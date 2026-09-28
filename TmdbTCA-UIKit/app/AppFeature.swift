//
//  AppFeature.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 08/08/26.
//

import ComposableArchitecture
import Foundation
import feature_genre

@Reducer
struct AppFeature {
    
    @Reducer(state: .equatable)
    enum Path {
        case moviesByGenre(MoviesByGenreFeature)
        case movieDetails(MovieDetailsFeature)
        case movieReviews(MovieReviewsFeature)
        case movieTrailer(MovieTrailerFeature)
    }
    
    @ObservableState
    struct State: Equatable {
        var showSplash = true
        var splash = SplashFeature.State()
        var genre = GenreFeature.State()
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case splash(SplashFeature.Action)
        case genre(GenreFeature.Action)
        case path(StackActionOf<Path>)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.splash, action: \.splash) {
            SplashFeature()
        }
        
        Scope(state: \.genre, action: \.genre) {
            GenreFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .splash(.delegate(.didFinish)):
                state.showSplash = false
                return .none
            case .splash:
                return .none
            case let .genre(.delegate(.genreSelected(genre))):
                state.path.append(.moviesByGenre(MoviesByGenreFeature.State(genreId: genre.id)))
                return .none
            case .genre:
                return .none
            case let .path(.element(id: _, action: .moviesByGenre(.delegate(.movieSelected(movie))))):
                state.path.append(.movieDetails(MovieDetailsFeature.State(movieId: movie.id)))
                return .none
            case let .path(.element(id: _, action: .movieDetails(.delegate(.showReviews(movieId))))):
                state.path.append(.movieReviews(MovieReviewsFeature.State(movieId: movieId)))
                return .none
            case let .path(.element(id: _, action: .movieDetails(.delegate(.showTrailer(movieId))))):
                state.path.append(.movieTrailer(MovieTrailerFeature.State(movieId: movieId)))
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
