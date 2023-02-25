//
//  ImageManager.swift
//  FilmScore
//
//  Created by Anikin Ilya on 17.02.2023.
//

import Foundation

class ImageManager {
    //MARK: - Public Properties
    static let shared = ImageManager()
    
    //MARK: - Initializers
    private init() {}
    
    //MARK: - Public Methods
    func fetchImage(from string: String?) ->Data? {
        guard let string = string else { return nil }
        guard let url = URL(string: string) else { return nil }
        guard let imageData = try? Data(contentsOf: url) else { return nil }
        return imageData
    }
}
