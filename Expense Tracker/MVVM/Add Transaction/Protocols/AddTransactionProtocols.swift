//
//  AddTransactionProtocols.swift
//  Expense Tracker
//
//  Created by Krunal on 2/9/22.
//

import Foundation


protocol AddTransactionViewProtocol: AnyObject {
    func transactionAddedSuccessful()
    func transactionErrorDesc(_ errorDesc: String) 
    func transactionAmountUpdated(to value: Int)
}

protocol AddTransactionViewModelProtocol: AnyObject {
    func increaseAmount(_ value: String)
    func decreaseAmount(_ value: String)
    func addSelected(_ type: Int,
                     _ desc: String,
                     _ amount: Int)
}





