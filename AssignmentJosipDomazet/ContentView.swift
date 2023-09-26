import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel: ItemViewModel
    @AppStorage("apiURL") private var apiURL = AppConstants.apiURL
    @AppStorage("showImages") private var showImages = true
    
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
                                if showImages, let imageUrlString = item.imageUrl, let imageUrl = URL(string: imageUrlString) {
                                    AsyncImage(url: imageUrl) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(width: 50, height: 50)
                                                .cornerRadius(10)
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .cornerRadius(10)
                                        case .failure:
                                            Image(systemName: "photo")
                                                .frame(width: 50, height: 50)
                                                .cornerRadius(10)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                } else {
                                    Image(systemName: "photo")
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
                    openAppSettings()
                }) {
                    Image(systemName: "gear")
                }
            )
        }
        .onAppear {
            viewModel.fetchItems(url: apiURL)
        }
        .refreshable {
            viewModel.reloadItems(url: apiURL)
        }
        .onChange(of: apiURL) { _ in
            viewModel.reloadItems(url: apiURL)
        }
    }
}


private func openAppSettings() {
    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(settingsUrl)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ItemViewModel(repository: ItemRepository()))
    }
}
