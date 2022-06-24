const names = ['TOYOTA-12', 'TESLA-24', 'SUBARU-95', 'HOMERCAR-32'];
const types = ['bagoneta', 'automovil', 'camioneta', 'motocicleta'];

const models = {};

for (let name of names) {
  for (let type of types) {
    models[`${name}-${type}`] = {
      name,
      brand: name.split('-')[0],
      year: Math.floor(1950 + Math.random() * 72),
      type,
    };
  }
}
