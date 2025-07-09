//
//  MovieDetailView.swift
//  MovieExplorer
//
//  Created by Mujtaba Khan on 08/07/25.
//

import SwiftUI
import WebKit

struct MovieDetailView: View {
    let movie: Movie
    @State private var trailerKey: String?
    @State private var isFavorite = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: movie.posterURL)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 300)
                    }
                }

                HStack {
                    Text(movie.title)
                        .font(.title)
                        .bold()
                    Spacer()
                    Button(action: {
                        FavoriteManager.shared.toggleFavorite(movie)
                        isFavorite.toggle()
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                            .font(.title2)
                    }
                }

                Text("🗓 Release: \(movie.releaseDate)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("⭐️ Rating: \(String(format: "%.1f", movie.voteAverage))/10")
                    .font(.subheadline)
                    .foregroundColor(.yellow)

                Text("🏷 Genres: \(GenreMapper.names(for: movie.genreIDs))")
                    .font(.subheadline)

                Text("📝 Overview")
                    .font(.headline)
                Text(movie.overview)

                if let key = trailerKey {
                    YouTubePlayerView(videoKey: key)
                        .frame(height: 220)
                        .cornerRadius(12)
                        .padding(.top)
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .onAppear {
            isFavorite = FavoriteManager.shared.isFavorite(movie)
            fetchTrailer()
        }
    }

    private func fetchTrailer() {
        NetworkService.shared.fetchTrailer(for: movie.id) { result in
            switch result {
            case .success(let trailer):
                if let key = trailer?.key {
                    DispatchQueue.main.async {
                        trailerKey = key
                    }
                } else {
                    print("Trailer key is nil")
                }
            case .failure(let error):
                print("Failed to load trailer: \(error)")
            }
        }
    }
}
