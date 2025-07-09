//
//  FavoritesView.swift
//  MovieExplorer
//
//  Created by Mujtaba Khan on 08/07/25.
//

import SwiftUI

struct FavoritesView: View {
    @State private var favoriteMovies: [Movie] = []

    var body: some View {
        NavigationView {
            List(favoriteMovies, id: \.id) { movie in
                NavigationLink(destination: MovieDetailView(movie: movie)) {
                    HStack {
                        AsyncImage(url: URL(string: "\(API.imageBaseURL)\(movie.posterPath ?? "")")) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else {
                                Color.gray
                            }
                        }
                        .frame(width: 60, height: 90)
                        .cornerRadius(8)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(movie.title)
                                .font(.headline)
                            Text("⭐️ \(String(format: "%.1f", movie.voteAverage))/10")
                                .font(.subheadline)
                                .foregroundColor(.yellow)
                        }
                    }
                }
            }
            .navigationTitle("❤️ Favorites")
            .onAppear {
                let realmFavorites = FavoriteManager.shared.getAllFavorites()
                favoriteMovies = realmFavorites.map { $0.asMovie() } // 🔐 Safe conversion to struct
            }
        }
    }
}
