//
//  JSONMoviesDecoder.swift
//  Movies
//
//  Created by Liron Matityahu on 10/03/2022.
//

import Foundation

class JSONMoviesDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
            //2006-03-15T00:00:00
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateDecodingStrategy = .formatted(dateFormatter)
    }
}
