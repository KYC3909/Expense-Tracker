//
//  TransactionsListCoordinator.swift
//  Expense Tracker
//
//  Created by Krunal on 30/8/22.
//

import Foundation
import UIKit
import CoreData

final class TransactionsListCoordinator : ChildCoordinator  {
    weak var parentCoordinator: ParentCoordinator?
    var navigationController: UINavigationController
    
    private(set) var managedObjectContext: NSManagedObjectContext!
    private(set) var coreDataManager: TransactionsCoreDataServiceManager!

    
    init(_ navigationController : UINavigationController){
        self.navigationController = navigationController
    }
    
    func configureChildViewController() {
//        self.navigationController.delegate = self

        let transactionsListVC = TransactionsListVC.instantiateFrom(.main)
        let loadPersistanceStoreContainer = PersistanceStoreContainerFactory.create(with: .transactions)
        managedObjectContext = loadPersistanceStoreContainer.viewContext
        coreDataManager = TransactionsCoreDataServiceManager(managedObjectContext)
        let viewModel = TransactionsListViewModel(transactionsListVC,
                                                  loadPersistanceStoreContainer,
                                                  managedObjectContext,
                                                  coreDataManager,
                                                  self)
        
        transactionsListVC.assignViewModel(viewModel)

        self.navigationController.setViewControllers([transactionsListVC], animated: false)
    }
    
    func configureAddedTransactionToTransactionsListVC(_ addedTransaction: Transaction?) {
        if let transactionsListVC = self.navigationController.viewControllers.first(where: { $0 is TransactionsListVC } ) as? TransactionsListVC,
            let addedTransaction = addedTransaction{
            transactionsListVC.viewModel.newTransactionAddedToLocalDatabase(addedTransaction)
        }
        parentCoordinator?.removeChildCoordinator(child: self)
    }
    
    func assignParent() {
        parentCoordinator?.childCoordinator.append(self)
    }
    
    func configureAddTransactionViewContoller() {
        let addTransactionChildCoordinator = ChildCoordinatorFactory.create(with: parentCoordinator!.navigationController, type: .addTransaction)
        
        if let coordinator = addTransactionChildCoordinator as? AddTransactionCoordinator{
            coordinator.assignMocAndLocalStorageManager(self.managedObjectContext,
                                                        self.coreDataManager)
        }
       

        parentCoordinator?.childCoordinator.append(addTransactionChildCoordinator)
//        parentCoordinator?.removeChildCoordinator(child: self)
        addTransactionChildCoordinator.parentCoordinator = self.parentCoordinator
        
        addTransactionChildCoordinator.configureChildViewController()

    }
    
    deinit {
        debugPrint("TransactionsListCoordinator")
    }
}
