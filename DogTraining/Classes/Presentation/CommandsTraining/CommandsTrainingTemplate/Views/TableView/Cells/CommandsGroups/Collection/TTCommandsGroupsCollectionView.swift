//
//  TTCommandsGroupsCollectionView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import UIKit

final class TTCommandsGroupsCollectionView: UICollectionView {
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
extension TTCommandsGroupsCollectionView {
    func setup(elements: [CommandGroup]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension TTCommandsGroupsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: TTCommandsGroupsCollectionCell.self), for: indexPath) as! TTCommandsGroupsCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension TTCommandsGroupsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        TTCommandsGroupsCollectionCell.size(for: elements[indexPath.row])
    }
}

// MARK: Private
private extension TTCommandsGroupsCollectionView {
    func initialize() {
        register(TTCommandsGroupsCollectionCell.self, forCellWithReuseIdentifier: String(describing: TTCommandsGroupsCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
