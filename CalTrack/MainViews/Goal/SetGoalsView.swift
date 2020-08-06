//
//  SetGoalsView.swift
//  CalTrack
//
//  Created by Jalp on 23/02/2020.
//  Copyright © 2020 jdc0rp. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
//**************** View that allows users to set/update their daily goal ****************\\
struct SetGoalsView: View {
//**************** Variables ****************\\
    @State var goal: String = ""
    @State var isShowingAlert = false
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var session : SessionStore
    @ObservedObject var goals = DBManager.shared
    @State var alertMsg = ""
    @State var alertMsgBody = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(alignment: .leading) {
                Image(systemName: "flame.fill")
                    .resizable()
                    .frame(width: 43, height: 50, alignment: .leading)
                    .aspectRatio(contentMode: .fit)
                Text("Set Daily Goal")
                    .foregroundColor(.primary)
                    .font(.largeTitle)
                    .frame(alignment: .leading)
                Text("Set daily goals to keep track of your daily calories")
                    .foregroundColor(.secondary)
                    .font(.largeTitle)
            }
            Spacer()
            
            VStack {
                HStack {
                    Image(systemName: "flag.fill")
                        .padding(.all)
                    TextField("Daily Calories", text: $goal)
                        .frame(height: 60)
                        .keyboardType(.numberPad)
                    Text("kCAL")
                        .padding()
                }
            }.background(Color("background"))
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .shadow(color: Color("textfield"), radius: 10, x: 5, y: 5)
                .padding(.horizontal, 16)
            
            Spacer()
            
            Button(action: {
                self.goals.updateGoal(goal: self.goal, session: self.session, completion: {result in
                    if (result == .Success) {
                        self.alertMsg = "Success"
                        self.alertMsgBody = "Your daily goal has been set to \(self.goal)"
                        self.isShowingAlert = true
                    } else if (result == .Error) {
                        self.alertMsg = "Error"
                        self.alertMsgBody = "Plese try again"
                        self.isShowingAlert = true
                    }
                })
            }) {
                Text("Set")
                    .foregroundColor(.black)
                    .frame(minWidth: 0, maxWidth: ScreenBounds.deviceWidth - 200)
                    .padding(12)
                    .padding(.horizontal, 30)
                    .background(Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)).opacity(0.2), radius: 16, x: 0, y: 20)
            }.alert(isPresented: $isShowingAlert) {
                Alert(title: Text(alertMsg), message: Text(alertMsgBody), dismissButton: .default(Text("Okay")) {
                    self.presentation.wrappedValue.dismiss()
                    })
            }
            
            Spacer() 
        }.onTapGesture {
            UIApplication.shared.keyWindow?.endEditing(true)
        }
    }
    
}

struct SetGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        SetGoalsView()
    }
}
