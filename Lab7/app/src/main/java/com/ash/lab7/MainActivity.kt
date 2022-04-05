package com.ash.lab7

import android.content.Context
import android.content.SharedPreferences
import android.os.Bundle
import com.google.android.material.snackbar.Snackbar
import androidx.appcompat.app.AppCompatActivity
import androidx.navigation.findNavController
import androidx.navigation.ui.AppBarConfiguration
import androidx.navigation.ui.navigateUp
import androidx.navigation.ui.setupActionBarWithNavController
import android.view.Menu
import android.view.MenuItem
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.ash.lab7.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private lateinit var appBarConfiguration: AppBarConfiguration
    private lateinit var binding: ActivityMainBinding
    private lateinit var adapter: GameAdapter
    lateinit var sharedPref: SharedPreferences
    val prefKey = "com.ash.lab7"
    val dataSetKey = "dataSet"
    var currDataSetNum = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        sharedPref = getSharedPreferences(prefKey, Context.MODE_PRIVATE)
        currDataSetNum = sharedPref.getInt(dataSetKey, 0)

        val currDataSet = if (currDataSetNum == 0) BestGames.gameList else BestGames.secondTierList
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val recycler: RecyclerView = findViewById(R.id.recyclerView)
        recycler.addItemDecoration(DividerItemDecoration(this,LinearLayoutManager.VERTICAL))
        val adapter = GameAdapter()
        adapter.setGames(currDataSet)
        this.adapter = adapter
        recycler.adapter = adapter
        recycler.layoutManager = LinearLayoutManager(this,LinearLayoutManager.VERTICAL, false)

        setSupportActionBar(binding.toolbar)

        val navController = findNavController(R.id.nav_host_fragment_content_main)
        appBarConfiguration = AppBarConfiguration(navController.graph)
        setupActionBarWithNavController(navController, appBarConfiguration)

    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        // Inflate the menu; this adds items to the action bar if it is present.
        menuInflater.inflate(R.menu.menu_main, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        return when (item.itemId) {
            R.id.action_settings -> {
                handleDataset()
                return true
            }
            else -> super.onOptionsItemSelected(item)
        }
    }

    override fun onSupportNavigateUp(): Boolean {
        val navController = findNavController(R.id.nav_host_fragment_content_main)
        return navController.navigateUp(appBarConfiguration)
                || super.onSupportNavigateUp()
    }

    private fun handleDataset() {
        when (currDataSetNum) {
            0 -> {
                currDataSetNum = 1
                adapter.setGames(BestGames.secondTierList)
                with(sharedPref.edit()) {
                    putInt(dataSetKey, currDataSetNum)
                    apply();
                }
                adapter.notifyDataSetChanged()
                return
            }
            1 -> {
                currDataSetNum = 0
                adapter.setGames(BestGames.gameList)
                with(sharedPref.edit()) {
                    putInt(dataSetKey, currDataSetNum)
                    apply();
                }
                adapter.notifyDataSetChanged()
                return
            }
        }

    }
}