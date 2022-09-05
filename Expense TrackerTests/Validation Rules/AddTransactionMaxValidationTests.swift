//
//  AddTransactionMaxValidationTests.swift
//  Expense TrackerTests
//
//  Created by Krunal on 4/9/22.
//

import XCTest
@testable import Expense_Tracker

class AddTransactionMaxValidationTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func testAddTransactionAmount_WhenAmountIsZero_ShouldFail() throws {
        // Arrange
        let sut = 0
        
        // Act
        let amountValidatorRule = TransactionMaxAmountRule()
        let output = amountValidatorRule.performValidation(sut)
        
        // Assert
        XCTAssertFalse(output, "Transaction Amount should be Failed when Zero amount is sent")
        XCTAssertEqual(amountValidatorRule.errorMessage(), "Please enter proper amount")
    }
    
    func testAddTransactionAmount_WhenAmountIsMoreThanOneHundredMillion_ShouldFail() throws {
        // Arrange
        let sut = 100_000_000
        
        // Act
        let amountValidatorRule = TransactionMaxAmountRule("Please provide Less Than 100 Hundred Million Dollar amount")
        let output = amountValidatorRule.performValidation(sut)
        
        // Assert
        XCTAssertFalse(output, "Transaction Amount should be Failed when One Hundred Million amount is sent")
        XCTAssertEqual(amountValidatorRule.errorMessage(), "Please provide Less Than 100 Hundred Million Dollar amount")
    }
    
    func testAddTransactionAmount_WhenAmountIsLessThanOneHundredMillion_ShouldPass() throws {
        // Arrange
        let sut = 99_999_999
        
        // Act
        let amountValidatorRule = TransactionMaxAmountRule()
        let output = amountValidatorRule.performValidation(sut)
        
        // Assert
        XCTAssertTrue(output, "Transaction Amount should be Failed when Less Than One Hundred Million amount is sent")
    }
    
    
    func testAddTransactionAmount_WhenAmountIsRandomNumberLessThanOneHundredMillion_ShouldPass() throws {
        // Arrange
        let sut = Int.random(in: 1..<100_000_000)
        
        // Act
        let amountValidatorRule = TransactionMaxAmountRule()
        let output = amountValidatorRule.performValidation(sut)
        
        // Assert
        XCTAssertTrue(output, "Transaction Amount should be Failed when Less Than One Hundred Million amount is sent")
    }
    
}
