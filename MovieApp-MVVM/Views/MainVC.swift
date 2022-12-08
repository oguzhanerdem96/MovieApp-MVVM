//
//  MainVC.swift
//  MovieApp-MVVM
//
//  Created by Oğuzhan Erdem on 4.12.2022.
//

import UIKit


protocol MovieOutPutProtocol {
    func changeLoading(isLoad: Bool)
    func saveMovieNowPlayingDatas(listValues: [MovieNowPlayingInfo])
    func saveMovieUpComingPlayingDatas(listValues: [MovieUpComingInfo])
}

class MainVC: UIViewController {

    private lazy var homeMovieNowPlayingList: [MovieNowPlayingInfo] = []
    private lazy var homeMovieUpComingList: [MovieUpComingInfo] = []
    lazy var viewModel = HomeViewModel()
    private let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var searchMode = false
    var filteredList = [MovieNowPlayingInfo]()
    
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
        cv.register(HomeBottomListCell.self,
                    forCellWithReuseIdentifier: HomeBottomListCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    
    private let searchController: UISearchController = {
         let controller = UISearchController(searchResultsController: SearchCompositionalResultsVC())
         controller.searchBar.placeholder = "Searching.."
         controller.searchBar.searchBarStyle = .minimal
         return controller
     }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        //viewModel delegate
        viewModel.setDelegate(output: self)
        viewModel.fetchNowPlayingItems()
        viewModel.fetchUpcomingItems()
      
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
   
    
    func setupViews() {
        view.addSubview(generalCollectionView)
        view.addSubview(indicator)
        setGeneralCollectionViewConstraints()
        
        
        if #available(iOS 13.0, *) {
           let navBarAppearance = UINavigationBarAppearance()
           //navBarAppearance.configureWithOpaqueBackground()

           navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemYellow,NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 32.0)!]
           navBarAppearance.backgroundColor = .black
           navigationController?.navigationBar.barStyle = .black
           navigationController?.navigationBar.standardAppearance = navBarAppearance
           navigationController?.navigationBar.compactAppearance = navBarAppearance
           navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

           navigationController?.navigationBar.prefersLargeTitles = false
           navigationItem.title = "Oguzhan Cinema®"

           }
        generalCollectionView.delegate = self
        generalCollectionView.dataSource = self
        
        indicator.startAnimating()
        //configureSearchBarButton()
     
    }


}
//MARK: - MovieOutPutProtocol
extension MainVC: MovieOutPutProtocol {
    
    func changeLoading(isLoad: Bool) {
        isLoad ? indicator.startAnimating() : indicator.stopAnimating()
    }
    
    // now_playing
    func saveMovieNowPlayingDatas(listValues: [MovieNowPlayingInfo]) {
        self.homeMovieNowPlayingList = listValues
        generalCollectionView.reloadData()
    }
    
    // upcoming
    func saveMovieUpComingPlayingDatas(listValues: [MovieUpComingInfo]) {
        self.homeMovieUpComingList = listValues
        generalCollectionView.reloadData()
    }
    
    
}

//MARK: -  Constraints
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

//MARK: - Delegate, DataSource
extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    // numberOfItemsInSection ( how many cells )
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        
        return searchMode ? filteredList.count :   self.homeMovieNowPlayingList.count
    }
    
    
    // cellForItemAt
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Top
        if indexPath.section == 0 {
            
            let topCell = generalCollectionView.dequeueReusableCell(withReuseIdentifier: HomeTopCell.identifier, for: indexPath) as! HomeTopCell
            
            topCell.setX(model: homeMovieUpComingList)
            topCell.topcellDelegate = self
            return topCell
        }
        
        // bottom
        let bottomListCell = generalCollectionView.dequeueReusableCell(withReuseIdentifier: HomeBottomListCell.identifier, for: indexPath) as! HomeBottomListCell
           
      
        bottomListCell.backgroundColor = .black
      
        bottomListCell.layer.shadowColor = UIColor.white.cgColor
        bottomListCell.layer.shadowPath = UIBezierPath(rect: bottomListCell.bounds).cgPath
        bottomListCell.layer.shadowRadius = 3
        bottomListCell.layer.shadowOffset = .zero
        bottomListCell.layer.shadowOpacity = 0.6
        
        searchMode ?   bottomListCell.saveModel(model: filteredList[indexPath.item])  :
        bottomListCell.saveModel(model: homeMovieNowPlayingList[indexPath.item])
       
        
        return bottomListCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 1 {
            return 8
        }
        return 0
    }
     
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
       
        if indexPath.section == 0 {
            print("clicked")
        }
        
        print("gelenid", homeMovieNowPlayingList[indexPath.item].id)
        let movieDetailVC = MovieDetailVC()
        movieDetailVC.myId =  homeMovieNowPlayingList[indexPath.item].id
        navigationController?.pushViewController(movieDetailVC, animated: false)
    }
     
}

//MARK: - DelegateFlowLayout
extension MainVC: UICollectionViewDelegateFlowLayout {
    
    
    // sizeForItemAt, cell -> w,h
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // topCell
        if indexPath.section == 0 {
            return CGSize(width: generalCollectionView.frame.width,
                          height: 350)
        }
        
        // bottomListcell
        return CGSize(width: generalCollectionView.frame.width,
                      height: generalCollectionView.frame.width - 280)
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return  .zero
        }
        
        return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
}

//MARK: - HomeTopCell'den -> Buraya veri gönderimi, delegate Design Pattern
extension MainVC: HomeTopCellProtocol {
    func didPressCell(sendId: Int) {
        print("IDGELDİ", sendId)
        let movieDetailvc = MovieDetailVC()
        movieDetailvc.myId = sendId
        self.navigationController?.pushViewController(movieDetailvc, animated: false)
    }
    
    
}
extension MainVC : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        //print("mytext",searchBar.text)
        
        guard let query = searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty,
                query.trimmingCharacters(in: .whitespaces).count >= 3,
                          
                var resultController = searchController.searchResultsController as? SearchCompositionalResultsVC else {  return}
        
      
       
        MovieService.shared.getSearch(with: query ) { [weak self] (res,error) in
            DispatchQueue.main.async {
                resultController.configure(model: res ?? [])
                resultController.searchResultsCollectionView.reloadData()
                        
            }
        }
       
    }
    
   
}

