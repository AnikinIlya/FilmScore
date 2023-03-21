//
//  SearchCellViewModel.swift
//  FilmScore
//
//  Created by Anikin Ilya on 20.03.2023.
//

import Foundation

//MARK: - SearchCellViewModelProtocol
protocol SearchCellViewModelProtocol {
    var imageData: Data? { get }
    var title: String { get }
    var description: String { get }
    
    init(film: MovieSearchResponse)
}

//MARK: - SearchCellViewModel
class SearchCellViewModel: SearchCellViewModelProtocol {
    //MARK: - Privae Properties
    private let film: MovieSearchResponse
    
    //MARK: - Public Properties
    var imageData: Data? {
        ImageManager.shared.fetchImage(from: film.image)
    }
    
    var title: String {
        film.title
    }
    
    var description: String {
        film.description
    }
    
    //MARK: - Initializer
    required init(film: MovieSearchResponse) {
        self.film = film
    }
}
