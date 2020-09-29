//
//  AddTaskViewController.swift
//  With a Plan
//
//  Created by mac on 19.07.2020.
//  Copyright © 2020 Oleg Stasiw. All rights reserved.
//

import UIKit
import RealmSwift

class AddTaskViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var selectDateStack: UIStackView!
    @IBOutlet weak var selectTimeStack: UIStackView!

    @IBOutlet var saveAndCancelButtons: [UIButton]!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var chooseColorButton: UIButton!
    @IBOutlet weak var reminderSwitch: UISwitch!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewScreen: UIView!
    @IBOutlet weak var colorView: UIView!

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!

    //MARK: - Public Properties
    var currentList: TaskList!

    //MARK: - Private Properties
    private let myColors = MyColors.allCases
    private let notifications = Notifications()
    private var defaultColor = UIColor.init(red: 0.9, green: 0.3, blue: 0.4, alpha: 1)
    private var changedDate = Date()

    //MARK: - Live Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        appointDelegates()
        setMainScreen()
        setUI()

        makeDateFormatterTo(date: changedDate)
        addDoneButtonTo(noteTextView)

        addTouchForCloseKeyboard()

        createObserver()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUIForTextView()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUIForTextView()
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "chooseColorSegue") {
            let segueViewController = segue.destination as! ColorCollectionViewController
            segueViewController.someColor = defaultColor
        } else {
            let segueViewController = segue.destination as! ChooseDateViewController
            segueViewController.date = changedDate
            segueViewController.buttonIsHidden = true
            segueViewController.mainButtonIsHidden = false
        }
    }

    //MARK: - Ovrride Methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }

    //MARK: - IBAction
    @IBAction func saveTask() {

        let oneTask = createTask()

        if nameTextField.text == "" {
            showAlert()
        } else  {
            if oneTask.isReminder {
                if Date() > changedDate {
                    showAlertWithAction(task: oneTask)
                } else {
                    let task = createTask()
                    StorageManager.shared.save(task: task, into: self.currentList)

                    self.notifications.scheduleNotification(notifaicationType: task.name, task: task)

                    dismiss(animated: true)
                }
            }
            else {
                let task = createTask()
                StorageManager.shared.save(task: task, into: self.currentList)
                dismiss(animated: true)
            }
        }
    }

    @IBAction func cancelButton() {
        dismiss(animated: true)
    }
    
    
    @IBAction func reminderSwitchOnOff(_ sender: UISwitch) {
        if sender.isOn {

            notifications.requestAutorization(
                completionOn: {
                    DispatchQueue.main.async {
                        self.hideElements(bool: false)
                    }
                },
                completion: {
                    DispatchQueue.main.async {
                        self.showAlertWithTwoAction(swicher: sender)
                    }
                })

        } else {
            hideElements(bool: true)
        }
    }

    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        if seg.source is ColorCollectionViewController {
            if let senderVC = seg.source as? ColorCollectionViewController {
                if senderVC.isChecked {
                    defaultColor = senderVC.newColor
                    chooseColorButton.backgroundColor = defaultColor
                    view.backgroundColor = defaultColor
                    colorView.backgroundColor = defaultColor
                }
            }
        }
    }

    @IBAction func unwindDate( _ seg: UIStoryboardSegue) {
        if seg.source is ChooseDateViewController {
            if let senderVC = seg.source as? ChooseDateViewController {

                changedDate = senderVC.chooseDatePicker.date
                makeDateFormatterTo(date: changedDate)
            }
        }
    }

    //MARK: - Private Methods
    private func setMainScreen() {
        let sizze  = CGSize(width: view.frame.width, height: view.frame.height)
        viewScreen.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = sizze.height
            }
        }
    }

    private func appointDelegates() {
        nameTextField.delegate = self
        noteTextView.delegate = self
    }

    private func makeDateFormatterTo(date: Date) {
        let timeFormatter = DateFormatter()
        let dateFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeFormatter.dateStyle = .none
        dateFormatter.dateStyle = .long
        timeLabel.text = timeFormatter.string(from: date)
        dateLabel.text = dateFormatter.string(from: date)
    }

    private func setUI() {
        setUIForTextField()
        setUIForTextView()
        hideElements(bool: true)
        changeColorsAndRadius()
    }

    private func setUIForTextField() {
        nameTextField.layer.borderWidth = 0.2
        nameTextField.layer.cornerRadius = 5
        nameTextField.layer.borderColor = UIColor.init(named: "blackColor")?.cgColor

        nameTextField.attributedPlaceholder = NSAttributedString(string: "Task Name",attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }

    private func setUIForTextView() {
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        noteTextView.isScrollEnabled = false

        noteTextView.layer.borderWidth = 0.2
        noteTextView.layer.cornerRadius = 5
        noteTextView.layer.borderColor = UIColor.init(named: "barColor")?.cgColor
    }

    private func changeColorsAndRadius() {
        defaultColor = myColors.randomElement()?.value ?? .brown


        chooseColorButton.backgroundColor = defaultColor
        colorView.backgroundColor = defaultColor
        view.backgroundColor = defaultColor

        for button in saveAndCancelButtons {
            button.layer.cornerRadius = button.frame.height / 2
        }
        chooseColorButton.layer.cornerRadius = chooseColorButton.frame.width / 2
    }

    func hideElements(bool: Bool) {
        selectDateStack.isHidden = bool
        selectTimeStack.isHidden = bool
        changeButton.isHidden = bool
    }

    private func addTouchForCloseKeyboard() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(recognizer)
    }

    @objc private func touch() {
        self.view.endEditing(true)
    }

    private func createTask() -> Task {
        let name = nameTextField.text ?? ""
        let note = noteTextView.text ?? ""

        let redColor = Float(chooseColorButton.backgroundColor?.cgColor.components?[0] ?? 0.1)
        let greenColor = Float(chooseColorButton.backgroundColor?.cgColor.components?[1] ?? 0.1)
        let blueColor = Float(chooseColorButton.backgroundColor?.cgColor.components?[2] ?? 0.1)

        let reminder = reminderSwitch.isOn ? changedDate : Date()
        let isReminder = reminderSwitch.isOn ? true : false
        let id = UUID().uuidString

        let task = Task(value: [name, note, redColor, greenColor, blueColor, reminder, isReminder, id])
        return task
    }

    private func createObserver() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedFromBackground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    @objc private func appMovedFromBackground() {
        DispatchQueue.main.async {
            self.noteTextView.layer.borderColor = UIColor.init(named: "barColor")?.cgColor

        }
    }
}

//MARK: - TextField
extension AddTaskViewController: UITextFieldDelegate {

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

//MARK: - TextView
extension AddTaskViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = noteTextView.sizeThatFits(size)
        noteTextView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        let sizze  = CGSize(width: view.frame.width, height: view.frame.height)
        viewScreen.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height + sizze.height
            }
        }
    }

    private func addDoneButtonTo(_ textViews: UITextView...) {
        textViews.forEach { textView in
            let keyboardToolbar = UIToolbar()
            textView.inputAccessoryView = keyboardToolbar
            keyboardToolbar.sizeToFit()

            let doneButton = UIBarButtonItem(title:"Done",
                                             style: .done,
                                             target: self,
                                             action: #selector(didTapDone))
            doneButton.tintColor = UIColor.init(named: "barColor")

            let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                target: nil,
                                                action: nil)

            keyboardToolbar.items = [flexBarButton, doneButton]
        }
    }

    @objc private func didTapDone() {
        view.endEditing(true)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = UIColor.init(named: "textFieldColor")
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = .clear
    }
}

//MARK: - ALERT
extension AddTaskViewController {

    private func showAlert() {
        let alert = AlertController(title: "Warning", message: "Your task name is empty. Enter a name.", preferredStyle: UIAlertController.Style.alert)
        alert.actionWithoutAction()
        self.present(alert, animated: true)
    }

    private func showAlertWithAction(task: Task) {
        let alert = AlertController(title: "Warning", message: "You cannot set a reminder for a time that is less than the current time.", preferredStyle: UIAlertController.Style.alert)
        alert.action(firstTitle: "Disable reminder", secondTitle: "Change time") {
            let reminder = Date()
            let isReminder = false
            task.reminder = reminder
            task.isReminder = isReminder
            StorageManager.shared.save(task: task, into: self.currentList)
            self.dismiss(animated: true)
        }
        self.present(alert, animated: true)
    }

    private func showAlertWithTwoAction(swicher: UISwitch) {
        let alert = AlertController(title: "Unable to use notifications",
                                    message: "To enable notifications, go to Settings and enable notifications for this app.",
                                    preferredStyle: UIAlertController.Style.alert)


        alert.action(firstTitle: "Ok", secondTitle: "Settings") {

        } completionTwo: {
            swicher.setOn(false, animated: true)

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                })
            }
        }
        self.present(alert, animated: true)
    }
}
