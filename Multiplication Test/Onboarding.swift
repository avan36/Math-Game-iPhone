//
//  Onboarding.swift
//  QuickQuiz
//
//  Created by Ambrose V on 23/11/24.
//

import SwiftUI
import GameKit

struct Onboarding: View {
    @AppStorage("onboardingFinished") var onboardingFinished = false
    @State private var isAuthenticating = false
    @State private var showError = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Welcome to QuickQuiz!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                authenticateUser()
            }) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .disabled(isAuthenticating)
            .padding(.horizontal)
           .padding(.bottom, 40)
        }
        .alert("Sign into game center to access the app to get access to leaderboards, etc", isPresented: $showError) {
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 1.0, green: 0.6, blue: 0.0), // Orange
                    Color(red: 0.8, green: 0.0, blue: 0.0)  // Red
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .edgesIgnoringSafeArea(.all) // Makes the gradient fill the entire screen
    }
    
    private func authenticateUser() {
            isAuthenticating = true
            
            GKLocalPlayer.local.authenticateHandler = { viewController, error in
                if let viewController = viewController {
                    // If Game Center requires a sign-in, present the view controller
                    UIApplication.shared.windows.first?.rootViewController?.present(viewController, animated: true)
                } else if GKLocalPlayer.local.isAuthenticated {
                    // User is authenticated
                    isAuthenticating = false
                    onboardingFinished = true
                } else {
                    // Authentication failed
                    isAuthenticating = false
                    showError = true
                    
                }
            }
        }
}

#Preview {
    Onboarding()
}
