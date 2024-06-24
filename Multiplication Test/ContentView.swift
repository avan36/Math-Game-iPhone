//
//  ContentView.swift
//  Multiplication Test
//
//  Created by Ambrose V on 24/06/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var num1 = Int.random(in: 1..<10)
    @State private var num2 = Int.random(in: 1..<10)
    @State private var options = [0,0,0]
    @State private var score = 0
    @State private var correctAnswer = 0
    @State private var tries = 0
    
    var body: some View {
        NavigationView {
            VStack{
                Text("What's \(num1) multiplied by \(num2)?")
                    .font(.title)
                    //.padding(.top)
                
                Spacer()
                
                
                ForEach(0..<3)  {number in
                    Button {
                        updateCorrectAnswer(number)
                    } label: {
                        Text("\(options[number])")
                            .font(.largeTitle)
                    }
                    .frame(width: 100, height: 100)
                    .background(.blue.opacity(0.7))
                    .clipShape(.rect(cornerRadius: 20))
                    .foregroundColor(.white)
                }
                Text(tries == 0 ? "Score: 0   Let's start!"
                     : tries > 1 ?
                     "Score: \(score) / \(tries) tries"
                     : "Score: \(score) / \(tries) try")
                    .font(.headline)
                    .padding()
                
                
                Spacer()
            }
            .navigationTitle("Multiplication!")
            .onAppear {
                generateAnswers()
            }
        }
        .padding()
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
        
        correctAnswer = options.firstIndex(of: correctResult) ?? 0 //Finds index of first correct anser for first time playing the game
        
    }
}

#Preview {
    ContentView()
}
