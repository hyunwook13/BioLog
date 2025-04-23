//
//  MainViewController.swift
//  BioLog
//
//  Created by 이현욱 on 2/24/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import RxViewController
import RxDataSources

class MainViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: MainViewModelAble
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.delegate = self
        cv.register(NestedCollectionCell.self, forCellWithReuseIdentifier: NestedCollectionCell.reuseIdentifier)
        cv.register(RecommendedBookCell.self, forCellWithReuseIdentifier: RecommendedBookCell.reuseIdentifier)
        cv.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.identifier
        )
        return cv
    }()
    
    private let addButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        btn.tintColor = .label
        return btn
    }()
    
    private let chartButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "chart.bar"), for: .normal) // 차트 아이콘
        btn.tintColor = .label
        return btn
    }()
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<Section>!
    
    init(vm: MainViewModelAble) {
        self.viewModel = vm
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingView()
        settingLayout()
        bind()
    }
    
    private func settingView() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = "어서오세요!"
        
        var barButtonItems: [UIBarButtonItem] = [UIBarButtonItem(customView: addButton)]
        if #available(iOS 16.0, *) {
            barButtonItems.append(UIBarButtonItem(customView: chartButton))
        }
        
        navigationItem.rightBarButtonItems = barButtonItems
    }
    
    private func settingLayout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        self.rx.viewWillAppear
            .map { _ in Void() }
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind(to: viewModel.add)
            .disposed(by: disposeBag)
        
        chartButton.rx.tap
            .bind(to: viewModel.chart)
            .disposed(by: disposeBag)
        
        dataSource = createDataSource()
        
        collectionView.rx.itemSelected
            .map { [weak self] indexPath -> CompleteBook in
                guard let self = self else { fatalError() }
                let item = self.dataSource[indexPath]
                switch item {
                case .recommendedBook(let book):
                    return book
                case .savedBooks(_):
                    return CompleteBook.empty
                }
            }
            .bind(to: viewModel.selectNewBook)
            .disposed(by: disposeBag)
        
        viewModel.book
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<Section> {
        return RxCollectionViewSectionedReloadDataSource<Section>(
            configureCell: { [weak self] dataSource, collectionView, indexPath, item in
                guard let self = self else { return UICollectionViewCell() }
                switch item {
                case .savedBooks(let books):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NestedCollectionCell.reuseIdentifier, for: indexPath) as! NestedCollectionCell
                    if books.isEmpty {
                        cell.configure(with: [CompleteBook.empty])
                    } else {
                        cell.configure(with: books)
                    }
                    cell.itemSelected
                        .filter { $0.detail.isbn != BookDTO.empty.isbn }
                        .bind(to: self.viewModel.selectReadingBook)
                        .disposed(by: cell.disposeBag)
                    return cell
                case .recommendedBook(let book):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedBookCell.reuseIdentifier, for: indexPath) as! RecommendedBookCell
                    cell.configure(with: book)
                    return cell
                }
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                guard kind == UICollectionView.elementKindSectionHeader else {
                    return UICollectionReusableView()
                }
                
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SectionHeaderView.identifier,
                    for: indexPath
                ) as! SectionHeaderView
                
                let sectionTitle = dataSource.sectionModels[indexPath.section].title
                header.configure(with: sectionTitle)
                
                return header
            }
        )
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.bounds.width // 좌우 inset(16+16) 고려
        if indexPath.section == 0 {
            // 첫번째 섹션: 내부 콜렉션 뷰 셀 (예시 높이 200)
            return CGSize(width: width, height: 200)
        } else {
            // 두번째 섹션: 일반 셀 (예시 높이 80)
            return CGSize(width: width - 32, height: 116)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.frame.width, height: 70)
            
        } else {
            return CGSize(width: collectionView.frame.width, height: 100)
        }
    }
}
