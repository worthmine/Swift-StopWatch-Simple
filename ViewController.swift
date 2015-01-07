import UIKit

class TimerView: UILabel {
    var timerOn :Bool = false
    var timer = NSTimer()
    var countNum :Int = 0
    
    override init(frame :CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.greenColor()
        self.text = timeFormat(countNum)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startAndStop(sender: UITapGestureRecognizer) {
        if timerOn == false {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
            timerOn = true
        } else {
            timer.invalidate()
            timerOn = false
        }
    }
    
    func reset(sender: UISwipeGestureRecognizer) {
        countNum = 0
        text = timeFormat(countNum)
    }
    
    func update() {
        countNum++
        text = timeFormat(countNum)
    }
    
    func timeFormat(Num :Int)-> String {
        let ms = Num % 100
        let s = (Num - ms) / 100 % 60
        let m = (Num - s - ms) / 6000 % 3600
        return String(format: "%02d:%02d.%02d", arguments: [m,s,ms])
    }
    
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var timerView: TimerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        var frame :CGRect = CGRect(origin: self.view.bounds.origin, size: self.view.bounds.size)
        
        //カスタマイズViewを生成
        let myView = TimerView(frame: frame)

        //カスタマイズViewを追加
        self.view.addSubview(myView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
