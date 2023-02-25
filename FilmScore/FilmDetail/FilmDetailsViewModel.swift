//
//  FilmDetailsViewModel.swift
//  FilmScore
//
//  Created by Anikin Ilya on 21.02.2023.
//

import Foundation

protocol FilmDetailsViewModelProtocol {
    var filmTitle: String { get }
    var imageData: Data? { get }
    var filmGenre: String { get }
    var filmYear: String { get }
    var filmRuntime: String { get }
    var filmPlot: String { get }
    var filmRating: String { get }
    var filmStars: String { get }
    var filmDirectors: String { get }
    var filmWriters: String { get }
    var filmTrailers: String { get }
    
    init(series: SeriesById)
}

class FilmDetailsViewModel: FilmDetailsViewModelProtocol {
    
    
    var filmTitle: String {
        series.title
    }
    
    var imageData: Data? {
        ImageManager.shared.fetchImage(from: series.image)
    }
    
    var filmGenre: String {
        series.genres
    }
    
    var filmYear: String {
        series.year
    }
    
    var filmRuntime: String {
        series.runtimeMins
    }
    
    var filmPlot: String {
        series.plot
    }
    
    var filmRating: String {
        series.imDbRating
    }
    
    var filmStars: String {
        series.stars
    }
    
    var filmDirectors: String {
        series.directors
    }
    
    var filmWriters: String {
        series.writers
    }
    
    var filmTrailers: String {
        series.writers
    }
    
    private var series: SeriesById
    
    required init(series: SeriesById) {
        self.series = series
    }
}
