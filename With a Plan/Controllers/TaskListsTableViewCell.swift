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

    override func awakeFromNib() {
        super.awakeFromNib()
        colorView.layer.cornerRadius = colorView.frame.height / 2
    }

    //MARK: - Public Methods
    func configure(with taskList: TaskList) {
        let currentTasks = taskList.tasks.filter("isComplete = false")
        let completedTasks = taskList.tasks.filter("isComplete = true")

        if !currentTasks.isEmpty {
            accessoryType = .none
            checkImageView.isHidden = true
        } else if !completedTasks.isEmpty {
            checkImageView.isHidden = false
            accessoryType = .checkmark
        } else {
            accessoryType = .none
            checkImageView.isHidden = true
        }

        taskListNameLabel.text = taskList.name

        colorView.backgroundColor = UIColor(red: CGFloat(taskList.redColor),
                                            green: CGFloat(taskList.greenColor),
                                            blue: CGFloat(taskList.blueColor),
                                            alpha: 1)
    }
    
}
