//
//  BookInfoViewController.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import RxViewController
import RxDataSources

final class BookInfoViewController: UIViewController {
    private let viewModel: BookInfoViewModelAble
    private let disposeBag = DisposeBag()
    
    private lazy var dataSource = createDataSource()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        
        // Register cells
        collectionView.register(BookInfoCell.self, forCellWithReuseIdentifier: BookInfoCell.identifier)
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.identifier)
//        collectionView.register(NoteCell.self, forCellWithReuseIdentifier: NoteCell.identifier)
        collectionView.register(AddNewCell.self, forCellWithReuseIdentifier: AddNewCell.identifier)
        
        // Register headers
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.identifier)
        return collectionView
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .systemRed
        return button
    }()
    
    // 검색 버튼 추가
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    // 읽기 시작 버튼 추가
    //    lazy var startReadingButton: UIButton = {
    //        let button = UIButton()
    //        button.setTitle("읽기 시작", for: .normal)
    //        button.setTitleColor(.systemBlue, for: .normal)
    //        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    //        return button
    //    }()
    
    init(viewModel: BookInfoViewModelAble) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("BookInfoViewController deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.largeTitleDisplayMode = .never
        
        // 삭제 버튼과 검색 버튼을 포함하는 스택 뷰 생성
        let buttonStackView = UIStackView(arrangedSubviews: [deleteButton, searchButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 16
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonStackView)
        
        self.view.addSubview(collectionView)
        //        self.view.addSubview(startReadingButton) // 읽기 시작 버튼 추가
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        //        startReadingButton.snp.makeConstraints {
        //            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        //            $0.centerX.equalToSuperview()
        //        }
    }
    
    private func bind() {
        self.rx.viewWillAppear
            .map { _ in () }
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .bind(to: viewModel.delete)
            .disposed(by: disposeBag)
        
        //        searchButton.rx.tap
        //            .bind(to: viewModel.search)
        //            .disposed(by: disposeBag)
        //
        //        startReadingButton.rx.tap
        //            .bind(to: viewModel.startReading)
        //            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .bind { [weak self] idx in
                guard let self = self else { return }
                let selectedItem = dataSource[idx.section].items[idx.item]
                
                switch selectedItem {
                case .characters(let character):
                    if character.name == "아무도_만들지_않을_만한_이름" {
                        viewModel.addCharacter.onNext(())
                    } else {
                        viewModel.selectedCharacter.onNext(character)
                    }
//                case .notes(let note):
//                    if note.context == "아무도_만들지_않을_만한_이름" {
//                        viewModel.addNote.onNext(())
//                    } else {
//                        viewModel.selectedNote.onNext(note)
//                    }
                case .bookInfo(_):
                    return
                }
            }
            .disposed(by: disposeBag)
        
        viewModel
            .result
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension BookInfoViewController {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let section = self.dataSource[sectionIndex].types.first
            
            switch section {
            case .bookInfo:
                return self.createBookInfoSection()
            case .characters:
                return self.createCharactersSection()
//            case .notes:
//                return self.createNotesSection()
            default:
                return nil
            }
        }
    }
    
    private func createBookInfoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        return section
    }
    
    private func createCharactersSection() -> NSCollectionLayoutSection {
        let spacing: CGFloat = 16
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalWidth(0.5)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.5)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createNotesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(80))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<InfoSection> {
        return RxCollectionViewSectionedReloadDataSource<InfoSection>(
            configureCell: { [weak self] dataSource, collectionView, indexPath, item in
                guard let self = self else { return UICollectionViewCell() }
                switch item {
                case .bookInfo(let book):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookInfoCell.identifier,
                                                                  for: indexPath) as! BookInfoCell
                    self.title = book.detail.title
                    cell.configure(with: book)
                    return cell
                    
                case .characters(let character):
                    if character.name == "아무도_만들지_않을_만한_이름" {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddNewCell.identifier,
                                                                      for: indexPath) as! AddNewCell
                        
                        cell.configure(with: .character)
                        //                        cell.cellTapSubject
                        //                            .map { _ in .character }
                        //                            .bind(to: viewModel.addCell)
                        //                            .disposed(by: cell.disposeBag)
                        return cell
                    }
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier,
                                                                  for: indexPath) as! CharacterCell
                    cell.configure(with: character)
                    
                    return cell
//                    
//                case .notes(let note):
//                    if note.context == "아무도_만들지_않을_만한_이름" {
//                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddNewCell.identifier,
//                                                                      for: indexPath) as! AddNewCell
//                        cell.configure(with: .note)
//                        //                        cell.cellTapSubject
//                        //                            .map { _ in .note }
//                        //                            .bind(to: viewModel.addCell)
//                        //                            .disposed(by: cell.disposeBag)
//                        return cell
//                    }
//                    return UICollectionViewCell()
//                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCell.identifier,
//                                                                  for: indexPath) as! NoteCell
//                    cell.configure(with: note)
//                    return cell
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
