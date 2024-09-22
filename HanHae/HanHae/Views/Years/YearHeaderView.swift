//
//  YearHeaderView.swift
//  HanHae
//
//  Created by 김성민 on 9/22/24.
//

import UIKit

final class YearHeaderView: UICollectionReusableView {
    
    static let identifier = "YearHeaderView"
    
    let yearLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.font = .hhLargeTitle
        lb.textColor = .hhText
        lb.text = "0000년"
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(yearLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            yearLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            yearLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            yearLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
