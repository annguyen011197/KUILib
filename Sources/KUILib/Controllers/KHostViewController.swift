//
//  KHostViewController.swift
//  
//
//  Created by An Nguyen on 24/12/2023.
//

import UIKit

open class KHostViewController: KViewController {
    public lazy var container: UIView = { UIView() }()
    public weak var displayingVC: UIViewController? = nil
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func fillViewController(vc: UIViewController) {
        addVC(vc, toView: container)
        displayingVC = vc
    }
}
