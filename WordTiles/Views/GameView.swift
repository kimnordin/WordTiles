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
    
    private let letterFrequencies = [
        ("E", 12.02), ("T", 9.10), ("A", 8.12), ("O", 7.68), ("I", 7.31),
        ("N", 6.95), ("S", 6.28), ("R", 6.02), ("H", 5.92), ("D", 4.32),
        ("L", 3.98), ("U", 2.88), ("C", 2.71), ("M", 2.61), ("F", 2.30),
        ("Y", 2.11), ("W", 2.09), ("G", 2.03), ("P", 1.82), ("B", 1.49),
        ("V", 1.11), ("K", 0.69), ("X", 0.17), ("Q", 0.11), ("J", 0.10), ("Z", 0.07)
    ]
    
    @State private var score: Int = 0
    @State private var tiles: [Tile] = []
    @State private var completedWords: [String] = []
    
    @State private var selectedPositions: [CGPoint] = []
    @State private var selectedLetters: [String] = []
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
                            Text(completedWord)
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
            .background(.white)
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
        var lettersArray: [String] = []
        for (letter, frequency) in letterFrequencies {
            let count = Int(frequency * 10)
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
        let selectedWord = selectedLetters.joined()
        if !completedWords.contains(selectedWord) {
            WordValidator.shared.validateWord(selectedWord) { isValid in
                if isValid {
                    let points = selectedWord.count
                    score += points
                    completedWords.append(selectedWord)
                    
                    print("Valid word: \(selectedWord) (+\(points) points)")
                } else {
                    print("Invalid word: \(selectedWord)")
                }
            }
            clearSelection()
        } else {
            print("Word already guessed: \(selectedWord)")
            clearSelection()
        }
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
