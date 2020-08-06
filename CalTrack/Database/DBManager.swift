//
//  GoalObject.swift
//  CalTrack
//
//  Created by Jalp on 09/03/2020.
//  Copyright © 2020 jdc0rp. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import Firebase
import Combine

//**************** Performs CRUD Operation for Database ****************\\
class DBManager : ObservableObject {
// **************** Variables **************** \\
    @Published var previousGoals = [goals]()
    @Published var currentIntake = 0.0
    @Published var currentGoal = 0.0
    enum ResultType {
        case Error
        case Success
        case None
    }
    
    // Singleton Class
    static let shared = DBManager()
    init(){}
    
    
    //**************** CREATE ****************\\
    
    // Add a new goal for the current user
    func addGoal(goal: String, session: SessionStore, completion: @escaping (_ resultType : ResultType) -> Void) {
        var result = ResultType.None
        let db = Firestore.firestore()
        db.collection("goals").document()
            .setData(["goal": goal, "userid" : session.session!.uid, "date": Date.getCurrentDate()]) { (error) in
                if error != nil {
                    print((error?.localizedDescription)!)
                    result = .Error
                    completion(result)
                    return
                } else {
                    result = .Success
                    completion(result)
                }
        }
    }
    
    // Add new intake for the current user
    func addIntake(intake: Double, session: SessionStore, completion: @escaping (_ resultType : ResultType) -> Void) {
        print("TRACK FOOD METHOD CALLED")
        print("Current intake before setting new one is : \(self.currentIntake)")
        var result = ResultType.None
        let db = Firestore.firestore()
        // New Document Reference
        db.collection("intakes").document()
            .setData(["intake": intake, "date": Date.getCurrentDate(), "userid" : session.session!.uid]) { (error) in
                if error != nil {
                    print((error?.localizedDescription)!)
                    result = .Error
                    completion(result)
                    return
                } else {
                    print("Updating intake")
                    self.readIntake(session: session)
                    result = .Success
                    completion(result)
                }
        }
    }
    
    
    //****************  READ  ****************\\
    
    // Reads the total intake for today
    func readIntake(session: SessionStore) {
        print("GET INTAKE METHOD CALLED")
        var tempInk = 0.0
        let db = Firestore.firestore()
        // DB Query
        db.collection("intakes")
            .whereField("userid", isEqualTo: session.session!.uid)
            .whereField("date", isEqualTo: Date.getCurrentDate())
            .addSnapshotListener { (snap,error) in
                if error != nil {
                    print((error?.localizedDescription)!)
                    return
                } else {
                    print("Snapshot Returned Count : \(snap!.count)")
                    if (snap!.count == 0) {
                        print("Query Returned no result")
                    } else {
                        tempInk = 0.0
                        for i in snap!.documentChanges {
                            let intake = i.document.get("intake") as! Double
                            print(intake)
                            tempInk += intake
                        }
                    }
                    self.currentIntake = tempInk
                }
        }
    }
    
    // Read the current goal
    func readGoal(session: SessionStore) {
        let db = Firestore.firestore()
        // New DB Query
        db.collection("goals")
            .whereField("userid", isEqualTo: session.session!.uid)
            .whereField("date", isEqualTo: Date.getCurrentDate())
            .addSnapshotListener { (snap,error) in
                if error != nil {
                    print((error?.localizedDescription)!)
                    return
                }
                if (snap!.documents.count >= 1) {
                    let res = snap!.documents.first?.get("goal") as! String
                    print("Goal for today : \(res)")
                    let goal = Double(res)
                    self.currentGoal = goal ?? 0.0
                } else {
                    self.currentGoal = 0.0
                }
        }
    }
    
    // Reads all the goals set by the curent user
    func readAllGoals(session : SessionStore) {
        var tempArray = [goals]()
        var aGoal : goals?
        let db = Firestore.firestore()
        
        self.previousGoals.removeAll()
        db.collection("goals").whereField("userid", isEqualTo: session.session!.uid).addSnapshotListener { (snap, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            for i in snap!.documents {
                let goal = i.get("goal") as! String
                let userid = i.get("userid") as! String
                let date = i.get("date") as! String
                print("Previous Goal: \(goal)")
                aGoal = goals(goal: goal, userid: userid, date: date)
                tempArray.append(aGoal!)
            }
            self.previousGoals = tempArray
        }
    }
    
    //**************** UPDATE ****************\\
    
    // Updates current goal of the user
    func updateGoal(goal: String, session: SessionStore, completion: @escaping (_ resultType : ResultType) -> Void) {
        var result = ResultType.None
        let db = Firestore.firestore()
        let path = db.collection("goals")
            .whereField("userid", isEqualTo: session.session!.uid).whereField("date", isEqualTo: Date.getCurrentDate())
        
        path.getDocuments { (query, error) in
            if error != nil {
                print("Error fetching")
                result = .Error
                completion(result)
                return
            } else if query!.documents.count == 0 {
                self.addGoal(goal: goal, session: session, completion: {results in
                    if (results == .Error) {
                        result = .Error
                        completion(result)
                    } else {
                        result = .Success
                        completion(result)
                    }
                })
            } else {
                query!.documents[0].reference.updateData(["goal": goal]) { (error) in
                    if (error != nil) {
                        return
                    }
                    result = .Success
                    completion(result)
                }
            }
        }
    }
    
    //**************** DELETE ****************\\
    // No Operation for now
}

