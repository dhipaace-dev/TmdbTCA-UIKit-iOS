//
//  GetMovieReviewUseCaseImpl.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 03/08/26.
//

import Foundation

public struct GetMovieReviewUseCaseImpl: GetMovieReviewUseCase {

    let appRepository: AppRepository

    public init(appRepository: AppRepository) {
        self.appRepository = appRepository
    }

    public func call(movieId: Int, page: Int) async throws -> ReviewModel {
        try await appRepository.fetchMovieReviews(movieId: movieId, page: page)
    }
}
