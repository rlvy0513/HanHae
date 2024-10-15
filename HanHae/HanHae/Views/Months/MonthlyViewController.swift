//
//  MonthlyViewController.swift
//  HanHae
//
//  Created by 기 표 on 10/2/24.
//

import UIKit

protocol TodoListEditingDelegate: AnyObject {
    func todoListEditingDidBegin()
    func todoListEditingDidEnd()
}

class MonthlyViewController: HHBaseViewController {
    
    private var mottoVC: MonthlyMottoViewController!
    private var mottoViewModel: MonthlyMottoViewModel!
    var toDoListViewModel: MonthlyToDoListViewModel!
    
    private var isEditingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mottoViewModel = MonthlyMottoViewModel(model: HHMonth(year: 2024, month: 9, monthlyComment: nil, toDoList: []))
        
        setupNavigationBar()
        setupSubViewControllers()
        setupToolbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.updateSettingButton()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
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
        button.addTarget(self, action: #selector(popMonthlyViewController), for: .touchUpInside)
        button.contentVerticalAlignment = .bottom
        return button
    }
    
    private func setupSubViewControllers() {
        mottoVC = MonthlyMottoViewController(viewModel: mottoViewModel)
        mottoVC.delegate = self
        addChild(mottoVC)
        mottoVC.view.translatesAutoresizingMaskIntoConstraints = false
        mottoVC.didMove(toParent: self)

        DispatchQueue.main.async {
            self.updateSettingButton()
        }
        
        NSLayoutConstraint.activate([
            mottoVC.view.heightAnchor.constraint(equalToConstant: 250),
        ])
    }
    
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
//        todoListVC.didTapAddTodoListButton()
        
    }
    
    @objc private func didTapDeleteAllButton() {
//        todoListVC.didTapDeleteAllButton()
        
        DispatchQueue.main.async {
            self.updateSettingButton()
        }
    }
    
    @objc private func popMonthlyViewController() {
        navigationController?.popViewController(animated: true)
    }

    func updateSettingButton() {
        
//        let hasTodoList = !viewModel.todoList.isEmpty
        
        let settingButton = UIButton(type: .system)
        settingButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        settingButton.tintColor = .hhAccent
        settingButton.showsMenuAsPrimaryAction = true
//        settingButton.menu = createMenu(hasTodoList: hasTodoList)
        
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
//            self?.todoListVC.didTapDeleteAllButton()
        })
        deleteAction.attributes = hasTodoList ? [.destructive] : [.disabled]
        
        let divider = UIMenu(title: "", options: .displayInline, children: [editAction, appSettingsAction])
        
        return UIMenu(title: "", children: [divider, deleteAction])
    }
    
    private func enterEditingMode() {
        isEditingMode = true
        
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(exitEditingMode))
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.hhHeadLine,
            .foregroundColor: UIColor.hhAccent
        ]
        doneButton.setTitleTextAttributes(attributes, for: .normal)
        doneButton.setTitleTextAttributes(attributes, for: .highlighted)
        
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func exitEditingMode() {
        isEditingMode = false
//        todoListVC.didTapEditListButton()
        updateSettingButton()
    }
    
    @objc private func endTodoEditing() {
        view.endEditing(true)
//        todoListVC.finishEditing()
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
}

extension MonthlyViewController: TodoListEditingDelegate {
    func todoListEditingDidBegin() {
        let doneButton = createDoneButton(selector: #selector(endTodoEditing))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func todoListEditingDidEnd() {
        setupNavigationBar()
    }
}

extension MonthlyViewController: MonthlyMottoDelegate {
    func mottoEditingDidBegin() {
        let doneButton = createDoneButton(selector: #selector(endMottoEditing))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func mottoEditingDidEnd() {
        setupNavigationBar()
    }
    
    @objc private func endMottoEditing() {
        view.endEditing(true)
    }
}
