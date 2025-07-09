//
//  GenreMapper.swift
//  MovieExplorer
//
//  Created by Mujtaba Khan on 08/07/25.
//

import Foundation

// Helpers/GenreMapper.swift
struct GenreMapper {
    static let genreMap: [Int: String] = [
        28: "Action",
        12: "Adventure",
        16: "Animation",
        35: "Comedy",
        80: "Crime",
        99: "Documentary",
        18: "Drama",
        10751: "Family",
        14: "Fantasy",
        36: "History",
        27: "Horror",
        10402: "Music",
        9648: "Mystery",
        10749: "Romance",
        878: "Sci-Fi",
        10770: "TV Movie",
        53: "Thriller",
        10752: "War",
        37: "Western"
    ]
    
    static func names(for ids: [Int]) -> String {
        ids.compactMap { genreMap[$0] }.joined(separator: ", ")
    }
}
