const { Router } = require('express');
const router = Router();

router.get('/', (req, res, next) => {
  return [];
});

router.get('/:id', (req, res, next) => {
  const id = req.params.id;
  return [];
});

router.delete('/:id', (req, res, next) => {
  const id = req.params.id;
  return [];
});

module.exports = router;
