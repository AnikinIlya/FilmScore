//
//  FilmsListViewModel.swift
//  FilmScore
//
//  Created by Anikin Ilya on 12.02.2023.
//

import Foundation

protocol FilmsListViewModelProtocol {
    func fetchFilms(of type: DataType, completion: @escaping() -> Void)
    func numberOfRows() -> Int
    func getFilmCellViewModel(at indexPath: IndexPath) -> FilmCellViewModelProtocol
    func getFilmDetailsViewModel(at indexPath: IndexPath) -> FilmDetailsViewModelProtocol
}

class FilmsListViewModel: FilmsListViewModelProtocol {
    //MARK: - Private Properties
    private var seriesList: [Top250Series] = []
    private var series: SeriesById?
    
    //MARK: - Public Methods
    func fetchFilms(of type: DataType, completion: @escaping () -> Void) {
        NetworkManager.shared.fetchData(of: type) { result in
            switch result {
            case .success(let data):
                self.seriesList = data.items
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getFilmCellViewModel(at indexPath: IndexPath) -> FilmCellViewModelProtocol {
        FilmCellViewModel(film: seriesList[indexPath.row])
    }
    
    func numberOfRows() -> Int {
        seriesList.count
    }
    
    func fetchFilm(by titleId: String) {
        NetworkManager.shared.fetchData(by: titleId) { result in
            switch result {
            case .success(let data):
                self.series = data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getFilmDetailsViewModel(at indexPath: IndexPath) -> FilmDetailsViewModelProtocol {
        fetchFilm(by: seriesList[indexPath.row].id)
        return FilmDetailsViewModel(series: series ?? SeriesById(id: "", title: "", year: "", image: "", runtimeMins: "", plot: "", directors: "", writers: "", stars: "", genres: "", imDbRating: ""))
    }
}
