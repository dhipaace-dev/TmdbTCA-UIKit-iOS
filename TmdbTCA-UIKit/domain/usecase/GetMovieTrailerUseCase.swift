//
//  GetMovieTrailerUseCase.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 03/08/26.
//

import Foundation

public protocol GetMovieTrailerUseCase: Sendable {
    func call(movieId: Int) async throws -> TrailerModel
}
