<!DOCTYPE html>
<html>
    <head>
        <title>SCFC Volunteer</title>
        <link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
        <script src="js/jquery-1.9.0.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script>
            function create_account() {
                $('#create_account').modal();
            }
            function login() {
                $('#login_account').modal();
            }
        </script>
    </head>
    <body>
        <div class='container'>
            <div class='navbar'>
                <div class='navbar-inner'>
                    %if session['logged_in']:
                        <a class='brand' href='#'>Hello {{session['user']}}</a>
                        <a class='pull-right' href='/account/logout'>logout</a>
                    %else:
                        <ul class='nav pull-right'>
                            <li><a href='#' onclick='login()'>Login</a></li>
                            <li><a href='#' onclick='create_account()' >Create Account</a></li>
                        </ul>
                    %end
                </div>
            </div>
            %if session['logged_in']:
            <h2>My Matrices</h2>
            %for m in matrices:
                <a href='{{m['_id']}}'>{{m['name']}}</a><br>
            %end
            %end
        </div>
        <!--dialogs-->
        <div id='create_account' class='modal hide fade' tabindex='-1' role='dialog' aria-labelledby='create_account_label' aria-hidden='true'>
            <div class='modal-header'>
                <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>x</button>
                <h3 id='create_account_label'>Please enter you information</h3>
                <form id='create_account_form' action='/account/create' method='POST'>
                    <input type='hidden' name='current' value='/'>
                    <div class="modal-body">
                        <label for='ca_email'>Email:</label><input id='ca_email' name='email'>
                        <label for='ca_password'>Password:</label><input type='password' id='ca_password' name='password'>
                    </div>
                    <div class="modal-footer">
                        <button type='button' class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
                        <button class="btn btn-primary">Create Account</button>
                    </div>
                </div>
            </form>
        </div>
        <div id='login_account' class='modal hide fade' tabindex='-1' role='dialog' aria-labelledby='login_account_label' aria-hidden='true'>
            <div class='modal-header'>
                <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>x</button>
                <h3 id='login_account_label'>Please enter you information</h3>
                <form id='login_account_form' action='/account/login' method='POST'>
                    <input type='hidden' name='current' value='/'>
                    <div class="modal-body">
                        <label for='la_email'>Email:</label><input id='la_email' name='email'>
                        <label for='la_password'>Password:</label><input type='password' id='la_password' name='password'>
                    </div>
                    <div class="modal-footer">
                        <button type='button' class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
                        <button class="btn btn-primary">Login</button>
                    </div>
                </div>
            </form>
        </div>
    </body>
</html>
