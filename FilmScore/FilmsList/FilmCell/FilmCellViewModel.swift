//
//  FilmCellViewModel.swift
//  FilmScore
//
//  Created by Anikin Ilya on 13.02.2023.
//

import Foundation

protocol FilmCellViewModelProtocol {
    var imageData: Data? { get }
    var title: String { get }
    var crew: String { get }
    var rating: String { get }
    
    init (film: Top250Series)
}

class FilmCellViewModel: FilmCellViewModelProtocol {
    //MARK: - Privae Properties
    private let film: Top250Series
    
    //MARK: - Public Properties
    var imageData: Data? {
        ImageManager.shared.fetchImage(from: film.image)
    }
    
    var title: String {
        film.fullTitle
    }
    
    var crew: String {
        film.crew
    }
    
    var rating: String {
        film.imDbRating
    }
    
    //MARK: - Initializers
    required init(film: Top250Series) {
        self.film = film
    }
}
