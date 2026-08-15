//
//  Dependencies.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 08/08/26.
//

import ComposableArchitecture
import Foundation

enum AppEnvironment {
    static let apiClient = ApiClient()
    static let dataSource: AppDataSource = RemoteDataSourceImpl(apiClient: apiClient)
    static let repository: AppRepository = AppRepositoryImpl(appDataSource: dataSource)
}

private enum GetMovieGenreUseCaseKey: DependencyKey {
    static let liveValue: GetMovieGenreUseCase = GetMovieGenreUseCaseImpl(appRepository: AppEnvironment.repository)
}

private enum GetMovieByGenreUseCaseKey: DependencyKey {
    static let liveValue: GetMovieByGenreUseCase = GetMovieByGenreUseCaseImpl(appRepository: AppEnvironment.repository)
}

private enum GetMovieDetailsUseCaseKey: DependencyKey {
    static let liveValue: GetMovieDetailsUseCase = GetMovieDetailsUseCaseImpl(appRepository: AppEnvironment.repository)
}

private enum GetMovieReviewUseCaseKey: DependencyKey {
    static let liveValue: GetMovieReviewUseCase = GetMovieReviewUseCaseImpl(appRepository: AppEnvironment.repository)
}

private enum GetMovieTrailerUseCaseKey: DependencyKey {
    static let liveValue: GetMovieTrailerUseCase = GetMovieTrailerUseCaseImpl(appRepository: AppEnvironment.repository)
}

extension DependencyValues {
    var getMovieGenreUseCase: GetMovieGenreUseCase {
        get { self[GetMovieGenreUseCaseKey.self] }
        set { self[GetMovieGenreUseCaseKey.self] = newValue }
    }
    
    var getMovieByGenreUseCase: GetMovieByGenreUseCase {
        get { self[GetMovieByGenreUseCaseKey.self] }
        set { self[GetMovieByGenreUseCaseKey.self] = newValue }
    }
    
    var getMovieDetailsUseCase: GetMovieDetailsUseCase {
        get { self[GetMovieDetailsUseCaseKey.self] }
        set { self[GetMovieDetailsUseCaseKey.self] = newValue }
    }
    
    var getMovieReviewUseCase: GetMovieReviewUseCase {
        get { self[GetMovieReviewUseCaseKey.self] }
        set { self[GetMovieReviewUseCaseKey.self] = newValue }
    }
    
    var getMovieTrailerUseCase: GetMovieTrailerUseCase {
        get { self[GetMovieTrailerUseCaseKey.self] }
        set { self[GetMovieTrailerUseCaseKey.self] = newValue }
    }
}
