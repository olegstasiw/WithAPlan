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

    //MARK: - Live Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        appointDelegates()
        registerCell()
        setUI()
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
        navigationItem.titleView = searchBar

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



