//
//  TaskViewController.swift
//  With a Plan
//
//  Created by mac on 10.10.2020.
//  Copyright © 2020 Oleg Stasiw. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class TaskViewController: UIViewController {

    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!

    //MARK: - Public Properties
    var currentList: TaskList!

    //MARK: - Private Properties
    private var currentTasks: Results<Task>!
    private var completedTasks: Results<Task>!
    private var indexPathForCurrentTasks = IndexPath()
    private var indePathForCompletedTasks = IndexPath()
    private var destinationIndexRow = IndexPath()

    //MARK: - Live Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell()

        navigationItem.title = currentList.name

        currentTasks = currentList.tasks.filter("isComplete = false").sorted(byKeyPath: "date")
        completedTasks = currentList.tasks.filter("isComplete = true").sorted(byKeyPath: "date")

        taskTableView.delegate = self
        taskTableView.dataSource = self
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 29, bottom: 4, right: 29)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.applicationIconBadgeNumber = 0
        taskTableView.reloadData()
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "DetailTaskViewController" {
            let navigationController = segue.destination as! UINavigationController
            let currentViewController = navigationController.topViewController as! AddTaskViewController
            currentViewController.currentList = currentList
        }
        if (segue.identifier == "DetailTaskViewController") {
            guard let data = sender as? Task else { return }

            let navigationController = segue.destination as! UINavigationController
            let currentViewController = navigationController.topViewController as! DetailTaskViewController

            currentViewController.task = data
            currentViewController.modifyDate = data.reminder
        }
    }

    //MARK: - Private Methods
    private func registerCell() {
        taskTableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskTableViewCell")
        taskTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
    }
}

// MARK: - Table view data source
extension TaskViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? currentTasks.count : completedTasks.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell

        let task = indexPath.section == 0
            ? currentTasks[indexPath.row]
            : completedTasks[indexPath.row]

        cell.configure(with: task)
        
        cell.make = {

            self.indexPathForCurrentTasks = IndexPath(row: self.currentTasks.count , section: 0)
            self.indePathForCompletedTasks = IndexPath(row: self.completedTasks.count , section: 1)

            StorageManager.shared.done(task: task)

            self.destinationIndexRow = indexPath.section == 0
                ? self.indePathForCompletedTasks
                : self.indexPathForCurrentTasks

            UITableView.transition(with: self.taskTableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.taskTableView.reloadData()
            })

            StorageManager.shared.changeDate(task: task)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let task = indexPath.section == 0
            ? currentTasks[indexPath.row]
            : completedTasks[indexPath.row]

        self.performSegue(withIdentifier: "DetailTaskViewController", sender: task)
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let task = indexPath.section == 0
            ? currentTasks[indexPath.row]
            : completedTasks[indexPath.row]

        let doneAction = UIContextualAction(style: .normal,
                                            title: indexPath.section == 0 ? "Done" : "Return") { (_, _, isDone) in

            StorageManager.shared.done(task: task)

            self.indexPathForCurrentTasks = IndexPath(row: self.currentTasks.count - 1, section: 0)
            self.indePathForCompletedTasks = IndexPath(row: self.completedTasks.count - 1, section: 1)

            self.destinationIndexRow = indexPath.section == 0
                ? self.indePathForCompletedTasks
                : self.indexPathForCurrentTasks

            UITableView.transition(with: self.taskTableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.taskTableView.moveRow(at: indexPath, to: self.destinationIndexRow)
            })


            StorageManager.shared.changeDate(task: task)

            isDone(true)
        }

        doneAction.backgroundColor = indexPath.section == 0 ? #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1) : #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)

        return UISwipeActionsConfiguration(actions: [doneAction])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let task = indexPath.section == 0
            ? currentTasks[indexPath.row]
            : completedTasks[indexPath.row]

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, complete) in

            self.showAlert(task: task, indexPath: indexPath)
            complete(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

//MARK: - ALERT
extension TaskViewController {
    private func showAlert(task: Task, indexPath: IndexPath) {
        let alert = AlertController(title: "Warning", message: "Do you want to delete this task?", preferredStyle: UIAlertController.Style.alert)
        alert.action(firstTitle: "Yes", secondTitle: "No") {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id])
            StorageManager.shared.delete(task: task)
            self.taskTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        self.present(alert, animated: true)
    }
}
