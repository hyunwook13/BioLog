//
//  NestedCollectionCell.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

// MARK: - 첫번째 섹션: 내부 콜렉션 뷰가 포함된 셀
class NestedCollectionCell: UICollectionViewCell {
    static let reuseIdentifier = "NestedCollectionCell"
    let screenWidth = UIScreen.main.bounds.width
    
    let disposeBag = DisposeBag()
    
    private let items: BehaviorSubject<[CompleteBook]> = BehaviorSubject(value: [])

    var itemSelected: ControlEvent<CompleteBook> {
        return innerCollectionView.rx.modelSelected(CompleteBook.self)
    }
    
    // 내부 콜렉션 뷰 (예: 가로 스크롤)
    private lazy var innerCollectionView: UICollectionView = {
        let collectionWidth = screenWidth
        let itemWidth = screenWidth - 36 // 원하는 높이 설정
        let inset = (collectionWidth - itemWidth) / 2
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        layout.itemSize = CGSize(width: itemWidth, height: 200)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = false
        cv.rx.setDelegate(self).disposed(by: disposeBag)
        cv.register(FeaturedBookCell.self, forCellWithReuseIdentifier: FeaturedBookCell.reuseIdentifier)
        cv.decelerationRate = .fast
        
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setting()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 데이터 전달 후 내부 콜렉션 뷰 리로드
    func configure(with items: [CompleteBook]) {
        self.items.onNext(items)
        innerCollectionView.reloadData()
    }
    
    private func setting() {
        contentView.addSubview(innerCollectionView)
        
        innerCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        items.bind(to: innerCollectionView.rx.items(cellIdentifier: FeaturedBookCell.reuseIdentifier, cellType: FeaturedBookCell.self)) { _, book, cell in
            cell.configure(with: book)
        }.disposed(by: disposeBag)
    }
}

extension NestedCollectionCell: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = innerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let cellWidth = layout.itemSize.width
        let spacing = layout.minimumLineSpacing
        let cellWidthIncludingSpacing = cellWidth + spacing
        
        // 현재 오프셋에 sectionInset.left을 더해서 계산
        let offsetX = scrollView.contentOffset.x + scrollView.contentInset.left
        
        // 현재 셀 인덱스(소수점 포함)
        let index = offsetX / cellWidthIncludingSpacing
        
        // 임계치 설정: 예를 들어 셀의 절반 이상을 넘겼을 때 다음 셀로 전환
        let threshold: CGFloat = 0.5
        
        // 현재 셀의 인덱스(정수 부분)
        let currentIndex = floor(index)
        let fractionalPart = index - currentIndex
        
        var targetIndex: CGFloat = currentIndex
        
        // 스크롤 속도가 일정 임계값보다 크면 velocity에 따라 진행 방향을 결정
        if abs(velocity.x) > 0.2 {
            targetIndex = velocity.x > 0 ? ceil(index) : floor(index)
        } else {
            // 그렇지 않다면, 스크롤한 거리의 비율(fractionalPart)을 보고 결정
            targetIndex = fractionalPart > threshold ? ceil(index) : floor(index)
        }
        
        // 새로운 오프셋 계산 (sectionInset.left을 빼주어 조정)
        let newOffsetX = targetIndex * cellWidthIncludingSpacing - scrollView.contentInset.left
        
        targetContentOffset.pointee = CGPoint(x: newOffsetX, y: targetContentOffset.pointee.y)
    }
}
