import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var workoutCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTable" {
            if let nextViewController = segue.destination as? TableViewController {
                if let i = sender as? Int {
                    nextViewController.currentPack = Content.Workout.all[i]
                    nextViewController.currentTitle = Content.Workout.workoutTitles[i]
                    nextViewController.indexOfPack = i
                }
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Content.Workout.all.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIDevice.current.userInterfaceIdiom == .pad ? UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20) : UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExercisesCollectionViewCell", for: indexPath) as! ExercisesCollectionViewCell
        cell.workoutTitle.text = Content.Workout.workoutTitles[indexPath.row]
        cell.backgroundImageView.image = UIImage(named: "background-\(indexPath.row)")
        cell.difExLabel.text = Content.exDescription[indexPath.row]
        cell.descriptionTitle.text = Content.Workout.descriptionTexts[indexPath.row]
        cell.difLabel.text = Content.explanations[indexPath.row]
        cell.startButton.isHidden = indexPath.row == 6
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return UIDevice.current.userInterfaceIdiom == .pad ? CGSize(width: UIScreen.main.bounds.size.width * 0.75 , height: UIScreen.main.bounds.size.height * 0.83) : CGSize(width: UIScreen.main.bounds.size.width * 0.75 , height: UIScreen.main.bounds.size.height * 0.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row != 6 else { return }
        performSegue(withIdentifier: "ShowTable", sender: indexPath.row)
    }
}

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
        let activeDistance: CGFloat = 150
        let zoomFactor: CGFloat = 0.115
        
        override func prepare() {
            sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            super.prepare()
        }
        
        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            guard let collectionView = collectionView else { return nil }
            let rectAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
            let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)
            for attributes in rectAttributes where attributes.frame.intersects(visibleRect) {
                let distance = visibleRect.midX - attributes.center.x
                let normalizedDistance = distance / activeDistance

                if distance.magnitude < activeDistance {
                    let zoom = 1 + zoomFactor * (1 - normalizedDistance.magnitude)
                    attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
                    attributes.zIndex = Int(zoom.rounded())
                }
            }
            
            return rectAttributes
        }
        
        override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
            guard let collectionView = collectionView else { return .zero }
            let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
            guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }
            
            var offsetAdjustment = CGFloat.greatestFiniteMagnitude
            let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2
            
            for layoutAttributes in rectAttributes {
                let itemHorizontalCenter = layoutAttributes.center.x
                if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                    offsetAdjustment = itemHorizontalCenter - horizontalCenter
                }
            }
            
            return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
        }
        
        override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
            return true
        }
        
        override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
            let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
            context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
            return context
        }
}
