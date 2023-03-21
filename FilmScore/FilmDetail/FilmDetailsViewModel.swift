//
//  FilmDetailsViewModel.swift
//  FilmScore
//
//  Created by Anikin Ilya on 21.02.2023.
//

import Foundation

//MARK: - FilmDetailsViewModelProtocol
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
    var errorMessage: String? { get }
    
    init(seriesId: String)
    
    func fetchFilm(completion: @escaping() -> Void) 
}

//MARK: - FilmDetailsViewModel
class FilmDetailsViewModel: FilmDetailsViewModelProtocol {
    
    //MARK: - Public Properties
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
        "IMDB rating - \(series?.imDbRating ?? "Not rated") ⭐️"
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
    
    var errorMessage: String?
    
    //MARK: - Private Properties
    private var seriesId: String
    private var series: Title?
    private var trailer: YouTubeTrailer?
    
    //MARK: - Initializer
    required init(seriesId: String) {
        self.seriesId = seriesId
    }
    
    //MARK: - Public Methods
    func fetchFilm(completion: @escaping() -> Void) {
        NetworkManager.shared.fetch(type: Title.self, endpoint: .title, titleId: seriesId) { [weak self] result in
            switch result {
            case .success(let seriesData):
                self?.series = seriesData
                self?.errorMessage = seriesData.errorMessage
                self?.fetchTrailer()
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchTrailer(){
        NetworkManager.shared.fetch(type: YouTubeTrailer.self, endpoint: .trailer, titleId: seriesId) {[weak self] result in
            switch result {
            case .success(let trailerData):
                self?.trailer = trailerData
                self?.errorMessage = trailerData.errorMessage
            case .failure(let error):
                print(error)
            }
        }
    }
}
