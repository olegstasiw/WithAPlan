//
//  DetailTaskViewController.swift
//  With a Plan
//
//  Created by mac on 12.08.2020.
//  Copyright © 2020 Oleg Stasiw. All rights reserved.
//

import UIKit

class DetailTaskViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var hidenStacks: [UIStackView]!

    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!

    @IBOutlet weak var reminderDate: UILabel!
    @IBOutlet weak var reminderTime: UILabel!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewScreen: UIView!
    @IBOutlet weak var colorView: UIView!

    @IBOutlet weak var changeColorButton: UIButton!
    @IBOutlet weak var changeButtonH: UIButton!
    @IBOutlet weak var makeTaskDoneButton: UIButton!
    @IBOutlet var doneAndCancelButtons: [UIButton]!

    @IBOutlet weak var reminderSwitch: UISwitch!

    //MARK: - Public Properties
    var task: Task!
    var modifyDate: Date!

    //MARK: - Private Properties
    private let notification = Notifications()
    private var isDone: Bool!
    private var defaultColor = UIColor.init(red: 0.9, green: 0.3, blue: 0.4, alpha: 1)
    private var isReminder: Bool!

    //MARK: - Live Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        taskNameTextField.delegate = self
        noteTextView.delegate = self

        initAllProperties()
        setUI()
        createObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "changeDate") {
            let segueViewController = segue.destination as! ChooseDateViewController
            segueViewController.date = modifyDate
            segueViewController.mainButtonIsHidden = true
            segueViewController.buttonIsHidden = false
        }
    }


    //MARK: - Ovrride Methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }

    //MARK: - IBAction
    @IBAction func doneButtonPress(_ sender: Any) {

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id])

        if taskNameTextField.text == "" {
            showAlert()
        } else {
            if isReminder {
                if  Date() > modifyDate {
                    showAlertWithAction(task: task,
                                        color: defaultColor,
                                        name: taskNameTextField,
                                        note: noteTextView,
                                        isDone: isDone)
                }
                else {
                    StorageManager.shared.edit(task: task,
                                               name: taskNameTextField.text ?? "" ,
                                               note: noteTextView.text,
                                               isReminder: isReminder,
                                               reminder: modifyDate)
                    StorageManager.shared.editColor(task: task, color: defaultColor)
                    StorageManager.shared.done(task: task, isDone: isDone)

                    self.notification.scheduleNotification(notifaicationType: task.name, task: task)

                    dismiss(animated: true)
                }
            } else {
                StorageManager.shared.edit(task: task,
                                           name: taskNameTextField.text ?? "" ,
                                           note: noteTextView.text,
                                           isReminder: isReminder,
                                           reminder: modifyDate)
                StorageManager.shared.editColor(task: task, color: defaultColor)
                StorageManager.shared.done(task: task, isDone: isDone)
                dismiss(animated: true)
            }
        }
    }
    @IBAction func makeTaskDoneButtonPress() {
        pressDoneButton()
    }

    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction func reminderSwitcher(_ sender: UISwitch) {
        if sender.isOn {
            hideElements(bool: false)
            isReminder = true
        } else {
            hideElements(bool: true)
            isReminder = false
        }
    }

    @IBAction func unwindTime( _ seg: UIStoryboardSegue) {
        if seg.source is ChooseDateViewController {
            if let senderVC = seg.source as? ChooseDateViewController {
                modifyDate = senderVC.chooseDatePicker.date
                makeDateFormatterTo(date: modifyDate)
            }
        }
    }

    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        if seg.source is ColorCollectionViewController {
            if let senderVC = seg.source as? ColorCollectionViewController {
                if senderVC.isChecked {
                    defaultColor = senderVC.newColor
                    setMainColor(color: defaultColor)
                }
            }
        }
    }

    //MARK: - Private Methods

    private func pressDoneButton() {
        if isDone {
            makeTaskDoneButton.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            makeTaskDoneButton.setTitle("Meke done", for: .normal)
            isDone = false
        } else {
            makeTaskDoneButton.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            makeTaskDoneButton.setTitle("Make not done", for: .normal)
            isDone = true
        }
    }

    private func hideElements(bool: Bool) {
        for stack in hidenStacks {
            stack.isHidden = bool
        }
        changeButtonH.isHidden = bool
    }

    private func makeDateFormatterTo(date: Date) {
        let timeFormatter = DateFormatter()
        let dateFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeFormatter.dateStyle = .none
        dateFormatter.dateStyle = .long
        reminderTime.text = timeFormatter.string(from: date)
        reminderDate.text = dateFormatter.string(from: date)

    }

    private func setUI() {
        makeDoneButtonUI()
        textViewDidChange(noteTextView)
        addDoneButtonTo(noteTextView)
        addTouchForCloseKeyboard()

        setMainColor(color: defaultColor)
        setRadius()
        setUIForTextView()
        setUIForTextField()
    }

    private func initAllProperties() {
        defaultColor = UIColor.init(red: CGFloat(task.redColor),
                                    green: CGFloat(task.greenColor),
                                    blue: CGFloat(task.blueColor),
                                    alpha: 1)
        taskNameTextField.text = task.name
        noteTextView.text = task.note
        isReminder = task.isReminder
        reminderSwitch.setOn(task.isReminder, animated: false)
        makeDateFormatterTo(date: task.reminder)
        hideElements(bool: !task.isReminder)
        isDone = task.isComplete
    }

    private func setUIForTextField() {
        taskNameTextField.layer.borderWidth = 0.2
        taskNameTextField.layer.cornerRadius = 5
        taskNameTextField.layer.borderColor = UIColor.init(named: "blackColor")?.cgColor

        taskNameTextField.attributedPlaceholder = NSAttributedString(string: "Task Name",attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }

    private func setUIForTextView() {
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        noteTextView.isScrollEnabled = false

        noteTextView.layer.borderWidth = 0.2
        noteTextView.layer.cornerRadius = 5
        noteTextView.layer.borderColor = UIColor.init(named: "barColor")?.cgColor

        noteTextView.backgroundColor = .clear
    }


    private func setMainColor(color: UIColor) {
        changeColorButton.backgroundColor = color
        view.backgroundColor = color
        colorView.backgroundColor = color
    }

    private func setRadius() {
        changeColorButton.layer.cornerRadius = changeColorButton.frame.width / 2
        for button in doneAndCancelButtons {
            button.layer.cornerRadius = button.frame.height / 2
        }
    }

    private func makeDoneButtonUI() {
        if isDone {
            makeTaskDoneButton.setTitle("Make not done", for: .normal)
            makeTaskDoneButton.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)

        } else {
            makeTaskDoneButton.setTitle("Make done", for: .normal)
            makeTaskDoneButton.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        }
    }

    private func addTouchForCloseKeyboard() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(recognizer)
    }

    @objc func touch() {
        self.view.endEditing(true)
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

//MARK: - TextView
extension DetailTaskViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = UIColor.init(named: "textFieldColor")
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = .clear
    }

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
}

//MARK: - TextField
extension DetailTaskViewController: UITextFieldDelegate {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == taskNameTextField {
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

//MARK: - ALERT
extension DetailTaskViewController {

    private func showAlert() {
        let alert = AlertController(title: "Увага", message: "Назва вашого таску пуста. Введіть назву!", preferredStyle: UIAlertController.Style.alert)
        alert.actionWithoutAction()
        self.present(alert, animated: true)
    }

    private func showAlertWithAction(task: Task, color: UIColor, name: UITextField, note: UITextView, isDone: Bool) {
        let alert = AlertController(title: "Увага", message: "Ви не можете призначити нагадування на час який менший за теперішній! В минуле не повернешся.", preferredStyle: UIAlertController.Style.alert)
        alert.action(firstTitle: "Виключити нагадування", secondTitle: "Змінити час") {

            let newModifyDate = Date()
            let newIsReminder = false
            StorageManager.shared.edit(task: task, name: name.text ?? "" , note: note.text, isReminder: newIsReminder, reminder: newModifyDate)
            StorageManager.shared.editColor(task: task, color: color)
            StorageManager.shared.done(task: task, isDone: isDone)

            self.dismiss(animated: true)
        }
        self.present(alert, animated: true)
    }
}

