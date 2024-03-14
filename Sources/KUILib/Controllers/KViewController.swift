//
//  KViewController.swift
//  
//
//  Created by An Nguyen on 24/12/2023.
//

import UIKit

open class KViewController: UIViewController {


    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}

public extension UIViewController {
    var selfNavigationBar: UINavigationBar? {
        self.navigationController?.navigationBar
    }
    
    var selfTopItemNavigation: UINavigationItem? {
        self.selfNavigationBar?.topItem
    }
}

open class KBindingViewController<T: UIViewController&NibInstantiatable>: KViewController {
    
    public lazy var binding: T = T.instantiate()
    
    open override func loadView() {
        view = UIView()
        addVC(binding, toView: view)
    }
}
