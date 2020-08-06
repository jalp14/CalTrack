//
//  DailyIntakeData.swift
//  CalTrack
//
//  Created by Jalp on 06/02/2020.
//  Copyright © 2020 jdc0rp. All rights reserved.
//

import Swift
import SwiftUI

// **************** Read Only Struct **************** \\
struct DailyIntakeData {
    
    // Daily Intake Values per 100g according to NHS : https://www.nhs.uk/live-well/eat-well/what-are-reference-intakes-on-food-labels/
    
    // Source of Calories -> Protein, Carbohydrate(Sugars), Fat(Saturated Fat)
    
    static let dailyEnergyIntake = 2000.0 // kcal
    
    static let dailyTotalFatIntake = 70.0 // per 100 grams
    static let maxDailyFat = 17.5
    static let minDailyFat = 3.0
    
    static let dailySaturatedFatIntake = 20.0 // grams
    static let maxDailySaturatedFat = 5.0
    static let minDailySaturatedFat = 1.5
    
    static let dailyCarbsIntake = 260 // grams
    
    
    static let dailySugarsInatke = 90.0 // grams
    static let maxDailySugars = 22.5
    static let minDailySugars = 5.0
    
    static let dailyProteinIntake = 50 // grams
    
    static let dailySaltIntake = 6.0 // grams
    static let maxDailySalt = 1.5
    static let minDailySalt = 0.3
}
// **************** Calculates all the ref values and colour for the nutritional label **************** \\
class FoodEnergy {
    // Singleton Class
    static let shared = FoodEnergy()
    init(){}
// **************** Variables **************** \\
    var energyV = ""
    var energyRV = ""
    var energy = 0.0
    var energyColor = Color.white
    var fatV = ""
    var fatRV = ""
    var fatColor = Color.white
    var saturateV = ""
    var saturateRV = ""
    var saturateColor = Color.white
    var sugarV = ""
    var sugarRV = ""
    var sugarColor = Color.white
    var saltV = ""
    var saltRV = ""
    var saltColor = Color.white
    var energyKJ = ""
    
    // Works out the serving quantity based on the serv_qty received from the API
    func workoutServQty(serv_qty : Double) -> Double {
        var qty : Double = 1.0
        print("Serving Quantitiy is -> \(serv_qty)")
        if (serv_qty != 0.0) {
            qty = 100/serv_qty
        } else {
            qty = 1.0
        }
    
        print("Serving Quantity is : \(qty)")
        return qty
        
    }
    // Wokrouts all the nutritional data
    func getAll(energy : Double, fat : Double, saturate : Double, sugar : Double, salt : Double, serv_qty : Double) {
        let srv_qty = workoutServQty(serv_qty: serv_qty)
        calculateEnergy(energy: energy, srv_qty: srv_qty)
        calculateFat(fat: fat, srv_qty: srv_qty)
        calculateSaturate(saturate: saturate, srv_qty: srv_qty)
        calculateSugar(sugar: sugar, srv_qty: srv_qty)
        calculateSalt(salt: (salt/1000), srv_qty: srv_qty)
    }
    
    // Works out the Calories percentage for daily intake and the color based on the min/max daily intake
    func calculateEnergy(energy : Double, srv_qty : Double) {
        let energyF = (energy * srv_qty).roundToDecimal(2)
        self.energy = energyF
        energyV = "\(energyF)kCal"
        energyRV = String((((energyF / DailyIntakeData.dailyEnergyIntake)*100).roundToDecimal(2))) + "%"
        let energyJ = (energyF * 4.184).roundToDecimal(2)
        energyKJ = "\(energyJ)kJ"
    }
    
    // Works out the Fat percentage for daily intake and the color based on the min/max daily intake
    func calculateFat(fat : Double, srv_qty : Double) {
        fatV = "\((fat).roundToDecimal(2))g"
        let fatF = (((fat*srv_qty) / DailyIntakeData.dailyTotalFatIntake)*100).roundToDecimal(2)
        fatRV = ("\(fatF)%")
        if fat <= DailyIntakeData.minDailyFat {
            fatColor = Color.green
        } else if fat >= DailyIntakeData.maxDailyFat {
            fatColor = Color.red
        } else {
            fatColor = Color.orange
            
        }
    }
    
    // Works out the Saturate percentage for daily intake and the color based on the min/max daily intake
    func calculateSaturate(saturate : Double, srv_qty : Double) {
        saturateV = "\((saturate).roundToDecimal(2))g"
        let saturateF = (((saturate*srv_qty) / DailyIntakeData.dailySaturatedFatIntake)*100).roundToDecimal(2)
        saturateRV = ("\(saturateF)%")
        if saturate <= DailyIntakeData.minDailySaturatedFat {
            saturateColor = Color.green
        } else if saturate >= DailyIntakeData.maxDailySaturatedFat {
            saturateColor = Color.red
        } else {
            saturateColor = Color.orange
        }
    }
    
    // Works out the Sugar percentage for daily intake and the color based on the min/max daily intake
    func calculateSugar(sugar : Double, srv_qty : Double) {
        sugarV = "\((sugar).roundToDecimal(2))g"
        let sugarF = (((sugar*srv_qty) / DailyIntakeData.dailySugarsInatke)*100).roundToDecimal(2)
        print(sugar*srv_qty)
        sugarRV = ("\(sugarF)%")
        if sugar <= DailyIntakeData.minDailySugars {
            sugarColor = Color.green
        } else if sugar >= DailyIntakeData.maxDailySugars {
            sugarColor = Color.red
        } else {
            sugarColor = Color.orange
        }
    }
    
    // Works out the Salt percentage for daily intake and the color based on the min/max daily intake
    func calculateSalt(salt : Double, srv_qty : Double) {
        // Multiply by 2.5
        saltV = "\((salt*2.5).roundToDecimal(2))g"
        let saltF = (((salt*2.5*srv_qty) / DailyIntakeData.dailySaltIntake)*100).roundToDecimal(2)
        saltRV = ("\(saltF)%")
        if salt <= DailyIntakeData.minDailySalt {
            saltColor = Color.green
        } else if salt >= DailyIntakeData.maxDailySalt {
            saltColor = Color.red
        } else {
            saltColor = Color.orange
        }
    }
    
}

// Used to round decimal values with precision
extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

// Used to convert Double -> String and place decimal points in correct places
extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

// Used to convert Int -> String and place decimal points in correct places
extension Int {
    func format(f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}

