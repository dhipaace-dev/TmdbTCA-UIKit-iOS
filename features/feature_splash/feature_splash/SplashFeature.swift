//
//  SplashFeature.swift
//  TmdbTCA-SwiftUI
//
//  Created by JAVARENT on 04/08/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct SplashFeature {
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action {
        case onAppeer
        case finished
        case delegate(Delegate)
        
        public enum Delegate {
            case didFinish
        }
    }
    
    @Dependency(\.continuousClock) var clock
    
    public var body: some ReducerOf<Self> {
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
