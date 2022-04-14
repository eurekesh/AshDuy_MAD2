package com.ash.lab8

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.activity.viewModels
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.ash.lab8.controller.JokeController
import com.ash.lab8.controller.JokesAdapter
import com.ash.lab8.model.JokeVM

class MainActivity : AppCompatActivity() {
    private val model: JokeVM by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        if (model.jokeList.value == null) {
            JokeController().sendRequest(this.applicationContext, model)
        }

        val recycler: RecyclerView = findViewById(R.id.recyclerView)

        // thanks to https://stackoverflow.com/a/57886251
        recycler.addItemDecoration(DividerItemDecoration(
            this@MainActivity,
            LinearLayoutManager.VERTICAL
        ))
        recycler.layoutManager = LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false)

        val adapter = JokesAdapter(model)
        recycler.adapter = adapter

        model.jokeList.observe(this) {
            adapter.update()
        }
    }
}