//
//  GetMovieDetailsUseCase.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 03/08/26.
//

import Foundation

public protocol GetMovieDetailsUseCase: Sendable {
    func call(movieId: Int) async throws -> MovieDetailsModel
}
