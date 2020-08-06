//
//  NetworkManager.swift
//  CalTrack
//
//  Created by Jalp on 31/10/2019.
//  Copyright © 2019 jdc0rp. All rights reserved.
//

import SwiftUI
import Combine
import Swift


//**************** Manages all the communication with the API ****************\\
class NetworkManager : ObservableObject {
    // Singleton Class
    static let shared = NetworkManager()
    // Empty Initialiser
    init(){}
    
    //**************** Variables ****************\\
    var didChange = PassthroughSubject<NetworkManager, Never>()
    @Published var commonProducts = [Common]()
    @Published var brandedProducts = [Branded]()
    @Published var foodDetail = [Foods]()
    
    
    // Endpoints for the API
    let apiEndpoint = "https://trackapi.nutritionix.com/v2/"
    let searchEndpoint = "search/instant?branded_region=2&query="
    let upcEndpoint = "search/item?upc="
    let commonFoodDetailEndpoint = "natural/nutrients"
    let brandedFoodDetailEndpoint = "search/item?nix_item_id="
    
    // Create a request for the API
    func createRequest(request : URL) -> URLRequest {
        var request  = URLRequest(url : request)
        request.addValue("", forHTTPHeaderField: "x-app-id")
        request.addValue("", forHTTPHeaderField : "x-app-key")
        request.addValue("0", forHTTPHeaderField : "x-remote-user-id")
        return request
    }
    
    // Perform Search Query
    func performQuery(query : String) {
        let url = apiEndpoint + searchEndpoint
        let query = encodeQuery(query: query)
        let finalURL = URL(string: url+query)
        let request = createRequest(request: finalURL!)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            print("Data is : \(data)")
            
            let result = try? JSONDecoder().decode(Response.self, from: data)
            
            DispatchQueue.main.async {
                self.commonProducts = result!.common
                self.brandedProducts = result!.branded
            }
        }.resume()
    }
    
    // Encode query that have spaces in them
    func encodeQuery(query : String) -> String {
        let encodedParams = query.lowercased().addingPercentEncoding(withAllowedCharacters : .alphanumerics)
        return encodedParams!
    }
    
    // Get nutritional details for Common Food Type
    func getCommonFoodItemDetails(food_name : String, callback: @escaping () -> Void) {
        let url = apiEndpoint + commonFoodDetailEndpoint
        
        let finalURL = URL(string: url)
        print("Final URL sent : \(String(describing: finalURL))")
        var request = createRequest(request: finalURL!)
        request.httpMethod = "POST"
        let json: [String: Any] = ["query" : food_name]
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            print("Data is : \(data)")
            
            let result = try? JSONDecoder().decode(ItemResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.foodDetail = result!.foods
            }
            
            FoodEnergy.shared.getAll(energy: self.foodDetail.first?.nf_calories ?? 0.0, fat: self.foodDetail.first?.nf_total_fat ?? 0.0, saturate: self.foodDetail.first?.nf_saturated_fat ?? 0.0, sugar: self.foodDetail.first?.nf_sugars ?? 0.0, salt: self.foodDetail.first?.nf_sodium ?? 0.0, serv_qty: self.foodDetail.first?.serving_weight_grams ?? 0.0)
            
            callback()
        }.resume()
    }
    
    // Get nutritional details for Branded Food Type
    func getBrandedFoodItemDetails(food_name : String, callback: @escaping () -> Void) {
        let url = apiEndpoint + brandedFoodDetailEndpoint
        // Maybe we don't need to encode the query
        let query = encodeQuery(query: food_name)
        let finalURL = URL(string: url+query)
        print("Final URL sent : \(String(describing: finalURL))")
        let request = createRequest(request: finalURL!)
        
        let details : Foods = Foods(food_name: "", brand_name: "", photo: Photo(thumb: ""), nf_calories: 0, nf_total_fat: 10.0, nf_saturated_fat: 3.0, nf_sugars: 2.0, nf_sodium: 2.0, serving_weight_grams: 2.0)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            print("Data is : \(data)")
            
            let result = try? JSONDecoder().decode(ItemResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.foodDetail = result!.foods
                print(result?.foods ?? details)
                
                FoodEnergy.shared.getAll(energy: self.foodDetail.first?.nf_calories ?? 0.0, fat: self.foodDetail.first?.nf_total_fat ?? 0.0, saturate: self.foodDetail.first?.nf_saturated_fat ?? 0.0, sugar: self.foodDetail.first?.nf_sugars ?? 0.0, salt: self.foodDetail.first?.nf_sodium ?? 0.0, serv_qty: self.foodDetail.first?.serving_weight_grams ?? 0.0)
            }
            callback()
        }.resume()
        
    }
    
    
    // Get nutritional details for food items scanned using barcode
    func getItemDetailsByUPC(upc : String) {
        let url = apiEndpoint + upcEndpoint
        let finalURL = URL(string: url+upc)
        let request = createRequest(request: finalURL!)
        // No need to encode the query since it's just a UPC string
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            
            print("Data is : \(data)")
            
            let result = try? JSONDecoder().decode(ItemResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.foodDetail = result?.foods ?? [Foods]()
                FoodEnergy.shared.getAll(energy: self.foodDetail.first?.nf_calories ?? 0.0, fat: self.foodDetail.first?.nf_total_fat ?? 0.0, saturate: self.foodDetail.first?.nf_saturated_fat ?? 0.0, sugar: self.foodDetail.first?.nf_sugars ?? 0.0, salt: self.foodDetail.first?.nf_sodium ?? 0.0, serv_qty: self.foodDetail.first?.serving_weight_grams ?? 0.0)
            }
        }.resume()
    }
}


