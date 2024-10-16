//
//  TodoListTableViewCell.swift
//  HanHae
//
//  Created by 기 표 on 10/2/24.
//

import UIKit

class ToDoListTableViewCell: UITableViewCell, UITextViewDelegate {
    
    private var checkBoxImageView: UIImageView!
    private var toDoListTextView: UITextView!
    private var noteTextView: UITextView!
    private var detailButton: UIButton!
    weak var delegate: MonthlyViewController?
    var viewModel: MonthlyToDoListViewModel!
    var index: Int!
    private var toDoListTextViewTrailingConstraint: NSLayoutConstraint!
    private var noteTextViewBottomConstraint: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupNotification()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNotification()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        toDoListTextView.text = ""
        noteTextView.text = ""
        checkBoxImageView.image = UIImage(systemName: "square")
        detailButton.isHidden = true
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateNoteText(_:)), name: NSNotification.Name("NoteUpdated"), object: nil)
    }
    
    func configure(toDo: ToDo, index: Int, delegate: MonthlyViewController, viewModel: MonthlyToDoListViewModel) {
        self.index = index
        self.delegate = delegate
        self.viewModel = viewModel
        
        selectionStyle = .none
        
        setupCheckBoxImageView(toDo: toDo)
        setupTodoListTextView(toDo: toDo)
        setupNoteTextView(toDo: toDo)
        setupDetailButton()
        setupConstraints()
        
        if let note = toDo.note?.trimmingCharacters(in: .whitespacesAndNewlines), !note.isEmpty {
            noteTextView.isHidden = false
            noteTextView.text = note
//            noteTextViewBottomConstraint.constant = -10
        } else {
            noteTextView.text = "노트 추가하기"
            noteTextView.isHidden = true
//            noteTextViewBottomConstraint.constant = 15
        }
    }

    private func setupCheckBoxImageView(toDo: ToDo) {
        checkBoxImageView = UIImageView()
        checkBoxImageView.translatesAutoresizingMaskIntoConstraints = false
        checkBoxImageView.isUserInteractionEnabled = true
        checkBoxImageView.contentMode = .scaleAspectFit
        checkBoxImageView.tintColor = .hhAccent
        
        updateCheckBoxImage(toDo: toDo)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCheckBox))
        checkBoxImageView.addGestureRecognizer(tapGesture)
        contentView.addSubview(checkBoxImageView)
    }

    private func updateCheckBoxImage(toDo: ToDo) {
        let checkBoxImage = toDo.isCompleted ? "checkmark.square.fill" : "square"
        checkBoxImageView.image = UIImage(systemName: checkBoxImage)
    }

    private func setupTodoListTextView(toDo: ToDo) {
        toDoListTextView = UITextView()
        toDoListTextView.text = toDo.title
        toDoListTextView.textColor = toDo.title == "목표를 입력하세요." ? .hhLightGray : .hhText
        toDoListTextView.font = .hhBody
        toDoListTextView.isScrollEnabled = false
        toDoListTextView.textContainer.lineBreakMode = .byWordWrapping
        toDoListTextView.translatesAutoresizingMaskIntoConstraints = false
        toDoListTextView.textContainerInset = .zero
        toDoListTextView.textContainer.lineFragmentPadding = 0
        toDoListTextView.delegate = self
        toDoListTextView.tag = index
        toDoListTextView.tintColor = .hhAccent
        toDoListTextView.backgroundColor = .clear
        contentView.addSubview(toDoListTextView)
    }

    private func setupNoteTextView(toDo: ToDo) {
        noteTextView = UITextView()
        let noteText = toDo.note?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        noteTextView.text = noteText.isEmpty ? "노트 추가하기" : noteText
        noteTextView.textColor = .hhLightGray
        noteTextView.tintColor = .hhAccent
        noteTextView.font = .hhCaption1
        noteTextView.isScrollEnabled = false
        noteTextView.textContainer.lineBreakMode = .byWordWrapping
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        noteTextView.textContainerInset = .zero
        noteTextView.textContainer.lineFragmentPadding = 0
        noteTextView.delegate = self
        noteTextView.tag = index
        noteTextView.isEditable = true
        noteTextView.backgroundColor = .clear
        noteTextView.isHidden = true
        contentView.addSubview(noteTextView)
    }

    private func setupDetailButton() {
        detailButton = UIButton(type: .custom)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .large)
        let largeImage = UIImage(systemName: "info.circle", withConfiguration: largeConfig)
        detailButton.setImage(largeImage, for: .normal)
        detailButton.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
        detailButton.translatesAutoresizingMaskIntoConstraints = false
        detailButton.contentMode = .scaleAspectFit
        detailButton.tintColor = .hhAccent
        detailButton.isHidden = true
        contentView.addSubview(detailButton)
    }

    private func setupConstraints() {
        toDoListTextViewTrailingConstraint = toDoListTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        
        noteTextViewBottomConstraint = noteTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)

        NSLayoutConstraint.activate([
            checkBoxImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            checkBoxImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            checkBoxImageView.widthAnchor.constraint(equalToConstant: 24),
            checkBoxImageView.heightAnchor.constraint(equalToConstant: 24),
            
            toDoListTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            toDoListTextView.leadingAnchor.constraint(equalTo: checkBoxImageView.trailingAnchor, constant: 10),
            toDoListTextViewTrailingConstraint,
            
            noteTextView.topAnchor.constraint(equalTo: toDoListTextView.bottomAnchor, constant: 8),
            noteTextView.leadingAnchor.constraint(equalTo: checkBoxImageView.trailingAnchor, constant: 10),
            noteTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            noteTextViewBottomConstraint,
            
            detailButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            detailButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            detailButton.widthAnchor.constraint(equalToConstant: 24),
            detailButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    @objc private func updateNoteText(_ notification: Notification) {
        if let userInfo = notification.userInfo, let updatedNote = userInfo["updatedNote"] as? String {
            self.noteTextView.text = updatedNote
            self.noteTextView.textColor = .hhLightGray
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == toDoListTextView {
            if textView.text == "목표를 입력하세요." {
                textView.text = ""
                textView.textColor = .hhText
            }
            
            if noteTextView.text == "노트 추가하기" {
                noteTextView.isHidden = false
                noteTextViewBottomConstraint.constant = -10
            }
            
            detailButton.isHidden = false
            toDoListTextViewTrailingConstraint.constant = -50
            UIView.animate(withDuration: 0.1) {
                self.contentView.layoutIfNeeded()
            }
        } else if textView == noteTextView {
            if noteTextView.text == "노트 추가하기" {
                noteTextView.text = ""
                noteTextView.textColor = .hhLightGray
            }
            noteTextView.isHidden = false
            noteTextView.becomeFirstResponder()
        }
        delegate?.showDoneButton(textView)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == toDoListTextView {
            if textView.text.isEmpty {
                textView.text = "목표를 입력하세요."
                textView.textColor = .hhLightGray
            } else {
                viewModel.updateToDoText(at: index, text: textView.text)
            }
            
            if noteTextView.text == "노트 추가하기" {
                noteTextView.isHidden = true
                noteTextViewBottomConstraint.constant = 15
            }
            
            detailButton.isHidden = true
            toDoListTextViewTrailingConstraint.constant = -20
            UIView.animate(withDuration: 0.1) {
                self.contentView.layoutIfNeeded()
            }
        } else if textView == noteTextView {
            if noteTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                noteTextView.text = "노트 추가하기"
                noteTextView.textColor = .hhLightGray
                noteTextView.isHidden = true
                noteTextViewBottomConstraint.constant = 15
            } else {
                viewModel.updateNoteText(at: index, note: noteTextView.text)
                noteTextView.textColor = .hhBlack
                noteTextView.isHidden = false
            }
        }
        delegate?.hideDoneButton()
    }

    func textViewDidChange(_ textView: UITextView) {
        if let tableView = findTableView() {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

    @objc private func toggleCheckBox() {
        if index >= 0 && index < viewModel.toDoList.count {
            let todo = viewModel.toDoList[index]
            
            if todo.isCompleted {
                let alertController = UIAlertController(
                    title: "목표 상태 변경하기",
                    message: "목표 상태를 미완료 상태로 변경하시겠습니까?",
                    preferredStyle: .alert
                )
                
                let cancelAction = UIAlertAction(title: "취소하기", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                let confirmAction = UIAlertAction(title: "변경하기", style: .default) { _ in
                    self.viewModel.updateCompletionStatus(at: self.index, isCompleted: false)
                    self.updateCheckBoxImage(toDo: todo)
                }
                alertController.addAction(confirmAction)
                
                delegate?.present(alertController, animated: true, completion: nil)
            } else {
                viewModel.updateCompletionStatus(at: index, isCompleted: true)
                updateCheckBoxImage(toDo: todo)
            }
        }
    }

    @objc private func detailButtonTapped() {
        if toDoListTextView.isFirstResponder {
            toDoListTextView.resignFirstResponder()
        }
        if noteTextView.isFirstResponder {
            noteTextView.resignFirstResponder()
        }
        delegate?.showModalForTodoList(at: index)
    }

    private func findTableView() -> UITableView? {
        var view = self.superview
        while view != nil {
            if let tableView = view as? UITableView {
                return tableView
            }
            view = view?.superview
        }
        return nil
    }
}

extension MonthlyViewController {
    func showModalForTodoList(at index: Int) {
        let todo = toDoListViewModel.toDoList[index]
        let startDate = todo.startDate
        let completionDate = todo.completionDate
        let detailVC = DetailViewController()
        detailVC.todo = todo
        detailVC.index = index
        detailVC.start = startDate
        detailVC.completion = completionDate
        detailVC.viewModel = toDoListViewModel
        
        detailVC.modalPresentationStyle = .pageSheet
        present(detailVC, animated: true, completion: nil)
    }
}
