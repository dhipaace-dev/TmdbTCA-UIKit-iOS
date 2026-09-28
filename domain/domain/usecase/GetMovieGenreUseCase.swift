//
//  GetMovieGenreUseCase.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 03/08/26.
//

import Foundation

public protocol GetMovieGenreUseCase: Sendable {
    func call() async throws -> GenreModel
}
