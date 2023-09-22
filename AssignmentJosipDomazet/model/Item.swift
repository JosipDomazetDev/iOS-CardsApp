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
    let imageURL: URL
    
    
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case description
        case imageURL
    }
}
