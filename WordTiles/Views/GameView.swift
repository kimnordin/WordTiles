//
//  GameView.swift
//  WordTiles
//
//  Created by Kim on 2024-11-05.
//

import SwiftUI

struct GameView: View {
    let letters: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    @State private var tiles: [Tile] = []
    @State private var currentColumns: Int = 0
    @State private var selectedPositions: [CGPoint] = []
    @State private var selectedLetters: [String] = []
    @State private var tileFrames: [CGPoint: CGRect] = [:]
    @State private var positionToLetter: [CGPoint: String] = [:]
    
    var body: some View {
        ZStack {
            GridView(tiles: tiles, selectedPositions: $selectedPositions)
            TileSelectionPath(selectedPositions: $selectedPositions, tileFrames: $tileFrames)
        }
        .background(Color.white)
        .coordinateSpace(name: "GameView")
        .onAppear {
            self.tiles = generateGrid(from: letters)
        }
        .onPreferenceChange(TileSelectionPreferenceKey.self) { preferences in
            self.tileFrames = preferences
        }
        .onPreferenceChange(TileLetterPreferenceKey.self) { preferences in
            self.positionToLetter = preferences
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let location = value.location
                    for (gridPosition, frame) in tileFrames {
                        if frame.contains(location) {
                            handleTileSelection(at: gridPosition)
                            break
                        }
                    }
                }
                .onEnded { _ in
                    completeWord()
                }
        )
    }
    
    private func completeWord() {
        print("Selected word: \(selectedLetters.joined())")
        selectedPositions.removeAll()
        selectedLetters.removeAll()
    }
    
    private func generateGrid(from letters: [String]) -> [Tile] {
        return letters.map { Tile(letter: $0) }
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
            } else if selectedPositions.count >= 2, position == selectedPositions[selectedPositions.count - 2] {
                selectedPositions.removeLast()
                selectedLetters.removeLast()
            } else if isAdjacent(lastPosition, position) && !selectedPositions.contains(position) {
                selectedPositions.append(position)
                if let letter = positionToLetter[position] {
                    selectedLetters.append(letter)
                }
            }
        } else {
            selectedPositions.append(position)
            if let letter = positionToLetter[position] {
                selectedLetters.append(letter)
            }
        }
    }
}

#Preview {
    GameView()
}
