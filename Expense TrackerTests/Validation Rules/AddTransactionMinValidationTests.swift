//
//  AddTransactionMinValidationTests.swift
//  Expense TrackerTests
//
//  Created by Krunal on 4/9/22.
//

import XCTest
@testable import Expense_Tracker

class AddTransactionMinValidationTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testAddTransactionAmount_WhenAmountIsZero_ShouldFail() throws {
        // Arrange
        let sut = 0
        
        // Act
        let amountValidatorRule = TransactionMinAmountRule()
        let output = amountValidatorRule.performValidation(sut.description)
        
        // Assert
        XCTAssertFalse(output, "Transaction Amount should be Failed when Zero amount is sent")
        XCTAssertEqual(amountValidatorRule.errorMessage(), "Please enter proper amount")
    }

    
    func testAddTransactionAmount_WhenAmountIsLessThanZero_ShouldFail() throws {
        // Arrange
        let sut = -1
        
        // Act
        let amountValidatorRule = TransactionMinAmountRule()
        let output = amountValidatorRule.performValidation(sut.description)
        
        // Assert
        XCTAssertFalse(output, "Transaction Amount should be Failed when Zero amount is sent")
        XCTAssertEqual(amountValidatorRule.errorMessage(), "Please enter proper amount")
    }
    
    func testAddTransactionAmount_WhenAmountIsOne_ShouldPass() throws {
        // Arrange
        let sut = 1
        
        // Act
        let amountValidatorRule = TransactionMinAmountRule()
        let output = amountValidatorRule.performValidation(sut.description)
        
        // Assert
        XCTAssertTrue(output, "Transaction Amount should be Failed when Less Than One Hundred Million amount is sent")
    }
}
