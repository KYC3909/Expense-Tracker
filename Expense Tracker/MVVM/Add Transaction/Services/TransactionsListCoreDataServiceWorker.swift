//
//  TransactionsListCoreDataServiceWorker.swift
//  Expense Tracker
//
//  Created by Krunal on 31/8/22.
//

import Foundation
import CoreData

// Worker class manipulates the Transaction with Local Storage
final class TransactionsListCoreDataServiceWorker {
    // Object which will be Stored to Local Storage
    typealias StorageObject = Transaction
    // stored Object will be returned as ViewModel
    typealias ReturnedObject = TransactionsListCellViewModel
    // HeaderViewModel Object
    typealias TotalExpenseObject = TransactionsTotalHeaderViewModel

    // Core Data Managed Object Context
    private let moc: NSManagedObjectContext!
    
    // Dependency Injection
    init(_ moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
}

// MARK: - Local Data Storage Service Worker Protocol
extension TransactionsListCoreDataServiceWorker: LocalDataStorageServiceWorkerProtocol {
    
    // Add Transaction Object to Local Storage and
    /// Return the `TransactionsListCellViewModel`
    func addDataToLocalStorageAndReturn(_ object: Transaction) -> TransactionsListCellViewModel {
        try? saveToContext()
        return generateTransactionsListCellViewModel(object)
    }
    
    // Delete Transaction Object from Local Storage
    // Throw error if any
    func deleteDataFromLocalStorage(_ object: Transaction) throws {
        // Initialize Fetch Request
        let fetchRequest = Transaction.fetchRequest()

        // Configure Fetch Request for loading on `id == UUID` which are Identifiable only
        fetchRequest.includesPropertyValues = false

        do {
            // Fetch Transactions
            let items = try self.moc.fetch(fetchRequest)

            // Iterate over items
            for item in items {
                
                // if both ID are matched then remove from Local Storage and Save to Context
                if object.id == item.id {
                    self.moc.delete(item)
                    break
                }
            }

            // Save Changes
            try saveToContext()

        } catch let error as NSError {
            debugPrint("================================")
            debugPrint("Error in File: \(#file) at Line: \(#line)")
            debugPrint("Error while fetching Record: \(error.localizedDescription)")
            debugPrint("================================")
            throw error
        }
    }
    
    
    // Fetch All the records from the Local Storage and
    // Convert them into Array of Array [[ViewModel]]
    /// `[[TransactionsListCellViewModel]]`
    // Throw error if any
    // If there is no records return an Empty Array.
    func fetchDataFromLocalStorage() throws -> (total: TransactionsTotalHeaderViewModel, transactions: [[TransactionsListCellViewModel]]) {
        
        // Create an empty array
        var trasactionsArray = [[TransactionsListCellViewModel]]()
        
        do {
            // Initialize Fetch Request
            let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Transaction")
            
            // Apply filter for Expense
            // TransactionType.Expense = 0
            request.predicate = NSPredicate(format: "transactionType == 0")

            // add Expression type alise like SQL
            let sumDesc = NSExpressionDescription()
            sumDesc.name = "sum"
            
            // add Expression on Column name `amount`
            let keypathExp1 = NSExpression(forKeyPath: "amount")
            let expression = NSExpression(forFunction: "\(sumDesc.name):", arguments: [keypathExp1])
            sumDesc.expression = expression
            sumDesc.expressionResultType = .integer64AttributeType

            // Results as Dictionary object
            request.returnsObjectsAsFaults = false
            request.propertiesToFetch = [sumDesc]
            request.resultType = .dictionaryResultType
                
            ///`TransactionsTotalHeaderViewModel`
            let headerViewModel = TransactionsTotalHeaderViewModel()

            // Fetch `Expenses` and Store it to the Header View Model
            var transactions = try moc.fetch(request) as? [[String: Any]]
            headerViewModel.expense = transactions?.first?["sum"] as? Int64 ?? 0
            
            // Fetch `Income` and Store it to the Header View Model
            request.predicate = NSPredicate(format: "transactionType == 1")
            transactions = try moc.fetch(request) as? [[String: Any]]
            headerViewModel.income = transactions?.first?["sum"] as? Int64 ?? 0
            
            
            // Initialize Fetch Request
            let fetchRequest = Transaction.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "date", ascending: false)]
            
            // Fetch Transactions
            let fetchedTransactions = try self.moc.fetch(fetchRequest)
            
            
            // Check the Transactions Count
            if fetchedTransactions.count > 0 {
                // Apply grouping by DateString based on Locale.
                // E.g. Sep 2, 2022 (as per my current Locale)
                let dicGroupedByDate = Dictionary(grouping: fetchedTransactions, by: { $0.date!.dateString(for: .medium) })
                
                // Apply sorting in Descending order
                let sortedDates = dicGroupedByDate.keys.sorted(by: >)
                
                // Iterate through each records and create an Array of Array[[ViewModel]]
                /// `[[TransactionsListCellViewModel]]`
                for dateString in sortedDates {
                    
                    if let transactions = dicGroupedByDate[dateString], transactions.count > 0 {
                        
                        // Create local array and store value to them
                        var array = [TransactionsListCellViewModel]()
                        
                        // [0] => DateString E.g. Sep 2, 2022
                        // [0] => it is still an object of TransactionsListCellViewModel
                        array.append(TransactionsListCellViewModel(dateString))
                        
                        // [1] => object of TransactionsListCellViewModel
                        // [1] => Use higher order function Map to iterate through each object and convert them to TransactionsListCellViewModel
                        array.append(contentsOf: transactions.map( { TransactionsListCellViewModel($0) } ))
                        
                        // Add to a `trasactionsArray`
                        trasactionsArray.append(array)
                    }
                }
            } else {
//                trasactionsArray.append([TransactionsListCellViewModel(Date().dateString(for: .medium))])
            }
            
            // Return `TransactionsTotalHeaderViewModel`, [[`TransactionsListCellViewModel`]]
            return (headerViewModel, trasactionsArray)

        } catch let error as NSError {
            // Throw error if any
            debugPrint("================================")
            debugPrint("Error in File: \(#file) at Line: \(#line)")
            debugPrint("Error while fetching Record: \(error.localizedDescription)")
            debugPrint("================================")
            
            throw error
        }
    }
}
// MARK: - Clear All Records
extension TransactionsListCoreDataServiceWorker {
    // Clear all records from Local Storage
    func clearAllRecords() {
        // Initialize Fetch Request
        let fetchRequest = Transaction.fetchRequest()

        // Configure Fetch Request
        fetchRequest.includesPropertyValues = false

        do {
            // Fetch Transactions
            let items = try self.moc.fetch(fetchRequest)

            // Iterate over items and delete all of them
            for item in items {
                self.moc.delete(item)
            }

            // Save Changes
            try saveToContext()

        } catch let error as NSError {
            
            // Catch Error if any
            debugPrint("================================")
            debugPrint("Error in File: \(#file) at Line: \(#line)")
            debugPrint("Error while fetching Record: \(error.localizedDescription)")
            debugPrint("================================")
        }

    }
}

//MARK: - Private Helper methods
extension TransactionsListCoreDataServiceWorker {
    
    // Create instance of `TransactionsListCellViewModel`
    private func generateTransactionsListCellViewModel(_ object: Transaction) -> TransactionsListCellViewModel {
        return TransactionsListCellViewModel(object)
    }
    
    // Save Records to Contect
    private func saveToContext() throws {
        do {
            
            // MOC tries to Save if failed then catch will be called.
            try self.moc.save()
            
        } catch let error as NSError {
            
            // Catch Error if any
            debugPrint("================================")
            debugPrint("Error in File: \(#file) at Line: \(#line)")
            debugPrint("Error while saving Record: \(error.localizedDescription)")
            debugPrint("================================")
            throw error
        }
    }
}

