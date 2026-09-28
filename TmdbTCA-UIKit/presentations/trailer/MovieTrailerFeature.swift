//
//  MovieTrailerFeature.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 08/08/26.
//

import ComposableArchitecture
import Foundation
import domain

@Reducer
struct MovieTrailerFeature {
    
    @ObservableState
    struct State: Equatable {
        let movieId: Int
        var movieKey: String?
        var isLoading: Bool = false
        var errorMessage: String?
        
        init(movieId: Int) {
            self.movieId = movieId
        }
    }
    
    enum Action {
        case onAppear
        case trailersResponse(Result<TrailerModel, AppError>)
    }
    
    @Dependency(\.getMovieTrailerUseCase) var getMovieTrailerUseCase
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.movieKey == nil else { return .none }
                state.isLoading = true
                state.errorMessage = nil
                let movieId = state.movieId
                return .run { send in
                    await send(.trailersResponse(Result {
                        try await getMovieTrailerUseCase.call(movieId: movieId)
                    }.mapError(toAppError)))
                }
            case let .trailersResponse(.success(model)):
                state.isLoading = false
                state.movieKey = model.results.first {
                    $0.site.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == "youtube"
                }?.key
                return .none
                
            case let .trailersResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
            }
        }
    }
}
