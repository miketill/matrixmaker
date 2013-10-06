import sys,os
# Change working directory so relative paths (and template lookup) work again
sys.path = [os.path.dirname(__file__)]+sys.path
os.chdir(os.path.dirname(__file__))

import bottle
import scfc
application = scfc.app
