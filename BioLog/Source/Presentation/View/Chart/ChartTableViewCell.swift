//
//  ChartTableViewCell.swift
//  BioLog
//
//  Created by 이현욱 on 4/16/25.
//

import UIKit
import SwiftUI
import Charts

import SnapKit

// MARK: - ChartTableViewCell
@available(iOS 16.0, *)
class ChartTableViewCell: UITableViewCell {
    static let id = "ChartTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private lazy var chartView = UIView() // 차트를 표시할 뷰
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, with data: [ChartData]) {
        titleLabel.text = title
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(8)
        }
        
        let chart = BarChart(data: data)
        chartView = UIHostingController(rootView: chart).view
        
        contentView.addSubview(chartView)
        
        // SnapKit을 사용한 제약 조건 설정
        chartView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview().inset(8)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }
}


@available(iOS 16.0, *)
struct BarChart: View {
    let data: [ChartData]

    var body: some View {
        Chart(data) {
            BarMark(
                x: .value("name", $0.name),
                y: .value("age", $0.value)
//                width: .automatic,
//                height: .automatic
//                stacking: .center
            )
        }
    }
}
