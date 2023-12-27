//
//  NibInstantiatable.swift
//  
//
//  Created by An Nguyen on 24/12/2023.
//

import Foundation
import UIKit

public protocol NibInstantiatable {
    static var NibName: String { get }
}

extension NibInstantiatable where Self: UIViewController {

    static var NibName: String { return String(describing: self) }

    public static func instantiate() -> Self {
        return Self(nibName: NibName, bundle: nil)
    }

}
