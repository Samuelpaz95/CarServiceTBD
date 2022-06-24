const Joi = require('joi');
const { Router } = require('express');
const db = require('../lib/database');

const router = Router();
// getSession()
//   .then(async (session) => {
//     session.startTransaction();
//     session
//       .sql(
//         'INSERT INTO `Client` (`first_name`, `last_name`, `phone_number`, `email`, `client_type`) VALUES ("willy2", "Sejas", "656343242", "willy.paz@cannedhead.com", NULL);'
//       )
//       .execute();
//     session.rollback();
//     console.log(session.inspect());
//   })
//   .catch((error) => {
//     console.log('\nHAHAHAHA\n');
//     console.log(error);
//   });

const bodySchema = Joi.object({
  CI: Joi.string()
    .min(6)
    .max(10)
    .pattern(/^[0-9]+$/)
    .required(),
  first_name: Joi.string().required(),
  last_name: Joi.string().required(),
  phone_number: Joi.string()
    .length(8)
    .pattern(/^[0-9]+$/),
  email: Joi.string().email().required(),
  consultation: Joi.object({
    details: Joi.array()
      .items(
        Joi.object({
          type: Joi.string().required(),
          description: Joi.string().required(),
        })
      )
      .min(1)
      .required(),
  }),
  vehicles: Joi.array()
    .items(
      Joi.object({
        chassis_code: Joi.string().required(),
        plate_code: Joi.string().required(),
        color: Joi.string().required(),
        model: Joi.object({
          name: Joi.string().required(),
          brand: Joi.string().required(),
          year: Joi.number().min(1950).max(2022).required(),
          type: Joi.string().required(),
        }).required(),
      })
    )
    .min(1)
    .required(),
});

router.get('/', async (req, res, next) => {
  const rows = [];
  const query = 'SELECT * FROM Client ORDER BY CI DESC;';
  const nice = await db.session.sql(query).execute((result) => {
    rows.push(result);
  });
  const cols = nice.getColumns().map((col) => col.getColumnName());
  const clients = rows.map((row) => {
    const client = {};
    cols.forEach((col, index) => {
      client[col] = row[index];
    });
    return client;
  });
  res.render('clients/list', { clients });
});

router.get('/add', (req, res, next) => {
  res.render('clients/add');
});

router.get('/done', (req, res) => {
  req.flash('success', 'Client saved successfully');
  res.redirect('/clients');
});

router.post('/add', async (req, res, next) => {
  const body = req.body;
  const validatedData = bodySchema.validate(body, { stripUnknown: true });
  if (validatedData.error) {
    res.status(422).json({ msg: validatedData.error.message });
    return;
  }

  const { CI, first_name, last_name, phone_number, email } = validatedData.value;
  const details = validatedData.value.consultation.details;
  const vehicle = validatedData.value.vehicles[0];

  db.session.startTransaction(); // START TRANSACTION;
  try {
    const clientQuery =
      'INSERT INTO Client(CI, first_name, last_name, phone_number, email) VALUES (?, ?, ?, ?, ?)';
    const query = db.session.sql(clientQuery).bind(CI, first_name, last_name, phone_number, email);
    let result = await query.execute();
    const client_id = result.getAutoIncrementValue();

    if (!(vehicle && details.length >= 0)) {
      db.session.rollback(); // ROLLBACK;
      res.status(500).json({ msg: 'Vehicles and details are required' });
      return;
    }

    const { name, brand, year, type } = vehicle.model;
    const { chassis_code, plate_code, color } = vehicle;

    // Vehicle Model
    const model = [];
    let selectModel =
      'SELECT id FROM vehicle_model WHERE name = ? AND brand = ? AND year = ? AND type = ?';
    selectModel = db.session.sql(selectModel).bind(name, brand, year, type);
    await selectModel.execute((result) => {
      model.push(...result);
    });

    let model_id = model[0];
    if (!model_id) {
      let modelQuery = 'INSERT INTO vehicle_model(name, brand, year, type) VALUES (?, ?, ?, ?);';
      modelQuery = db.session.sql(modelQuery).bind(name, brand, year, type);
      result = await modelQuery.execute();
      model_id = result.getAutoIncrementValue();
    }
    // Vehicle
    let vehicleQuery =
      'INSERT INTO Vehicle(chassis_code, plate_code, color, model_id, client_id) VALUES (?, ?, ?, ?, ?);';
    vehicleQuery = db.session
      .sql(vehicleQuery)
      .bind(chassis_code, plate_code, color, model_id, client_id);
    result = await vehicleQuery.execute();
    const vehicle_id = result.getAutoIncrementValue();
    // Consultation
    const newDate = new Date().toISOString().replace('T', ' ').split('.')[0];
    let consulQuery =
      'INSERT INTO Consultation(reception_date, client_id, vehicle_id) VALUES (?, ?, ?);';
    consulQuery = db.session.sql(consulQuery).bind(newDate, client_id, vehicle_id);
    result = await consulQuery.execute();
    const consultation_id = result.getAutoIncrementValue();

    // Details
    let detailQuery = 'INSERT INTO Detail(type, description, consultation_id) VALUES ';
    const params = [];
    details.forEach((detail) => {
      const { type, description } = detail;
      params.push(...[type, description, consultation_id]);
      detailQuery = detailQuery + '(?, ?, ?),';
    });
    detailQuery = detailQuery.slice(0, detailQuery.length - 1) + ';';
    detailQuery = db.session.sql(detailQuery).bind(...params);
    await detailQuery.execute();

    db.session.commit(); //  COMMIT;
  } catch (error) {
    console.error(error);
    db.session.rollback(); // ROLLBACK;
    res.status(500).json(error.msg);
    return;
  }

  console.log({ details, vehicle });

  res.status(201).json({ done: true });
});

router.post('/delete/:ci', (req, res, next) => {
  const { id } = req.params;
  res.redirect('/clients');
});

router.get('/edit/:ci', (req, res, next) => {
  const { ci } = req.params;
  const client = {
    CI: 9396576,
    first_name: 'WIlly',
    last_name: 'Paz',
    phone_number: '+59176465727',
    email: 'willy.paz@gmail.com',
    client_type: 'A',
  };
  res.render('clients/edit', { client });
});

router.post('/edit/:ci', (req, res, next) => {
  const { ci } = req.params;
  res.redirect('/clients/edit/' + ci);
});

module.exports = router;
