import UIKit

class ViewController: UIViewController {
    var collectionView: UICollectionView?
    var items = ["5","6","2","3","7","0","1","8","4"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        updateBackgroundColor()
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let itemSize = (view.frame.size.width - 20) / 3.2 // Make cells square and fit 3 cells horizontally with some spacing
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: (view.frame.size.height - itemSize * 3) / 2, width: view.frame.size.width, height: itemSize * 3), collectionViewLayout: layout)
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

    func updateBackgroundColor() {
        if items == ["0", "1", "2", "3", "4", "5", "6", "7", "8"] {
            view.backgroundColor = .red
        } else {
            view.backgroundColor = .white
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let image = UIImage(named: items[indexPath.item]) {
            let imageView = UIImageView(image: image)
            imageView.frame = cell.contentView.bounds
            imageView.contentMode = .scaleToFill
            cell.contentView.addSubview(imageView)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movable = items.remove(at: sourceIndexPath.item)
        items.insert(movable, at: destinationIndexPath.item)
        updateBackgroundColor()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (view.frame.size.width - 20) / 3.2 // Make cells square and fit 3 cells horizontally with some spacing
        return CGSize(width: itemSize, height: itemSize)
    }
}
