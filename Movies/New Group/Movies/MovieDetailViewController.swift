//
//  MoviesRowViewController.swift
//  Movies
//
//  Created by Liron Matityahu on 03/12/2021.
//

import UIKit
import Combine
//TODO: how to cache images from url
//TODO: how to show loading indicator on image
class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var cast: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var directors: UILabel!
    private var cancellables = Set<AnyCancellable>()

    let movie : Movie
    
    init?(coder: NSCoder, movie: Movie) {
        self.movie = movie

        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = movie.title
        details.text = ListFormatter.localizedString(byJoining: movie.genres)
        cast.text = ListFormatter.localizedString(byJoining: movie.cast)
        overview.text = movie.overview
        directors.text = ListFormatter.localizedString(byJoining: movie.director)
        
        MoviesAPIClient.shared.loadImage(url: movie.poster)
            .print()
            .map {UIImage(data: $0)}
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: movieImageView)
            .store(in: &cancellables)
            
            //.tryMap(Data, in UIImage(data: data))
            

//        MoviesAPIClient.shared.loadImage(url: movie.poster) { [weak self] result in
//            switch result {
//            case .success(let data):
//                DispatchQueue.main.async {
//                    self?.movieImageView.image = UIImage(data: data)
//                }
//            default: break
//            }
//        }
    }
}
