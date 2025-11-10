//
// ContentView.swift
//
// Partner Lab 3
// Group # 5
// Created by:
//             Liam Christensen
//             Alex Teterin
// Date:       11/10/25.
//

import SwiftUI

struct CardModel: Identifiable {
    let id = UUID()
    let contentID: Int
    let id_index: Int
    
    var isFaceUp = false
    var isComplete = false
}

class MemoryGameViewModel: ObservableObject {
    @Published private var cards: [CardModel]
    @Published var completePairs: Int = 0
    
    private var tileUpIndex: Int?
    private var isProcessingClick = false
    
    var tiles: [CardModel] { cards }

    init() {
        self.cards = MemoryGameViewModel.createGameCards()
    }
    
    private static func createGameCards() -> [CardModel] {
        var types = Array(1...11).shuffled().prefix(8)
        var contents = Array(types) + Array(types)
        contents.shuffle()
        
        var newCards: [CardModel] = []
        for i in 0..<contents.count {
            newCards.append(CardModel(contentID: contents[i], id_index: i))
        }
        return newCards
    }

    func choose(card: CardModel) {
        guard let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
              !isProcessingClick,
              !cards[chosenIndex].isComplete,
              !cards[chosenIndex].isFaceUp
        else {
            return
        }

        cards[chosenIndex].isFaceUp = true

        if let previousIndex = tileUpIndex {
            if cards[chosenIndex].contentID == cards[previousIndex].contentID {
                cards[chosenIndex].isComplete = true
                cards[previousIndex].isComplete = true
                completePairs += 1
                tileUpIndex = nil
            } else {
                isProcessingClick = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.cards[chosenIndex].isFaceUp = false
                    self.cards[previousIndex].isFaceUp = false
                    self.tileUpIndex = nil
                    self.isProcessingClick = false
                }
            }
        } else {
            tileUpIndex = chosenIndex
        }
    }
}

struct CardView: View {
    let card: CardModel
    let chooseAction: (CardModel) -> Void

    private var image: String { "\(card.contentID)" }
    private var isFaceUp: Bool { card.isFaceUp }
    private var isComplete: Bool { card.isComplete }
    
    var body: some View {
        ZStack {
            Group {
                Image(image)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .scaledToFit()
                    .opacity(isComplete ? 0.5 : 1.0)
                
                RoundedRectangle(cornerRadius: 6)
                    .fill(.white)
                    .frame(width: 60, height: 60)
                    .border(.black, width: 1)
                    .blendMode(.destinationOver)
            }
            .rotation3DEffect(.degrees(isFaceUp ? 0 : 180), axis: (x: 0, y: 1, z: 0))
            .opacity(isFaceUp ? 1 : 0)
            
            Group {
                let coverGradient = LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(red:156/255, green:79/255, blue:150/255), location: 0),
                        .init(color: Color(red:255/255, green:99/255, blue:85/255), location: 0.5),
                        .init(color: Color(red:251/255, green:169/255, blue:73/255), location: 1)
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                RoundedRectangle(cornerRadius: 6)
                    .fill(coverGradient)
                    .frame(width: 60, height: 60)
                    .border(.black, width: 1)
            }
            .rotation3DEffect(.degrees(isFaceUp ? 180 : 0), axis: (x: 0, y: -1, z: 0))
            .opacity(isFaceUp ? 0 : 1)
        }
        .padding(5)
        .animation(.easeOut(duration: 0.4), value: isFaceUp)
        .opacity(isComplete ? 0.0 : 1.0)
        .animation(.linear(duration: 0.5), value: isComplete)
        .onTapGesture {
            chooseAction(card)
        }
    }
}

struct ContentView: View {
    @StateObject private var game = MemoryGameViewModel()
    
    var body: some View {
        VStack {
            Text("Matched Pairs: \(game.completePairs)/8")
            Text("Memory Game")
                .font(.title).fontWeight(.bold)
                .padding(.bottom, 5)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: 4), spacing: 5) {
                ForEach(game.tiles) { card in
                    CardView(card: card, chooseAction: game.choose)
                        .aspectRatio(1, contentMode: .fit)
                }
            }
            .padding(.horizontal)
            
            if game.completePairs == 8 {
                Text("You Won! 🎉")
                    .font(.title).fontWeight(.bold)
                    .padding(20)
                    .scaleEffect(1.2)
                    .animation(.spring(response: 0.5, dampingFraction: 0.4), value: game.completePairs)
            }
            Spacer()
        }
        .padding(.top)
    }
}

#Preview {
    ContentView()
}
