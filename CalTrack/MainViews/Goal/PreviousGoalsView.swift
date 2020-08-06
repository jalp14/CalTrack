//
//  PreviousGoalsView.swift
//  CalTrack
//
//  Created by Jalp on 08/03/2020.
//  Copyright © 2020 jdc0rp. All rights reserved.
//

import SwiftUI
//**************** Displays a list of previous goals ****************\\
struct PreviousGoalsView: View {
//**************** Variable ****************\\
    @EnvironmentObject var session: SessionStore
    @ObservedObject var goalObj = DBManager.shared
    @State var prevGoals : [goals] = []
    var body: some View {
        VStack {
            // If results are not empty show previous goals
            if !prevGoals.isEmpty {
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        ForEach(prevGoals, id: \.goal) { i in
                            PreviousGoalDesign(goal: i.goal, date: i.date)
                                .cornerRadius(23)
                                .padding(.all)
                        }
                    }
                }
                // If results are empty no goals have been set by the user
            } else {
                Text("No previous goals found")
            }
            // When goals are received from the database populate the view
        }.onReceive(goalObj.$previousGoals, perform: {goal in
            self.prevGoals = goal
        })
        // When the view appears fetch the previos goals
        .onAppear() {
                self.goalObj.readAllGoals(session: self.session)
        }
    }
}

struct PreviousGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        PreviousGoalsView()
    }
}

//**************** Detail view for each previous goal ****************\\
struct PreviousGoalDesign: View {
//**************** Variables ****************\\
    var goal : String
    var date : String?
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "flame.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 30)
                .shadow(radius: 10)
                .padding()
            Spacer()
            VStack(alignment: .leading) {
                Text("Goals is : \(goal)")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                Text(date!)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }
            Spacer()
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color.blue)
    }
}

