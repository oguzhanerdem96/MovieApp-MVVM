//
//  SearchViewModel.swift
//  MovieApp-MVVM
//
//  Created by Oğuzhan Erdem on 6.12.2022.
//

import Foundation

protocol SearchViewModelProtocol {
    func setSearchDelegate(output: SearchMovieOutPutProtocol)
    var searchOutPut: SearchMovieOutPutProtocol? { get }
}


final class SearchViewModel: SearchViewModelProtocol {
    var searchOutPut: SearchMovieOutPutProtocol?
    var movieWebService: MovieService
    var resultCont: SearchCompositionalResultsVC?
    
    
    init(){
        movieWebService = MovieService()
    }
    
    
    func setSearchDelegate(output: SearchMovieOutPutProtocol) {
        searchOutPut = output
    }
    }
