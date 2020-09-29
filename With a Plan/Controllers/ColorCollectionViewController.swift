//
//  ColorCollectionViewController.swift
//  With a Plan
//
//  Created by mac on 18.09.2020.
//  Copyright © 2020 Oleg Stasiw. All rights reserved.
//

import UIKit

class ColorCollectionViewController: UICollectionViewController {
    
    //MARK: - Public Properties
    var someColor: UIColor! = .gray
    var newColor:UIColor! = .gray
    var isChecked = false

    //MARK: - Private Properties
    private let myColors = MyColors.allCases
    private let itemsPerRow: CGFloat = 4
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    private var lastSelectedCell = UICollectionViewCell()

    //MARK: - Ovrride Methods
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myColors.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "coll", for: indexPath) as! ColorCell

        let color = myColors[indexPath.item]

        cell.backgroundColor = color.value
        cell.textLabel.text = ""
        cell.layer.cornerRadius = cell.frame.height / 2
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        isChecked = true
        let color = myColors[indexPath.item]
        newColor = color.value
        someColor = color.value

        lastSelectedCell.layer.borderWidth = 0
        lastSelectedCell = collectionView.cellForItem(at: indexPath) ?? UICollectionViewCell()
        collectionView.cellForItem(at: indexPath)?.layer.borderWidth = 3
        collectionView.cellForItem(at: indexPath)?.layer.borderColor = UIColor.init(named: "barColor")?.cgColor


    }
}

//MARK: - Collection View Delegate Flow Layout
extension ColorCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingWidth = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}


