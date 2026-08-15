//
//  ApiClient.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 04/08/26.
//

import Alamofire
import Foundation
//import data
//import domain

public final class ApiClient: Sendable {

    public init() {}

    func fetchMovieGenre() async throws -> GenreResponse {
        try await request(APIRouter.fetchMovieGenre, type: GenreResponse.self)
    }

    func fetchMovieByGenre(genreId: String, page: Int) async throws -> DiscoverMovieByGenreResponse {
        try await request(APIRouter.fetchMovieByGenre(genreId: genreId, page: page), type: DiscoverMovieByGenreResponse.self)
    }

    func fetchMovieDetail(movieId: Int) async throws -> MovieDetailsResponse {
        try await request(APIRouter.fetchMovieDetail(movieId: movieId), type: MovieDetailsResponse.self)
    }

    func fetchMovieReviews(movieId: Int, page: Int) async throws -> ReviewResponse {
        try await request(APIRouter.fetchMovieReviews(movieId: movieId, page: page), type: ReviewResponse.self)
    }

    func fetchMovieTrailer(movieId: Int) async throws -> TrailerResponse {
        try await request(APIRouter.fetchMovieTrailer(movieId: movieId), type: TrailerResponse.self)
    }

    func request<T: Decodable>(_ router: APIRouter, type: T.Type) async throws -> T {
        let dataTask = AF.request(router).serializingDecodable(T.self)
        let response = await dataTask.response
        
        guard let statusCode = response.response?.statusCode else {
            throw NetworkError.unknown(statusCode: -1)
        }
        
        switch statusCode {
        case 200..<300:
            switch response.result {
            case .success(let value):
                return value
            case .failure(let afError):
                throw NetworkError.afError(afError)
            }
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 500..<600:
            throw NetworkError.serverError
        default:
            throw NetworkError.unknown(statusCode: statusCode)
        }
    }
}
