//
//  EditCharacterViewController.swift
//  BioLog
//
//  Created by 이현욱 on 3/21/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class EditCharacterViewController: UIViewController {
    
    private let vm: EditCharacterViewModelAble
    private let disposeBag = DisposeBag()
    private var tableViewHeightConstraint: Constraint!
    //    private var notes = [NoteDTO]()
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    
    private let profileImageView = UIButton()
    private let nameLabel = UILabel()
    private let nameTextField = UITextField()
    
    private let sexLabel = UILabel()
    private let sexTextField = UITextField()
    
    private let ageLabel = UILabel()
    private let ageTextField = UITextField()
    
    private let laborLabel = UILabel()
    private let laborTextField = UITextField()
    
    private let notesLabel = UILabel()
    
    private lazy var notesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NoteCell.self, forCellReuseIdentifier: NoteCell.identifier)
        tableView.backgroundColor = .systemBackground
        tableView.layer.cornerRadius = 8
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.systemGray5.cgColor
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 80
        return tableView
    }()
    
    private let addNoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("노트 추가", for: .normal)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - Init
    init(vm: EditCharacterViewModelAble) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bind()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        // Profile Image
        profileImageView.setImage(UIImage(systemName: "person.fill"), for: .normal)
        profileImageView.backgroundColor = .systemGray3
        profileImageView.tintColor = .white
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 40
        containerView.addSubview(profileImageView)
        
        // Labels
        [nameLabel, sexLabel, ageLabel, laborLabel, notesLabel].forEach {
            $0.font = .systemFont(ofSize: 18)
            containerView.addSubview($0)
        }
        nameLabel.text = "이름"
        sexLabel.text = "성별"
        ageLabel.text = "나이"
        laborLabel.text = "직업"
        notesLabel.text = "Notes"
        
        // TextFields
        [nameTextField, sexTextField, ageTextField, laborTextField].forEach {
            $0.borderStyle = .roundedRect
            $0.backgroundColor = .systemGray6
            containerView.addSubview($0)
        }
        nameTextField.placeholder = "이름"
        sexTextField.placeholder = "성별"
        ageTextField.placeholder = "나이"
        laborTextField.placeholder = "직업"
        
        // Notes Table & Buttons
        containerView.addSubview(notesTableView)
        containerView.addSubview(addNoteButton)
        containerView.addSubview(saveButton)
        
        // 초기 값 세팅
        nameTextField.text = vm.character.name
        sexTextField.text = vm.character.sex
        ageTextField.text = vm.character.age
        laborTextField.text = vm.character.labor
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(16)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        sexLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(16)
            make.leading.equalTo(nameLabel)
        }
        sexTextField.snp.makeConstraints { make in
            make.top.equalTo(sexLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(nameTextField)
            make.height.equalTo(44)
        }
        
        ageLabel.snp.makeConstraints { make in
            make.top.equalTo(sexTextField.snp.bottom).offset(16)
            make.leading.equalTo(nameLabel)
        }
        ageTextField.snp.makeConstraints { make in
            make.top.equalTo(ageLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(nameTextField)
            make.height.equalTo(44)
        }
        
        laborLabel.snp.makeConstraints { make in
            make.top.equalTo(ageTextField.snp.bottom).offset(16)
            make.leading.equalTo(nameLabel)
        }
        laborTextField.snp.makeConstraints { make in
            make.top.equalTo(laborLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(nameTextField)
            make.height.equalTo(44)
        }
        
        notesLabel.snp.makeConstraints { make in
            make.top.equalTo(laborTextField.snp.bottom).offset(24)
            make.leading.equalTo(nameLabel)
        }
        
        notesTableView.snp.makeConstraints { make in
            make.top.equalTo(notesLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            tableViewHeightConstraint = make.height.equalTo(0).constraint
        }
        
        addNoteButton.snp.makeConstraints { make in
            make.top.equalTo(notesTableView.snp.bottom).offset(12)
            make.leading.trailing.equalTo(notesTableView)
            make.height.equalTo(40)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(addNoteButton.snp.bottom).offset(24)
            make.leading.trailing.equalTo(notesTableView)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Binding
    private func bind() {
        // TextFields
        nameTextField.rx.text.orEmpty.bind(to: vm.name).disposed(by: disposeBag)
        sexTextField.rx.text.orEmpty.bind(to: vm.sex).disposed(by: disposeBag)
        ageTextField.rx.text.orEmpty.bind(to: vm.age).disposed(by: disposeBag)
        laborTextField.rx.text.orEmpty.bind(to: vm.labor).disposed(by: disposeBag)
        
        // Buttons
        profileImageView.rx.tap.bind(to: vm.addImage).disposed(by: disposeBag)
        addNoteButton.rx.tap.bind(to: vm.addNote).disposed(by: disposeBag)
        saveButton.rx.tap.bind(to: vm.save).disposed(by: disposeBag)
        
        notesTableView.rx.itemDeleted
            .bind {
                print($0)
            }.disposed(by: disposeBag)
        
        notesTableView.rx.modelSelected(NoteDTO.self)
            .bind(to: vm.selectedNote)
            .disposed(by: disposeBag)
        
        // Notes -> TableView
        vm.notes
            .drive(notesTableView.rx.items(cellIdentifier: NoteCell.identifier, cellType: NoteCell.self)) { _, note, cell in
                cell.configure(with: note)
            }
            .disposed(by: disposeBag)
        
        // Adjust table height on data update
        vm.notes
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.notesTableView.reloadData()
                self.notesTableView.layoutIfNeeded()
                let height = self.notesTableView.contentSize.height
                self.tableViewHeightConstraint.update(offset: height)
            })
            .disposed(by: disposeBag)
    }
}

extension EditCharacterViewController: UITableViewDelegate {}
