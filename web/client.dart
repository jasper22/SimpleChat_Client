import 'dart:html';
import 'dart:async';
import 'package:web_ui/web_ui.dart';

import 'lib/RikuloChatClient.dart';

import 'NewsProxy.dart';


void main()
{
  // Enable this to use Shadow DOM in the browser.
  //useShadowDom = true;

  NewsProxy newsProxy;

  Client client = new Client(document.query("#main"));
  client.onUserLogin.stream.listen((userInfo){
    print('main::User login success');

    newsProxy = new NewsProxy(userInfo, serverAddress:'ws:/127.0.0.1:8080/ws');
    newsProxy.GetNewsForUser();
  });

  client.onRefreshNews.listen((_){
    newsProxy.GetNewsForUser();
  });

}
