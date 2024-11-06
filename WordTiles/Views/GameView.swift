//
//  GameView.swift
//  WordTiles
//
//  Created by Kim on 2024-11-05.
//

import SwiftUI

struct GameView: View {
    private let rows = 6
    private let columns = 6
    
    private let letters = [
        Letter(character: "A"), Letter(character: "B"), Letter(character: "C"), Letter(character: "D"),
        Letter(character: "E"), Letter(character: "F"), Letter(character: "G"), Letter(character: "H"),
        Letter(character: "I"), Letter(character: "J"), Letter(character: "K"), Letter(character: "L"),
        Letter(character: "M"), Letter(character: "N"), Letter(character: "O"), Letter(character: "P"),
        Letter(character: "Q"), Letter(character: "R"), Letter(character: "S"), Letter(character: "T"),
        Letter(character: "U"), Letter(character: "V"), Letter(character: "W"), Letter(character: "X"),
        Letter(character: "Y"), Letter(character: "Z")
    ]
    
    @State private var score: Int = 0
    @State private var tiles: [Tile] = []
    @State private var completedWords: [CompletedWord] = []
    
    @State private var selectedPositions: [CGPoint] = []
    @State private var selectedLetters: [Letter] = []
    @State private var tileFrames: [CGPoint: CGRect] = [:]
    
    var body: some View {
        VStack {
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
                CompletedWordsView
            }
            .padding()
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
    }
    
    @ViewBuilder private var CompletedWordsView: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
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
