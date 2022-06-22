const { Router } = require('express');
const router = Router();

/**
 *
 * @param {Date} date
 * @returns string fomated date yyyy-mm-dd
 */
const format = (date) => {
  return date.toISOString().split('T')[0];
};

router.get('/:client_id', (req, res) => {
  const client_id = req.params.client_id;
  console.log({ client_id });
  consultation = { id: 2, reception_date: format(new Date()) };
  res.render('consultations/view', { client_name: 'Willy Paz', ...consultation });
});

router.get('/:id/:client_id', (req, res) => {
  const { id, client_id } = req.params;
  console.log({ client_id });
  consultation = { id, reception_date: format(new Date()) };
  res.render('consultations/view', { client_name: 'Willy Paz', ...consultation });
});

module.exports = router;
