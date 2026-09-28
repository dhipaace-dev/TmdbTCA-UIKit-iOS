//
//  MovieReviewsViewController.swift
//  TmdbTCA-UIKit
//
//  Created by JAVARENT on 09/08/26.
//

import ComposableArchitecture
import UIKit
import app_framework

public final class MovieReviewsViewController: UITableViewController {
    private let store: StoreOf<MovieReviewsFeature>
    private var observationToken: ObservationToken?
    private let overlay = LoadingOverlayView()
    
    private var renderedCount = 0
    
    public init(store: StoreOf<MovieReviewsFeature>) {
        self.store = store
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reviews"
        
        tableView.register(ReviewCell.self, forCellReuseIdentifier: ReviewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        tableView.separatorStyle = .none
        
        overlay.frame = view.bounds
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(overlay)
        
        observationToken = observe { [weak self] in
            guard let self else { return }
            self.applyReviewChanges()
            self.overlay.update(isLoading: self.store.isLoading, errorMessage: self.store.errorMessage)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.send(.onAppear)
    }
    
    private func applyReviewChanges() {
        let newCount = store.reviews.count
        
        if newCount < renderedCount {
            renderedCount = newCount
            tableView.reloadData()
            return
        }
        
        guard newCount > renderedCount else { return }
        let indexPaths = (renderedCount..<newCount).map { IndexPath(row: $0, section: 0) }
        renderedCount = newCount
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .none)
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        store.reviews.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.reuseIdentifier, for: indexPath) as! ReviewCell
        
        cell.configure(with: store.reviews[indexPath.row])
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        store.send(.loadMoreIfNeeded(currentReview: store.reviews[indexPath.row]))
    }
}
