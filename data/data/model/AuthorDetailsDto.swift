//
//  AuthorDetailsDto.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 03/08/26.
//

import Foundation

struct AuthorDetailsDto: Decodable {
    let name: String?
    let username: String?
    let avatarPath: String?
    let rating: Float?

    init(
        name: String?,
        username: String?,
        avatarPath: String?,
        rating: Float?
    ) {
        self.name = name
        self.username = username
        self.avatarPath = avatarPath
        self.rating = rating
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case username
        case avatarPath = "avatar_path"
        case rating
    }
}
