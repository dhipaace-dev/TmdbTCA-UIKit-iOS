//
//  GenreModel.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 02/08/26.
//

import Foundation

public struct GenreModel: Equatable, Sendable {
    public let genres: [Genre]

    public init(genres: [Genre] = []) {
        self.genres = genres
    }
}
