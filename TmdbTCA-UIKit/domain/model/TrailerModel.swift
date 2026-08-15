//
//  TrailerModel.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 02/08/26.
//

import Foundation

public struct TrailerModel: Equatable, Sendable {
    public let id: Int
    public let results: [Trailer]

    public init(id: Int = -1, results: [Trailer] = []) {
        self.id = id
        self.results = results
    }
}
