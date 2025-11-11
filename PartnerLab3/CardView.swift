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
            let shape = ZStack {
                RoundedRectangle(cornerSize: CGSize(width: 6, height: 6))
                    .foregroundColor(.white)
                    .border(Color.black, width: 1)
                    .frame(width: 60, height: 60)
                    .padding(0)
                LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .init(.sRGB, red:0.611, green:0.31, blue:0.588), location: 0),
                            .init(color: .init(.sRGB, red:1, green:0.388, blue:0.333), location: 0.5),
                            .init(color: .init(.sRGB, red:0.984, green:0.663, blue:0.286), location: 1)
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
            .onTapGesture(perform: { flip_function(self) })
    }
}

#Preview {
    ContentView()
}
