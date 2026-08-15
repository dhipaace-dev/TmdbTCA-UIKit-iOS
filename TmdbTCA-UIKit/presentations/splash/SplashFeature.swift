//
//  SplashFeature.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 04/08/26.
//

import ComposableArchitecture
import Foundation

@Reducer
struct SplashFeature {
    @ObservableState
    struct State: Equatable {}
    
    enum Action {
        case onAppeer
        case finished
        case delegate(Delegate)
        
        enum Delegate {
            case didFinish
        }
    }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppeer:
                return .run { send in
                    try await clock.sleep(for: .seconds(3))
                    await send(.finished)
                }
            case .finished:
                return .send(.delegate(.didFinish))
            case .delegate:
                return .none
            }
        }
    }
}
