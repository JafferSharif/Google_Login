import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
  'profile',
  'email',
]);

void main() {
  runApp(MaterialApp(
    title: 'Google sign in',
    home: SignInDemo(),
  ));
}

class SignInDemo extends StatefulWidget {
  @override
  _SignInDemoState createState() => _SignInDemoState();
}

class _SignInDemoState extends State<SignInDemo> {
  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign in Demo'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_currentUser != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  leading: GoogleUserCircleAvatar(identity: _currentUser),
                  title: Text(_currentUser.displayName ?? ''),
                  subtitle: Text(_currentUser.email ?? ''),
                ),
                RaisedButton(
                  onPressed: _handleSignOut,
                  child: Text('SIGN OUT'),
                ),
              ]),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(vertical:20.0,horizontal:20.0),
        margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
        decoration: BoxDecoration(
          color: Colors.brown[100],
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('You are not signed in'),
            RaisedButton(
              onPressed: _handleSignIn,
              child: Text('SIGN IN'),
            ),
          ],
        ),
      );
    }
  }
}

Future<void> _handleSignIn() async {
  try {
    await _googleSignIn.signIn();
    print('sigin');
  } catch (error) {
    print(error);
  }
}

Future<void> _handleSignOut() async {
  await _googleSignIn.disconnect();
}
