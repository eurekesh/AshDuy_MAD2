//
//  TodoTasksTableTableViewController.swift
//  Lab6
//
//  Created by Ashlyn Duy on 3/28/22.
//

import UIKit
import FirebaseAuth
import FirebaseGoogleAuthUI

class TodoTasksTableTableViewController: UITableViewController, FUIAuthDelegate {
    
    @IBOutlet weak var addTaskButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    var tasks = [TodoTask]()
    var fbManager = FBManager()
    var auth: FUIAuth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = FUIAuth.defaultAuthUI()
        auth?.delegate = self
        getTableData()
        isUserSignedIn(false)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getTableData() {
        Task {
            await fbManager.getData()
            tasks = fbManager.getTasks()
            tableView.reloadData()
        }
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
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        if segue.identifier == "savesegue" {
            let addvc = segue.source as! AddTaskViewController
            fbManager.addTodoTask(addvc.outTaskName, addvc.outCompleteDate)
            getTableData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var cellConfig = cell.defaultContentConfiguration()
        cellConfig.text = tasks[indexPath.row].taskName
        cell.contentConfiguration = cellConfig
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && isUserSignedIn(true) == true {
            // Delete the row from the data source
            if let id = tasks[indexPath.row].id {
                fbManager.deleteTask(id)
                getTableData()
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    @IBAction func login(_ sender: Any) {
        //authentication providers
        let providers: [FUIAuthProvider] = [FUIGoogleAuth(authUI: auth!)]
        auth?.providers = providers
        if auth?.auth?.currentUser == nil {
            // get the sign-in method selector
            let authViewController = auth?.authViewController()
            // present the auth view controller
            present(authViewController!, animated: true, completion: nil)
        } else {
            
            let name = auth?.auth?.currentUser!.displayName
            let alert=UIAlertController(title: "Firebase", message: "You're already logged into Firebase \(name!)", preferredStyle: UIAlertController.Style.alert)
            
            let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            print("\(auth?.auth?.currentUser) is the currently logged in")
        } }
    
    @IBAction func logout(_ sender: Any) {
        do{
            try auth?.signOut()
            let alert=UIAlertController(title: "Firebase", message: "You've been logged out of Firebase", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil) } catch {
                print("You were not logged out")
            }
        setLoggedOutButtons()
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        // handle user and error as necessary
        
        guard let authUser = user else { return } //create a UIAlertController object
        let alert = UIAlertController(title: "Firebase", message: "Welcome to Firebase \(authUser.displayName!)", preferredStyle: UIAlertController.Style.alert)
        
        //create a UIAlertAction object for the button
        let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        setLoggedInButtons()
        guard let authError = error else { return }
        let errorCode = UInt((authError as NSError).code)
        switch errorCode {
        case FUIAuthErrorCode.userCancelledSignIn.rawValue:
            print("User cancelled sign-in");
            break
        default:
            let detailedError = (authError as NSError).userInfo[NSUnderlyingErrorKey] ?? authError
            print("Login error: \((detailedError as! NSError).localizedDescription)");
        }
        
    }
    
    func isUserSignedIn(_ showAlert: Bool?) -> Bool {
        guard auth.auth?.currentUser == nil else {
            setLoggedInButtons()
            return true
        }
        
        guard showAlert != nil && showAlert != false else {
            setLoggedOutButtons()
            return false
        }
        let alert=UIAlertController(title: "Firebase", message: "Please login to modify your tasks", preferredStyle: UIAlertController.Style.alert)

        let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        setLoggedOutButtons()
        return false
    }
    
    func setLoggedInButtons() -> Void {
        addTaskButton.isEnabled = true
        loginButton.isEnabled = false
        logoutButton.isEnabled = true
    }
    
    func setLoggedOutButtons() -> Void {
        addTaskButton.isEnabled = false
        loginButton.isEnabled = true
        logoutButton.isEnabled = false
    }
    
}

