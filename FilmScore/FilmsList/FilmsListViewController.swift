//
//  FilmsListViewController.swift
//  FilmScore
//
//  Created by Anikin Ilya on 21.02.2023.
//

import UIKit

class FilmsListViewController: UITableViewController {
    //MARK: - IBOutlets
    @IBOutlet var searchBar: UISearchBar!
    
    //MARK: - Private Properties
    private var activityIndicatro: UIActivityIndicatorView?
    private var viewModel: FilmsListViewModelProtocol! {
        didSet {
            viewModel.fetchFilms(of: .topFilms) { [weak self] in
                print("Hello")
                self?.tableView.reloadData()
                self?.activityIndicatro?.stopAnimating()
            }
        }
    }
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FilmsListViewModel()
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
}
