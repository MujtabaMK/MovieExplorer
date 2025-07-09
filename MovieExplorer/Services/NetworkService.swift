//
//  NetworkService.swift
//  MovieExplorer
//
//  Created by Mujtaba Khan on 08/07/25.
//

import Foundation
import Alamofire

struct TrailerResponse: Codable {
    let results: [Trailer]
}

struct Trailer: Codable {
    let key: String
    let name: String
    let site: String
    let type: String
}

class NetworkService {
    static let shared = NetworkService()

    func fetchMovies(endpoint: String, page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let url = "\(API.baseURL)/movie/\(endpoint)?api_key=\(API.key)&page=\(page)"
        
        AF.request(url).responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let movieResponse):
                completion(.success(movieResponse.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let url = "\(API.baseURL)/search/movie?api_key=\(API.key)&query=\(query)"
        
        AF.request(url).responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let movieResponse):
                completion(.success(movieResponse.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension NetworkService {
    func fetchTrailer(for movieID: Int, completion: @escaping (Result<Trailer?, Error>) -> Void) {
        let url = "\(API.baseURL)/movie/\(movieID)/videos?api_key=\(API.key)"
        
        AF.request(url).responseDecodable(of: TrailerResponse.self) { response in
            switch response.result {
            case .success(let data):
                let trailer = data.results.first(where: { $0.site == "YouTube" && $0.type == "Trailer" })
                completion(.success(trailer))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

