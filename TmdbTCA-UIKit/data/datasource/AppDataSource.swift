//
//  AppDataSource.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 03/08/26.
//

import Foundation

protocol AppDataSource {
    func fetchMovieGenre() async throws -> GenreResponse
    func fetchMovieByGenre(genreId: String, page: Int) async throws -> DiscoverMovieByGenreResponse
    func fetchMovieDetail(movieId: Int) async throws -> MovieDetailsResponse
    func fetchMovieReviews(movieId: Int, page: Int) async throws -> ReviewResponse
    func fetchMovieTrailer(movieId: Int) async throws -> TrailerResponse
}
