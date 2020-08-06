//
//  ForgotPasswordView.swift
//  CalTrack
//
//  Created by Jalp on 12/12/2019.
//  Copyright © 2019 jdc0rp. All rights reserved.
//

import SwiftUI

//**************** View for Forgot Password ****************\\
struct ForgotPasswordView: View {
    //**************** Variables ****************\\
    @EnvironmentObject var session: SessionStore
    @Environment(\.presentationMode) var presentation
    @State var userEmail: String = ""
    @State var userPassword: String = ""
    @State var load = false
    @State var isShowingSuccessAlert = false
    @State var authError = false
    @State var display: Bool
    
    var body: some View {
        ZStack {
            Image("2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .scaleEffect(display ? 1.6 : 1.2)
                .animation(Animation.easeIn(duration: 13))
            
            VStack(spacing: 0) {
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Reset Password")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .bold()
                        .frame(alignment: .leading)
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
                }
                .frame(width: 360, height: 80)
                .background(VisualBlur(blurStyle: .systemMaterial))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color(#colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)).opacity(0.3), radius: 20, x: 10, y: 10)
                
                Spacer()
                
                Button(action: {
                    self.forgotPassword()
                    self.isShowingSuccessAlert.toggle()
                }) {
                    Text("Send Email")
                        .foregroundColor(.black)
                        .frame(minWidth: 0, maxWidth: ScreenBounds.deviceWidth - 250)
                        .padding(12)
                        .padding(.horizontal, 30)
                        .background(Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)).opacity(0.2), radius: 16, x: 0, y: 20)
                }.alert(isPresented: $isShowingSuccessAlert) {
                    Alert(title: Text("Success!"), message: Text("An email with the reset link has been sent to your email"), dismissButton: .default(Text("Okay")) {
                        self.presentation.wrappedValue.dismiss()
                        })
                }
                
                Spacer()
            }
        }.onAppear() {
            self.display.toggle()
        }
    }
    // Sends a rest password request to the session class
    func forgotPassword() {
        load = true
        authError = false
        session.resetPassword(email: userEmail)
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(display: false)
    }
}
