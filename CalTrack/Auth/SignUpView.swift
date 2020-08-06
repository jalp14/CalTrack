//
//  SignUpView.swift
//  CalTrack
//
//  Created by Jalp on 24/11/2019.
//  Copyright © 2019 jdc0rp. All rights reserved.
//

import SwiftUI
//**************** View for Sign Up ****************\\
struct SignUpView: View {
//**************** Variables ****************\\
    @EnvironmentObject var session: SessionStore
    @State var userEmail: String = ""
    @State var userPassword: String = ""
    @State var load = false
    @State var authError = false
    @State var display: Bool
    @State var showingErrorAlert : Bool = false
    
    var body: some View {
        ZStack {
            Image("4")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .scaleEffect(display ? 1.6 : 1)
                .animation(Animation.easeIn(duration: 13))
            
            VStack(spacing: 0) {
                Spacer()
                VStack(alignment: .leading) {
                    Image("Icon")
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .leading)
                        .aspectRatio(contentMode: .fit)
                    Text("Welcome!")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .bold()
                        .frame(alignment: .leading)
                    Text("Sign Up to use CalTrack")
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
                            self.showingErrorAlert = true
                    }
                    .alert(isPresented: $showingErrorAlert) {
                        Alert(title: Text("Error with authentication"), message: Text("Wrong Email or Password entered"), dismissButton: .default(Text("Try Again")))
                    }
                }
                
                Button(action: signup) {
                    Text("Sign Up")
                        .foregroundColor(.black)
                        .frame(minWidth: 0, maxWidth: ScreenBounds.deviceWidth - 250)
                        .padding(12)
                        .padding(.horizontal, 30)
                        .background(Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)).opacity(0.2), radius: 16, x: 0, y: 20)
                }
                
                Spacer()
            }
        }.onAppear() {
            self.display.toggle()
        }
    }
    // Sends the detail from fields to the signup function to register user
    func signup() {
        load = true
        authError = false
        session.signUp(email: userEmail, password: userPassword) { (result, error) in
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(display: false)
    }
}
