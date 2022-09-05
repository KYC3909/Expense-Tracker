//
//  TransactionsListViewModel.swift
//  Expense Tracker
//
//  Created by Krunal on 31/8/22.
//

import Foundation
import CoreData

final class TransactionsListViewModel {
    // Private Properties
    private weak var view: TransactionsListViewProtocol?
    private let transactionsListChildCoordinator : TransactionsListCoordinator?

    private let persistanceStoreContainer: NSPersistentContainer
    private let managedObjectContext: NSManagedObjectContext!
    private let coreDataServiceManager: TransactionsCoreDataServiceManager!

    // Protocol Properties
    var transactionsListItemViewModels = [[TransactionsListCellViewModel]]()
    private(set) var transactionsTotalViewModel: TransactionsTotalHeaderViewModelProtocol?

    // D.I.
    init(_ view: TransactionsListViewProtocol,
         _ persistanceStoreContainer: NSPersistentContainer,
         _ managedObjectContext: NSManagedObjectContext,
         _ coreDataServiceManager: TransactionsCoreDataServiceManager,
         _ transactionsListChildCoordinator: TransactionsListCoordinator) {
        
        self.view = view
        self.persistanceStoreContainer = persistanceStoreContainer
        self.managedObjectContext = managedObjectContext
        self.coreDataServiceManager = coreDataServiceManager
        self.transactionsListChildCoordinator = transactionsListChildCoordinator

        self.persistanceStoreContainer.loadPersistentStores { [weak self] descriptions, error in
            debugPrint("Load Persistent Stores Description:\(descriptions)\n\nError: \(error?.localizedDescription ?? "")")
        }
        
    }
}

// MARK: - Transactions List ViewModel Protocol
extension TransactionsListViewModel: TransactionsListViewModelProtocol {
    // Load list from Local Data Storage
    func fetchTransactionsList() {
        do {
            let transactionsMetadata = try self.coreDataServiceManager.fetchDataFromLocalStorage()
            self.transactionsListItemViewModels = transactionsMetadata.transactions
            self.transactionsTotalViewModel = transactionsMetadata.total
            self.view?.transacationsListFetchedSuccessful()

        } catch let error as NSError {
            self.view?.transacationsListFetchedFailed(with: error.localizedDescription)
        }
    }
    
    // Open Add Transaction Screen
    func addTransactionSelected() {
//        coreDataServiceManager.clearAllRecords()
//        return
        self.transactionsListChildCoordinator?.configureAddTransactionViewContoller()
    }
    
    // Newly created Transaction from the Add Transaction Screen
    func newTransactionAddedToLocalDatabase(_ transaction: Transaction) {
        
        // update Income/Expense to the HeaderViewModel
        addTransactionFromHeaderViewViewModel(transaction)
        
        // Convert to CellViewModel
        let cellViewModel = self.coreDataServiceManager.addDataToLocalStorageAndReturn(transaction)

        // Check for Current and Past Latest Date
        var array = transactionsListItemViewModels.first ?? []
        if array.count == 0 {
            // Add CellViewModel at the First Index for Today's Date
            addTransactionWithSection(for: cellViewModel, sectionIndex: 0)
            
        }
//        else if array.count == 1 {
//            // Add CellViewModel at the Second Index for Today's Date
//            array.insert(cellViewModel, at: 1)
//            transactionsListItemViewModels[0] = array
//
//            // Reload Table based on CRUD Type: Added
//            self.transacationAddedOrDeletedFor(row: 1, section: 0, type: .added)
//
//        }
        else {
            let cellVM = array[1]
            
            if cellVM.transactionDateString != cellViewModel.transactionDateString {
                addTransactionWithSection(for: cellViewModel, sectionIndex: 0)
                
            } else {
                array.insert(cellViewModel, at: 1)
                transactionsListItemViewModels[0] = array
                
                // Reload Table based on CRUD Type: Added
                self.transacationAddedOrDeletedFor(row: 1, section: 0, type: .added)
            }
        }

    }
}

// MARK: - Private Helper methods
extension TransactionsListViewModel {
    
    // Reload Table based on CRUD Type: Added / Deleted
    private func transacationAddedOrDeletedFor(row: Int, section: Int, type: Transaction_CRUD_Type) {
        let indexPath = IndexPath(row: row, section: section)
        self.view?.transacationAdditionDeletionSuccessful([indexPath], type)
    }
    
    // Reload Table
    private func reloadTable() {
        self.view?.transacationsListFetchedSuccessful()
    }
    
    // Add CellViewModel to the Array
    private func addTransactionWithSection(for cellViewModel: TransactionsListCellViewModel, sectionIndex: Int){
        
        
        var array = [TransactionsListCellViewModel]()
        
        // [0] => DateString E.g. Sep 2, 2022
        // [0] => it is still an object of TransactionsListCellViewModel
        array.append(TransactionsListCellViewModel(cellViewModel.transactionDateString))
        
        // [1] => object of TransactionsListCellViewModel
        array.append(contentsOf: [cellViewModel])
        
        if transactionsListItemViewModels.count == 0 {
            transactionsListItemViewModels.append(array)
        }else {
            transactionsListItemViewModels.insert(array, at: sectionIndex)
        }
        
        let indexPathZero = IndexPath(row: 0, section: sectionIndex)
        let indexPathFirst = IndexPath(row: 1, section: sectionIndex)
        self.view?.transacationAdditionDeletionSuccessful([indexPathZero, indexPathFirst], .added)
    }
    
    // Delete Object from Local Data Storage
    private func deleteTransactionFromLocalDataStorage(_ indexPath: IndexPath) -> Bool {
        let cellViewModel = viewModelFor(indexPath)
        let transaction = cellViewModel.createTransactionRecord(for: self.managedObjectContext)
        
        do {
            deleteTransactionFromHeaderViewViewModel(transaction)
            try self.coreDataServiceManager.deleteDataFromLocalStorage(transaction)
            return true
        } catch {
            return false
        }
    }
}
// MARK: - Table View Related methods
extension TransactionsListViewModel {
    func numberOfSections() -> Int {
        return transactionsListItemViewModels.count
    }

    func numberOfRows(for section: Int) -> Int {
        return transactionsListItemViewModels[section].count
    }
    
    func viewModelFor(_ indexPath: IndexPath) -> TransactionsListCellViewModel {
        return transactionsListItemViewModels[indexPath.section][indexPath.row]
    }
    
    func canDeleteRow(_ indexPath: IndexPath) -> Bool {
        let cellViewModel = viewModelFor(indexPath)
        return cellViewModel.editable
    }
    
    func deleteItemFor(_ indexPath: IndexPath) {
        if numberOfRows(for: indexPath.section) <= 2 {
            // Create IndexPaths for First and Second index
            let indexPathZero = IndexPath(row: 0, section: indexPath.section)
            let indexPathFirst = IndexPath(row: indexPath.row, section: indexPath.section)
            
            // Delete Transaction From Local Data Storage
            if deleteTransactionFromLocalDataStorage(indexPathFirst) {
                
                // Delete Record if deleted from Local Data Storage
                transactionsListItemViewModels.remove(at: indexPath.section)
                
                // Reload Table based on CRUD Type: Added / Deleted
                self.view?.transacationAdditionDeletionSuccessful([indexPathZero,indexPathFirst], .deleted)
            } else {
                
                // Reload Table if not deleted
                self.reloadTable()
            }

        }else {
            // Delete Transaction From Local Data Storage
            if deleteTransactionFromLocalDataStorage(indexPath) {
                
                // Delete Record if deleted from Local Data Storage
                transactionsListItemViewModels[indexPath.section].remove(at: indexPath.row)
                
                // Reload Table based on CRUD Type: Added / Deleted
                self.transacationAddedOrDeletedFor(row: indexPath.row, section: indexPath.section, type: .deleted)
            } else {
                
                // Reload Table if not deleted
                self.reloadTable()
            }
        }
    }
        
}

// MARK: - Header View Related methods

extension TransactionsListViewModel {
    // Add Transaction Amount to HeaderViewViewModel
    private func addTransactionFromHeaderViewViewModel(_ transaction: Transaction) {
        let amount = transaction.amount
        let headerViewModel = TransactionsTotalHeaderViewModel()

        // Check Transaction Type
        // Add Amount
        if transaction.transactionType == TransactionType.expense.rawValue {
            headerViewModel.expense = (transactionsTotalViewModel?.totalExpense ?? 0) + amount
            headerViewModel.income = (transactionsTotalViewModel?.totalIncome ?? 0)
        } else {
            headerViewModel.expense = (transactionsTotalViewModel?.totalExpense ?? 0)
            headerViewModel.income = (transactionsTotalViewModel?.totalIncome ?? 0) + amount
        }
        
        // Update HeaderViewModel
        self.transactionsTotalViewModel = headerViewModel
    }
    
    // Delete Transaction Amount to HeaderViewViewModel
    private func deleteTransactionFromHeaderViewViewModel(_ transaction: Transaction) {
        let amount = transaction.amount
        let headerViewModel = TransactionsTotalHeaderViewModel()

        // Check Transaction Type
        // Deduct Amount
        if transaction.transactionType == TransactionType.expense.rawValue {
            headerViewModel.expense = (transactionsTotalViewModel?.totalExpense ?? 0) - amount
            headerViewModel.income = (transactionsTotalViewModel?.totalIncome ?? 0)
        } else {
            headerViewModel.expense = (transactionsTotalViewModel?.totalExpense ?? 0)
            headerViewModel.income = (transactionsTotalViewModel?.totalIncome ?? 0) - amount
        }
        
        // Update HeaderViewModel
        self.transactionsTotalViewModel = headerViewModel
    }
}
