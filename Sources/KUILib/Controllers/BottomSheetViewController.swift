//
//  BottomSheetViewController.swift
//  
//
//  Created by An Nguyen on 31/12/2023.
//

import UIKit

open class BottomSheetViewController: KBaseBottomSheetViewController {
    
    private weak var rootViewController: UIViewController?
    
    public init(rootViewController: UIViewController) {
        super.init(nibName: nil, bundle: nil)
//        self.modalPresentationStyle = .fullScreen
        self.rootViewController = rootViewController
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if let rootViewController = self.rootViewController {
            addVC(rootViewController, toView: self.containerView)
        }
    }
}
