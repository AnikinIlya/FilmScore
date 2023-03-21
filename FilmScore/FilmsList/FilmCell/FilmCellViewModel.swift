//
//  FilmCellViewModel.swift
//  FilmScore
//
//  Created by Anikin Ilya on 13.02.2023.
//

import Foundation

//MARK: - FilmCellViewModelProtocol
protocol FilmCellViewModelProtocol {
    var imageData: Data? { get }
    var title: String { get }
    var crew: String { get }
    var rating: String { get }
    
    init (film: Series)
}

//MARK: - FilmCellViewModel
class FilmCellViewModel: FilmCellViewModelProtocol {
    //MARK: - Privae Properties
    private let film: Series
    
    //MARK: - Public Properties
    var imageData: Data? {
        ImageManager.shared.fetchImage(from: film.image)
    }
    
    var title: String {
        film.fullTitle
    }
    
    var crew: String {
        film.crew ?? film.plot ?? "No description"
    }
    
    var rating: String {
        film.imDbRating ?? "Not rated"
    }
    
    //MARK: - Initializer
    required init(film: Series) {
        self.film = film
    }
}
