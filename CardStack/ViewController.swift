//
//  ViewController.swift
//  CardStack
//
//  Created by Kevin Scardina on 9/24/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let controlPadding:CGFloat = 2.0
    let boarderColor = UIColor.gray.cgColor
    let boarderWidth:CGFloat = 1.0
    let cardViewPadding:CGFloat = 4.0
    let cardViewNextOffset:CGFloat = 2.0

    var dataSource = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    var cardStack:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.createCardStack()
        self.drawCardStackControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createCardStack() {
        // create a view a quarter size of the main container view.
        self.cardStack = UIView(
            frame: CGRect(
                x: self.view.safeAreaInsets.left + self.controlPadding,
                y: self.view.safeAreaInsets.top + UIApplication.shared.statusBarFrame.height + self.controlPadding,
                width: self.view.bounds.width - CGFloat(self.controlPadding*2.0),
                height: (self.view.bounds.height - CGFloat(self.controlPadding*2.0))/4.0
            )
        )
        self.cardStack.layer.borderColor = self.boarderColor
        self.cardStack.layer.borderWidth = self.boarderWidth
        
        // add a gesture recognizer to the control view for left
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipeLeftGestureRecognizer.direction = .left
        self.cardStack.addGestureRecognizer(swipeLeftGestureRecognizer)
        
        // add it to the main container view.
        self.view.addSubview(self.cardStack)
    }
    
    func drawCardStackControl() {
        // clear out subviews
        for subview in self.cardStack.subviews {
            subview.removeFromSuperview()
        }
        // create a top and next view for the card stack
        if self.dataSource.count > 0 {
            self.drawTopCard(withColor: self.dataSource[0])
            if self.dataSource.count > 1 {
                drawNextCard(withColor: self.dataSource[1])
            }
        }
    }
    
    func drawTopCard(withColor color: UIColor) {
        let cardView = UIView(
            frame: CGRect(
                x: self.cardViewPadding,
                y: self.cardViewPadding,
                width: self.cardStack.bounds.width - CGFloat(self.cardViewPadding*2.0),
                height: self.cardStack.bounds.height - CGFloat(self.cardViewPadding*2.0)
            )
        )
        cardView.layer.borderWidth = self.boarderWidth
        cardView.layer.borderColor = self.boarderColor
        cardView.layer.backgroundColor = color.cgColor
        self.cardStack.addSubview(cardView)
    }
    
    func drawNextCard(withColor color: UIColor) {
        let cardView = UIView(
            frame: CGRect(
                x: self.cardViewPadding+self.cardViewNextOffset,
                y: self.cardViewPadding+self.cardViewNextOffset,
                width: self.cardStack.bounds.width - CGFloat(self.cardViewPadding*2.0),
                height: self.cardStack.bounds.height - CGFloat(self.cardViewPadding*2.0)
            )
        )
        cardView.layer.borderWidth = self.boarderWidth
        cardView.layer.borderColor = self.boarderColor
        cardView.layer.backgroundColor = color.cgColor
        self.cardStack.insertSubview(cardView, at: 0)
    }
}

extension ViewController {
    @objc fileprivate func swipeLeft(recognizer:UISwipeGestureRecognizer) {
        if let topCard = self.cardStack.subviews.last {
            UIView.animate(
                withDuration: 0.4,
                animations: {
                    topCard.frame = CGRect(
                        x: -(self.cardStack.bounds.width),
                        y: topCard.frame.origin.y,
                        width: topCard.frame.width,
                        height: topCard.frame.height
                    )
            }) { (success) in
                self.dataSource.append(self.dataSource.remove(at: 0))
                self.drawCardStackControl()
            }
        }
    }
}

