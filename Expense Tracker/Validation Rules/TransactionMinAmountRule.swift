//
//  TransactionMinAmountRule.swift
//  Expense Tracker
//
//  Created by Krunal on 2/9/22.
//

import Foundation

final class TransactionMinAmountRule: RuleProtocol {
    private var message: String
    static let MIN_AMOUNT = 1
    
    init(_ message: String = "Please enter proper amount") {
        self.message = message
    }
    func performValidation(_ value: String) -> Bool {
        let intValue = Int(value) ?? 0
        return intValue >= TransactionMinAmountRule.MIN_AMOUNT
    }
    func errorMessage() -> String {
        return message
    }
}
