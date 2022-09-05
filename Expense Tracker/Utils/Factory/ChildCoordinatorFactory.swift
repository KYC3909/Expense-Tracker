//
//  ChildCoordinatorFactory.swift
//  Expense Tracker
//
//  Created by Krunal on 30/8/22.
//

import Foundation
import UIKit

enum ChildCoordinatorType {
    case transactionsList
    case addTransaction
}

final class ChildCoordinatorFactory {
    static func create(with _navigationController: UINavigationController, type: ChildCoordinatorType) -> ChildCoordinator {

        switch type {
        case .transactionsList:
            return TransactionsListCoordinator(_navigationController)
        case .addTransaction:
            return AddTransactionCoordinator(_navigationController)
        }
        
    }
}
