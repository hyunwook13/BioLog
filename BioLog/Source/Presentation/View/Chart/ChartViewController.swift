//
//  ChartViewController.swift
//  BioLog
//
//  Created by 이현욱 on 3/26/25.
//

import UIKit

import RxSwift
import RxCocoa

@available(iOS 16.0, *)
final class ChartViewController: UIViewController, UITableViewDelegate {
    private let viewModel: ChartViewModelAble
    private let disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(ChartTableViewCell.self, forCellReuseIdentifier: ChartTableViewCell.id)
        return tableView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal) // X 버튼 이미지 설정
        button.tintColor = .label // 버튼 색상 설정
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "차트"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    init(_ viewModel: ChartViewModelAble) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("start", Date.timeIntervalSinceReferenceDate)
        setupUI()
        bind()
    }
    
    private func setupUI() {
        titleLabel.text = "Charts"
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel) // 타이틀 레이블 추가
        view.addSubview(tableView)
        view.addSubview(closeButton) // X 버튼 추가
        
        // X 버튼 제약 조건 설정
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(20) // 오른쪽 여백 설정
            make.width.height.equalTo(44) // 버튼 크기 설정
        }
        
        // SnapKit을 사용한 제약 조건 설정
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview() // 가운데 정렬 설정
            make.centerY.equalTo(closeButton)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(closeButton.snp.bottom).offset(10)
        }
    }
    
    private func bind() {
        closeButton.rx.tap
            .bind(to: viewModel.dismiss)
            .disposed(by: disposeBag)
        
        self.rx.viewWillAppear
            .map { _ in () }
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: disposeBag)
        
        viewModel.datas
            .drive(tableView.rx.items(cellIdentifier: ChartTableViewCell.id, cellType: ChartTableViewCell.self)) { idx, data, cell in
                cell.configure(title: data.title, with: data.1)
            }.disposed(by: disposeBag)
    }
}

@available(iOS 16.0, *)
extension ChartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

import UIKit
import SnapKit
import RxSwift
import RxCocoa

// MARK: - Custom PaddingTextField
final class PaddingTextField: UITextField {
    private let padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    private func configure() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        leftViewMode = .always
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}

// MARK: - EditCharacterViewController
final class EditCharactersViewController: UIViewController {
    private let vm: EditCharacterViewModelAble
    private let disposeBag = DisposeBag()
    private var traits: [String] = []
    private var relationships: [String] = []

    // MARK: UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let profileImageView = UIButton()
    private let nameTextField = PaddingTextField()
    private let sexTextField = PaddingTextField()
    private let ageTextField = PaddingTextField()
    private let laborTextField = PaddingTextField()
    private let traitsCard = UIButton()
    private let relationshipsCard = UIButton()
    private let saveButton = UIButton()

    
    
    init(vm: EditCharacterViewModelAble? = nil) {
        
        func asd() {
            
        }
        
        func asdasda(note:NoteDTO) {
            
        }
        let stack = BioLogCoreDataStack.shared
        
        let storage = CoreData(
            mainContext: stack.mainContext,
            container: stack.persistentContainer
        )
        
        self.vm =  EditCharacterViewModel(
            .empty,
            CharactersUseCaseImpl(repo: CharacterRepositoryImpl(storage: storage)),
            noteUseCase: NoteUseCaseImpl(repository: NoteRepositoryImpl(storage: storage)),
            action: EditCharacterAction(addHandler: asd, editNoteHandler:asdasda(note:))
        )
        super.init(nibName: nil, bundle: nil)
    }
    

    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        bindViewModel()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = vm.character.name.isEmpty ? "새 캐릭터 추가" : "캐릭터 편집"

        // ScrollView
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

        // Profile Image
        profileImageView.setImage(UIImage(systemName: "person.fill"), for: .normal)
        profileImageView.backgroundColor = .systemGray4
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }

        // TextFields Stack
        let fieldsStack = UIStackView(arrangedSubviews: [nameTextField, sexTextField, ageTextField, laborTextField])
        fieldsStack.axis = .vertical
        fieldsStack.spacing = 16
        contentView.addSubview(fieldsStack)
        fieldsStack.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        nameTextField.placeholder = "이름"
        sexTextField.placeholder = "성별"
        ageTextField.placeholder = "나이"
        laborTextField.placeholder = "직업"

        // Traits & Relationships Cards
        contentView.addSubview(traitsCard)
        traitsCard.backgroundColor = .white
        traitsCard.layer.cornerRadius = 8
        traitsCard.layer.shadowColor = UIColor.black.cgColor
        traitsCard.layer.shadowOpacity = 0.1
        traitsCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        traitsCard.layer.shadowRadius = 4
        traitsCard.setTitleColor(.label, for: .normal)
        traitsCard.contentHorizontalAlignment = .left
        traitsCard.titleEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        traitsCard.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        traitsCard.setTitle("특성 (0개)", for: .normal)
        traitsCard.snp.makeConstraints { make in
            make.top.equalTo(fieldsStack.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        contentView.addSubview(relationshipsCard)
        relationshipsCard.backgroundColor = .white
        relationshipsCard.layer.cornerRadius = 8
        relationshipsCard.layer.shadowColor = UIColor.black.cgColor
        relationshipsCard.layer.shadowOpacity = 0.1
        relationshipsCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        relationshipsCard.layer.shadowRadius = 4
        relationshipsCard.setTitleColor(.label, for: .normal)
        relationshipsCard.contentHorizontalAlignment = .left
        relationshipsCard.titleEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        relationshipsCard.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        relationshipsCard.setTitle("관계 (0개)", for: .normal)
        relationshipsCard.snp.makeConstraints { make in
            make.top.equalTo(traitsCard.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(contentView.snp.bottom).inset(80)
        }

        // Save Button
        view.addSubview(saveButton)
        saveButton.setTitle("저장", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(54)
        }
    }

    private func setupActions() {
        traitsCard.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showListEditor(title: "특성 편집", items: self?.traits ?? []) { updated in
                    self?.traits = updated
                    self?.traitsCard.setTitle("특성 (\(updated.count)개)", for: .normal)
                }
            }).disposed(by: disposeBag)

        relationshipsCard.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showListEditor(title: "관계 편집", items: self?.relationships ?? []) { updated in
                    self?.relationships = updated
                    self?.relationshipsCard.setTitle("관계 (\(updated.count)개)", for: .normal)
                }
            }).disposed(by: disposeBag)

        saveButton.rx.tap
            .bind(to: vm.save)
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        nameTextField.rx.text.orEmpty
            .bind(to: vm.name)
            .disposed(by: disposeBag)
        sexTextField.rx.text.orEmpty
            .bind(to: vm.sex)
            .disposed(by: disposeBag)
        ageTextField.rx.text.orEmpty
            .bind(to: vm.age)
            .disposed(by: disposeBag)
        laborTextField.rx.text.orEmpty
            .bind(to: vm.labor)
            .disposed(by: disposeBag)
    }

    private func showListEditor(title: String, items: [String], completion: @escaping ([String]) -> Void) {
        let editor = EditListViewController(title: title, items: items)
        editor.onSave = completion
        let nav = UINavigationController(rootViewController: editor)
        present(nav, animated: true)
    }
}

// MARK: - EditListViewController
final class EditListViewController: UIViewController {
    var items: [String]
    var onSave: (([String]) -> Void)?

    private let tableView = UITableView()
    private let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    init(title: String, items: [String]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) missing") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneTapped))
        navigationItem.leftBarButtonItem = addButton
        addButton.target = self
        addButton.action = #selector(addItem)

        tableView.register(EditListCell.self, forCellReuseIdentifier: EditListCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc private func doneTapped() {
        onSave?(items)
        dismiss(animated: true)
    }

    @objc private func addItem() {
        items.append("")
        let index = IndexPath(row: items.count-1, section: 0)
        tableView.insertRows(at: [index], with: .automatic)
    }
}

extension EditListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditListCell.identifier, for: indexPath) as! EditListCell
        cell.configure(text: items[indexPath.row]) { [weak self] newText in
            self?.items[indexPath.row] = newText
        } deleteAction: { [weak self] in
            self?.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return cell
    }
}

// MARK: - EditListCell
final class EditListCell: UITableViewCell {
    static let identifier = "EditListCell"
    private let textField = UITextField()
    private let deleteButton = UIButton(type: .system)
    private var onTextChanged: ((String) -> Void)?
    private var onDelete: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
        contentView.addSubview(deleteButton)
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(deleteButton.snp.leading).offset(-8)
            make.height.equalTo(44)
        }
        deleteButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        deleteButton.tintColor = .systemRed
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }

    @objc private func textChanged() {
        onTextChanged?(textField.text ?? "")
    }

    @objc private func deleteTapped() {
        onDelete?()
    }

    func configure(text: String,
                   textChanged: @escaping (String) -> Void,
                   deleteAction: @escaping () -> Void) {
        textField.text = text
        onTextChanged = textChanged
        onDelete = deleteAction
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) missing") }
}

// MARK: - PaddingLabel
final class PaddingLabel: UILabel {
    let padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}
