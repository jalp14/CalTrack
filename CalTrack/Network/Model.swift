//
//  Model.swift
//  CalTrack
//
//  Created by Jalp on 24/04/2020.
//  Copyright © 2020 jdc0rp. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

//****************************** Nutrionix API Models ******************************\\

// Live Search
struct Response : Decodable {
    let common : [Common]
    let branded : [Branded]
}

struct Common : Decodable {
    let food_name : String
    let photo : Photo
}

struct Branded : Decodable {
    let food_name : String
    let photo : Photo
    let nix_brand_id : String
    let nix_item_id : String
}

struct Photo : Decodable {
    let thumb : String
}

struct ItemResponse : Decodable {
    let foods : [Foods]
}

// Nutritioanl Value
struct Foods : Decodable {
    let food_name : String
    let brand_name : String?
    let photo : Photo
    let nf_calories : Double? // Same as Energy
    let nf_total_fat : Double?
    let nf_saturated_fat : Double?
    let nf_sugars : Double?
    let nf_sodium : Double? // Multiply by 2.5 to get salt value
    let serving_weight_grams : Double? // if null assume 100g
}


//****************************** Database Models ******************************\\

// User class which is used when sending queries and receiving data from the database
//**************** Model for User ****************\\
class User {
    var uid: String
    var email: String?
    var displayName: String?
    
    init(uid: String, displayName: String?, email: String?) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
    }
}

// Struct used as models when sending queries and recieving data from the database

//**************** Model for the goals collection ****************\\
struct goals: Identifiable {
    @DocumentID var id : String? = nil
    var goal : String
    var userid : String
    var date : String
}

//**************** Model for the intakes collection ****************\\
struct intakes: Identifiable {
    @DocumentID var id : String? = nil
    var intake : String
    var userid : String
    var date : String
}

