//
//  LeaderboardView.swift
//  Multiplication Test
//
//  Created by Ambrose V on 22/11/24.
//

import SwiftUI
import GameKit

struct SettingsView: View {
    @StateObject private var viewModel  = LeaderboardViewModel()
    @AppStorage("onboardingFinished") var onboardingFinished = false
    @AppStorage("username") var username = ""
    @AppStorage("multiplicationHighScore") var multiplicationHighScore = 0
    @AppStorage("divisionHighScore") private var divisionHighScore = 0
    @AppStorage("wordGameHighScore") private var wordGameHighScore = 0
    @AppStorage("lifeTimeScore") private var lifeTimeScore = 0
    @State private var isAuthenticated = false
    @EnvironmentObject var gameCenterManager: GameCenterManager
    var body: some View {
        
        NavigationStack {
            Form {
                Section {
                    Text("Your Settings")
                        .font(.title)
                        .fontWeight(.bold)
                    HStack {
                        Text("Username:")
                            .fontWeight(.bold)
                        TextField("Enter your username", text: $gameCenterManager.username)
                    }
                    HStack {
                        Text("Multiplication high score: \(multiplicationHighScore)")
                        
                        Button(action: {
                            multiplicationHighScore = 0
                            lifeTimeScore = wordGameHighScore + divisionHighScore + multiplicationHighScore
                        }, label: {
                            Text("Reset")
                        })
                    }
                    HStack {
                        Text("Division high score: \(divisionHighScore)")
                        Button(action: {
                            multiplicationHighScore = 0
                            lifeTimeScore = wordGameHighScore + divisionHighScore + multiplicationHighScore
                        }, label: {
                            Text("Reset")
                        })
                    }
                    HStack {
                        Text("Word game high score: \(wordGameHighScore)")
                        Button(action: {
                            wordGameHighScore = 0
                            lifeTimeScore = wordGameHighScore + divisionHighScore + multiplicationHighScore
                        }, label: {
                            Text("Reset")
                        })
                    }
                    
                    Text("Your combined score: \(lifeTimeScore)")
                        .fontWeight(.semibold)
                }
                Text("Leaderboard")
                    .font(.title)
                    .fontWeight(.bold)
                List(viewModel.scores) { score in
                    VStack {
                        HStack {
                            Text(score.user)
                                .font(.headline)
                            Text("\(score.score)")
                                .font(.subheadline)
                        }
                        Spacer()
                    }
                } //:LIST
                
                Section {
                    Button("Restart entirely") {
                        onboardingFinished = false
                        multiplicationHighScore = 0
                        divisionHighScore = 0
                        wordGameHighScore = 0
                    }
                }
            }
            .onAppear {
                viewModel.fetchLeaderboard()
                gameCenterManager.authenticateGameCenterUser()
                lifeTimeScore = wordGameHighScore + divisionHighScore + multiplicationHighScore
            }
        }//:NAVSTACK
    }
    
    
}

#Preview {
    SettingsView()
}
