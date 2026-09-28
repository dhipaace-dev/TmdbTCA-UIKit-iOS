//
//  AuthorDetails.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 02/08/26.
//

import Foundation

public struct AuthorDetails: Equatable, Sendable {
    public let avatarPath: String

    public init(avatarPath: String = "") {
        self.avatarPath = avatarPath
    }
}
