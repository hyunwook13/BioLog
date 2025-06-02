//
//  NoteCell.swift
//  BioLog
//
//  Created on 7/9/25.
//

import UIKit

final class NoteCell: UITableViewCell {
    static let identifier = "NoteCell"
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let pageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Cell의 Touch 시작")
        super.touchesBegan(touches, with: event)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Cell의 Touch 끝")
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Cell의 Touch 취소됨")
        super.touchesCancelled(touches, with: event)
    }
    
    
    
    private func setupUI() {
        contentView.addSubview(noteLabel)
        contentView.addSubview(pageLabel)
        contentView.backgroundColor = .basicGray
        contentView.layer.cornerRadius = 8.0
        contentView.layer.masksToBounds = true
        
        noteLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalTo(pageLabel.snp.top).offset(6)
        }
        
        pageLabel.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.height.equalTo(25)
        }
    }
    
    func configure(with note: NoteDTO) {
        noteLabel.text = note.context
        pageLabel.text = note.page
    }
}
