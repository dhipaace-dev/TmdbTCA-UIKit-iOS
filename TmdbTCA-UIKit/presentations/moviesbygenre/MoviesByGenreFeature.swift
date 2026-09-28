//
//  MoviesByGenreFeature.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 04/08/26.
//

import ComposableArchitecture
import Foundation
import domain

@Reducer
struct MoviesByGenreFeature {
    
    @ObservableState
    struct State: Equatable {
        var genreId: Int
        var movies: [Movie] = []
        var page = 0
        var isLoading = false
        var errorMessage: String?
        
        init(genreId: Int) {
            self.genreId = genreId
        }
    }
    
    enum Action {
        case onAppear
        case movieTapped(Movie)
        case loadMoreIfNeeded(currentMovie: Movie)
        case moviesResponse(nextPage: Int, Result<DiscoverMovieByGenreModel, AppError>)
        case delegate(Delegate)
        
        enum Delegate {
            case movieSelected(Movie)
        }
    }
    
    @Dependency(\.getMovieByGenreUseCase) var getMovieByGenreUseCase
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.movies.isEmpty else { return .none }
                return fetchNextPage(&state)
            case let .movieTapped(movie):
                return .send(.delegate(.movieSelected(movie)))
            case let .loadMoreIfNeeded(currentMovie):
                guard state.movies.last?.id == currentMovie.id else { return .none }
                return fetchNextPage(&state)
            case let .moviesResponse(nextPage, .success(model)):
                state.isLoading = false
                if !model.results.isEmpty {
                    state.movies.append(contentsOf: model.results)
                    state.page = nextPage
                }
                return .none
            case let .moviesResponse(_, .failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
            case .delegate:
                return .none
            }
        }
    }
    
    private func fetchNextPage(_ state: inout State) -> Effect<Action> {
        state.isLoading = true
        state.errorMessage = nil
        let nextPage = state.page + 1
        let genreId = state.genreId
        
        return .run { send in
            await send(.moviesResponse(nextPage: nextPage, Result { try await getMovieByGenreUseCase.call(genreId: "\(genreId)", page: nextPage)}.mapError(toAppError)))
        }
    }
}
