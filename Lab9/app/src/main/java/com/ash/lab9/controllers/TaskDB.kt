package com.ash.lab9.controllers

import com.ash.lab9.models.Task
import com.firebase.ui.firestore.FirestoreRecyclerOptions
import com.google.firebase.firestore.FirebaseFirestore

class TaskDB {
    private val taskdb = FirebaseFirestore.getInstance()
    private val taskRef = taskdb.collection("todo_tasks")

    fun getOptions(): FirestoreRecyclerOptions<Task> {
        val q = taskRef
        val opts = FirestoreRecyclerOptions.Builder<Task>()
            .setQuery(q, Task::class.java)
            .build()
        return opts
    }

    fun addTask(t: Task) {
        taskRef.add(t)
    }

    fun deleteTask(id: String) {
        taskRef.document(id).delete()
    }
}