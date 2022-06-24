const Joi = require('joi');
const { Router } = require('express');
const router = Router();

const mysqlx = require('@mysql/xdevapi');

export const getSession = async () => {
  return await mysqlx.getSession(
    'mysqlx://carservices_user:password@localhost:33060/carservices_db?ssl-mode=DISABLED'
  );
};

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
      .required(),
  }),
  vehicles: Joi.array().items(
    Joi.object({
      chassis_code: Joi.string().required(),
      plate_code: Joi.string().required(),
      color: Joi.string().required(),
      model: Joi.object({
        name: Joi.string().required(),
        brand: Joi.string().required(),
        year: Joi.string().required(),
        type: Joi.string().required(),
      }).required(),
    })
  ),
});

router.get('/', (req, res, next) => {
  clients = [
    {
      CI: 9396576,
      first_name: 'WIlly',
      last_name: 'Paz',
      phone_number: '+59176465727',
      email: 'willy.paz@gmail.com',
      client_type: 'A',
    },
    {
      CI: 9396576,
      first_name: 'WIlly',
      last_name: 'Paz',
      phone_number: '+59176465727',
      email: 'willy.paz@gmail.com',
      client_type: 'A',
    },
    {
      CI: 9396576,
      first_name: 'WIlly',
      last_name: 'Paz',
      phone_number: '+59176465727',
      email: 'willy.paz@gmail.com',
      client_type: 'A',
    },
  ];
  res.render('clients/list', { clients });
});

router.get('/add', (req, res, next) => {
  res.render('clients/add');
});

router.get('/done', (req, res) => {
  req.flash('success', 'Client saved successfully');
  res.redirect('/clients');
});

router.post('/add', (req, res, next) => {
  const body = req.body;
  const validation = bodySchema.validate(body);
  console.log({ body, validation });
  if (isValid.error) {
    res.status(500).json({ msg: isValid.error.message });
    return;
  }
  res.status(200).json(body);
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
