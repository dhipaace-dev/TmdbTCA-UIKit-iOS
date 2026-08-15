//
//  GetMovieByGenreUseCase.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 03/08/26.
//

import Foundation

public protocol GetMovieByGenreUseCase: Sendable {
    func call(genreId: String, page: Int) async throws -> DiscoverMovieByGenreModel
}
