//
//  BookInfoCell.swift
//  BioLog
//
//  Created on 7/9/25.
//

import UIKit
//import Kingfisher

final class BookInfoCell: UICollectionViewCell {
    static let identifier = "BookInfoCell"
    
    private let coverImageView: AsyncFetchImageView = {
        let imageView = AsyncFetchImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 3
        return label
    }()
    
    private let ratingView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(coverImageView)
        contentView.addSubview(infoStackView)
        
        infoStackView.addArrangedSubview(authorLabel)
        infoStackView.addArrangedSubview(descriptionLabel)
        infoStackView.addArrangedSubview(ratingView)
        
        let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
        starImageView.tintColor = .systemYellow
        let ratingLabel = UILabel()
        ratingLabel.font = .systemFont(ofSize: 12)
        ratingLabel.textColor = .secondaryLabel
        
        ratingView.addArrangedSubview(starImageView)
        ratingView.addArrangedSubview(ratingLabel)
        
        coverImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(150)
        }
        
        infoStackView.snp.makeConstraints {
            $0.leading.equalTo(coverImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview()
            $0.top.equalTo(coverImageView)
        }
        
        starImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }
    }
    
    func configure(with book: CompleteBook) {
        coverImageView.fetchImage(with: book.detail.cover)
        authorLabel.text = book.detail.author
        descriptionLabel.text = book.detail.description
        
        if let ratingLabel = ratingView.arrangedSubviews.last as? UILabel {
            ratingLabel.text = String(book.detail.customerReviewRank)
        }
    }
}

