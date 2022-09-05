//
//  TransactionsTotalHVM.swift
//  Expense TrackerTests
//
//  Created by Krunal on 4/9/22.
//

import XCTest
@testable import Expense_Tracker

class TransactionsTotalHVM: XCTestCase {
    fileprivate var sut:TransactionsTotalHeaderViewModel!

    override func setUpWithError() throws {
        sut = TransactionsTotalHeaderViewModel()
        sut.expense = 19
        sut.income = 100
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testTotalProgress() throws {
        XCTAssertEqual(sut.totalProgress, 0.19, "Progress should be `19%` only")
    }
    
    func testTotalBalanceString() throws {
        XCTAssertEqual(sut.totalBalanceString, "$ 81", "Balance should be `$ 81`")
    }
    
    func testTotalExpenseString() throws {
        sut.expense = 112
        XCTAssertEqual(sut.totalExpenseString, "$ 112", "Expense should be `$ 112`")
    }
    
    func testTotalIncomeString() throws {
        sut.income = 245
        XCTAssertEqual(sut.totalIncomeString, "$ 245", "Income should be `$ 245`")
    }
    
    func testExpense() throws {
        sut.expense = 2362
        XCTAssertEqual(sut.expense, 2362, "Expense should be `2362`")
    }
    
    func testIncome() throws {
        sut.income = 2463
        XCTAssertEqual(sut.income, 2463, "Income should be `2463`")
    }
    
    func testLessIncomeMoreExpenseForTotalBalanceString_ShouldPass() throws {
        sut.income = 246
        sut.expense = 280
        XCTAssertEqual(sut.totalBalanceString, "- $ 34", "Balance should be `- $ 34`")
    }
    
    func testIncomeisZero_ShouldPass() throws {
        sut.income = 0
        sut.expense = 0
        XCTAssertEqual(sut.totalProgress, 0, "Progress should be `0%` only as there is no Income or Expense")
    }
}
