//
//  TableFooterView.swift
//  TableViewFooter
//
//  Created by Haris Zaman on 1/16/22.
//

import UIKit

class TableFooterView: UIView {
    
    var lessOrMoreButtonCallback: (() -> ())?
    var hideButtonCallback: (() -> ())?
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .vertical
        return stackView
    }()
    
    private var contentLabel: UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }
    
    private lazy var lessOrMoreButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(lessOrMoreButtonPressed), for: .touchUpInside)
        button.setTitle("Less", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    private lazy var hideButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(hideButtonPressed), for: .touchUpInside)
        button.setTitle("Hide", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    init(strings: [String]) {
        super.init(frame: .zero)
        setup(strings: strings)
    }
    
    private func setup(strings: [String]) {
        addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 16),
            contentStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 8),
            layoutMarginsGuide.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor, constant: 16),
            layoutMarginsGuide.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 8)
        ])
        
        strings.forEach { string in
            let contentLabel = self.contentLabel
            contentLabel.text = string
            contentStackView.addArrangedSubview(contentLabel)
        }
        
        contentStackView.addArrangedSubview(lessOrMoreButton)
        contentStackView.addArrangedSubview(hideButton)
        contentStackView.layoutIfNeeded()
    }
    
    @objc private func lessOrMoreButtonPressed() {
        
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut]) {
            self.contentStackView.arrangedSubviews.enumerated().forEach { idx, element in
                if idx > 3,
                   self.lessOrMoreButton.currentTitle == "Less",
                   element.isKind(of: UILabel.self), !element.isHidden {
                    element.isHidden = true
                }
                else {
                    element.isHidden = false
                }
            }
            self.lessOrMoreButtonCallback?()
            self.contentStackView.layoutIfNeeded()
            self.lessOrMoreButton.setTitle(self.lessOrMoreButton.currentTitle == "Less" ? "More": "Less", for: .normal)
            
        } completion: { complete in
            
        }
    }
    
    @objc private func hideButtonPressed() {
        
        let shouldHide = hideButton.currentTitle == "Hide"
        let shouldShowCollpasedState = self.lessOrMoreButton.currentTitle == "More"
        
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut]) {
            self.contentStackView.arrangedSubviews.enumerated().forEach { idx, element in
                var isHideButton = false
                if let button = element as? UIButton, button.currentTitle == "Hide" {
                    isHideButton = true
                }
                
                func hideElement() {
                    element.isHidden = true
                    if element.isKind(of: UIButton.self) {
                        element.alpha = 0
                    }
                }
                
                func showElement() {
                    element.isHidden = false
                    if element.isKind(of: UIButton.self) {
                        element.alpha = 1
                    }
                }
                
                if shouldHide {
                    if !element.isHidden, !isHideButton {
                        hideElement()
                    }
                } else {
                    if shouldShowCollpasedState {
                        if idx > 3, element.isKind(of: UILabel.self) {
                            guard !element.isHidden else { return }
                            hideElement()
                        }
                        else {
                            showElement()
                        }
                    } else {
                        showElement()
                    }
                }
            }
            
            self.hideButtonCallback?()
            self.contentStackView.layoutIfNeeded()
            self.hideButton.setTitle(self.hideButton.currentTitle == "Hide" ? "Show": "Hide", for: .normal)
            
        } completion: { complete in
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
