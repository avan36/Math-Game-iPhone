//
//  ContentView.swift
//  Multiplication Test
//
//  Created by Ambrose V on 24/06/2024.
//
import SwiftUI

struct MultiplicationGameView: View {
    @State private var num1 = Int.random(in: 1..<10)
    @State private var num2 = Int.random(in: 1..<10)
    @State private var options = [0, 0, 0]
    @State private var score = 0
    @State private var correctAnswer = 0
    @State private var tries = 0

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
            Text(tries == 0 ? "Score: 0   Let's start!" : tries > 1 ? "Score: \(score) / \(tries) tries" : "Score: \(score) / \(tries) try")
                .font(.headline)
            Spacer()
                .frame(height: 20)
                .navigationTitle("Multiplication!")
                .onAppear {
                    generateAnswers()
                }
        }
    }

    func updateCorrectAnswer(_ tapped: Int) {
        if tapped == correctAnswer {
            score += 1
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
