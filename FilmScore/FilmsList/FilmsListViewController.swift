//
//  FilmsListViewController.swift
//  FilmScore
//
//  Created by Anikin Ilya on 21.02.2023.
//

import UIKit

//MARK: - FilmsListViewController
class FilmsListViewController: UITableViewController {
    
    //MARK: - Private Properties
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var searchBarIsFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private var topMenu = UIMenu()
    private var activityIndicator: UIActivityIndicatorView?
    
    private var endpoint: Endpoints = .topMovies {
        didSet {
            self.activityIndicator?.startAnimating()
            viewModel.clearResults()
            self.tableView.reloadData()
            
            viewModel.fetchFilms(from: endpoint) { [weak self] in
                if self?.viewModel.errorMessage == "" {
                    self?.tableView.reloadData()
                } else {
                    self?.setupAlertController(viewModelError: self?.viewModel)
                }
                self?.activityIndicator?.stopAnimating()
            }
        }
    }
    
    private var viewModel: FilmsListViewModelProtocol! {
        didSet {
            viewModel.fetchFilms(from: endpoint) { [weak self] in
                if self?.viewModel.errorMessage == "" {
                    self?.tableView.reloadData()
                } else {
                    self?.setupAlertController(viewModelError: self?.viewModel)
                }
                self?.activityIndicator?.stopAnimating()
            }
        }
    }
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = FilmsListViewModel()
        setupView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let filmDetail = segue.destination as? FilmDetailsViewController else { return }
        filmDetail.viewModel = sender as? FilmDetailsViewModelProtocol
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBarIsFiltering {
                return viewModel.numberOfRowsForSearchCell()
        }
        return viewModel.numberOfRowsForFilmCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searchBarIsFiltering {
            let cell = Bundle.main.loadNibNamed("SearchCell", owner: self)?.first
            guard let cell = cell as? SearchCell else { return UITableViewCell() }
            cell.viewModel = viewModel.getSearchCellViewModel(at: indexPath)
            
            return cell
        } else {
            let cell = Bundle.main.loadNibNamed("FilmCell", owner: self)?.first
            guard let cell = cell as? FilmCell else { return UITableViewCell() }
            cell.viewModel = viewModel.getFilmCellViewModel(at: indexPath)
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var filmDetailsViewModel: FilmDetailsViewModelProtocol
        if searchBarIsFiltering {
            filmDetailsViewModel = viewModel.getFilmDetailsViewModelForSearchCell(at: indexPath)
        } else {
            filmDetailsViewModel = viewModel.getFilmDetailsViewModelForFilmCell(at: indexPath)
        }
        performSegue(withIdentifier: "showDetails", sender: filmDetailsViewModel)
    }
}

//MARK: - UISearchResultsUpdating
extension FilmsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        getSearchResult(searchText)
    }
    
    func getSearchResult(_ searchText: String) {
        self.activityIndicator?.startAnimating()
        viewModel.clearResults()
        self.tableView.reloadData()
        
        viewModel.fetchSearchResults(searchText: searchText) { [weak self] in
            if self?.viewModel.errorMessage == "" {
                self?.tableView.reloadData()
            } else {
                self?.setupAlertController(viewModelError: self?.viewModel)
            }
            self?.activityIndicator?.stopAnimating()
        }
    }
}

//MARK: - Setting View
extension FilmsListViewController {
    func setupView() {
        self.title = "Top 250 Movies"
        activityIndicator = setupActivityIndicator(in: view)
        setupSearchController()
        setupTopMenu()
    }
    
    func setupActivityIndicator(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .systemYellow
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        
        return activityIndicator
    }
    
    func setupSearchController(){
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.barTintColor = .systemYellow
        searchController.searchBar.tintColor = .black
    }
    
    func setupTopMenu() {
        let top250Movies = UIAction(title: "Top 250 Movies", image: UIImage(systemName: "star.fill")) { [unowned self] _ in
            self.endpoint = .topMovies
            self.title = "Top 250 Movies"
        }
        
        let comingSoon = UIAction(title: "Coming Soon", image: UIImage(systemName: "clock")) { [unowned self] _ in
            self.endpoint = .comingSoonFilms
            self.title = "Coming Soon"
        }
        
        let mostPopular = UIAction(title: "Most Popular now", image: UIImage(systemName: "forward.end.fill")) { [unowned self] _ in
            self.endpoint = .mostPopularMovies
            self.title = "Most Popular now"
        }
        
        let inTheaters = UIAction(title: "In Theaters", image: UIImage(systemName: "ticket")) { [unowned self] _ in
            self.endpoint = .inTheaters
            self.title = "In Theaters"
        }
        
        let favoriteMovies = UIAction(title: "Favorite Movies", image: UIImage(systemName: "heart.fill")) { [unowned self] _ in
            self.title = "Favorite Movies"
        }
        
        topMenu = UIMenu(title: "Options", children: [top250Movies, comingSoon, mostPopular, inTheaters, favoriteMovies])
        
        let barItemRight = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), menu: topMenu)
        navigationItem.rightBarButtonItem = barItemRight
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    func setupAlertController(viewModelError: FilmsListViewModelProtocol?) {
        let alertController = UIAlertController(title: "Service Error", message: viewModelError?.errorMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(named: "AccentColor")
        alertController.view.tintColor = UIColor(named: "TintColor")
        
        present(alertController, animated: true)
    }
}
