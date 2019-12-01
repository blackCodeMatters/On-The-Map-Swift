//
//  StudentLocationTableViewController.swift
//  OnTheMap
//
//  Created by Dustin Mahone on 11/21/19.
//  Copyright © 2019 Dustin. All rights reserved.
//

import Foundation
import UIKit

class StudentLocationTableViewController: UITableViewController {
    
    /*var students = DataModel.students
    
    override func viewWillAppear(_animated: Bool) {
        tableView.reloadData
    }
    
    override func viewDidLoad() {
        _ = OTMClient.getStudentLocations { (students, error) in
            DataModel.students = students
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.students.count
    }
    
    
    */
    var students = DataModel.students
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        _ = OTMClient.getStudentLocations { (students, error) in
            DataModel.students = students
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        //print(students.count)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.students.count
    }
    
    override func tableView(_ tableview: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
 
        let student = self.students[indexPath.row]
        
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.detailTextLabel?.text = "\(student.mapString)"
        
        return cell
    }
    
}
