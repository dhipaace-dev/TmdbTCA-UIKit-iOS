//
//  MovieDetailsFeature.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 04/08/26.
//

import ComposableArchitecture
import Foundation
import domain
import app_framework

@Reducer
struct MovieDetailsFeature {
    
    @ObservableState
    struct State: Equatable {
        var movieId: Int
        var movie: MovieDetailsModel?
        var isLoading = false
        var errorMessage: String?
        
        init(movieId: Int) {
            self.movieId = movieId
        }
    }
    
    enum Action {
        case onAppear
        case detailsResponse(Result<MovieDetailsModel, AppError>)
        case showReviewsTapped
        case showTrailerTapped
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case showReviews(movieId: Int)
            case showTrailer(movieId: Int)
        }
    }
    
    @Dependency(\.getMovieDetailsUseCase) var getMovieDetailsUseCase
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.movie == nil else { return .none }
                state.isLoading = true
                state.errorMessage = nil
                
                let movieId = state.movieId
                return .run { send in
                    await send(.detailsResponse(Result { try await getMovieDetailsUseCase.call(movieId: movieId)}.mapError(toAppError)))
                }
            case let .detailsResponse(.success(movie)):
                state.isLoading = false
                state.movie = movie
                return .none
            case let .detailsResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
            case .showReviewsTapped:
                return .send(.delegate(.showReviews(movieId: state.movieId)))
            case .showTrailerTapped:
                return .send(.delegate(.showTrailer(movieId: state.movieId)))
            case .delegate:
                return .none
            }
        }
    }
}
