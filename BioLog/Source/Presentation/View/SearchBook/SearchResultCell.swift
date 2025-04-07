//
//  SearchResultCell.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import UIKit
import SnapKit

class SearchResultCell: UITableViewCell {
    static let reuseIdentifier = "SearchResultCell"
    
    private let coverImageView: AsyncFetchImageView = {
        let imageView = AsyncFetchImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.backgroundColor = .lightGray // 임시 배경색 (실제 이미지를 로드할 때 교체)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .systemPlaceHolder
        label.numberOfLines = 1
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        label.textColor = .systemPlaceHolder
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 서브뷰 추가
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(ratingLabel)
        
        // SnapKit 레이아웃 설정
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        coverImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
            make.width.equalTo(coverImageView.snp.height).multipliedBy(0.75)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.top).offset(8)
            make.left.equalTo(coverImageView.snp.right).offset(12)
            make.right.equalToSuperview().inset(24)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.bottom.equalTo(coverImageView.snp.bottom).offset(-8).priority(.low)
            $0.left.equalTo(titleLabel.snp.left)
            $0.top.equalTo(authorLabel.snp.bottom).offset(8)
        }
    }
    
    func configure(with book: BookDTO) {
        titleLabel.text = book.title
        authorLabel.text = book.author
        ratingLabel.text = "★ \(book.customerReviewRank)"
        coverImageView.fetchImage(with: book.cover)
    }
}
