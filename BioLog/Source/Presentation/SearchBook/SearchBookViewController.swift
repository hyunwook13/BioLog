//
//  SearchBookViewController.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchBookViewController: UIViewController {
    
    private let viewModel: SearchBookViewModelAble
    
    private let disposeBag = DisposeBag()
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "책 이름을 입력하세요."
        sb.searchBarStyle = .prominent
        sb.showsBookmarkButton = false
        sb.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        return sb
    }()
    
    let cancelBtn = UIBarButtonItem(title: "닫기", image: nil, target: nil, action: nil)
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.rx.setDelegate(self).disposed(by: disposeBag)
        tv.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        return tv
    }()
    
    init(vm: SearchBookViewModelAble) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bind()
    }
    
    private func setupViews() {
        title = "책 검색"
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.leftBarButtonItem = cancelBtn
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        cancelBtn.rx.tap
            .bind(to: viewModel.cancel)
            .disposed(by: disposeBag)
        
        searchBar.rx.text
            .filter { !($0 == "" || $0 == nil || $0?.isEmpty ?? true) }
            .compactMap { $0 }
            .bind(to: viewModel.searchedTitle)
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        tableView.rx.didScroll
            .subscribe(onNext: { [weak self] in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(BookDTO.self)
            .bind(to: viewModel.selectedBook)
            .disposed(by: disposeBag)
        
        viewModel.books
            .drive(tableView.rx.items(cellIdentifier: SearchResultCell.reuseIdentifier, cellType: SearchResultCell.self)) { idx, book , cell in
                cell.configure(with: book)
            }.disposed(by: disposeBag)
    }
}

extension SearchBookViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
