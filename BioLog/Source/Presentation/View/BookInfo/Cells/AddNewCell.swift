import UIKit
import RxSwift
import RxCocoa

final class AddNewCell: UICollectionViewCell {
    static let identifier = "AddNewCell"
    
    var disposeBag = DisposeBag()
    let cellTapSubject = PublishSubject<Void>()
    
    private let plusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.circle.fill")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemBlue
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
//        setupGesture()
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer()
        contentView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .bind(onNext: { [weak self] _ in
                UIView.animate(withDuration: 0.1) {
                    self?.transform = .identity
                }
                self?.cellTapSubject.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.layer.borderWidth = 2.0
        contentView.layer.borderColor = UIColor.basicGray.cgColor
        contentView.layer.cornerRadius = 8.0
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(plusImageView)
        contentView.addSubview(titleLabel)
        
        plusImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(plusImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func configure(with type: SectionType) {
        switch type {
        case .character:
            titleLabel.text = "Add Character"
        case .note:
            titleLabel.text = "Add Note"
        }
    }
}
