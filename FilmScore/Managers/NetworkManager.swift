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
    case topFilms = "Top250Movies"
    case comingSoonFilms = "ComingSoon"
}

class NetworkManager {
    //MARK: - Private Properties
    private let apiKey = API().apiKey
    
    //MARK: - Public Properties
    static let shared = NetworkManager()
    
    //MARK: - Initializers
    private init() {}
    
    //MARK: - Public Methods
    func fetchData(of type: DataType, completion: @escaping(Result<SeriesCollection<Top250Series>, NetworkError>) -> Void) {
        guard let url = URL(string: "https://imdb-api.com/API/\(type.rawValue)/\(apiKey)") else { return completion(.failure(.invalidURL))}
        let urlRequest = NSURLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest as URLRequest) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                completion(.failure(.noData))
                return
            }
            do {
                let series = try JSONDecoder().decode(SeriesCollection<Top250Series>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(series))
                }
            } catch {
                print(error.localizedDescription)
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchData(by titleId: String,completion: @escaping(Result<SeriesById, NetworkError>) -> Void) {
        guard let url = URL(string: "https://imdb-api.com/API/Title/\(apiKey)/\(titleId)") else { return completion(.failure(.invalidURL))}
        let urlRequest = NSURLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest as URLRequest) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                completion(.failure(.noData))
                return
            }
            do {
                let series = try JSONDecoder().decode(SeriesById.self, from: data)
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
