//
//  FilmDetailsViewController.swift
//  FilmScore
//
//  Created by Anikin Ilya on 22.02.2023.
//

import UIKit
import SafariServices

class FilmDetailsViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var yearAndRuntimeLabel: UILabel!
    @IBOutlet var plotLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var starsLabel: UILabel!
    @IBOutlet var directorsLabel: UILabel!
    
    //MARK: - Public Properties
    var viewModel: FilmDetailsViewModelProtocol! {
        didSet{
            viewModel.fetchFilm { [weak self] in
                self?.setupUI()
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
    @IBAction func whatchTrailerButtonPressed(_ sender: Any) {
        guard let url = URL(string: viewModel.filmTrailer) else { return }
        let trailerView = SFSafariViewController(url: url)
        
        present(trailerView, animated: true)
    }
    
    //MARK: - PrivateMethods
    private func setupUI() {
        self.title = viewModel.filmTitle
        imageView.image = UIImage(data: viewModel.imageData ?? Data())
        genreLabel.text = viewModel.filmGenre
        yearAndRuntimeLabel.text = viewModel.filmYearAndRuntimeLabel
        plotLabel.text = viewModel.filmPlot
        ratingLabel.text = viewModel.filmRating
        starsLabel.text = viewModel.filmStars
        directorsLabel.text = viewModel.filmDirectors
    }
    
    private func showActivityIndicator(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        
        return activityIndicator
    }
}
