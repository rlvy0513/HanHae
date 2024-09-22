//
//  MonthlyCell.swift
//  HanHae
//
//  Created by 김성민 on 9/21/24.
//

import UIKit

final class MonthlyCell: UICollectionViewCell {
    
    static let identifier = "MonthlyCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.shadowColor = UIColor.hhShadow.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowOpacity = 1
        layer.masksToBounds = false
    }
    
    private func setupCell() {
        contentView.backgroundColor = .hhCard
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
}
