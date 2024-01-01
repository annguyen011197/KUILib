//
//  UIViewController+Extensions.swift
//  
//
//  Created by An Nguyen on 24/12/2023.
//

import Foundation
import UIKit
import SnapKit

extension UIViewController {
    public func wrapWithNavigation() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
    public func addVC(_ target: UIViewController, toView: UIView) {
        addChild(target)
        toView.addSubview(target.view)
        target.didMove(toParent: self)
        
        target.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func removeVCFromHost() {
        guard let parent = self.parent else { return }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    @MainActor
    public func transistionVC(_ target: UIViewController, toView: UIView) {
        guard let previousViewController = children.first else {
            return addVC(target, toView: toView)
        }
        
        if previousViewController == target {
            return
        }
        
        addChild(target)
        toView.addSubview(target.view)
        
        target.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        toView.layoutIfNeeded()
        
        UIView.transition(from: previousViewController.view, to: target.view, duration: 0.2, options: [.transitionCrossDissolve]) { _ in
            previousViewController.removeFromParent()
            target.didMove(toParent: self)
        }
    }
}
