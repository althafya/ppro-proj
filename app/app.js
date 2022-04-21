const express = require('express')
const app = express()
const moment = require('moment')
const { Client } = require('pg');
const port = 8000;
const cred = {
    user: 'postgres',
    host: 'pg-service',
    database: 'postgres',
    // dynamic pass per environment
    password: process.env.POSTGRES_PASSWORD,
    port: 5432
}

async function getdbval() {
    const client = new Client(cred);
    await client.connect();
    const result = await client.query("select val from pprotble where id = 1");
    await client.end();
    return result;
}

app.get('/get', (req, res) => {
        const output =  getdbval();
        res.send(moment().valueOf() + ' => ' + output )
})

app.listen(port, () => {
    console.log('Rest api is listening...')
})