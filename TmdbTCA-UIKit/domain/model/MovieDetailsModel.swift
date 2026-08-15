//
//  MovieDetailsModel.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 02/08/26.
//

import Foundation

public struct MovieDetailsModel: Equatable, Sendable {
    public let id: Int
    public let overview: String
    public let title: String
    public let imageUrl: String

    public init(id: Int = -1, overview: String = "", title: String = "", imageUrl: String = "") {
        self.id = id
        self.overview = overview
        self.title = title
        self.imageUrl = imageUrl
    }
}
