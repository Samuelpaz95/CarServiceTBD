const Joi = require('joi');
const { Router } = require('express');
const router = Router();

const bodySchema = Joi.object({
  chassis_code: Joi.string().required(),
  plate_code: Joi.string().required(),
  color: Joi.string().required(),
  model_id: Joi.string().required(),
  client_id: Joi.string().required(),
});

router.post('/', (req, res, next) => {
  const body = req.body;
  bodySchema.validate(body);
  return { success: true, message: 'vehicle added successfully' };
});

router.get('/', (req, res, next) => {
  return [];
});

router.get('/:id', (req, res, next) => {
  const id = req.params.id;
  return [];
});

router.put('/:id', (req, res, next) => {
  const id = req.params.id;
  return [];
});

router.delete('/:id', (req, res, next) => {
  const id = req.params.id;
  return [];
});

module.exports = router;
