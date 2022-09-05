//
//  MockCoordinatorTests.swift
//  Expense TrackerTests
//
//  Created by Krunal on 4/9/22.
//

import XCTest
@testable import Expense_Tracker


fileprivate class MockMainCoordinator : ParentCoordinator {
    // Properties
    var navigationController: UINavigationController
    var childCoordinator: [ChildCoordinator] = [ChildCoordinator]()
    
    private(set) var loadNavViewControllerCallCount:Int = 0
    private(set) var startCallCount:Int = 0
    private(set) var didRemoveCallCount:Int = 0
    
    // D.I.
    init(_ navigationController : UINavigationController){
        self.navigationController = navigationController
    }
    
    // Navigation Controller
    private func configureNavigationController() {
        loadNavViewControllerCallCount += 1
    }
    
    // Configure Root View Controller
    func configureRootViewController() {
        startCallCount += 1
        
        // Configure Navigation Controller
        // update any Settings for Navigation Controller
        // like Large Title, Navigation Bar Hide/Show
        self.configureNavigationController()
        
        // Create Coordinator
        let transactionsListCoordinator = MockTransactionsListCoordinator(self.navigationController)
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
        didRemoveCallCount += 1
    }
}



final class MockTransactionsListCoordinator : ChildCoordinator {
    // Properties
    weak var parentCoordinator: ParentCoordinator?
    var navigationController: UINavigationController
    
    private(set) var loadViewControllerCallCount:Int = 0
    private(set) var didAddCallCount:Int = 0

    // D.I.
    init(_ navigationController : UINavigationController){
        self.navigationController = navigationController
    }
    
    // Configure Chile Controller
    func configureChildViewController() {
        loadViewControllerCallCount += 1
    }
    
    // Configure Next Child Controller
    func configureAddTransactionViewContoller() {
        didAddCallCount += 1
    }
    
}


class CoordinatorTests: XCTestCase {
    fileprivate var sutCoordinator:MockMainCoordinator!
    
    override func setUpWithError() throws {
        sutCoordinator = MockMainCoordinator(UINavigationController())
    }

    override func tearDownWithError() throws {
        sutCoordinator = nil
    }
    
    
    func testStartCoordinator() {
        sutCoordinator.configureRootViewController()
        XCTAssertEqual(sutCoordinator.startCallCount, 1, "Configure Root View Controller should be called once")
    }
    
    func testConfigureNavigationController() {
        sutCoordinator.configureRootViewController()
        XCTAssertEqual(sutCoordinator.loadNavViewControllerCallCount, 1, "Navigation Controller should be called once")
    }
    
    func testCoordinatorInstanceAssociationWithViewController() {
        sutCoordinator.configureRootViewController()
        XCTAssertEqual((sutCoordinator.childCoordinator.first as? MockTransactionsListCoordinator)?.loadViewControllerCallCount, 1, "Mock Transactions List View Controller should be called once")
    }
    
    
    func testCoordinatorInstanceAssociationWithNextViewController() {
        sutCoordinator.configureRootViewController()
        let sut = sutCoordinator.childCoordinator.first as! MockTransactionsListCoordinator
        sut.configureAddTransactionViewContoller()
        
        XCTAssertEqual(sut.didAddCallCount, 1, "Mock Transaction View Controller should be called once")
    }
    
    func testCoordinatorInstanceRemoveCoordinator() {
        sutCoordinator.configureRootViewController()
        let sut = sutCoordinator.childCoordinator.first as! MockTransactionsListCoordinator
        sutCoordinator.removeChildCoordinator(child: sut)
        
        XCTAssertEqual(sutCoordinator.didRemoveCallCount, 1, "Child Coordinator Removed and should be called once")
    }

    
}
