//
//  HomeView.swift
//  CalTrack
//
//  Created by Dev on 08/12/2019.
//  Copyright © 2019 jdc0rp. All rights reserved.
//

import SwiftUI
import HealthKit
import Firebase
import FirebaseFirestoreSwift

//**************** Home View ****************\\
struct HomeView: View {
//**************** Variables ****************\\
    @EnvironmentObject var session : SessionStore
    @ObservedObject var dbManager = DBManager.shared
    @State var isShowingCameraPreview = false
    @State var isShowingBarcodePreview = false
    @State var todayCalorie : Int = 0
    @State var currentIntake = 0.0
    @State var todayGoal = 0.0
    @State var goalRatio = 0.0
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                VStack {
                    DailyOverView(intake: $currentIntake, caloriesBurned: $todayCalorie, goalSetToday: $todayGoal, goalRatio : $goalRatio)
                }
                .frame(width: 360, height: 140)
                .background(VisualBlur(blurStyle: .systemMaterial))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color(#colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)).opacity(0.3), radius: 20, x: 13, y: 10)
                
                Spacer()
                
                Button(action: {self.isShowingCameraPreview.toggle()}) {
                    Text("Track using ML")
                        .foregroundColor(.black)
                        .frame(minWidth: 0, maxWidth: ScreenBounds.deviceWidth - 250)
                        .padding(12)
                        .padding(.horizontal, 30)
                        .background(Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)).opacity(0.2), radius: 16, x: 0, y: 20)
                }.sheet(isPresented: $isShowingCameraPreview, content: {LiveCameraPreview().environmentObject(self.session)})
                
                Spacer()
                Button(action: {self.isShowingBarcodePreview.toggle()}) {
                    Text("Track using Barcode")
                        .foregroundColor(.black)
                        .frame(minWidth: 0, maxWidth: ScreenBounds.deviceWidth - 200)
                        .padding(12)
                        .padding(.horizontal, 30)
                        .background(Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)).opacity(0.2), radius: 16, x: 0, y: 20)
                }.sheet(isPresented: $isShowingBarcodePreview, content: {BarcodeScannerView().environmentObject(self.session)})
                
                Spacer()
                
            }.navigationBarTitle(Text("Home"))
        //**************** When the view appers, update the values ****************\\
        }.onAppear() {
            print("On Appera Triggered!!!!")
            self.loadCalories()
            self.dbManager.readGoal(session: self.session)
        }
       //**************** When the value for intake is updated, update the UI ****************\\
        .onReceive(dbManager.$currentIntake, perform: {newIntake in
            print("New intake received \(newIntake)")
            self.currentIntake = newIntake
            
            // Recalculate the ratio
            self.goalRatio = (self.currentIntake - Double(self.todayCalorie)) / self.todayGoal
            
            self.goalRatio = self.goalRatio * 100
            print("Goal Ration : \(self.goalRatio)")
            
        })
        //**************** When the value for the current goal is updated, update the UI ****************\\
            .onReceive(dbManager.$currentGoal) { (currentGoal) in
                self.todayGoal = currentGoal
        }
    }
    
    // Load calories burned for today
    func loadCalories() {
        self.dbManager.readIntake(session: self.session)
        HealthDataQuery.shared.getEnergyBurned(completion: {calories in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.todayCalorie = Int(calories)
                print(self.todayCalorie)
                self.goalRatio = (self.currentIntake - Double(self.todayCalorie)) / self.todayGoal
                self.goalRatio = self.goalRatio * 100
                print("Goal Ratio : \(self.goalRatio)")
            }
        })
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

