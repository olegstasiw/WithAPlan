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

    //MARK: - Private Properties
    private var sortedPlanList = StorageManager.shared.realm.objects(TaskList.self)
    private let planList = StorageManager.shared.realm.objects(TaskList.self)
    private var charactersCount = 0
    let myButton = UIButton()
    let myView = UIView()

    var anchor: NSLayoutConstraint?
    var anchor2: NSLayoutConstraint?

    //MARK: - Live Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        appointDelegates()
        registerCell()
        setUI()

        navigationController?.navigationBar.prefersLargeTitles = false

        view.addSubview(myView)
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        myView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        myView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        myView.widthAnchor.constraint(equalToConstant: view.frame.width ).isActive = true
        myView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        myView.addSubview(searchBar)

        myButton.setTitle("+", for: .normal)

        myButton.backgroundColor = .systemGreen

        myView.addSubview(myButton)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        myButton.translatesAutoresizingMaskIntoConstraints = false
        searchBar.leadingAnchor.constraint(equalTo: myView.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: myButton.trailingAnchor, constant: -50).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: myView.bottomAnchor).isActive = true
//        searchBar.widthAnchor.constraint(equalToConstant: myView.frame.width - 100).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true

        anchor = myButton.trailingAnchor.constraint(equalTo: myView.trailingAnchor)
        anchor2 = myButton.trailingAnchor.constraint(equalTo: myView.trailingAnchor, constant: 50)
        anchor?.isActive = true

        myButton.bottomAnchor.constraint(equalTo: myView.bottomAnchor).isActive = true
        myButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        myButton.widthAnchor.constraint(equalToConstant: 50).isActive = true

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        print(self.tasksTableView.frame.origin.y)
        print(self.view.frame.origin.y)

        searchBar.searchTextField.clearButtonMode = .never
//        myButton.layer.cornerRadius = 25
//        searchBar.backgroundColor = .clear
//        searchBar.layer.cornerRadius = 25
    }

//    @objc func keyboardWillShow(sender: NSNotification) {
//        let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//        self.view.frame.origin.y -= (keyboardSize?.height ?? 0) - 50
//        self.myButton.frame.origin.x += myButton.frame.width
//
//
//
//
//    }
//    @objc func keyboardWillHide(sender: NSNotification) {
//        self.view.frame.origin.y = 0
//        self.myButton.frame.origin.x -= myButton.frame.width
//
//    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {

                self.view.frame.origin.y -= keyboardSize.height - 50
                self.tasksTableView.frame.origin.y += keyboardSize.height - 50
                self.myButton.frame.origin.x += myButton.frame.width

                anchor?.isActive = false
                anchor2?.isActive = true
                print(self.tasksTableView.frame.origin.y)
                print(self.view.frame.origin.y)

//                UIView.animate(withDuration: 5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
//                    self.view.constraints.forEach { constraint in
//                        if constraint.firstAttribute == .top {
//                            constraint.constant = keyboardSize.height / 2 + 20
//
//                        }
//                    }
//                }



//                navigationController?.navigationBar.prefersLargeTitles = false
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {

        if self.view.frame.origin.y != 0 {


            self.view.frame.origin.y = 0
            self.tasksTableView.frame.origin.y = 92
            self.myButton.frame.origin.x -= myButton.frame.width
            anchor2?.isActive = false
            anchor?.isActive = true
            print(self.tasksTableView.frame.origin.y)
            print(self.view.frame.origin.y)
//            view.constraints.forEach { constraint in
//                if constraint.firstAttribute == .top {
//                    constraint.constant -= (keyboardSize?.height ?? 0) / 2 + 20
//                }
//            }



//            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.applicationIconBadgeNumber = 0
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
            let segueViewController = segue.destination as! TaskTableViewController
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
//        navigationItem.titleView = searchBar

        view.backgroundColor = .systemGroupedBackground

        navigationController?.navigationBar.tintColor = UIColor.init(named: "barColor");
        navigationController?.navigationBar.barTintColor = UIColor.init(named: "backgroundColor")
        navigationController?.navigationBar.barStyle = UIBarStyle.default;
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

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.text = ""
        sortedPlanList = planList
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
            tableView.reloadData()
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
            searchBar.endEditing(true)
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


//        if searchText.isEmpty {
//               DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                   searchBar.resignFirstResponder()
//               }
//           }

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



