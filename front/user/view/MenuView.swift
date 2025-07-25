//
//  MenuView.swift
//  front
//
//  Created by Quadroue4 on 7/19/25.
//

import Foundation
import UIKit
import SwiftUI

class MenuView: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let menuItems = [
        (title: "게시판", segueIdentifier: "ShowBoardList")
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
        if segueId == "ShowBoardList" {
            let boardListView = BoardMainView()
            let hostingVC = UIHostingController(rootView: boardListView)
            if let nav = self.navigationController {
                nav.pushViewController(hostingVC, animated: true)
            } else {
                hostingVC.modalPresentationStyle = .fullScreen
                self.present(hostingVC, animated: true, completion: nil)
            }
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

