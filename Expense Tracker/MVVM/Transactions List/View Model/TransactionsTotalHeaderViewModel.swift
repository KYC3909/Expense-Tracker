//
//  TransactionsTotalViewModel.swift
//  Expense Tracker
//
//  Created by Krunal on 1/9/22.
//

import Foundation

// TransactionsTotalHeaderViewModel
final class TransactionsTotalHeaderViewModel {
    var expense: Int64 = 0
    var income: Int64 = 0
}

// MARK: - Transactions Total Header ViewModel Protocol
extension TransactionsTotalHeaderViewModel: TransactionsTotalHeaderViewModelProtocol {
    var totalExpense: Int64 {
        return expense
    }
    
    var totalIncome: Int64 {
        return income
    }
    
    var totalExpenseString : String {
        return "$ \(expense)"
    }
    
    var totalIncomeString : String {
        return "$ \(income)"
    }
    
    var totalBalanceString: String {
        let totalBalance = income - expense
        return "\((totalBalance < 0) ? "- " : "")$ \(abs(totalBalance))"
    }
        
    var totalProgress : Float {
        let min = min(income, abs(expense))
        let max = max(income, abs(expense))

        if max == 0 { return 0 }
        
        let percentage = Float(min) / Float(max)
        return Float(round(1000*percentage)/1000)
    }
}
