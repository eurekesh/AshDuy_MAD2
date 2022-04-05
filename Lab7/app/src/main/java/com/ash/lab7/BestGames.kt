package com.ash.lab7

data class Game (val name: String, val releaseDate: String){

}

object BestGames {
    val gameList = ArrayList<Game>()
    val secondTierList = ArrayList<Game>()

    init {
        gameList.add(Game("Destiny", "September 9, 2014"))
        gameList.add(Game("Destiny 2", "September 6, 2017"))
        gameList.add(Game("Minecraft", "November 18, 2011"))
        gameList.add(Game("Clash of Clans", "August 2, 2012"))
        gameList.add(Game("Control", "August 27, 2019"))

        secondTierList.add(Game("Chess", "8th Century"))
        secondTierList.add(Game("Rainbow 6: Siege", "December 1, 2015"))
        secondTierList.add(Game("Sea of Thieves", "March 20, 2018"))
        secondTierList.add(Game("Rocket League", "July 7, 2015"))
        secondTierList.add(Game("Team Fortress 2", "October 10, 2007"))
    }
}