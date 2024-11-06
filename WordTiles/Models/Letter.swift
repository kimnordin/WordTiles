//
//  Letter.swift
//  WordTiles
//
//  Created by Kim on 2024-11-06.
//

import SwiftUI

struct Letter {
    let character: String
    let frequency: CGFloat
    
    var points: Int {
        switch frequency {
        case 4..<7:
            4
        case 2..<4:
            6
        case 1..<2:
            8
        case 0..<1:
            10
        default:
            2
        }
    }
    
    var color: Color {
        switch frequency {
        case 4..<7:
            .green
        case 2..<4:
            .yellow
        case 1..<2:
            .orange
        case 0..<1:
            .red
        default:
            .blue
        }
    }
}
