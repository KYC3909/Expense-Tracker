//
//  TransactionsListCellItemViewModel.swift
//  Expense Tracker
//
//  Created by Krunal on 31/8/22.
//

import Foundation
import CoreData

final class TransactionsListCellViewModel {
    // View Related Properties
    var editable: Bool! // Editable means record can be Deletable
    var selected: Bool! // Selected 
    
    // Transaction Properties
    private let id : UUID?
    private let transactionType: TransactionType?
    private let desc: String!
    private let date: Date?
    private let amount: Int64?
    
    // D.I. when convert to `TransactionsListCellViewModel`
    // For [0] First Index
    init(_ desc: String) {
        self.desc = desc
        self.editable = false
        self.selected = false
        
        self.id = nil
        self.date = nil
        self.amount = nil
        self.transactionType = Optional.none
    }
    
    // D.I. when convert to `TransactionsListCellViewModel`
    // For [1] Second Index
    init(_ transaction: Transaction) {
        self.id = transaction.id
        self.transactionType = TransactionType(rawValue: Int(transaction.transactionType))
        self.desc = transaction.desc
        self.date = transaction.date
        self.amount = transaction.amount
        self.editable = true
        self.selected = false
    }
    
    // Convert Back to Transaction Object
    func createTransactionRecord(for moc: NSManagedObjectContext) -> Transaction{
        let transaction = Transaction(context: moc)
                
        transaction.id = id
        transaction.desc = desc
        transaction.date = date
        transaction.transactionType = Int64(transactionType?.rawValue ?? 0)
        transaction.amount = amount ?? 0
        
        return transaction
    }
}

// MARK: - Transactions List Cell ViewModel
extension TransactionsListCellViewModel {
    var transactionTitle: String {
        return desc
    }
    
    var transactionAmount: String {
        return editable ? transactionType == .income ? "$ \(amount ?? 0)" : "- $ \(amount ?? 0)" : ""
    }
    
    var transactionDateString: String {
        return date?.dateString(for: .medium) ?? ""
    }
}
