//
//  AppRepositoryImpl.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 03/08/26.
//

import Foundation
//import domain

public class AppRepositoryImpl: AppRepository {

    let appDataSource: AppDataSource

    init(appDataSource: AppDataSource) {
        self.appDataSource = appDataSource
    }

    public func fetchMovieGenre() async throws -> GenreModel {
        try await appDataSource.fetchMovieGenre().toDomain()
    }

    public func fetchMovieByGenre(genreId: String, page: Int) async throws -> DiscoverMovieByGenreModel {
        try await appDataSource.fetchMovieByGenre(genreId: genreId, page: page).toDomain()
    }

    public func fetchMovieDetail(movieId: Int) async throws -> MovieDetailsModel {
        try await appDataSource.fetchMovieDetail(movieId: movieId).toDomain()
    }

    public func fetchMovieReviews(movieId: Int, page: Int) async throws -> ReviewModel {
        try await appDataSource.fetchMovieReviews(movieId: movieId, page: page).toDomain()
    }

    public func fetchMovieTrailer(movieId: Int) async throws -> TrailerModel {
        try await appDataSource.fetchMovieTrailer(movieId: movieId).toDomain()
    }
}
