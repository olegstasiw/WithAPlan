//
//  ChooseDateViewController.swift
//  With a Plan
//
//  Created by mac on 23.07.2020.
//  Copyright © 2020 Oleg Stasiw. All rights reserved.
//

import UIKit

class ChooseDateViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var colorViewSelectDate: UIView!

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveButtonMain: UIButton!

    @IBOutlet weak var chooseDatePicker: UIDatePicker!

    //MARK: - Public Properties
    var date: Date!
    var mainButtonIsHidden: Bool!
    var buttonIsHidden: Bool!

    //MARK: - Live Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    //MARK: - Private Methods
    private func setUI() {
        setCornerRadius(radius: 10)
        configureFormatterAndPicker(date: date)
    }
    private func setCornerRadius(radius: CGFloat) {
        mainView.layer.cornerRadius = radius
        colorViewSelectDate.layer.cornerRadius = radius
        saveButton.layer.cornerRadius = radius
        saveButtonMain.layer.cornerRadius = radius
    }
    private func configureFormatterAndPicker(date: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        chooseDatePicker.setDate(date, animated: true)

        saveButton.isHidden = buttonIsHidden
        saveButtonMain.isHidden = mainButtonIsHidden
        chooseDatePicker.minimumDate = Date()
    }
}
