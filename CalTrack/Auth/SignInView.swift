//
//  SignInView.swift
//  CalTrack
//
//  Created by Jalp on 24/11/2019.
//  Copyright © 2019 jdc0rp. All rights reserved.
//

import SwiftUI
import Firebase
//**************** View for Sign in ****************\\
struct SignInView: View {
//**************** Variables ****************\\
    @EnvironmentObject var session: SessionStore
    @State var userEmail: String = ""
    @State var isShowingForgotPasswordView = false
    @State var userPassword: String = ""
    @State var load = false
    @State var authError = false
    @State var display: Bool
    @State var showingErrorAlert : Bool = false
    @State var alertMsg = ""
    @State var alertMsgBody = ""
    
    var body: some View {
        ZStack {
            Image("3")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .scaleEffect(display ? 1.6 : 1.2)
                .animation(Animation.easeIn(duration: 13))
            
            VStack(spacing: 0) {
                Spacer()
                VStack(alignment: .leading) {
                    Image("Icon")
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .leading)
                        .aspectRatio(contentMode: .fit)
                    Text("Welcome Back!")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .bold()
                        .frame(alignment: .leading)
                    Text("Sign In to use CalTrack")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .bold()
                }
                Spacer()
                
                VStack {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)))
                            .frame(width: 44, height: 44)
                            .background(Color("background3"))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)).opacity(0.1), radius: 5, x: 0, y: 5)
                            .padding(.all)
                        
                        TextField("Email Address", text: $userEmail)
                            .frame(height: 60)
                            .keyboardType(.emailAddress)
                    }
                    Divider()
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)))
                            .frame(width: 44, height: 44)
                            .background(Color("background3"))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)).opacity(0.1), radius: 5, x: 0, y: 5)
                            .padding(.all)
                        SecureField("Password", text: $userPassword)
                            .frame(height: 60)
                    }
                }
                .frame(width: 360, height: 160)
                .background(VisualBlur(blurStyle: .systemMaterial))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color(#colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)).opacity(0.3), radius: 20, x: 10, y: 10)
                
                Spacer()
                
                if (authError) {
                    Text("")
                        .onAppear() {
                            self.alertMsg = "Error with authentication"
                            self.alertMsgBody = "Wrong Email or Password entered"
                            self.showingErrorAlert = true
                    }
                    .alert(isPresented: $showingErrorAlert) {
                        Alert(title: Text(alertMsg), message: Text(alertMsgBody), dismissButton: .default(Text("Try Again")))
                    }
                }
                
                Button(action: login) {
                    Text("Sign In")
                        .foregroundColor(.black)
                        .frame(minWidth: 0, maxWidth: ScreenBounds.deviceWidth - 250)
                        .padding(12)
                        .padding(.horizontal, 30)
                        .background(Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)).opacity(0.2), radius: 16, x: 0, y: 20)
                }
                
                Spacer()
                
                Button(action: {self.isShowingForgotPasswordView.toggle()}) {
                    Text("Forgot Password")
                        .foregroundColor(.black)
                        .frame(minWidth: 0, maxWidth: ScreenBounds.deviceWidth - 200)
                        .padding(12)
                        .padding(.horizontal, 30)
                        .background(Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)).opacity(0.2), radius: 16, x: 0, y: 20)
                }.sheet(isPresented: $isShowingForgotPasswordView, content: {ForgotPasswordView(display: false).environmentObject(self.session)})
                
                Spacer()
            }
        }.onAppear() {
            self.display.toggle()
        }
    }
    
    // Check for credentials and if corret login the user
    func login() {
        load = true
        authError = false
        session.signIn(email: userEmail, password: userPassword) { (result, error) in
            self.load = false
            if error != nil {
                self.authError = true
            } else {
                self.userEmail = ""
                self.userPassword = ""
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(display: false)
    }
}



