//
//  MonthlyCell.swift
//  HanHae
//
//  Created by 김성민 on 9/21/24.
//

import UIKit

final class MonthlyCell: UICollectionViewCell {
    
    static let identifier = "MonthlyCell"
    
    let monthLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .hhText
        lb.textAlignment = .left
        lb.font = .hhBody
        lb.text = "00월"
        return lb
    }()
    
    let percentNumberLabel: UILabel = {
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
    
    private lazy var percentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            percentNumberLabel,
            percentSymbolLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.alignment = .lastBaseline
        return stackView
    }()
    
    private let toDoCountSymbolImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "flag.checkered"))
        imageView.tintColor = .hhLightGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let toDoCountLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .hhLightGray
        lb.textAlignment = .right
        lb.font = .hhCaption2
        lb.text = "1 / 3"
        return lb
    }()
    
    private lazy var toDoCountStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            toDoCountSymbolImageView,
            toDoCountLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        return stackView
    }()
    
    // 값이 변경될 제약
    private var monthLabelTopConstraint: NSLayoutConstraint!
    private var toDoCountStackTopConstraint: NSLayoutConstraint!
    private var toDoCountStackBottomConstraint: NSLayoutConstraint!
    private var percentStackTopConstraint: NSLayoutConstraint!
    private var percentStackBottomConstraint: NSLayoutConstraint!
    private var percentStackTrailingConstraintForMultiColumns: NSLayoutConstraint!
    private var percentStackTrailingConstraintForSingleColumn: NSLayoutConstraint!
    
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
        contentView.addSubview(percentStackView)
        contentView.addSubview(toDoCountStackView)
    }
    
    private func setupConstraint() {
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        toDoCountSymbolImageView.translatesAutoresizingMaskIntoConstraints = false
        toDoCountStackView.translatesAutoresizingMaskIntoConstraints = false
        percentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        monthLabelTopConstraint = monthLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        
        toDoCountStackTopConstraint = toDoCountStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        toDoCountStackBottomConstraint = toDoCountStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        
        percentStackTopConstraint = percentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        percentStackBottomConstraint = percentStackView.bottomAnchor.constraint(equalTo: toDoCountStackView.topAnchor)
        percentStackTrailingConstraintForMultiColumns = percentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        percentStackTrailingConstraintForSingleColumn = percentStackView.trailingAnchor.constraint(equalTo: toDoCountStackView.leadingAnchor, constant: -8)
        
        
        NSLayoutConstraint.activate([
            monthLabelTopConstraint,
            monthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            toDoCountStackBottomConstraint,
            toDoCountStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            percentStackBottomConstraint,
            percentStackTrailingConstraintForMultiColumns,
            
            toDoCountSymbolImageView.heightAnchor.constraint(equalToConstant: toDoCountLabel.font.lineHeight)
        ])
    }
    
    func changeMonthlyCellLayout(isSingleColumn: Bool) {
        changeMonthLabel(isSingleColumn: isSingleColumn)
        changePercentNumberLabel(isSingleColumn: isSingleColumn)
        changePercentSymbolLabel(isSingleColumn: isSingleColumn)
        changeToDoCountLabel(isSingleColumn: isSingleColumn)
        changeToDoCountStack(isSingleColumn: isSingleColumn)
        changePercentStack(isSingleColumn: isSingleColumn)
        
        UIView.animate(withDuration: 0.4) {
            self.layoutIfNeeded()
        }
    }
    
    private func changeMonthLabel(isSingleColumn: Bool) {
        if isSingleColumn {
            monthLabel.font = .hhTitle
            monthLabelTopConstraint.constant = 6
        } else {
            // TODO: - 여기 아마 수정 필요, 뷰모델 필요~
            monthLabel.font = .hhBody
            monthLabelTopConstraint.constant = 8
        }
    }
    
    private func changePercentNumberLabel(isSingleColumn: Bool) {
        if isSingleColumn {
            percentNumberLabel.font = .hhCaption1
            percentNumberLabel.textColor = .hhLightGray
        } else {
            percentNumberLabel.font = .hhLargeTitle
            percentNumberLabel.textColor = .hhText
        }
    }
    
    private func changePercentSymbolLabel(isSingleColumn: Bool) {
        if isSingleColumn {
            percentSymbolLabel.font = .hhCaption1
            percentSymbolLabel.textColor = .hhLightGray
        } else {
            percentSymbolLabel.font = .hhTitle
            percentSymbolLabel.textColor = .hhText
        }
    }
    
    private func changeToDoCountLabel(isSingleColumn: Bool) {
        if isSingleColumn {
            toDoCountLabel.font = .hhCaption1
        } else {
            toDoCountLabel.font = .hhCaption2
        }
    }
    
    private func changeToDoCountStack(isSingleColumn: Bool) {
        NSLayoutConstraint.deactivate([toDoCountStackTopConstraint, toDoCountStackBottomConstraint])
        
        if isSingleColumn {
            NSLayoutConstraint.activate([toDoCountStackTopConstraint])
        } else {
            NSLayoutConstraint.activate([toDoCountStackBottomConstraint])
        }
    }
    
    private func changePercentStack(isSingleColumn: Bool) {
        NSLayoutConstraint.deactivate([
            percentStackTopConstraint,
            percentStackBottomConstraint,
            percentStackTrailingConstraintForSingleColumn,
            percentStackTrailingConstraintForMultiColumns
        ])
        
        if isSingleColumn {
            NSLayoutConstraint.activate([percentStackTopConstraint, percentStackTrailingConstraintForSingleColumn])
        } else {
            NSLayoutConstraint.activate([percentStackBottomConstraint, percentStackTrailingConstraintForMultiColumns])
        }
    }
    
}
