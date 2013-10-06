import pymongo
import bottle
import bson
import bcrypt
from bottle import static_file, route, redirect, template, request, response
from bson import ObjectId
from beaker.middleware import SessionMiddleware

session_opts = {
    'session.type': 'file',
    'session.cookie_expires': 1800,
    'session.data_dir': './sessions',
    'session.auto': True
}
app = SessionMiddleware(bottle.app(), session_opts)

conn_string = 'mongodb://localhost'

@route('/js/<filename:path>')
def send_css(filename):
    return static_file(filename, root='js')

@route('/css/<filename:path>')
def send_css(filename):
    return static_file(filename, root='css')

@route('/favicon.ico')
def favicon():
    bottle.abort(404)

@route('/')
def index():
    return template('index')

@route('/account/logout')
def logout():
    session = request.environ.get('beaker.session')
    session['logged_in'] = False
    redirect('/'+request.query['m_id'])

@route('/account/create', method='POST')
def create_account():
    email = request.forms.email
    password = request.forms.password
    if len(email) > 0 and len(password) > 0:
        conn = pymongo.Connection(conn_string)
        db = conn.scfc
        r = db.users.find_one({'_id':email})
        if r == None:
            pw_hash = bcrypt.hashpw(password, bcrypt.gensalt())
            db.users.insert({'_id':email,'pw_hash':pw_hash,'admin':False})
    return login()

@route('/account/login', method='POST')
def login():
    email = request.forms.email
    password = request.forms.password
    current_matrix = request.forms.matrix
    if len(email) > 0 and len(password) > 0:
        conn = pymongo.Connection(conn_string)
        db = conn.scfc
        import re
        regex = re.compile('^'+email+'$', re.IGNORECASE)
        r = db.users.find_one({'_id':regex})
        if r:
            session = request.environ.get('beaker.session')
            if r['pw_hash'] == bcrypt.hashpw(password, r['pw_hash']):
                session['logged_in'] = True
                session['user'] = r['_id']
                session['admin'] = r['admin']
            else:
                session['logged_in'] = False
    redirect('/'+current_matrix)

@route('/<matrix_id>')
def matrix(matrix_id):
    session = request.environ.get('beaker.session')
    if not session.has_key('logged_in'):
        session['logged_in'] = False

    m = get_matrix(matrix_id)
    if m:
        return template('matrix',m=m['matrix'],matrix_id=matrix_id,session=session)
    else:
        redirect('/')

@route('/<matrix_id>/clear', method='POST')
def clear_slot(matrix_id):
    session = request.environ.get('beaker.session')
    if session['logged_in'] and session['admin']:
        m = request.forms.m
        x = request.forms.x
        y = request.forms.y
        if x and y and m:
            conn = pymongo.Connection(conn_string)
            db = conn.scfc
            db.matrices.update({'_id':ObjectId(matrix_id)},{'$unset':{'matrix.'+m+'.3.'+x+'~'+y:1}})
    redirect('/'+matrix_id)

@route('/<matrix_id>', method='POST')
def select_slot(matrix_id):
    record = get_matrix(matrix_id)
    if record:
        session = request.environ.get('beaker.session')
        m = record['matrix']
        slot_x = request.forms.slot_x
        slot_y = request.forms.slot_y
        name = request.forms.v_name
        phone = request.forms.v_phone
        email = request.forms.v_email
        matrix_number = int(request.forms.matrix_number)
        matrix = m[matrix_number]
        slots = matrix[3]
        slot_key = slot_x+"~"+slot_y
        if not slots.has_key(slot_key):
            slots[slot_key] = {'name':name, 'phone':phone, 'email':email}
            save_matrix(record)
        redirect('/'+matrix_id)
    else:
        redirect('/')

def save_matrix(matrix):
    conn = pymongo.Connection(conn_string)
    db = conn.scfc
    db.matrices.save(matrix)

def get_matrix(matrix_id):
    conn = pymongo.Connection(conn_string)
    db = conn.scfc
    return db.matrices.find_one({'_id':ObjectId(matrix_id)})

if __name__ == '__main__':
    bottle.run(app=app, host='localhost', port='8080', reloader=True, debug=True)
