//
//  RecommendedBookCell.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import UIKit
import SnapKit

class RecommendedBookCell: UICollectionViewCell {
    static let reuseIdentifier = "RecommendedBookCell"
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemPlaceHolder
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .label
        return label
    }()
    
    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .systemPlaceHolder
        label.numberOfLines = 2
        return label
    }()
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemSetting
        
        contentView.addSubview(authorLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(summaryLabel)
        contentView.addSubview(coverImageView)
        
        // SnapKit 레이아웃 설정
        coverImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
            make.right.equalToSuperview().inset(8)
            make.width.equalTo(100)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(12)
            make.right.lessThanOrEqualTo(coverImageView.snp.left).offset(-8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(12)
            make.right.lessThanOrEqualTo(coverImageView.snp.left).offset(-8)
        }
        
        summaryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(12)
            make.right.lessThanOrEqualTo(coverImageView.snp.left).offset(-8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with book: BookDTO) {
        authorLabel.text = book.author//"by: \(book.author)"
        titleLabel.text = book.title
        summaryLabel.text = book.description
        
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
