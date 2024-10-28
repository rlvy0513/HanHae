//
//  TodoListTableViewCell.swift
//  HanHae
//
//  Created by 기 표 on 10/2/24.
//

import UIKit

class ToDoListTableViewCell: UITableViewCell, UITextViewDelegate {
    
    private var checkBoxImageView: UIImageView!
    var toDoListTextView: UITextView!
    private var noteTextView: UITextView!
    private var detailButton: UIButton!
    weak var delegate: MonthlyViewController?
    var viewModel: MonthlyViewModel!
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
        toDoListTextView.textColor = .hhLightGray
    
        checkBoxImageView.image = UIImage(systemName: "square")
        
        detailButton.isHidden = true

        noteTextView.text = ""
        noteTextView.isHidden = true
        noteTextView.textColor = .hhLightGray
        noteTextViewBottomConstraint.constant = 15
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateNoteText(_:)), name: NSNotification.Name("NoteUpdated"), object: nil)
    }
    
    func configure(toDo: ToDo, index: Int, delegate: MonthlyViewController, viewModel: MonthlyViewModel) {
        self.index = index
        self.delegate = delegate
        self.viewModel = viewModel
        
        selectionStyle = .none
        
        setupCheckBoxImageView(toDo: toDo)
        setupTodoListTextView(toDo: toDo)
        setupNoteTextView(toDo: toDo)
        setupDetailButton()
        setupConstraints()
        updateCheckBoxImage(toDo: toDo)
        
        if toDo.title.isEmpty || toDo.title == "목표를 입력하세요." {
            toDoListTextView.text = "목표를 입력하세요."
            toDoListTextView.textColor = .hhLightGray
        } else {
            toDoListTextView.text = toDo.title
            toDoListTextView.textColor = .hhText
        }
        
        updateNoteTextView(toDo.note)
    }
    
    private func updateNoteTextView(_ note: String?) {
        let trimmedNote = note?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if !trimmedNote.isEmpty && trimmedNote != "노트 추가하기" {
            noteTextView.text = trimmedNote
            noteTextViewBottomConstraint.constant = -10
            noteTextView.isHidden = false
        } else {
            noteTextView.text = "노트 추가하기"
            noteTextViewBottomConstraint.constant = 15
            noteTextView.isHidden = true
        }

        delegate?.updateTableViewLayout()
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
        contentView.addSubview(noteTextView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleNoteTextViewTap))
        tapGesture.delegate = self
        noteTextView.addGestureRecognizer(tapGesture)
        
        noteTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true

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

            if noteTextView.text == "노트 추가하기" || noteTextView.text.isEmpty {
                noteTextViewBottomConstraint.constant = -10
                noteTextView.isHidden = false
            }

            if let tableView = findTableView() {
                tableView.beginUpdates()
                tableView.endUpdates()
            }

            detailButton.isHidden = false
            toDoListTextViewTrailingConstraint.constant = -50
            UIView.animate(withDuration: 0.1) {
                self.contentView.layoutIfNeeded()
            }
        } else if textView == noteTextView {
            if noteTextView.text == "노트 추가하기" {
                noteTextView.text = ""
            }
            noteTextView.isHidden = false
            noteTextViewBottomConstraint.constant = -10
            noteTextView.becomeFirstResponder()
        }
        delegate?.showDoneButton(textView)
        delegate?.updateTableViewLayout()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == toDoListTextView {
            let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)

            if trimmedText.isEmpty {
                viewModel.updateToDoTitle(at: index, newTitle: "")
                textView.text = "목표를 입력하세요."
                textView.textColor = .hhLightGray
            } else {
                viewModel.updateToDoTitle(at: index, newTitle: trimmedText)
                textView.textColor = .hhText
            }

            detailButton.isHidden = true
            toDoListTextViewTrailingConstraint.constant = -20
            UIView.animate(withDuration: 0.1) {
                self.contentView.layoutIfNeeded()
            }

            if !noteTextView.isFirstResponder {
                updateNoteTextView(noteTextView.text)
            }
        } else if textView == noteTextView {
            let trimmedNote = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedNote.isEmpty {
                viewModel.updateToDoNote(at: index, newNote: "")
                textView.text = "노트 추가하기"
            } else {
                viewModel.updateToDoNote(at: index, newNote: trimmedNote)
            }

            if !toDoListTextView.isFirstResponder {
                updateNoteTextView(noteTextView.text)
            }
        }
        delegate?.hideDoneButton()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let tableView = findTableView() {
            tableView.performBatchUpdates(nil, completion: nil)
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.contentView.layoutIfNeeded()
            })
        }
    }
    
    @objc private func handleNoteTextViewTap() {
        if noteTextView.isHidden {
            noteTextView.isHidden = false
            noteTextViewBottomConstraint.constant = -10
        }

        if noteTextView.text == "노트 추가하기" {
            noteTextView.text = ""
        }

        noteTextView.becomeFirstResponder()

        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
    
    @objc private func toggleCheckBox() {
        guard let indexPath = findIndexPath() else { return }
        
        if toDoListTextView.isFirstResponder {
            toDoListTextView.resignFirstResponder()
            viewModel.updateToDoTitle(at: indexPath.row, newTitle: toDoListTextView.text.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
        if noteTextView.isFirstResponder {
            noteTextView.resignFirstResponder()
            viewModel.updateToDoNote(at: indexPath.row, newNote: noteTextView.text.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
        let todo = viewModel.toDoList[indexPath.row]
        
        if todo.isCompleted {
            let alertController = UIAlertController(
                title: "목표 상태 변경하기",
                message: "목표 상태를 미완료 상태로 변경하시겠습니까?",
                preferredStyle: .alert
            )
            
            let cancelAction = UIAlertAction(title: "취소하기", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let confirmAction = UIAlertAction(title: "변경하기", style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.updateToDoCompletionStatus(at: indexPath.row, isCompleted: false)
                self.updateCheckBoxImage(toDo: self.viewModel.toDoList[indexPath.row])
            }
            alertController.addAction(confirmAction)
            
            delegate?.present(alertController, animated: true, completion: nil)
        } else {
            viewModel.updateToDoCompletionStatus(at: indexPath.row, isCompleted: true)
            updateCheckBoxImage(toDo: viewModel.toDoList[indexPath.row])
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
    
    private func findIndexPath() -> IndexPath? {
        guard let tableView = findTableView() else { return nil }
        return tableView.indexPath(for: self)
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
        let toDo = viewModel.toDoList[index]
        let startDate = toDo.startDate
        let completionDate = toDo.completionDate
        let detailVC = DetailViewController()
        detailVC.toDo = toDo
        detailVC.index = index
        detailVC.start = startDate
        detailVC.completion = completionDate
        detailVC.viewModel = viewModel
        
        detailVC.modalPresentationStyle = .pageSheet
        present(detailVC, animated: true, completion: nil)
    }
}
