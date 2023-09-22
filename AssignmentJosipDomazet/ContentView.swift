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
        NavigationView {
            VStack {
                switch viewModel.viewState {
                case .INITIAL:
                    Text("Pull down to load cards.")
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
            }
            .navigationBarTitle("Item List")
        }
        .onAppear {
            viewModel.fetchItems()
        }
        .refreshable {
            viewModel.reloadItems()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ItemViewModel(repository: ItemRepository()))
    }
}
