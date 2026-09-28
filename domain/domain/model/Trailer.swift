//
//  Trailer.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 02/08/26.
//

import Foundation

public struct Trailer: Identifiable, Equatable, Sendable {
    public let id: String
    public let key: String
    public let name: String
    public let site: String

    public init(id: String = "", key: String = "", name: String = "", site: String = "") {
        self.id = id
        self.key = key
        self.name = name
        self.site = site
    }
}
