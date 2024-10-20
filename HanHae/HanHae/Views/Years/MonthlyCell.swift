//
//  MonthlyCell.swift
//  HanHae
//
//  Created by 김성민 on 9/21/24.
//

import UIKit

final class MonthlyCell: UICollectionViewCell {
    
    static let identifier = "MonthlyCell"
    
    var viewModel: MonthlyTDLViewModel? {
        didSet {
            configureUI()
        }
    }
    
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
    
    let toDoEmptyLabel: UILabel = {
        let lb = UILabel()
        lb.text = "해당 월의 목표가 없습니다."
        lb.textColor = .hhLightGray
        lb.font = .hhBody
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var toDoListStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()
    
    // 값이 변경될 제약
    private var monthLabelTopConstraint: NSLayoutConstraint!
    private var toDoCountStackViewTopConstraint: NSLayoutConstraint!
    private var toDoCountStackViewBottomConstraint: NSLayoutConstraint!
    private var percentStackViewTopConstraint: NSLayoutConstraint!
    private var percentStackViewBottomConstraint: NSLayoutConstraint!
    private var percentStackViewTrailingConstraintForMultiColumns: NSLayoutConstraint!
    private var percentStackViewTrailingConstraintForSingleColumn: NSLayoutConstraint!
    
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
        
        toDoCountStackViewTopConstraint = toDoCountStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        toDoCountStackViewBottomConstraint = toDoCountStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        
        percentStackViewTopConstraint = percentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        percentStackViewBottomConstraint = percentStackView.bottomAnchor.constraint(equalTo: toDoCountStackView.topAnchor)
        percentStackViewTrailingConstraintForMultiColumns = percentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        percentStackViewTrailingConstraintForSingleColumn = percentStackView.trailingAnchor.constraint(equalTo: toDoCountStackView.leadingAnchor, constant: -8)
        
        
        NSLayoutConstraint.activate([
            monthLabelTopConstraint,
            monthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            toDoCountStackViewBottomConstraint,
            toDoCountStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            percentStackViewBottomConstraint,
            percentStackViewTrailingConstraintForMultiColumns,
            
            toDoCountSymbolImageView.heightAnchor.constraint(equalToConstant: toDoCountLabel.font.lineHeight)
        ])
    }
    
    func changeMonthlyCellLayout(isSingleColumn: Bool) {
        changeMonthLabel(isSingleColumn: isSingleColumn)
        changePercentNumberLabel(isSingleColumn: isSingleColumn)
        changePercentSymbolLabel(isSingleColumn: isSingleColumn)
        changeToDoCountLabel(isSingleColumn: isSingleColumn)
        changeToDoCountStackView(isSingleColumn: isSingleColumn)
        changePercentStackView(isSingleColumn: isSingleColumn)
        changeToDoListStackView(isSingleColumn: isSingleColumn)
        
        UIView.animate(withDuration: 0.4) {
            self.layoutIfNeeded()
        }
    }
    
    private func changeMonthLabel(isSingleColumn: Bool) {
        if isSingleColumn {
            monthLabel.font = .hhTitle
            monthLabelTopConstraint.constant = 6
        } else {
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
    
    private func changeToDoCountStackView(isSingleColumn: Bool) {
        NSLayoutConstraint.deactivate([toDoCountStackViewTopConstraint, toDoCountStackViewBottomConstraint])
        
        if isSingleColumn {
            NSLayoutConstraint.activate([toDoCountStackViewTopConstraint])
        } else {
            NSLayoutConstraint.activate([toDoCountStackViewBottomConstraint])
        }
    }
    
    private func changePercentStackView(isSingleColumn: Bool) {
        NSLayoutConstraint.deactivate([
            percentStackViewTopConstraint,
            percentStackViewBottomConstraint,
            percentStackViewTrailingConstraintForSingleColumn,
            percentStackViewTrailingConstraintForMultiColumns
        ])
        
        if isSingleColumn {
            NSLayoutConstraint.activate([
                percentStackViewTopConstraint,
                percentStackViewTrailingConstraintForSingleColumn
            ])
        } else {
            NSLayoutConstraint.activate([
                percentStackViewBottomConstraint,
                percentStackViewTrailingConstraintForMultiColumns
            ])
        }
    }
    
    private func changeToDoListStackView(isSingleColumn: Bool) {
        if isSingleColumn {
            if toDoListStackView.superview == nil {
                contentView.addSubview(toDoListStackView)
                setupToDoListStackViewConstraints()
            }
        } else {
            toDoListStackView.removeFromSuperview()
        }
    }
    
    private func setupToDoListStackViewConstraints() {
        toDoListStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toDoListStackView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 5),
            toDoListStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            toDoListStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    private func configureUI() {
        guard let viewModel = viewModel else { return }
        
        toDoListStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if viewModel.toDoList.isEmpty {
            toDoListStackView.addArrangedSubview(toDoEmptyLabel)
        } else {
            for toDo in viewModel.toDoList {
                toDoListStackView.addArrangedSubview(createToDoStackView(for: toDo))
            }
        }
        
        monthLabel.text = viewModel.getMonthLabelText()
        monthLabel.textColor = viewModel.getMonthLabelColor()
        
        let numericLableText = viewModel.getNumericLabelText()
        percentNumberLabel.text = numericLableText.percent
        toDoCountLabel.text = numericLableText.toDoCount
    }
    
    private func createToDoStackView(for toDo: ToDo) -> UIStackView {
        let checkBoxImageView = UIImageView(image: UIImage(systemName: toDo.isCompleted ? "checkmark.square.fill" : "square"))
        checkBoxImageView.tintColor = .hhAccent
        checkBoxImageView.contentMode = .scaleAspectFill
        
        let titleLabel = UILabel()
        titleLabel.text = toDo.title
        titleLabel.textColor = .hhText
        titleLabel.font = .hhBody
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byCharWrapping
        
        let toDoStackView = UIStackView(arrangedSubviews: [checkBoxImageView, titleLabel])
        toDoStackView.axis = .horizontal
        toDoStackView.spacing = 8
        toDoStackView.alignment = .top
        
        checkBoxImageView.translatesAutoresizingMaskIntoConstraints = false
        checkBoxImageView.heightAnchor.constraint(equalToConstant: titleLabel.font.lineHeight).isActive = true
        
        return toDoStackView
    }
    
}
