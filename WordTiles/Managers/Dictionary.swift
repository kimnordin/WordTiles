//
//  Dictionary.swift
//  WordTiles
//
//  Created by Kim on 2024-11-05.
//

import Foundation

class Dictionary {
    static let shared = Dictionary()
    private(set) var words: Set<String> = []
    
    private init() {
        loadDictionary()
    }
    
    private func loadDictionary() {
        if let url = Bundle.main.url(forResource: "dictionary", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                if let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let allWords = jsonDictionary.keys.map { $0.lowercased() }
                    words = Set(allWords)
                    print("Loaded \(words.count) words into the dictionary.")
                }
            } catch {
                print("Error loading dictionary: \(error)")
            }
        } else {
            print("Dictionary file not found.")
        }
    }
}
