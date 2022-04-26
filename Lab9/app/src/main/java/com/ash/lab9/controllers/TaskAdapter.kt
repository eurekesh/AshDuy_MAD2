package com.ash.lab9.controllers

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.ash.lab9.R
import com.ash.lab9.models.Task
import com.ash.lab9.models.TaskVM
import com.firebase.ui.firestore.FirestoreRecyclerAdapter
import com.firebase.ui.firestore.FirestoreRecyclerOptions
import com.google.android.material.snackbar.Snackbar

class TaskAdapter(opts: FirestoreRecyclerOptions<Task>, private val vm: TaskVM) : FirestoreRecyclerAdapter<Task,TaskAdapter.ViewHolder>(opts) {
    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        var taskView: TextView = view.findViewById(R.id.taskView)
        var completeByView: TextView = view.findViewById(R.id.completeByView)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val LI = LayoutInflater.from(parent.context)
        val taskVH = LI.inflate(R.layout.item,parent,false)
        return ViewHolder(taskVH)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int, model: Task) {
        holder.taskView.text = model.taskName
        holder.completeByView.text = "Complete by ${model.completeBy.toString()}"
        holder.itemView.setOnCreateContextMenuListener { menu,view,menuInfo ->
            menu.setHeaderTitle(R.string.delete)

            menu.add(R.string.yes).setOnMenuItemClickListener {
                val id = snapshots.getSnapshot(position).id
                vm.deleteTask(id)
                Snackbar.make(view, R.string.taskDeleted,Snackbar.LENGTH_LONG)
                    .setAction(R.string.action,null).show()
                true
            }
            menu.add(R.string.no)

        }
    }
}