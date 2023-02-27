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
    var filmYearAndRuntimeLabel: String { get }
    var filmPlot: String { get }
    var filmRating: String { get }
    var filmStars: String { get }
    var filmDirectors: String { get }
    
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
    
    var filmYearAndRuntimeLabel: String {
        "\(series?.year ?? ""), \(series?.runtimeMins ?? "") minutes"
    }
    
    var filmPlot: String {
        series?.plot ?? ""
    }
    
    var filmRating: String {
        "IMDB rating - \(series?.imDbRating ?? "")/10 ⭐️"
    }
    
    var filmStars: String {
        series?.stars.replacingOccurrences(of: ", ", with: "\n") ?? ""
    }
    
    var filmDirectors: String {
        series?.directors.replacingOccurrences(of: ", ", with: "\n") ?? ""
    }
    
    private var seriesId: String
    private var series: SeriesById?
    
    required init(seriesId: String) {
        self.seriesId = seriesId
    }
    
    func fetchFilm(completion: @escaping() -> Void) {
        
        NetworkManager.shared.fetch(dataType: SeriesById.self, from: .title, titleId: seriesId) { result in
            switch result {
            case .success(let data):
                self.series = data
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func fetchTrailer(completion: @escaping() -> Void) {
        NetworkManager.shared.fetch(dataType: Trailer.self, from: .trailer, titleId: seriesId) { result in
            switch result {
            case .success(_):
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
}
