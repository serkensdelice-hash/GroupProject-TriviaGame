//
//  TriviaModel.swift
//  Trivia Game Project
//
//  Created by Serkens Delice on 3/13/26.
//
import Foundation

struct TriviaResponse: Codable{
    let response_code: Int
    let results: [TriviaQuestion]

    private enum CodingKeys: String, CodingKey {
        case response_code
        case results
    }
}


struct TriviaQuestion: Codable, Identifiable {
    let id = UUID()

    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]

    enum CodingKeys: String, CodingKey {
        case category
        case type
        case difficulty
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }


    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.category = try container.decode(String.self, forKey: .category)
        self.type = try container.decode(String.self, forKey: .type)
        self.difficulty = try container.decode(String.self, forKey: .difficulty)
        self.question = try container.decode(String.self, forKey: .question)
        self.correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
        self.incorrectAnswers = try container.decode([String].self, forKey: .incorrectAnswers)
        // `id` is intentionally not decoded; it keeps its default UUID value.
    }
}

