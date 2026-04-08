import SwiftUI

struct ScoreView: View {
    let score: Int
    let total: Int
    let questions: [TriviaQuestion]
    let userAnswers: [UUID: String]
    let onPlayAgain: () -> Void

    private var percentage: Double {
        total > 0 ? Double(score) / Double(total) : 0
    }

    private var resultInfo: (emoji: String, message: String) {
        switch percentage {
        case 1.0:
            return ("🏆", "Perfect Score!")
        case 0.8 ..< 1.0:
            return ("🌟", "Great Job!")
        case 0.6 ..< 0.8:
            return ("👏", "Well Done!")
        case 0.4 ..< 0.6:
            return ("💪", "Keep Practicing!")
        default:
            return ("📚", "Don't Give Up!")
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.indigo, Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {

                    // SCORE SUMMARY
                    VStack(spacing: 8) {
                        Text(resultInfo.emoji)
                            .font(.system(size: 72))
                            .padding(.top, 40)

                        Text("\(score)/\(total)")
                            .font(.system(size: 80, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)

                        Text("Your Score")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))

                        Text(resultInfo.message)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 4)
                    }

                    // ANSWER BREAKDOWN
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Answer Breakdown")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.85))
                            .padding(.horizontal)

                        ForEach(questions.indices, id: \.self) { index in
                            let question = questions[index]
                            let userAnswer = userAnswers[question.id, default: ""]
                            let correct = isAnswerCorrect(user: userAnswer, correct: question.correctAnswer)

                            VStack(alignment: .leading, spacing: 6) {
                                HStack(alignment: .top, spacing: 8) {
                                    Text("\(index + 1).")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.secondary)
                                    Text(question.question.htmlDecoded)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .fixedSize(horizontal: false, vertical: true)
                                }

                                if correct {
                                    Label("Correct", systemImage: "checkmark.circle.fill")
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                } else {
                                    Label("Incorrect", systemImage: "xmark.circle.fill")
                                        .font(.subheadline)
                                        .foregroundColor(.red)

                                    if !userAnswer.isEmpty {
                                        Text("Your answer: \(userAnswer.htmlDecoded)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }

                                    Text("Correct: \(question.correctAnswer.htmlDecoded)")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                            .padding(.horizontal)
                        }
                    }

                    // PLAY AGAIN
                    Button(action: onPlayAgain) {
                        HStack(spacing: 10) {
                            Image(systemName: "arrow.clockwise")
                            Text("Play Again")
                                .fontWeight(.bold)
                        }
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                colors: [.green, .teal],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: .green.opacity(0.45), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
