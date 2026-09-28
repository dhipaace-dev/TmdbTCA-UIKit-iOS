//
//  SplashViewController.swift
//  TmdbTCA-UIKit
//
//  Created by JAVARENT on 09/08/26.
//

import ComposableArchitecture
import UIKit

public final class SplashViewController: UIViewController {
    private var store: StoreOf<SplashFeature>
    
    public init(store: StoreOf<SplashFeature>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "TMDB App"
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store.send(.onAppeer)
    }
}
