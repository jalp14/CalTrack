//
//  Extensions.swift
//  CalTrack
//
//  Created by Jalp on 02/05/2020.
//  Copyright © 2020 jdc0rp. All rights reserved.
//

import Foundation
import Swift
import UIKit


//**************** Extends the Date class to provice current date in custom format ****************\\
extension Date {
    static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: Date())
    }
}

// Dissmiss Keyboard after search
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
