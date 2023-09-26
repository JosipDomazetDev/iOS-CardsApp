import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel: ItemViewModel
    @State private var isShowingSettings = false

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
                            HStack {
                                if let imageUrlString = item.imageUrl, let imageUrl = URL(string: imageUrlString) {
                                    AsyncImage(url: imageUrl)
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(10)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(item.title)
                                        .font(.headline)
                                    
                                    Text(item.id)
                                        .font(.subheadline)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Item List")
            .navigationBarItems(
                trailing: Button(action: {
                    isShowingSettings.toggle()
                }) {
                    Image(systemName: "gear")
                }
            )
        }
        .onAppear {
            viewModel.fetchItems()
        }
        .refreshable {
            viewModel.reloadItems()
        }
        .sheet(isPresented: $isShowingSettings) {
            SettingsView(viewModel: viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ItemViewModel(repository: ItemRepository()))
    }
}
