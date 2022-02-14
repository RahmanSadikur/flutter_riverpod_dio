import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio_riverpod/provider/loginProvider.dart';
import 'package:dio_riverpod/screen/homeScreen.dart';

final loginNotifierProvider =
    ChangeNotifierProvider<LoginProvider>((ref) => LoginProvider());

class LoginScreen extends ConsumerWidget {
  static const routeName = '/login';
  final _passwordfocus = FocusNode();
  final _form = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  _verifyLogin(BuildContext context, LoginProvider loginProvider) async {
    final isvalid = _form.currentState!.validate();
    if (!isvalid) {
      return;
    }
    _form.currentState!.save();
    await loginProvider
        .login(_userNameController.text, _passwordController.text)
        .then((_) {
      if (loginProvider.isLoggedIn) {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      } else {
        _showErrorDialogue(loginProvider.errorMessage, context);
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'You are offline, Please check your internet Connection!',
          textAlign: TextAlign.start,
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  }

  _showErrorDialogue(String errorMsg, context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(errorMsg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final loginProvider = ref.watch(loginNotifierProvider);

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).primaryColor,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Container(
              height: mediaQuery,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Container(
                  //   width: 170,
                  //   height: 170,
                  //   child: Image.asset(
                  //     'assets/logo/aiub_logo_with_text.webp',
                  //     fit: BoxFit.contain,
                  //   ),
                  // ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 0,
                            ),
                            child: SizedBox(
                              height: 60,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  isDense: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  labelText: 'Student ID',
                                  prefixIcon: Icon(Icons.person_outlined),
                                  filled: true,
                                  fillColor: Theme.of(context).canvasColor,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                controller: _userNameController,
                                textInputAction: TextInputAction.next,
                                autofocus: true,
                                keyboardType: TextInputType.number,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_passwordfocus);
                                },
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return 'Enter Valid Student ID';
                                  }
                                  String pattern1 =
                                      r'(^[0-9]{2}-[0-9]{5}-[1-3]$)';
                                  RegExp regExp1 = new RegExp(pattern1);
                                  if (!regExp1.hasMatch(v)) {
                                    return 'Enter Valid Student ID';
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            // height: _passwordError ? 60 : 40,
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 0,
                            ),
                            child: SizedBox(
                              height: 60,
                              child: TextFormField(
                                obscureText: !loginProvider.passwordVisible,
                                decoration: InputDecoration(
                                  isDense: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  labelText: 'Password',
                                  prefixIcon: Icon(
                                    Icons.lock_outlined,
                                  ),
                                  filled: true,
                                  fillColor: Theme.of(context).canvasColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      loginProvider.passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      loginProvider.togglePasswordVisible();
                                    },
                                  ),
                                ),
                                controller: _passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                focusNode: _passwordfocus,
                                onFieldSubmitted: (_) {
                                  _verifyLogin(context, loginProvider);
                                },
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return 'Enter Valid Password';
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 3,
                          child: BouncingWidget(
                            scaleFactor: 0.5,
                            onPressed: () => {
                              _verifyLogin(context, loginProvider),
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide')
                            },
                            child: Container(
                              //padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Theme.of(context).accentColor,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).canvasColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                      ],
                    ),
                  ),

                  //  isLoading
                  //       ? Center(
                  //           child: Lottie.asset(
                  //             'assets/lottie_files/loader.zip',
                  //             width: 180,
                  //             height: 180,
                  //             fit: BoxFit.contain,
                  //             repeat: true,
                  //           ),
                  //         )
                  //       : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
