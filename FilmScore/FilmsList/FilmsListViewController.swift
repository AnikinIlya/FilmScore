//
//  FilmsListViewController.swift
//  FilmScore
//
//  Created by Anikin Ilya on 21.02.2023.
//

import UIKit

class FilmsListViewController: UITableViewController {
    //MARK: - Private Properties
    private let searchController = UISearchController(searchResultsController: nil)
    private var activityIndicator: UIActivityIndicatorView?
    private var viewModel: FilmsListViewModelProtocol! {
        didSet {
            viewModel.fetchFilms(of: .topMovies, searchWords: "") { [weak self] in
                self?.tableView.reloadData()
                self?.activityIndicator?.stopAnimating()
            }
        }
    }
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FilmsListViewModel()
        activityIndicator = showActivityIndicator(in: view)
        setupSearchController()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let filmDetail = segue.destination as? FilmDetailsViewController else { return }
        filmDetail.viewModel = sender as? FilmDetailsViewModelProtocol
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("FilmCell", owner: self)?.first
        guard let cell = cell as? FilmCell else { return UITableViewCell() }
        cell.viewModel = viewModel.getFilmCellViewModel(at: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let filmDetailsViewModel = viewModel.getFilmDetailsViewModel(at: indexPath)
        performSegue(withIdentifier: "showDetails", sender: filmDetailsViewModel)
    }
    
    private func showActivityIndicator(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .systemYellow
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        
        return activityIndicator
    }
    
    private func setupSearchController(){
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.barTintColor = .systemYellow
        searchController.searchBar.tintColor = .black
    }
    
    
}

extension FilmsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        
    }
    
    private func getSearchResult() {
        
    }
}
