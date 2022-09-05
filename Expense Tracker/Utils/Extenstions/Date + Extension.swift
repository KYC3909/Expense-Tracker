//
//  Date + Extension.swift
//  Expense Tracker
//
//  Created by Krunal on 31/8/22.
//

import Foundation

extension Date {
    func dateString(for style: DateFormatter.Style) -> String {
        let dateformat: DateFormatter = DateFormatter()
        dateformat.calendar = .current
        dateformat.timeZone = .current
        dateformat.locale = .current

        dateformat.dateStyle = style
        dateformat.timeStyle = .none
                
        return dateformat.string(from: self)
    }
}
