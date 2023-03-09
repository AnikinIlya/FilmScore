//
//  SeriesCollection.swift
//  FilmScore
//
//  Created by Anikin Ilya on 13.02.2023.
//

import Foundation

//MARK: - Title
//Model for FilmDetailsView, for detailed information about a movie
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
    let imDbRating: String?
    let errorMessage: String
}

//MARK: - YouTubeTrailer
//Model for FilmDetailsView, for YouTube trailer
struct YouTubeTrailer: Decodable {
    let videoUrl: String
    let errorMessage: String
}

//MARK: - SearchMovie
//Model for FilmList, for search bar results
struct SearchMovie: Decodable {
    let expression: String
    let results: [MovieSearchResponse]
    let errorMessage: String
}

struct MovieSearchResponse: Decodable {
    let id: String
    let image: String
    let title: String
    let description: String
}

//MARK: - SeriesCollection
//Model for FilmList, for most popular right now, top, coming soon and in theaters results
struct SeriesCollection: Decodable{
    let items: [Series]
    let errorMessage: String
}

struct Series: Decodable {
    let id: String
    let fullTitle: String
    let image: String
    let crew: String?
    let plot: String?
    let imDbRating: String?
}
