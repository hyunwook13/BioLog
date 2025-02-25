//
//  FeaturedBookCell.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import UIKit
import SnapKit

class FeaturedBookCell: UICollectionViewCell {
    static let reuseIdentifier = "FeaturedBookCell"
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .left
        return label
    }()
    
    private let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.trackTintColor = .lightGray
        progress.tintColor = .systemBlue
        return progress
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(progressView)
        
        coverImageView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalTo(coverImageView.snp.right).offset(12)
            make.right.equalToSuperview().inset(12)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(coverImageView.snp.right).offset(12)
            make.right.equalToSuperview().inset(12)
        }
        
        progressView.snp.makeConstraints { make in
            make.left.equalTo(coverImageView.snp.right).offset(12)
            make.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, author: String, progress: Float) {
        titleLabel.text = title
        authorLabel.text = author
        progressView.progress = progress
        // 커버 이미지는 샘플이므로 임시 배경색 사용
    }
}
