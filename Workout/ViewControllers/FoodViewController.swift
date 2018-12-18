import UIKit

class FoodViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = UIColor.clear
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFoodDetails" {
            if let nextViewController = segue.destination as? FoodDetailsViewController {
                if let ex = sender as? Int {
                    nextViewController.dayDiet = Content.dietDescription[ex]
                    nextViewController.dayImage = Content.dietImage[ex]
                }
            }
        }
    }
}

extension FoodViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height / 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodTableViewCell", for: indexPath) as! FoodTableViewCell
        cell.caloriesLabel.text = Content.caloriesDiet[indexPath.row]
        switch indexPath.row {
        case 0: cell.dayLabel.text = "Monday"
            cell.dayImageView.image = UIImage(named: "cup")
        case 1: cell.dayLabel.text = "Tuesday"
        case 2: cell.dayLabel.text = "Wednesday"
        case 3: cell.dayLabel.text = "Thursday"
            cell.dayImageView.image = UIImage(named: "coffee")
        case 4: cell.dayLabel.text = "Friday"
            cell.dayImageView.image = UIImage(named: "cup")
        case 5: cell.dayLabel.text = "Saturday"
        case 6: cell.dayLabel.text = "Sunday"
            cell.dayImageView.image = UIImage(named: "coffee")
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowFoodDetails", sender: indexPath.row)
    }
}
