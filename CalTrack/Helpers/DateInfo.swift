//
//  DateInfo.swift
//  CalTrack
//
//  Created by Jalp on 09/03/2020.
//  Copyright © 2020 jdc0rp. All rights reserved.
//

import Foundation

// Gets the current Date
struct DateInfo {
    static let now = Calendar.current.dateComponents(in: .current, from: Date())
    static let currentDate = "\(now.day!)-\(now.month!)-\(now.year!)"
}

