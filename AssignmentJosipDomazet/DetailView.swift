import SwiftUI

struct ItemDetailsView: View {
    var item: Item
    @AppStorage("showImages") private var showImages = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                if let imageUrl = item.imageUrl, showImages {
                    AsyncImage(url: URL(string: imageUrl)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 200, height: 200)
                                .background(Color.gray)
                                .cornerRadius(10)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300)
                                .overlay(
                                    Text(item.title ?? "")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .frame(maxWidth: .infinity, minHeight: 55)
                                        .background(Color.black.opacity(0.6))
                                    ,
                                    alignment: .top
                                )
                                .cornerRadius(10)
                            
                        case .failure:
                            Image(systemName: "photo")
                                .frame(width: 200, height: 200)
                                .background(Color.gray)
                                .cornerRadius(10)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    
                    Text(item.title ?? "")
                        .font(.headline)
                    
                    Text("Images not displayed")
                        .font(.caption2)
                        .foregroundColor(.red)
                }
                
            }
            
            Text("ID: \(item.id ?? "")")
                .font(.system(size: 9))
                .foregroundColor(.gray)
            
            if let description = item.description {
                Text(description)
                    .font(.body)
                    .padding(8)
            } else {
                Text("Description not available")
                    .font(.body)
                    .padding(8)
            }
            
            
            if let imageUrl = item.imageUrl {
                Button(action: {
                    if let url = URL(string: imageUrl) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Open Image URL")
                        .font(.headline)
                        .foregroundColor(.blue)
                }.padding(16)
            }
        }
        .padding(16)
        .navigationBarTitle("Item Details")
        
    }
}

