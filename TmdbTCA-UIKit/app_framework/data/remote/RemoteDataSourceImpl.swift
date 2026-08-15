//
//  RemoteDataSourceImpl.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 03/08/26.
//

import Foundation
//import domain
//import data

public final class RemoteDataSourceImpl: AppDataSource, Sendable {

    let apiClient: ApiClient

    public init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }

    public func fetchMovieGenre() async throws -> GenreResponse {
        do {
            return try await apiClient.fetchMovieGenre()
        } catch {
            throw AppError.networkError(message: error.localizedDescription)
        }
    }

    public func fetchMovieByGenre(genreId: String, page: Int) async throws -> DiscoverMovieByGenreResponse {
        do {
            return try await apiClient.fetchMovieByGenre(genreId: genreId, page: page)
        } catch {
            throw AppError.networkError(message: error.localizedDescription)
        }
    }

    public func fetchMovieDetail(movieId: Int) async throws -> MovieDetailsResponse {
        do {
            return try await apiClient.fetchMovieDetail(movieId: movieId)
        } catch {
            throw AppError.networkError(message: error.localizedDescription)
        }
    }

    public func fetchMovieReviews(movieId: Int, page: Int) async throws -> ReviewResponse {
        do {
            return try await apiClient.fetchMovieReviews(movieId: movieId, page: page)
        } catch {
            throw AppError.networkError(message: error.localizedDescription)
        }
    }

    public func fetchMovieTrailer(movieId: Int) async throws -> TrailerResponse {
        do {
            return try await apiClient.fetchMovieTrailer(movieId: movieId)
        } catch {
            throw AppError.networkError(message: error.localizedDescription)
        }
    }
}
