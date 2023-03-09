//
//  FilmsListViewModel.swift
//  FilmScore
//
//  Created by Anikin Ilya on 12.02.2023.
//

import Foundation

protocol FilmsListViewModelProtocol {
    var errorMessage: String? { get }
    func fetchFilms(from endpoint: Endpoints, searchWords: String, completion: @escaping() -> Void)
    func numberOfRows() -> Int
    func getFilmCellViewModel(at indexPath: IndexPath) -> FilmCellViewModelProtocol
    func getFilmDetailsViewModel(at indexPath: IndexPath) -> FilmDetailsViewModelProtocol
    func clearResults()
}

class FilmsListViewModel: FilmsListViewModelProtocol {
    //MARK: - Public Properties
    var errorMessage: String?
    
    //MARK: - Private Properties
    private var seriesList: [Series] = []
    private var series: Title?
    
    //MARK: - Public Methods
    func fetchFilms(from endpoint: Endpoints, searchWords: String = "", completion: @escaping () -> Void) {
        NetworkManager.shared.fetch(type: SeriesCollection.self, endpoint: endpoint, searchWords: searchWords) { [weak self] result in
            switch result {
            case .success(let data):
                self?.seriesList = data.items
                self?.errorMessage = data.errorMessage
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func clearResults() {
        seriesList = []
    }
    
    func getFilmCellViewModel(at indexPath: IndexPath) -> FilmCellViewModelProtocol {
        FilmCellViewModel(film: seriesList[indexPath.row])
    }
    
    func numberOfRows() -> Int {
        seriesList.count
    }
    
    func getFilmDetailsViewModel(at indexPath: IndexPath) -> FilmDetailsViewModelProtocol {
        return FilmDetailsViewModel(seriesId: seriesList[indexPath.row].id)
    }
}
