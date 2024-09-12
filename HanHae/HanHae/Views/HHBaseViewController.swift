//
//  HHBaseViewController.swift
//  HanHae
//
//  Created by 김성민 on 9/12/24.
//

import UIKit

class HHBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateBackgroudColor()
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
            self.updateBackgroudColor()
        }
    }
    
    private func updateBackgroudColor() {
        if traitCollection.userInterfaceStyle == .light {
            setLightBackground()
        } else {
            setDarkBackground()
        }
    }
    
    private func setLightBackground() {
        if let sublayers = view.layer.sublayers, sublayers.contains(where: { $0 is CAGradientLayer }) {
            sublayers.first { $0 is CAGradientLayer }?.removeFromSuperlayer()
        }
        
        view.backgroundColor = .white
    }
    
    private func setDarkBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.hhGradient1.cgColor, UIColor.hhGradient2.cgColor]
        
        if let sublayers = view.layer.sublayers, sublayers.contains(where: { $0 is CAGradientLayer }) {
            sublayers.first { $0 is CAGradientLayer }?.removeFromSuperlayer()
        }
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
