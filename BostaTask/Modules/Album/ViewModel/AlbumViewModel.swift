//
//  AlbumViewModel.swift
//  BostaTask
//
//  Created by mac on 11/02/2023.
//

import Foundation
import RxSwift
import RxRelay
class AlbumViewModel: BaseViewModel {
    var albumElement: AlbumElement
    var allPhotosSubject: BehaviorRelay<Photos> = .init(value: [])
    
    private var allPhotos:Photos!
    private var searchedPhotoElements:Photos!
    var searchWord:BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    private lazy var searchWordObservable:Observable<String> = searchWord.asObservable()
    
    init(album: AlbumElement) {
        self.albumElement = album
        super.init()
        self.getAllPhotos()
        searchedPhotoElements = allPhotos
        self.searchWordObservable.subscribe(onNext: {[weak self] (value) in
            self?.searchedPhotoElements = self?.allPhotos?.filter({ (photo) -> Bool in
                photo.title.lowercased().contains(value.lowercased())
            })
            if(value.isEmpty){
                self?.searchedPhotoElements = self?.allPhotos
            }
            self?.allPhotosSubject.accept(self?.searchedPhotoElements ?? [])
        }).disposed(by: self.disposeBag)
        
        
    }
    private func getAllPhotos(){
        self.isLoading.accept(true)
        networkProvider.performRequest(Photos.self, router: .getPhotos(albumId: albumElement.id ?? 1)).subscribe { response in
            switch response {
            case let .success(data):
                self.isLoading.accept(false)
                self.allPhotosSubject.accept(data)
                self.allPhotos = data
            case let .failure(error):
                self.isLoading.accept(false)
                self.showMessageObservable.onNext(("OOps", error.localizedDescription))
            }
        }
    }
}
