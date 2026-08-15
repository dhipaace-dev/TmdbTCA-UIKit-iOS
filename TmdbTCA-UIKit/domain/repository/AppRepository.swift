//
//  AppRepository.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 02/08/26.
//

import Foundation

public protocol AppRepository {
    func fetchMovieGenre() async throws -> GenreModel
    func fetchMovieByGenre(genreId: String, page: Int) async throws -> DiscoverMovieByGenreModel
    func fetchMovieDetail(movieId: Int) async throws -> MovieDetailsModel
    func fetchMovieReviews(movieId: Int, page: Int) async throws -> ReviewModel
    func fetchMovieTrailer(movieId: Int) async throws -> TrailerModel
}
