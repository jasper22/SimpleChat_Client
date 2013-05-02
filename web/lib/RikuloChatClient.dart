
library rikulochat_client;

import 'dart:html';
import 'dart:async';
import 'dart:uri';
import 'dart:json' as JSON;

//
// Rikulo UI
import 'package:rikulo_ui/view.dart';
import "package:rikulo_commons/util.dart";
import "package:rikulo_commons/async.dart";
import 'package:rikulo_commons/html.dart';

//
// Google SingIn
import 'package:google_oauth2_client/google_oauth2_browser.dart';


//
//
part 'UI/UIBuilder.dart';


/*
 * Main 'client' object
 */
class Client
{
  BuildUI _buildUi;

  GoogleOAuth2 _auth;

  StreamController<Map<String, dynamic>> onUserLogin;
  StreamController<bool> _onRefreshRequest;

  /*
   * Default constructor
   *     [mainHTMLtagName] All UI will be build inside this tag
   */
  Client(Element mainHTMLtagName)
  {
    _onRefreshRequest = new StreamController<bool>();

    _auth = new GoogleOAuth2(
        '568630157444-o6d8hhtf6ueu65jrqpl7cgjl0knegtrg.apps.googleusercontent.com', // Client ID
        ['openid', 'email', 'profile'],
        tokenLoaded:oauthReady);

    _buildUi = new BuildUI.fromTag(mainHTMLtagName);
    _buildUi.onSignWithGoogle.listen(
        (val){
          _googleLogin();
        }
    );

    _buildUi.onRefresh.listen((_){
      _onRefreshRequest.add(true);
    });

    onUserLogin = new StreamController<Map<String, dynamic>>();
  }

  /*
   * Event will be raised when user logged in
   * Stream of UserInfo data ( Map<String, dynamic> )
   */
  Stream get onUserLoginEvent
  {
    return onUserLogin.stream;
  }

  /**
   * User click on 'refresh' button
   */
  Stream get onRefreshNews
  {
    return _onRefreshRequest.stream;
  }

  void _googleLogin()
  {
    _auth.logout();
    _auth.token = null;

    _auth.login().then(
        (_){
          //print('Why do I get here ? I should send to oauthReady() function');
        })
        .catchError( (onError){
          print('AuthException occurred');
          _buildUi.LoginAccessDenied();
        }, test: (e) => e is AuthException)
        .catchError((onError){
          print('Another error occurred: $onError');
        });

  }

  void oauthReady(Token token)
  {
    print('Token is: $token');

    // Ask for User info
    // https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=ya29.AHES6ZRtfdpaDXyA697D8s0j9zq2YRIthEBSb8yRxYuGroc6PwPM6w

    Uri googleUserInfo = Uri.parse('https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=${token.data}');

//    HttpRequest userInfoRequest = new HttpRequest();
//
//    userInfoRequest.onReadyStateChange.listen((_){
//      if (userInfoRequest.readyState == HttpRequest.DONE && (userInfoRequest.status == 200 || userInfoRequest.status == 0))
//      {
//              // data saved OK.
//              print('Server responded ${userInfoRequest.responseText}'); // output the response from the server
//      }
//      else
//      {
//        print('Server responded with: ${userInfoRequest.readyState}');
//      }
//    });
//
//    userInfoRequest.open("GET", googleUserInfo.toString(), async: true);
//    print('Request send');

      var request = HttpRequest.getString(googleUserInfo.toString()).then((jsonResponse){
        Map<String, dynamic> receivedData = JSON.parse(jsonResponse);

//        receivedData.forEach( (key,value){
//          print('Key is: $key   and value is: $value');
//        });

        if (receivedData != null)
        {
          _buildUi.BuildViewFromGoogleProfile(receivedData);

          receivedData.putIfAbsent('token', ()=> token.data);

          onUserLogin.add(receivedData);
        }

      }, onError: (err) {
        print('Error occurred in JSON request: $err');
      });
  }
}