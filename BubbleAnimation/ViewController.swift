//
//  ViewController.swift
//  BubbleAnimation
//
//  Created by Imac on 3/9/17.
//  Copyright © 2017 iOS_Devs. All rights reserved.
//

//  ref: https://austinstartups.com/ios-bubble-animation-tutorial-4d3a4d0fe20c#.5gr28oba2

import UIKit

class ViewController: UIViewController {

  var fishImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    addFish()
    Timer.scheduledTimer(timeInterval: 0.1,
                         target: self,
                         selector: #selector(ViewController.addBubble),
                         userInfo: nil,
                         repeats: true)
    animationFish()
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func addFish() {
    
    fishImageView = UIImageView.init(image: UIImage(named: "fish"))
    fishImageView.frame = CGRect(x: self.view.center.x - 100,
                                 y: self.view.center.y - 100,
                                 width: 200,
                                 height: 200)
    self.view.addSubview(fishImageView)
    
  }
  
  func addBubble() {
   
    let size = self.randomFloatBetween(5, 30)
    
    //  add bubble to view
    let bubbleImageView = UIImageView.init(image: UIImage(named: "bubble"))
    bubbleImageView.frame = CGRect(x: (fishImageView.layer.presentation()?.frame.origin.x)!,
                                   y: (fishImageView.layer.presentation()?.frame.origin.y)! + 80,
                                   width: size,
                                   height: size)
    bubbleImageView.alpha = self.randomFloatBetween(0.2, 1)
    self.view.addSubview(bubbleImageView)
    
    let oX: CGFloat = bubbleImageView.frame.origin.x
    let oY: CGFloat = bubbleImageView.frame.origin.y
    let eX: CGFloat = oX
    let eY: CGFloat = oY - self.randomFloatBetween(50, 300)
    let t: CGFloat = self.randomFloatBetween(20, 100)
    let cp1 = CGPoint(x: oX - t, y: (oY + eY)/2)
    let cp2 = CGPoint(x: oX + t, y: cp1.y)
    
    //  add animation
    let zigzagPath = UIBezierPath()
    zigzagPath.move(to: CGPoint(x: oX, y: oY))
    //  add end point and control of the point
    zigzagPath.addCurve(to: CGPoint(x: eX, y: eY), controlPoint1: cp1, controlPoint2: cp2)
    
    //  create animation path
    let pathAnimation = CAKeyframeAnimation(keyPath: "position")
    pathAnimation.duration = 2
    pathAnimation.path = zigzagPath.cgPath
    
    //  remains visible in it's final state when animation is finish
    //  in conjunction with removeOnCompletion
    pathAnimation.fillMode = kCAFillModeForwards
    pathAnimation.isRemovedOnCompletion = false
    
    //  begin transaction animation
    CATransaction.begin()
    CATransaction.setCompletionBlock {
      UIView.transition(with: bubbleImageView,
                        duration: 0.1,
                        options: UIViewAnimationOptions.transitionCrossDissolve,
                        animations: {
                          bubbleImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
      }, completion: { (finished) in
        bubbleImageView.removeFromSuperview()
      })
    }
    
    //  add animation to bubble image
    bubbleImageView.layer.add(pathAnimation, forKey: "movingAnimation")
    
    CATransaction.commit()
    
  }
  
  func animationFish() {
    UIView.animate(withDuration: 5, animations: { 
      
      self.fishImageView.frame = CGRect(x: self.view.frame.width + 200,
                                        y: self.view.center.y - 100,
                                        width: 200,
                                        height: 200)
      
    }) { (_) in
      self.fishImageView.frame = CGRect(x: self.view.frame.origin.x - 200,
                                        y: self.view.center.y - 100,
                                        width: 200,
                                        height: 200)
      self.animationFish()
    }
  }
  
  func randomFloatBetween(_ smallNumber: CGFloat, _ bigNumber: CGFloat) -> CGFloat {
    
    let diff = bigNumber - smallNumber
    let rd = arc4random() % (UInt32(RAND_MAX) + 1)
    let value = CGFloat(CGFloat(rd)/CGFloat(RAND_MAX))*diff + smallNumber
    return value
    
  }
}

