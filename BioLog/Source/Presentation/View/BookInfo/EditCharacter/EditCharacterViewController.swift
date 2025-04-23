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
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    
    //    private let profileView = UIView()
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
    private var notes: [String] = [""] // Initial empty note
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
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
        tableView.estimatedRowHeight = 60
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
        //        button.addTarget(self, action: #selector(addNoteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let tableStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private let headerView = UIView() // 새로운 뷰 생성
    
    init(vm: EditCharacterViewModelAble) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("EditCharacterViewController deinitialized")
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
        
        // 화면 터치 시 키보드 숨기기 위한 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // 키보드 숨기기 메서드
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Setup
    private func setupViews() {
        //        navigationItem.title = "Character"
        view.backgroundColor = .systemBackground
        
        // Add scrollView and containerView
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        // Add headerView
        containerView.addSubview(headerView)
        
        profileImageView.setImage(UIImage(systemName: "person.fill"), for: .normal)
        profileImageView.backgroundColor = .systemPlaceHolder
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.tintColor = .white
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 40
        headerView.addSubview(profileImageView)
        
        nameLabel.text = "이름"
        nameLabel.font = .systemFont(ofSize: 18)
        headerView.addSubview(nameLabel)
        
        nameTextField.placeholder = "이름"
        nameTextField.borderStyle = .roundedRect
        nameTextField.layer.borderWidth = 0
        nameTextField.backgroundColor = .systemSetting
        headerView.addSubview(nameTextField)
        
        // Sex
        sexLabel.text = "성별"
        sexLabel.font = .systemFont(ofSize: 18)
        headerView.addSubview(sexLabel)
        
        sexTextField.placeholder = "성별"
        sexTextField.borderStyle = .roundedRect
        sexTextField.layer.borderWidth = 0
        sexTextField.backgroundColor = .systemSetting
        headerView.addSubview(sexTextField)
        
        // Age
        ageLabel.text = "나이"
        ageLabel.font = .systemFont(ofSize: 18)
        headerView.addSubview(ageLabel)
        
        ageTextField.placeholder = "나이"
        ageTextField.borderStyle = .roundedRect
        ageTextField.layer.borderWidth = 0
        ageTextField.backgroundColor = .systemSetting
        headerView.addSubview(ageTextField)
        
        // Labor
        laborLabel.text = "직업"
        laborLabel.font = .systemFont(ofSize: 18)
        headerView.addSubview(laborLabel)
        
        laborTextField.placeholder = "직업"
        laborTextField.borderStyle = .roundedRect
        laborTextField.layer.borderWidth = 0
        laborTextField.backgroundColor = .systemSetting
        headerView.addSubview(laborTextField)
        
        notesLabel.text = "Notes"
        notesLabel.font = .systemFont(ofSize: 18)
        headerView.addSubview(notesLabel)
        
        containerView.addSubview(tableStackView)
        tableStackView.addArrangedSubview(notesTableView)
        containerView.addSubview(addNoteButton)
        view.addSubview(saveButton)
        
        nameTextField.text = vm.character.name
        sexTextField.text = vm.character.sex
        ageTextField.text = vm.character.age
        laborTextField.text = vm.character.labor
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.bottom.equalTo(addNoteButton.snp.bottom).offset(20)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
            make.leading.equalToSuperview().inset(16)
        }
        
        nameTextField.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
        }
        
        sexLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(30)
            make.height.equalTo(22)
            make.leading.equalTo(nameLabel)
        }
        
        ageLabel.snp.makeConstraints { make in
            make.top.equalTo(sexLabel)
            make.height.equalTo(22)
            make.leading.equalTo(headerView.snp.centerX).offset(10)
        }
        
        sexTextField.snp.makeConstraints { make in
            make.top.equalTo(sexLabel.snp.bottom).offset(10)
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(headerView.snp.centerX).offset(-10)
            make.height.equalTo(50)
        }
        
        ageTextField.snp.makeConstraints { make in
            make.top.equalTo(ageLabel.snp.bottom).offset(10)
            make.leading.equalTo(headerView.snp.centerX).offset(10)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
        
        laborLabel.snp.makeConstraints { make in
            make.top.equalTo(sexTextField.snp.bottom).offset(20)
            make.leading.equalTo(nameLabel)
            make.height.equalTo(22)
        }
        
        laborTextField.snp.makeConstraints { make in
            make.top.equalTo(laborLabel.snp.bottom).offset(10)
            make.leading.equalTo(nameLabel)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        }
        
        notesLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(25)
            make.leading.equalTo(nameLabel)
            make.height.equalTo(22)
        }
        
        tableStackView.snp.makeConstraints { make in
            make.top.equalTo(notesLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(addNoteButton.snp.top).offset(-10)
        }
        
        addNoteButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.top.equalTo(tableStackView).offset(8)
            make.bottom.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        
        //        collectionView.snp.makeConstraints { make in
        //            make.top.equalTo(notesLabel.snp.bottom).offset(10)
        //            make.leading.equalTo(nameLabel)
        //            make.centerX.equalToSuperview()
        //            make.height.equalTo(300)
        //            make.bottom.equalToSuperview().offset(-20)
        //        }
    }
    
    private func bind() {
        addNoteButton.rx.tap
            .bind(to: vm.addNote)
            .disposed(by: disposeBag)
        
        profileImageView.rx.tap
            .bind(to: vm.addImage)
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .bind(to: vm.save)
            .disposed(by: disposeBag)
        
        sexTextField.rx.text
            .orEmpty
            .bind(to: vm.sex)
            .disposed(by: disposeBag)
        
        ageTextField.rx.text
            .orEmpty
            .bind(to: vm.age)
            .disposed(by: disposeBag)
        
        nameTextField.rx.text
            .orEmpty
            .bind(to: vm.name)
            .disposed(by: disposeBag)
        
        laborTextField.rx.text
            .orEmpty
            .bind(to: vm.labor)
            .disposed(by: disposeBag)
        
        notesTableView.rx.modelSelected(NoteDTO.self)
            .bind(to: vm.selectedNote)
            .disposed(by: disposeBag)
        
        vm.notes
            .drive(notesTableView.rx.items(cellIdentifier: NoteCell.identifier, cellType: NoteCell.self)) { row, note, cell in
                cell.configure(with: note)
            }
            .disposed(by: disposeBag)
    }
    
    internal func updateProfileImage(_ image: UIImage) {
        profileImageView.setImage(image, for: .normal)
    }
}

extension EditCharacterViewController: UIScrollViewDelegate {
    
}
