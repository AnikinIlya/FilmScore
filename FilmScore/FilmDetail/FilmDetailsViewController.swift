//
//  FilmDetailsViewController.swift
//  FilmScore
//
//  Created by Anikin Ilya on 22.02.2023.
//

import UIKit

class FilmDetailsViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var yearAndRuntimeLabel: UILabel!
    @IBOutlet var plotLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var starsLabel: UILabel!
    @IBOutlet var directorsLabel: UILabel!
    @IBOutlet var writersLabel: UILabel!
    @IBOutlet var trailersLabel: UILabel!
    
    //MARK: - Public Methods
    var viewModel: FilmDetailsViewModelProtocol!
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - PrivateMethods
    private func setupUI() {
        self.title = viewModel.filmTitle
        imageView.image = UIImage(data: viewModel.imageData ?? Data())
        genreLabel.text = viewModel.filmGenre
        yearAndRuntimeLabel.text = "\(viewModel.filmYear), \(viewModel.filmRuntime) minutes"
        plotLabel.text = viewModel.filmPlot
        ratingLabel.text = "\(viewModel.filmRating)/10 ⭐️"
        starsLabel.text = "Starring\n" + viewModel.filmStars.replacingOccurrences(of: ", ", with: "\n")
        directorsLabel.text = "Director(s)\n" + viewModel.filmDirectors.replacingOccurrences(of: ", ", with: "\n")
        writersLabel.text = "Producer(s)" + viewModel.filmWriters.replacingOccurrences(of: ", ", with: "\n")
    }
}
