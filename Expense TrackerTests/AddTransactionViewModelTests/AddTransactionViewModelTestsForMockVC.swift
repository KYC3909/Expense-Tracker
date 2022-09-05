//
//  AddTransactionViewModelTestsMockVC.swift
//  Expense TrackerTests
//
//  Created by Krunal on 5/9/22.
//

import XCTest
import CoreData
@testable import Expense_Tracker

private final class MockViewController: AddTransactionViewProtocol {
    static var transactionSuccessfulCount:Int = 0
    static var errorDescCount:Int = 0
    static var transactionAmountCount:Int = 0

    func transactionAddedSuccessful() { MockViewController.transactionSuccessfulCount += 1 }
    func transactionErrorDesc(_ errorDesc: String) { MockViewController.errorDescCount += 1 }
    func transactionAmountUpdated(to value: Int) { MockViewController.transactionAmountCount += 1 }
    
    func resetCounter() {
        MockViewController.transactionSuccessfulCount = 0
        MockViewController.errorDescCount = 0
        MockViewController.transactionAmountCount = 0
    }
}

class AddTransactionViewModelTestsMockVC: XCTestCase {
    private var managedObjectContext:NSManagedObjectContext!
    private var coreDataManager:TransactionsCoreDataServiceManager!
    private var sutViewModel:AddTransactionViewModel!
    private var addTransactionVC:MockViewController!

    override func setUpWithError() throws {
        let loadPersistanceStoreContainer = PersistanceStoreContainerFactory.create(with: .transactions)
        loadPersistanceStoreContainer.loadPersistentStores { [weak self] desc, err in }
        managedObjectContext = loadPersistanceStoreContainer.viewContext
        coreDataManager = TransactionsCoreDataServiceManager(managedObjectContext)
        coreDataManager.clearAllRecords()

        addTransactionVC = MockViewController()
        let viewModel = AddTransactionViewModel(addTransactionVC,
                                                managedObjectContext,
                                                coreDataManager,
                                                AddTransactionCoordinator(UINavigationController()))
        
        sutViewModel = viewModel
    }

    override func tearDownWithError() throws {
        coreDataManager.clearAllRecords()
        addTransactionVC.resetCounter()
        addTransactionVC = nil
        sutViewModel = nil
        managedObjectContext = nil
        coreDataManager = nil
    }
    
    // MARK: - Testing Increase Amount
    func testViewModel_WhenIncreaseUnrealisticAmount_ShouldFail() throws {
        sutViewModel.increaseAmount("100000000")
        
        XCTAssertEqual(MockViewController.errorDescCount, 1, "This increment operation not allowed.")
    }
    
    func testViewModel_WhenIncreaseRandomAmount_ShouldPass() throws {
        sutViewModel.increaseAmount(Int.random(in: 1..<100000000).description)
        
        XCTAssertEqual(MockViewController.transactionAmountCount, 1, "This increment operation not allowed.")
    }
    
    func testViewModel_WhenIncreaseZeroAmount_ShouldPass() throws {
        sutViewModel.increaseAmount("0")
        
        XCTAssertEqual(MockViewController.transactionAmountCount, 1, "This increment operation not allowed.")
    }
    
    // MARK: - Testing Decrease Amount
    func testViewModel_WhenDecreaseUnrealisticAmount_ShouldPass() throws {
        sutViewModel.decreaseAmount("100000000")
        
        XCTAssertEqual(MockViewController.transactionAmountCount, 1, "This decrement operation not allowed.")
    }
    
    func testViewModel_WhenDecreaseRandomAmount_ShouldPass() throws {
        sutViewModel.decreaseAmount(Int.random(in: 1..<100000000).description)
        
        XCTAssertEqual(MockViewController.transactionAmountCount, 1, "This decrement operation not allowed.")
    }
    
    func testViewModel_WhenDecreaseZeroAmount_ShouldFail() throws {
        sutViewModel.decreaseAmount("0")
        
        XCTAssertEqual(MockViewController.errorDescCount, 1, "This decrement operation not allowed.")
    }
    
    // MARK: - Testing Add Transaction
    func testViewModelAddTransaction_WhenTransactionTypeNotSelected_ShouldFail() throws {
        sutViewModel.addSelected(-1, "", 0)
        
        XCTAssertEqual(MockViewController.errorDescCount, 1, "Transaction Type should be `-1`")
    }
    
    func testViewModelAddTransaction_WhenDescriptionNotProvided_ShouldFail() throws {
        sutViewModel.addSelected(1, "", 0)
        
        XCTAssertEqual(MockViewController.errorDescCount, 1, "Description should be blank.")
    }
    
    func testViewModelAddTransaction_WhenExpenseAmountNotProvided_ShouldFail() throws {
        sutViewModel.addSelected(0, "Shopping", 0)
        
        XCTAssertEqual(MockViewController.errorDescCount, 1, "Expense amount should be `0`")
    }
    
    func testViewModelAddTransaction_WhenExpenseAmountProvided_ShouldPass() throws {
        sutViewModel.addSelected(0, "Shopping", 10)
        
        XCTAssertEqual(MockViewController.transactionSuccessfulCount, 1, "Expense amount should be `10`")
    }
    
}
