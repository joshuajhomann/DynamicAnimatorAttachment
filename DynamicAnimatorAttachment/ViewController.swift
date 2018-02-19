//
//  ViewController.swift
//  DynamicAnimatorAttachment
//
//  Created by Joshua Homann on 11/9/17.
//  Copyright © 2017 josh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Variables
    @IBOutlet var stars: [UIImageView]!
    private var strings: [UIView] = []
    private var animator: UIDynamicAnimator!
    private var gravity: UIGravityBehavior!
    private var pushBehavior: UIPushBehavior!
    // MARK: - Constants
    let stringLengths: [CGFloat] = [75, 100, 150, 120, 80]
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        strings = zip(stars, stringLengths).map { (star,stringLength) -> UIView in
            let string = UIView()
            string.translatesAutoresizingMaskIntoConstraints = false
            self.view.insertSubview(string, at: 0)
            string.backgroundColor = .lightGray
            string.widthAnchor.constraint(equalToConstant: 3).isActive = true
            string.heightAnchor.constraint(equalToConstant: stringLength).isActive = true
            string.centerXAnchor.constraint(equalTo: star.centerXAnchor).isActive = true
            string.bottomAnchor.constraint(equalTo: star.centerYAnchor).isActive = true
            return string
        }
        animator = UIDynamicAnimator(referenceView: view)
        view.layoutIfNeeded()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var attachments: [UIDynamicBehavior] = [UIAttachmentBehavior(item: view, attachedToAnchor: view.center)]
        zip(stars, strings).forEach { (star, string) in
            let anchor = CGPoint(x: string.center.x, y: string.frame.origin.y)
            let stringAttachment = UIAttachmentBehavior(item: string, offsetFromCenter: UIOffset(horizontal: 0, vertical: -string.frame.size.height / 2 - star.frame.size.height / 2), attachedToAnchor: anchor)
            let starAttachment =  UIAttachmentBehavior.pinAttachment(with: star, attachedTo: string, attachmentAnchor: star.center)
            starAttachment.frictionTorque = 100
            attachments.append(stringAttachment)
            attachments.append(starAttachment)
        }
        animator.removeAllBehaviors()
        attachments.forEach { self.animator.addBehavior($0) }
        gravity = UIGravityBehavior(items: [stars,strings].flatMap{$0})
        animator.addBehavior(gravity)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func tap(sender: UITapGestureRecognizer) {
        stars.forEach { star in
            let location = sender.location(in: star)
            if star.bounds.contains(location) {
                let direction = CGVector(dx: location.x < star.bounds.midX ? 1 : -1, dy: 0)
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

