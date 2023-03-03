//
//  NetworkManager.swift
//  FilmScore
//
//  Created by Anikin Ilya on 13.02.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    //MARK: - Private Properties
    private let apiKey = API().apiKey
    
    //MARK: - Public Properties
    static let shared = NetworkManager()
    
    //MARK: - Initializers
    private init() {}
    
    //MARK: - Public Methods
    func fetch<T: Decodable>(type: T.Type, from requestExpression: RequestExpression, titleId: String = "", searchWords: String = "", completion: @escaping(Result<T, NetworkError>) -> Void) {
        var url = URL(string: "")
        
        switch requestExpression {
        case .search:
            url = URL(string: "https://imdb-api.com/API/\(requestExpression.rawValue)/\(apiKey)/\(searchWords)")
        case .title, .trailer:
            url = URL(string: "https://imdb-api.com/API/\(requestExpression.rawValue)/\(apiKey)/\(titleId)")
        case .topMovies, .comingSoonFilms, .mostPopularMovies, .inTheaters:
            url = URL(string: "https://imdb-api.com/API/\(requestExpression.rawValue)/\(apiKey)")
        }
        
        guard let url = url else {
            return completion(.failure(.invalidURL))
        }
        
        let urlRequest = NSURLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest as URLRequest) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                completion(.failure(.noData))
                return
            }
            do {
                let series = try JSONDecoder().decode(type.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(series))
                }
            } catch {
                print(error.localizedDescription)
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
