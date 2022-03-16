//
//  MoviesRowViewModel.swift
//  Movies
//
//  Created by Liron Matityahu on 03/12/2021.
//

import UIKit

class MovieViewModel {
    
    private var movie : Movie
    
    init(movie : Movie) {
        self.movie = movie
    }
    
    func loadImage() {
        MoviesAPIClient.shared.loadImage(url: movie.backdrop)
    }
}
