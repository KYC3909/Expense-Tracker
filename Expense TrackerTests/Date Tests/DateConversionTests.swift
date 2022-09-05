//
//  DateConversionTests.swift
//  Expense TrackerTests
//
//  Created by Krunal on 4/9/22.
//

import XCTest
@testable import Expense_Tracker

class DateConversionTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testDateToday() throws {
        let sut = Date()
        XCTAssertNotNil(sut.dateString(for: .medium))
    }
    
    func testDatePastSevenDays() throws {
        let sut = Date().addingTimeInterval(-7*24*60*60)
        XCTAssertNotNil(sut.dateString(for: .medium))
    }
    
    func testDatePastOneDay() throws {
        let sut = Date().addingTimeInterval(-1*24*60*60)
        XCTAssertNotNil(sut.dateString(for: .medium))
    }
    
}
