//
//  RuleProtocol.swift
//  Expense Tracker
//
//  Created by Krunal on 2/9/22.
//

import Foundation

protocol RuleProtocol: ValidationBaseProtocol {
    func errorMessage() -> String
    func performValidation(_ value: String) -> Bool
}

