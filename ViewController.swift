//
//  ViewController.swift
//  Watch
//
//  Created by 吉田勇気 on 2014/12/31.
//  Copyright (c) 2014年 Yuki Yoshida. All rights reserved.
//

import UIKit

protocol CountNumDelegate: class {
    func rapDelegate(lastRap: Int) -> ViewController
}

class TimerView :UILabel {
    var timerOn = false
    var nsTimer = NSTimer()
    var countNum :Int
    var lastRap = 0
    weak var delegate :CountNumDelegate!
    
    func update() {
        countNum++
        self.text = timeFormat(countNum)
    }
    
    func timeFormat(var num :Int)-> String {
//        if num < 0 { num = 0 }
        let ms = num % 100
        let s = (num - ms) / 100 % 60
        let m = (num - s - ms) / 6000 % 3600
        return String(format: "%02d:%02d.%02d", arguments: [m,s,ms])
    }
    
    override init(frame :CGRect) {
        countNum = lastRap
        super.init(frame: frame)
        self.userInteractionEnabled = true  // 地味に必須

        let tap = UITapGestureRecognizer()
        let swipeRight = UISwipeGestureRecognizer()
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        let swipeDown = UISwipeGestureRecognizer()
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        
        tap.addTarget(self, action: "startAndStop")
        swipeRight.addTarget(self, action: "reset")
        swipeDown.addTarget(self, action: "rap")

        self.addGestureRecognizer(tap)
        self.addGestureRecognizer(swipeRight)
        self.addGestureRecognizer(swipeDown)

        self.text = timeFormat(countNum)
        self.backgroundColor = UIColor.redColor()
        self.font = UIFont(name: "Symbol", size: 60.0)
        self.textAlignment = NSTextAlignment.Center
        self.baselineAdjustment = UIBaselineAdjustment.AlignCenters
//        self.layer.cornerRadius = 5 //      ?
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startAndStop() {
        if timerOn == false {
            nsTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
            timerOn = true
            self.backgroundColor = UIColor.greenColor()
            NSLog("Tap to start")
            
        } else {
            nsTimer.invalidate()
            timerOn = false
            self.backgroundColor = UIColor.redColor()
            NSLog("Tap to stop")
        }
    }

    func reset() {
        if timerOn == false {
            countNum = 0
            lastRap = 0
            self.text = timeFormat(countNum)
            NSLog("Swiped Right to reset")
        }
    }
    
    func rap() {
        lastRap = countNum - lastRap
        NSLog("Swiped Down at count \(timeFormat(lastRap))")
        if timerOn == true {
            delegate.rapDelegate(countNum).draw(6)   // ViewControllerのメソッドを呼ぶ
        }
    }
}

class ViewController: UIViewController, CountNumDelegate {

    var timerLabel = [
        TimerView(frame: CGRectMake(0, 0, 250, 80)),
        TimerView(frame: CGRectMake(0, 0, 250, 80)),
//        TimerView(frame: CGRectMake(0, 0, 250, 80)),
    ]

    func rapDelegate(countNum :Int) -> ViewController {
        let rapped = TimerView(frame: CGRectMake(0, 0, 250, 80))
        rapped.userInteractionEnabled = false  // 再稼働禁止
        rapped.lastRap = countNum
        timerLabel.insert(rapped, atIndex: 1)
        rapped.countNum = countNum - timerLabel[2].lastRap
        let t = timerLabel[1]
        t.lastRap = countNum
        t.text = rapped.timeFormat(rapped.countNum)
        NSLog("\(t.timeFormat(t.lastRap))")
        return self
    }

    func draw(max: Int) {
        // 既存のビューを一度すべて消す
        let subviews = self.view.subviews as [UIView]
        for v in subviews {
            if let timerView = v as? TimerView {
                    timerView.removeFromSuperview()
            }
        }
        // 並べ直し
        var num = 0
        for t in timerLabel {
            t.center = CGPointMake(self.view.bounds.width / 2, self.view.bounds.height * CGFloat(++num) / 7)
            if num <= max {
                self.view.addSubview(t)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timerLabel[0].delegate = self
        self.draw(1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
