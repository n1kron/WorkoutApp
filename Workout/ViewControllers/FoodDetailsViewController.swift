//
//  FoodDetailsViewController.swift
//  Workout
//
//  Created by  Kostantin Zarubin on 08/12/2018.
//  Copyright © 2018  Kostantin Zarubin. All rights reserved.
//

import UIKit

class FoodDetailsViewController: UIViewController {
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var rationTextView: UITextView!
    @IBOutlet weak var backView: UIView!
    
    var dayDiet: String?
    var dayImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rationTextView.text = dayDiet
        backView.layer.borderColor = UIColor.lightGray.cgColor
        backView.layer.borderWidth = 2.0
        backView.layer.cornerRadius = 20.0
        if let image = dayImage {
            topImageView.image = UIImage(named: image)
        }
    }
    
    override func viewDidLayoutSubviews() {
        rationTextView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
