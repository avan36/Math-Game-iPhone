//
//  ContentView.swift
//  Multiplication Test
//
//  Created by Ambrose V on 24/06/2024.
//
import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseFirestore



/*let docData: [String: Any] = [
    "User": "None",
    "Score": 1,
    "dateAdded": Timestamp(date: Date()),
]*/

// Create the document in Firestore

struct MultiplicationGameView: View {
    @StateObject var leaderboardViewModel = LeaderboardViewModel()
    @AppStorage("onboardingFinished") var onboardingFinished = false
    @State private var num1 = Int.random(in: 1..<10)
    @State private var num2 = Int.random(in: 1..<10)
    @State private var isAuthenticated = false
    @State private var options = [0, 0, 0]
    @State private var score = 0
    @State private var correctAnswer = 0
    @State private var tries = 0
    @AppStorage("multiplicationHighScore") private var multiplicationHighScore: Int = 0
    @EnvironmentObject var gameCenterManager: GameCenterManager
    @AppStorage("username") var username = ""
    @State private var wrongAnswerAlert = false
    
    
    var body: some View {
        NavigationStack {
            Spacer()
            HStack {
                Text("What's \(num1) multiplied by \(num2)?")
                    .font(.title)
            }
            ForEach(0..<3) { number in
                Button {
                    updateCorrectAnswer(number)
                } label: {
                    Text("\(options[number])")
                        .font(.largeTitle)
                }
                .frame(width: 125, height: 125)
                .background(.blue.opacity(0.7))
                .clipShape(.rect(cornerRadius: 20))
                .foregroundColor(.white)
            }
            Spacer()
            Text(tries == 0 ? "Score: 0   Let's start!" : "Score: \(score)")
                .font(.title)
            Spacer()
                .frame(height: 20)
                .navigationTitle("Multiplication!")
                .onAppear {
                    generateAnswers()
                }
        Text("Your high score: \(multiplicationHighScore)")
                .padding()
        
        }
        .alert("Wrong answer.", isPresented: $wrongAnswerAlert, actions: {})
        .onAppear {
            gameCenterManager.authenticateGameCenterUser()
            username = gameCenterManager.username
            
        }
        
    }

    func updateCorrectAnswer(_ tapped: Int) {
        if tapped == correctAnswer {
            let newScore = Score(id: UUID().uuidString, user: username, score: score, dateAdded: Date())
            score += 1
            if score > multiplicationHighScore {
                multiplicationHighScore = score
                if !gameCenterManager.username.isEmpty { // Ensure username is not empty
                    let newScore = Score(user: gameCenterManager.username, score: score, dateAdded: Date())
                    leaderboardViewModel.addScore(score: newScore)
                } else {
                    print("Username is empty; cannot save score.")
                }
            }
            
        }
        else {
            wrongAnswerAlert = true
            tries = 0
            score = 0
            
        }
        tries += 1
        generateAnswers()
    }
    
    func generateAnswers() {
        num1 = Int.random(in: 1..<10)
        num2 = Int.random(in: 1..<10)

        let correctResult = num1 * num2
        options = [Int.random(in: 1..<100), Int.random(in: 1..<100), correctResult].shuffled()

        correctAnswer = options.firstIndex(of: correctResult) ?? 0 // Finds index of first correct answer for the first time playing the

    }
}

#Preview {
    MultiplicationGameView()
}
