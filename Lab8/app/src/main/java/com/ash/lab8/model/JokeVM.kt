package com.ash.lab8.model

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel

class JokeVM: ViewModel() {
    val jokeList = MutableLiveData<ArrayList<Joke>>()

    fun updateList(newList: ArrayList<Joke>){
        jokeList.value = newList
    }
}