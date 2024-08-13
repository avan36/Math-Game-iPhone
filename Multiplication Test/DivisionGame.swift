//
//  DivisionGame.swift
//  Multiplication Test
//
//  Created by Ambrose V on 13/08/2024.
//

import SwiftUI

struct DivisionGame: View {
    @State private var mainNumber = Int.random(in: 30..<332)
    
    @State private var userSelections = Array(repeating: false, count: 12)

    @State private var oldScore = 0
    @State private var score = 0
    
    private var correctAnswers: [Bool] {
        (1...12).map {mainNumber % $0 == 0}
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
        VStack(alignment: .leading) {
        Text("Tap all the numbers that  \(mainNumber) is divisible by:")
                .font(.title2)
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
            ForEach (0..<12) { index in
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
                Spacer()
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
                Spacer()
            }
            
        }
        .padding()
        .onAppear {
            userSelections[0] = true
        }
    }
    
    private func continueButton() {
        mainNumber = Int.random(in: 30..<332)
        oldScore += score
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
}

#Preview {
    DivisionGame()
}
