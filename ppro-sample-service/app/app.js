const express = require('express')
const app = express()
const moment = require('moment')
const yaml = require('js-yaml')
const fs = require('fs')
const { Client } = require('pg');
const port = 8000;

// read config
const appconfig = yaml.load(fs.readFileSync('app-config.yaml', 'utf-8'));

const cred = {
    // dynamic config per environment basis
    user: appconfig.DB_USER,
    host: appconfig.DB_ENDPOINT,
    database: appconfig.DB_NAME,
    password: appconfig.DB_PASS,
    port: 5432
}

// call initdb
const initdb = require('./initdb.js');
console.log(initdb);

// get call routing
app.get('/get', async (req, res) => {
        const client = new Client(cred);
        await client.connect();
        const result = await client.query("select val from pprotble where id = '1'");
        res.send(moment().valueOf() + ' => ' + result['rows'][0]['val'])
})

// run
app.listen(port, () => {
    console.log('Rest api is listening...')
})