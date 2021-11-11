//
//  ViewController.swift
//  ToDo
//
//  Created by Lyudmila Platonova on 8.11.21.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tasksTableView: UITableView!
    @IBOutlet weak var tasksTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var tasksList = Task.fetchAll()
    var enteredTask = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        tasksTextField.delegate = self
        addButton.layer.cornerRadius = 6.0
        tasksTableView.rowHeight = 40.0
        tasksTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
    }

    @IBAction func addNewTask(_ sender: UIButton) {
        addATask()
    }
    
    @IBAction func resetTasks(_ sender: UIBarButtonItem) {
        deleteAllTasks()
    }
    
    private func addATask() {
        self.enteredTask = tasksTextField.text!
        saveTask(named: self.enteredTask)
        self.tasksList = Task.fetchAll()
        tasksTableView.reloadData()
        tasksTextField.text = ""
    }
    
    private func saveTask(named name: String) {
        let task = Task(context: AppDelegate.viewContext)
        task.taskName = name
        task.isFinished = false
        try? AppDelegate.viewContext.save()
    }
    
    private func deleteAllTasks() {
        Task.deleteAll()
        tasksList = Task.fetchAll()
        tasksTableView.reloadData()
    }
    
    
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as? TableViewCell else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.selectionStyle = .none
            return cell
        }
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        let currentTask = tasksList[indexPath.row]
        let attributedString = NSMutableAttributedString(string: currentTask.taskName ?? "Error")
        if !currentTask.isFinished {
            cell.adjustCell(imageSystemName: "minus", tintColor: #colorLiteral(red: 0.9434493094, green: 0.2707911035, blue: 0.2124529079, alpha: 1), text: attributedString)
        } else {
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
            cell.adjustCell(imageSystemName: "checkmark", tintColor: #colorLiteral(red: 0.2273788435, green: 0.6532184746, blue: 0.1123306466, alpha: 1), text: attributedString)
        }
        return cell
    }
    
    
}


extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            let context = AppDelegate.viewContext
            context.delete(self.tasksList[indexPath.row] as NSManagedObject)
            try? context.save()
            tableView.beginUpdates()
            self.tasksList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
        deleteAction.image = UIImage(systemName: "trash")
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: "Done") {  (contextualAction, view, boolValue) in
            let currentTask = self.tasksList[indexPath.row]
            if !currentTask.isFinished {
                currentTask.isFinished = true
            } else {
                currentTask.isFinished = false
            }
            self.tasksTableView.reloadData()
        }
        if !tasksList[indexPath.row].isFinished {
            doneAction.image = UIImage(systemName: "checkmark")
            doneAction.backgroundColor = #colorLiteral(red: 0.2273788435, green: 0.6532184746, blue: 0.1123306466, alpha: 0.5960368984)
        } else {
            doneAction.image = UIImage(systemName: "xmark")
            doneAction.backgroundColor = #colorLiteral(red: 0.9434493094, green: 0.2707911035, blue: 0.2124529079, alpha: 0.5964967841)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [doneAction])
        return swipeActions
    }
    
    
}


extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        for textField in self.view.subviews where textField is UITextField {
            textField.resignFirstResponder()
        }
        self.view.endEditing(true)
        return true
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
