//
//  StorageManager.swift
//  With a Plan
//
//  Created by mac on 22.07.2020.
//  Copyright © 2020 Oleg Stasiw. All rights reserved.
//

import RealmSwift

class StorageManager {
    static let shared = StorageManager()

    let realm = try! Realm()

    private init() {}

    func save(list: TaskList) {
        write {
            realm.add(list)
        }
    }
    
    func save(task: Task, into taskList: TaskList) {
        write {
            taskList.tasks.append(task)
        }
    }
    
    func done(taskList: TaskList) {
        write {
            taskList.tasks.setValue(true, forKey: "isComplete")
        }
    }

    func done(task: Task) {
        write {
            task.isComplete.toggle()
        }
    }

    func done(task: Task, isDone: Bool) {
        write {
            task.isComplete = isDone
        }
    }

    func delete(taskList: TaskList) {
        write {
            realm.delete(taskList.tasks)
            realm.delete(taskList)
        }
    }


    func delete(task: Task) {
        write {
            realm.delete(task)
        }
    }

    func changeDate(task: Task) {
        write {
            task.date = Date()
        }
    }

    func edit(task: Task, name: String, note: String, isReminder: Bool, reminder: Date) {
        write {
            task.name = name
            task.note = note
            task.isReminder = isReminder
            task.reminder = reminder
        }
    }

    func editeReminder(task: Task, isReminder: Bool) {
        write {
            task.isReminder = isReminder
        }
    }

    func editColor(task: Task, color: UIColor) {
        write {
            task.redColor = Float(color.cgColor.components?[0] ?? 0.1)
            task.greenColor = Float(color.cgColor.components?[1] ?? 0.1)
            task.blueColor = Float(color.cgColor.components?[2] ?? 0.1)
        }
    }

    func edit(taskList: TaskList, name: String) {
        write {
            taskList.name = name
        }
    }

    func editColor(taskList: TaskList, color: UIColor) {
        write {
            taskList.redColor = Float(color.cgColor.components?[0] ?? 0.1)
            taskList.greenColor = Float(color.cgColor.components?[1] ?? 0.1)
            taskList.blueColor = Float(color.cgColor.components?[2] ?? 0.1)
        }
    }

    private func write(_ completion:() -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch let error {
            print(error)
        }
    }

}
