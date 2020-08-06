//
//  ContentView.swift
//  CalTrack
//
//  Created by Jalp on 04/12/2019.
//  Copyright © 2019 jdc0rp. All rights reserved.
//

import SwiftUI
import UserNotifications

//**************** First view  ****************\\
struct ContentView: View {
//**************** User Default Variables ****************\\
    @State var isShowingIntroView = !(UserDefaults.standard.bool(forKey: "shownWelcomeScreen"))
    @State var hasAccessToNotifications = UserDefaults.standard.bool(forKey: "isNotificationsAllowed")
    @State var hasAccessToHealthData = UserDefaults.standard.bool(forKey: "isHealthDataAllowed")
    
    var body: some View {
        VStack {
            WelcomeView(display: true)
                .onAppear() {
                    // Check if the app has notification access
                    if !(self.hasAccessToNotifications) {
                        print("Requiresting Notification Access")
                        GetPermission.shared.requestNotificationAccess()
                    }
                    // Check if the app has HealthKit access
                    if !(self.hasAccessToHealthData) {
                        print("Requesting Health Aceess")
                        HealthDataQuery.shared.authorizeHealthKit()
                    }
            }
            EmptyView()
                .sheet(isPresented: self.$isShowingIntroView, content: {
                    IntroView()
                })
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//**************** Introduction view shown on first launch of the app ****************\\
struct IntroView : View {
//**************** Variables ****************\\
    @Environment(\.presentationMode) var presentation
    @State var isShownToUser : Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                Spacer()
                Image("Icon")
                    .resizable()
                    .frame(width: 95, height: 95, alignment: .center)
                    .aspectRatio(contentMode: .fit)
                    .shadow(color: Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)).opacity(0.1), radius: 5, x: 0, y: 5)
                Spacer()
            }
            
            HStack {
                Spacer()
                Text("Welcome to CalTrack")
                    .bold()
                    .padding()
                    .font(.largeTitle)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            IntroViewLayout(title: "Warning", subtitle: "Only use this app when in a safe environment", image: "exclamationmark.triangle.fill")
            
            IntroViewLayout(title: "Track at Ease", subtitle: "You can track calories using 3 different methods. So feel free to use any", image: "ellipsis.circle.fill")
            
            IntroViewLayout(title: "Reminder", subtitle: "Turn on notifications to get reminded everyday to set your daily calories", image: "rectangle.grid.1x2.fill")
            
            Spacer()
            
            Button(action : {
                self.isShownToUser = true
                UserDefaults.standard.set(self.isShownToUser, forKey: "shownWelcomeScreen")
                self.presentation.wrappedValue.dismiss()
                // Haptic Feedback on completion of setup
                HapticFeedbackGenerator.shared.generateSuccessFeedback()
            }) {
                Text("Continue")
                    .foregroundColor(.black)
                    .frame(minWidth: 0, maxWidth: ScreenBounds.deviceWidth - 10)
                    .padding(12)
                    .padding(.horizontal, 30)
                    .background(Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)).opacity(0.2), radius: 16, x: 0, y: 20)
            }
            Spacer()
        }.padding(.horizontal)   
    }
}

//**************** Layout of the Intro view ****************\\
struct IntroViewLayout : View {
//**************** Variables ****************\\
    var title: String = "placeholder"
    var subtitle: String = "placeholder"
    var image: String = "placeholder"
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: image)
                .padding()
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                
                Text(subtitle)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
        }.padding()
    }
}

