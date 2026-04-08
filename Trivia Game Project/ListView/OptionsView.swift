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
            Form {
                Stepper("Number of Questions: \(amount)", value: $amount, in: 1...20)
                
                Picker("Difficulty", selection: $difficulty) {
                    Text("Easy").tag("easy")
                    Text("Medium").tag("medium")
                    Text("Hard").tag("hard")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Picker("Type", selection: $type) {
                    Text("Typing Questions").tag("multiple")
                    Text("True / False").tag("boolean")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                NavigationLink("Start Quiz",
                               destination: QuizView(amount: amount,
                                                     category: category,
                                                     difficulty: difficulty,
                                                     type: type))
            }
            .navigationTitle("Trivia Options")
            }
        
        }
    }

