//
//  SettingsView.swift
//  CalTrack
//
//  Created by Dev on 08/12/2019.
//  Copyright © 2019 jdc0rp. All rights reserved.
//

import SwiftUI

// Settings for the app
struct SettingsView: View {
// ****************  Variables  **************** \\
    @EnvironmentObject var session: SessionStore
    @State var isShowingUpdatePasswordView = false
    @State var isShowingAlert = false
    @State var isShowingAlertConfirmation = false
    @State var alertMsgBody = ""
    @State var alertMsg = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Current User : \((session.session?.email ?? "No User Found"))")
                    .bold()
                    .font(.headline)
                Spacer()
                Button(action: {self.session.signOut()}) {
                    Text("Logout")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.primary)
                        .cornerRadius(13)
                }
                Spacer()
                Button(action: {self.isShowingUpdatePasswordView.toggle()}) {
                    Text("Update Password")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.primary)
                        .cornerRadius(13)
                }.sheet(isPresented: $isShowingUpdatePasswordView, content: {
                    UpdatePasswordView(display: true).environmentObject(self.session)
                })
                Spacer()
                Button(action: {self.isShowingAlert = true}) {
                    Text("Delete Account")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.primary)
                        .cornerRadius(13)
                    // Shows warning alert when deleting account
                }.alert(isPresented: $isShowingAlert) {
                    Alert(title: Text("Warning!"), message: Text("This will permanently delete your account and all the data associated with it"), primaryButton: .default(Text("Okay")) {self.deleteAccount()},
                          secondaryButton: .default(Text("Cancel")){
                            // Do Nothing
                        })
                }
                Text("")
                    // Shows alert when deleting account
                    .alert(isPresented: $isShowingAlertConfirmation) {
                        Alert(title: Text(alertMsg), message: Text(alertMsgBody), dismissButton: .default(Text("Okay")) {})
                }
                Spacer()
            }.navigationBarTitle("Settings")
        }
    }
    //Deletes Account
    func deleteAccount() {
        self.session.deleteAccount { (result, msg) in
            // If Completion returns error print error messagea
            if (result == .Error) {
                self.alertMsg = "Error"
                self.alertMsgBody = msg
                self.isShowingAlertConfirmation = true
                // If Completion retruns success print success message
            } else if (result == .Success) {
                self.alertMsg = "Success"
                self.alertMsgBody = "Your account has been deleted"
                self.isShowingAlertConfirmation = true
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


