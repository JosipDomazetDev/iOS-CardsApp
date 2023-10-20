//
//  ViewState.swift
//  AssignmentJosipDomazet
//
//  Created by user on 22.09.23.
//

import Foundation

enum ViewState<T>: Equatable where T: Equatable {
    case INITIAL
    case LOADING
    case ERROR(String)
    case SUCCESS(T)
}
