//
//  MemoryGame.swift
//  PartnerLab3
//
//  Created by Mac User on 11/10/25.
//

import Foundation
import SwiftUI

class MemoryGame {
    // Logic for generating a random board of paired tiles
    static func generateTiles() -> [Int] {
        var possibleTiles: [Int] = Array(1..<12)
        var selectedTileTypes: [Int] = []
        for _ in 0..<8 {
            let selection = Int.random(in: 0..<possibleTiles.count)
            selectedTileTypes.append(possibleTiles[selection])
            possibleTiles.remove(at: selection)
        }
        var _tiles: [Int] = []
        for _ in 0..<16 {
            let selection = Int.random(in: 0..<selectedTileTypes.count)
            let tileType = selectedTileTypes[selection]
            if _tiles.contains(tileType) {
                selectedTileTypes.remove(at: selection)
            }
            _tiles.append(tileType)
        }
        return _tiles
    }

    private var tileUp: CardView? = nil // current flipped card -> nil if no card is flipped over
    public var tiles: [Int]
    private var isProcessingClick: Bool = false // small time allocated for showing second card in pair

    init() {
        self.tiles = MemoryGame.generateTiles()
    }
    
    // Logic for when a card is flipped over
    func flipCard(card: CardView) {
        if isProcessingClick == true || card.isComplete {
            return
        }
        
        if tileUp == nil {
            tileUp = card
            card.isFaceUp = true
        }
        else {
            if tileUp!.id_index == card.id_index {
                return
            }

            card.isFaceUp = true
            if tileUp!.image == card.image {
                card.isComplete = true
                tileUp?.isComplete = true
                tileUp = nil
            }
            else {
                isProcessingClick = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                    tileUp!.isFaceUp = false
                    card.isFaceUp = false
                    tileUp = nil
                    isProcessingClick = false
                }
            }
        }
    }
}
