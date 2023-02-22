//
//  EmojiTableViewCell.swift
//  Emoji Dictionary
//
//  Created by Lore P on 14/02/2023.
//

import UIKit

class EmojiTableViewCell: UITableViewCell {
    static let identifier = "EmojiTableViewCell"
    
    
    // MARK: UI Elements
    public var emojiLabel: UILabel = {
        
        let label                                       = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font                                      = .systemFont(ofSize: 30, weight: .regular)
        label.textAlignment                             = .center
        label.setContentHuggingPriority(.init(252), for: .horizontal)
        
        return label
    }()
    
    public var nameLabel: UILabel = {
        
        let label                                       = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font                                      = .preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    public var descriptionLabel: UILabel = {
        
        let label                                       = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines                             = 0
        label.font                                      = .preferredFont(forTextStyle: .subheadline)
        
        return label
    }()

    public let verticalStackView   = UIStackView()

    public let horizontalStackView = UIStackView()

    
    
    // MARK: Initialiser
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureStackViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: Layout configuration
    // Configure StackViews
    func configureStackViews() {
        
        verticalStackView.axis         = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(descriptionLabel)
        
        contentView.addSubview(horizontalStackView)
        horizontalStackView.axis         = .horizontal
        horizontalStackView.distribution = .fill
        horizontalStackView.spacing      = 15
        horizontalStackView.addArrangedSubview(emojiLabel)
        horizontalStackView.addArrangedSubview(verticalStackView)
        
        constraintHorizontalStackViews()
    }
    
    
    // Contraints only for the horizontal stack
    func constraintHorizontalStackViews() {
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
   
        let horizontalStackViewContraints = [
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ]
        
        NSLayoutConstraint.activate(horizontalStackViewContraints)
    }
}
