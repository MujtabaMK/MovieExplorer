//
//  MovieListViewModel.swift
//  MovieExplorer
//
//  Created by Mujtaba Khan on 08/07/25.
//

import Foundation
import Combine

class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var query: String = ""
    
    private var currentPage = 1
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $query
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] keyword in
                self?.searchMovies(keyword)
            }
            .store(in: &cancellables)
    }

    func loadMovies() {
        NetworkService.shared.fetchMovies(endpoint: "popular", page: currentPage) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newMovies):
                    self?.movies.append(contentsOf: newMovies)
                    self?.currentPage += 1
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    func searchMovies(_ keyword: String) {
        guard !keyword.isEmpty else {
            self.movies = []
            loadMovies()
            return
        }

        NetworkService.shared.searchMovies(query: keyword) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self?.movies = results
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

