//
//  GetMovieDetailsUseCaseImpl.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 03/08/26.
//

import Foundation

public struct GetMovieDetailsUseCaseImpl: GetMovieDetailsUseCase {

    let appRepository: AppRepository

    public init(appRepository: AppRepository) {
        self.appRepository = appRepository
    }

    public func call(movieId: Int) async throws -> MovieDetailsModel {
        try await appRepository.fetchMovieDetail(movieId: movieId)
    }
}
