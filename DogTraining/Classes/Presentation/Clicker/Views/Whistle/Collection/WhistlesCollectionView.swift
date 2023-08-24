//
//  WhistlesCollectionView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 23.08.2023.
//

import UIKit

final class WhistlesCollectionView: UICollectionView {
    lazy var elements = [WhistlesCollectionElement]()
    
    var didSelectElement: ((WhistlesCollectionElement) -> Void)?

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WhistlesCollectionView {
    func setup(elements: [WhistlesCollectionElement], isNeedScroll: Bool) {
        self.elements = elements
        
        CATransaction.setCompletionBlock { [weak self] in
            if isNeedScroll, let index = elements.firstIndex(where: { $0.selected }) {
                self?.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: false)
            }
        }
        CATransaction.begin()
        reloadData()
        CATransaction.commit()
    }
}

// MARK: UICollectionViewDelegate
extension WhistlesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        
        let height = collectionView.bounds.height - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom
        return CGSize(width: flowLayout.itemSize.width, height: height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cell = visibleCells.max(by: { lc, rc -> Bool in
            let lcSize = lc.bounds.applying(lc.transform).size
            let rcSize = rc.bounds.applying(rc.transform).size
            
            return (rcSize.width > lcSize.width) && (rcSize.height > lcSize.height)
        })
        guard let cell, let element = elements[safe: indexPath(for: cell)?.row ?? 0] else {
            return
        }
        
        elements.forEach { $0.selected = false }
        element.selected = true

        didSelectElement?(element)

        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension WhistlesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element = elements[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WhistlesCollectionCell.self), for: indexPath) as! WhistlesCollectionCell
        cell.setup(element: element)
        return cell
    }
}

// MARK: Private
private extension WhistlesCollectionView {
    func initialize() {
        register(WhistlesCollectionCell.self, forCellWithReuseIdentifier: String(describing: WhistlesCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
