//
//  LocalDataPersistanceStoreContainer.swift
//  Expense Tracker
//
//  Created by Krunal on 31/8/22.
//

import Foundation
import CoreData

// Persistance Store Container Name
enum PersistanceStoreContainerName: String {
    case transactions = "Transactions"
}

// Factory class for Persistance Store Container
// Creates Persistent Container object
final class PersistanceStoreContainerFactory {
    static func create(with type: PersistanceStoreContainerName) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: type.rawValue)
        return container
    }
}
