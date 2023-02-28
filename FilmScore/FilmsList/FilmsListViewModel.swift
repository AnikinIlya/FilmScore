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
        NetworkManager.shared.fetch(dataType: SeriesCollection<Top250Series>.self, from: type) {[weak self] result in
            switch result {
            case .success(let data):
                self?.seriesList = data.items
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
    
    func getFilmDetailsViewModel(at indexPath: IndexPath) -> FilmDetailsViewModelProtocol {
        return FilmDetailsViewModel(seriesId: seriesList[indexPath.row].id)
    }
}
