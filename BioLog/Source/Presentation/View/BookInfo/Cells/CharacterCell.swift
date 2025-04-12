//
//  CharacterCell.swift
//  BioLog
//
//  Created on 7/9/25.
//

import UIKit

final class CharacterCell: UICollectionViewCell {
    static let identifier = "CharacterCell"
    
    private let avatarButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        return button
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "person.fill")
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .systemGray6.withAlphaComponent(0.3)
        contentView.layer.cornerRadius = 12
        
        contentView.addSubview(avatarButton)
        avatarButton.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        
        avatarButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(60)
        }
        
        avatarImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(avatarButton.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
    }
    
    func configure(with character: CharacterDTO) {
        if let imageData = character.image, !imageData.isEmpty {
            avatarButton.setImage(UIImage(data: imageData), for: .normal)
            avatarImageView.isHidden = true
        }
        nameLabel.text = character.name
        descriptionLabel.text = character.sex
    }
}

