package com.ash.lab9.models

import androidx.lifecycle.ViewModel
import com.ash.lab9.controllers.TaskDB

class TaskVM: ViewModel() {
    private val taskdb = TaskDB()
    val opts = taskdb.getOptions()

    fun addTask(t: Task) = taskdb.addTask(t)

    fun deleteTask(id: String) = taskdb.deleteTask(id)
}