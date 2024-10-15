//
//  TodoListTableViewCell.swift
//  HanHae
//
//  Created by 기 표 on 10/2/24.
//


import UIKit

class TodoListTableViewCell: UITableViewCell, UITextViewDelegate {
    
    private var checkBoxImageView: UIImageView!
    private var todoListTextView: UITextView!
    private var noteTextView: UITextView!
    private var dividerView: UIView!
    private var detailButton: UIButton!
    weak var delegate: MonthlyViewController?
    var viewModel: MonthlyTodoListViewModel!
    var index: Int!
    var isCompleted: Bool = false
    private var todoListTextViewTrailingConstraint: NSLayoutConstraint!

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
        todoListTextView.text = ""
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
    
    func configure(todo: ToDo, index: Int, delegate: MonthlyViewController, viewModel: MonthlyTodoListViewModel) {
        self.index = index
        self.delegate = delegate
        self.isCompleted = todo.isCompleted
        self.viewModel = viewModel
        
        selectionStyle = .none
        
        setupCheckBoxImageView(todo: todo)
        setupTodoListTextView(todo: todo)
        setupNoteTextView(todo: todo)
        setupDividerView()
        setupDetailButton()
        setupConstraints()
    }

    private func setupCheckBoxImageView(todo: ToDo) {
        let checkBoxImage = isCompleted ? "checkmark.square.fill" : "square"
        checkBoxImageView = UIImageView(image: UIImage(systemName: checkBoxImage))
        checkBoxImageView.translatesAutoresizingMaskIntoConstraints = false
        checkBoxImageView.isUserInteractionEnabled = true
        checkBoxImageView.contentMode = .scaleAspectFit
        checkBoxImageView.tintColor = .hhAccent
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCheckBox))
        checkBoxImageView.addGestureRecognizer(tapGesture)
        contentView.addSubview(checkBoxImageView)
    }

    private func setupTodoListTextView(todo: ToDo) {
        todoListTextView = UITextView()
        todoListTextView.text = todo.title
        todoListTextView.textColor = todo.title == "목표를 입력하세요." ? .hhLightGray : .hhText
        todoListTextView.font = .hhBody
        todoListTextView.isScrollEnabled = false
        todoListTextView.textContainer.lineBreakMode = .byWordWrapping
        todoListTextView.translatesAutoresizingMaskIntoConstraints = false
        todoListTextView.textContainerInset = .zero
        todoListTextView.textContainer.lineFragmentPadding = 0
        todoListTextView.delegate = self
        todoListTextView.tag = index
        todoListTextView.tintColor = .hhAccent
        todoListTextView.backgroundColor = .clear
        contentView.addSubview(todoListTextView)
    }

    private func setupNoteTextView(todo: ToDo) {
        noteTextView = UITextView()
        let noteText = todo.note?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
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
        noteTextView.isHidden = false
        contentView.addSubview(noteTextView)
    }

    private func setupDividerView() {
        dividerView = UIView()
        dividerView.backgroundColor = .hhDevider
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dividerView)
    }

    private func setupDetailButton() {
        detailButton = UIButton(type: .custom)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .large)
        let largeImage = UIImage(systemName: "exclamationmark.circle", withConfiguration: largeConfig)
        detailButton.setImage(largeImage, for: .normal)
        detailButton.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
        detailButton.translatesAutoresizingMaskIntoConstraints = false
        detailButton.contentMode = .scaleAspectFit
        detailButton.tintColor = .hhAccent
        detailButton.isHidden = true
        contentView.addSubview(detailButton)
    }

    private func setupConstraints() {
        todoListTextViewTrailingConstraint = todoListTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        NSLayoutConstraint.activate([
            checkBoxImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            checkBoxImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            checkBoxImageView.widthAnchor.constraint(equalToConstant: 24),
            checkBoxImageView.heightAnchor.constraint(equalToConstant: 24),
            
            todoListTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            todoListTextView.leadingAnchor.constraint(equalTo: checkBoxImageView.trailingAnchor, constant: 10),
            todoListTextViewTrailingConstraint,
            
            noteTextView.topAnchor.constraint(equalTo: todoListTextView.bottomAnchor, constant: 8),
            noteTextView.leadingAnchor.constraint(equalTo: checkBoxImageView.trailingAnchor, constant: 10),
            noteTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            noteTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            
            dividerView.topAnchor.constraint(equalTo: noteTextView.bottomAnchor, constant: 10),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            detailButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            detailButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            detailButton.widthAnchor.constraint(equalToConstant: 24),
            detailButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == todoListTextView {
            if textView.text == "목표를 입력하세요." {
                textView.text = ""
                textView.textColor = .hhText
            }
            detailButton.isHidden = false
            todoListTextViewTrailingConstraint.constant = -50
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
//        delegate?.textViewDidBeginEditing(textView)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == todoListTextView {
            if textView.text.isEmpty {
                textView.text = "목표를 입력하세요."
                textView.textColor = .hhLightGray
            } else {
                viewModel.updateTodoText(at: index, text: textView.text)
            }
            detailButton.isHidden = true
            todoListTextViewTrailingConstraint.constant = -20
            UIView.animate(withDuration: 0.1) {
                self.contentView.layoutIfNeeded()
            }
        } else if textView == noteTextView {
            if noteTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                noteTextView.text = "노트 추가하기"
                noteTextView.textColor = .hhLightGray
            } else {
                viewModel.updateNoteText(at: index, note: noteTextView.text)
                noteTextView.textColor = .hhBlack
            }
            noteTextView.isHidden = false
        }
//        delegate?.textViewDidEndEditing(textView)
    }

    func textViewDidChange(_ textView: UITextView) {
        if let tableView = findTableView() {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

    @objc private func toggleCheckBox() {
        if isCompleted {
            let alertController = UIAlertController(
                title: "목표 상태 변경하기",
                message: "목표 상태를 미완료 상태로 변경하시겠습니까?",
                preferredStyle: .alert
            )
            
            let cancelAction = UIAlertAction(title: "취소하기", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let confirmAction = UIAlertAction(title: "변경하기", style: .default) { _ in
                self.isCompleted = false
                self.checkBoxImageView.image = UIImage(systemName: "square")
                self.viewModel.updateCompletionStatus(at: self.index, isCompleted: false)
//                self.delegate?.saveCompletionStatus(at: self.index, isCompleted: self.isCompleted)
            }
            alertController.addAction(confirmAction)
            
            delegate?.present(alertController, animated: true, completion: nil)
        } else {
            isCompleted = true
            checkBoxImageView.image = UIImage(systemName: "checkmark.square.fill")
            viewModel.updateCompletionStatus(at: index, isCompleted: true)
//            delegate?.saveCompletionStatus(at: index, isCompleted: isCompleted)
        }
    }

    @objc private func detailButtonTapped() {
        if todoListTextView.isFirstResponder {
            todoListTextView.resignFirstResponder()
        }
        if noteTextView.isFirstResponder {
            noteTextView.resignFirstResponder()
        }
//        delegate?.showModalForTodoList(at: index)
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

    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "날짜 없음" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }

    @objc private func updateNoteText(_ notification: Notification) {
        if let userInfo = notification.userInfo, let updatedNote = userInfo["updatedNote"] as? String {
            self.noteTextView.text = updatedNote
            self.noteTextView.textColor = .hhLightGray
        }
    }
}

extension MonthlyViewController {
    func showModalForTodoList(at index: Int) {
//        let todo = viewModel.todoList[index]
//        let startDate = todo.startDate
//        let completionDate = todo.completionDate
        let detailVC = DetailViewController()
//        detailVC.todo = todo
        detailVC.index = index
//        detailVC.start = startDate
//        detailVC.completion = completionDate
        detailVC.delegate = self

        detailVC.modalPresentationStyle = .pageSheet
        present(detailVC, animated: true, completion: nil)
    }
    
    func showDoneButton(for textView: UITextView) {
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(endEditing))
        doneButton.tintColor = .hhAccent
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func hideDoneButton() {
        navigationItem.rightBarButtonItem = nil
    }
    
    @objc private func endEditing() {
        view.endEditing(true)
    }
    
}

