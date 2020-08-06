//
//  WelcomeView.swift
//  CalTrack
//
//  Created by Dev on 04/12/2019.
//  Copyright © 2019 jdc0rp. All rights reserved.
//

import SwiftUI

//**************** Welcome View ****************\\
struct WelcomeView: View {
    //**************** Variables ****************\\
    @EnvironmentObject var session: SessionStore
    @State var isShowingLoginForm = false
    @State var isShowingSignUpForm = false
    @State var display: Bool
    
    // Initialise the session
    func getUser() {
        session.listen()
    }
    
    var body: some View {
        Group {
            // If the user is logged in show home view
            if (session.session != nil) {
                VStack {
                    TabView {
                        HomeView().environmentObject(self.session)
                            .tabItem {
                                Image(systemName: "house.fill")
                                Text("Home")
                        }.tag(0)
                        SearchView().environmentObject(self.session)
                            .tabItem {
                                Image(systemName: "magnifyingglass.circle.fill")
                                Text("Search")
                        }.tag(1)
                        GoalsView().environmentObject(self.session)
                            .tabItem {
                                Image(systemName: "flame.fill")
                                Text("Goals")
                        }.tag(2)
                        SettingsView().environmentObject(self.session)
                            .tabItem {
                                Image(systemName: "person.fill")
                                Text("Settings")
                        }.tag(3)
                    }
                    
                }
                
                // If the user is not logged in show auth screen
            } else {
                ZStack {
                    Image("1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                        .scaleEffect(display ? 1.2 : 1.6)
                        .animation(Animation.easeIn(duration: 13))
                    
                    VStack {
                        Spacer()
                        Image("Icon")
                            .resizable()
                            .frame(width: 150, height: 150, alignment: .center)
                            .aspectRatio(contentMode: .fit)
                            .opacity(display ? 0 : 1)
                            .offset(y: display ? 20 : 0)
                            .shadow(color: Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)).opacity(0.1), radius: 5, x: 0, y: 5)
                            .animation(Animation.easeIn(duration: 0.5).delay(0.3))
                        
                        
                        Text("Welcome to CalTrack")
                            .padding()
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .opacity(display ? 0 : 1)
                            .offset(y: display ? 20 : 0)
                            .animation(Animation.easeIn(duration: 0.5).delay(0.2))
                        
                        
                        Spacer()
                        // Login Button
                        Button(action: {self.isShowingLoginForm.toggle()}) {
                            Text("Sign In")
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                                .frame(minWidth: 0, maxWidth: ScreenBounds.deviceWidth - 250)
                                .padding(12)
                                .padding(.horizontal, 30)
                                .background(Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)))
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .shadow(color: Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)).opacity(0.3), radius: 16, x: 5, y: 20)
                                .opacity(display ? 0 : 1)
                                .offset(y: display ? 20 : 0)
                                .animation(Animation.easeIn(duration: 0.6))
                        }.sheet(isPresented: $isShowingLoginForm, content: {SignInView(display: false).environmentObject(self.session)})
                        
                        
                        Spacer()
                        
                        // Signup Button
                        Button(action: {self.isShowingSignUpForm.toggle()}) {
                            Text("Sign Up")
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                                .frame(minWidth: 0, maxWidth: ScreenBounds.deviceWidth - 250)
                                .padding(12)
                                .padding(.horizontal, 30)
                                .background(Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)))
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .shadow(color: Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)).opacity(0.2), radius: 16, x: 0, y: 20)
                                .opacity(display ? 0 : 1)
                                .offset(y: display ? 20 : 0)
                                .animation(Animation.easeIn(duration: 0.6))
                        }.sheet(isPresented: $isShowingSignUpForm, content: {SignUpView(display: false).environmentObject(self.session)})
                        
                        Spacer()
                    }
                }
            }
        }.onAppear {
            self.getUser()
            self.display.toggle()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(display: false)
            .environmentObject(SessionStore())
    }
}
