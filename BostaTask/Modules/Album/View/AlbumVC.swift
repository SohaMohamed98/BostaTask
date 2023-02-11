//
//  AlbumVC.swift
//  BostaTask
//
//  Created by mac on 11/02/2023.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa
import ImageSlideshow
import ImageSlideshowSDWebImage

class AlbumVC: BaseWireFrame<AlbumViewModel> {
    @IBOutlet weak var uiNavigationView: NavigationView!
    var slideshowTransitioningDelegate: ZoomAnimatedTransitioningDelegate? = nil
    @IBOutlet weak var uiPhotoSearchBar: UISearchBar!
    @IBOutlet weak var uiPhotoCollectionView: UICollectionView!{
        didSet{
            uiPhotoCollectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.uiPhotoSearchBar.text = ""
    }
    
    override func bind(viewModel: AlbumViewModel) {
        bindNavigationView()
        bindPhotos()
        setupSearch()
        openPhoto()
    }
    
    private func bindNavigationView(){
        self.uiNavigationView.title = self.viewModel.albumElement.title ?? ""
        self.uiNavigationView.back_Btn.rx.tap.subscribe(onNext:{[weak self] _ in
            guard let self = self else{return}
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
    }
    
    private func bindPhotos(){
        self.uiPhotoCollectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
        self.viewModel.allPhotosSubject.bind(to: uiPhotoCollectionView.rx.items(cellIdentifier: "PhotoCell", cellType: PhotoCell.self)){row, item, cell in
            cell.bindPhoto(photoModel: item)
        }.disposed(by: self.disposeBag)
    }
    
    private func setupSearch(){
        uiPhotoSearchBar.rx.text
            .orEmpty.distinctUntilChanged().bind(to: viewModel.searchWord).disposed(by: self.disposeBag)
        Observable.combineLatest(uiPhotoSearchBar.rx.searchButtonClicked, uiPhotoSearchBar.rx.cancelButtonClicked).subscribe(onNext: {[weak self] _, _ in
            guard let self = self else {return}
            self.view.endEditing(true)
        }).disposed(by: self.disposeBag)
    }
    
    private func openPhoto(){
        Observable.zip(self.uiPhotoCollectionView.rx.itemSelected, self.uiPhotoCollectionView.rx.modelSelected(PhotoElement.self)).subscribe(onNext:{[weak self] index, model in
            guard let self = self else{return}
            let fullScreenController = FullScreenSlideshowViewController()
            fullScreenController.inputs = [SDWebImageSource(url: URL(string: model.url ?? "")!, placeholder: UIImage(named: "TestImageLarge"))]
            fullScreenController.initialPage = index.row
            let cell = self.uiPhotoCollectionView.cellForItem(at: index) as! PhotoCell
            self.slideshowTransitioningDelegate = ZoomAnimatedTransitioningDelegate(imageView: cell.uiPhotoImage, slideshowController: fullScreenController)
            fullScreenController.modalPresentationStyle = .custom
            fullScreenController.transitioningDelegate = self.slideshowTransitioningDelegate
            fullScreenController.slideshow.currentPageChanged = { [weak self] page in
                if  let cell = self?.uiPhotoCollectionView.cellForItem(at: index) as? PhotoCell, let imageView = cell.uiPhotoImage {
                    self?.slideshowTransitioningDelegate?.referenceImageView = imageView
                }
            }
            self.present(fullScreenController, animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
    }
}

extension AlbumVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width-0.5)/3, height: (collectionView.frame.width-20)/2.5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
