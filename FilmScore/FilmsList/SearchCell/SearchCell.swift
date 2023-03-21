//
//  SearchCell.swift
//  FilmScore
//
//  Created by Anikin Ilya on 20.03.2023.
//

import UIKit

//MARK: - SearchCell
class SearchCell: UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    //MARK: - Public Properties
    var viewModel: SearchCellViewModelProtocol! {
        didSet {
            guard let imageData = viewModel.imageData else { return }
            posterImage.image = UIImage(data: imageData)
            
            titleLabel.text = viewModel.title
            descriptionLabel.text = viewModel.description
        }
    }

}
