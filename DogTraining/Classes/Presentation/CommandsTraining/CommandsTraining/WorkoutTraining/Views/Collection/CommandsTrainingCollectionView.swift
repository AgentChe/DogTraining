//
//  CommandsTrainingCollectionView.swift
//  Soccer
//
//  Created by Виталий Загороднов on 04.04.2023.
//

import UIKit

final class CommandsTrainingCollectionView: UICollectionView {
    lazy var elements = [Command]()

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CommandsTrainingCollectionView {
    func setup(elements: [Command]) {
        self.elements = elements
        
        reloadData()
    }
    
}
// MARK: UICollectionViewDataSource
extension CommandsTrainingCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: CommandsTrainingImageViewCell.self), for: indexPath) as! CommandsTrainingImageViewCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CommandsTrainingCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 552.scale)
    }
}

// MARK: Private
private extension CommandsTrainingCollectionView {
    func initialize() {
        register(CommandsTrainingImageViewCell.self, forCellWithReuseIdentifier: String(describing: CommandsTrainingImageViewCell.self))
        
        dataSource = self
        delegate = self
        
        isPagingEnabled = true
    }
}
