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
    
    private var randomLetters: [Letter] {
        var randomLetters: [Letter] = []
        for letter in letters {
            let count = Int(letter.frequency * 10)
            randomLetters += Array(repeating: letter, count: count)
        }
        return randomLetters
    }
    
    @State private var score: Int = 0
    @State private var tiles: [Tile] = []
    @State private var completedWords: [CompletedWord] = []
    
    @State private var selectedPositions: [CGPoint] = []
    @State private var selectedTiles: [Tile] = []
    @State private var tileFrames: [CGPoint: CGRect] = [:]
    
    var body: some View {
        GeometryReader { geometry in
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
                    GridView(tiles: tiles, rows: rows, columns: columns, maxHeight: geometry.size.height / 2, selectedPositions: $selectedPositions)
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
                .frame(maxWidth: .infinity, minHeight: geometry.size.height, alignment: .bottomLeading)
            }
        }
    }
    
    private func clearSelection() {
        selectedPositions.removeAll()
        selectedTiles.removeAll()
    }
    
    private func resetGame() {
        score = 0
        completedWords = []
        clearSelection()
        generateGrid(rows: rows, columns: columns)
    }
    
    private func generateGrid(rows: Int, columns: Int) {
        var generatedTiles: [Tile] = []
        for row in 0..<rows {
            for column in 0..<columns {
                let randomLetter = randomLetters.randomElement()!
                let tile = Tile(letter: randomLetter, row: row, column: column)
                generatedTiles.append(tile)
            }
        }
        
        tiles = generatedTiles
    }
    
    private func generateRandomTile(row: Int, column: Int) -> Tile {
        return Tile(letter: randomLetters.randomElement()!, row: row, column: column)
    }
    
    private func selectTile(at point: CGPoint) {
        for (gridPosition, frame) in tileFrames {
            if frame.contains(point) {
                handleTileSelection(at: gridPosition)
                break
            }
        }
    }
    
    private func handleTileSelection(at position: CGPoint) {
        if let lastPosition = selectedPositions.last {
            if position == lastPosition {
                return
            } else if selectedPositions.count >= 2, position == selectedPositions[selectedPositions.count - 2] {
                selectedPositions.removeLast()
                selectedTiles.removeLast()
            } else if isAdjacentTile(lastPosition, position) && !selectedPositions.contains(position) {
                selectedPositions.append(position)
                if let tile = tiles.first(where: { $0.row == Int(position.y) && $0.column == Int(position.x) }) {
                    selectedTiles.append(tile)
                }
            }
        } else {
            selectedPositions.append(position)
            if let tile = tiles.first(where: { $0.row == Int(position.y) && $0.column == Int(position.x) }) {
                selectedTiles.append(tile)
            }
        }
    }
    
    private func completeWord() {
        let selectedWord = selectedTiles.map { $0.letter.character }.joined()
        if !completedWords.contains(where: { $0.word == selectedWord }), selectedTiles.count > 1 {
            WordValidator.shared.validateWord(selectedWord) { isValid in
                if isValid {
                    let points = selectedTiles.reduce(0) { partialResult, tile in
                        partialResult + tile.letter.points
                    }
                    score += points
                    
                    let completedWord = CompletedWord(word: selectedWord, points: points)
                    completedWords.append(completedWord)
                    
                    moveDownTiles(above: selectedTiles)
                    removeTiles(selectedTiles)
                    addNewTiles(above: selectedTiles)
                    
                    print("Valid word: \(completedWord.word) (+\(completedWord.points) points)")
                } else {
                    print("Invalid word: \(selectedWord)")
                }
            }
        }
        clearSelection()
    }
    
    private func moveDownTiles(above selectedTiles: [Tile]) {
        for selectedTile in selectedTiles {
            for tile in tiles where tile.column == selectedTile.column && tile.row < selectedTile.row {
                moveDownTile(tile: tile)
            }
        }
    }
    
    private func moveDownTile(tile: Tile) {
        tile.row += 1
    }
    
    private func addNewTiles(above removedTiles: [Tile]) {
        for removedTile in removedTiles {
            let newTile = generateRandomTile(row: 0, column: removedTile.column)
            
            withAnimation(.default) {
                tiles.append(newTile)
                
                while !tiles.contains(where: { $0.column == removedTile.column && $0.row == newTile.row + 1 }) {
                    moveDownTile(tile: newTile)
                }
            }
        }
    }
    
    private func removeTiles(_ removableTiles: [Tile]) {
        tiles.removeAll(where: { removableTiles.contains($0) })
    }
    
    private func isAdjacentTile(_ firstTilePosition: CGPoint, _ secondTilePosition: CGPoint) -> Bool {
        let deltaX = abs(Int(firstTilePosition.x - secondTilePosition.x))
        let deltaY = abs(Int(firstTilePosition.y - secondTilePosition.y))
        return (deltaX <= 1 && deltaY <= 1) && !(deltaX == 0 && deltaY == 0)
    }
}

#Preview {
    GameView()
}
