//
//  LeaderboardViewMoel.swift
//  Multiplication Test
//
//  Created by Ambrose V on 22/11/24.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Score: Identifiable, Codable {
    var id: String = UUID().uuidString
    var user: String
    var score: Int
    var dateAdded: Date
}

class LeaderboardViewModel: ObservableObject {
    @Published var scores: [Score] = []
    private var db = Firestore.firestore()
    
    func fetchLeaderboard() {
        db.collection("leaderboard")
            .order(by: "score", descending: true)
            .limit(to: 10)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching leaderboard: \(error.localizedDescription)")
                    return
                }
                self.scores = snapshot?.documents.compactMap { document in
                    try? document.data(as: Score.self)
                } ?? []
            }
    }
    
    func addScore(score: Score) {
        let userRef = db.collection("leaderboard").document(score.user)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists { //Check if document exists
                if let existingScore = document.data()?["score"] as? Int, score.score > existingScore {
                    userRef.setData([
                        "id": score.id,
                        "user": score.user,
                        "score": score.score,
                        "dateAdded": Timestamp(date: score.dateAdded)
                    ]) { error in
                        if let error = error {
                            print("Error updating score: \(error.localizedDescription)")
                        } else {
                            print("Score successfully updated")
                        }
                    }
                } else {
                    print("New score is not higher than the existing score. No update made.")
                }
            } else { //Otherwise we add to the database
                userRef.setData([
                    "id": score.id,
                    "user": score.user,
                    "score": score.score,
                    "dateAdded": Timestamp(date: score.dateAdded)
                ]) { error in
                    if let error = error {
                        print("Error adding new user score: \(error.localizedDescription)")
                    } else {
                        print("New user score successfully added")
                    }
                }
            }
        }
    }
}
