//
//  ViewController.swift
//  BioLog
//
//  Created by 이현욱 on 2/24/25.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    // 메인 콜렉션 뷰 (전체 화면에 2개 섹션)
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.register(NestedCollectionCell.self, forCellWithReuseIdentifier: NestedCollectionCell.reuseIdentifier)
        cv.register(RecommendedBookCell.self, forCellWithReuseIdentifier: RecommendedBookCell.reuseIdentifier)
        return cv
    }()
    
    // 두번째 섹션에 사용할 샘플 데이터 (예: 추천 도서 제목)
    private let recommendedItems: [String] = [
        "Book A", "Book B", "Book C", "Book D", "Book E"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 한 곳에서 subview 추가
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    // 섹션 2개 구성
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    // 섹션별 아이템 개수 지정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1  // 첫번째 섹션: 단 하나의 셀에 내부 콜렉션 뷰 포함
        } else {
            return recommendedItems.count // 두번째 섹션: 일반 셀들
        }
    }
    
    // 셀 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.section == 0 {
            // 첫번째 섹션: 내부 콜렉션 뷰가 포함된 셀
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NestedCollectionCell.reuseIdentifier, for: indexPath) as! NestedCollectionCell
            // 내부 콜렉션 뷰에 표시할 데이터 (예: 가로 스크롤 아이템들)
            cell.configure(with: ["Featured 1", "Featured 2", "Featured 3"])
            return cell
        } else {
            // 두번째 섹션: 일반 셀
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedBookCell.reuseIdentifier, for: indexPath) as! RecommendedBookCell
//            cell.configure(text: recommendedItems[indexPath.item])
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    // 각 셀의 크기 지정
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32 // 좌우 inset(16+16) 고려
        if indexPath.section == 0 {
            // 첫번째 섹션: 내부 콜렉션 뷰 셀 (예시 높이 200)
            return CGSize(width: width, height: 200)
        } else {
            // 두번째 섹션: 일반 셀 (예시 높이 80)
            return CGSize(width: width, height: 80)
        }
    }
}
