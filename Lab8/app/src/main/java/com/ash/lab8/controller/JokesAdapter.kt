package com.ash.lab8.controller

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.ash.lab8.R
import com.ash.lab8.model.JokeVM

class JokesAdapter(private val jokeVM: JokeVM): RecyclerView.Adapter<RecyclerView.ViewHolder>() {
    private var jokesList = jokeVM.jokeList.value

    class JokesViewHolder(view: View): RecyclerView.ViewHolder(view) {
        val questionView: TextView = view.findViewById<TextView>(R.id.cardQuestion)
        val punchlineView: TextView = view.findViewById<TextView>(R.id.cardAnswer)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): JokesViewHolder {
        val li = LayoutInflater.from(parent.context)

        val itemHolder = li.inflate(R.layout.card_item,parent,false)
        return JokesViewHolder(itemHolder)
    }

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        val newHolder = holder as JokesViewHolder
        val joke = jokesList?.get(position)

        newHolder.questionView.text = joke?.question ?: ""
        newHolder.punchlineView.text = joke?.punchline ?: ""
    }

    override fun getItemCount(): Int {
        return jokesList?.size ?: 0
    }

    fun update(){
        jokesList = jokeVM.jokeList.value
        notifyDataSetChanged()
    }
}