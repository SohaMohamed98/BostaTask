//
//  BaseWireFrame.swift
//  Maqraa
//
//  Created by Mohamed Mahmoud on 08/08/2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
class BaseWireFrame<T: BaseViewModel>: UIViewController,UIGestureRecognizerDelegate{
    var viewModel: T!
    lazy var disposeBag: DisposeBag = {
        return DisposeBag()
    }()
    
    private lazy var indicator:UIActivityIndicatorView = {
        var activityView = UIActivityIndicatorView(style: .large)
        return activityView
    }()
    
    init(viewModel: T, customNibName:String? = nil) {
        self.viewModel = viewModel
        guard let nibName = customNibName else{
            super.init(nibName: String(describing: type(of: self)), bundle: nil)
            return
        }
        super.init(nibName: nibName, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        bind(viewModel: viewModel)
        self.baseBind()
        
    }
    
    func bind(viewModel: T){
        fatalError("Please override bind function")
    }
    func baseBind(){
        
        viewModel.showMessageObservable.subscribe {[weak self] (title, message) in
            guard let self = self else {return}
            self.showMessage(title: title, message: message, observable: nil)
        }.disposed(by: self.disposeBag)
        
        viewModel.isLoading.subscribe(onNext:{[weak self] isShow in
            guard let self = self else{return}
            isShow ? self.showActivityIndicatory() : self.removeActivity()
        }).disposed(by: self.disposeBag)
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func showMessage(title: String?, message: String, observable: PublishSubject<Void>?){
        let messageAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        messageAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(messageAlert, animated: true, completion: nil)
    }
    func showActivityIndicatory() {
        if #available(iOS 13.0, *) {
            indicator = UIActivityIndicatorView(style: .large)
        } else {
            indicator = UIActivityIndicatorView(style: .gray)
        }
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.startAnimating()
    }
    func removeActivity(){
        indicator.stopAnimating()
        indicator.removeFromSuperview()
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
