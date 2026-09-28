//
//  GetMovieReviewUseCase.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 03/08/26.
//

import Foundation

public protocol GetMovieReviewUseCase: Sendable {
    func call(movieId: Int, page: Int) async throws -> ReviewModel
}
