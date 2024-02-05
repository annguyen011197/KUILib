//
//  File.swift
//  
//
//  Created by An Nguyen on 02/02/2024.
//

import Foundation
import UIKit
//@IBDesignable
open class SSSegmentedControl: UIView {
    
    //MARK: - Properties
    open var stackView: UIStackView = UIStackView()
    open var buttonsCollection: [UIButton] = []
    open var currentIndexView: UIView = UIView(frame: .zero)
    
    open var buttonPadding: CGFloat = 5
    open var stackViewSpacing: CGFloat = 0
    open var selectedGradientColor: GradientBackground? = nil
    //MARK: - Callback
    open var didTapSegment: ((Int) -> ())?
    
    //MARK: - Inspectable Properties
    @IBInspectable open var currentIndex: Int = 0 {
        didSet {
            setCurrentIndex()
        }
    }
    
    @IBInspectable open var currentIndexTitleColor: UIColor = .white {
        didSet {
            updateTextColors()
        }
    }
    
    @IBInspectable open var currentIndexBackgroundColor: UIColor = .systemTeal {
        didSet {
            setCurrentViewBackgroundColor()
        }
    }
    
    @IBInspectable open var otherIndexTitleColor: UIColor = .gray {
        didSet {
            updateTextColors()
        }
    }
    
    @IBInspectable open var cornerRadius: CGFloat = 15 {
        didSet {
            setCornerRadius()
        }
    }
    
    @IBInspectable open var buttonCornerRadius: CGFloat = 10 {
        didSet {
            setButtonCornerRadius()
        }
    }
    
    @IBInspectable open var borderColor: UIColor = .systemTeal {
        didSet {
            setBorderColor()
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = 1 {
        didSet {
            setBorderWidth()
        }
    }
    
    @IBInspectable open var numberOfSegments: Int = 2 {
        didSet {
            addSegments()
        }
    }
    
    @IBInspectable open var segmentsTitle: String = "Segment 1,Segment 2" {
        didSet {
            updateSegmentTitles()
        }
    }
    
    //MARK: - Life cycle
    public init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    public override init(frame: CGRect) { //From code
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder: NSCoder) { //From IB
        super.init(coder: coder)
        
        commonInit()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        setCurrentIndex(animated: false)
    }
    
    //MARK: - Functions
    private func commonInit() {
        backgroundColor = .clear
        
        setupStackView()
        addSegments()
        setCurrentIndexView()
        setCurrentIndex(animated: false)
        
        setCornerRadius()
        setButtonCornerRadius()
        setBorderColor()
        setBorderWidth()
    }
    
    private func setCurrentIndexView() {
        setCurrentViewBackgroundColor()
        
        addSubview(currentIndexView)
        sendSubviewToBack(currentIndexView)
    }
    
    private func setCurrentIndex(animated: Bool = true) {
        var lastFrame = self.currentIndexView.frame
        stackView.subviews.enumerated().forEach { (index, view) in
            let button: UIButton? = view as? UIButton
            
            if index == currentIndex {
                let buttonWidth = (frame.width - (buttonPadding * 2)) / CGFloat(numberOfSegments)
                
                if animated {
                    UIView.animate(withDuration: 0.3) {
                        self.currentIndexView.frame =
                            CGRect(x: self.buttonPadding + (buttonWidth * CGFloat(index)),
                               y: self.buttonPadding,
                               width: buttonWidth,
                               height: self.frame.height - (self.buttonPadding * 2))
                    }
                } else {
                    self.currentIndexView.frame =
                        CGRect(x: self.buttonPadding + (buttonWidth * CGFloat(index)),
                           y: self.buttonPadding,
                           width: buttonWidth,
                           height: self.frame.height - (self.buttonPadding * 2))
                }
                
                button?.setTitleColor(currentIndexTitleColor, for: .normal)
            } else {
                button?.setTitleColor(otherIndexTitleColor, for: .normal)
            }
        }
        
        if 
            let selectedGradientColor = self.selectedGradientColor,
            lastFrame != self.currentIndexView.frame
        {
            currentIndexView.backgroundColor = .clear
            currentIndexView.makeGradient(value: selectedGradientColor).do {
                $0.cornerRadius = cornerRadius
            }
        }
    }
    
    private func updateTextColors() {
        stackView.subviews.enumerated().forEach { (index, view) in
            let button: UIButton? = view as? UIButton
            
            if index == currentIndex {
                button?.setTitleColor(currentIndexTitleColor, for: .normal)
            } else {
                button?.setTitleColor(otherIndexTitleColor, for: .normal)
            }
        }
    }
    
    private func setCurrentViewBackgroundColor() {
        currentIndexView.backgroundColor = currentIndexBackgroundColor
    }
    
    private func setupStackView() {
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = stackViewSpacing
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: buttonPadding),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -buttonPadding),
                stackView.topAnchor.constraint(equalTo: topAnchor, constant: buttonPadding),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -buttonPadding)
            ]
        )
    }
    
    private func addSegments() {
        //Remove buttons
        buttonsCollection.removeAll()
        stackView.subviews.forEach { view in
            (view as? UIButton)?.removeFromSuperview()
        }

        let titles = segmentsTitle.split(separator: ",")
        
        for index in 0 ..< numberOfSegments {
            let button = UIButton()
            button.tag = index
            
            if let index = titles.indices.contains(index) ? index : nil {
                button.setTitle(String(titles[index]), for: .normal)
            } else {
                button.setTitle("<Segment>", for: .normal)
            }
            
            button.titleLabel?.font = .systemFont(ofSize: 16)
            button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
            
            stackView.addArrangedSubview(button)
            buttonsCollection.append(button)
        }
    }
    
    private func updateSegmentTitles() {
        let titles = segmentsTitle.split(separator: ",")
        
        stackView.subviews.enumerated().forEach { (index, view) in
            if let index = titles.indices.contains(index) ? index : nil {
                (view as? UIButton)?.setTitle(String(titles[index]), for: .normal)
            } else {
                (view as? UIButton)?.setTitle("<Segment>", for: .normal)
            }
        }
    }
    
    private func setCornerRadius() {
        layer.cornerRadius = cornerRadius
    }
    
    private func setButtonCornerRadius() {
        stackView.subviews.forEach { view in
            (view as? UIButton)?.layer.cornerRadius = cornerRadius
        }
        
        currentIndexView.layer.cornerRadius = cornerRadius
    }
    
    private func setBorderColor() {
        layer.borderColor = borderColor.cgColor
    }
    
    private func setBorderWidth() {
        layer.borderWidth = borderWidth
    }
    
    //MARK: - IBActions
    @objc func segmentTapped(_ sender: UIButton) {
        didTapSegment?(sender.tag)
        currentIndex = sender.tag
    }
    
}
