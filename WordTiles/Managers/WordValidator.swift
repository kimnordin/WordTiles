//
//  WordValidator.swift
//  WordTiles
//
//  Created by Kim on 2024-11-05.
//

import Foundation

class WordValidator {
    static let shared = WordValidator()
    private let localDictionary = Dictionary.shared
    
    private init() {}
    
    func validateWord(_ word: String, completion: @escaping (Bool) -> Void) {
        let sanitizedWord = word.lowercased()
        let isValid = localDictionary.words.contains(sanitizedWord)
        completion(isValid)
    }
}
