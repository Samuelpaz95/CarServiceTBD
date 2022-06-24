const { join, resolve } = require('path');
const { v4: uuid } = require('uuid');
const express = require('express');
const exphbs = require('express-handlebars');
const morgan = require('morgan');
const flash = require('connect-flash');
const session = require('express-session');

const app = express();

app.set('port', process.env.PORT || 3000);
app.set('views', join(__dirname, 'views'));
app.engine(
  '.hbs',
  exphbs.engine({
    defaultLayout: 'main',
    layoutsDir: join(app.get('views'), 'layouts'),
    partialsDir: join(app.get('views'), 'partials'),
    extname: '.hbs',
    helpers: require('./lib/handlebars'),
  })
);
app.set('view engine', '.hbs');

// Middlewares
app.use(
  session({
    resave: false,
    saveUninitialized: false,
    secret: 'SUPER_SECRET',
    genid: function (req) {
      return uuid(); // use UUIDs for session IDs
    },
  })
);
app.use(flash());
app.use(morgan('dev'));
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Global variables
app.use((req, res, next) => {
  app.locals.success = req.flash('success');
  app.locals.message = req.flash('message');
  next();
});

// Routes
app.use(require('./routes/index'));
app.use('/clients', require('./routes/clients'));
app.use('/consultations', require('./routes/consultations_view'));

// public
app.use(express.static(join(__dirname, 'public')));

app.listen(app.get('port'), () => {
  console.log(`Server on port ${app.get('port')}`);
});
