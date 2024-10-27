//
//  DetailViewController.swift
//  HanHae
//
//  Created by 기 표 on 10/2/24.
//

import UIKit

class DetailViewController: HHBaseViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    var toDo: ToDo?
    var index: Int?
    var start: Date?
    var completion: Date?
    var viewModel: MonthlyViewModel!
    private var tableView: UITableView!
    private var toDoListTextView: UITextView!
    private var noteTextView: UITextView!
    private var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupModal()
    }
    
    private func setupModal() {
        headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.titleLabel?.font = .hhBody
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        cancelButton.tintColor = .hhAccent
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("완료", for: .normal)
        doneButton.titleLabel?.font = .hhHeadLine
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        doneButton.tintColor = .hhAccent
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "자세한 내용"
        titleLabel.font = .hhHeadLine
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(cancelButton)
        headerView.addSubview(doneButton)
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            cancelButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            cancelButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            doneButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            doneButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DetailCell")
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = .hhModalCell
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            toDoListTextView = UITextView()
            toDoListTextView.font = .hhFont(.eliceDigitalBaeumRegular, ofSize: 16)
            toDoListTextView.tintColor = .hhAccent
            toDoListTextView.backgroundColor = .clear
            toDoListTextView.isScrollEnabled = false
            toDoListTextView.delegate = self
            toDoListTextView.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(toDoListTextView)
            
            if let toDoTitle = toDo?.title, toDoTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || toDoTitle == "목표를 입력하세요." {
                toDoListTextView.text = "목표를 입력하세요."
                toDoListTextView.textColor = .hhLightGray
            } else {
                toDoListTextView.text = toDo?.title
                toDoListTextView.textColor = .hhText
            }
            
            NSLayoutConstraint.activate([
                toDoListTextView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 5),
                toDoListTextView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
                toDoListTextView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                toDoListTextView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -5)
            ])
            
        case (0, 1):
            noteTextView = UITextView()
            noteTextView.font = .hhFont(.eliceDigitalBaeumRegular, ofSize: 16)
            noteTextView.tintColor = .hhAccent
            noteTextView.delegate = self
            noteTextView.backgroundColor = .clear
            noteTextView.isScrollEnabled = false
            noteTextView.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(noteTextView)
            
            if let todoNote = toDo?.note?.trimmingCharacters(in: .whitespacesAndNewlines), !todoNote.isEmpty {
                noteTextView.text = todoNote
                noteTextView.textColor = .hhLightGray
            } else {
                noteTextView.text = "노트 추가하기"
                noteTextView.textColor = .hhLightGray
            }
            
            NSLayoutConstraint.activate([
                noteTextView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 0),
                noteTextView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
                noteTextView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                noteTextView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -5)
            ])
            
        case (1, 0):
            let startDateImage = UIImageView()
            startDateImage.image = UIImage(systemName: "flag")
            startDateImage.tintColor = .hhAccent
            startDateImage.translatesAutoresizingMaskIntoConstraints = false
            
            let startLabel = UILabel()
            startLabel.text = "목표 시작일"
            startLabel.font = .hhFont(.eliceDigitalBaeumRegular, ofSize: 16)
            startLabel.textAlignment = .left
            startLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let startDate = UILabel()
            startDate.text = formattedDate(start ?? Date())
            startDate.font = .hhFont(.eliceDigitalBaeumRegular, ofSize: 16)
            startDate.textAlignment = .right
            startDate.textColor = .hhLightGray
            startDate.translatesAutoresizingMaskIntoConstraints = false
            
            let stackView = UIStackView(arrangedSubviews: [startDateImage, startLabel, startDate])
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .fill
            stackView.spacing = 10
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            cell.contentView.addSubview(stackView)
            
            NSLayoutConstraint.activate([
                startDateImage.widthAnchor.constraint(equalToConstant: 24),
                startDateImage.heightAnchor.constraint(equalToConstant: 24),
                
                stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                stackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
                stackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10)
            ])
            
        case (1, 1):
            let completionDateImage = UIImageView()
            completionDateImage.image = UIImage(systemName: "flag.checkered")
            completionDateImage.tintColor = .hhAccent
            completionDateImage.translatesAutoresizingMaskIntoConstraints = false
            
            let completionLabel = UILabel()
            completionLabel.text = "목표 완료일"
            completionLabel.font = .hhFont(.eliceDigitalBaeumRegular, ofSize: 16)
            completionLabel.textAlignment = .left
            completionLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let completionDate = UILabel()
            completionDate.text = formattedDate(completion) ?? "-"
            completionDate.font = .hhFont(.eliceDigitalBaeumRegular, ofSize: 16)
            completionDate.textAlignment = .right
            completionDate.textColor = .hhLightGray
            completionDate.translatesAutoresizingMaskIntoConstraints = false
            
            let completionStackView = UIStackView(arrangedSubviews: [completionDateImage, completionLabel, completionDate])
            completionStackView.axis = .horizontal
            completionStackView.alignment = .center
            completionStackView.distribution = .fill
            completionStackView.spacing = 10
            completionStackView.translatesAutoresizingMaskIntoConstraints = false
            
            cell.contentView.addSubview(completionStackView)
            
            NSLayoutConstraint.activate([
                completionDateImage.widthAnchor.constraint(equalToConstant: 24),
                completionDateImage.heightAnchor.constraint(equalToConstant: 24),
                
                completionStackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                completionStackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                completionStackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
                completionStackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10)
            ])
        default:
            break
        }
        return cell
    }
    
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == noteTextView, textView.text == "노트 추가하기" {
            textView.text = ""
        }
        
        if textView == toDoListTextView, textView.text == "목표를 입력하세요." {
            textView.text = ""
            textView.textColor = .hhText
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText.isEmpty {
            if textView == noteTextView {
                textView.text = "노트 추가하기"
                textView.textColor = .hhLightGray
            } else if textView == toDoListTextView {
                textView.text = "목표를 입력하세요."
                textView.textColor = .hhLightGray
            }
        } else {
            if textView == noteTextView {
                toDo?.note = textView.text
            } else if textView == toDoListTextView {
                toDo?.title = textView.text
            }
        }
    }
    
    private func formattedDate(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd."
        return dateFormatter.string(from: date)
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneTapped() {
        let isTodoTextEmpty = toDoListTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || toDoListTextView.text == "목표를 입력하세요."
        
        if isTodoTextEmpty {
            shakeTextView(toDoListTextView)
            toDoListTextView.becomeFirstResponder()
            return
        }
        
        if let updatedNote = noteTextView.text {
            NotificationCenter.default.post(name: NSNotification.Name("NoteUpdated"), object: nil, userInfo: ["updatedNote": updatedNote])
        }
        
        if let updatedTitle = toDoListTextView.text {
            NotificationCenter.default.post(name: NSNotification.Name("TitleUpdated"), object: nil, userInfo: ["updatedTitle": updatedTitle])
        }
        
        if let index = index {
            viewModel?.updateToDoNote(at: index, newNote: noteTextView.text)
            viewModel?.updateToDoTitle(at: index, newTitle: toDoListTextView.text)
            viewModel?.fetchUpdatedToDoList()
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func shakeTextView(_ textView: UITextView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textView.center.x - 8, y: textView.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textView.center.x + 8, y: textView.center.y))
        textView.layer.add(animation, forKey: "position")
    }
}
