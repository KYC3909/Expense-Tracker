//
//  TransactionType.swift
//  Expense Tracker
//
//  Created by Krunal on 31/8/22.
//

import Foundation
import CoreData

/// Transaction Type = `Expense` or `Income`
enum TransactionType: Int {
    case expense = 0, income
}

/// Supported CRUD Types = `Added` or `Deleted`
/// This is useful when `Transaction` will be `Added` or `Deleted`
enum Transaction_CRUD_Type: Int {
    case added, deleted
}
