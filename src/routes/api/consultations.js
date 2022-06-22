const Joi = require('joi');
const { Router } = require('express');
const router = Router();

router.post('/', (req, res, next) => {
  return { success: true, message: 'consultation added successfully' };
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
