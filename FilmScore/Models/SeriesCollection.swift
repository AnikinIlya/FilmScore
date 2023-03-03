//
//  SeriesCollection.swift
//  FilmScore
//
//  Created by Anikin Ilya on 13.02.2023.
//

import Foundation

enum RequestExpression: String, Decodable {
    case search = "SearchMovie"
    case title = "Title"
    case trailer = "YouTubeTrailer"
    case topMovies = "Top250Movies"
    case comingSoonFilms = "ComingSoon"
    case mostPopularMovies = "MostPopularMovies"
    case inTheaters = "InTheaters"
}

struct Title: Decodable {
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

struct SearchMovie: Decodable {
    let expression: String
    let results: MovieSearchResponse
}

struct MovieSearchResponse: Decodable {
    let id: String
    let image: String
    let title: String
    let description: String
}

struct SeriesCollection<T: Decodable>: Decodable{
    let items: [T]
    let errorMessage: String
}

//SeriesCollection
struct Top250Movies: Decodable {
    let id: String
    let title: String
    let fullTitle: String
    let year: String
    let image: String
    let crew: String
    let imDbRating: String
}

//SeriesCollection
struct MostPopularMovies: Decodable {
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
struct ComingSoon: Decodable {
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

//InTheaters, SeriesCollection
struct Genre: Decodable {
    let key: String
    let value: String
}

struct YouTubeTrailer: Decodable {
    let videoUrl: String
}
