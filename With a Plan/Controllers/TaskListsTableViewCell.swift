//
//  TaskListsTableViewCell.swift
//  With a Plan
//
//  Created by mac on 25.09.2020.
//  Copyright © 2020 Oleg Stasiw. All rights reserved.
//

import UIKit

class TaskListsTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var taskListNameLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var checkImageView: UIImageView!

    //MARK: - Public Properties
    var check : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colorView.layer.cornerRadius = colorView.frame.height / 2
    }

    //MARK: - IBAction
    @IBAction func checkButtonPress(_ sender: Any) {
        if let button = check {
            button()
        }
    }
    //MARK: - Public Methods
    func configure(with taskList: TaskList) {
        let currentTasks = taskList.tasks.filter("isComplete = false")
        let completedTasks = taskList.tasks.filter("isComplete = true")

        if !currentTasks.isEmpty {
            checkImageView.isHidden = true
        } else if !completedTasks.isEmpty {
            checkImageView.isHidden = false
        } else {
            checkImageView.isHidden = true
        }

        taskListNameLabel.text = taskList.name

        colorView.backgroundColor = UIColor(red: CGFloat(taskList.redColor),
                                            green: CGFloat(taskList.greenColor),
                                            blue: CGFloat(taskList.blueColor),
                                            alpha: 1)
    }

    
}
