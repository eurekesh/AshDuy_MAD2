package com.ash.lab8.controller

import android.content.Context
import android.util.Log
import com.android.volley.Request
import com.android.volley.toolbox.StringRequest
import com.android.volley.toolbox.Volley
import com.ash.lab8.model.Joke
import com.ash.lab8.model.JokeVM
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject

class JokeController {
    fun sendRequest(context: Context, jokeVM: JokeVM) {
        val url = "https://backend-omega-seven.vercel.app/api/getjoke"

        val q = Volley.newRequestQueue(context)

        val req = StringRequest(Request.Method.GET, url, {
            res -> parse(res, jokeVM)
        }, {
            Log.e("Network Error", error("something went wrong with the request"))
        })

        for (i in 1..20) {
            q.add(req)
        }
    }

    private fun parse(res: String, jokeVM: JokeVM) {
        val jokes = jokeVM.jokeList.value ?: ArrayList<Joke>()

        try {
            val arr = JSONArray(res)
            val obj = arr.getJSONObject(0)

            val question = obj.getString("question")
            val punchline = obj.getString("punchline")

            val newJoke = Joke(question, punchline)

            jokes.add(newJoke)
        } catch (e: JSONException) {
            e.printStackTrace()
        }
        jokeVM.updateList(jokes)
    }
}