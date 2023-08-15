//
//  HomeGamesCollectionView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.02.2023.
//

import UIKit

final class HomeGamesCollectionView: UICollectionView {
    var didTap: ((Game) -> Void)?
    
    lazy var elements = [HomeGameElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension HomeGamesCollectionView {
    func setup(elements: [HomeGameElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension HomeGamesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: HomeGamesCollectionCell.self), for: indexPath) as! HomeGamesCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension HomeGamesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 254.scale, height: 330.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = elements[indexPath.row].game
        didTap?(game)
    }
}

// MARK: Private
private extension HomeGamesCollectionView {
    func initialize() {
        register(HomeGamesCollectionCell.self, forCellWithReuseIdentifier: String(describing: HomeGamesCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
