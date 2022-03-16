//
//  ViewController.swift
//  Movies
//
//  Created by Liron Matityahu on 03/12/2021.
//

import UIKit
import Combine

enum MoviesMode: Equatable {
  case search
  case all
}

class MoviesViewController: UIViewController {
    let viewModel = HomeViewModel()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    private(set) var movieMode : MoviesMode = .all

    var stream = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }

    func initView() {
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        setupSearchListener()
        
    }
    
    func setupSearchListener() {
        NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchBar.searchTextField)
            .print()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            //.removeDuplicates()
            .map { ($0.object as! UISearchTextField).text}
            .sink { [weak self] search in
                self?.viewModel.getMoviesData(search:search)
            }.store(in: &stream)
    }
    
    func initViewModel() {
        viewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
            self?.tableView.reloadData()
        }.store(in: &stream)
        viewModel.getMoviesData()
        viewModel.$fetchStatus.receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                switch status {
                case .error(let str):
                    self?.showAlertView(msg: str)
                case .ready: break
                    
                case .ongoing:
                    break
                    
                case .finished: break
                    
                }
            }.store(in: &self.stream)
            
    }

}

extension UIViewController {
    func showAlertView(msg : String) {
        let ac = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
}
//MARK: UITableViewDelegate & UITableViewDataSource
extension MoviesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let movie = viewModel.movies[indexPath.row]
        cell.movie = movie
        cell.setCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.movies[indexPath.row]
        let movieDetailViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "MoviewDetail", creator: { coder -> MovieDetailViewController? in
            MovieDetailViewController(coder: coder, movie: movie)
        })
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}
 
extension MoviesViewController : UISearchBarDelegate, UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        // TODO
      }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        viewModel.getMoviesData(search:searchText)
//    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        defer {
            searchBar.resignFirstResponder()
        }
        guard let search = searchBar.text else {return}
        viewModel.getMoviesData(search:search)
    }
}
