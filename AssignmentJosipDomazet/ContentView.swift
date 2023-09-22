//
//  ContentView.swift
//  AssignmentJosipDomazet
//
//  Created by user on 22.09.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel: ItemViewModel
    
    init(viewModel: ItemViewModel) {
        self.viewModel = viewModel
    }
    
    func errorWidget(_ errorMessage: String) -> Text {
        print(errorMessage)
        return Text("Error: \(errorMessage)")
    }
    
    var body: some View {
        NavigationView { // Wrap your content in a NavigationView
            VStack {
                switch viewModel.viewState {
                case .INITIAL:
                    Text("Press the button to load cards.")
                case .LOADING:
                    ProgressView("Loading...")
                case .ERROR(let errorMessage):
                    errorWidget(errorMessage)
                        .foregroundColor(.red)
                case .SUCCESS(let items):
                    List(items, id: \.id) { item in
                        NavigationLink(destination: ItemDetailsView(item: item)) {
                            Text(item.title)
                        }
                    }
                }
                
                Button(action: {
                    viewModel.fetchItems()
                }) {
                    Text("Load Cards")
                }
                .disabled(viewModel.viewState == .LOADING)
            }
            .navigationBarTitle("Item List") // Set the navigation bar title
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ItemViewModel(repository: ItemRepository()))
    }
}
