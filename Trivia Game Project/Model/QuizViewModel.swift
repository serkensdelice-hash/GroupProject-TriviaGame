//  QuizViewModel.swift
//  Trivia Game Project
//
//  Created by Serkens Delice on 3/20/26.
//

import Foundation
import Combine

struct Question: Codable, Identifiable, Hashable {
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    var id: String { question } // stable ID
    
    enum CodingKeys: String, CodingKey {
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}


@MainActor
class QuizViewModel: ObservableObject {
    @Published var questions: [TriviaQuestion] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var TimerCountdown: Int = 200
    private var timer : Timer?
    
    

        func startTimer() {
            timer?.invalidate() // reset if already running

            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                DispatchQueue.main.async {
                    if self.TimerCountdown > 0 {
                        self.TimerCountdown -= 1
                    } else {
                        self.timer?.invalidate()
                    }
                }
            }
        }
    

    @objc private func tick() {
        // This runs on the main run loop; class is @MainActor so it's safe
        TimerCountdown += 1
    }

    func stopTotalTimer() {
        timer?.invalidate()
    }

    

    func loadQuestions(amount: Int, category: String, difficulty: String, type: String) async {
        guard questions.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        let urlString = "https://opentdb.com/api.php?amount=\(amount)&category=\(category)&difficulty=\(difficulty)&type=\(type)"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(TriviaResponse.self, from: data)
            questions = decoded.results
        } catch {
            errorMessage = "Error: \(error.localizedDescription)"
            questions = []
        }
        
        isLoading = false
    }
}
