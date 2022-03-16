//
//  NetworkManager.swift
//  Movies
//
//  Created by Liron Matityahu on 04/12/2021.
//

import Foundation
import Combine
import UIKit
protocol MoviesAPIClientProtocol {
    func fetchMovies(search: String) -> AnyPublisher<[Movie], NetworkError>
    //func fetchMovies() -> AnyPublisher<[Movie], Error>
    //func fetchMeals(category: String) -> AnyPublisher<[Movie], Error>
}

enum APIError: Error, LocalizedError {
    case unknown, apiError(reason: String)
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .apiError(let reason):
            return reason
        }
    }
}
class MoviesAPIClient  {
    
    static let shared = MoviesAPIClient()
    let baseUrlString = "https://wookie.codesubmit.io/movies"
    private var cancellables = Set<AnyCancellable>()

    var stream : AnyCancellable? = nil
    
    func fetchMovies(search: String = "") {//}-> AnyPublisher<[Movie], NetworkError> {
        let urlString = baseUrlString+(search.isEmpty ? "" : "?q="+search)
//        guard let url = URL(string:urlString) else {
//            return Fail(error: .badUrl).eraseToAnyPublisher()
//        }
//        var request = URLRequest(url: url,cachePolicy: .returnCacheDataElseLoad)
//        request.setValue("Bearer Wookie2019", forHTTPHeaderField: "Authorization")
        
//        return URLSession.shared.dataTaskPublisher(for: request)
//            .print()
//            .mapError { NetworkError.request(underlyingError: $0) }
//                    .map { $0.data }
//                    .decode(type: MoviesResult.self, decoder: JSONMoviesDecoder())
//                    .mapError { $0 as? NetworkError ?? .unableToDecode(underlyingError: $0) }
//                    .map {$0.movies}
//                    .eraseToAnyPublisher()
        
    }
    func loadImage(url : URL) -> Future<Data,NetworkError> {
        return Future<Data,NetworkError> { [weak self] promise in
            guard let self = self else {
                return promise(.failure(.unknown))
            }
            let urlRequest = URLRequest(url: url,cachePolicy: .returnCacheDataElseLoad)
            URLSession.shared.dataTaskPublisher(for: urlRequest)
                //.map {UIImage(data: $0.data)}
                //.replaceError(with: nil)
                .sink(receiveCompletion: {_ in }, receiveValue: {
                    return promise(.success($0.data))
                })
                .store(in: &self.cancellables)
                
            
        }
    }
//    func loadImage(url : URL, completion: ((Result<Data, Error>) -> Void)? = nil) {
//        let urlRequest = URLRequest(url: url,cachePolicy: .returnCacheDataElseLoad)
//        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//            if let data = data {
//                completion?(.success(data))
//            } else if let error = error {
//                completion?(.failure(error))
//            }
//        }
//        task.resume()
//    }
}
//        return URLSession.DataTaskPublisher(request: request, session: .shared)
//            .tryMap { data, response in
//                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
//                    throw APIError.unknown
//                }
//                return data
//            }
//            .mapError { error in
//                if let error = error as? APIError {
//                    return error
//                } else {
//                    return APIError.apiError(reason: error.localizedDescription)
//                }
//            }
//            .decode(type: MoviesResult.self, decoder: JSONMoviesDecoder())
//            .map { $0.movies }
//            .eraseToAnyPublisher()
//
//    }
//
    //enum APIError : Error {
    //    case invalidURL,invalidResponse, invalidData
    //    case error(Error)
    //}
    
    
    
    
    
    //    func fetchMovies(urlString: String, search : String = "") -> AnyPublisher<[Movie], Error> {
    //        let url : URL
    //        if !search.isEmpty {
    //            url = URL(string: baseUrlString+"?q="+search)!
    //        } else {
    //            url = URL(string: baseUrlString)!
    //        }
    //        var urlRequest = URLRequest(url: url,cachePolicy: .returnCacheDataElseLoad)
    //        urlRequest.setValue("Bearer Wookie2019", forHTTPHeaderField: "Authorization")
    //        return URLSession.shared.dataTaskPublisher(for: urlRequest)
    //            .print()
    //            .tryMap { output in
    //                guard let httpResponse = output.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
    //                    throw URLError(.badServerResponse)
    //                }
    //                return output.data
    //            }
    //            .decode(type: MoviesResult.self, decoder: JSONMoviesDecoder())
    //            .map { $0.movies }
    //            .eraseToAnyPublisher()
    //
    ////        guard let url = URL(string: urlString) else {
    ////            completion(.failure(.invalidURL))
    ////            return
    ////        }
    //
    ////        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
    ////            if let error = error {
    ////                completion(.failure(.error(error)))
    ////                print("error:\(error.localizedDescription)")
    ////            } else {
    ////                do {
    ////                    //TODO: move to file
    ////                    let decoder = JSONDecoder()
    ////                    decoder.keyDecodingStrategy = .convertFromSnakeCase
    ////                    let dateFormatter = DateFormatter()
    ////                        //2006-03-15T00:00:00
    ////                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    ////                    dateFormatter.locale = Locale(identifier: "en_US")
    ////                    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    ////                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    ////                    let items = try decoder.decode(MoviesResult.self, from: data!)
    ////                    completion(.success(items.movies))
    ////                }
    ////                catch let error {
    ////                    completion(.failure(.error(error)))
    ////                    print("error:\(error.localizedDescription)")
    ////                }
    ////            }
    ////        }
    ////        task.resume()
    //    }

    //
    //    func loadData(url: URL, completion: @escaping ((Result<Data, Error>) -> Void)) {
    //        // Compute a path to the URL in the cache
    //        let fileCachePath = FileManager.default.temporaryDirectory
    //            .appendingPathComponent(
    //                url.lastPathComponent,
    //                isDirectory: false
    //            )
    //
    //        // If the image exists in the cache,
    //        // load the image from the cache and exit
    //        if let data = try? Data(contentsOf: fileCachePath) {
    //            completion(.success(data))
    //            return
    //        }
    //
    //        // If the image does not exist in the cache,
    //        // download the image to the cache
    //        download(url: url, toFile: fileCachePath) { (error) in
    //            do {
    //                let data = try Data(contentsOf: fileCachePath)
    //                completion(.success(data))
    //            }
    //            catch let error {
    //                completion(.failure(error))
    //            }
    //        }
    //    }
    //
    //    private func download(url: URL, toFile file: URL, completion: @escaping (Error?) -> Void) {
    //        // Download the remote URL to a file
    //        let task = URLSession.shared.downloadTask(with: url) {
    //            (tempURL, response, error) in
    //            // Early exit on error
    //            guard let tempURL = tempURL else {
    //                completion(error)
    //                return
    //            }
    //
    //            do {
    //                // Remove any existing document at file
    //                if FileManager.default.fileExists(atPath: file.path) {
    //                    try FileManager.default.removeItem(at: file)
    //                }
    //
    //                // Copy the tempURL to file
    //                try FileManager.default.copyItem(
    //                    at: tempURL,
    //                    to: file
    //                )
    //
    //                completion(nil)
    //            }
    //
    //            // Handle potential file system errors
    //            catch _ {
    //                completion(error)
    //            }
    //        }
    //
    //        // Start the download
    //        task.resume()
    //    }
    
//}
