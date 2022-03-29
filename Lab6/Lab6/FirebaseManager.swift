//
//  FirebaseManager.swift
//  Lab6
//
//  Created by Ashlyn Duy on 3/28/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

class FBManager {
    let db = Firestore.firestore()
    
    var tasks = [TodoTask]()
    
    func getData() async {
        do {
            let snap = try await db.collection("todo_tasks").getDocuments()
            self.tasks = snap.documents.compactMap { document->TodoTask? in
                return try? document.data(as: TodoTask.self)
            }
            print(self.tasks)
        } catch {
            print(error)
        }
    }
    
    func addTodoTask(_ name: String, _ date: Date) -> Void {
        guard name.isEmpty != true else {return}
        let taskCollection = db.collection("todo_tasks")
        
        let newTask = ["taskName": name, "completeBy": date] as [String : Any]
        
        var ref: DocumentReference? = nil
        ref = taskCollection.addDocument(data: newTask) {
            err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)") }
        }
    }
    
    func deleteTask(_ taskId: String){
        // Delete the object from Firestore
        db.collection("todo_tasks").document(taskId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
    }
    
    func getTasks() -> [TodoTask] {
        return tasks
    }
}
