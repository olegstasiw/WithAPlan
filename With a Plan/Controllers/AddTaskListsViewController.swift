//
//  AddTaskListsViewController.swift
//  With a Plan
//
//  Created by mac on 19.07.2020.
//  Copyright © 2020 Oleg Stasiw. All rights reserved.
//

import UIKit

class AddTaskListsViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var chooseColorButton: UIButton!
    @IBOutlet var saveAndCancelButtons: [UIButton]!
    
    //MARK: - Private Properties
    private let myColors = MyColors.allCases
    private var defaultColor = UIColor.init(red: 0.9, green: 0.3, blue: 0.4, alpha: 1)

    //MARK: - Live Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        setUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - Ovrride Methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }

    //MARK: - IBAction
    @IBAction func saveTaskList() {
        let taskList = TaskList()
        taskList.name = nameTextField.text ?? ""
        taskList.redColor = Float(chooseColorButton.backgroundColor?.cgColor.components?[0] ?? 0.1)
        taskList.greenColor = Float(chooseColorButton.backgroundColor?.cgColor.components?[1] ?? 0.1)
        taskList.blueColor = Float(chooseColorButton.backgroundColor?.cgColor.components?[2] ?? 0.1)

        StorageManager.shared.save(list: taskList)
        dismiss(animated: true)
    }

    @IBAction func cancelButtonPress() {
        dismiss(animated: true)
    }

    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        if seg.source is ColorCollectionViewController {
            if let senderVC = seg.source as? ColorCollectionViewController {
                if senderVC.isChecked {
                    defaultColor = senderVC.newColor
                    chooseColorButton.backgroundColor = defaultColor
                    view.backgroundColor = defaultColor
                }
            }
        }
    }
    
    //MARK: - Private Methods
    private func setUI() {
        changeColorsAndRadius()
        setUIForTextField()
    }
    private func setUIForTextField() {
        nameTextField.layer.borderWidth = 0.2
        nameTextField.layer.cornerRadius = 5
        nameTextField.layer.borderColor = UIColor.init(named: "blackColor")?.cgColor

        nameTextField.attributedPlaceholder = NSAttributedString(string: "TaskList Name",attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    private func changeColorsAndRadius() {
        defaultColor = myColors.randomElement()?.value ?? .brown
        view.backgroundColor = defaultColor
        chooseColorButton.backgroundColor = defaultColor
        chooseColorButton.layer.cornerRadius = chooseColorButton.frame.width / 2

        for button in saveAndCancelButtons {
            button.layer.cornerRadius = button.frame.height / 2
        }
    }
}

//MARK: - TextField
extension AddTaskListsViewController: UITextFieldDelegate {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            textField.resignFirstResponder()
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.init(named: "textFieldColorWhite")
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = .clear
    }
}
