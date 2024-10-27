//
//  MonthlyMottoViewController.swift
//  HanHae
//
//  Created by 기 표 on 10/2/24.
//

import UIKit

class MonthlyMottoViewController: UIViewController, UITextViewDelegate {
    
    private var viewModel: MonthlyViewModel!
    private var mottoTextViewTopConstraint: NSLayoutConstraint!
    
    private let monthlyMottoTextView: UITextView = {
        let textView = UITextView()
        textView.font = .hhBody
        textView.textColor = .hhText
        textView.tintColor = .hhAccent
        textView.textAlignment = .center
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.tag = 1
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var monthlyMottoFooterLabel: UILabel = {
        let label = UILabel()
        label.text = "\(viewModel.monthData.month)월의 나에게"
        label.font = .hhCaption1
        label.textColor = .hhLightGray
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
        view.backgroundColor = .hhCard
        view.layer.cornerRadius = 10
        view.alpha = 1
        view.clipsToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.hhShadow.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowOpacity = 1
        view.layer.masksToBounds = false
        return view
    }()
    
    init(viewModel: MonthlyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthlyMottoTextView.delegate = self
        
        setupView()
        bindViewModel()
        
        let savedMotto = viewModel.getMonthlyMottoText()
        monthlyMottoTextView.text = savedMotto
        updateMottoTextView(for: savedMotto)
        
        updateTextViewPosition(for: monthlyMottoTextView)
        view.layoutIfNeeded()
    }
    
    private func bindViewModel() {
        viewModel.onMottoUpdated = { [weak self] newMotto in
            self?.monthlyMottoTextView.text = newMotto
            self?.updateTextViewPosition(for: self?.monthlyMottoTextView ?? UITextView())
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
            
            openingQuoteLabel.topAnchor.constraint(equalTo: monthlyBox.topAnchor, constant: 5),
            openingQuoteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            monthlyMottoTextView.leadingAnchor.constraint(equalTo: monthlyBox.leadingAnchor, constant: 10),
            monthlyMottoTextView.trailingAnchor.constraint(equalTo: monthlyBox.trailingAnchor, constant: -10),
            
            closingQuoteLabel.topAnchor.constraint(equalTo: monthlyMottoFooterLabel.bottomAnchor, constant: -3),
            closingQuoteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            monthlyMottoFooterLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            monthlyMottoFooterLabel.leadingAnchor.constraint(equalTo: monthlyBox.leadingAnchor, constant: 10),
            monthlyMottoFooterLabel.trailingAnchor.constraint(equalTo: monthlyBox.trailingAnchor, constant: -10)
        ])
        
        mottoTextViewTopConstraint = monthlyMottoTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55)
        mottoTextViewTopConstraint.isActive = true
    }
    
    private func updateMottoTextView(for text: String) {
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || text == viewModel.mottoPlaceholder {
            monthlyMottoTextView.text = viewModel.mottoPlaceholder
            monthlyMottoTextView.textColor = .hhLightGray
            hideFooterAndQuoteLabels()
        } else {
            monthlyMottoTextView.textColor = .hhText
            showFooterAndQuoteLabels()
        }
    }
    
    private func updateTextViewPosition(for textView: UITextView) {
        DispatchQueue.main.async {
            let numberOfLines = self.calculateNumberOfLines(for: textView)
            self.adjustTextViewPosition(for: numberOfLines, isDefaultText: textView.text == self.viewModel.mottoPlaceholder)
            self.view.layoutIfNeeded()
        }
    }
    
    private func calculateNumberOfLines(for textView: UITextView) -> Int {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let textViewSize = textView.sizeThatFits(size)
        let lineHeight = textView.font?.lineHeight ?? 0
        return Int(textViewSize.height / lineHeight)
    }
    
    private func adjustTextViewPosition(for numberOfLines: Int, isDefaultText: Bool) {
        mottoTextViewTopConstraint.isActive = false
        
        if isDefaultText {
            mottoTextViewTopConstraint = monthlyMottoTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
        } else {
            switch numberOfLines {
            case 1:
                mottoTextViewTopConstraint = monthlyMottoTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55)
            case 2:
                mottoTextViewTopConstraint = monthlyMottoTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45)
            case 3:
                mottoTextViewTopConstraint = monthlyMottoTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
            default:
                mottoTextViewTopConstraint = monthlyMottoTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
            }
        }
        
        mottoTextViewTopConstraint.isActive = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == viewModel.mottoPlaceholder {
            textView.text = ""
            textView.textColor = .hhText
            showFooterAndQuoteLabels()
        }
        
        updateTextViewPosition(for: textView)
        
        if let monthlyView = self.parent as? MonthlyViewController {
            monthlyView.showDoneButton(textView)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText.isEmpty {
            textView.text = viewModel.mottoPlaceholder
            textView.textColor = .hhLightGray
            hideFooterAndQuoteLabels()
        } else {
            viewModel.updateMonthlyMotto(textView.text)
            textView.textColor = .hhText
            showFooterAndQuoteLabels()
        }
        
        updateTextViewPosition(for: textView)
        
        if let monthlyView = self.parent as? MonthlyViewController {
            monthlyView.hideDoneButton()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.tag == 1 {
            let maxNumberOfLines = 3
            
            let size = CGSize(width: textView.frame.width, height: .infinity)
            let textViewSize = textView.sizeThatFits(size)
            let lineHeight = textView.font?.lineHeight ?? 0
            let numberOfLines = Int(textViewSize.height / lineHeight)
            
            if numberOfLines > maxNumberOfLines {
                textView.text = String(textView.text.dropLast())
            }
            
            adjustTextViewPosition(for: numberOfLines, isDefaultText: false)
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            
            viewModel.updateMonthlyMotto(textView.text)
        }
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
