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
    
    // CollectionView layout 관련 상수
    private let collectionViewSideInset: CGFloat = 16
    private let collectionViewCollumsCount: CGFloat = 3
    private let collectionViewInteritemSpacing: CGFloat = 8
    private let collectionViewLineSpacing: CGFloat = 8
    
    private lazy var cellWidth = ((UIScreen.main.bounds.width - (collectionViewSideInset * 2)) - (collectionViewInteritemSpacing * (collectionViewCollumsCount - 1))) / collectionViewCollumsCount
    private lazy var cellHeight = cellWidth

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
        setupConstraints()
        
        setupCollectionView()
        setupCollectionViewLayout()
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
