//
//  MovieCollectionCell.swift
//  Movies
//
//  Created by Liron Matityahu on 03/12/2021.
//

import UIKit
import Combine

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var movieImageView: UIImageView!
    private var cancellables = Set<AnyCancellable>()

    var movie : Movie?

    func setCell() {
        title.text = movie?.title
        if let url = movie?.backdrop {
            
            MoviesAPIClient.shared.loadImage(url: url)
                .map {UIImage(data: $0)}
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .assign(to: \.image, on: movieImageView)
                .store(in: &cancellables)
            
        }
    }
}

