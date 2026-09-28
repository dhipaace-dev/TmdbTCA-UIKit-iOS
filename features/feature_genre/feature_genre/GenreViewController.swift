//
//  GenreViewController.swift
//  TmdbTCA-UIKit
//
//  Created by JAVARENT on 09/08/26.
//

import ComposableArchitecture
import UIKit
import app_framework

public final class GenreViewController: UITableViewController {
    private let store: StoreOf<GenreFeature>
    private var observationToken: ObservationToken?
    private let overlay = LoadingOverlayView()
    
    private static let cellReuseIdentifier = "GenreCell"
    
    public init(store: StoreOf<GenreFeature>) {
        self.store = store
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Genres"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellReuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        overlay.frame = view.bounds
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(overlay)
        
        observationToken = observe { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
            self.overlay.update(isLoading: self.store.isLoading, errorMessage: self.store.errorMessage)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.send(.onAppear)
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        store.genres.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellReuseIdentifier, for: indexPath)
        let genre = store.genres[indexPath.row]
        
        cell.textLabel?.text = genre.name
        cell.textLabel?.font = .boldSystemFont(ofSize: 16)
        cell.layer.borderColor = UIColor.label.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.contentView.frame = cell.contentView.frame.insetBy(dx: 4, dy: 4)
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        store.send(.genreTapped(store.genres[indexPath.row]))
    }
}
