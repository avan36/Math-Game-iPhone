//
//  SwiftUIView.swift
//  Multiplication Test
//
//  Created by Ambrose V on 26/09/2024.
//

import SwiftUI

struct WordGameView: View {
    @ObservedObject var viewModel = WordGameViewModel()
    var body: some View {
        
        NavigationStack { //spacing: 20
            VStack {
                HStack {
                    Text(viewModel.currentDefinition)
                        .font(.title)
                }
                .frame(maxWidth: .infinity)
                
                
                ForEach(viewModel.choices, id: \.self) { choice in
                    Button(action: {
                        viewModel.checkAnswer(choice)
                        
                    }) {
                        Text(choice)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
                
                
                if let isCorrect = viewModel.isCorrect {
                    Text(isCorrect ? "Correct" : "Wrong!")
                        .font(.headline)
                        .foregroundColor(isCorrect ? .green : .red)
                    
                }
                Spacer()
                    .frame(height: 50)
                Button("Next question") {
                    viewModel.generateNewQuestion()
                }
                .disabled(!viewModel.answerSelected)
                .padding()
                .background(viewModel.answerSelected ? Color.blue : Color.secondary)
                .foregroundColor(.white)
                .cornerRadius(10)
                Spacer()
                    .frame(height: 30)
                Text("Score: \(viewModel.score)")
                
                    .navigationTitle("Word matching!")
            }
            
            .padding()
            .onAppear() {
                viewModel.generateNewQuestion()
            }
            
        }
    }
}


class WordGameViewModel: ObservableObject {
    @Published var words: [WordDefinition] = []
    @Published var currentDefinition: String = ""
    @Published var choices: [String] = []
    @Published var correctAnswer: String = ""
    @Published var isCorrect: Bool? = nil
    @Published var answerSelected: Bool = false
    @Published var score = 0
    struct WordDefinition: Codable {
        let word: String
        let definition: String
    }
    
    init() {
        loadWordsFromJSON()
        //generateNewQuestion()
    }
    
    /*func returnScore() -> Int {
        return score
    }*/
    
    private func loadWordsFromJSON() {
        guard let url = Bundle.main.url(forResource: "words", withExtension: "json") else {
            print("Couldn't find words.json file")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedWords = try JSONDecoder().decode([WordDefinition].self, from: data)
            words = decodedWords
        } catch {
            print("Failed to decode words.json: \(error.localizedDescription)")
        }
    }
    
    func generateNewQuestion() {
        isCorrect = nil
        answerSelected = false
        
        guard !words.isEmpty else { return }
        words.shuffle()
        
        let correctWord = words.first!
        correctAnswer = correctWord.word
        currentDefinition = correctWord.definition
        
        var randomWords = Array(words.prefix(4).map { $0.word })
        
        if !randomWords.contains(correctAnswer) {
            randomWords.removeLast()
            randomWords.append(correctAnswer)
        }
        
        choices = randomWords.shuffled()
        
    }
    
    func checkAnswer(_ word: String) {
        if !answerSelected {
            isCorrect = word == correctAnswer
            if word == correctAnswer {
                playSound(sound: "sound-ding", type: "mp3")
                score += 1
                answerSelected = true
            }
        }
    }
}

struct SwiftUIView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    let mockViewModel = WordGameViewModel()
    WordGameView(viewModel: mockViewModel)
}
