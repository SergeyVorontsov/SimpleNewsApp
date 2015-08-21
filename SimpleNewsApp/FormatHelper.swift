//
//  FormatHelper.swift
//  SimpleNewsApp
//
//  Created by Sergey Vorontsov
//  Copyright (c) 2015 Sergey Vorontsov. All rights reserved.
//

import Foundation


/**
Time ago since date

:param: date since date

:returns: Formatted string. For example, "5 day ago"
*/
func timeAgoSinceDate(date:NSDate) -> String {
    let calendar = NSCalendar.currentCalendar();
    let startDate = date
    let endDate = NSDate()
    let flags: NSCalendarUnit = .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute
    let components = calendar.components(flags, fromDate: startDate, toDate: endDate, options: nil)
    var result = ""
    
    if components.day > 0 {
        result = "\(components.day) day ago"
    } else if components.minute > 0  {
        result = "\(components.hour) hour ago"
    } else if components.minute > 0  {
        result = "\(components.day) minutes ago"
    }
    return result
}

