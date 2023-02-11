//
//  ProfileVC.swift
//  BostaTask
//
//  Created by mac on 11/02/2023.
//

import UIKit
import RxSwift
import RxDataSources
class ProfileVC: BaseWireFrame<ProfileVM> {
    @IBOutlet weak var uiUserAddressLbl: UILabel!
    @IBOutlet weak var uiUserNameLbl: UILabel!
    @IBOutlet weak var uiAlbumCollectionView: UITableView!{
        didSet{
            uiAlbumCollectionView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellReuseIdentifier: "AlbumCell")
        }
    }
    var dataSource: RxTableViewSectionedReloadDataSource<CustomCollectionDataSource>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiAlbumCollectionView.rowHeight = 50
        self.uiAlbumCollectionView.sectionHeaderHeight = 50
    }
    
    override func bind(viewModel: ProfileVM) {
        bindHeader()
        bindAlbumDataSource()
    }
    
    private func bindHeader(){
        self.viewModel.firstUserSubject.compactMap(
            {$0?.name}).bind(to: uiUserNameLbl.rx.text)
            .disposed(by: self.disposeBag)
        self.viewModel.firstUserSubject.compactMap(
            {"\($0?.address?.street ?? ""), \($0?.address?.suite ?? ""), \($0?.address?.city ?? ""), \($0?.address?.zipcode ?? "")"})
        .bind(to: uiUserAddressLbl.rx.text)
        .disposed(by: self.disposeBag)
    }
    
    private func bindAlbumDataSource(){
        dataSource = RxTableViewSectionedReloadDataSource<CustomCollectionDataSource>(configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
            cell.uiTitleLbl.text = item.title ?? ""
            return cell
        })
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        self.viewModel.dataSourcSubject.bind(to: uiAlbumCollectionView.rx.items(dataSource: dataSource))
    }
    
    
}

