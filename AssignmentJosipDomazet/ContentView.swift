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
    
    func createListView(items: [Item]) -> some View {
        List(items, id: \.id) { item in
            NavigationLink(destination: ItemDetailsView(item: item)) {
                
                if (item.id == items.first?.id){
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                            
                            Text("\(item.id)")
                                .font(.system(size: 10))
                        }
                        
                        if showImages, let imageUrlString = item.imageUrl, let imageUrl = URL(string: imageUrlString) {
                            Spacer() // Push AsyncImage to the right edge
                            AsyncImage(url: imageUrl) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(10)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100)
                                    
                                case .failure:
                                    Image(systemName: "photo")
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(10)
                                @unknown default:
                                    EmptyView()
                                }
                            }.padding(8)
                        } else {
                            Image(systemName: "photo")
                                .frame(width: 50, height: 50)
                                .cornerRadius(10)
                                .padding(8)
                        }
                    }

                }else{
                    
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
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50)
                
                                case .failure:
                                    Image(systemName: "photo")
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(10)
                                @unknown default:
                                    EmptyView()
                                }
                            }.padding(8)
                        } else {
                            Image(systemName: "photo")
                                .frame(width: 50, height: 50)
                                .cornerRadius(10).padding(8)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                            
                            Text("\(item.id)")
                                .font(.system(size: 10))
                        }
                    }
                }}
        }
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
                    createListView(items: items)
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
