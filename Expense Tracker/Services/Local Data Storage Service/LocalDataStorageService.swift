//
//  LocalDataStorageService.swift
//  Expense Tracker
//
//  Created by Krunal on 31/8/22.
//

import Foundation

protocol LocalDataStorageServiceWorkerProtocol: AnyObject {
    associatedtype StorageObject        // Object which will be Stored to Local Storage
    associatedtype ReturnedObject       // stored Object will be returned as ViewModel
    associatedtype TotalExpenseObject   // HeaderViewModel Object
    
    // Add Transaction Object to Local Storage and
    /// Return the `TransactionsListCellViewModel`
    func addDataToLocalStorageAndReturn(_ object: StorageObject) -> ReturnedObject
    
    // Delete Transaction Object from Local Storage
    // Throw error if any
    func deleteDataFromLocalStorage(_ object: Transaction) throws
    
    // Fetch All the records from the Local Storage and
    // Convert them into Array of Array [[ViewModel]]
    /// `[[TransactionsListCellViewModel]]`
    // Throw error if any
    // If there is no records return an Empty Array.
    func fetchDataFromLocalStorage() throws -> (total: TotalExpenseObject, transactions: [[ReturnedObject]])
}
