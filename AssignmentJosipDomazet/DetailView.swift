import SwiftUI

struct ItemDetailsView: View {
    var item: Item

    var body: some View {
        VStack(alignment: .leading, spacing: 16) { // Adjust alignment and spacing
            Text("ID: \(item.id)")
                .font(.headline)
            
            Text("Title: \(item.title)")
                .font(.title)
            
            Text("Description:")
                .font(.subheadline)
            Text(item.description)
                .font(.body)
            
            if let imageUrl = item.imageUrl {
                Text("Image URL:")
                    .font(.subheadline)
                Text(imageUrl)
                    .font(.body)
            } else {
                Text("Image URL: N/A")
                    .font(.subheadline)
            }
        }
        .padding(16) // Add padding to the entire content
        .navigationBarTitle("Item Details")
    }
}
