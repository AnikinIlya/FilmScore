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
    var filmTrailer: String { get }
    
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
    
    var filmTrailer: String {
        trailer?.videoUrl ?? ""
    }
    
    private var seriesId: String
    private var series: Title?
    private var trailer: YouTubeTrailer?
    
    required init(seriesId: String) {
        self.seriesId = seriesId
    }
    
    func fetchFilm(completion: @escaping() -> Void) {
        NetworkManager.shared.fetch(type: Title.self, from: .title, titleId: seriesId) { [weak self] result in
            switch result {
            case .success(let data):
                self?.series = data
                self?.fetchTrailer()
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func fetchTrailer(){
        NetworkManager.shared.fetch(type: YouTubeTrailer.self, from: .trailer, titleId: seriesId) {[weak self] result in
            switch result {
            case .success(let data):
                self?.trailer = data
            case .failure(let error):
                print(error)
            }
        }
    }
}
