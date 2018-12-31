import consola from 'consola'
import bodyparser from 'koa-bodyparser'
import router from './routes/main.js'
import ntutdb from './config/db.js'

/**
 * Setup the Koa application.
 * @param {Koa} app Koa application.
 */
export default function (app) {
  app.use(bodyparser())

  return new Promise((resolve, reject) => {
    // Check whether the connection is created or not.
    ntutdb
      .authenticate()
      .then(() => {
        consola.ready(`Connected to MariaDB.`)

        app.use(router.routes()).use(router.allowedMethods())

        resolve()
      })
      .catch(err => {
        consola.error(`Failed to connect to MariaDB:\n${err}`)
        reject(err)
      })
  })
}
