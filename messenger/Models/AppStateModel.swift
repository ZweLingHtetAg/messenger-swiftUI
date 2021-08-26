//
//  AppStateModel.swift
//  messenger
//
//  Created by Zwel Linn Htet Ag on 23/08/2021.
//

import Foundation
import SwiftUI
//
import Firebase
import FirebaseAuth
import FirebaseFirestore



class AppStateModel: ObservableObject {
    
    @AppStorage("currentUserName") var currentUserName: String = ""
    @AppStorage("currentEmail") var currentEmail: String = ""
    
    @Published var showingSignIn: Bool = true
    @Published var conversations: [String] = []
    @Published var messages: [Message] = []
    
    var database = Firestore.firestore()
    var auth = Auth.auth()
    var otherUserName = ""
    var conversionListener : ListenerRegistration?
    var chatListener : ListenerRegistration?
    init() {
        self.showingSignIn = Auth.auth().currentUser == nil
    }
}

// Search

extension AppStateModel{
    func searchUser(queryText:String,completion: @escaping ([String]) -> Void)
    {
        database.collection("users").getDocuments{snapshot , error in
            
            guard let usernames = snapshot?.documents.compactMap({$0.documentID}),
                  
                error == nil else {
                    completion([])
                    return
            }
            let filtered = usernames.filter({
                $0.lowercased().hasPrefix(queryText.lowercased())
            })
            
            completion(filtered)
        }
    }
}

// Conversation

extension AppStateModel{
    func getConversation()
    {
        conversionListener = database
            .collection("users")
            .document(currentUserName)
            .collection("chats").addSnapshotListener { [weak self] snapshot ,error in
                guard let userNames = snapshot?.documents.compactMap({$0.documentID}),
                      error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self?.conversations = userNames
                }
                
            }
    }
}

// Get - Send Message

extension AppStateModel{
    func observeChat()
    {
        creationConversation()
        
        chatListener = database
            .collection("users")
            .document(currentUserName)
            .collection("chats")
            .document(otherUserName)
            .collection("messages")
            .addSnapshotListener { [weak self] snapshot ,error in
                guard let objects = snapshot?.documents.compactMap({$0.data()}),
                      error == nil else {
                    return
                }
                
                let messages = objects.compactMap({
                    return Message(
                        text: $0["text"] as? String ?? "",
                        type: $0["sender"] as? String == self?.currentUserName ? .sent : .received,
                        created: ISO8601DateFormatter().date(from: $0["created"] as? String ?? "") ?? Date()
                    )
                }).sorted(by: {first,second in
                    return first.created < second.created
                })
                
                DispatchQueue.main.async {
                    print(messages)
                    self?.messages = messages
                }
                
            }
    }
    func sendMessage(text: String)
    {
        let newMessageId = UUID().uuidString
            
        let data = [
            "text" : text,
            "sender" : currentUserName,
            "created" : ISO8601DateFormatter().string(from: Date())
        ]
        
        database
            .collection("users")
            .document(currentUserName)
            .collection("chats")
            .document(otherUserName)
            .collection("messages")
            .document(newMessageId)
            .setData(data)
        
        database
            .collection("users")
            .document(otherUserName)
            .collection("chats")
            .document(currentUserName)
            .collection("messages")
            .document(newMessageId)
            .setData(data)
    }
    
    func creationConversation()
    {
        database
            .collection("users")
            .document(currentUserName)
            .collection("chats")
            .document(otherUserName)
            .setData([
                "created" : "true"
            ])
        
        database
            .collection("users")
            .document(otherUserName)
            .collection("chats")
            .document(currentUserName)
            .setData([
                "created" : "true"
            ])
    }
}


// Sign In and Sign Out

extension AppStateModel{
    func signIn(userName: String,password: String)
    {
        // try to sign in
        
        // get email from database
        
        database.collection("users").document(userName).getDocument { [weak self] snapshot , error in
            
            guard let email = snapshot?.data()?["email"] as? String, error == nil else
            {
                  return
            }
            
            // try to sign in
            self?.auth.signIn(withEmail: email, password: password, completion: {result , error in
                guard error == nil , result != nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.currentEmail = email
                    self?.currentUserName = userName
                    
                    self?.showingSignIn = false
                }
            })
        }
    }
    
    func signUp(email: String,userName: String,password: String)
    {
        // Create Account
        
        auth.createUser(withEmail: email, password: password){ [weak self]
            result, error in
            
            guard result != nil , error == nil else {
                return
            }
        }
        
        // Insert Into the database
        
        let  data =   [
            "email" : email,
            "userName" : userName,
        ]
        
        self.database.collection("users")
            .document(userName)
            .setData(data){ error in
                guard error == nil else{
                    return
                }
                
            }
        DispatchQueue.main.async {
            
            self.currentEmail = email
            self.currentUserName = userName
            self.showingSignIn = false
        }
        
    }
    
    func signOut(){
        do {
            try auth.signOut()
            self.showingSignIn = true
            self.currentUserName = ""
            self.currentEmail = ""
        }
        catch{
            print (error)
        }
    }
}
