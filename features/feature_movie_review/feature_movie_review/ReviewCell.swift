//
//  ReviewCell.swift
//  TmdbTCA-UIKit
//
//  Created by JAVARENT on 09/08/26.
//

import UIKit
import domain

final class ReviewCell: UITableViewCell {
    static let reuseIdentifier = "ReviewCell"
    
    private let contentLabel = UILabel()
    private let authorLabel = UILabel()
    private let avatarImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        selectionStyle = .none
        
        contentLabel.numberOfLines = 0
        contentLabel.font = .systemFont(ofSize: 14)
        
        authorLabel.font = .boldSystemFont(ofSize: 14)
        authorLabel.textAlignment = .right
        
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.backgroundColor = .systemGray5
        
        let footerStack = UIStackView(arrangedSubviews: [authorLabel, avatarImageView])
        footerStack.axis = .horizontal
        footerStack.spacing = 12
        footerStack.alignment = .center
        
        let mainStack = UIStackView(arrangedSubviews: [contentLabel, footerStack])
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with review: Review) {
        contentLabel.text = review.content
        authorLabel.text = review.author
        avatarImageView.setRemoteImage(review.authorDetails?.avatarPath ?? "")
    }
}
