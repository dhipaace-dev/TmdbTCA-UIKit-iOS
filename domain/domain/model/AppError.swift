//
//  AppError.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 02/08/26.
//

import Foundation

public enum AppError: Error, Equatable, Sendable {
    case networkError(message: String)
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .networkError(message):
            return message
        }
    }
}
