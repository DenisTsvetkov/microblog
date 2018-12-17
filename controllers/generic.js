
const emptyCookie = {'user_id': undefined, 'email': undefined, 'name': undefined, 'access_level':undefined, 'access_token': undefined}

moment.locale('ru')

exports.extractAccessToken = (req) => parseCookies(req)().access_token;

const parseCookies = (req) => () =>
(req.cookies.udata && JSON.parse(req.cookies.udata)) ||
{'user_id': undefined, 'email': undefined, 'name': undefined, 'access_level':undefined, 'access_token': undefined }



//exports.render = (req, res, form, data) => res.render(form, {...data, acc_level, dateFormat, 'parseCookies': parseCookies(req) })