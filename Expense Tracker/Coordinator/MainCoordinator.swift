//
//  MainCoordinator.swift
//  Expense Tracker
//
//  Created by Krunal on 30/8/22.
//

import Foundation
import UIKit

final class MainCoordinator : ParentCoordinator {
        
    // Properties
    var navigationController: UINavigationController
    var childCoordinator: [ChildCoordinator] = [ChildCoordinator]()

    // Dependency Injection
    init(_ navigationController : UINavigationController){
        self.navigationController = navigationController
    }
    
    // Configure Navigation Controller
    // update any Settings for Navigation Controller
    // like Large Title, Navigation Bar Hide/Show
    private func configureNavigationController() {
        self.navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    // Create Coordinator
    private func createTransactionsListChildCoordinator(_ navigationController: UINavigationController) -> ChildCoordinator {
        // Create Child Coordinator via Factory type `.transactionsList`
        let childCoordinator = ChildCoordinatorFactory.create(with: self.navigationController, type: .transactionsList)
        return childCoordinator
    }
    
    // Configure Root View Controller
    func configureRootViewController() {
        
        // Configure Navigation Controller
        // update any Settings for Navigation Controller
        // like Large Title, Navigation Bar Hide/Show
        self.configureNavigationController()
        
        // Create Coordinator
        let transactionsListCoordinator = createTransactionsListChildCoordinator(self.navigationController)
        childCoordinator.append(transactionsListCoordinator)
        transactionsListCoordinator.parentCoordinator = self
        transactionsListCoordinator.configureChildViewController()
    }

    // Remove Child from Parent Coordinator
    func removeChildCoordinator(child: ChildCoordinator) {
        for(index, coordinator) in childCoordinator.enumerated() {
            if(coordinator === child) {
                childCoordinator.remove(at: index)
                break
            }
        }
    }
    // Release
    deinit {
        debugPrint("MainCoordinator")
    }
}


