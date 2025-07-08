//
//  MovieDetailView.swift
//  MovieExplorer
//
//  Created by Mujtaba Khan on 08/07/25.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Poster Image
                AsyncImage(url: URL(string: movie.posterURL)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 300)
                            .overlay(Text("No Image"))
                    }
                }

                // Title
                Text(movie.title)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)

                // Release Date
                Text("🗓 Release Date: \(movie.releaseDate)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // ⭐️ Rating
                Text("⭐️ Rating: \(String(format: "%.1f", movie.voteAverage))/10")
                    .font(.subheadline)
                    .foregroundColor(.yellow)

                // Overview
                Text("📝 Overview")
                    .font(.headline)
                    .padding(.top, 8)

                Text(movie.overview)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

