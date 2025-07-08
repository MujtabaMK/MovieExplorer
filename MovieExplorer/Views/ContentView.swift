//
//  ContentView.swift
//  MovieExplorer
//
//  Created by Mujtaba Khan on 08/07/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MovieListViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.movies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        MovieRow(movie: movie)
                            .onAppear {
                                if movie == viewModel.movies.last {
                                    viewModel.loadMovies()
                                }
                            }
                    }
                }
            }
            .navigationTitle("Movie Explorer")
            .searchable(text: $viewModel.query)
            .onAppear {
                viewModel.loadMovies()
            }
        }
    }
}

#Preview {
    ContentView()
}
