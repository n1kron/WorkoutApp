import UIKit

class WorkoutViewController: UIViewController {
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var timeToRestLabel: UILabel!
    @IBOutlet weak var exerciseTitle: UILabel!
    @IBOutlet weak var repetitionLabel: UILabel!
    @IBOutlet weak var startView: StartView!
    @IBOutlet weak var finishView: FinishView!
    
    @IBOutlet var pauseView: FinishView!
    
    @IBOutlet weak var workoutView: UIView!
    @IBOutlet weak var circleTimer: UIView!
    @IBOutlet weak var exerciseTitleLabel: UILabel!

    var timer:Timer!
    var startCount = 0
    var timeCount: Int = 15
    var indexOfPack = 0
    var currentPack: [String] = []
    var currentTitle = ""
    var startBackgroundImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutView.layer.borderWidth = 1.0
        workoutView.layer.borderColor = UIColor.lightGray.cgColor
        progressView.layer.borderWidth = 1.0
        progressView.layer.borderColor = UIColor(red: 206/255, green: 192/255, blue: 255/255, alpha: 1.0).cgColor
        gifImageView.loadGif(name: currentPack[startCount])
        exerciseTitleLabel.text = Content.titleEx[indexOfPack][startCount]
        exerciseTitle.text = currentTitle
        workoutView.layer.cornerRadius = 20.0
        circleTimer.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        startView.frame.size = view.frame.size
        pauseView.delegate = self
        pauseView.frame.size = view.frame.size
        finishView.delegate = self
        finishView.frame.size = view.frame.size
        finishView.alpha = 0.0
        view.addSubview(startView)
    }

    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pauseAction(_ sender: Any) {
        view.addSubview(pauseView)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if !gifImageView.isHidden {
            if startCount == currentPack.count - 1 {
                finishView.caloriesLabel.text = "Burned calories: \(Content.calories[indexOfPack])"
                view.addSubview(finishView)
                UIView.animate(withDuration: 0.25) { [weak self] in
                    self?.finishView.alpha = 1.0
                }
                return
            }
            progressView.progress += currentPack.count == 4 ? 0.25 : 0.2
            gifImageView.isHidden = true
            exerciseTitleLabel.isHidden = true
            progressView.isHidden = true
            repetitionLabel.isHidden = true
            timeToRestLabel.isHidden = false
            circleTimer.isHidden = false
            restLabel.isHidden = false
            timer = Timer(timeInterval: 1.0, target: self, selector: #selector(timerDidFire), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        } else {
            exerciseIsOver()
        }
    }
    
    @objc func timerDidFire() {
        timeCount -= 1
        if timeCount == 0 {
            exerciseIsOver()
        }
        restLabel.text = NSString(format: "%02d:%02d",(timeCount/60)%60,timeCount%60) as String
    }
    
    func exerciseIsOver () {
        timer.invalidate()
        startCount += 1
        gifImageView.loadGif(name: currentPack[startCount])
        exerciseTitleLabel.text = Content.titleEx[indexOfPack][startCount]
        exerciseTitleLabel.isHidden = false
        gifImageView.isHidden = false
        progressView.isHidden = false
        repetitionLabel.isHidden = false
        circleTimer.isHidden = true
        timeToRestLabel.isHidden = true
        restLabel.isHidden = true
        restLabel.text = "00:15"
        timeCount = 15
    }
}

extension WorkoutViewController: FinishDelegate {
    func repeatSelected() {
        progressView.progress = 0
        startView.numberLabel.transform = CGAffineTransform.identity
        startView.numberLabel.text = "Get Ready!"
        startView.timeCount = 4
        finishView.alpha = 0.0
        startView.awakeFromNib()
        view.addSubview(startView)
        startCount = 0
        gifImageView.loadGif(name: currentPack[startCount])
        pauseView?.removeFromSuperview()
    }
    
    func menuSelected() {
        dismiss(animated: true, completion: nil)
    }
    
    func resumeSelected() {
        pauseView.removeFromSuperview()
    }
}
