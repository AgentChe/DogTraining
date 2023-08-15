//
//  HomeCommandsGroupsCollectionView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import UIKit

final class HomeCommandsGroupsCollectionView: UICollectionView {
    var didTap: ((CommandGroup) -> Void)?
    
    lazy var elements = [CommandGroup]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension HomeCommandsGroupsCollectionView {
    func setup(elements: [CommandGroup]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension HomeCommandsGroupsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: HomeCommandsGroupsCollectionCell.self), for: indexPath) as! HomeCommandsGroupsCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension HomeCommandsGroupsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        HomeCommandsGroupsCollectionCell.size(for: elements[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let commangGroup = elements[indexPath.row]
        didTap?(commangGroup)
    }
}

// MARK: Private
private extension HomeCommandsGroupsCollectionView {
    func initialize() {
        register(HomeCommandsGroupsCollectionCell.self, forCellWithReuseIdentifier: String(describing: HomeCommandsGroupsCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
