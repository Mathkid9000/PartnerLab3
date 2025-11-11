//
//  LanguageMemoryGame.swift
//  PartnerLab3
//
//  Created by Mac User on 11/10/25.
//

import Foundation
import SwiftUI

class LanguageMemoryGame: ObservableObject {
    @Published public var model: MemoryGame = createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame {
        return MemoryGame()
    }
        
    static func getContent(index: Int) -> String {
        return "\(index)"
    }
}
