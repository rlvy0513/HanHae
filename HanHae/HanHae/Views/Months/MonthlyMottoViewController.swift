//
//  MonthlyMottoViewController.swift
//  HanHae
//
//  Created by 기 표 on 10/2/24.
//

import UIKit

class MonthlyMottoViewController: UIViewController,UITextViewDelegate {
    
    private var model: HHMonth
    private var viewModel: MonthlyMottoViewModel!
    private var mottoTextViewTopConstraint: NSLayoutConstraint!
    
    private let monthlyMottoTextView: UITextView = {
        let textView = UITextView()
        textView.font = .hhBody
        textView.textColor = .hhText
        textView.textAlignment = .center
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.tag = 1
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let monthlyMottoFooterLabel: UILabel = {
        let label = UILabel()
        label.text = "?월의 나에게"
        label.font = .hhCaption1
        label.textColor = .hhLightGray // 잘 안보임
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let openingQuoteLabel: UILabel = {
        let label = UILabel()
        label.text = "❝"
        label.font = .hhFont(.eliceDigitalBaeumBold, ofSize: 25)
        label.textColor = .hhAccent
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closingQuoteLabel: UILabel = {
        let label = UILabel()
        label.text = "❞"
        label.font = .hhFont(.eliceDigitalBaeumBold, ofSize: 25)
        label.textColor = .hhAccent
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let monthlyBox: UIView = {
        let view = UIView()
        view.backgroundColor = .hhCharacter
        view.layer.cornerRadius = 10
        view.alpha = 0.5
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(model: HHMonth) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        viewModel = MonthlyMottoViewModel(model: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthlyMottoTextView.delegate = self
        
        setupView()
        bindViewModel()
        
        let savedMotto = viewModel.loadMotto()
        monthlyMottoTextView.text = savedMotto
        updateMottoTextView(for: savedMotto)
        updateTextViewPosition()
    }
    
    private func bindViewModel() {
        viewModel.onMottoUpdated = { [weak self] newMotto in
            self?.monthlyMottoTextView.text = newMotto
            self?.updateTextViewPosition()
        }
    }
    
    private func setupView() {
        view.addSubview(monthlyBox)
        view.addSubview(openingQuoteLabel)
        view.addSubview(monthlyMottoTextView)
        view.addSubview(monthlyMottoFooterLabel)
        view.addSubview(closingQuoteLabel)
        
        NSLayoutConstraint.activate([
            monthlyBox.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            monthlyBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            monthlyBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            monthlyBox.heightAnchor.constraint(greaterThanOrEqualToConstant: 165),
            
            openingQuoteLabel.topAnchor.constraint(equalTo: monthlyBox.topAnchor, constant: 0),
            openingQuoteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            monthlyMottoTextView.leadingAnchor.constraint(equalTo: monthlyBox.leadingAnchor, constant: 10),
            monthlyMottoTextView.trailingAnchor.constraint(equalTo: monthlyBox.trailingAnchor, constant: -10),
            
            closingQuoteLabel.topAnchor.constraint(equalTo: monthlyMottoFooterLabel.bottomAnchor, constant: 0),
            closingQuoteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            monthlyMottoFooterLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 125),
            monthlyMottoFooterLabel.leadingAnchor.constraint(equalTo: monthlyBox.leadingAnchor, constant: 10),
            monthlyMottoFooterLabel.trailingAnchor.constraint(equalTo: monthlyBox.trailingAnchor, constant: -10)
        ])
        
        mottoTextViewTopConstraint = monthlyMottoTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
        mottoTextViewTopConstraint.isActive = true
    }
    
    private func updateMottoTextView(for text: String) {
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || text == "?월의 나에게\n목표 달성을 위한\n응원의 메시지를 적어주세요.\n" {
            monthlyMottoTextView.text = "?월의 나에게\n목표 달성을 위한\n응원의 메시지를 적어주세요.\n"
            monthlyMottoTextView.textColor = .hhLightGray
            hideFooterAndQuoteLabels()
        } else {
            monthlyMottoTextView.textColor = .hhText
            showFooterAndQuoteLabels()
        }
    }
    
    private func updateTextViewPosition() {
        let isDefaultText = monthlyMottoTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        monthlyMottoTextView.text == "?월의 나에게\n목표 달성을 위한\n응원의 메시지를 적어주세요.\n"
        mottoTextViewTopConstraint.isActive = false
        
        if isDefaultText {
            mottoTextViewTopConstraint = monthlyMottoTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
            monthlyMottoTextView.textColor = .hhLightGray
        } else {
            mottoTextViewTopConstraint = monthlyMottoTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
            monthlyMottoTextView.textColor = .hhText
        }
        
        mottoTextViewTopConstraint.isActive = true
        view.layoutIfNeeded()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.tag == 1, textView.text == "?월의 나에게\n목표 달성을 위한\n응원의 메시지를 적어주세요.\n" {
            textView.text = ""
            textView.textColor = .hhText
            showFooterAndQuoteLabels()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.tag == 1 && textView.text.isEmpty {
            textView.text = "?월의 나에게\n목표 달성을 위한\n응원의 메시지를 적어주세요.\n"
            textView.textColor = .hhText
            hideFooterAndQuoteLabels()
        } else {
            viewModel.updateMotto(textView.text)
        }
        updateTextViewPosition()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.tag == 1 {
            let maxNumberOfLines = 3
            
            let size = CGSize(width: textView.frame.width, height: .infinity)
            let textViewSize = textView.sizeThatFits(size)
            
            let lineHeight = textView.font?.lineHeight ?? 0
            let numberOfLines = Int(textViewSize.height / lineHeight)
            
            if numberOfLines > maxNumberOfLines {
                let newText = String(textView.text.dropLast())
                textView.text = newText
            }
            
            textView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = textViewSize.height
                }
            }
        }
        viewModel.updateMotto(textView.text)
    }
    
    private func showFooterAndQuoteLabels() {
        monthlyMottoFooterLabel.isHidden = false
        openingQuoteLabel.isHidden = false
        closingQuoteLabel.isHidden = false
    }
    
    private func hideFooterAndQuoteLabels() {
        monthlyMottoFooterLabel.isHidden = true
        openingQuoteLabel.isHidden = true
        closingQuoteLabel.isHidden = true
    }
}

