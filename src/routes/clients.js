const Joi = require('joi');
const { Router } = require('express');
const router = Router();

const bodySchema = Joi.object({
  CI: Joi.number().required(),
  first_name: Joi.string().required(),
  last_name: Joi.string().required(),
  phone_number: Joi.string()
    .length(11)
    .pattern(/^[0-9]+$/),
  email: Joi.string().email().required(),
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

router.post('/add', (req, res, next) => {
  const body = req.body;
  bodySchema.validate(body);
  req.flash('success', 'Client saved successfully');
  res.redirect('/clients');
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
