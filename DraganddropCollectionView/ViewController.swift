import UIKit

class ViewController: UIViewController {
    var collectionView: UICollectionView?
    var items: [UIColor] = [.black, .blue, .systemRed, .systemPink, .systemTeal, .systemIndigo, .systemPurple, .systemOrange, .white]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width/3.2, height: view.frame.size.height/3.2)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        // Create and add long press gesture recognizer
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        longPressGestureRecognizer.minimumPressDuration = 0.1
        collectionView?.addGestureRecognizer(longPressGestureRecognizer)
        
        view.addSubview(collectionView!)
    }


    @objc func handleGesture(_ gesture: UILongPressGestureRecognizer) {
        if let collectionView = collectionView {
            switch gesture.state {
            case .began:
                guard let targetIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
                collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
            case .changed:
                collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
            case .ended:
                collectionView.endInteractiveMovement()
            default:
                collectionView.cancelInteractiveMovement()
            }
        }
    }

}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = items[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movable = items.remove(at: sourceIndexPath.row)
        items.insert(movable, at: destinationIndexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/3.2, height: view.frame.size.height/3.2)
    }
}
