//
//  TriviaService.swift
//  Trivia Game Project
//
//  Created by Serkens Delice on 3/13/26.
//

import Foundation
class TriviaService {
    
    func fetchTrivia(amount: Int,
                     category: String,
                     difficulty: String,
                     type: String) async throws -> [TriviaQuestion] {
        
        let urlString =
        "https://opentdb.com/api.php?amount=\(amount)&category=\(category)&difficulty=\(difficulty)&type=\(type)"
        
        guard let url = URL(string: urlString) else {
            return []
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoded = try JSONDecoder().decode(TriviaResponse.self, from: data)
        
        return decoded.results
    }
}
