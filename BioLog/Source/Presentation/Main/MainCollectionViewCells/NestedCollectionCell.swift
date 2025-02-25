//
//  NestedCollectionCell.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import UIKit
import SnapKit

// MARK: - 첫번째 섹션: 내부 콜렉션 뷰가 포함된 셀
class NestedCollectionCell: UICollectionViewCell {
    static let reuseIdentifier = "NestedCollectionCell"
    
    private var items: [String] = []
    
    // 내부 콜렉션 뷰 (예: 가로 스크롤)
    private lazy var innerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.itemSize = CGSize(width: 150, height: 150)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.register(FeaturedBookCell.self, forCellWithReuseIdentifier: FeaturedBookCell.reuseIdentifier)
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        contentView.addSubview(innerCollectionView)
        innerCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // 데이터 전달 후 내부 콜렉션 뷰 리로드
    func configure(with items: [String]) {
        self.items = items
        innerCollectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NestedCollectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedBookCell.reuseIdentifier, for: indexPath) as! FeaturedBookCell
//        cell.configure(text: items[indexPath.item])
        return cell
    }
}
