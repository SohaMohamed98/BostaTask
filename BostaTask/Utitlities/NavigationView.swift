//
//  NavigationView.swift
//  BostaTask
//
//  Created by mac on 11/02/2023.
//

import UIKit

@IBDesignable
class NavigationView: UIView {
    
   
    
    @IBInspectable
    var title: String = ""{
        didSet{
            self.title_lbl.text = self.title
        }
    }
    
    @IBInspectable
    var barColor: UIColor = .white{
        didSet{
            self.title_lbl.textColor = self.barColor
            self.back_Btn.tintColor = self.barColor
        }
    }
    
    @IBInspectable
    var isBackButtonEnabled: Bool = true{
        didSet{
            self.back_Btn.isHidden = !isBackButtonEnabled
        }
    }
    
     lazy var title_lbl: UILabel = {
        let lable = UILabel()
         lable.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "Helvetica-Bold", size: 26)!)
        lable.textAlignment = .left
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    lazy var back_Btn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        button.tintColor = .white
        button.setTitle(nil, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initalize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initalize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupViews()
    }

    private func initalize(){
        self.backgroundColor = .white
    }
    
    private func setupViews(){
        self.addSubviews(self.back_Btn,
                         self.title_lbl)
        
        NSLayoutConstraint.activate([
            self.back_Btn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            self.back_Btn.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.back_Btn.heightAnchor.constraint(equalToConstant: 50),
            self.back_Btn.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            self.title_lbl.leadingAnchor.constraint(equalTo: self.back_Btn.trailingAnchor, constant: -30),
            self.title_lbl.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.title_lbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
        ])
    }
}
