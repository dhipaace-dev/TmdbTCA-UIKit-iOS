//
//  GetMovieTrailerUseCaseImpl.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 03/08/26.
//

import Foundation

public struct GetMovieTrailerUseCaseImpl: GetMovieTrailerUseCase {

    let appRepository: AppRepository

    public init(appRepository: AppRepository) {
        self.appRepository = appRepository
    }

    public func call(movieId: Int) async throws -> TrailerModel {
        try await appRepository.fetchMovieTrailer(movieId: movieId)
    }
}
