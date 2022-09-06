//
//  AddTransactionViewModel.swift
//  Expense Tracker
//
//  Created by Krunal on 2/9/22.
//

import Foundation
import CoreData

final class AddTransactionViewModel {
    weak var view: AddTransactionViewProtocol?
    private let addTransactionChildCoordinator : AddTransactionCoordinator?

    private let managedObjectContext: NSManagedObjectContext!
    private let coreDataServiceManager: TransactionsCoreDataServiceManager!

    init(_ view: AddTransactionViewProtocol,
         _ managedObjectContext: NSManagedObjectContext,
         _ coreDataServiceManager: TransactionsCoreDataServiceManager,
         _ addTransactionChildCoordinator: AddTransactionCoordinator) {
        
        self.view = view
        self.managedObjectContext = managedObjectContext
        self.coreDataServiceManager = coreDataServiceManager
        self.addTransactionChildCoordinator = addTransactionChildCoordinator
    }
}

// MARK: - AddTransactionViewModelProtocol
extension AddTransactionViewModel: AddTransactionViewModelProtocol {
    func increaseAmount(_ value: String) {
        let amount = Int(value) ?? 0
        let maxAmountRuleValidator = TransactionMaxAmountRule()
        if maxAmountRuleValidator.performValidation((amount + 1).description) {
            self.view?.transactionAmountUpdated(to: amount + 1)
        }else {
            self.view?.transactionErrorDesc(maxAmountRuleValidator.errorMessage())
        }
    }
    func decreaseAmount(_ value: String) {
        let amount = Int(value) ?? 1
        let minAmountRuleValidator = TransactionMinAmountRule()
        if minAmountRuleValidator.performValidation((amount - 1).description) {
            self.view?.transactionAmountUpdated(to: amount - 1)
        }else {
            self.view?.transactionErrorDesc(minAmountRuleValidator.errorMessage())
        }
    }
    
    func addSelected(_ type: Int,
                     _ desc: String,
                     _ amount: Int) {
        
        guard type != -1 else {
            self.view?.transactionErrorDesc("Please select Transaction Type")
            return
        }
        
        let transactionDescRuleValidator = TransactionDescriptionRule()
        guard transactionDescRuleValidator.performValidation(desc) else {
            self.view?.transactionErrorDesc(transactionDescRuleValidator.errorMessage())
            return
        }
        
        let transactionAmountRuleValidator = TransactionMinAmountRule()
        guard transactionAmountRuleValidator.performValidation(amount.description) else {
            self.view?.transactionErrorDesc(transactionAmountRuleValidator.errorMessage())
            return
        }
        

        let transaction = Transaction(context: self.managedObjectContext)
        
        let date = Date()
        
        transaction.id = UUID()
        transaction.desc = desc
        transaction.date = date
        transaction.transactionType = Int64(type)
        transaction.amount = Int64(amount)
        
        self.view?.transactionAddedSuccessful()
        self.addTransactionChildCoordinator?.dismissController(with: transaction)
    }
    func dismissSelected(isDismissing: Bool) {
        self.addTransactionChildCoordinator?.dismissController(with: nil, isDismissing: isDismissing)
    }
}
