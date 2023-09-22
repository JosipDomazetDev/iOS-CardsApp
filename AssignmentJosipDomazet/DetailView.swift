//
//  DetailView.swift
//  AssignmentJosipDomazet
//
//  Created by user on 22.09.23.
//

import Foundation

import SwiftUI

struct ItemDetailsView: View { // Make sure ItemDetailsView conforms to View
    var item: Item // Replace Item with your data model

    var body: some View {
        VStack {
            Text("Title: \(item.title)")
            // Add more details here such as unique identifier, description, and image URL
        }
        .navigationBarTitle("Item Details")
    }
}

