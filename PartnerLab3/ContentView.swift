//
//  ContentView.swift
//
//  Partner Lab 3
//  Group # 5
//  Created by:
//              Liam Christensen
//              Alex Teterin
//  Date:       11/10/25.
//

import SwiftUI

class MemoryGame: ObservableObject {
    public static var _instance: MemoryGame? = nil
    
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

    var tileUp: CardView? = nil // current flipped card -> nil if no card is flipped over
    @Published var tiles: [Int]
    @Published var completePairs: Int = 0
    var isProcessingClick: Bool = false // small time allocated for showing second card in pair
    
    init() {
        self.tiles = MemoryGame.generateTiles()
        MemoryGame._instance = self
    }
}

struct ContentView: View {
    @StateObject private var game = MemoryGame()
    
    var body: some View {
        VStack {
            Text("Matched Pairs: \(game.completePairs)/8")
            Text("Memory Game")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            LazyHGrid(rows:
                        [GridItem(.adaptive(minimum: 40, maximum: .infinity)),
                         GridItem(.adaptive(minimum: 40, maximum: .infinity)),
                         GridItem(.adaptive(minimum: 40, maximum: .infinity)),
                         GridItem(.adaptive(minimum: 40, maximum: .infinity))],
                      spacing: 0
            )
            {
                ForEach(0..<16) { i in
                    CardView (image: "\(game.tiles[i])", id_index: i)
                        .frame(minWidth: 40, maxWidth: .infinity)
                }
            }.padding(0)
            
            if game.completePairs == 8 {
                Text("You Won!")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .padding(20)
            }
        }
    }

}

// Implements functionality to cover and uncover cars upon tap gesture
struct CardView: View {
    var image: String
    var id_index: Int
    //var image: Int
    @State var isFaceUp: Bool = false // false: Cards covered by default, true: cards uncovered by default
    @State var isComplete: Bool = false // false: Cards have no effect, true: add an opacity effect to show that it has been paired
    
    init(image: String, id_index: Int) {
        self.image = image
        self.id_index = id_index
    }
    
    // Logic for when a card is flipped over
    func flipCard() {
        if MemoryGame._instance?.isProcessingClick == true || isComplete {
            return
        }
        
        if MemoryGame._instance?.tileUp == nil {
            MemoryGame._instance?.tileUp = self
            isFaceUp = true
        }
        else {
            if MemoryGame._instance?.tileUp!.id_index == id_index {
                return
            }

            isFaceUp = true
            if MemoryGame._instance?.tileUp!.image == image {
                MemoryGame._instance?.completePairs += 1
                print(MemoryGame._instance?.completePairs)
                isComplete = true
                MemoryGame._instance?.tileUp?.isComplete = true
                MemoryGame._instance?.tileUp = nil
            }
            else {
                MemoryGame._instance?.isProcessingClick = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    MemoryGame._instance?.tileUp!.isFaceUp = false
                    isFaceUp = false
                    MemoryGame._instance?.tileUp = nil
                    MemoryGame._instance?.isProcessingClick = false
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            let shape = ZStack {
                RoundedRectangle(cornerSize: CGSize(width: 6, height: 6))
                    .foregroundColor(.white)
                    .border(Color.black, width: 1)
                    .frame(width: 60, height: 60)
                    .padding(0)
                LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .init(.sRGB, red:156/255, green:79/255, blue:150/255), location: 0),
                            .init(color: .init(.sRGB, red:255/255, green:99/255, blue:85/255), location: 0.5),
                            .init(color: .init(.sRGB, red:251/255, green:169/255, blue:73/255), location: 1)
                        ]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
            }
            
            
            Image(image)
                .resizable()
                .frame(width: 60, height: 60)
                .scaledToFit()
                .opacity(isComplete ? 0.5 : 1)
            
            if isFaceUp {
                shape.opacity(0)
            }
            else {
                shape.opacity(1)
            }
        }.padding(5)
            .onTapGesture(perform: flipCard)
        
    }
}

#Preview {
    ContentView()
}
