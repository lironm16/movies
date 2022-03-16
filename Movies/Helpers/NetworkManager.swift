//
//  NetworkManager.swift
//  Movies
//
//  Created by Liron Matityahu on 11/03/2022.
//

import Foundation
import Combine

enum Endpoint: String {
    case movies
    case details
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
//    private init() {
//
//    }
    
    private var cancellables = Set<AnyCancellable>()
    private let baseURL = "https://wookie.codesubmit.io/"
    
    
    func getData<T: Codable>(endpoint: Endpoint, search: String? = nil, type: T.Type, decoder: JSONDecoder = JSONDecoder()) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NetworkError.unknown))
                return
            }
            var urlComponents = URLComponents(string: self.baseURL.appending(endpoint.rawValue))
            
            if let searchText = search, !searchText.isEmpty {
                urlComponents?.queryItems = [
                URLQueryItem(name: "q", value: search)
                ]
            }
            
            guard let url = urlComponents?.url else { promise(.failure(NetworkError.invalidURL))
                return
            }
            print("URL is \(url.absoluteString)")
            var request = URLRequest(url:url ,cachePolicy: .reloadIgnoringCacheData)
            request.setValue("Bearer Wookie2019", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTaskPublisher(for: request)
                .print()
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: decoder)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: { promise(.success($0)) })
                .store(in: &self.cancellables)
        }
    }
}


enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}
