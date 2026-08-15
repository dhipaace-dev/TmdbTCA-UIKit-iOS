//
//  MovieTrailerViewController.swift
//  TmdbTCA-UIKit
//
//  Created by JAVARENT on 09/08/26.
//

import ComposableArchitecture
import UIKit
import WebKit

final class MovieTrailerViewController: UIViewController {
    private let store: StoreOf<MovieTrailerFeature>
    private var observationToken: ObservationToken?
    
    private let webView = WKWebView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var loadedKey: String?
    
    init(store: StoreOf<MovieTrailerFeature>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Trailer"
        
        view.backgroundColor = .systemBackground
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 250),
            
            activityIndicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor)
        ])
        
        observationToken = observe { [weak self] in
            self?.render()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.send(.onAppear)
    }
    
    private func render() {
        guard let key = store.movieKey, !key.isEmpty else {
            activityIndicator.startAnimating()
            return
        }
        
        guard key != loadedKey, let url = URL(string: "https://www.youtube.com/embed/\(key)") else {
            return
        }
        
        loadedKey = key
        activityIndicator.stopAnimating()
        webView.load(URLRequest(url: url))
    }
}
