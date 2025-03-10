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
        imageView.backgroundColor = .systemGray4
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.tintColor = .systemGray
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
        label.textColor = .systemPlaceHolder
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
        
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemSetting
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(progressView)
        
        coverImageView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(138)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 이미지뷰 초기화
        coverImageView.image = nil
    }
    
    func configure(with book: BookDTO) {
        if book.isbn == BookDTO.empty.isbn {
            titleLabel.text = "추가하신 도서가 없습니다"
            authorLabel.text = "새로운 도서를 추가해보세요!"
            coverImageView.image = UIImage(systemName: "book.closed")
            progressView.isHidden = true
        } else {
            titleLabel.text = book.title
            authorLabel.text = book.author
            guard let url = URL(string: book.cover) else { return }
            
            DispatchQueue.global(qos: .background).async { [weak self] in
                if let data = try? Data(contentsOf: url),
                   let downloadedImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.coverImageView.image = downloadedImage
                    }
                }
            }
        }
    }
}
