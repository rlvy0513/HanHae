//
//  MonthlyTodoListViewController.swift
//  HanHae
//
//  Created by 기 표 on 10/2/24.
//

import UIKit

protocol TodoListEditingDelegate: AnyObject {
    func todoListEditingDidBegin()
    func todoListEditingDidEnd()
    func scrollToTop()
}

class MonthlyTodoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    private var tableView: UITableView!
    private var emptyStateImageView: UIImageView!
    private var emptyStateLabel: UILabel!
    private var testButtonStackView: UIStackView!
    var completionLabel: UILabel!
    weak var delegate: TodoListEditingDelegate?
    var viewModel: MonthlyTodoListViewModel!
    var onContentHeightUpdated: ((CGFloat) -> Void)?
    
    init(viewModel: MonthlyTodoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MonthlyTodoListViewModel()
        
        setupCompletionLabel()
        setupTableView()
        bindViewModel()
        setupEmptyStateView()
        updateEmptyStateView(isEmpty: viewModel.isEmpty)
        updateCompletionLabel()
        
        DispatchQueue.main.async {
            self.updateTableViewContentHeight()
        }
    }

    private func bindViewModel() {
        viewModel.onTodoListUpdated = { [weak self] todoList in
            self?.updateEmptyStateView(isEmpty: todoList.isEmpty)
            self?.tableView.reloadData()
            self?.updateCompletionLabel()
            
            DispatchQueue.main.async {
                self?.updateTableViewContentHeight()
            }
        }
    }
    
    private func setupCompletionLabel() {
        completionLabel = UILabel()
        completionLabel.translatesAutoresizingMaskIntoConstraints = false
        completionLabel.font = UIFont.hhTitle
        completionLabel.textColor = .hhLightGray
        completionLabel.textAlignment = .right
        
        view.addSubview(completionLabel)
        
        NSLayoutConstraint.activate([
            completionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            completionLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoListTableViewCell.self, forCellReuseIdentifier: "TodoListCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 82
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: completionLabel.topAnchor, constant: -30)
        ])
    }
    
    private func setupEmptyStateView() {
        emptyStateImageView = UIImageView()
        emptyStateImageView.image = UIImage(systemName: "swift")
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateImageView.contentMode = .scaleAspectFit
        emptyStateImageView.tintColor = .hhAccent
        
        emptyStateLabel = UILabel()
        emptyStateLabel.text = "아직 이번 달 목표가 없어요!\n새로운 목표를 추가해보세요!"
        emptyStateLabel.numberOfLines = 2
        emptyStateLabel.font = .hhTitle
        emptyStateLabel.textColor = .hhLightGray
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emptyStateImageView)
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            emptyStateImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 100),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 100),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 20),
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func updateEmptyStateView(isEmpty: Bool) {
        emptyStateImageView.isHidden = !isEmpty
        emptyStateLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        completionLabel.isHidden = isEmpty
    }
    
    private func updateCompletionLabel() {
        let percentage = Int(viewModel.completionPercentage())
        let fullText = "목표량 \(percentage)% 달성"
        
        let attributedText = NSMutableAttributedString(string: fullText)
        let percentageRange = (fullText as NSString).range(of: "\(percentage)%")
        attributedText.addAttributes([
            .foregroundColor: UIColor.hhAccent,
            .font: UIFont.hhLargeTitle
        ], range: percentageRange)
        
        let defaultRange = (fullText as NSString).range(of: "목표량 달성")
        attributedText.addAttributes([
            .foregroundColor: UIColor.hhLightGray,
            .font: UIFont.hhTitle
        ], range: defaultRange)
        
        completionLabel.attributedText = attributedText
    }
    
    private func updateTableViewContentHeight() {
        DispatchQueue.main.async {
            self.tableView.layoutIfNeeded()
            let tableViewHeight = self.tableView.contentSize.height
            self.onContentHeightUpdated?(tableViewHeight)
        }
    }
    
    @objc public func didTapAddTodoListButton() {
        viewModel.addTodo()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    public func didTapEditListButton() {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    public func didTapDeleteAllButton() {
        let alertController = UIAlertController(title: "모든 목표 삭제", message: "정말로 모든 목표를 삭제하시겠습니까?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.viewModel.removeAllTodos()
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.updateCompletionLabel()
                self?.delegate?.scrollToTop()
                
                if let parentVC = self?.delegate as? MonthlyViewController {
                    parentVC.updateSettingButton()
                }
                
                self?.view.setNeedsLayout()
                self?.view.layoutIfNeeded()
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updateTableViewContentHeight()
        return viewModel.todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath) as? TodoListTableViewCell {
            let todo = viewModel.todoList[indexPath.row]
            cell.configure(todo: todo, index: indexPath.row, delegate: self, viewModel: viewModel)
            cell.backgroundColor = .clear
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeTodo(at: indexPath.row)
            tableView.reloadData()

            DispatchQueue.main.async {
                self.updateCompletionLabel()
                self.updateTableViewContentHeight()
                
                // 메뉴 상태 업데이트
                if let parentVC = self.delegate as? MonthlyViewController {
                    parentVC.updateSettingButton()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        viewModel.moveTodo(from: fromIndexPath.row, to: to.row)
    }
    
    func saveText(at index: Int, text: String) {
        viewModel.updateTodoText(at: index, text: text)
    }
    
    func saveNoteText(at index: Int, noteText: String) {
        viewModel.updateNoteText(at: index, note: noteText)
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
    func saveCompletionStatus(at index: Int, isCompleted: Bool) {
        viewModel.updateCompletionStatus(at: index, isCompleted: isCompleted)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.todoListEditingDidBegin()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.todoListEditingDidEnd()
    }
    
    func finishEditing() {
        tableView.setEditing(false, animated: true)
    }
}

