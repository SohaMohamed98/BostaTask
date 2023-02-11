//
//  NetworkProvider.swift
//  BostaTask
//
//  Created by mac on 11/02/2023.
//

import Foundation
import Moya
import RxSwift

class NetworkProvider{
    
    var provider = MoyaProvider<UserServices>()
    
    func performRequest<T>(_ object: T.Type, router: UserServices) -> Single<T> where T : Decodable {
        
        return Single.create { (observer) -> Disposable in
            self.provider.request(router) { result in
                switch result {
                case let .success(response):
                    do{
                        print("response: \(response)")
                        let responseModel = try JSONDecoder().decode(T.self, from: response.data)
                        observer(.success(responseModel))
                    }catch let error{
                        observer(.failure(error))
                    }
                    
                case let .failure(error):
                    observer(.failure(error))
                }
            }
            return Disposables.create()
        }
        
    }
    
    
}

