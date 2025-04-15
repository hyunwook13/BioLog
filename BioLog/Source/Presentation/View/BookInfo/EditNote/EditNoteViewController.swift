//
//  EditNoteViewController.swift
//  BioLog
//
//  Created by 이현욱 on 4/15/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class EditNoteViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: EditNoteViewModelAble
    
    // MARK: - UI Components
    private let noteTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "노트를 작성하세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let pageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "본 페이지를 작성하세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장하기", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        return button
    }()
    
    init(_ viewModel: EditNoteViewModelAble) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        view.backgroundColor = .systemBackground
        
        // UI 컴포넌트 추가
        view.addSubview(noteTextField)
        view.addSubview(pageTextField)
        view.addSubview(saveButton)
        
        // SnapKit을 사용한 제약 조건 설정
        noteTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        pageTextField.snp.makeConstraints { make in
            make.top.equalTo(noteTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(pageTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    private func bind() {
        saveButton.rx.tap
            .bind(to: viewModel.save)
            .disposed(by: disposeBag)
        
        noteTextField.rx.text.orEmpty
            .bind(to: viewModel.context)
            .disposed(by: disposeBag)
        
        pageTextField.rx.text.orEmpty
            .bind(to: viewModel.page)
            .disposed(by: disposeBag)
    }
}
