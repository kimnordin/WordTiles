//
//  TileView.swift
//  WordTiles
//
//  Created by Kim on 2024-11-05.
//

import SwiftUI

struct TileView: View {
    let letter: String
    var isSelected: Bool
    let gridPosition: CGPoint

    var body: some View {
        ZStack {
            Rectangle()
                .fill(isSelected ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2))
                .cornerRadius(8)
            Text(letter)
                .font(.largeTitle)
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
        .preference(key: TileLetterPreferenceKey.self, value: [gridPosition: letter])
    }
}

#Preview {
    TileView(letter: "Q", isSelected: true, gridPosition: CGPoint.zero)
}
