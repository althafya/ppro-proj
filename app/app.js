const express = require('express')
const app = express()
const port = 8000
const pg_pass = process.env.POSTGRES_PASSWORD


app.get('/get', (req, res) => {
    const { Client } = require('pg')
    const client = new Client({
    user: 'postgres',
    // having PG in the same name space the service entity need not to worry!
    host: 'pg-service',
    database: 'postgres',
    // to handle dynamic configuration for db credential
    password: pg_pass,
    port: 5432,
    })
    client.connect(function(err) {
    if (err) throw err;
    console.log("Connected!");
    res.send("Connected!"); 
    });
})

app.listen(port, () => {
    console.log('Rest api is running')
})
