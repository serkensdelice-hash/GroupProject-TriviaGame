import SwiftUI
import Foundation
import Combine
import UIKit

struct QuizView: View {
    @StateObject private var viewModel = QuizViewModel()
    @State private var submitted = false
    @State private var userAnswers: [UUID: String] = [:]
    @FocusState private var focusedField: UUID?
    
    var amount: Int
    var category: String
    var difficulty: String
    var type: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                // Background
                LinearGradient(
                    colors: [.green],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // CONTENT
                if viewModel.isLoading {
                    ProgressView("Loading Questions...")
                    
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                    
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            
                            // SCORE
                            if submitted {
                                let score = viewModel.questions.filter {
                                    isAnswerCorrect(
                                        user: userAnswers[$0.id, default: ""],
                                        correct: $0.correctAnswer
                                    )
                                }.count
                                
                                Text("Score: \(score)/\(viewModel.questions.count)")
                                    .font(.title2)
                                    .bold()
                                    .padding()
                                    .foregroundColor(.white)
                            }
                            
                            // QUESTIONS
                            ForEach(viewModel.questions) { question in
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    Text(question.question.htmlDecoded)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    TextField(
                                        text: Binding(
                                            get: { userAnswers[question.id, default: ""] },
                                            set: { userAnswers[question.id] = $0 }
                                        ),
                                        prompt: Text("Type your answer")
                                    ) {
                                        EmptyView()
                                    }
                                    .textFieldStyle(.roundedBorder)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .submitLabel(.done)
                                    .focused($focusedField, equals: question.id)
                                    .disabled(submitted)
                                    
                                    if submitted {
                                        let userAnswer = userAnswers[question.id, default: ""]
                                        
                                        if isAnswerCorrect(user: userAnswer, correct: question.correctAnswer) {
                                            Text("✅ Correct")
                                                .foregroundColor(.green)
                                        } else {
                                            Text("❌ Incorrect")
                                                .foregroundColor(.red)
                                            
                                            Text("Correct: \(question.correctAnswer.htmlDecoded)")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(15)
                                .shadow(radius: 3)
                            }
                            
                            // SUBMIT BUTTON
                            Button("Submit Quiz") {
                                submitted = true
                                viewModel.stopTotalTimer()
                                hideKeyboard()
                            }
                            .buttonStyle(.borderedProminent)
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Trivia Quiz")
            .onAppear {
                viewModel.startTimer()
            }
            .onChange(of: viewModel.TimerCountdown) { _, newValue in
                if newValue == 0 && !submitted {
                    submitted = true
                    viewModel.stopTotalTimer()
                }
            }
            .task {
                await viewModel.loadQuestions(
                    amount: amount,
                    category: category,
                    difficulty: difficulty,
                    type: type
                )
            }
        }
    }
}

// Normalize text for answer comparison
@inline(__always)
private func normalizeAnswer(_ text: String) -> String {
    text.htmlDecoded
        .lowercased()
        .replacingOccurrences(of: "&", with: "and")
        .components(separatedBy: CharacterSet.alphanumerics.inverted)
        .joined()
}

// Compare a user answer to the correct answer using normalization
@inline(__always)
func isAnswerCorrect(user: String, correct: String) -> Bool {
    normalizeAnswer(user) == normalizeAnswer(correct)
}

extension String {
    var htmlDecoded: String {
        var result = self
        result = result.replacingOccurrences(of: "&quot;", with: "\"")
        result = result.replacingOccurrences(of: "&#039;", with: "'")
        result = result.replacingOccurrences(of: "&amp;", with: "&")
        result = result.replacingOccurrences(of: "&lt;", with: "<")
        result = result.replacingOccurrences(of: "&gt;", with: ">")
        result = result.replacingOccurrences(of: "&eacute;", with: "é")
        return result
    }
}

// Dismiss the keyboard from anywhere in SwiftUI
private func hideKeyboard() {
    #if canImport(UIKit)
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    #endif
}

