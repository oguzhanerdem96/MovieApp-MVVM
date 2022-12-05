//
//  WebService.swift
//  MovieApp-MVVM
//
//  Created by Oğuzhan Erdem on 3.12.2022.
//

import Foundation
import Alamofire

enum MovieTypes: String {
    case nowPlaying = "now_playing"
    case upComing = "upcoming"
}

final class MovieService {
    
    static let shared = MovieService()
    private init(){}
    
    let apiBaseUrl = "https://api.themoviedb.org/3/movie/"
    let languageAndPage = "language=en-US&page=1#"
    let myAPIKey = "0c3c30821942c1012a6fd0366d2aaf13"

    typealias cHandler = ([MovieNowPlayingInfo]? ,String?) -> Void
    typealias cUpComingHandler = ([MovieUpComingInfo]?,String?) -> Void
    typealias detailHandler = (MovieDetailsModel?,String?) -> Void
    
    //MARK: - getMovies with types

    func fetchNowPlayingMovies(movieType: MovieTypes, completion: @escaping cHandler) {
        let endPoint = apiBaseUrl + "\(movieType.rawValue)?api_key=\(myAPIKey)" + languageAndPage
        
        let request = AF.request(endPoint)
        request.validate().responseDecodable(of: MovieNowPlayingModel.self) { response in
            switch response.result {
            case .success(let movieInfos):
                completion(movieInfos.results, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    
    //MARK: - get Now
    func fetchUpComingMovies(movieType: MovieTypes, completion: @escaping cUpComingHandler) {
        let endPoint = apiBaseUrl + "\(movieType.rawValue)?api_key=\(myAPIKey)" + languageAndPage
        
        let request = AF.request(endPoint)
        request.validate().responseDecodable(of: MovieUpComingModel.self) { response in
            switch response.result {
            case .success(let movieInfos):
                completion(movieInfos.results, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }

    
    //MARK: - fetch Movie details
    
    func fetchDetailsMovie(id: Int , completion: @escaping detailHandler) {
        let endPoint = apiBaseUrl + "\(id)?api_key=\(myAPIKey)" + languageAndPage
        let request = AF.request(endPoint)
        request.validate().responseDecodable(of: MovieDetailsModel.self) { response in
            switch response.result {
            case .success(let movieInfos):
                completion(movieInfos, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    
    //MARK: - fetch similar movies
    
    func fetchSimilarMovie(id: Int , completion: @escaping cHandler) {
        let endPoint = apiBaseUrl + "\(id)/similar?api_key=\(myAPIKey)" + languageAndPage
        
        let request = AF.request(endPoint)
        request.validate().responseDecodable(of: MovieNowPlayingModel.self) { response in
            switch response.result {
            case .success(let movieInfos):
                completion(movieInfos.results, nil)
            case . failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
        
    }
    
    //MARK: - Get Search
    
    func getSearch(with query: String, completion: @escaping cUpComingHandler) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let urlString =  "https://api.themoviedb.org/3/search/movie?api_key=\(myAPIKey)&query=\(query)"
        
        let request = AF.request(urlString)
        request.validate().responseDecodable(of: MovieUpComingModel.self) { response in
            switch response.result {
            case .success(let movieInfos):
                completion(movieInfos.results, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}


