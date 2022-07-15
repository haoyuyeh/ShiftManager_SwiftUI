//
//  TimeFormatter.swift
//  ShiftManager_SwiftUI
//
//  Created by Hao Yu Yeh on 2022/7/15.
//

import Foundation

class TimeFormatter {
    static let shared = TimeFormatter()
    
    var dateFormatter = DateFormatter()
    
    func getTimeString(date: Date, timeStyle:  DateFormatter.Style) -> String {
        dateFormatter.timeStyle = timeStyle
        return dateFormatter.string(from: date)
    }
}
