//
//  KBaseBottomSheetViewController.swift
//  
//
//  Created by An Nguyen on 31/12/2023.
//

import UIKit
import SnapKit

public struct BottomSheetAttributte {
    public var defaultHeight: CGFloat = 372
    public var dimmedAlpha: CGFloat = 0.0
    public var roudingCorners: CGFloat = 34
    public var backgroundColor: UIColor = .white
    public var durationShow: TimeInterval = 0.3
    public var durationHide: TimeInterval = 0.2
}

open class KBaseBottomSheetViewController: KViewController  {
    private var defaultHeight: CGFloat {
        return attribute.defaultHeight
    }
    private var dismissibleHeight: CGFloat {
        return defaultHeight * 0.8
    }
    private var currentContainerHeight: CGFloat = 0
    private let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    internal var attribute: BottomSheetAttributte = BottomSheetAttributte()
    internal var shouldAnimate: Bool = false
    
    let containerView: UIView = {
        let view  = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.0
        return view
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        attribute = updateAttribute(currentAttr: attribute)
        setupViews()
        setupContrainst()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        containerView.roundCorners(roudingCorners: [.topLeft, .topRight], radius: attribute.roudingCorners)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentContainerHeight = defaultHeight
    }
    
    func updateAttribute(currentAttr: BottomSheetAttributte) -> BottomSheetAttributte {
        return currentAttr
    }
    
    func setupViews() {
        view.backgroundColor = .clear
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        dimmedView.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesBegan = false
        view.addGestureRecognizer(panGesture)
    }
    
    func setupContrainst() {
        dimmedView.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.top).offset(-100)
            make.bottom.equalTo(bottomLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(defaultHeight)
            $0.bottom.equalTo(defaultHeight)
        }
    }
    
    @objc
    func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        // drag to top will be minus value and vice versa
        print("Pan gesture y offset: \(translation.y)")
        
        // get drag direction
        let isDraggingDown = translation.y > 0
        print("Dragging direction: \(isDraggingDown ? "going down" : "going up")")
        
        // New height is based on value of dragging plus current container height
        let newHeight = currentContainerHeight - translation.y
        
        // Handle based on gesture state
        switch gesture.state {
        case .changed:
            if newHeight < defaultHeight {
                containerView.snp.updateConstraints { (make) in
//                    make.height.equalTo(newHeight)
                    make.bottom.equalTo(translation.y)
                }
                // refresh layout
                view.layoutIfNeeded()
            }
        case .ended:
            // This happens when user stop drag,
            // so we will get the last height of container
            // Condition 1: If new height is below min, dismiss controller
            
//            let velocity = (0.2 * gesture.velocity(in: self.view).y)
//            let animationDuration = TimeInterval(abs(velocity*0.0002) + 0.2)
            
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            }
            else if newHeight < defaultHeight {
                // Condition 2: If new height is below default, animate back to default
                animateContainerHeight(defaultHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                // Condition 3: If new height is below max and going down, set to default height
//                animateContainerHeight(defaultHeight, duration: animationDuration)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                // Condition 4: If new height is below max and going up, set to max height at top
//                animateContainerHeight(maximumContainerHeight, duration: animationDuration)
            }
        default:
            break
        }
    }
    
    @objc
    func handleTapGesture() {
        animateDismissView()
    }
    
    //- MARK: animate
    func animateDismissView(completion: (() -> Void)? = nil) {
        // hide main container view by updating bottom constraint in animation block
        UIView.animate(withDuration: attribute.durationHide) {
            self.containerView.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.defaultHeight)
            }
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        
        // hide blur view
        dimmedView.alpha = attribute.dimmedAlpha
        UIView.animate(withDuration: attribute.durationHide) {
            self.dimmedView.alpha = 0
        } completion: { [weak self] _ in
            // once done, dismiss without animation
        }
        
        self.dismiss(animated: self.shouldAnimate) {
            completion?()
        }
    }
    
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: attribute.durationHide) {
            self.containerView.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.defaultHeight)
            }
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
            
            // hide blur view
            self.dimmedView.alpha = self.attribute.dimmedAlpha
            UIView.animate(withDuration: self.attribute.durationHide) {
                self.dimmedView.alpha = 0
            } completion: { [weak self] _ in
                // once done, dismiss without animation
            }
            
            super.dismiss(animated: true)
        }
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: attribute.durationHide) {
            // Update container height
            self.containerView.snp.updateConstraints { (make) in
                make.height.equalTo(height)
                make.bottom.equalToSuperview()
            }
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // Save current height
        currentContainerHeight = height
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        animateContainerHeight(defaultHeight)
//    }
    
    private func animatePresentContainer() {
        // Update bottom constraint in animation block
        UIView.animate(withDuration: attribute.durationShow) {
            self.containerView.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview()
            }
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: attribute.durationShow) {
            self.dimmedView.alpha = self.attribute.dimmedAlpha
        }
    }
}
