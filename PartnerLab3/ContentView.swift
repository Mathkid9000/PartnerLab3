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

struct ContentView: View {
    @ObservedObject private var viewModel: LanguageMemoryGame = LanguageMemoryGame()

    var body: some View {
        VStack {
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
                    CardView(image: "\(viewModel.model.tiles[i])", id_index: i, flip_function: viewModel.model.flipCard)
                        .frame(minWidth: 40, maxWidth: .infinity)
                }
            }.padding(0)
        }
    }

}
