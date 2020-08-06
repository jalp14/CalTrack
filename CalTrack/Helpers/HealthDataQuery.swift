//
//  HealthDataQuery.swift
//  CalTrack
//
//  Created by Jalp on 09/03/2020.
//  Copyright © 2020 jdc0rp. All rights reserved.
//

import Foundation
import Swift
import HealthKit
import SwiftUI
import Combine

// **************** Class used to authorise access to HealthKit and fetch calories burned  **************** \\
class HealthDataQuery {
    static let shared = HealthDataQuery()
    let healthStore = HKHealthStore()
    let energyUnit = HKUnit.kilocalorie()

    // Fetches the active calories burned by the user for the day
    func getEnergyBurned(completion: @escaping (_ calorieRetrieved: Double) -> Void) {
        let calendar = Calendar.current
        let today = Date()
        // Set the range to today
        var startDate = calendar.dateComponents([.year, .month, .day], from: today)
        // Apply the range
        startDate.calendar = calendar
        // Create a predicate/filter from the set range
        let predicate = HKQuery.predicateForActivitySummary(with: startDate)
        // Create a query with the predicate
        let dataQuery = HKActivitySummaryQuery(predicate: predicate) { (query, activity, error) in
            if error != nil {
                print("Something went wrong")
                return
            }
            
            if let activity = activity {
                var calories : Double = Double()
                calories = activity[0].activeEnergyBurned.doubleValue(for: .kilocalorie())
                completion(calories)
            }
        }
        // Run the query
        healthStore.execute(dataQuery)
    }
    
    // Request access to data from HealthKit
    func authorizeHealthKit() {
        // Check if HealthKit is available on the device
        guard HKHealthStore.isHealthDataAvailable() else {
            return
        }
        // Set reqest for ActivitySummary
        let objectTypes: Set<HKObjectType> = [
            HKObjectType.activitySummaryType()
        ]
        // Perform the authorisation
        healthStore.requestAuthorization(toShare: nil, read: objectTypes) { (success, error) in
            if (success) {
                print(success)
                UserDefaults.standard.set(true, forKey: "isHealthDataAllowed")
            } else {
                if error != nil {
                    print(error ?? "Error")
                    UserDefaults.standard.set(false, forKey: "isHealthDataAllowed")
                }
            }
        }
    }
}
