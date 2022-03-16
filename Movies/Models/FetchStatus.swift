//
//  FetchStatus.swift
//  Movies
//
//  Created by Liron Matityahu on 10/03/2022.
//

import Foundation

enum FetchStatus: Equatable {
    case ready
    case ongoing
    case error(String)
    case finished
}

