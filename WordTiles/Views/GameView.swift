//
//  GameView.swift
//  WordTiles
//
//  Created by Kim on 2024-11-05.
//

import SwiftUI

struct GameView: View {
    private let rows = 5
    private let columns = 5
    
    private let letters = [
        Letter(character: "E", frequency: 12.02, points: 1), Letter(character: "T", frequency: 9.10, points: 1), Letter(character: "A", frequency: 8.12, points: 1), Letter(character: "O", frequency: 7.68, points: 2), Letter(character: "I", frequency: 7.31, points: 2),
        Letter(character: "N", frequency: 6.95, points: 2), Letter(character: "S", frequency: 6.28, points: 2), Letter(character: "R", frequency: 6.02, points: 2), Letter(character: "H", frequency: 5.92, points: 3), Letter(character: "D", frequency: 4.32, points: 3),
        Letter(character: "L", frequency: 3.98, points: 3), Letter(character: "U", frequency: 2.88, points: 4), Letter(character: "C", frequency: 2.71, points: 4), Letter(character: "M", frequency: 2.61, points: 4), Letter(character: "F", frequency: 2.30, points: 4),
        Letter(character: "Y", frequency: 2.11, points: 5), Letter(character: "W", frequency: 2.09, points: 5), Letter(character: "G", frequency: 2.03, points: 5), Letter(character: "P", frequency: 1.82, points: 6), Letter(character: "B", frequency: 1.49, points: 6),
        Letter(character: "V", frequency: 1.11, points: 6), Letter(character: "K", frequency: 0.69, points: 6), Letter(character: "X", frequency: 0.17, points: 7), Letter(character: "Q", frequency: 0.11, points: 8), Letter(character: "J", frequency: 0.10, points: 9),
        Letter(character: "Z", frequency: 0.07, points: 10)
    ]
    
    @State private var score: Int = 0
    @State private var tiles: [Tile] = []
    @State private var completedWords: [CompletedWord] = []
    
    @State private var selectedPositions: [CGPoint] = []
    @State private var selectedLetters: [Letter] = []
    @State private var tileFrames: [CGPoint: CGRect] = [:]
    
    var body: some View {
        VStack {
            ZStack {
                Text("Score: \(score)")
                    .font(.title)
                    .frame(maxWidth: .infinity)
                HStack {
                    Spacer()
                    Button {
                        resetGame()
                    } label: {
                        Image(systemName: "arrow.trianglehead.2.counterclockwise")
                            .font(.title)
                    }
                    .buttonStyle(.plain)
                }
            }
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(completedWords.indices, id: \.self) { completedWordIndex in
                            let completedWord = completedWords[completedWordIndex]
                            Text("\(completedWord.word) +\(completedWord.points)")
                        }
                    }
                    .frame(maxWidth: .infinity,
                           minHeight: geometry.size.height,
                           alignment: .bottomLeading)
                }
            }
            ZStack {
                GridView(tiles: tiles, rows: rows, columns: columns, selectedPositions: $selectedPositions)
                TileSelectionPath(selectedPositions: $selectedPositions, tileFrames: $tileFrames)
            }
            .coordinateSpace(name: "GameView")
            .onAppear {
                generateGrid(rows: rows, columns: columns)
            }
            .onPreferenceChange(TileSelectionPreferenceKey.self) { preferences in
                self.tileFrames = preferences
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged {
                        selectTile(at: $0.location)
                    }
                    .onEnded { _ in
                        completeWord()
                    }
            )
        }
        .padding()
    }
    
    private func generateGrid(rows: Int, columns: Int) {
        var lettersArray: [Letter] = []
        for letter in letters {
            let count = Int(letter.frequency * 10)
            lettersArray += Array(repeating: letter, count: count)
        }
        
        var generatedTiles: [Tile] = []
        for row in 0..<rows {
            for column in 0..<columns {
                let randomLetter = lettersArray.randomElement()!
                let tile = Tile(letter: randomLetter, row: row, column: column)
                generatedTiles.append(tile)
            }
        }
        
        tiles = generatedTiles
    }
    
    private func selectTile(at point: CGPoint) {
        for (gridPosition, frame) in tileFrames {
            if frame.contains(point) {
                handleTileSelection(at: gridPosition)
                break
            }
        }
    }
    
    private func completeWord() {
        let selectedWord = selectedLetters.map { $0.character }.joined()
        if !completedWords.contains(where: { $0.word == selectedWord }), selectedLetters.count > 1 {
            WordValidator.shared.validateWord(selectedWord) { isValid in
                if isValid {
                    let points = selectedLetters.reduce(0) { partialResult, letter in
                        partialResult + letter.points
                    }
                    score += points
                    
                    let completedWord = CompletedWord(word: selectedWord, points: points)
                    completedWords.append(completedWord)
                    
                    print("Valid word: \(completedWord.word) (+\(completedWord.points) points)")
                } else {
                    print("Invalid word: \(selectedWord)")
                }
            }
        }
        clearSelection()
    }
    
    private func clearSelection() {
        selectedPositions.removeAll()
        selectedLetters.removeAll()
    }
    
    private func resetGame() {
        score = 0
        completedWords = []
        clearSelection()
        generateGrid(rows: rows, columns: columns)
    }
    
    private func isAdjacent(_ pos1: CGPoint, _ pos2: CGPoint) -> Bool {
        let dx = abs(Int(pos1.x - pos2.x))
        let dy = abs(Int(pos1.y - pos2.y))
        return (dx <= 1 && dy <= 1) && !(dx == 0 && dy == 0)
    }
    
    private func handleTileSelection(at position: CGPoint) {
        if let lastPosition = selectedPositions.last {
            if position == lastPosition {
                return
            } else if selectedPositions.count >= 2,
                      position == selectedPositions[selectedPositions.count - 2] {
                selectedPositions.removeLast()
                selectedLetters.removeLast()
            } else if isAdjacent(lastPosition, position) &&
                        !selectedPositions.contains(position) {
                selectedPositions.append(position)
                if let tile = tiles.first(where: {
                    $0.row == Int(position.y) && $0.column == Int(position.x)
                }) {
                    selectedLetters.append(tile.letter)
                }
            }
        } else {
            selectedPositions.append(position)
            if let tile = tiles.first(where: {
                $0.row == Int(position.y) && $0.column == Int(position.x)
            }) {
                selectedLetters.append(tile.letter)
            }
        }
    }
}

#Preview {
    GameView()
}
