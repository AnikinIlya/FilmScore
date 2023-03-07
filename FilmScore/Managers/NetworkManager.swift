//
//  NetworkManager.swift
//  FilmScore
//
//  Created by Anikin Ilya on 13.02.2023.
//

import Foundation

//MARK: - NetworkErrors
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

//MARK: - Endpoints
enum Endpoints: String, Decodable {
    case search = "SearchMovie"
    case title = "Title"
    case trailer = "YouTubeTrailer"
    case topMovies = "Top250Movies"
    case comingSoonFilms = "ComingSoon"
    case mostPopularMovies = "MostPopularMovies"
    case inTheaters = "InTheaters"
}

//MARK: - Network Manager
class NetworkManager {
    
    //MARK: - Public Properties
    static let shared = NetworkManager()
    
    //MARK: - Private Properties
    private let apiKey = API().apiKey
    
    //MARK: - Initializers
    private init() {}
    
    //MARK: - Public Methods
    func fetch<T: Decodable>(type: T.Type, endpoint: Endpoints, titleId: String = "", searchWords: String = "", completion: @escaping(Result<T, NetworkError>) -> Void) {
        var url = URL(string: "")
        
        switch endpoint {
        case .search:
            url = URL(string: "https://imdb-api.com/API/\(endpoint.rawValue)/\(apiKey)/\(searchWords)")
        case .title, .trailer:
            url = URL(string: "https://imdb-api.com/API/\(endpoint.rawValue)/\(apiKey)/\(titleId)")
        case .topMovies, .comingSoonFilms, .mostPopularMovies, .inTheaters:
            url = URL(string: "https://imdb-api.com/API/\(endpoint.rawValue)/\(apiKey)")
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
