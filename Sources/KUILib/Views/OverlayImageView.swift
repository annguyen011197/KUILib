//
//  OverlayImageView.swift
//  
//
//  Created by An Nguyen on 26/12/2023.
//

import UIKit
import SnapKit
open class OverlayImageView: UIView {
    lazy var imageView: UIImageView = UIImageView()
    lazy var overlayView: UIView = UIView()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        configUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configUI()
    }
    
    public func setImage(_ image: UIImage?) {
        imageView.image = image
    }
    
    public func setOverlayColor(_ color: UIColor) {
        overlayView.layer.backgroundColor = color.cgColor
        overlayView.layer.compositingFilter = "overlayBlendMode"
    }
    
    private func configUI() {
        self.backgroundColor = .white
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(overlayView)
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
