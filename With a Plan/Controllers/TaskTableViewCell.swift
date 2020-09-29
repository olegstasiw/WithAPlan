//
//  TaskTableViewCell.swift
//  With a Plan
//
//  Created by mac on 19.07.2020.
//  Copyright © 2020 Oleg Stasiw. All rights reserved.
//

import UIKit
import RealmSwift

class TaskTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskNoteLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var reminderImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        colorView.layer.cornerRadius = colorView.frame.height / 2
        checkImageView.isHidden = true

    }

    //MARK: - Public Methods
    func configure(with task: Task) {

        if Date() > task.reminder {
            StorageManager.shared.editeReminder(task: task, isReminder: false)
        }

        reminderImage.isHidden = task.isReminder ? false : true
        checkImageView.isHidden = task.isComplete ? false : true

        taskNameLabel.text = task.name
        taskNoteLabel.text = task.note

        colorView.backgroundColor = UIColor(red: CGFloat(task.redColor), green: CGFloat(task.greenColor), blue: CGFloat(task.blueColor), alpha: 1)
    }
}
