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
            HStack {
                Text("Page \(viewModel.pageNumber)")
                    .font(.system(size: 12)) // Adjust the font size as needed
                    .foregroundColor(.gray)
            }

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
                    Text(viewModel.combinedCardNames)
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

