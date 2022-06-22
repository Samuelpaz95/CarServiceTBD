const express = require('express');
const router = express.Router();



// READING
router.get('/', async (request, response) => {
    const { id } = request.user;
    db.Link.findAll({ where: { user_id: id } }).then(links => {
        links = links.map(link => link.dataValues)
        response.render('links/list', { links });
    });
});

// CREATING 
router.get('/add', (request, response) => {
    response.render('links/add');
});

router.post('/add', async (request, response) => {
    const { title, lurl, descrip } = request.body;
    const newLink = {
        title, lurl, descrip, user_id: request.user.id
    };
    db.Link.create(newLink).then(user => {
        user.save();
        request.flash('success', "Link saved successfully");
        response.redirect('/links');
    });
});

// DELETE
router.get('/delete/:id', async (request, response) => {
    const { id } = request.params;
    const user_id = request.user.id;
    db.Link.destroy({ where: { id: id, user_id: user_id } });
    response.redirect('/links');
});

// EDITION
router.get('/edit/:id', async (request, response) => {
    const { id } = request.params;
    const user_id = request.user.id;
    db.Link.findOne({ where: { id: id, user_id: user_id } }).then(link => {
        if (link === null) {
            response.redirect('/links');
        } else {
            link = link.dataValues;
            response.render('links/edit', { link });
        }
    });
});
router.post('/edit/:id', async (request, response) => {
    const { id } = request.params;
    const user_id = request.user.id;
    const { title, lurl, descrip } = request.body;
    const newLink = {
        title, lurl, descrip, user_id
    };
    db.Link.update(newLink, { where: { id: id, user_id: user_id } });
    response.redirect('/links');
});

module.exports = router