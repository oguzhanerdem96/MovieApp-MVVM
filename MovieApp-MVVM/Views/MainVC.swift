//
//  MainVC.swift
//  MovieApp-MVVM
//
//  Created by Oğuzhan Erdem on 4.12.2022.
//

import UIKit

class MainVC: UIViewController {

    // General CollectionView
    private let generalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .systemBackground
       
        
        //register cells
        cv.register(HomeTopCell.self,
                    forCellWithReuseIdentifier: HomeTopCell.identifier)
       // cv.register(HomeBottomListCell.self,
         //           forCellWithReuseIdentifier: HomeBottomListCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setGeneralCollectionViewConstraints()
       
    }
    


}

extension MainVC {
    
    private func setGeneralCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            generalCollectionView.topAnchor.constraint(equalTo:view.topAnchor),
            generalCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            generalCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            generalCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           
        ])
    }
    
    
}
