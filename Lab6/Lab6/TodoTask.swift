//
//  TodoTask.swift
//  Lab6
//
//  Created by Ashlyn Duy on 3/28/22.
//

import Foundation
import FirebaseFirestoreSwift

struct TodoTask: Codable, Identifiable {
    @DocumentID var id: String?
    var taskName: String
    var completeBy: Date
}
