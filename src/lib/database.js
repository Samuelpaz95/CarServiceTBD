const dotenv = require('dotenv');
const mysqlx = require('@mysql/xdevapi');

dotenv.config({
  path: '.env',
});

class Database {
  #session;

  async initSession() {
    if (!this.#session) {
      this.#session = await mysqlx.getSession(
        `mysqlx://${process.env.DB_USER}:${process.env.DB_PASS}@${process.env.HOST}:33060/${process.env.DB_NAME}?ssl-mode=DISABLED`
      );
    }
    console.log('Database connected.');
  }

  get session() {
    return this.#session;
  }
}

const db = new Database();
module.exports = db;
