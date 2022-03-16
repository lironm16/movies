//
//  Movie.swift
//  Movies
//
//  Created by Liron Matityahu on 03/12/2021.
//

import Foundation


struct MoviesResult : Codable {
    let movies : [Movie]
}

struct Movie : Codable {
    
    let title : String
    let overview : String
    let poster : URL
    let slug : String
    let backdrop : URL
    let releasedOn : Date
    let classification : String
    let director : [String]
    let id : String
    let length : String
    let cast : [String]
    let genres : [String]
    let imdbRating : Double
    
    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        overview = try container.decode(String.self, forKey: .overview)
        poster = try container.decode(URL.self, forKey: .poster)
        slug = try container.decode(String.self, forKey: .slug)
        backdrop = try container.decode(URL.self, forKey: .backdrop)
        releasedOn = try container.decode(Date.self, forKey: .releasedOn)
        classification = try container.decode(String.self, forKey: .classification)
        id = try container.decode(String.self, forKey: .id)
        length = try container.decode(String.self, forKey: .length)
        cast = try container.decode([String].self, forKey: .cast)
        genres = try container.decode([String].self, forKey: .genres)
        imdbRating = try container.decode(Double.self, forKey: .imdbRating)
        
        if let directors = try? [String(container.decode(String.self, forKey: .director))] {
            director = directors
        } else {
            director = try container.decode([String].self, forKey: .director)
        }
    }
}
