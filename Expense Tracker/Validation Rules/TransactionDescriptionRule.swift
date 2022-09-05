//
//  TransactionDescriptionRule.swift
//  Expense Tracker
//
//  Created by Krunal on 2/9/22.
//

import Foundation

final class TransactionDescriptionRule: RuleProtocol {
    typealias ValueType = String
    private var message: String
    
    init(_ message: String = "Description field should not be blank") {
        self.message = message
    }
    func performValidation(_ value: String) -> Bool {
        return !value.isEmpty
    }
    func errorMessage() -> String {
        return message
    }
}
