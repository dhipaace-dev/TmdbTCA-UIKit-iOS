//
//  MovieReviewsFeature.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 08/08/26.
//

import ComposableArchitecture
import Foundation

@Reducer
struct MovieReviewsFeature {
    
    @ObservableState
    struct State: Equatable {
        let movieId: Int
        var reviews: [Review] = []
        var page = 0
        var isLoading: Bool = false
        var errorMessage: String?
        
        init(movieId: Int) {
            self.movieId = movieId
        }
    }
    
    enum Action {
        case onAppear
        case loadMoreIfNeeded(currentReview: Review)
        case reviewsResponse(nextPage: Int, Result<ReviewModel, AppError>)
    }
    
    @Dependency(\.getMovieReviewUseCase) var getMovieReviewUseCase
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.reviews.isEmpty else { return .none }
                return fetchNextPage(&state)
            case let .loadMoreIfNeeded(currentReview):
                guard state.reviews.last?.id == currentReview.id else { return .none }
                return fetchNextPage(&state)
            case let .reviewsResponse(nextPage, .success(model)):
                state.isLoading = false
                if !model.results.isEmpty {
                    state.reviews.append(contentsOf: model.results)
                    state.page = nextPage
                }
                return .none
            case let .reviewsResponse(_, .failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
            }
        }
    }
    
    private func fetchNextPage(_ state: inout State) -> Effect<Action> {
        state.isLoading = true
        state.errorMessage = nil
        
        let nextPage = state.page + 1
        let movieId = state.movieId
        
        return .run { send in
            await send(.reviewsResponse(nextPage: nextPage, Result {
                try await getMovieReviewUseCase.call(movieId: movieId, page: nextPage)
            }.mapError(toAppError)))
        }
        
    }
}
