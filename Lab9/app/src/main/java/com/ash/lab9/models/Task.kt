package com.ash.lab9.models

import java.util.Date


data class Task(val taskName: String, val completeBy: Date?) {
    constructor(): this("", null){}
}