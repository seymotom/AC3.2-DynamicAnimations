//
//  ViewController.swift
//  DynamicAnimations
//
//  Created by Louis Tur on 1/26/17.
//  Copyright © 2017 AccessCode. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var dynamicAnimator: UIDynamicAnimator? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpViews()
        setUpConstraints()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.dynamicAnimator = UIDynamicAnimator(referenceView: view)
        
        // Was like this but then we added a class to handle the behavior.
        //    let gravityBehavior = UIGravityBehavior(items: [blueView])
        //    gravityBehavior.angle = CGFloat.pi / 6.0
        //    gravityBehavior.magnitude = 0.2
        //    self.dynamicAnimator?.addBehavior(gravityBehavior)
        //
        //    let collisionBehavior = UICollisionBehavior(items: [blueView])
        //    collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        //    self.dynamicAnimator?.addBehavior(collisionBehavior)
        //
        //    let elasticBehavior = UIDynamicItemBehavior(items: [blueView])
        //    elasticBehavior.elasticity = 0.5
        //    self.dynamicAnimator?.addBehavior(elasticBehavior)
        
        let bouncyBehavior = BouncyView(items: [blueView, redView, snapButton, deSnapButton])
        self.dynamicAnimator?.addBehavior(bouncyBehavior)
        
        let barrierBehavior = UICollisionBehavior(items: [greenView, redView])
        barrierBehavior.addBoundary(withIdentifier: "Barrier" as NSString, from: CGPoint(x: greenView.frame.minX, y: greenView.frame.minY), to: CGPoint(x: greenView.frame.maxX, y:greenView.frame.minY))
        self.dynamicAnimator?.addBehavior(barrierBehavior)
    }
    
    func setUpViews() {
        self.view.addSubview(blueView)
        self.view.addSubview(redView)
        self.view.addSubview(greenView)
        self.view.addSubview(snapButton)
        self.view.addSubview(deSnapButton)
        snapButton.addTarget(self, action: #selector(snapToCenter), for: .touchUpInside)
        deSnapButton.addTarget(self, action: #selector(deSnap), for: .touchUpInside)

    }
    
    func setUpConstraints() {
        blueView.snp.makeConstraints { (blue) in
            blue.centerX.top.equalToSuperview()
            blue.width.height.equalTo(100)
        }
        redView.snp.makeConstraints { (red) in
            red.left.top.equalToSuperview()
            red.width.height.equalTo(100)
        }
        
        greenView.snp.makeConstraints { (green) in
            green.left.right.centerY.equalToSuperview().offset(100)
            green.height.equalTo(20)
        }

        snapButton.snp.makeConstraints { (button) in
            button.centerX.equalToSuperview()
            button.bottom.equalToSuperview().offset(-50)
        }
        deSnapButton.snp.makeConstraints { (button) in
            button.centerX.equalToSuperview()
            button.top.equalTo(snapButton.snp.bottom)
        }
    }
    
    func snapToCenter() {
        let snapBehavior = UISnapBehavior(item: blueView, snapTo: self.view.center)
        snapBehavior.damping = 1
        snapBehavior.addChildBehavior(UISnapBehavior(item: redView, snapTo: self.view.frame.origin))
        self.dynamicAnimator?.addBehavior(snapBehavior)
    }
    
    func deSnap() {
        _ = self.dynamicAnimator?.behaviors.map {
            if $0 is UISnapBehavior {
                self.dynamicAnimator?.removeBehavior($0)
            }
        }
    }
    
    internal lazy var blueView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    internal lazy var redView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    internal lazy var greenView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()

    
    internal lazy var snapButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Snap", for: .normal)
        return button
    }()
    
    internal lazy var deSnapButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("De-Snap", for: .normal)
        return button
    }()
    
}

class BouncyView: UIDynamicBehavior {
    
    override init() {}
    
    convenience init(items: [UIDynamicItem]) {
        self.init()
        let gravitiyBehavior = UIGravityBehavior(items: items)
        //        gravitiyBehavior.angle = CGFloat.pi / 6
        gravitiyBehavior.magnitude = 1.0
//        self.dynamicAnimator?.addBehavior(gravitiyBehavior)
        self.addChildBehavior(gravitiyBehavior)
        
        let collisionBehaior = UICollisionBehavior(items: items)
        collisionBehaior.translatesReferenceBoundsIntoBoundary = true
//        self.dynamicAnimator?.addBehavior(collisionBehaior)
        self.addChildBehavior(collisionBehaior)
        
        let elasticBehavior = UIDynamicItemBehavior(items: items)
        elasticBehavior.elasticity = 0.5
//        self.dynamicAnimator?.addBehavior(elasticBehavior)
        self.addChildBehavior(elasticBehavior)
    }
}







