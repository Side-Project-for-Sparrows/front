import UIKit

class MenuView: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let menuItems = [
        (title: "메뉴1", segueIdentifier: "ShowMenu1"),
        (title: "메뉴2", segueIdentifier: "ShowMenu2"),
        (title: "메뉴3", segueIdentifier: "ShowMenu3")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath)
        if let label = cell.contentView.viewWithTag(100) as? UILabel {
            label.text = menuItems[indexPath.item].title
        }
        cell.contentView.backgroundColor = .systemYellow
        return cell
    }

    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let segueId = menuItems[indexPath.item].segueIdentifier
        performSegue(withIdentifier: segueId, sender: self)
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
} 