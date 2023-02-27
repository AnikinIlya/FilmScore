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
    
    init(seriesId: String)
    
    func fetchFilm(completion: @escaping() -> Void) 
}

class FilmDetailsViewModel: FilmDetailsViewModelProtocol {
    
    
    var filmTitle: String {
        series?.title ?? ""
    }
    
    var imageData: Data? {
        ImageManager.shared.fetchImage(from: series?.image)
    }
    
    var filmGenre: String {
        series?.genres ?? ""
    }
    
    var filmYear: String {
        series?.year ?? ""
    }
    
    var filmRuntime: String {
        series?.runtimeMins ?? ""
    }
    
    var filmPlot: String {
        series?.plot ?? ""
    }
    
    var filmRating: String {
        series?.imDbRating ?? ""
    }
    
    var filmStars: String {
        series?.stars ?? ""
    }
    
    var filmDirectors: String {
        series?.directors ?? ""
    }
    
    var filmWriters: String {
        series?.writers ?? ""
    }
    
    var filmTrailers: String {
        series?.writers ?? ""
    }
    
    private var seriesId: String
    private var series: SeriesById?
    
    required init(seriesId: String) {
        self.seriesId = seriesId
    }
    
    func fetchFilm(completion: @escaping() -> Void) {
        NetworkManager.shared.fetchData(by: seriesId) { result in
            switch result {
            case .success(let data):
                self.series = data
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
}
