//
//  GameView.swift
//  WordTiles
//
//  Created by Kim on 2024-11-05.
//

import SwiftUI

struct GameView: View {
    let letters: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I"]
    let columns: Int = 3
    
    @State private var tiles: [Tile] = []
    @State private var selectedPositions: [CGPoint] = []
    @State private var selectedLetters: [String] = []
    @State private var tileFrames: [CGPoint: CGRect] = [:]
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                GridView(tiles: tiles, columns: columns, selectedPositions: $selectedPositions)
                TileSelectionPath(selectedPositions: $selectedPositions, tileFrames: $tileFrames)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .coordinateSpace(name: "GameView")
        .onAppear {
            self.tiles = generateGrid(from: letters, columns: columns)
        }
        .onPreferenceChange(TileFramePreferenceKey.self) { preferences in
            self.tileFrames = preferences
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
    
    private func generateGrid(from letters: [String], columns: Int) -> [Tile] {
        var tiles: [Tile] = []
        for (index, letter) in letters.enumerated() {
            let row = index / columns
            let column = index % columns
            tiles.append(Tile(letter: letter, row: row, column: column))
        }
        return tiles
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
            } else if !selectedPositions.contains(position) {
                selectedPositions.append(position)
                if let tile = tiles.first(where: { CGFloat($0.row) == position.y && CGFloat($0.column) == position.x }) {
                    selectedLetters.append(tile.letter)
                }
            }
        } else {
            selectedPositions.append(position)
            if let tile = tiles.first(where: { CGFloat($0.row) == position.y && CGFloat($0.column) == position.x }) {
                selectedLetters.append(tile.letter)
            }
        }
    }
}

#Preview {
    GameView()
}
