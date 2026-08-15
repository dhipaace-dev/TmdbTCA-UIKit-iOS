//
//  GenreFeature.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 04/08/26.
//

import ComposableArchitecture
import Foundation

@Reducer
struct GenreFeature {
    
    @ObservableState
    struct State: Equatable {
        var genres: [Genre] = []
        var isLoading = false
        var errorMessage: String?
    }
    
    enum Action {
        case onAppear
        case genreResponse(Result<GenreModel, AppError>)
        case genreTapped(Genre)
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case genreSelected(Genre)
        }
    }
    
    @Dependency(\.getMovieGenreUseCase) var getMovieGenreUseCase
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.genres.isEmpty else { return .none }
                state.isLoading = true
                state.errorMessage = nil
                return .run { send in
                    await send(.genreResponse(Result { try await getMovieGenreUseCase.call()}.mapError(toAppError)))
                }
            case let .genreResponse(.success(model)):
                state.isLoading = false
                state.genres = model.genres
                return .none
            case let .genreResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
            case let .genreTapped(genre):
                return .send(.delegate(.genreSelected(genre)))
            case .delegate:
                return .none
            }
        }
    }
}

func toAppError(_ error: any Error) -> AppError {
    (error as? AppError) ?? .networkError(message: error.localizedDescription)
}
