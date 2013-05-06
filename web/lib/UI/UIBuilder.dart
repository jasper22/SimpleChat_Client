
part of rikulochat_client;

/*
 * Class build all UI elements
 */
class BuildUI
{
  StreamController<bool> _onButtonClick;
  StreamController<bool> _onRefreshClick;
  View mainView;

  /*
   * Default constructor
   *     [tagElement] Main HTML element that all interface build inside it
   */
  BuildUI.fromTag(Element tagElement)
  {
    _onButtonClick = new StreamController<bool>();
    _onRefreshClick = new StreamController<bool>();

    _buildUi(tagElement);
  }

  /*
   * Stream to 'SingIn with Google' button 'click' events
   */
  Stream get onSignWithGoogle
  {
    return _onButtonClick.stream;
  }

  /**
   * Event for 'refresh' button
   */
  Stream get onRefresh
  {
    return _onRefreshClick.stream;
  }

  /*
   * Function will show 'Access denied' dialog'
   */
  void LoginAccessDenied()
  {
    View vAccessDenied = new View();
    vAccessDenied.layout.type = 'linear';
    vAccessDenied.layout.orient = 'vertical';
    vAccessDenied.profile.width = '30%';
    vAccessDenied.profile.height = '20%';
    vAccessDenied.profile.location = 'center center';
    vAccessDenied.style.cssText ='background:red;';

    TextView vTextView = new TextView('Access denied');
    vAccessDenied.addChild(vTextView);

    Button vBtnOk = new Button();
    vBtnOk.text = 'Ok';
    vBtnOk.on.click.listen((evt){
      vAccessDenied.remove();
    });
    vAccessDenied.addChild(vBtnOk);

    vAccessDenied.addToDocument(mode: 'dialog');
  }

  void BuildViewFromGoogleProfile(Map<String, dynamic> googleProfile)
  {
//    Key is: id   and value is: 110171062275970993306
//    Key is: email   and value is: jjasper22@gmail.com
//    Key is: verified_email   and value is: true
//    Key is: name   and value is: Aleksandr Fusman
//    Key is: given_name   and value is: Aleksandr
//    Key is: family_name   and value is: Fusman
//    Key is: link   and value is: https://plus.google.com/110171062275970993306
//    Key is: picture   and value is: https://lh4.googleusercontent.com/-0cGbkNLV4C8/AAAAAAAAAAI/AAAAAAAAZZA/FGTYCMFDNKo/photo.jpg
//    Key is: gender   and value is: male
//    Key is: birthday   and value is: 0000-06-08
//    Key is: locale   and value is: en-GB

    var vLogo = mainView.query('#vLogo');
    if(vLogo == null)
    {
      throw new Exception('Logo is not found!');
    }

    vLogo.children.clear();
    vLogo.addChild(new Image(googleProfile['picture']));
    var fullName = googleProfile['name'];
    vLogo.addChild(new TextView.fromHtml('<pre>Welcome<br />$fullName </pre>'));

    var vButtonTmp = mainView.query('#vGoogleSign');
    vButtonTmp.remove();

    var vLeftBar = mainView.query('#vLeftBar');
    Button btnRefresh = new Button();
    btnRefresh.text = 'Refresh';
    btnRefresh.on.click.listen((data){
      _onRefreshClick.add(true);
    });
    vLeftBar.addChild(btnRefresh);

//    vLogo.requestLayout(true);
    vLeftBar.requestLayout(true);
  }

  /*
   * Function will actualy build View
   */
  void _buildUi(Element tagElement)
  {
    if (mainView != null)
    {
      mainView = null;
    }

    mainView = new View();
    mainView.profile.width = 'flex';
    mainView.profile.height = 'flex';
    mainView.layout.type = 'linear';
    mainView.layout.orient = 'vertical';
    mainView.style.cssText = "background: green;";

    View vWorkSpace = new View();
    vWorkSpace.id = 'vWorkSpace';
    vWorkSpace.profile.width = 'flex';
    vWorkSpace.profile.height = 'flex';
    vWorkSpace.layout.type = 'linear';
    vWorkSpace.layout.orient = 'horizontal';
    vWorkSpace.style.cssText = "background: red;";

    //
    // Left menu
    View vLeftBar = new View();
    vLeftBar.id = 'vLeftBar';
    vLeftBar.profile.width = "10%";
    vLeftBar.profile.height = "10%";
    vLeftBar.layout.type = 'linear';
    vLeftBar.layout.orient = 'vertical';
    vLeftBar.layout.spacing = '10';

    View vLogo = new View();
    vLogo.id = 'vLogo';
    vLogo.layout.type = 'linear';
    vLogo.layout.orient = 'vertical';
    vLogo.addChild(new Image('images/google_chrome.png'));
    vLeftBar.addChild(vLogo);

    Button vButton = new Button();
    vButton.id = 'vGoogleSign';
    vButton.text = 'Sign in with Google';
    vLeftBar.addChild(vButton);

    vButton.on.click.asBroadcastStream().listen(
          (val)
          {
            _onButtonClick.add(true);
          }
        );

    vWorkSpace.style.cssText = "background: blue;";
    vWorkSpace.addChild(vLeftBar);

    //
    // Middle
    View vMiddleTab = new View();
    vMiddleTab.id = 'vMiddleTab';
    vMiddleTab.profile.width = 'flex';
    vMiddleTab.profile.height = 'flex';
    vMiddleTab.layout.type = 'linear';
    vMiddleTab.layout.orient = 'horizontal';
    vMiddleTab.style.cssText = "background: yellow;";

    vWorkSpace.addChild(vMiddleTab);

    mainView.addChild(vWorkSpace);

    //
    // Footer
    View vFooter = new View();
    vFooter.id = 'vFooter';
    vFooter.profile.width = 'flex';
    vFooter.profile.height = '20%';
    vFooter.style.cssText = "background: black;";
    mainView.addChild(vFooter);

    mainView.addToDocument(ref: tagElement, layout: true);
  }
}