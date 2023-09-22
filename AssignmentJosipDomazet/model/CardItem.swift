//
//  CardItem.swift
//  AssignmentJosipDomazet
//
//  Created by user on 22.09.23.
//

import Foundation

struct Card: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let type: String
    let rarity: String
    let colors: [String]
}
