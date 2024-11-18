//
//  MonthlyViewController.swift
//  HanHae
//
//  Created by 기 표 on 10/2/24.
//

import UIKit

class MonthlyViewController: HHBaseViewController {
    
    private var mottoView: MonthlyMottoViewController!
    
    var viewModel: MonthlyViewModel
    
    private var tableView: UITableView!
    private var emptyStateImageView: UIImageView!
    private var emptyStateLabel: UILabel!
    private var completionLabel: UILabel!
    private var originalContentInset: UIEdgeInsets = .zero
    var isEditingMode = false
    private var toolbar: UIToolbar!
    
    init(viewModel: MonthlyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        setupEmptyStateView()
        updateEmptyStateView(isEmpty: viewModel.isEmptyToDoList)
        updateCompletionLabel()
        setupToolbar()
        setupSwipeGesture()
        
        originalContentInset = tableView.contentInset
        
        bindViewModel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableViewLayout), name: .updateTableViewLayout, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.updateSettingButton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if let navigationBar = navigationController?.navigationBar {
            let navigationBarHeight = navigationBar.frame.height
            let largeTitleHeight = 44.0
            let yOffset = -(navigationBarHeight - largeTitleHeight)
            tableView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        let indicesToRemove = viewModel.toDoList.enumerated().compactMap { index, todo in
            return todo.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || todo.title == String(localized: "목표를 입력하세요.") ? index : nil
        }
        
        tableView.beginUpdates()
        
        for index in indicesToRemove.reversed() {
            viewModel.removeToDo(at: index)
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
        
        tableView.endUpdates()
        
        updateCompletionLabel()
        updateEmptyStateView(isEmpty: viewModel.isEmptyToDoList)
    }
    
    private func bindViewModel() {
        viewModel.onToDoListUpdated = { [weak self] toDoList in
            self?.updateEmptyStateView(isEmpty: toDoList.isEmpty)
            self?.tableView.reloadData()
            self?.updateCompletionLabel()
        }
    }
    
    // MARK: 네비게이션 세팅
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = viewModel.getMonthLabelText(for: .monthView)
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: UIFont.hhLargeTitle,
            .foregroundColor: UIColor.hhText
        ]
        
        let yearsButton = createYearsButton()
        updateSettingButton()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: yearsButton)
    }
    
    private func createYearsButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(viewModel.getYearText(), for: .normal)
        button.titleLabel?.font = .hhBody
        button.setTitleColor(.hhAccent, for: .normal)
        let image = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
        button.setImage(image, for: .normal)
        button.tintColor = .hhAccent
        button.addTarget(self, action: #selector(backYearsViewController), for: .touchUpInside)
        button.contentVerticalAlignment = .bottom
        return button
    }
    
    @objc private func backYearsViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapDeleteAllButton() {
        let alertController = UIAlertController(
            title: String(localized: "모든 목표 삭제"),
            message: String(localized: "정말로 모든 목표를 삭제하시겠습니까?"),
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(
            title: String(localized: "삭제"),
            style: .destructive
        ) { [weak self] _ in
            self?.viewModel.removeToDoList()
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.updateCompletionLabel()
                self?.updateEmptyStateView(isEmpty: self?.viewModel.isEmptyToDoList ?? true)
                self?.updateSettingButton()
                
                self?.tableView.layoutIfNeeded()
            }
        }
        
        let cancelAction = UIAlertAction(
            title: String(localized: "취소"),
            style: .cancel,
            handler: nil
        )
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func didTapSettingButton() {
        viewModel.presentSettingsViewController(vc: self)
    }
    
    func updateSettingButton() {
        let hasToDoList = !viewModel.toDoList.isEmpty
        
        let settingButton = UIButton(type: .system)
        settingButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        settingButton.tintColor = .hhAccent
        settingButton.showsMenuAsPrimaryAction = true
        settingButton.menu = createMenu(hasTodoList: hasToDoList)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingButton)
    }
    
    private func createMenu(hasTodoList: Bool) -> UIMenu {
        let editAction = UIAction(
            title: String(localized: "목록 편집하기"),
            image: UIImage(systemName: "pencil.and.list.clipboard"),
            handler: { [weak self] _ in
                self?.enterEditingMode()
            })
        editAction.attributes = hasTodoList ? [] : [.disabled]
        
        let appSettingsAction = UIAction(
            title: String(localized: "앱 설정하기"),
            image: UIImage(systemName: "gearshape"),
            handler: { [weak self] _ in
                self?.didTapSettingButton()
            })
        
        let deleteAction = UIAction(
            title: String(localized: "모든 목표 삭제하기"),
            image: UIImage(systemName: "trash"),
            handler: { [weak self] _ in
                self?.didTapDeleteAllButton()
            })
        deleteAction.attributes = hasTodoList ? [.destructive] : [.disabled]
        
        let divider = UIMenu(title: "", options: .displayInline, children: [editAction, appSettingsAction])
        
        return UIMenu(title: "", children: [divider, deleteAction])
    }
    
    private func enterEditingMode() {
        isEditingMode = true
        tableView.setEditing(true, animated: true)
        viewModel.didTapEditListButton()
        
        let doneButton = createDoneButton(selector: #selector(exitEditingMode))
        
        navigationItem.rightBarButtonItem = doneButton
        
        toolbar.isHidden = true
    }
    
    @objc func exitEditingMode() {
        isEditingMode = false
        tableView.setEditing(false, animated: true)
        viewModel.didTapEditListButton()
        updateSettingButton()
        
        toolbar.isHidden = false
    }
    
    private func createDoneButton(selector: Selector) -> UIBarButtonItem {
        let doneButton = UIBarButtonItem(
            title: String(localized: "완료"),
            style: .done,
            target: self,
            action: selector
        )
        doneButton.tintColor = .hhAccent
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.hhHeadLine,
            .foregroundColor: UIColor.hhAccent
        ]
        doneButton.setTitleTextAttributes(attributes, for: .normal)
        doneButton.setTitleTextAttributes(attributes, for: .highlighted)
        return doneButton
    }
    
    // MARK: 목표량 관련 메서드
    private func setupCompletionFooterView() {
        completionLabel = UILabel()
        completionLabel.translatesAutoresizingMaskIntoConstraints = false
        completionLabel.font = UIFont.hhTitle
        completionLabel.textColor = .hhLightGray
        completionLabel.textAlignment = .right
        
        let footerView = UIView()
        footerView.addSubview(completionLabel)
        
        NSLayoutConstraint.activate([
            completionLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 20),
            completionLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -20),
            completionLabel.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: 45),
            completionLabel.heightAnchor.constraint(equalToConstant: 33)
        ])
        
        tableView.tableFooterView = footerView
    }
    
    private func updateCompletionLabel() {
        let percentage = viewModel.getNumericLabelText().percent
        
        var fullText: String
        var defaultRange: NSRange
        
        let preferredLanguage = Locale.preferredLanguages.first?.prefix(2)
        
        if preferredLanguage == "en" {
            fullText = "Goal \(percentage)% Achieved"
            defaultRange = (fullText as NSString).range(of: "Goal Achieved")
        } else {
            fullText = "목표 \(percentage)% 달성"
            defaultRange = (fullText as NSString).range(of: "목표 달성")
        }
        
        let attributedText = NSMutableAttributedString(string: fullText)
        let percentageRange = (fullText as NSString).range(of: "\(percentage)%")
        
        attributedText.addAttributes(
            [.foregroundColor: UIColor.hhAccent, .font: UIFont.hhLargeTitle],
            range: percentageRange
        )
        attributedText.addAttributes(
            [.foregroundColor: UIColor.hhLightGray, .font: UIFont.hhTitle],
            range: defaultRange
        )
        
        completionLabel.attributedText = attributedText
    }
    
    // MARK: 엠티뷰 관련 메서드
    private func setupEmptyStateView() {
        emptyStateImageView = UIImageView()
        emptyStateImageView.image = UIImage(named: "EmptyViewImage")
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateImageView.contentMode = .scaleAspectFit
        
        emptyStateLabel = UILabel()
        emptyStateLabel.text = String(localized: "아직 이번 달 목표가 없어요!\n새로운 목표를 추가해보세요!")
        emptyStateLabel.numberOfLines = 3
        emptyStateLabel.font = .hhTitle
        emptyStateLabel.textColor = .hhLightGray
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emptyStateImageView)
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            emptyStateImageView.topAnchor.constraint(equalTo: tableView.tableHeaderView!.topAnchor, constant: 195),
            emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 220),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 220),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: -25),
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func updateEmptyStateView(isEmpty: Bool) {
        emptyStateImageView.isHidden = !isEmpty
        emptyStateLabel.isHidden = !isEmpty
        tableView.isHidden = false
        completionLabel.isHidden = isEmpty
    }
    
    // MARK: 툴바 세팅
    private func setupToolbar() {
        let addTodoListButton = createAddTodoListButton()
        
        let addTodoListBarButton = UIBarButtonItem(customView: addTodoListButton)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.items = [addTodoListBarButton, flexSpace]
        toolbar.tintColor = .hhAccent
        
        view.addSubview(toolbar)
        
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func createAddTodoListButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(String(localized: " 목표 추가하기"), for: .normal)
        button.setImage(UIImage(systemName: "plus.square.fill"), for: .normal)
        button.titleLabel?.font = .hhBody
        button.setTitleColor(.hhAccent, for: .normal)
        button.tintColor = .hhAccent
        button.contentHorizontalAlignment = .left
        button.sizeToFit()
        button.addTarget(self, action: #selector(didTapAddTodoListButton), for: .touchUpInside)
        return button
    }
    
    @objc private func didTapAddTodoListButton() {
        viewModel.addToDo()
        
        let newIndexPath = IndexPath(row: viewModel.toDoList.count - 1, section: 0)
        tableView.reloadData()
        tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let cell = self.tableView.cellForRow(at: newIndexPath) as? ToDoListTableViewCell {
                cell.toDoListTextView.becomeFirstResponder()
            }
        }
        
        tableView.layoutIfNeeded()
        updateCompletionLabel()
        updateEmptyStateView(isEmpty: viewModel.toDoList.isEmpty)
        updateSettingButton()
    }
    
    // MARK: 텍스트뷰 완료 메서드
    func showDoneButton(_ textView: UITextView) {
        let doneButton = createDoneButton(selector: #selector(endEditing))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func hideDoneButton() {
        setupNavigationBar()
    }
    
    @objc private func endEditing() {
        view.endEditing(true)
        updateTableViewLayout()
        viewModel.finishEditing()
        
        if isEditingMode {
            exitEditingMode()
        }
    }
    
    @objc func updateTableViewLayout() {
        DispatchQueue.main.async {
            self.tableView.performBatchUpdates(nil, completion: nil)
            self.tableView.layoutIfNeeded()
        }
    }
    // MARK: 키보드 이벤트 핸들러
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            let contentInsets = UIEdgeInsets(top: originalContentInset.top, left: originalContentInset.left, bottom: keyboardHeight, right: originalContentInset.right)
            tableView.contentInset = contentInsets
            tableView.scrollIndicatorInsets = contentInsets
            
            if let activeTextView = UIResponder.currentFirstResponder() as? UITextView {
                var contentOffset = tableView.contentOffset
                let textViewFrame = activeTextView.convert(activeTextView.bounds, to: tableView)
                
                let visibleRectHeight = tableView.bounds.height - keyboardHeight
                let offsetY = textViewFrame.maxY - visibleRectHeight
                
                if offsetY > 0 {
                    contentOffset.y = offsetY
                    tableView.setContentOffset(contentOffset, animated: false)
                }
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = originalContentInset
        tableView.scrollIndicatorInsets = .zero
    }
}

// MARK: - 테이블뷰
extension MonthlyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ToDoListTableViewCell.self, forCellReuseIdentifier: "TodoListCell")
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .init(top: 0, left: 55, bottom: 0, right: 20)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
        tableView.contentInset.bottom = 250
        tableView.showsVerticalScrollIndicator = false
        
        let mottoVC = MonthlyMottoViewController(viewModel: self.viewModel)
        addChild(mottoVC)
        mottoVC.didMove(toParent: self)
        mottoVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 200))
        headerView.addSubview(mottoVC.view)
        
        view.addSubview(tableView)
        tableView.tableHeaderView = headerView
        setupCompletionFooterView()
        
        NSLayoutConstraint.activate([
            mottoVC.view.topAnchor.constraint(equalTo: headerView.topAnchor),
            mottoVC.view.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            mottoVC.view.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            mottoVC.view.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath) as? ToDoListTableViewCell {
            let todo = viewModel.toDoList[indexPath.row]
            cell.configure(toDo: todo, index: indexPath.row, delegate: self, viewModel: viewModel)
            
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
            tableView.beginUpdates()
            
            viewModel.removeToDo(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            updateSettingButton()
            
            if tableView.isEditing {
                let doneButton = createDoneButton(selector: #selector(exitEditingMode))
                navigationItem.rightBarButtonItem = doneButton
            }
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        viewModel.moveToDo(fromIndex: fromIndexPath.row, toIndex: to.row)
    }
}

extension UIResponder {
    private static weak var _currentFirstResponder: UIResponder?
    
    static func currentFirstResponder() -> UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }
    
    @objc fileprivate func findFirstResponder(_ sender: AnyObject) {
        UIResponder._currentFirstResponder = self
    }
}

extension MonthlyViewController: UIGestureRecognizerDelegate {
    func setupSwipeGesture() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
