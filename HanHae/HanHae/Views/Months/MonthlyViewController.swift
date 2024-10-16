//
//  MonthlyViewController.swift
//  HanHae
//
//  Created by 기 표 on 10/2/24.
//

import UIKit

class MonthlyViewController: HHBaseViewController {
    
    private var mottoView: MonthlyMottoViewController!
    private var mottoViewModel: MonthlyMottoViewModel!
    var toDoListViewModel: MonthlyToDoListViewModel!
    
    private var tableView: UITableView!
    private var emptyStateImageView: UIImageView!
    private var emptyStateLabel: UILabel!
    private var completionLabel: UILabel!
    private var isEditingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mottoViewModel = MonthlyMottoViewModel(model: HHMonth(year: 2024, month: 9, monthlyComment: nil, toDoList: []))
        toDoListViewModel = MonthlyToDoListViewModel()
        
        setupNavigationBar()
        setupTableView()
        setupToolbar()
        setupEmptyStateView()
        updateEmptyStateView(isEmpty: toDoListViewModel.isEmpty)
        updateCompletionLabel()
        
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.updateSettingButton()
        }
    }
    
    private func bindViewModel() {
        toDoListViewModel.onToDoListUpdated = { [weak self] toDoList in
            self?.updateEmptyStateView(isEmpty: toDoList.isEmpty)
            self?.tableView.reloadData()
            self?.updateCompletionLabel()
        }
    }
    
    // MARK: 네비게이션 세팅
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "\(mottoViewModel.currentMonth.month)월"
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
        button.setTitle(" \(Date.todayYear)", for: .normal)
        button.titleLabel?.font = .hhBody
        button.setTitleColor(.hhAccent, for: .normal)
        let image = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
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
        let alertController = UIAlertController(title: "모든 목표 삭제", message: "정말로 모든 목표를 삭제하시겠습니까?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.toDoListViewModel.removeAllToDoList()
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.updateCompletionLabel()
                self?.updateEmptyStateView(isEmpty: self?.toDoListViewModel.isEmpty ?? true)
                self?.updateSettingButton()
                
                self?.tableView.layoutIfNeeded()
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func updateSettingButton() {
        guard let viewModel = toDoListViewModel else { return }

        let hasToDoList = !viewModel.toDoList.isEmpty
        
        let settingButton = UIButton(type: .system)
        settingButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        settingButton.tintColor = .hhAccent
        settingButton.showsMenuAsPrimaryAction = true
        settingButton.menu = createMenu(hasTodoList: hasToDoList)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingButton)
    }

    private func createMenu(hasTodoList: Bool) -> UIMenu {
        let editAction = UIAction(title: "목록 편집하기", image: UIImage(systemName: "pencil.and.list.clipboard"), handler: { [weak self] _ in
            self?.enterEditingMode()
        })
        editAction.attributes = hasTodoList ? [] : [.disabled]

        let appSettingsAction = UIAction(title: "앱 설정하기", image: UIImage(systemName: "gearshape"), handler: { (_) in
            // MARK: 설정 연결
        })
        
        let deleteAction = UIAction(title: "모든 목표 삭제하기", image: UIImage(systemName: "trash"), handler: { [weak self] _ in
            self?.didTapDeleteAllButton()
        })
        deleteAction.attributes = hasTodoList ? [.destructive] : [.disabled]
        
        let divider = UIMenu(title: "", options: .displayInline, children: [editAction, appSettingsAction])
        
        return UIMenu(title: "", children: [divider, deleteAction])
    }

    private func enterEditingMode() {
        isEditingMode = true
        tableView.setEditing(true, animated: true)
        toDoListViewModel.didTapEditListButton()
        
        let doneButton = createDoneButton(selector: #selector(exitEditingMode))

        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func exitEditingMode() {
        isEditingMode = false
        tableView.setEditing(false, animated: true)
        toDoListViewModel.didTapEditListButton()
        updateSettingButton()
    }

    private func createDoneButton(selector: Selector) -> UIBarButtonItem {
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: selector)
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
        let percentage = Int(toDoListViewModel.completionPercentage())
        let fullText = "목표 \(percentage)% 달성"
        
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
    
    // MARK: 엠티뷰 관련 메서드
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
            emptyStateImageView.topAnchor.constraint(equalTo: tableView.tableHeaderView!.topAnchor, constant: 250),
            emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 100),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 100),

            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 20),
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
        
        let toolbar = UIToolbar()
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
        button.setTitle(" 목표 추가하기", for: .normal)
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
        toDoListViewModel.addToDo()
        tableView.reloadData()
        tableView.layoutIfNeeded()
        updateCompletionLabel()
        updateEmptyStateView(isEmpty: toDoListViewModel.toDoList.isEmpty)
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
        toDoListViewModel.finishEditing()
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

        let mottoVC = MonthlyMottoViewController(viewModel: mottoViewModel)
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
        return toDoListViewModel.toDoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath) as? ToDoListTableViewCell {
            let todo = toDoListViewModel.toDoList[indexPath.row]
            cell.configure(toDo: todo, index: indexPath.row, delegate: self, viewModel: toDoListViewModel)

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
            toDoListViewModel.removeToDo(at: indexPath.row)
            tableView.reloadData()
            updateSettingButton()
        }
    }

    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        toDoListViewModel.moveToDo(from: fromIndexPath.row, to: to.row)
    }
}
