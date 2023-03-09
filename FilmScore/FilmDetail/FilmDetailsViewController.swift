//
//  FilmDetailsViewController.swift
//  FilmScore
//
//  Created by Anikin Ilya on 22.02.2023.
//

import UIKit
import SafariServices

//MARK: - FilmDetailsViewController
class FilmDetailsViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var yearAndRuntimeLabel: UILabel!
    @IBOutlet var plotLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var starsLabel: UILabel!
    @IBOutlet var directorsLabel: UILabel!
    @IBOutlet var watchTrailerButton: UIButton!
    @IBOutlet var addToFavoriteButton: UIBarButtonItem!
    
    //MARK: - Public Properties
    var viewModel: FilmDetailsViewModelProtocol! {
        didSet{
            viewModel.fetchFilm { [weak self] in
                if self?.viewModel.errorMessage == "" {
                    self?.setupUI()
                } else {
                    self?.setupAlertController(viewModelError: self?.viewModel)
                }
                self?.activityIndicator?.stopAnimating()
            }
        }
    }
    
    //MARK: - Private Properties
    private var activityIndicator: UIActivityIndicatorView?
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = showActivityIndicator(in: view)
    }
    
    //MARK: - IBActions
    @IBAction func whatchTrailerButtonPressed(_ sender: UIButton) {
        guard let url = URL(string: viewModel.filmTrailer) else { return }
        let trailerView = SFSafariViewController(url: url)
        
        present(trailerView, animated: true)
    }
    
    @IBAction func addToFavoriteButtonPressed(_ sender: UIButton) {
        addToFavoriteButton.image = UIImage(systemName: "heart.fill")
        addToFavoriteButton.tintColor = .systemRed
    }
}

//MARK: - Extensions
private extension FilmDetailsViewController {
    func setupUI() {
        self.title = viewModel.filmTitle
        imageView.image = UIImage(data: viewModel.imageData ?? Data())
        genreLabel.text = viewModel.filmGenre
        yearAndRuntimeLabel.text = viewModel.filmYearAndRuntimeLabel
        plotLabel.text = viewModel.filmPlot
        ratingLabel.text = viewModel.filmRating
        starsLabel.text = viewModel.filmStars
        directorsLabel.text = viewModel.filmDirectors
        
        hideUI(false)
    }
    
    func showActivityIndicator(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .systemYellow
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        hideUI(true)
        
        return activityIndicator
    }
    
    func hideUI(_ statement:Bool) {
        imageView.isHidden = statement
        genreLabel.isHidden = statement
        yearAndRuntimeLabel.isHidden = statement
        plotLabel.isHidden = statement
        ratingLabel.isHidden = statement
        starsLabel.isHidden = statement
        directorsLabel.isHidden = statement
        watchTrailerButton.isHidden = statement
        addToFavoriteButton.customView?.isHidden = statement
    }
    
    func setupAlertController(viewModelError: FilmDetailsViewModelProtocol?) {
        let alertController = UIAlertController(title: "Service Error", message: viewModelError?.errorMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(named: "AccentColor")
        alertController.view.tintColor = UIColor(named: "TintColor")
        
        present(alertController, animated: true)
    }
}
