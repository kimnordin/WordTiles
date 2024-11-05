//
//  GameView.swift
//  WordTiles
//
//  Created by Kim on 2024-11-05.
//

import SwiftUI

struct GameView: View {
    let letters = [
        ["A", "B", "C"],
        ["D", "E", "F"],
        ["G", "H", "I"]
    ]

    @State private var selectedPositions: [CGPoint] = []
    @State private var selectedLetters: [String] = []
    @State private var tileFrames: [CGPoint: CGRect] = [:]

    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                ZStack {
                    VStack(spacing: 10) {
                        ForEach(0..<3, id: \.self) { row in
                            HStack(spacing: 10) {
                                ForEach(0..<3, id: \.self) { column in
                                    let position = CGPoint(x: CGFloat(column), y: CGFloat(row))
                                    TileView(
                                        letter: letters[row][column],
                                        isSelected: selectedPositions.contains(position),
                                        gridPosition: position // Pass the grid position
                                    )
                                }
                            }
                        }
                        .padding()
                    }
                    Path { path in
                        guard !selectedPositions.isEmpty else { return }
                        if let firstPos = selectedPositions.first, let firstFrame = tileFrames[firstPos] {
                            let startPoint = CGPoint(x: firstFrame.midX, y: firstFrame.midY)
                            path.move(to: startPoint)
                            for pos in selectedPositions.dropFirst() {
                                if let frame = tileFrames[pos] {
                                    let point = CGPoint(x: frame.midX, y: frame.midY)
                                    path.addLine(to: point)
                                }
                            }
                        }
                    }
                    .stroke(Color.blue, lineWidth: 5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .coordinateSpace(name: "GameView")
            .onPreferenceChange(TileFramePreferenceKey.self) { preferences in
                self.tileFrames = preferences
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let location = value.location
                        for (gridPosition, frame) in tileFrames {
                            if frame.contains(location) {
                                if !selectedPositions.contains(gridPosition) {
                                    selectedPositions.append(gridPosition)
                                    let row = Int(gridPosition.y)
                                    let column = Int(gridPosition.x)
                                    selectedLetters.append(letters[row][column])
                                }
                                break
                            }
                        }
                    }
                    .onEnded { _ in
                        print("Selected word: \(selectedLetters.joined())")
                        selectedPositions.removeAll()
                        selectedLetters.removeAll()
                    }
            )
        }
        .background(Color.white)
    }
}

#Preview {
    GameView()
}
