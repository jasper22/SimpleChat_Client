
part of rikulochat_client;

/*
 * Class will 'pull' news from server
 */
class NewsProxy
{
  StreamController<bool> _onNewsReceived;
  StreamController<bool> _onServerError;
  Map<String, dynamic> _userInfoData;
  WebSocket webSocket;
  const String SERVER_ADDRESS = 'ws:/127.0.0.1:8080';

  /*
   * Default ctor
   *     [userInfoData] 'Map' received from Google server (including 'token')
   */
  NewsProxy(Map<String, dynamic> userInfoData, {String serverAddress:null})
  {
    this._userInfoData = userInfoData;

    if (serverAddress == null)
    {
      serverAddress = SERVER_ADDRESS;
    }

    _onNewsReceived = new StreamController<bool>();
    _onServerError = new StreamController<bool>();

    _connect(serverAddress);
  }

  void GetNewsForUser()
  {
    if (webSocket != null && webSocket.readyState == WebSocket.OPEN)
    {
//      this._userInfoData.putIfAbsent('Command', ()=> 'Send me news');
//      String msg = JSON.stringify(_userInfoData);

      SimpleMessage tmpMessage = new SimpleMessage(this._userInfoData['name'].toString(),to:'Server', text:'Hello server');
      String msg = JSON.stringify(tmpMessage);

      webSocket.send(msg);
      print('[NewsProxy::GetNewsForUser] Message was send');
    }
    else
    {
      print('[NewsProxy::GetNewsForUser] Could not send message');
    }
  }

  /*
   * Event will be raised when 'new' news received from server
   */
  Stream get OnNewsReceived
  {
    return _onNewsReceived.stream;
  }

  /*
   * Event will be raised when server error occures
   */
  Stream get OnServerError
  {
    return _onServerError.stream;
  }

  /**
   * Function will connect to WebSocket server at [serverAddress]
   */
  void _connect(String serverAddress)
  {
    webSocket = new WebSocket(serverAddress);
    webSocket.onOpen.listen(ws_onOpen);
    webSocket.onClose.listen(ws_onClose);
    webSocket.onMessage.listen(ws_onMessage);
    webSocket.onError.listen(ws_onError);
  }

  void ws_onOpen(Event openEvent)
  {
    print('[NewsProxy::ws_onOpen] Received open(!) event: $openEvent');
  }

  void ws_onClose(CloseEvent close)
  {
    print('[NewsProxy::ws_onClose] Received close event: $close');
  }

  void ws_onMessage(MessageEvent msg)
  {
    print('[NewsProxy::ws_onMessage] Received message: $msg');
  }

  void ws_onError(Event errorEvent)
  {
    print('[NewsProxy::ws_onError] Received error: $errorEvent');
  }
}