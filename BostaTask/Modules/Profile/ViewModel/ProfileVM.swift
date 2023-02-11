//
//  ProfileVM.swift
//  BostaTask
//
//  Created by mac on 11/02/2023.
//

import Foundation
import RxSwift
import RxRelay
import RxDataSources
class ProfileVM:BaseViewModel {
    
    var dataSourcSubject: BehaviorRelay<[CustomCollectionDataSource]> = .init(value: [])
    var firstUserSubject: BehaviorRelay<User?> = .init(value: nil)
    
    override init() {
        super.init()
        self.getAllUsers()
        self.getAllAlbums()
    }
    private func getAllUsers(){
        networkProvider.performRequest(Users.self, router: .getUsers).subscribe { response in
            switch response {
            case let .success(data):
                self.firstUserSubject.accept(data.first)
            case let .failure(error):
                print(error)
                self.showMessageObservable.onNext(("OOps", error.localizedDescription))
            }
        }
    }
    
    
    private func getAllAlbums(){
        networkProvider.performRequest(Albums.self, router: .getAlbums(userId: 1)).subscribe { response in
            switch response {
            case let .success(data):
                self.dataSourcSubject.accept([.init(header: "My Albums", items: data)])
            case let .failure(error):
                print(error)
                self.showMessageObservable.onNext(("OOps", error.localizedDescription))
            }
        }
    }
}
