//
//  TableViewController.swift
//  Workout
//
//  Created by  Kostantin Zarubin on 11/12/2018.
//  Copyright © 2018  Kostantin Zarubin. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var currentPack: [String] = []
    var currentTitle = ""
    var indexOfPack = 0
    var test = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if test {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowExercise" {
            if let nextViewController = segue.destination as? WorkoutViewController {
                nextViewController.currentPack = currentPack
                nextViewController.currentTitle = currentTitle
                nextViewController.indexOfPack = indexOfPack
                test = true
            }
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        performSegue(withIdentifier: "ShowExercise", sender: nil)
    }
}

extension TableViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Content.titleEx[indexOfPack].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height / 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.gifImageView.loadGif(name: currentPack[indexPath.row])
        cell.titleLabel.text = Content.titleEx[indexOfPack][indexPath.row]
        cell.numberButton.setTitle("\(indexPath.row + 1)", for: .normal)
        return cell
    }
}
