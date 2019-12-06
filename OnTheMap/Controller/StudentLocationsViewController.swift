//
//  StudentLocationsTable.swift
//  OnTheMap
//
//  Created by Dustin Mahone on 12/1/19.
//  Copyright © 2019 Dustin. All rights reserved.
//

import Foundation
import UIKit

class StudentLocationsViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var alertTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Variables and Constants
    var result = [StudentLocation]()
    var students = DataModel.students
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudents(message: "        Fetching Data")
    }

    //MARK: - Methods
    func checkFetch(message: String) {
        let students = DataModel.students
        if students.count == 0 {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.activityIndicator.isHidden = false
                self.alertTextView.isHidden = false
                self.alertTextView.text = message
            }
        } else {
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = true
            self.alertTextView.isHidden = true
            self.alertTextView.text = message
        }
    }
    
    func getStudents(message: String) {
        checkFetch(message: message)
        OTMClient.getStudentLocations { (students, error) in
            DataModel.students = students
            DispatchQueue.main.async {
                self.checkFetch(message: "        Data download failed, try refresh")
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func logoutButtonPressed(_ sender: Any) {
        OTMClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        getStudents(message: "        Fetching Data")
    }
        
}

    //MARK: - Extentions
extension StudentLocationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataModel.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let student = DataModel.students[indexPath.row]
        
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.detailTextLabel?.text = "\(student.mediaURL)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        _ = DataModel.students[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let indexPath = tableView.indexPathForSelectedRow {
            let student = DataModel.students[indexPath.row]
            let destination = segue.destination as? WebViewController
            destination?.mediaUrl = student.mediaURL
        }
    }
    
}
