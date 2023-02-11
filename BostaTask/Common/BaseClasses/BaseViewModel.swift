//
//  BaseViewModel.swift
//  Maqraa
//
//  Created by Mohamed Mahmoud on 08/08/2022.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel: NSObject{
    
    let networkProvider:NetworkProvider = NetworkProvider()
    var refreshData: BehaviorRelay<Void> = .init(value: ())
    var disposeBag = DisposeBag()
    var isLoading: BehaviorRelay<Bool> = .init(value: false)
    lazy var showMessageObservable: PublishSubject<(String?, String)> = .init()
}
