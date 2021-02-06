//
//  UILabelTextChangeTransition.swift
//
//  Created by Baianat on 2/6/21.
//

import UIKit

public extension UILabel {
    enum Direction {
        case downwards(offset: CGFloat)
        case upwards(offset: CGFloat)
        case leftwards(offset: CGFloat)
        case rightwards(offset: CGFloat)
        
        func initialTransform() -> CGAffineTransform {
            switch self {
                case .downwards(let offset):
                    return CGAffineTransform(translationX: 0, y: -offset)
                case .upwards(let offset):
                    return CGAffineTransform(translationX: 0, y: offset)
                case .leftwards(let offset):
                    return CGAffineTransform(translationX: offset, y: 0)
                case .rightwards(let offset):
                    return CGAffineTransform(translationX: -offset, y: 0)
            }
        }
        func finalTransform() -> CGAffineTransform {
            switch self {
                case .downwards(let offset):
                    return CGAffineTransform(translationX: 0, y: offset)
                case .upwards(let offset):
                    return CGAffineTransform(translationX: 0, y: -offset)
                case .leftwards(let offset):
                    return CGAffineTransform(translationX: -offset, y: 0)
                case .rightwards(let offset):
                    return CGAffineTransform(translationX: offset, y: 0)
            }
        }
    }
    func animateTextChangeInto(newText: String, withDirection direction: Direction, ofDuration duration: Double) {
        let duplicatedLabel = duplicateViewWithConstraint()
        
        duplicatedLabel.text = newText
        
        duplicatedLabel.alpha = 0
        duplicatedLabel.transform = direction.initialTransform()
        
        UIView.animate(withDuration: duration) {
            duplicatedLabel.transform = .identity
            duplicatedLabel.alpha = 1
            self.transform = direction.finalTransform()
            self.alpha = 0
        } completion: { (_) in
            self.transform = .identity
            self.alpha = 1
            self.text = newText
            
            UIView.animate(withDuration: 0.2) {
                duplicatedLabel.alpha = 0
                duplicatedLabel.removeFromSuperview()
            }
        }
    }
    
    func duplicateViewWithConstraint() -> UILabel {
        let label = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! UILabel
        superview?.addSubview(label)
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        return label
    }
}
