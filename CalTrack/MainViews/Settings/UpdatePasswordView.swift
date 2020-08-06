//
//  UpdatePasswordView.swift
//  CalTrack
//
//  Created by Jalp on 02/05/2020.
//  Copyright © 2020 jdc0rp. All rights reserved.
//

import SwiftUI


//**************** View for Password Update ****************\\
struct UpdatePasswordView: View {
// ****************  Variables  **************** \\
    @EnvironmentObject var session: SessionStore
    @Environment(\.presentationMode) var presentation
    @State var userPassword: String = ""
    @State var isShowingSuccessAlert = false
    @State var alertMsg = ""
    @State var alertMsgBody = ""
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
                    Text("Update Password")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .bold()
                        .frame(alignment: .leading)
                }
                Spacer()
                
                VStack {
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
                            .keyboardType(.default)
                    }
                }
                    // ****************  Modifier Properties for View  **************** \\
                    .frame(width: 360, height: 80)
                    .background(VisualBlur(blurStyle: .systemMaterial))
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)).opacity(0.3), radius: 20, x: 10, y: 10)
                
                Spacer()
                
                Button(action: {
                    self.updatePassword()
                }) {
                    Text("Update Password")
                        // ****************  Modifier Properties for Text  **************** \\
                        .foregroundColor(.black)
                        .frame(minWidth: 0, maxWidth: ScreenBounds.deviceWidth - 200)
                        .padding(12)
                        .padding(.horizontal, 30)
                        .background(Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 0.8767055458, green: 0.1087125435, blue: 0.1915467579, alpha: 1)).opacity(0.2), radius: 16, x: 0, y: 20)
                    // Shows an alert for updating password
                }.alert(isPresented: $isShowingSuccessAlert) {
                    Alert(title: Text(alertMsg), message: Text(alertMsgBody), dismissButton: .default(Text("Okay")) {
                        self.presentation.wrappedValue.dismiss()
                        })
                }
                Spacer()
            }
        }
    }
    // Update the password
    func updatePassword() {
        self.session.updatePassword(password: self.userPassword, completion: {result,msg  in
            if (result == .Success) {
                // If Completion is successful print success message
                self.alertMsg = "Success!"
                self.alertMsgBody = "Your password has been updated"
                self.isShowingSuccessAlert.toggle()
            } else if (result == .Error) {
                // If Completion is not successful print error message
                self.alertMsg = "Error"
                self.alertMsgBody = "msg"
            }
        })
    }
}

