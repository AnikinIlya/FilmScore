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

enum DataType: String {
    case title = "Title"
    case trailer = "Trailer"
    case topMovies = "Top250Movies"
    case comingSoonFilms = "ComingSoon"
    case mostPopularSeries = "MostPopularSeries"
    case inTheaters = "InTheaters"
}

class NetworkManager {
    //MARK: - Private Properties
    private let apiKey = API().apiKey
    
    //MARK: - Public Properties
    static let shared = NetworkManager()
    
    //MARK: - Initializers
    private init() {}
    
    //MARK: - Public Methods
    func fetch<T: Decodable>(dataType: T.Type, from type: DataType, titleId: String = "", completion: @escaping(Result<T, NetworkError>) -> Void) {
        var url = URL(string: "")
        
        switch type {
        case .title, .trailer:
            url = URL(string: "https://imdb-api.com/API/\(type.rawValue)/\(apiKey)/\(titleId)")
        case .topMovies, .comingSoonFilms, .mostPopularSeries, .inTheaters:
            url = URL(string: "https://imdb-api.com/API/\(type.rawValue)/\(apiKey)")
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
                let series = try JSONDecoder().decode(T.self, from: data)
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
