//
//  MovieNowPlayingModel.swift
//  MovieApp-MVVM
//
//  Created by Oğuzhan Erdem on 3.12.2022.
//

import Foundation

// MARK: - MovieNowPlayingModel
struct MovieNowPlayingModel: Codable {
    let page: Int?
    let results: [MovieNowPlayingInfo]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct MovieNowPlayingInfo: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String?
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case fr = "fr"
    case ja = "ja"
    case no = "no"
}
