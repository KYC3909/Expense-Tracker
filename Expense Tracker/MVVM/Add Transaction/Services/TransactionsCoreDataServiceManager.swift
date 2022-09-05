//
//  TransactionsListCoreDataServiceManager.swift
//  Expense Tracker
//
//  Created by Krunal on 31/8/22.
//

import Foundation
import CoreData

final class TransactionsCoreDataServiceManager {
    private let moc: NSManagedObjectContext!
    private let storageServiceWorker: TransactionsListCoreDataServiceWorker!
    
    init(_ moc: NSManagedObjectContext) {
        self.moc = moc
        self.storageServiceWorker = TransactionsListCoreDataServiceWorker(moc)
    }
    
    func addDataToLocalStorageAndReturn(_ object: Transaction) -> TransactionsListCellViewModel {
        return self.storageServiceWorker.addDataToLocalStorageAndReturn(object)
    }
    
    func deleteDataFromLocalStorage(_ object: Transaction) throws {
        do {
            try self.storageServiceWorker.deleteDataFromLocalStorage(object)
        } catch let error as NSError {
            throw error
        }
    }
    func clearAllRecords() { self.storageServiceWorker.clearAllRecords() }
    
    func fetchDataFromLocalStorage() throws -> (total: TransactionsTotalHeaderViewModel, transactions: [[TransactionsListCellViewModel]]) {
        do {
            return try self.storageServiceWorker.fetchDataFromLocalStorage()
        } catch let error as NSError {
            throw error
        }
    }
}
