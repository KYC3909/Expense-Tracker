//
//  TransactionsListProtocols.swift
//  Expense Tracker
//
//  Created by Krunal on 31/8/22.
//

import Foundation

protocol TransactionsListViewProtocol: AnyObject{
    func transacationAdditionDeletionSuccessful(_ indexPaths: [IndexPath], _ type: Transaction_CRUD_Type)
    func transacationsListFetchedSuccessful()
    func transacationsListFetchedFailed(with error: String)
}

protocol TransactionsListViewModelProtocol: AnyObject {
    var transactionsListItemViewModels: [[TransactionsListCellViewModel]] { get set }
    var transactionsTotalViewModel: TransactionsTotalHeaderViewModelProtocol? { get }

    func fetchTransactionsList()
    func addTransactionSelected()
    func newTransactionAddedToLocalDatabase(_ transaction: Transaction)
    
    func numberOfSections() -> Int
    func numberOfRows(for section: Int) -> Int
    func viewModelFor(_ indexPath: IndexPath) -> TransactionsListCellViewModel
    func canDeleteRow(_ indexPath: IndexPath) -> Bool
    func deleteItemFor(_ indexPath: IndexPath)
}

protocol TransactionsTotalHeaderViewModelProtocol: AnyObject {
    var totalExpense : Int64 { get }
    var totalIncome : Int64 { get }
    var totalExpenseString : String { get }
    var totalIncomeString : String { get }
    var totalBalanceString : String { get }
    var totalProgress : Float { get }
}
