//
//  TileView.swift
//  WordTiles
//
//  Created by Kim on 2024-11-05.
//

import SwiftUI

struct TileView: View {
    let letter: Letter
    var isSelected: Bool
    let gridPosition: CGPoint

    var body: some View {
        ZStack {
            Rectangle()
                .fill(isSelected ? .blue.opacity(0.3) : .gray.opacity(0.2))
                .cornerRadius(8)
            Text(letter.character)
                .font(.largeTitle)
                .minimumScaleFactor(0.1)
        }
        .contentShape(Rectangle())
        .overlay(
            GeometryReader { geometry in
                Color.clear.preference(
                    key: TileSelectionPreferenceKey.self,
                    value: [gridPosition: geometry.frame(in: .named("GameView"))]
                )
            }
        )
    }
}

#Preview {
    TileView(letter: Letter(character: "Q", frequency: 0.11, points: 8), isSelected: true, gridPosition: CGPoint.zero)
}
