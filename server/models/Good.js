import Joi from 'joi'
import db from '../config/db.js'
import GoodSchema from '../schemas/Good.js'
import errorGen from '../modules/errorgen.js'

const Good = db.import('GOOD', GoodSchema)

/**
 * A json validator for GoodData.
 */
const GOODDATA_VALIDATOR = Joi.object().required().keys({
  name: Joi.string()
    .required(),
  description: Joi.string()
    .empty('').max(2000),
  price: Joi.number()
    .integer()
    .positive()
    .required(),
  stock: Joi.number()
    .integer()
    .positive()
    .required(),
  durability: Joi.number()
    .integer()
    .min(0)
    .max(10)
    .required()
})

/**
 * @typedef GoodData
 * @type {Object}
 * @description A JSON object contains a new good's basic data.
 * @property {string} name Name.
 * @property {string} description Product's description.
 * @property {number} price Price.
 * @property {number} stock The quantity of the good.
 * @property {number} durability The level of 'how new the product is'.
 */
/**
 * Publish a new product.
 * @param {number} memberId The user's MEMBER id.
 * @param {GoodData} data A data which records new product
 * @async
 */
async function publishNewGood (memberId, data) {
  let result = GOODDATA_VALIDATOR.validate(data, { abortEarly: false })

  if (result.error) {
    return {
      success: false,
      error: errorGen(result.error.details)
    }
  }

  let value = result.value
  let newGood = await Good.create({
    // id is auto-increment
    member_id: memberId,
    name: value.name,
    stock: value.stock,
    price: value.price,
    description: value.description || '',
    durability: value.durability,
    state: 0
    // publish_time uses the default yield function sequelize.fn('current_timestamp')
  })

  return {
    success: true,
    newGood
  }
}

export default {
  publishNewGood
}