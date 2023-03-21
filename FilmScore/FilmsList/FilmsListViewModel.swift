//
//  FilmsListViewModel.swift
//  FilmScore
//
//  Created by Anikin Ilya on 12.02.2023.
//

import Foundation

//MARK: - FilmsListViewModelProtocol
protocol FilmsListViewModelProtocol {
    var errorMessage: String? { get }
    func fetchFilms(from endpoint: Endpoints, completion: @escaping() -> Void)
    func fetchSearchResults(searchText: String, completion: @escaping () -> Void)
    func numberOfRowsForFilmCell() -> Int
    func numberOfRowsForSearchCell() -> Int
    func getFilmCellViewModel(at indexPath: IndexPath) -> FilmCellViewModelProtocol
    func getSearchCellViewModel(at indexPath: IndexPath) -> SearchCellViewModelProtocol
    func getFilmDetailsViewModelForFilmCell(at indexPath: IndexPath) -> FilmDetailsViewModelProtocol
    func getFilmDetailsViewModelForSearchCell(at indexPath: IndexPath) -> FilmDetailsViewModelProtocol
    func clearResults()
}

//MARK: - FilmsListViewModel
class FilmsListViewModel: FilmsListViewModelProtocol {
    //MARK: - Public Properties
    var errorMessage: String?
    
    //MARK: - Private Properties
    private var seriesList: [Series] = []
    private var searchListResult: [MovieSearchResponse] = []
    private var series: Title?
    
    //MARK: - Public Methods
    func fetchFilms(from endpoint: Endpoints, completion: @escaping () -> Void) {
        NetworkManager.shared.fetch(type: SeriesCollection.self, endpoint: endpoint) { [weak self] result in
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
    
    func fetchSearchResults(searchText: String, completion: @escaping () -> Void) {
        NetworkManager.shared.fetch(type: SearchMovie.self, endpoint: .search, searchWords: searchText) { [weak self] result in
            switch result {
            case .success(let data):
                self?.searchListResult = data.results
                self?.errorMessage = data.errorMessage
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func clearResults() {
        seriesList = []
        searchListResult = []
    }
    
    func getFilmCellViewModel(at indexPath: IndexPath) -> FilmCellViewModelProtocol {
        FilmCellViewModel(film: seriesList[indexPath.row])
    }
    
    func getSearchCellViewModel(at indexPath: IndexPath) -> SearchCellViewModelProtocol {
        SearchCellViewModel(film: searchListResult[indexPath.row])
    }
    
    func numberOfRowsForFilmCell() -> Int {
        seriesList.count
    }
    
    func numberOfRowsForSearchCell() -> Int {
        searchListResult.count
    }
    
    func getFilmDetailsViewModelForFilmCell(at indexPath: IndexPath) -> FilmDetailsViewModelProtocol {
        return FilmDetailsViewModel(seriesId: seriesList[indexPath.row].id)
    }
    
    func getFilmDetailsViewModelForSearchCell(at indexPath: IndexPath) -> FilmDetailsViewModelProtocol {
        return FilmDetailsViewModel(seriesId: searchListResult[indexPath.row].id)
    }
}
