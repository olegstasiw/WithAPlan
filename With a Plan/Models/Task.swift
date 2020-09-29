//
//  Task.swift
//  With a Plan
//
//  Created by mac on 19.07.2020.
//  Copyright © 2020 Oleg Stasiw. All rights reserved.
//

import RealmSwift

class Task: Object {
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var redColor: Float = 1
    @objc dynamic var greenColor: Float = 1
    @objc dynamic var blueColor: Float = 1
    @objc dynamic var reminder = Date()
    @objc dynamic var isReminder = false
    @objc dynamic var id = ""
    @objc dynamic var isComplete = false
    @objc dynamic var date = Date()
}

class TaskList: Object {
    @objc dynamic var name = ""
    @objc dynamic var redColor: Float = 1
    @objc dynamic var greenColor: Float = 1
    @objc dynamic var blueColor: Float = 1
    @objc dynamic var date = Date()
    var tasks = List<Task>()
}

