import UIKit

protocol FinishDelegate: class {
    func menuSelected()
    func repeatSelected()
    func resumeSelected()
}

class FinishView: UIView {
    @IBOutlet weak var caloriesLabel: UILabel!
    weak var delegate: FinishDelegate?
    
    @IBAction func menuAction(_ sender: UIButton) {
        delegate?.menuSelected()
    }
    
    @IBAction func repeatAction(_ sender: UIButton) {
        delegate?.repeatSelected()
    }
    
    @IBAction func resumeAction(_sender: UIButton) {
        delegate?.resumeSelected()
    }
}
