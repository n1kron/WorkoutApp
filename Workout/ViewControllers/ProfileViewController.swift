import UIKit
import HealthKit

class ProfileViewController: UITableViewController {
    @IBOutlet private var ageLabel:UILabel!
    @IBOutlet private var bloodTypeLabel:UILabel!
    @IBOutlet private var biologicalSexLabel:UILabel!
    @IBOutlet private var weightLabel:UILabel!
    @IBOutlet private var heightLabel:UILabel!
    @IBOutlet private var bodyMassIndexLabel:UILabel!
    
    private enum ProfileSection: Int {
        case ageSexBloodType
        case weightHeightBMI
        case authorizeHealthKit
        case saveBMI
    }
    
    private enum ProfileDataError: Error {
        case missingBodyMassIndex
        var localizedDescription: String {
            switch self {
            case .missingBodyMassIndex:
                return "Unable to calculate body mass index with available profile data."
            }
        }
    }
    
    private let userHealthProfile = UserHealthProfile()
    private func updateHealthInfo() {
        loadAndDisplayAgeSexAndBloodType()
        loadAndDisplayMostRecentWeight()
        loadAndDisplayMostRecentHeight()
    }
    
    private func authorizeHealthKit() {
        HealthKitSetupAssistant.authorizeHealthKit {[weak self](authorized, error) in
            
            guard authorized else {
                if let error = error {
                    print("HealthKit Authorization Failed. Reason: \(error.localizedDescription)")
                } else {
                    print("HealthKit Authorization Failed")
                }
                return
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.open(URL(string: "x-apple-health://")!)
            }
            self?.updateHealthInfo()
            print("HealthKit Successfully Authorized.")
        }
    }
    
    private func loadAndDisplayAgeSexAndBloodType() {
        do {
            let userAgeSexAndBloodType = try ProfileDataStore.getAgeSexAndBloodType()
            userHealthProfile.age = userAgeSexAndBloodType.age
            userHealthProfile.biologicalSex = userAgeSexAndBloodType.biologicalSex
            userHealthProfile.bloodType = userAgeSexAndBloodType.bloodType
            updateLabels()
        } catch let error {
            print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateHealthInfo()
    }
    
    private func updateLabels() {
        DispatchQueue.main.async {
            if let age = self.userHealthProfile.age {
                self.ageLabel.text = "\(age)"
            }
            
            if let biologicalSex = self.userHealthProfile.biologicalSex {
                self.biologicalSexLabel.text = biologicalSex.stringRepresentation
            }
            
            if let bloodType = self.userHealthProfile.bloodType {
                self.bloodTypeLabel.text = bloodType.stringRepresentation
            }
            
            if let weight = self.userHealthProfile.weightInKilograms {
                let weightFormatter = MassFormatter()
                weightFormatter.isForPersonMassUse = true
                self.weightLabel.text = weightFormatter.string(fromKilograms: weight)
            }
            
            if let height = self.userHealthProfile.heightInMeters {
                let heightFormatter = LengthFormatter()
                heightFormatter.isForPersonHeightUse = true
                self.heightLabel.text = heightFormatter.string(fromMeters: height)
            }
            
            if let bodyMassIndex = self.userHealthProfile.bodyMassIndex {
                self.bodyMassIndexLabel.text = String(format: "%.02f", bodyMassIndex)
            }
        }
    }
    
    private func loadAndDisplayMostRecentHeight() {
        guard let heightSampleType = HKSampleType.quantityType(forIdentifier: .height) else {
            print("Height Sample Type is no longer available in HealthKit")
            return
        }
        
        ProfileDataStore.getMostRecentSample(for: heightSampleType) { (sample, error) in
            guard let sample = sample else {
                if let error = error {
                    print(error)
                }
                return
            }
            
            let heightInMeters = sample.quantity.doubleValue(for: HKUnit.meter())
            self.userHealthProfile.heightInMeters = heightInMeters
            self.updateLabels()
        }
    }
    
    private func loadAndDisplayMostRecentWeight() {
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            print("Body Mass Sample Type is no longer available in HealthKit")
            return
        }
        
        ProfileDataStore.getMostRecentSample(for: weightSampleType) { (sample, error) in
            guard let sample = sample else {
                if let error = error {
                    print(error)
                }
                return
            }
            
            let weightInKilograms = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            self.userHealthProfile.weightInKilograms = weightInKilograms
            self.updateLabels()
        }
    }
    
    private func saveBodyMassIndexToHealthKit() {
        guard let bodyMassIndex = userHealthProfile.bodyMassIndex else {
            displayAlert(text: "No information about weight or height. Calculations cannot be reached without it")
            return
        }
        displayAlert(text: "BMI successfully saved")
        ProfileDataStore.saveBodyMassIndexSample(bodyMassIndex: bodyMassIndex, date: Date())
    }
    
    private func displayAlert(text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "O.K.",style: .default,handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = ProfileSection(rawValue: indexPath.section) else {
            fatalError("A ProfileSection should map to the index path's section")
        }
        
        switch section {
        case .saveBMI:
            saveBodyMassIndexToHealthKit()
        case .authorizeHealthKit:
            authorizeHealthKit()
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont(name: "Mont-HeavyDEMO", size: 17)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .left
    }
}
