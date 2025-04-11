//
//  BookShelfViewController.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class BookShelfViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let vm: BookShelfViewModelAble
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "책 이름을 입력하세요."
        sb.searchBarStyle = .prominent
        sb.showsBookmarkButton = false
        sb.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        return sb
    }()
    
    private let segement: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["전체", "읽는 중", "북마크"])
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = .systemBackground
        segment.selectedSegmentTintColor = .systemBlue
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: .normal)
        return segment
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let verticalSpacing: CGFloat = 32 // 위아래 간격을 더 크게 설정
        let width = (UIScreen.main.bounds.width - spacing * 3) / 2 // 좌우 여백과 중앙 여백을 고려
        layout.itemSize = CGSize(width: width, height: width * 1.5) // 높이는 width의 1.5배
        layout.minimumLineSpacing = verticalSpacing // 셀 간의 위아래 간격 증가
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.register(BookShelfCell.self, forCellWithReuseIdentifier: BookShelfCell.id)
        return cv
    }()
    
    init(_ vm: BookShelfViewModelAble) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        layout()
        bind()
        setupTapGesture()
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        // 제스처가 다른 터치 이벤트를 방해하지 않도록 설정
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    private func bind() {
        self.rx.viewWillAppear
            .map { _ in () }
            .bind(to: vm.viewWillAppear)
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: vm.searchBookTitle)
            .disposed(by: disposeBag)
        
        segement.rx.selectedSegmentIndex
            .do(onNext: { [weak self] _ in
                self?.dismissKeyboard()
            })
            .bind(to: vm.selectedIndex)
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(BookDTO.self)
            .bind(to: vm.selectedBook)
            .disposed(by: disposeBag)
        
        vm.searchedBook
            .drive(collectionView.rx.items(cellIdentifier: BookShelfCell.id, cellType: BookShelfCell.self)) { index, book, cell in
                cell.configure(with: book)
            }.disposed(by: disposeBag)
    }
    
    private func setting() {
        self.navigationItem.title = "책장"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.view.addSubview(searchBar)
        self.view.addSubview(segement)
        self.view.addSubview(collectionView)
    }
    
    private func layout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(50)
        }
        
        segement.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(segement.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
