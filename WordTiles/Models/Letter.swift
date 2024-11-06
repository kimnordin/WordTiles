//
//  Letter.swift
//  WordTiles
//
//  Created by Kim on 2024-11-06.
//

import SwiftUI

struct Letter {
    let character: String
    
    var frequency: Int {
        switch character {
        case "N", "S", "R", "H", "D":
            8
        case "L", "U", "C", "M", "F", "Y", "W", "G":
            6
        case "P", "B", "V":
            4
        case "K", "X", "Q", "J":
            2
        case "Z":
            1
        default:
            10
        }
    }
    
    var points: Int {
        switch frequency {
        case 8:
            4
        case 6:
            6
        case 4:
            8
        case 2:
            10
        case 1:
            12
        default:
            2
        }
    }
    
    var color: Color {
        switch frequency {
        case 8:
            .green
        case 6:
            .yellow
        case 4:
            .orange
        case 2:
            .purple
        case 1:
            .red
        default:
            .blue
        }
    }
}
