//
//  MoviesByGenreViewController.swift
//  TmdbTCA-UIKit
//
//  Created by JAVARENT on 09/08/26.
//

import ComposableArchitecture
import UIKit
import app_framework

final class MoviesByGenreViewController: UITableViewController {
    private let store: StoreOf<MoviesByGenreFeature>
    private var observationToken: ObservationToken?
    private let overlay = LoadingOverlayView()
    
    private var renderedCount = 0
    
    init(store: StoreOf<MoviesByGenreFeature>) {
        self.store = store
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 170
        tableView.separatorStyle = .none
        
        overlay.frame = view.bounds
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(overlay)
        
        observationToken = observe { [weak self] in
            guard let self else { return }
            self.applyMovieChanges()
            self.overlay.update(isLoading: self.store.isLoading, errorMessage: self.store.errorMessage)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.send(.onAppear)
    }
    
    private func applyMovieChanges() {
        let newCount = store.movies.count
        
        if newCount < renderedCount {
            renderedCount = newCount
            tableView.reloadData()
            return
        }
        
        guard newCount > renderedCount else { return }
        let indexPaths = (renderedCount..<newCount).map { IndexPath(row: $0, section: 0)}
        renderedCount = newCount
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .none)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        store.movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
        cell.configure(with: store.movies[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        store.send(.loadMoreIfNeeded(currentMovie: store.movies[indexPath.row]))
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        store.send(.movieTapped(store.movies[indexPath.row]))
    }
}
