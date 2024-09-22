//
//  YearsViewController.swift
//  HanHae
//
//  Created by 김성민 on 9/19/24.
//

import UIKit

final class YearsViewController: HHBaseViewController {
    
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
    private let collectionViewCollumsCount: CGFloat = 3
    private let collectionViewInteritemSpacing: CGFloat = 8
    private let collectionViewLineSpacing: CGFloat = 8
    
    private lazy var cellWidth = ((UIScreen.main.bounds.width - (collectionViewSideInset * 2)) - (collectionViewInteritemSpacing * (collectionViewCollumsCount - 1))) / collectionViewCollumsCount
    private lazy var cellHeight = cellWidth
    
    private var isSingleColumn = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
        setupConstraints()
        
        setupCollectionView()
        setupCollectionViewLayout()
        
        setupNavigationBar()
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
        
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(
            MonthlyCell.self,
            forCellWithReuseIdentifier: MonthlyCell.identifier
        )
    }
    
    private func setupCollectionViewLayout() {
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(
            top: 10,
            left: collectionViewSideInset,
            bottom: 30,
            right: collectionViewSideInset
        )
        
        flowLayout.itemSize = CGSize(
            width: cellWidth,
            height: cellHeight
        )
        
        flowLayout.minimumInteritemSpacing = collectionViewInteritemSpacing
        flowLayout.minimumLineSpacing = collectionViewLineSpacing
    }
    
    // TODO: - 효과가 있는지 체크
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupNavigationBarButtons() {
        let changeCollectionViewLayoutBarButton = UIBarButtonItem(customView: changeCollectionViewLayoutButton)
        
        navigationItem.setLeftBarButton(moveThisMonthBarButton, animated: true)
        navigationItem.setRightBarButtonItems(
            [settingBarButton, changeCollectionViewLayoutBarButton],
            animated: true
        )
    }
    
    @objc
    private func moveThisMonthBarButtonTapped() {
        
    }
    
    @objc
    private func changeCollectionViewLayoutButtonTapped() {
        isSingleColumn.toggle()
        
        UIView.animate(withDuration: 0.4) {
            self.changeCollectionViewLayoutButton.tintColor = self.isSingleColumn ? .white : .hhAccent
            self.changeCollectionViewLayoutButton.backgroundColor = self.isSingleColumn ? .hhAccent : .clear
        }
    }
    
    @objc
    private func settingBarButtonTapped() {
        
    }
    
}

extension YearsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthlyCell.identifier, for: indexPath) as! MonthlyCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        return UICollectionReusableView()
    }
}
