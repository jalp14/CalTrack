//
//  GoalsView.swift
//  CalTrack
//
//  Created by Dev on 08/12/2019.
//  Copyright © 2019 jdc0rp. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

//**************** View that gives an overiew of the daily goal  ****************\\
struct GoalsView: View {
//**************** Variables ****************\\
    @State var isShowingGoal = false
    @State var isShowingPreviousGoalsView = false
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        VStack {
            Spacer()
            PlatterView()
                .cornerRadius(20)
                .padding()
                .shadow(color: Color("textfield"), radius: 20, x: 0, y: 10)
                .environmentObject(self.session)
            Spacer()
            HStack {
                Text("View previous goals")
                Image(systemName: "arrow.right.circle.fill")
            }.sheet(isPresented: $isShowingPreviousGoalsView, content: {
                PreviousGoalsView().environmentObject(self.session)
            })
                .onTapGesture {
                    self.isShowingPreviousGoalsView.toggle()
            }
            
            Spacer()
            
            Button(action: {self.isShowingGoal.toggle()}) {
                Text("Set Goal for today")
                    .foregroundColor(.black)
                    .frame(minWidth: 0, maxWidth: ScreenBounds.deviceWidth - 200)
                    .padding(12)
                    .padding(.horizontal, 30)
                    .background(Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)).opacity(0.2), radius: 16, x: 0, y: 20)
            }.sheet(isPresented: $isShowingGoal, content: {SetGoalsView().environmentObject(self.session)})
            Spacer()
        }
    }
}

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsView()
    }
}



