package com.ash.lab7

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.ash.lab7.GameAdapter.ViewHolder

class GameAdapter(): RecyclerView.Adapter<ViewHolder>() {
    private var games: ArrayList<Game> = arrayListOf()

    class ViewHolder(view: View): RecyclerView.ViewHolder(view) {
        val gameTextView: TextView = view.findViewById(R.id.textView)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val l_inflater = LayoutInflater.from(parent.context)
        val itemViewHolder = l_inflater.inflate(R.layout.list_item, parent, false)
        return ViewHolder(itemViewHolder)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val game = games[position]

        holder.gameTextView.text = "${game.name} was released on ${game.releaseDate}. A great day indeed!"
    }

    override fun getItemCount(): Int {
        return games.size
    }

    public fun setGames(games: ArrayList<Game>) {
        this.games = games
    }

}