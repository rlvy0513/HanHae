//
//  MonthlyViewController.swift
//  HanHae
//
//  Created by 기 표 on 10/2/24.
//

import UIKit

class MonthlyViewController: HHBaseViewController, UIScrollViewDelegate {
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var mottoVC: MonthlyMottoViewController!
    private var todoListVC: MonthlyTodoListViewController!
    private var viewModel: MonthlyMottoViewModel!
    private var isEditingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MonthlyMottoViewModel(model: HHMonth(year: 2024, month: 9, monthlyComment: nil, toDoList: []))
        
        setupNavigationBar()
        setupScrollView()
        setupSubViewControllers()
        setupToolbar()
        
        DispatchQueue.main.async {
            print("시작 시 스크롤뷰 크기: \(self.scrollView.contentSize)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateScrollViewContentSize()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateScrollViewContentSize()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "\(viewModel.currentMonth.month)월"
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: UIFont.hhLargeTitle,
            .foregroundColor: UIColor.hhBlack
        ]
        
        let yearsButton = createYearsButton()
        let settingButton = createSettingButton()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: yearsButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingButton)
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
    
    @objc private func popMonthlyViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    private func createSettingButton() -> UIButton {
        let topActions = [
            UIAction(title: "목록 편집하기", image: UIImage(systemName: "pencil.and.list.clipboard"), handler: { [weak self] _ in
                self?.enterEditingMode()
            }),
            UIAction(title: "앱 설정하기", image: UIImage(systemName: "gearshape"), handler: { (_) in })
        ]
        let divider = UIMenu(title: "", options: .displayInline, children: topActions)
        
        let bottomAction = UIAction(title: "모든 목표 삭제하기", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { [weak self] _ in
            self?.todoListVC.didTapDeleteAllButton()
        })
        let items = [divider, bottomAction]
        let menu = UIMenu(title: "", children: items)
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        button.tintColor = .hhAccent
        button.showsMenuAsPrimaryAction = true
        button.menu = menu
        return button
    }
    
    private func enterEditingMode() {
        isEditingMode = true
        todoListVC.didTapEditListButton()
        
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
        todoListVC.didTapEditListButton()
        setupNavigationBar()
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupSubViewControllers() {
        mottoVC = MonthlyMottoViewController(viewModel: viewModel)
        mottoVC.delegate = self
        addChild(mottoVC)
        contentView.addSubview(mottoVC.view)
        mottoVC.view.translatesAutoresizingMaskIntoConstraints = false
        mottoVC.didMove(toParent: self)
        
        todoListVC = MonthlyTodoListViewController()
        todoListVC.delegate = self
        addChild(todoListVC)
        contentView.addSubview(todoListVC.view)
        todoListVC.view.translatesAutoresizingMaskIntoConstraints = false
        todoListVC.didMove(toParent: self)
        
        todoListVC.onContentHeightUpdated = { [weak self] updatedHeight in
            if let heightConstraint = self?.todoListVC.view.constraints.first(where: { $0.firstAttribute == .height }) {
                heightConstraint.isActive = false
            }
            let adjustedHeight = updatedHeight + 82
            self?.todoListVC.view.heightAnchor.constraint(equalToConstant: adjustedHeight).isActive = true
            self?.updateScrollViewContentSize()
        }
        
        NSLayoutConstraint.activate([
            mottoVC.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            mottoVC.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mottoVC.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mottoVC.view.heightAnchor.constraint(equalToConstant: 250),
            
            todoListVC.view.topAnchor.constraint(equalTo: mottoVC.view.bottomAnchor, constant: -55),
            todoListVC.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            todoListVC.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            todoListVC.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
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
        todoListVC.didTapAddTodoListButton()
        
        DispatchQueue.main.async {
            self.todoListVC.view.layoutIfNeeded()
            self.updateScrollViewContentSize()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.scrollToBottom()
            }
        }
    }
    
    @objc private func didTapDeleteAllButton() {
        todoListVC.didTapDeleteAllButton()
        
        DispatchQueue.main.async {
            self.todoListVC.view.layoutIfNeeded()
            self.updateScrollViewContentSize()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.scrollToTop()
            }
        }
    }
    
    private func updateScrollViewContentSize() {
        let mottoHeight = mottoVC.view.frame.height
        let todoHeight = todoListVC.view.frame.height
        let totalHeight = mottoHeight + todoHeight + 20
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: totalHeight)
        scrollView.layoutIfNeeded()
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
    
    private func scrollToBottom() {
        let completionLabelHeight = todoListVC.completionLabel.frame.height
        
        let bottomOffset = CGPoint(
            x: 0,
            y: scrollView.contentSize.height - scrollView.bounds.size.height + completionLabelHeight
        )
        
        if bottomOffset.y > 0 {
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    @objc private func endTodoEditing() {
        view.endEditing(true)
        todoListVC.finishEditing()
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
    
    func scrollToTop() {
        let extraOffset: CGFloat = 10
        let topOffset = CGPoint(x: 0, y: -scrollView.adjustedContentInset.top - extraOffset)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.scrollView.setContentOffset(topOffset, animated: false)
        }, completion: nil)
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
