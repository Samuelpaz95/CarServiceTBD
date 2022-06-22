const express = require('express');
const passport = require('passport');
const { isLoggedIn, isNotLoggedIn } = require('../lib/auth');
const router = express.Router();

router.get('/signup', isNotLoggedIn, (request, response) => {
    response.render('auth/signup');
});

router.post('/signup', isNotLoggedIn, passport.authenticate('local.signup', {
    successRedirect: '/profile',
    failureRedirect: '/signup',
    failureFlash: true
}));

router.get('/signin', isNotLoggedIn, (request, response) => {
    response.render('auth/signin')
});

router.post('/signin', isNotLoggedIn, passport.authenticate('local.signin', {
    successRedirect: '/profile',
    failureRedirect: '/signin',
    failureFlash: true
}));

router.get('/profile', isLoggedIn, (request, response) => {
    response.render('profile');
});

router.get('/logout', isLoggedIn, (request, response) => {
    request.logOut();
    response.redirect('signin');
});


module.exports = router