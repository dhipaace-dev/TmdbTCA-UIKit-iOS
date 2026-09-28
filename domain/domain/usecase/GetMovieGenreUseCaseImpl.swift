//
//  GetMovieGenreUseCaseImpl.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 03/08/26.
//

import Foundation

public struct GetMovieGenreUseCaseImpl: GetMovieGenreUseCase {

    let appRepository: AppRepository

    public init(appRepository: AppRepository) {
        self.appRepository = appRepository
    }

    public func call() async throws -> GenreModel {
        try await appRepository.fetchMovieGenre()
    }
}
