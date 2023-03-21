module.exports = function (app) {
    app.route('/').get(defaultResponse)
}

function defaultResponse(req, res) {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end('Hello, World!\n');
}