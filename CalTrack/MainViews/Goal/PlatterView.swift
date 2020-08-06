//
//  PlatterView.swift
//  CalTrack
//
//  Created by Jalp on 13/12/2019.
//  Copyright © 2019 jdc0rp. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

//**************** Platter view that displaus the current goal set by the user ****************\\
struct PlatterView: View {
//**************** Variables ****************\\
    @EnvironmentObject var session: SessionStore
    @ObservedObject var dbManager = DBManager.shared
    @State var goalToday = 0.0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Goal for Today")
                .foregroundColor(Color.white)
                .fontWeight(Font.Weight.heavy)
                .font(Font.system(size: 30))
                .multilineTextAlignment(.leading)
                .padding()
            
            Text("\(self.goalToday.format(f: ".2"))")
            .foregroundColor(Color.white)
            .font(.title)
            .padding()
            
            Image(systemName: "waveform.path.ecg")
            .resizable()
            .foregroundColor(Color.white)
            .frame(width: 100, height: 100, alignment: .center)
            .aspectRatio(contentMode: .fit)
            .padding()
            
            Text(Date.getCurrentDate())
                .foregroundColor(Color.white)
                .fontWeight(Font.Weight.medium)
                .font(Font.system(size: 30))
                .multilineTextAlignment(.leading)
                .padding()
            
            
        }.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            .background(Color.red)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: Color(#colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)).opacity(0.3), radius: 13, x: 5, y: 5)
            .onReceive(dbManager.$currentGoal) { (currentGoal) in
                self.goalToday = currentGoal
        }
        .onAppear() {
            self.dbManager.readGoal(session: self.session)
        }
    }
}


struct PlatterView_Previews: PreviewProvider {
    static var previews: some View {
        PlatterView()
    }
}


