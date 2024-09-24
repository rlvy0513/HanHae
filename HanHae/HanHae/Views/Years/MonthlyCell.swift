//
//  MonthlyCell.swift
//  HanHae
//
//  Created by 김성민 on 9/21/24.
//

import UIKit

final class MonthlyCell: UICollectionViewCell {
    
    static let identifier = "MonthlyCell"
    
    private let monthLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .hhText
        lb.textAlignment = .left
        lb.font = .hhBody
        lb.text = "00월"
        return lb
    }()
    
    private let percentNumberLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .hhText
        lb.textAlignment = .right
        lb.font = .hhLargeTitle
        lb.text = "33"
        return lb
    }()
    
    private let percentSymbolLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .hhText
        lb.textAlignment = .right
        lb.font = .hhTitle
        lb.text = "%"
        return lb
    }()
    
    private let toDoCountSymbolImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "flag.checkered"))
        imageView.tintColor = .hhLightGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let toDoCountLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .hhLightGray
        lb.textAlignment = .right
        lb.font = .hhCaption2
        lb.text = "1 / 3"
        return lb
    }()
    
    private lazy var toDoCountStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            toDoCountSymbolImageView,
            toDoCountLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
        setupView()
        setupConstraint()
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
    
    private func setupView() {
        contentView.addSubview(monthLabel)
        
        contentView.addSubview(percentNumberLabel)
        contentView.addSubview(percentSymbolLabel)
        
        contentView.addSubview(toDoCountStack)
    }
    
    private func setupConstraint() {
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        toDoCountStack.translatesAutoresizingMaskIntoConstraints = false
        
        percentNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        percentSymbolLabel.translatesAutoresizingMaskIntoConstraints = false
        
        toDoCountSymbolImageView.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            monthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            toDoCountStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            toDoCountStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            percentSymbolLabel.bottomAnchor.constraint(equalTo: toDoCountStack.topAnchor),
            percentNumberLabel.trailingAnchor.constraint(equalTo: percentSymbolLabel.leadingAnchor, constant: -1),
            
            percentNumberLabel.lastBaselineAnchor.constraint(equalTo: percentSymbolLabel.lastBaselineAnchor),
            percentSymbolLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            toDoCountSymbolImageView.heightAnchor.constraint(equalToConstant: toDoCountLabel.font.lineHeight)
        ])
    }
    
}
