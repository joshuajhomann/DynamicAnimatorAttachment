//
//  ViewController.swift
//  DynamicAnimatorAttachment
//
//  Created by Joshua Homann on 11/9/17.
//  Copyright © 2017 josh. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    // MARK: - Variables
    @IBOutlet var stars: [UIImageView]!
    private var animator: UIDynamicAnimator!
    private var gravity: UIGravityBehavior!
    private var pushBehavior: UIPushBehavior!
    // MARK: - Constants
    let motionManager = CMMotionManager()
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        let attachements = stars.map { (star: UIImageView) ->  UIAttachmentBehavior in
            let anchor = star.center
            let behavior = UIAttachmentBehavior(item: star, attachedToAnchor: anchor)
            behavior.length = 150
            behavior.frictionTorque = 10
            return behavior
        }
        animator = UIDynamicAnimator(referenceView: view)
        attachements.forEach { self.animator.addBehavior($0) }
        gravity = UIGravityBehavior(items: stars)
        animator.addBehavior(gravity)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func tap(sender: UITapGestureRecognizer) {
        stars.forEach { star in
            let location = sender.location(in: star)
            if star.bounds.contains(location) {
                let direction = CGVector(dx: star.center.x - location.x, dy: star.center.y - location.y)
                if let pushBehavior = self.pushBehavior {
                    self.animator.removeBehavior(pushBehavior)
                }
                self.pushBehavior = UIPushBehavior(items: [star], mode: .instantaneous)
                self.pushBehavior.pushDirection = direction
                self.pushBehavior.magnitude = 0.2
                self.animator.addBehavior(self.pushBehavior)
            }
        }
    }
    



}

