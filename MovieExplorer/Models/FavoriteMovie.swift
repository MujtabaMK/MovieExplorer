//
//  FavoriteMovie.swift
//  MovieExplorer
//
//  Created by Mujtaba Khan on 08/07/25.
//

import Foundation
import RealmSwift

class FavoriteMovie: Object, Identifiable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var posterPath: String
    @Persisted var rating: Double?
    @Persisted var genreIDs: List<Int>
    @Persisted var overview: String
    @Persisted var releaseDate: String

    func asMovie() -> Movie {
        Movie(
            id: id,
            title: title,
            originalTitle: title,
            overview: overview,
            posterPath: posterPath,
            backdropPath: nil,
            releaseDate: releaseDate,
            voteAverage: rating ?? 0.0,
            voteCount: 0,
            popularity: 0.0,
            adult: false,
            genreIDs: Array(genreIDs),
            originalLanguage: "en",
            video: false
        )
    }
}
