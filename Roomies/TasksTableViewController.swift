//
//  TasksTableViewController.swift
//  Roomies
//
//  Created by Mary Huerta on 1/22/17.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit
import CoreData

class TasksTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    let userCalendar = NSCalendar.current
    
    var tasks: [Task] = []
    var fetchResultController: NSFetchedResultsController<TaskMO>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        BaseViewControllerUtil.setup(viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "TaskCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TaskTableViewCell
     
     // Configure the cell...
        
        let task = tasks[indexPath.row]
        
        
        var str: String!
        
        if let due = task.dueDate {
            let timeDelta = Int(due.timeIntervalSince(Date()))
            let dueMinutes = timeDelta / 60
            let dueHours = dueMinutes / 60
            let dueDays = dueHours / 24
            
            print("DELTA \(timeDelta)")
            print(dueDays)
            print(dueHours)
            print(dueMinutes)
            
            
            
            //CountDownDoubleDifference.day
            if (dueDays > 0){
                str = "\(dueDays) days left"
            } else if dueHours > 0 {
                str = "\(dueHours) hours left"
            } else if dueMinutes > 0 {
                str = "\(dueMinutes) minutes left"
            } else {
                str = "YOU DIDNT DO IT"
            }
        } else {
            str = ""
        }
        
        
        cell.taskName.text = task.name
        cell.taskOwners.text = task.owner
        cell.taskDueDate.text = str
    
        return cell
    }
    
    // MARK: - Segue and Passing Data
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
       
    }
    
    @IBAction func done(segue:UIStoryboardSegue) {
        let newTask = Task()
        let addTask = segue.source as! AddTaskTableViewController
        
        newTask.name = addTask.addTask.name
        newTask.dueDate = addTask.addTask.dueDate
        if (addTask.addTask.owner == nil){
            newTask.owner = "None"
        } else {
            newTask.owner = addTask.addTask.owner
        }
        
        tasks.append(newTask)
        self.tableView.reloadData()
    
    }
    
    
    // MARK: - Delete Button
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        // Delete button
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete",handler: { (action, indexPath) -> Void in
            
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        })
        
        
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        return [deleteAction]
    }

}
