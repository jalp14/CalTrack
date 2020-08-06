//
//  HapticFeedbackGenerator.swift
//  CalTrack
//
//  Created by Jalp on 23/04/2020.
//  Copyright © 2020 jdc0rp. All rights reserved.
//

import Foundation
import Swift
import SwiftUI

// **************** Class to generate various haptic feedback **************** \\
class HapticFeedbackGenerator {
    
    // Singleton Class
    static let shared = HapticFeedbackGenerator()
    init(){}
    
    // Feedback Generator
    let gen = UINotificationFeedbackGenerator()
    
    // Successful Feedback
    func generateSuccessFeedback() {
        gen.notificationOccurred(.success)
    }
    // Warning Feedback
    func generateWarningFeedback() {
        gen.notificationOccurred(.warning)
    }
    // Error Feedback
    func generateErorFeedback() {
        gen.notificationOccurred(.error)
    }
    
}
