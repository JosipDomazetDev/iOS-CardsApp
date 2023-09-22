//
//  ContentView.swift
//  AssignmentJosipDomazet
//
//  Created by user on 22.09.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel: CardViewModel

    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            switch viewModel.viewState {
            case .INITIAL:
                Text("Press the button to load cards.")
            case .LOADING:
                ProgressView("Loading...")
            case .ERROR(let errorMessage):
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            case .SUCCESS(let cards):
                ScrollView {
                    ForEach(cards, id: \.id) { card in
                        Text(card.name)
                            .font(.headline)
                    }
                }
            }

            Button(action: {
                viewModel.loadCards()
            }) {
                Text("Load Cards")
            }
            .disabled(viewModel.viewState == .LOADING)
        }
       
    }
}

