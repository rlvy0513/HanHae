//
//  YearsViewController.swift
//  HanHae
//
//  Created by 김성민 on 9/19/24.
//

import UIKit

final class YearsViewController: HHBaseViewController {
    
    private let viewModel = YearsViewModel()
    
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: flowLayout
    )
    
    private lazy var moveThisMonthBarButton: UIBarButtonItem = {
        let barBtn = UIBarButtonItem(
            title: "이번 달",
            style: .plain,
            target: self,
            action: #selector(moveThisMonthBarButtonTapped)
        )
        barBtn.tintColor = .hhAccent
        barBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.hhBody], for: .normal)
        barBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.hhBody], for: .highlighted)
        return barBtn
    }()
    
    private lazy var changeCollectionViewLayoutButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "rectangle.grid.1x2"), for: .normal)
        btn.tintColor = .hhAccent
        btn.addTarget(self, action: #selector(changeCollectionViewLayoutButtonTapped), for: .touchUpInside)
        btn.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    private lazy var settingBarButton: UIBarButtonItem = {
        let barBtn = UIBarButtonItem(
            image: UIImage(systemName: "gearshape"),
            style: .plain,
            target: self,
            action: #selector(settingBarButtonTapped)
        )
        barBtn.tintColor = .hhAccent
        return barBtn
    }()
    
    // CollectionView layout 관련 상수
    private let collectionViewSideInset: CGFloat = 16
    private var collectionViewCollumsCount: CGFloat = 3
    private let collectionViewInteritemSpacing: CGFloat = 8
    private let collectionViewLineSpacing: CGFloat = 8
    private lazy var collectionViewEdgeInsets = UIEdgeInsets(
        top: 5,
        left: collectionViewSideInset,
        bottom: 30,
        right: collectionViewSideInset
    )
    
    private lazy var cellWidth = ((UIScreen.main.bounds.width - (collectionViewSideInset * 2)) - (collectionViewInteritemSpacing * (collectionViewCollumsCount - 1))) / collectionViewCollumsCount
    private lazy var cellHeight = cellWidth
    
    private var isSingleColumn = false
    
    private var currentSection = 0
    private var yearTitle: String {
        "\(currentSection + 2020)년"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
        setupConstraints()
        
        setupCollectionView()
        setupCollectionViewLayout()
        
        setupNavigationBarTitle()
        setupNavigationBarButtons()
    }
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(
            MonthlyCell.self,
            forCellWithReuseIdentifier: MonthlyCell.identifier
        )
        collectionView.register(
            YearHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: YearHeaderView.identifier
        )
    }
    
    private func setupCollectionViewLayout() {
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = collectionViewEdgeInsets
        
        flowLayout.itemSize = CGSize(
            width: cellWidth,
            height: cellHeight
        )
        
        flowLayout.minimumInteritemSpacing = collectionViewInteritemSpacing
        flowLayout.minimumLineSpacing = collectionViewLineSpacing
    }
    
    private func setupNavigationBarTitle() {
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: FontName.eliceDigitalBaeumBold.rawValue, size: 17)!
        ]
    }
    
    private func setupNavigationBarButtons() {
        let leftButton = moveThisMonthBarButton
        let rightButtons = [settingBarButton, UIBarButtonItem(customView: changeCollectionViewLayoutButton)]
        
        navigationItem.setLeftBarButton(leftButton, animated: true)
        navigationItem.setRightBarButtonItems(rightButtons, animated: true)
    }
    
    @objc
    private func moveThisMonthBarButtonTapped() {
        let targetSection = Date.todayYear - 2020
        let targetRow = Date.todayMonth - 1
        
        // 현재 보이는 IndexPaths에 목표하는 연도와 월이 있는지 확인
        let isAlreadyVisible = collectionView.indexPathsForVisibleItems.contains { indexPath in
            indexPath.section == targetSection && indexPath.row == targetRow
        }
        
        if isAlreadyVisible {
            // TODO: - MonthlyTDLView로 이동하는 로직 구현하기
            print("MonntlyTDLView로 이동")
            return
        } else {
            scrollCollectionView(atYear: Date.todayYear, atMonth: Date.todayMonth)
        }
    }
    
    @objc
    private func changeCollectionViewLayoutButtonTapped() {
        isSingleColumn.toggle()
        
        UIView.animate(withDuration: 0.4) {
            self.changeCollectionViewLayoutButton.tintColor = self.isSingleColumn ? .white : .hhAccent
            self.changeCollectionViewLayoutButton.backgroundColor = self.isSingleColumn ? .hhAccent : .clear
        }
        
        changeCollectionViewLayout()
        
        // 현재 보여지고 있는 Cell의 Layout도 변경해주는 코드
        for indexPath in collectionView.indexPathsForVisibleItems {
            let cell = collectionView.cellForItem(at: indexPath) as! MonthlyCell
            
            cell.changeMonthlyCellLayout(isSingleColumn: isSingleColumn)
        }
    }
    
    @objc
    private func settingBarButtonTapped() {
        
    }
    
    private func changeCollectionViewLayout() {
        let newFlowLayout = UICollectionViewFlowLayout()
        newFlowLayout.minimumInteritemSpacing = collectionViewInteritemSpacing
        newFlowLayout.sectionInset = collectionViewEdgeInsets
        
        if isSingleColumn {
            collectionViewCollumsCount = 1
            newFlowLayout.minimumLineSpacing = 14
            
            title = yearTitle
        } else {
            collectionViewCollumsCount = 3
            newFlowLayout.minimumLineSpacing = collectionViewLineSpacing
            
            title = nil
        }
        
        UIView.animate(withDuration: 0.4) {
            self.collectionView.setCollectionViewLayout(newFlowLayout, animated: true)
        }
        
        updateNavigationBarTitle()
    }
    
    private func scrollCollectionView(atYear: Int, atMonth: Int) {
        let indexPath = viewModel.getScrollIndexPath(atYear: atYear, atMonth: atMonth)
        
        if isSingleColumn {
            if let attributes = collectionView.layoutAttributesForItem(at: indexPath) {
                var cellFrame = attributes.frame
                cellFrame.size.height = view.safeAreaLayoutGuide.layoutFrame.height
                cellFrame.origin.y -= 14
                
                collectionView.scrollRectToVisible(cellFrame, animated: true)
            }
        } else {
            let headerIndexPath = IndexPath(item: 0, section: indexPath.section)
            
            if let layoutAttributes = collectionView.layoutAttributesForSupplementaryElement(
                ofKind: UICollectionView.elementKindSectionHeader,
                at: headerIndexPath
            ) {
                var headerFrame = layoutAttributes.frame
                headerFrame.size.height = view.safeAreaLayoutGuide.layoutFrame.height
                
                collectionView.scrollRectToVisible(headerFrame, animated: true)
            }
        }
    }
    
    private func updateNavigationBarTitle() {
        let centerPoint = CGPoint(
            x: collectionView.bounds.midX,
            y: collectionView.bounds.midY
        )
        
        if let centerIndexPath = collectionView.indexPathForItem(at: centerPoint) {
            let newSection = centerIndexPath.section
            
            if newSection != currentSection {
                currentSection = newSection
                
                generateHapticFeedback()
                
                if isSingleColumn {
                    title = yearTitle
                }
            }
        }
    }
    
    private func generateHapticFeedback() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light, view: view)
        feedbackGenerator.impactOccurred()
    }
    
}


extension YearsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let calculatedWidth = ((UIScreen.main.bounds.width - (collectionViewSideInset * 2)) - (collectionViewInteritemSpacing * (collectionViewCollumsCount - 1))) / collectionViewCollumsCount
        
        if isSingleColumn {
            let toDoList = viewModel.getMonthlyTDL(
                yearIndex: indexPath.section,
                monthIndex: indexPath.row
            )
            let estimatedHeight = calculateHeightForToDoList(toDoList: toDoList)
            
            return CGSize(
                width: calculatedWidth,
                height: estimatedHeight
            )
        } else {
            return CGSize(
                width: calculatedWidth,
                height: cellWidth
            )
        }
    }
    
    private func calculateHeightForToDoList(toDoList: [ToDo]) -> CGFloat {
        if toDoList.isEmpty {
            return 72
        } else {
            let totalHeight = toDoList.reduce(39) { (currentHeight, toDo) -> CGFloat in
                let toDoHeight = calculateHeightForText(toDo.title)
                return currentHeight + toDoHeight + 8
            }
            
            return totalHeight
        }
    }
    
    private func calculateHeightForText(_ text: String) -> CGFloat {
        let maxWidth = (UIScreen.main.bounds.width - (collectionViewSideInset * 2)) - 24 - 8 - 20
        let boundingRect = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.hhBody]
        
        let height = text.boundingRect(
            with: boundingRect,
            options: [.usesLineFragmentOrigin],
            attributes: attributes,
            context: nil
        ).height
        
        return ceil(height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateNavigationBarTitle()
    }
    
}


extension YearsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.getYearsCount()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 12
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthlyCell.identifier, for: indexPath) as! MonthlyCell
        
        cell.changeMonthlyCellLayout(isSingleColumn: isSingleColumn)
        cell.viewModel = viewModel.makeMonthlyTDLViewModelAt(
            yearIndex: indexPath.section,
            monthIndex: indexPath.row
        )
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: YearHeaderView.identifier,
            for: indexPath
        ) as! YearHeaderView
        headerView.yearLabel.text = viewModel.getYearLabelText(index: indexPath.section)
        headerView.yearLabel.textColor = viewModel.getYearLabelColor(index: indexPath.section)
        
        return headerView
    }
}
