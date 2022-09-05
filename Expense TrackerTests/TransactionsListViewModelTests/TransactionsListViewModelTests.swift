//
//  TransactionsListViewModelTests.swift
//  Expense TrackerTests
//
//  Created by Krunal on 4/9/22.
//

import XCTest
import CoreData
@testable import Expense_Tracker

private final class MockViewController: TransactionsListViewProtocol {
    func transacationAdditionDeletionSuccessful(_ indexPaths: [IndexPath], _ type: Transaction_CRUD_Type) { }
    func transacationsListFetchedSuccessful() { }
    func transacationsListFetchedFailed(with error: String) { }
}
final class TransactionsListViewModelTests: XCTestCase {
    private var managedObjectContext:NSManagedObjectContext!
    private var coreDataManager:TransactionsCoreDataServiceManager!
    private var sutViewModel:TransactionsListViewModel!


    override func setUpWithError() throws {
        let loadPersistanceStoreContainer = PersistanceStoreContainerFactory.create(with: .transactions)
        loadPersistanceStoreContainer.loadPersistentStores { [weak self] desc, err in }
        managedObjectContext = loadPersistanceStoreContainer.viewContext
        coreDataManager = TransactionsCoreDataServiceManager(managedObjectContext)
        coreDataManager.clearAllRecords()
        
        let transactionsListVC = TransactionsListVC.instantiateFrom(.main)
        let viewModel = TransactionsListViewModel(transactionsListVC,
                                                  loadPersistanceStoreContainer,
                                                  managedObjectContext,
                                                  coreDataManager,
                                                  TransactionsListCoordinator(UINavigationController()))
        transactionsListVC.assignViewModel(viewModel)
        sutViewModel = viewModel
    }

    override func tearDownWithError() throws {
        coreDataManager.clearAllRecords()
        sutViewModel = nil
        managedObjectContext = nil
        coreDataManager = nil
    }
    
    // MARK: - Expense Transactions
    @discardableResult
    func addTransaction1(_ todayDate: Bool = true, _ type: TransactionType = .expense) -> Transaction{
        let transaction1 = Transaction(context: self.managedObjectContext)
        
        transaction1.id = UUID()
        transaction1.desc = "Test1"
        transaction1.date = todayDate ? Date() : Date().addingTimeInterval(-5*24*60*60)
        transaction1.transactionType = Int64(type.rawValue)
        transaction1.amount = 10
        try? self.managedObjectContext.save()
        return transaction1
    }
    
    @discardableResult
    func addTransaction2(_ todayDate: Bool = true, _ type: TransactionType = .expense) -> Transaction{
        let transaction2 = Transaction(context: self.managedObjectContext)
        transaction2.id = UUID()
        transaction2.desc = "Test2"
        transaction2.date = todayDate ? Date() : Date().addingTimeInterval(-3*24*60*60)
        transaction2.transactionType = Int64(type.rawValue)
        transaction2.amount = 5
        try? self.managedObjectContext.save()
        return transaction2
    }
    
    @discardableResult
    func addTransaction3(_ todayDate: Bool = true, _ type: TransactionType = .expense) -> Transaction{
        let transaction3 = Transaction(context: self.managedObjectContext)
        transaction3.id = UUID()
        transaction3.desc = "Test3"
        transaction3.date = todayDate ? Date() : Date().addingTimeInterval(-1*24*60*60)
        transaction3.transactionType = Int64(type.rawValue)
        transaction3.amount = 21
        try? self.managedObjectContext.save()
        return transaction3
    }
    
    
    // MARK: - Testing Add Transactions
    func testViewModel_WhenAddThreeSameDatesTransactionToDatabase_ShouldBeOneArrayObject() throws {
        // Today's Dates
        addTransaction1(); addTransaction2(); addTransaction3()
        sutViewModel.fetchTransactionsList()
        
        XCTAssertEqual(sutViewModel.transactionsListItemViewModels.count, 1, "Only 1 count should be available as it is today's date.")
        XCTAssertEqual(sutViewModel.transactionsTotalViewModel?.totalExpense, 36, "Total expenses should be `36`")
        XCTAssertEqual(sutViewModel.transactionsTotalViewModel?.totalIncome, 0, "Total expenses should be `0`")
    }

    func testViewModel_WhenAddThreeDifferentDatesTransactionToDatabase_ShouldBeThreeArrayObjects() throws {
        // Past Dates
        addTransaction1(false); addTransaction2(false); addTransaction3(false)
        sutViewModel.fetchTransactionsList()
        
        XCTAssertEqual(sutViewModel.transactionsListItemViewModels.count, 3, "Only 3 count should be available as there are different dates.")
    }
    
    func testViewModel_WhenAddNewTransaction_ShouldBeOneArrayObject() throws {
        // Today's Date
        let transaction1 = addTransaction1()
        sutViewModel.newTransactionAddedToLocalDatabase(transaction1)
        
        XCTAssertEqual(sutViewModel.transactionsListItemViewModels.count, 1, "Only 1 count should be available as it is today's date.")
    }
    
    func testViewModel_WhenAddNewTransaction_ShouldBeOneArrayObjectWithTwoObjects() throws {
        // Today's Date
        let transaction1 = addTransaction1()
        sutViewModel.newTransactionAddedToLocalDatabase(transaction1)
        
        // First index contains at least 2 object
        // [0] => DateString E.g. Sep 2, 2022
        // [1] => CellViewModel
        XCTAssertEqual(sutViewModel.transactionsListItemViewModels.first?.count, 2, "Only 2 count should be available as it is today's date.")
    }
    
    
    func testViewModel_WhenAddNewTransactionForSameDate_ShouldBeOneArrayObjectWithThreeObjects() throws {
        // Today's Date
        let transaction1 = addTransaction1()
        sutViewModel.newTransactionAddedToLocalDatabase(transaction1)
        
        // Today's Date
        let transaction2 = addTransaction1()
        sutViewModel.newTransactionAddedToLocalDatabase(transaction2)
        

        // First index contains at least 2 object
        // [0] => DateString E.g. Sep 2, 2022
        // [1] => CellViewModel
        XCTAssertEqual(sutViewModel.transactionsListItemViewModels.first?.count, 3, "Only 3 count should be available as it is today's date only.")
    }
    
    func testViewModel_WhenAddNewTransactionForAnotherDate_ShouldBeTwoArrayObjectsWithTwoObjectsEach() throws {
        // Today's Date
        let transaction1 = addTransaction1()
        sutViewModel.newTransactionAddedToLocalDatabase(transaction1)
        
        // Past Date
        let transaction2 = addTransaction1(false, .income)
        sutViewModel.newTransactionAddedToLocalDatabase(transaction2)
        

        // First index contains at least 2 object
        // [0] => DateString E.g. Sep 2, 2022
        // [1] => CellViewModel
        XCTAssertEqual(sutViewModel.transactionsListItemViewModels.count, 2, "Only 2 count should be available as it is today's and previous dates.")
    }
    
    
    func testViewModel_WhenAddNewTransactionForAnotherDateForIncome_ShouldBeTwoArrayObjectsWithTwoObjectsEach() throws {
        // Today's Date
        let transaction1 = addTransaction1()
        sutViewModel.newTransactionAddedToLocalDatabase(transaction1)
        
        // Past Date
        let transaction2 = addTransaction1(false, .income)
        sutViewModel.newTransactionAddedToLocalDatabase(transaction2)
        

        // First index contains at least 2 object
        // [0] => DateString E.g. Sep 2, 2022
        // [1] => CellViewModel
        XCTAssertEqual(sutViewModel.transactionsListItemViewModels.count, 2, "Only 2 count should be available as it is today's and previous dates.")
    }

    // MARK: - Testing Delete Transactions
    func testViewModel_WhenDeleteTransactionFromDatabase_ShouldBeOneArrayObject() throws {
        // Today's Dates
        addTransaction1(); addTransaction2(); addTransaction3()
        sutViewModel.fetchTransactionsList()
        
        let indexPath = IndexPath(row: 1, section: 0)
        sutViewModel.deleteItemFor(indexPath)
        
        XCTAssertEqual(sutViewModel.transactionsListItemViewModels.count, 1, "Only 1 count should be available as it is today's date.")
        XCTAssertEqual(sutViewModel.transactionsListItemViewModels.first?.count, 3, "Only 3 count should be available as it is today's date and we have deleted one record from the array.")

    }

    func testViewModel_WhenDeleteTransactionForSameDateFromDatabase_ShouldBeOneArrayObject() throws {
        // Today's Dates
        addTransaction1(); addTransaction2(true, .income); addTransaction3()
        sutViewModel.fetchTransactionsList()
        
        let indexPath = IndexPath(row: 1, section: 0)
        sutViewModel.deleteItemFor(indexPath)
        
        XCTAssertEqual(sutViewModel.transactionsListItemViewModels.count, 1, "Only 1 count should be available as it is today's date.")
        XCTAssertEqual(sutViewModel.transactionsListItemViewModels.first?.count, 3, "Only 3 count should be available as it is today's date and we have deleted one record from the array.")

    }


    func testViewModel_WhenDeleteMultipleTransactionsForSameDatesFromDatabase_ShouldBeOneArrayObject() throws {
        // Today's Dates
        addTransaction1(); addTransaction2(true, .income); addTransaction3()
        sutViewModel.fetchTransactionsList()
        
        let indexPath = IndexPath(row: 1, section: 0)
        sutViewModel.deleteItemFor(indexPath)
        sutViewModel.deleteItemFor(indexPath)
        sutViewModel.deleteItemFor(indexPath)


        XCTAssertEqual(sutViewModel.transactionsListItemViewModels.count, 0, "All the Records should be deleted")

    }
    
    
    func testViewModel_WhenDeleteTransactionForDifferentDatesFromDatabase_ShouldBeOneArrayObject() throws {
        // Today's Dates
        addTransaction1(); addTransaction2(false, .income); addTransaction3(false)
        sutViewModel.fetchTransactionsList()
        
        let indexPath = IndexPath(row: 1, section: 0)
        sutViewModel.deleteItemFor(indexPath)

        XCTAssertEqual(sutViewModel.transactionsListItemViewModels.count, 2, "Array should contain 2 records as Today's date has been deleted.")

    }
    
    
    func testViewModel_WhenTryToDeleteNotDeletableTransactionsForDifferentDatesFromDatabase_ShouldReturnFalse() throws {
        // Today's Dates
        addTransaction1(); addTransaction2(false, .income); addTransaction3(false)
        sutViewModel.fetchTransactionsList()
        
        var indexPath = IndexPath(row: 0, section: 0)
        var output = sutViewModel.canDeleteRow(indexPath)

        XCTAssertFalse(output, "First object of any table section cannot be deleted.")

        indexPath = IndexPath(row: 0, section: 1)
        output = sutViewModel.canDeleteRow(indexPath)
        
        XCTAssertFalse(output, "First object of any table section cannot be deleted.")

        indexPath = IndexPath(row: 0, section: 2)
        output = sutViewModel.canDeleteRow(indexPath)
        
        XCTAssertFalse(output, "First object of any table section cannot be deleted.")

    }
    
    // MARK: - Testing Expenses / Income / Balance Transactions
    func testViewModel_WhenAddThreeSameDatesTransactionForHeaderView_ShouldBeOneArrayObject() throws {
        // Today's Dates
        addTransaction1(); addTransaction2(); addTransaction3()
        sutViewModel.fetchTransactionsList()
        
        XCTAssertEqual(sutViewModel.transactionsTotalViewModel?.totalExpense, 36, "Total expenses should be `36`")
        XCTAssertEqual(sutViewModel.transactionsTotalViewModel?.totalIncome, 0, "Total expenses should be `0`")
        XCTAssertEqual(sutViewModel.transactionsTotalViewModel?.totalExpenseString, "$ 36", "Total expenses should be `$ 36`")
        XCTAssertEqual(sutViewModel.transactionsTotalViewModel?.totalIncomeString, "$ 0", "Total expenses should be `$ 0`")
        XCTAssertEqual(sutViewModel.transactionsTotalViewModel?.totalBalanceString, "- $ 36", "Total expenses should be `- $ 36`")
        XCTAssertEqual(sutViewModel.transactionsTotalViewModel?.totalProgress, 0, "Total expenses should be `0%`")
    }

    func testViewModel_WhenAddThreeDifferentDatesTransactionForHeaderView_ShouldBeThreeArrayObjects() throws {
        // Past Dates
        addTransaction1(false); addTransaction2(false, .income); addTransaction3(false)
        sutViewModel.fetchTransactionsList()
        
        XCTAssertEqual(sutViewModel.transactionsTotalViewModel?.totalExpense, 31, "Total expenses should be `31`")
        XCTAssertEqual(sutViewModel.transactionsTotalViewModel?.totalIncome, 5, "Total expenses should be `5`")
        XCTAssertEqual(sutViewModel.transactionsTotalViewModel?.totalExpenseString, "$ 31", "Total expenses should be `$ 31`")
        XCTAssertEqual(sutViewModel.transactionsTotalViewModel?.totalIncomeString, "$ 5", "Total expenses should be `$ 5`")
        XCTAssertEqual(sutViewModel.transactionsTotalViewModel?.totalBalanceString, "- $ 26", "Total expenses should be `- $ 26`")
        XCTAssertEqual(Double(sutViewModel.transactionsTotalViewModel?.totalProgress ?? 0), 0.161, accuracy: 0.001, "Total expenses should be `0.161%`")
    }
}
