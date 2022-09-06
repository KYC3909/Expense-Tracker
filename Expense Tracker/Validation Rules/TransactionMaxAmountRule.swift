//
//  TransactionMaxAmountRule.swift
//  Expense Tracker
//
//  Created by Krunal on 2/9/22.
//

import Foundation

final class TransactionMaxAmountRule: RuleProtocol {
    private var message: String
    static let MAX_AMOUNT = 100_000_000
    
    init(_ message: String = "Please enter proper amount") {
        self.message = message
    }
    func performValidation(_ value: String) -> Bool {
        let intValue = Int(value) ?? 0
        return intValue > 0 && intValue < TransactionMaxAmountRule.MAX_AMOUNT
    }
    func errorMessage() -> String {
        return message
    }
}
