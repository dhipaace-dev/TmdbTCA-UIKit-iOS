//
//  DiscoverMovieByGenreModel.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 02/08/26.
//

import Foundation

public struct DiscoverMovieByGenreModel: Equatable, Sendable {
    public let page: Int
    public let results: [Movie]
    public let totalPages: Int
    public let totalResults: Int

    public init(page: Int = 1, results: [Movie] = [], totalPages: Int = -1, totalResults: Int = -1) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}
