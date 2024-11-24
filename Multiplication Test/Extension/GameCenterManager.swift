//
//  GameCenterManager.swift
//  Multiplication Test
//
//  Created by Ambrose V on 23/11/24.
//

import Foundation
import GameKit


class GameCenterManager: ObservableObject {
    @Published var username: String = ""
    static let shared = GameCenterManager()
    private init() {} //prevents direct initialization
    
    public func authenticateGameCenterUser() {
            let localPlayer = GKLocalPlayer.local
            
            localPlayer.authenticateHandler = { viewController, error in
                if let viewController = viewController {
                    // Present the Game Center login view
                    if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                        rootViewController.present(viewController, animated: true)
                    }
                } else if localPlayer.isAuthenticated {
                    // Update the username with the Game Center displayName
                    self.username = localPlayer.displayName
                } else if let error = error {
                    print("Error authenticating Game Center user: \(error.localizedDescription)")
                }
            }
    }
    
    
}
