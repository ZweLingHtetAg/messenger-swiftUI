//
//  messengerApp.swift
//  messenger
//
//  Created by Zwel Linn Htet Ag on 23/08/2021.
//

import SwiftUI
import Firebase

@main
struct messengerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate: AppDelegate
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ConversationView()
            .environmentObject(AppStateModel())
            
            //.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    class AppDelegate: NSObject, UIApplicationDelegate{
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launghOptions:
                        [UIApplication.LaunchOptionsKey:Any]? = nil) -> Bool {
            
            FirebaseApp.configure()
            return true
        }
    }
}
