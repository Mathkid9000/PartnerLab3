//
//  ProgrammingMemoryCard.swift
//  PartnerLab3
//
//  Created by Mac User on 11/10/25.
//

import Foundation
import SwiftUI

// Implements functionality to cover and uncover cars upon tap gesture
struct CardView: View {
    let image: String
    let id_index: Int
    let flip_function: (CardView) -> ()

    //var image: Int
    @State var isFaceUp: Bool = false // false: Cards covered by default, true: cards uncovered by default
    @State var isComplete: Bool = false // false: Cards have no effect, true: add an opacity effect to show that it has been paired
    
    init(image: String, id_index: Int, flip_function: @escaping (CardView) -> ()) {
        self.image = image
        self.id_index = id_index
        self.flip_function = flip_function
    }
        
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
            .onTapGesture(perform: { flip_function(self) })
            .animation(.easeOut(duration: 0.4), value: isFaceUp)
            .opacity(isComplete ? 0.0 : 1.0)
            .animation(.linear(duration: 0.5), value: isComplete)
    }
}

#Preview {
    ContentView()
}
