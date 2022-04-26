package com.ash.lab9

import android.os.Bundle
import com.google.android.material.snackbar.Snackbar
import androidx.appcompat.app.AppCompatActivity
import androidx.navigation.findNavController
import androidx.navigation.ui.AppBarConfiguration
import androidx.navigation.ui.navigateUp
import androidx.navigation.ui.setupActionBarWithNavController
import android.view.Menu
import android.view.MenuItem
import android.widget.DatePicker
import android.widget.EditText
import android.widget.LinearLayout
import android.widget.TextView
import androidx.activity.viewModels
import androidx.appcompat.app.AlertDialog
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.ash.lab9.controllers.TaskAdapter
import com.ash.lab9.databinding.ActivityMainBinding
import com.ash.lab9.models.Task
import com.ash.lab9.models.TaskVM
import java.time.LocalDateTime
import java.util.*

class MainActivity : AppCompatActivity() {
    private val vm: TaskVM by viewModels()
    private lateinit var taskAdapter: TaskAdapter

    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val recyclerView: RecyclerView = findViewById(R.id.recyclerView)
        recyclerView.addItemDecoration(DividerItemDecoration(this,LinearLayoutManager.VERTICAL))

        recyclerView.layoutManager = LinearLayoutManager(this,LinearLayoutManager.VERTICAL, false)

        val opts = vm.opts

        taskAdapter = TaskAdapter(opts, vm)

        recyclerView.adapter = taskAdapter

        binding.fab.setOnClickListener { view ->
            val layout = LinearLayout(this)
            val editTaskName = EditText(this)
            editTaskName.setHint(R.string.taskHint)
            layout.addView(editTaskName)

            val dialog = AlertDialog.Builder(this)
            dialog.setTitle(R.string.addTask)
            dialog.setView(layout)

            dialog.setPositiveButton(R.string.add) { dialog, which ->
                val taskName = editTaskName.text.toString()
                if(taskName.isNotEmpty()) {
                    val newTask = Task(taskName,Date(Date().time + (1000 * 60 * 60 * 24)))
                    vm.addTask(newTask)

                    Snackbar.make(view, R.string.taskAdded, Snackbar.LENGTH_LONG)
                        .setAction(R.string.action, null).show()
                }
            }

            dialog.setNegativeButton(R.string.cancel) {dialog,which ->

            }

            dialog.show()

        }
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        // Inflate the menu; this adds items to the action bar if it is present.
        menuInflater.inflate(R.menu.menu_main, menu)
        return true
    }

    override fun onStart() {
        super.onStart()
        taskAdapter.startListening()
    }

    override fun onStop() {
        super.onStop()
        taskAdapter.stopListening()
    }
}