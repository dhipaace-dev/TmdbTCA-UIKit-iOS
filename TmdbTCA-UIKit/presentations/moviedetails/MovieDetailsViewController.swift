//
//  MovieDetailsViewController.swift
//  TmdbTCA-UIKit
//
//  Created by JAVARENT on 09/08/26.
//

import ComposableArchitecture
import UIKit
import app_framework

final class MovieDetailsViewController: UIViewController {
    private let store: StoreOf<MovieDetailsFeature>
    private var observationToken: ObservationToken?
    private let overlay = LoadingOverlayView()
    
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let posterImageView = UIImageView()
    private let reviewsButton = UIButton(type: .system)
    private let trailerButton = UIButton(type: .system)
    
    init(store: StoreOf<MovieDetailsFeature>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        view.backgroundColor = .systemBackground
        
        setUpLayout()
        reviewsButton.addTarget(self, action: #selector(reviewsTapped), for: .touchUpInside)
        trailerButton.addTarget(self, action: #selector(trailerTapped), for: .touchUpInside)
        
        observationToken = observe { [weak self] in
            self?.render()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.send(.onAppear)
    }
    
    private func setUpLayout() {
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        overviewLabel.font = .systemFont(ofSize: 15)
        overviewLabel.numberOfLines = 0
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.backgroundColor = .systemGray5
        
        reviewsButton.setTitle("Show Reviews", for: .normal)
        trailerButton.setTitle("Show Trailer", for: .normal)
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let stack = UIStackView(arrangedSubviews: [
            titleLabel, overviewLabel, posterImageView, reviewsButton, trailerButton
        ])
        
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(stack)
        
        overlay.frame = view.bounds
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(overlay)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            
            posterImageView.widthAnchor.constraint(equalToConstant: 200),
            posterImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func render() {
        titleLabel.text = store.movie?.title ?? ""
        overviewLabel.text = store.movie?.overview ?? ""
        posterImageView.setRemoteImage(store.movie?.imageUrl ?? "")
        overlay.update(isLoading: store.isLoading, errorMessage: store.errorMessage)
    }
    
    @objc private func reviewsTapped() {
        store.send(.showReviewsTapped)
    }
    
    @objc private func trailerTapped() {
        store.send(.showTrailerTapped)
    }
}
