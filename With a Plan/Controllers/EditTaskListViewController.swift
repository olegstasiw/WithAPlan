//
//  EditTaskListViewController.swift
//  With a Plan
//
//  Created by mac on 19.09.2020.
//  Copyright © 2020 Oleg Stasiw. All rights reserved.
//

import UIKit

class EditTaskListViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet var saveAndCancelButtons: [UIButton]!

    //MARK: - Public Properties
    var tasklist: TaskList!
    var myColor: UIColor!

    //MARK: - Live Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
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
    @IBAction func cancelButtonPress(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func saveButtonPress(_ sender: Any) {
        StorageManager.shared.edit(taskList: tasklist, name: nameTextField.text ?? "")
        StorageManager.shared.editColor(taskList: tasklist, color: myColor)
        dismiss(animated: true)
    }

    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        if seg.source is ColorCollectionViewController {
            if let senderVC = seg.source as? ColorCollectionViewController {
                if senderVC.isChecked {
                    myColor = senderVC.newColor
                    view.backgroundColor = myColor
                    colorButton.backgroundColor = myColor
                } 
            }
        }
    }
    
    //MARK: - Private Methods
    private func setUI() {
        myColor = UIColor.init(red: CGFloat(tasklist.redColor),
                               green: CGFloat(tasklist.greenColor),
                               blue: CGFloat(tasklist.blueColor),
                               alpha: 1)
        view.backgroundColor = myColor
        colorButton.backgroundColor = myColor

        setTextFieldUI()
        changeRadius()
    }
    private func setTextFieldUI() {
        nameTextField.delegate = self
        nameTextField.text = tasklist.name
        nameTextField.layer.borderWidth = 0.2
        nameTextField.layer.cornerRadius = 5
        nameTextField.layer.borderColor = UIColor.init(named: "blackColor")?.cgColor
    }
    private func changeRadius() {
        colorButton.layer.cornerRadius = colorButton.frame.height / 2
        for button in saveAndCancelButtons {
            button.layer.cornerRadius = button.frame.height / 2
        }
    }
}

//MARK: - TextField
extension EditTaskListViewController: UITextFieldDelegate {

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
