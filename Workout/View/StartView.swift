import UIKit

class StartView: UIView {
    @IBOutlet weak var numberLabel: UILabel!
    
    var timeCount:Int = 4
    var timer:Timer!
    
    override func awakeFromNib() {
        if timer != nil {
            timer.invalidate()
        }
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(timerDidFire), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    
    @objc func timerDidFire() {
        timeCount -= 1
        numberLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
        if timeCount == 0 {
            timer.invalidate()
            self.removeFromSuperview()
        }
        
        UIView.animate(withDuration: 1.0) {
            self.numberLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.numberLabel.text = NSString(format: "%2d", self.timeCount%60) as String
        }
    }
}
