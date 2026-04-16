//
//  OptionView.swift
//  Trivia Game Project
//
//  Created by Serkens Delice on 3/13/26.
//

import SwiftUI

struct OptionsView: View {
    @State private var amount = 5
    @State private var category = ""
    @State private var difficulty = "easy"
    @State private var type = "multiple"
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.blue , Color.green],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                
                Form {
                    Section(header: Text("Quiz Setup")) {
                        Stepper("Questions: \(amount)", value: $amount, in: 1...20)
                    }
                    
                    Section(header: Text("Difficulty")) {
                        Picker("Difficulty", selection: $difficulty) {
                            Label("Easy", systemImage: "leaf").tag("easy")
                            Label("Medium", systemImage: "flame").tag("medium")
                            Label("Hard", systemImage: "bolt").tag("hard")
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Section(header: Text("Question Type")) {
                        Picker("Type", selection: $type) {
                            Text("Typing").tag("multiple")
                            Text("True / False").tag("boolean")
                        }
                        .pickerStyle(.segmented)
                    }
                    Section {
                        NavigationLink(
                            destination: QuizView(
                                amount: amount,
                                category: category,
                                difficulty: difficulty,
                                type: type
                            )
                        ) {
                            Text("Start Quiz")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.black)
                                .cornerRadius(12)
                        }
                    }
                }
                        .scrollContentBackground(.hidden)
                }
                .navigationTitle("Trivia Options")
            }
            
        }
    }
