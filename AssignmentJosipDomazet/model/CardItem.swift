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
    // Add other properties needed for display
}
