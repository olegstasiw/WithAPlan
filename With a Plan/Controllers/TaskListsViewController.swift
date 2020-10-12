//
//  TaskListsViewController.swift
//  With a Plan
//
//  Created by mac on 19.07.2020.
//  Copyright © 2020 Oleg Stasiw. All rights reserved.
//

import UIKit
import RealmSwift

class TaskListsViewController: UIViewController{

    //MARK: - IBOutlets
    @IBOutlet weak var tasksTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var addButton: UIButton!

    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heigthFromViewToSearch: NSLayoutConstraint!

    //MARK: - Private Properties
    private var sortedPlanList = StorageManager.shared.realm.objects(TaskList.self)
    private let planList = StorageManager.shared.realm.objects(TaskList.self)
    private var charactersCount = 0

    //MARK: - Live Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        appointDelegates()
        registerCell()
        setUI()
        createObserver()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.applicationIconBadgeNumber = 0
        sortedPlanList = planList
        tasksTableView.reloadData()
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "changeListSegue" {
            let navigation = segue.destination as! UINavigationController
            let segueViewController = navigation.topViewController as! EditTaskListViewController
            let taskList = sender as? TaskList
            segueViewController.tasklist = taskList
        } else {
            guard let indexPath = tasksTableView.indexPathForSelectedRow else { return }
            let taskList = sortedPlanList[indexPath.row]
            let segueViewController = segue.destination as! TaskViewController
            segueViewController.currentList = taskList
        }
    }

    //MARK: - Private Methods
    private func appointDelegates() {
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        searchBar.delegate = self
    }

    private func registerCell() {
        tasksTableView.register(TaskListsTableViewCell.self, forCellReuseIdentifier: "TaskListsTableViewCell")
        tasksTableView.register(UINib(nibName: "TaskListsTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskListsTableViewCell")
    }

    private func setUI() {
        view.backgroundColor = .systemGroupedBackground

        navigationController?.navigationBar.tintColor = UIColor.init(named: "barColor");
        navigationController?.navigationBar.barTintColor = UIColor.init(named: "backgroundColor")
        navigationController?.navigationBar.barStyle = UIBarStyle.default;
        setUIForSearchView()
    }

    private func setUIForSearchView() {
        searchView.layer.cornerRadius = searchView.frame.height / 2
        searchView.backgroundColor = .systemGray4
        searchBar.layer.borderColor = UIColor.systemGray4.cgColor
        searchBar.searchTextField.backgroundColor = UIColor.systemGray4
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.layer.borderWidth = 1
        UISearchBar.appearance().tintColor = UIColor.init(named: "barColor")

        addButton.backgroundColor = UIColor.systemGray4
        addButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        addButton.layer.cornerRadius = addButton.frame.height / 3

    }

    private func createObserver() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedFromBackground), name: UIApplication.willEnterForegroundNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func appMovedFromBackground() {
        DispatchQueue.main.async {
            self.searchBar.layer.borderColor = UIColor.systemGray4.cgColor
        }
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if heigthFromViewToSearch.constant == 50 {

                searchView.layer.cornerRadius = 0
                heigthFromViewToSearch.constant = keyboardSize.height
                searchViewWidthConstraint.constant = view.frame.width
                buttonWidthConstraint.constant = 0
                addButton.imageEdgeInsets = UIEdgeInsets(top: 0 , left: 0, bottom: 0, right: 0)

                UIView.animate(withDuration: 0.33,
                               delay: 0,
                               options: .curveEaseIn) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            if heigthFromViewToSearch.constant == keyboardSize.height {

                searchView.layer.cornerRadius = searchView.frame.height / 2
                heigthFromViewToSearch.constant = 50
                searchViewWidthConstraint.constant = 250
                buttonWidthConstraint.constant = 50
                addButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)

                UIView.animate(withDuration: 0.33,
                               delay: 0,
                               options: .curveEaseIn) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }

}

//MARK: - Table View Data Source
extension TaskListsViewController: UITableViewDelegate, UITableViewDataSource  {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedPlanList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListsTableViewCell", for: indexPath) as! TaskListsTableViewCell
        let taskList = sortedPlanList[indexPath.row]
        cell.configure(with: taskList)

        cell.make = {
            let currentList = self.sortedPlanList[indexPath.row]
            StorageManager.shared.done(taskList: currentList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        searchBar.text = ""
        searchBarTextDidEndEditing(searchBar)
        searchBar.endEditing(true)
        performSegue(withIdentifier: "tasksSegue", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let currentList = sortedPlanList[indexPath.row]

        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Delete") { (_, _, complete) in

            self.showAlert(taskList: currentList, at: indexPath)
            complete(true)
        }

        let editAction = UIContextualAction(style: .normal,
                                            title: "Edit") { (_, _, isDone) in
            self.performSegue(withIdentifier: "changeListSegue", sender: currentList)
            self.searchBar.text = ""
            self.sortedPlanList = self.planList
            tableView.reloadData()
            isDone(true)
        }

        editAction.backgroundColor = .orange

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let currentList = sortedPlanList[indexPath.row]
        let doneAction = UIContextualAction(style: .normal,
                                            title: "Done") { (_, _, isDone) in

            StorageManager.shared.done(taskList: currentList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            isDone(true)
        }

        doneAction.backgroundColor = .systemGreen

        return UISwipeActionsConfiguration(actions: [doneAction])
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}

//MARK: - SearchBar
extension TaskListsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        sortedPlanList = planList
        tasksTableView.reloadData()
        self.searchBar.endEditing(true)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            sortedPlanList = planList
            tasksTableView.reloadData()
            return
        }

        if searchText.count > charactersCount {
            sortedPlanList = sortedPlanList.filter("name CONTAINS[c] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
            charactersCount += 1
        } else {
            sortedPlanList = planList
            sortedPlanList = sortedPlanList.filter("name CONTAINS[c] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
            charactersCount -= 1
        }

        if searchBar.text?.count == 0 {

            TaskListsViewController.load()

            DispatchQueue.main.async {
                searchBar.endEditing(true)
                searchBar.resignFirstResponder()
            }
        }

        tasksTableView.reloadData()
    }
}

//MARK: ALERT
extension TaskListsViewController {

    private func showAlert(taskList: TaskList, at indexPath: IndexPath) {
        let alert = AlertController(title: "Warning", message: "Do you want to delete this list?", preferredStyle: UIAlertController.Style.alert)
        alert.action(firstTitle: "Yes", secondTitle: "No") {

            let allTask = taskList.tasks
            for task in allTask {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id])
            }

            StorageManager.shared.delete(taskList: taskList)
            self.tasksTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        self.present(alert, animated: true)
    }
}




