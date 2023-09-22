//
//  CardItem.swift
//  AssignmentJosipDomazet
//
//  Created by user on 22.09.23.
//

import Foundation

struct Item: Identifiable, Codable, Equatable {
    let id = UUID()
    let title: String
    let description: String
    let imageUrl: String?

    
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case description = "text"
        case imageUrl = "imageUrl"
    }
}

struct Response: Codable {
    let items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case items = "cards"
    }
}
