//
//  Multiplication_TestApp.swift
//  Multiplication Test
//
//  Created by Ambrose V on 24/06/2024.
//

import SwiftUI
import GameKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct Multiplication_TestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("onboardingFinished") var onboardingFinished = false
    //let db = Firestore.firestore()
    var db: Firestore {
        return Firestore.firestore()
    }
    
    var body: some Scene {
        WindowGroup {
            if onboardingFinished {
                AppSwitcher()
                    .environmentObject(GameCenterManager.shared)
            } else {
                Onboarding()
                    .environmentObject(GameCenterManager.shared)
            }
        }
    }
}
