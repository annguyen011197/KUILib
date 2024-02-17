//
//  File.swift
//  
//
//  Created by An Nguyen on 28/01/2024.
//

import Foundation
import UIKit

class ClosureAction<T: NSObject> {
    let closure: (T) -> ()
    weak var target: T?
    
    init(target: T, _ closure: @escaping (T) -> ()) {
        self.target = target
        self.closure = closure
    }
    
    @objc func invoke() {
        guard let target = self.target else {
            return
        }
        
        closure(target)
    }
}

public extension UIControl {
    
    func addAction<T: NSObject>(
        target: T,
        for controlEvents: UIControl.Event = .touchUpInside,
        _ closure: @escaping (T)->()
    ) {
        let clousreAction = ClosureAction(target: target, closure)
        addTarget(clousreAction, action: #selector(ClosureAction.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "\(UUID())", clousreAction, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    public func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        @objc class ClosureSleeve: NSObject {
            let closure:()->()
            init(_ closure: @escaping()->()) { self.closure = closure }
            @objc func invoke() { closure() }
        }
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}


public extension UIView {
    public func addTapAction(closure: @escaping()->()) {
        @objc class ClosureSleeve: NSObject {
            let closure:()->()
            init(_ closure: @escaping()->()) { self.closure = closure }
            @objc func invoke() { closure() }
        }
        let sleeve = ClosureSleeve(closure)
        let tap = UITapGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
        objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
