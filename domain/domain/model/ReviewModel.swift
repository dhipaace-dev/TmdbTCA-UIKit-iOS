//
//  ReviewModel.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 02/08/26.
//

import Foundation

public struct ReviewModel: Equatable, Sendable {
    public let results: [Review]

    public init(results: [Review] = []) {
        self.results = results
    }
}
