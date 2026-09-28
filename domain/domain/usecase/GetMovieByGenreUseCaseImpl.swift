//
//  GetMovieByGenreUseCaseImpl.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 03/08/26.
//

import Foundation

public struct GetMovieByGenreUseCaseImpl: GetMovieByGenreUseCase {

    let appRepository: AppRepository

    public init(appRepository: AppRepository) {
        self.appRepository = appRepository
    }

    public func call(genreId: String, page: Int) async throws -> DiscoverMovieByGenreModel {
        try await appRepository.fetchMovieByGenre(genreId: genreId, page: page)
    }
}
