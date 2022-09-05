//
//  AddTransactionCoordinator.swift
//  Expense Tracker
//
//  Created by Krunal on 2/9/22.
//

import Foundation
import UIKit
import CoreData

final class AddTransactionCoordinator : ChildCoordinator {
    weak var parentCoordinator: ParentCoordinator?
    var navigationController: UINavigationController
    
    
    private(set) var managedObjectContext: NSManagedObjectContext!
    private(set) var coreDataManager: TransactionsCoreDataServiceManager!

    
    init(_ navigationController : UINavigationController){
        self.navigationController = navigationController
    }
    
    func configureChildViewController() {
        let addTransactionVC = AddTransactionsVC.instantiateFrom(.main)
        let viewModel = AddTransactionViewModel(addTransactionVC,
                                                managedObjectContext,
                                                coreDataManager,
                                                self)
        
        addTransactionVC.assignViewModel(viewModel)

        self.navigationController.present(addTransactionVC, animated: true)
    }
    
    func assignMocAndLocalStorageManager(_ moc: NSManagedObjectContext, _ coreDataManager: TransactionsCoreDataServiceManager) {
        self.managedObjectContext = moc
        self.coreDataManager = coreDataManager
    }
    
    func dismissController(with addedTransaction: Transaction) {
        guard let transactionsListCoordinator = parentCoordinator?.childCoordinator.first(where: { $0 is TransactionsListCoordinator }) as? TransactionsListCoordinator else {
            return
        }
        
        transactionsListCoordinator.configureAddedTransactionToTransactionsListVC(addedTransaction)
        parentCoordinator?.removeChildCoordinator(child: self)
        self.navigationController.dismiss(animated: true) { [weak self] in
            transactionsListCoordinator.assignParent()
        }
    }
    
    deinit {
        debugPrint("AddTransactionCoordinator")
    }
}
