//
//  FilmCell.swift
//  FilmScore
//
//  Created by Anikin Ilya on 13.02.2023.
//

import UIKit

class FilmCell: UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var crewLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    
    //MARK: - Public Properties
    var viewModel: FilmCellViewModelProtocol! {
        didSet {
            guard let imageData = viewModel.imageData else { return }
            posterImage.image = UIImage(data: imageData)
            
            titleLabel.text = viewModel.title
            crewLabel.text = viewModel.crew
            ratingLabel.text = "⭐️" + viewModel.rating
        }
    }
}

