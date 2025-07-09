//
//  FavoritesView.swift
//  MovieExplorer
//
//  Created by Mujtaba Khan on 08/07/25.
//

import SwiftUI
import RealmSwift

struct FavoritesView: View {
    @State private var allFavorites: [Movie] = []
    @State private var searchText: String = ""
    @State private var selectedSortOption: SortOption = .name
    @State private var selectedGenre: Int? = nil

    enum SortOption: String, CaseIterable, Identifiable {
        case name = "Title (A-Z)"
        case rating = "Rating (High → Low)"
        var id: String { self.rawValue }
    }

    let genreMap: [Int: String] = [
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

    var filteredAndSortedFavorites: [Movie] {
        var result = allFavorites

        // 🔍 Filter by search text
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }

        // 🎯 Filter by genre
        if let genre = selectedGenre {
            result = result.filter {
                $0.genreIDs.contains(genre)
            }
        }

        // ⬆️ Sort
        switch selectedSortOption {
        case .name:
            result.sort { $0.title < $1.title }
        case .rating:
            result.sort { $0.voteAverage > $1.voteAverage }
        }

        return result
    }

    var body: some View {
        NavigationView {
            VStack {
                // 🔍 Search Bar
                TextField("Search by title...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // 🎯 Genre Picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button("All") {
                            selectedGenre = nil
                        }
                        .padding(6)
                        .background(selectedGenre == nil ? Color.blue.opacity(0.2) : Color.clear)
                        .cornerRadius(6)

                        ForEach(genreMap.sorted(by: { $0.value < $1.value }), id: \.key) { genreID, name in
                            Button(name) {
                                selectedGenre = genreID
                            }
                            .padding(6)
                            .background(selectedGenre == genreID ? Color.blue.opacity(0.2) : Color.clear)
                            .cornerRadius(6)
                        }
                    }
                    .padding(.horizontal)
                }

                // 🔽 Sort Picker
                Picker("Sort By", selection: $selectedSortOption) {
                    ForEach(SortOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // 📃 Favorites List
                List(filteredAndSortedFavorites, id: \.id) { movie in
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
            }
            .navigationTitle("❤️ Favorites")
            .onAppear {
                let realmFavorites = FavoriteManager.shared.getAllFavorites()
                self.allFavorites = realmFavorites.map { $0.asMovie() }
            }
        }
    }
}
