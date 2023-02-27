//
//  SeriesCollection.swift
//  FilmScore
//
//  Created by Anikin Ilya on 13.02.2023.
//

import Foundation

struct SeriesById: Decodable {
    let id: String
    let title: String
    let year: String
    let image: String
    let runtimeMins: String
    let plot: String
    let directors: String
    let stars: String
    let genres: String
    let imDbRating: String
}

struct SeriesCollection<T: Decodable>: Decodable{
    let items: [T]
    let errorMessage: String
}

//SeriesCollection
struct Top250Series: Decodable {
    let id: String
    let title: String
    let fullTitle: String
    let year: String
    let image: String
    let crew: String
    let imDbRating: String
}

//SeriesCollection
struct MostPopularSeries: Decodable {
    let id: String
    let rank: String
    let rankUpDown: String
    let title: String
    let fullTitle: String
    let year: String
    let image: String
    let crew: String
    let imDbRating: String
}

//SeriesCollection
struct InTheaters: Decodable {
    let id: String
    let title: String
    let fullTitle: String
    let year: String
    let releaseState: String
    let image: String
    let runtimeStr: String
    let plot: String
    let contentRating: String
    let imDbRating: String
    let genres: String
    let genreList: [Genre]
    let directors: String
    let stars: String
}

//SeriesCollection
struct ComingSoonSeries: Decodable {
    let id: String
    let title: String
    let fullTitle: String
    let year: String
    let releaseState: String
    let image: String
    let plot: String?
    let contentRating: String
    let genres: String
    let genreList: [Genre]
    let directors: String
    let stars: String
}

struct Genre: Decodable {
    let key: String
    let value: String
}

struct Trailer: Decodable {
    let imDbId: String
    let linkEmbed: String
}
