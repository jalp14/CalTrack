//
//  SessionStore.swift
//  CalTrack
//
//  Created by Jalp on 24/11/2019.
//  Copyright © 2019 jdc0rp. All rights reserved.
//

import Firebase
import FirebaseFirestore
import SwiftUI
import Combine

// **************** Referenced : https://benmcmahen.com/authentication-with-swiftui-and-firebase/ **************** \\

//**************** Class which maintains the current session ****************\\
class SessionStore: ObservableObject {
    //**************** Variables ****************\\
    @State private var isShowingAlert = false
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: User? { didSet { self.didChange.send(self) } }
    var handle: AuthStateDidChangeListenerHandle?
    enum ResultType {
        case Error
        case Success
        case None
    }
    
    // Listen for any changes in the database
    func listen() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                print("Found user : \(user)")
                print("UID : \(user.uid)")
                self.session = User(uid: user.uid, displayName: user.displayName, email: user.email)
            } else {
                print("No user found")
                self.session = nil
            }
        }
    }
    
    // Register new user to the database
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
        
    }
    
    // Authorise existing user
    func signIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    // Delete account of the logged in user
    func deleteAccount( completion:  @escaping (_ resultType: ResultType, _ description: String) -> Void) {
        var result = ResultType.None
        let currentUser = Auth.auth().currentUser
        currentUser?.delete(completion: { (error) in
            if error != nil {
                print((error?.localizedDescription)!)
                result = .Error
                completion(result, error!.localizedDescription)
                return
            }
            result = .Success
            completion(result, "Success")
            print("Deleted Account!")
        })
    }
    
    // Update password of the current user
    func updatePassword(password: String, completion:  @escaping (_ resultType: ResultType, _ description: String) -> Void ) {
        var result = ResultType.None
        let currentUser = Auth.auth().currentUser
        
        currentUser?.updatePassword(to: password, completion: { (error) in
            if (error != nil) {
                print((error?.localizedDescription)!)
                result = .Error
                completion(result, error!.localizedDescription)
                return
            }
            result = .Success
            completion(result, "No Error")
            print("password updated successfully")
        })
    }
    
    // Reset password of existing user
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                print("Failed to send the request : \(error)")
            }
        }
    }
    
    
    // Signout the user from the app
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            self.session = nil
            return true
        } catch {
            return false
        }
    }
    
    // Remove listener
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
}


