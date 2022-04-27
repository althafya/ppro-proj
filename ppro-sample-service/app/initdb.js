const yaml = require('js-yaml')
const fs = require('fs')
const { Client } = require('pg');
const sql = fs.readFileSync('./scripts/init.sql').toString();
// read config
const appconfig = yaml.load(fs.readFileSync('app-config.yaml', 'utf-8'));


const cred = {
    // dynamic config change
    user: appconfig.DB_USER,
    host: appconfig.DB_ENDPOINT,
    database: appconfig.DB_NAME,
    password: appconfig.DB_PASS,
    port: 5432
}

//  run init sql file
async function getdbval() {
    const client = new Client(cred);
    await client.connect();
    const result = await client.query(sql);
    await client.end();
    console.log(result);
    console.log('--- Completed ---');
    return result[0];
}

const output =  getdbval();