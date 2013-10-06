<!DOCTYPE html>
<html>
    <head>
        <title>SCFC Volunteer</title>
        <link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
        <script src="js/jquery-1.9.0.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script>
            function clear_slot(m,x,y) {
                $('#clear_x').val(x);
                $('#clear_y').val(y);
                $('#clear_m').val(m);
                $('#clear_slot').submit();
            }
            function select_slot(mn,x,y) {
                $('#slot_x').val(x);
                $('#slot_y').val(y);
                $('#matrix_number').val(mn);
                $('#v_info').modal();
            }
            function create_account() {
                $('#create_account').modal();
            }
            function login() {
                $('#login_account').modal();
            }
        </script>
    </head>
    <body>
        <form id='clear_slot' method='post' action='/{{matrix_id}}/clear'>
            <input id='clear_m' type='hidden' name='m'>
            <input id='clear_x' type='hidden' name='x'>
            <input id='clear_y' type='hidden' name='y'>
        </form>
        <div class='container'>
            <div class='navbar'>
                <div class='navbar-inner'>
                    %if session['logged_in']:
                        <a class='brand' href='#'>Hello {{session['user']}}</a>
                        <a class='pull-right' href='/account/logout?m_id={{matrix_id}}'>logout</a>
                    %else:
                        <ul class='nav pull-right'>
                            <li><a href='#' onclick='login()'>Login</a></li>
                            <li><a href='#' onclick='create_account()' >Create Account</a></li>
                        </ul>
                    %end
                </div>
            </div>
            <div class='row'>
                <hr>
                %for matrix_number in range(len(m)):
                %matrix = m[matrix_number]
                <h1>{{matrix[0]}}</h1>
                <table class='table'>
                    <thead>
                        <tr>
                            <td>&nbsp;</td>
                            %for x_name in matrix[1]:
                                <td>{{x_name}}</td>
                            %end
                        </tr>
                    </thead>
                    <tbody>
                        %for y_name in matrix[2]:
                            <tr>
                                <td>{{y_name}}</td>
                                %for x_name in matrix[1]:
                                    %if matrix[3].has_key(x_name+'~'+y_name):
                                        %if session['logged_in'] and session['admin']:
                                            <td>
                                                {{matrix[3][x_name+'~'+y_name]['name']}}<br>
                                                {{matrix[3][x_name+'~'+y_name]['email']}}<br>
                                                {{matrix[3][x_name+'~'+y_name]['phone']}}<br>
                                                <a href='#' onclick="clear_slot({{matrix_number}},'{{x_name}}','{{y_name}}')">Clear</a>
                                            </td>
                                        %else:
                                            <td>{{matrix[3][x_name+'~'+y_name]['name']}}</td>
                                        %end
                                    %else:
                                    <td><input type='button' value='Register' onclick="select_slot('{{matrix_number}}','{{x_name}}','{{y_name}}')"></td>
                                    %end
                                %end
                            </tr>
                        %end
                    </tbody>
                </table>
                <hr>   
                %end
            </div>
        </div>
        <div id='v_info' class='modal hide fade' tabindex='-1' role='dialog' aria-labelledby='v_info_label' aria-hidden='true'>
            <div class='modal-header'>
                <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>x</button>
                <h3 id='v_info_label'>Please enter you information</h3>
                <form id='v_form' method='POST'>
                    <input type='hidden' name='slot_x' id='slot_x'>
                    <input type='hidden' name='slot_y' id='slot_y'>
                    <input type='hidden' name='matrix_number' id='matrix_number'>
                    <div class="modal-body">
                        <label for='v_name'>Name:</label><input id='v_name' name='v_name'>
                        <label for='v_phone'>Phone:</label><input id='v_phone' name='v_phone'>
                        <label for='v_email'>Email:</label><input id='v_email' name='v_email'>
                    </div>
                    <div class="modal-footer">
                        <button type='button' class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
                        <button class="btn btn-primary">Save changes</button>
                    </div>
                </div>
            </form>
        </div>
        <div id='create_account' class='modal hide fade' tabindex='-1' role='dialog' aria-labelledby='create_account_label' aria-hidden='true'>
            <div class='modal-header'>
                <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>x</button>
                <h3 id='create_account_label'>Please enter you information</h3>
                <form id='create_account_form' action='/account/create' method='POST'>
                    <input type='hidden' name='matrix' value='{{matrix_id}}'>
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
                    <input type='hidden' name='matrix' value='{{matrix_id}}'>
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
    </div>
</body>
</html>
