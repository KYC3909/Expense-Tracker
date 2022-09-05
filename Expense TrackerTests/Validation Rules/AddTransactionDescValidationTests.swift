//
//  AddTransactionDescValidationTests.swift
//  Expense TrackerTests
//
//  Created by Krunal on 4/9/22.
//

import XCTest
@testable import Expense_Tracker

class AddTransactionDescValidationTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testAddTransactionDescription_WhenDescriptionNotProvided_ShouldFail() throws {
        // Arrange
        let sut = ""
        
        // Act
        let descValidatorRule = TransactionDescriptionRule()
        let output = descValidatorRule.performValidation(sut)
        
        // Assert
        XCTAssertFalse(output, "Add Transaction Description should be Failed when no value provided.")
    }

    
    func testAddTransactionDescription_WhenDescriptionNotProvided_ShouldFailWithMessage() throws {
        // Arrange
        let sut = ""
        
        // Act
        let descValidatorRule = TransactionDescriptionRule()
        let output = descValidatorRule.performValidation(sut)
        
        // Assert
        XCTAssertFalse(output, "Add Transaction Description should be Failed when no value provided.")
        XCTAssertEqual(descValidatorRule.errorMessage(), "Description field should not be blank", "Add Transaction Description should be 'Matched' when no value provided.")
    }
    
    
    func testAddTransactionDescription_WhenDescriptionNotProvided_ShouldFailWithUserDefinedMessage() throws {
        // Arrange
        let sut = ""
        
        // Act
        let descValidatorRule = TransactionDescriptionRule("Description is missing!")
        let output = descValidatorRule.performValidation(sut)
        
        // Assert
        XCTAssertFalse(output, "Add Transaction Description should be Failed when no value provided.")
        XCTAssertEqual(descValidatorRule.errorMessage(), "Description is missing!", "Add Transaction Description should be 'Matched' with User Defined Message was provided and when no value provided.")
    }
    
    
    func testAddTransactionDescription_WhenDescriptionNotProvided_ShouldPass() throws {
        // Arrange
        let sut = "Coffee from Tim Hortons" // Expense or Income description
        
        // Act
        let descValidatorRule = TransactionDescriptionRule()
        let output = descValidatorRule.performValidation(sut)
        
        // Assert
        XCTAssertTrue(output, "Add Transaction Description should be Failed when no value provided.")
    }
}
