import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/http_exception.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/utilis/constants.dart';
import 'package:shop_app/utilis/size.dart';
import '../add_new_product/validator.dart';

enum AuthStatus { SignUp, SignIn }

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth_screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with FormValidation, TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _emalFocused = FocusNode();
  // final _passwordFocused = FocusNode();
  // final _repeatPassFocused = FocusNode();

  // String email, pass, repeatPass;

  final Map<String, dynamic> _authData = {'email': '', 'password': ''};
  AuthStatus _authMode = AuthStatus.SignIn;
  List<String> authType = ["Sign In", "Sign Up"];
  int selectedIndex = 0;
  bool isLoading = false;

  void _toogleAuth(int index) {
    setState(() {
      selectedIndex = index;

      _authMode = selectedIndex == 0 ? AuthStatus.SignIn : AuthStatus.SignUp;

      if (_authMode == AuthStatus.SignIn) {
        _animationController.reverse();
      } else if (_authMode == AuthStatus.SignUp) {
        _animationController.forward();
      }
      _emailController.clear();
      _passwordController.clear();
      _confirmController.clear();
    });
  }

  void _signUp() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    _formKey.currentState.save();
    try {
      if (_authMode == AuthStatus.SignUp) {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['email'], _authData['password']);
      } else if (_authMode == AuthStatus.SignIn) {
        await Provider.of<Auth>(context, listen: false)
            .signIn(_authData['email'], _authData['password']);
      }
    } on HttpException catch (error) {
      var _errorMessage = 'Authentication failed!';
      if (error.toString().contains('EMAIL_EXISTS')) {
        _errorMessage = 'This email address already exists';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        _errorMessage = 'Password is invalid!';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        _errorMessage = 'Email not found!';
      }
      _showErrorDialoge(_errorMessage);
    } catch (error) {
      const _errorMessage = 'Authentication failed!';
      _showErrorDialoge(_errorMessage);
    }
    setState(() {
      isLoading = false;
    });
  }

  final _formKey = GlobalKey<FormState>();
  AnimationController _animationController;
  Animation<double> _animation;
  Animation<Offset> _slideanimation;
  @override
  void initState() {
    _animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);

    _slideanimation = Tween<Offset>(begin: Offset(0, -0.5), end: Offset(0, 0))
        .animate(
            CurvedAnimation(parent: _animationController, curve: Curves.ease));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.ease));

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _emalFocused.dispose();
    super.dispose();
  }

  void _showErrorDialoge(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('An error occured'),
              content: Text(message),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'))
              ],
            ));
  }

  bool _toogle = true;
  void _show() {
    if (_passwordController.text.isNotEmpty) {
      setState(() {
        _toogle = !_toogle;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        body: Column(
      children: [
        Flexible(
          child: Image.asset(
            'assets/images/clip-fast-delivery-right-in-time.png',
            height: 300,
          ),
        ),
        SizedBox(
            width: double.infinity,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ...List.generate(
                authType.length,
                (index) => GestureDetector(
                  onTap: () => _toogleAuth(index),
                  child: AnimatedContainer(
                    constraints: BoxConstraints(
                        minWidth: 80,
                        maxWidth: selectedIndex == index ? 120 : 100),
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInCubic,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: selectedIndex == index
                          ? Colors.green[100]
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(27.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          authType[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: selectedIndex == index
                                  ? Colors.black
                                  : Colors.grey,
                              fontSize: selectedIndex == index ? 20 : 18,
                              fontWeight: FontWeight.bold),
                        ),
                        //
                      ],
                    ),
                  ),
                ),
              ),
            ])),
        SizedBox(height: 20),
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildEmailForm(),
                SizedBox(height: 20),
                buildPasswordFrom(),
                _authMode == AuthStatus.SignUp
                    ? AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn,
                        child: FadeTransition(
                            opacity: _animation,
                            child: SlideTransition(
                              position: _slideanimation,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: buildRepeatPasswordFrom(),
                              ),
                            )),
                      )
                    : SizedBox(),
                SizedBox(height: 20),
                isLoading ? CircularProgressIndicator() : SizedBox(),
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: RaisedButton(
                      disabledColor: Colors.indigo.withOpacity(0.5),
                      color: Colors.indigo,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: isLoading ? null : _signUp,
                      child: Text(
                        _authMode == AuthStatus.SignIn
                            ? 'Sign In'.toUpperCase()
                            : 'Sign Up'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        _authMode == AuthStatus.SignIn
            ? Container(
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(right: 30),
                child: Text(
                  'forgot password',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.brown,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      decoration: TextDecoration.underline),
                ),
              )
            : SizedBox(),
      ],
    ));
  }

  TextFormField buildEmailForm() {
    return TextFormField(
      controller: _emailController,
      style: TextStyle(fontSize: getTextSize(18)),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      cursorWidth: 4.0,
      onSaved: (newValue) => _authData['email'] = _emailController.text,
      onChanged: (value) {
        if (value.isNotEmpty) {
          return "";
        } else if (emailValidatorRegExp.hasMatch(value)) {
          return "";
        }
      },
      validator: validateEmail, //which are located at ValidationMixin class
      decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'Enter your email',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: IconButton(
              onPressed: () {
                _emailController.clear();
              },
              icon: Icon(Icons.clear, size: 20))),
    );
  }

  TextFormField buildPasswordFrom() {
    return TextFormField(
      controller: _passwordController,
      style: TextStyle(fontSize: getTextSize(18)),
      obscureText: _toogle,
      cursorWidth: 4.0,
      onSaved: (newValue) => _authData['password'] = _passwordController.text,
      onChanged: (value) {
        if (value.isNotEmpty) {
          return "";
        } else if (value.length >= 8) {
          return "";
        }
      },
      validator: validatePassword, //which are located at ValidationMixin class
      decoration: InputDecoration(
          labelText: 'Pasword',
          hintText: 'Enter your password',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: IconButton(
            onPressed: () {
              _show();
            },
            icon: Icon(
                _toogle ? Icons.remove_red_eye_outlined : Icons.remove_red_eye,
                color: _toogle ? Colors.grey : Colors.red),
          )),
    );
  }

  TextFormField buildRepeatPasswordFrom() {
    return TextFormField(
      controller: _confirmController,
      obscureText: true,
      cursorWidth: 4.0,
      // onSaved: (newValue) => repeatPass = _confirmController.text,
      onChanged: (value) {
        if (value.isNotEmpty) {
          return "";
        } else if (value.length >= 8) {
          return "";
        }
      },
      validator: validatePassword, //which are located at ValidationMixin class
      style: TextStyle(fontSize: getTextSize(18)),
      decoration: InputDecoration(
        labelText: 'Confirm password',
        hintText: 'Confirm password',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
