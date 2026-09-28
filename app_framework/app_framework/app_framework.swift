//
//  app_framework.swift
//  app_framework
//
//  Created by JAVARENT on 28/09/26.
//

import Foundation
import domain

public func toAppError(_ error: any Error) -> AppError {
    (error as? AppError) ?? .networkError(message: error.localizedDescription)
}
