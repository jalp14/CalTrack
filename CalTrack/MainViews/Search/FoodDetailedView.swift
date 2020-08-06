//
//  FoodDetailedView.swift
//  CalTrack
//
//  Created by Jalp on 20/01/2020.
//  Copyright © 2020 jdc0rp. All rights reserved.
//

import SwiftUI
import Combine
import FirebaseFirestore

//**************** Shows nutritional values for a given food item ****************\\
struct FoodDetailedView: View {
    //**************** Variables ****************\\
    @State var quantity : Int = 0
    @State var isShowingAlert = false
    @State var dismissView = false
    @State var alertMsg = ""
    @State var alertMsgBody = ""
    @EnvironmentObject var session : SessionStore
    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
    @ObservedObject var networkManager = NetworkManager.shared
    @ObservedObject var goal = DBManager.shared
    var foodEnergy = FoodEnergy.shared
    
    // Tracks the calories of the food
    func trackFood() {
        // If the user didn't specify quantity alert them
        if (quantity == 0) {
            self.isShowingAlert = true
            self.alertMsg = "Error"
            self.alertMsgBody = "Quantity must be 1 or more"
            self.dismissView = false
        } else {
            print("Serving quantity selected : \(quantity)")
            let calorie = FoodEnergy.shared.energy
            let intake = calorie * Double(quantity)
            
            // Track the food item
            goal.addIntake(intake: intake, session: self.session, completion: {result in
                if (result == .Error) {
                    self.alertMsg = "Error"
                    self.alertMsgBody = "Error tracking food. Please try again"
                    self.isShowingAlert = true
                } else if (result == .Success) {
                    self.alertMsg = "Success"
                    self.alertMsgBody = "Food has been tracked!"
                    self.isShowingAlert = true
                    self.dismissView = true
                } else {
                    self.alertMsg = "Unkown Error"
                    self.alertMsgBody = "Please try again"
                    self.isShowingAlert = true
                }
            })
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                ImageView(imageURL: networkManager.foodDetail.first!.photo.thumb,vWidth: 90, vHeight: 90)
                    .frame(width: 120, height: 120, alignment: .center)
                    .aspectRatio(contentMode: .fit)
                
                VStack {
                    HStack {
                        Text("\(networkManager.foodDetail.first!.food_name)")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .frame(alignment: .leading)
                        Spacer()
                    }
                    HStack {
                        Text("\(networkManager.foodDetail.first!.brand_name ?? "Common Food")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(4)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
                Spacer(minLength: 40)
            }
            Spacer()
            
            HStack {
                Spacer()
                NutritionalLabelView(energyValue: foodEnergy.energyV, energyPercent: foodEnergy.energyRV, energyColor: foodEnergy.energyColor, energyJ : foodEnergy.energyKJ, fatValue: foodEnergy.fatV, fatPercent: foodEnergy.fatRV, fatColor: foodEnergy.fatColor, saturatesValue: foodEnergy.saturateV, saturatesPercent: foodEnergy.saturateRV, saturatesColor: foodEnergy.saturateColor, sugarsValue: foodEnergy.sugarV, sugarsPercent: foodEnergy.sugarRV, sugarsColor: foodEnergy.sugarColor, saltValue: foodEnergy.saltV, saltPercent: foodEnergy.saltRV, saltColor: foodEnergy.saltColor)
                    
                    
                    .frame(width : ScreenBounds.deviceWidth - 10, alignment: .center)
                Text("")
                Spacer()
            }
            
            Spacer()
            HStack {
                Image(systemName: "info.circle.fill")
                VStack(alignment: .leading) {
                    Text("of the reference intake*")
                        .bold()
                        .font(.caption)
                    Text("Typical values per 100g: Energy 1243kJ / 297kcal")
                        .bold()
                        .font(.caption)
                }
            }
            Spacer()
            
            Stepper(value: $quantity, in: 0...100) {
                Text("Serving \(quantity)")
            }.padding(.all)
            
            Spacer()
            
            Button(action: trackFood) {
                Text("Track")
                    .foregroundColor(.black)
                    .frame(minWidth: 0, maxWidth: ScreenBounds.deviceWidth - 250)
                    .padding(12)
                    .padding(.horizontal, 30)
                    .background(Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)).opacity(0.2), radius: 16, x: 0, y: 20)
            }
            
            Spacer()
        }.alert(isPresented: $isShowingAlert, content: {
            Alert(title: Text(alertMsg), message: Text(alertMsgBody), dismissButton: .default(Text("Okay")) {
                if (self.dismissView) {
                    self.presentation.wrappedValue.dismiss()
                }
                })
        })
        
    }
}

struct FoodDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailedView()
    }
}

