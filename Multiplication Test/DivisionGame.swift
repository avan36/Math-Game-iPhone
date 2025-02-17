//
//  DivisionGame.swift
//  Multiplication Test
//
//  Created by Ambrose V on 13/08/2024.
//
import SwiftUI
import GameKit

struct DivisionGame: View {
    @State private var mainNumber = Int.random(in: 30..<332)
    @State private var userSelections = Array(repeating: false, count: 12)
    @State private var oldScore = 0
    @State private var score = 0
    @State private var isAuthenticated = false
    @AppStorage("divisionHighScore") private var divisionHighScore = 0
    
    private var correctAnswers: [Bool] {
        (1...12).map { mainNumber % $0 == 0 }
    }

    private var continueAllowed: Bool {
        for i in 0..<12 {
            if correctAnswers[i] && !userSelections[i] {
                return false
            }
        }
        return true
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("Tap all the numbers that \(mainNumber) is divisible by:")
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .padding()

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                    ForEach(0..<12) { index in
                        let number = index + 1
                        Button(action: {
                            if userSelections[index] != true {
                                userSelections[index].toggle()
                                updateScore(for: index)
                            }
                        }) {
                            Text(String(number))
                                .font(.title2)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding()
                                .background(buttonColor(for: index))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 100, height: 100)
                }

                Spacer()

                HStack {
                    Spacer()
                    Text(oldScore == 0 ? "Score: \(score)" : "Score: \(oldScore) + \(score)")
                        .font(.title)
                    Spacer()
                }

                Spacer()

                HStack {
                    Button(action: {
                        continueButton()
                    }) {
                        Text("Continue")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .foregroundColor(.white)
                            .background(continueAllowed ? .blue.opacity(0.7) : .gray)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: 200, height: 60)
                    }
                    .disabled(!continueAllowed)
                }

                Spacer().frame(height: 20)
            }
            .navigationTitle("Division!")
            .onAppear {
                userSelections[0] = true
                authenticateLocalPlayer()
            }
        }
    }

    private func continueButton() {
        mainNumber = Int.random(in: 30..<332)
        while isPrime(mainNumber) {
            mainNumber = Int.random(in: 30..<332)
        }
        oldScore += score
        divisionHighScore = max(divisionHighScore, oldScore)
        submitScore(score: oldScore)
        score = 0
        userSelections = Array(repeating: false, count: 12)
        userSelections[0] = true
    }

    private func buttonColor(for index: Int) -> Color {
        if userSelections[index] {
            return correctAnswers[index] ? .green.opacity(0.7) : .red.opacity(0.7)
        } else {
            return .blue.opacity(0.7)
        }
    }

    private func updateScore(for index: Int) {
        if correctAnswers[index] == userSelections[index] {
            score += 1
        } else {
            score -= 1
        }
    }

    private func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = { viewController, error in
            if let viewController = viewController {
            } else if localPlayer.isAuthenticated {
                self.isAuthenticated = true
            } else {
                print("Game Center Authentication failed: \(error?.localizedDescription ?? "No error")")
            }
        }
    }

    private func submitScore(score: Int) {
        let scoreReporter = GKScore(leaderboardIdentifier: "YOUR_LEADERBOARD_ID")
        scoreReporter.value = Int64(score)
        
        GKScore.report([scoreReporter]) { error in
            if let error = error {
                print("Error reporting score: \(error.localizedDescription)")
            } else {
                print("Score reported successfully!")
            }
        }
    }
}

struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        DivisionGame()
    }
}
