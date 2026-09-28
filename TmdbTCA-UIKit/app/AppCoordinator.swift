//
//  AppCoordinator.swift
//  TmdbTCA-UIKit
//
//  Created by JAVARENT on 09/08/26.
//

import ComposableArchitecture
import UIKit
import feature_genre
import feature_movie_by_genre

final class AppCoordinator: UINavigationController, UINavigationControllerDelegate {
    private let store: StoreOf<AppFeature>
    private lazy var pathStore = store.scope(state: \.path, action: \.path)
    
    private var observationToken: ObservationToken?
    private var pushedIDs: [StackElementID] = []
    
    init(store: StoreOf<AppFeature>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        setNavigationBarHidden(true, animated: false)
        setViewControllers([SplashViewController(store: store.scope(state: \.splash, action: \.splash))], animated: false)
        
        observationToken = observe { [weak self] in
            self?.render()
        }
    }
    
    private func render() {
        guard !store.showSplash else { return }
        
        if viewControllers.first is SplashViewController {
            let genreViewController = GenreViewController(store: store.scope(state: \.genre, action: \.genre))
            setViewControllers([genreViewController], animated: false)
            setNavigationBarHidden(false, animated: false)
        }
        
        syncStack()
    }
    
    private func syncStack() {
        let ids = Array(store.path.ids)
        
        if ids.count < pushedIDs.count {
            pushedIDs = ids
            guard let root = viewControllers.first else { return }
            let kept = Array(viewControllers.dropFirst().prefix(ids.count))
            setViewControllers([root] + kept, animated: true)
            return
        }
        
        guard ids.count > pushedIDs.count else { return }
        for id in ids[pushedIDs.count...] {
            guard let destination = destinationViewController(for: id) else { continue }
            pushedIDs.append(id)
            pushViewController(destination, animated: true)
        }
    }
    
    
    private func destinationViewController(for id: StackElementID) -> UIViewController? {
        guard var elementState = store.path[id: id] else { return nil }
        let elementStore = pathStore.scope(state: { stackState in
            elementState = stackState[id: id] ?? elementState
            return elementState
        }, action: {
            .element(id: id, action: $0)
        })
        //guard let elementStore = pathStore[id: id] else { return nil }
        
        switch elementStore.case {
        case let .moviesByGenre(store):
            return MoviesByGenreViewController(store: store)
        case let .movieDetails(store):
            return MovieDetailsViewController(store: store)
        case let .movieReviews(store):
            return MovieReviewsViewController(store: store)
        case let .movieTrailer(store: store):
            return MovieTrailerViewController(store: store)
        }
    }
    
    func navigationConnstroller(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        let visibleCount = viewControllers.count - 1
        guard visibleCount >= 0, visibleCount < pushedIDs.count else { return }
        
        let poppedIDs = pushedIDs.suffix(pushedIDs.count - visibleCount)
        pushedIDs.removeLast(pushedIDs.count - visibleCount)
        
        for id in poppedIDs.reversed() {
            store.send(.path(.popFrom(id: id)))
        }
    }
}
