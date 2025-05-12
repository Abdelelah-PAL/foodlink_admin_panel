import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/providers/admins_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../core/constants/assets.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/size_config.dart';
import '../../providers/authentication_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/translation_services.dart';
import '../widgets/custom_text.dart';
import 'widgets/custom_auth_btn.dart';
import 'widgets/custom_auth_divider.dart';
import 'widgets/custom_auth_footer.dart';
import 'widgets/custom_auth_textfield.dart';
import 'widgets/custom_error_txt.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = AuthController();
    _authController.getLoginInfo();
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionalWidth(10)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizeConfig.customSizedBox(
                        179, 179, Image.asset(Assets.pureLogo)),
                    Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.getProportionalHeight(10),
                            bottom: SizeConfig.getProportionalHeight(13)),
                        child: const CustomText(
                          isCenter: true,
                          text: "welcome_back",
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                          color: AppColors.fontColor,
                        )),
                    CustomErrorTxt(
                      text: TranslationService()
                          .translate(_authController.errorText),
                      settingsProvider: settingsProvider,
                    ),
                    SizeConfig.customSizedBox(null, 6, null),
                    CustomAuthenticationTextField(
                        hintText: 'example@example.com',
                        obscureText: false,
                        textEditingController: _authController.emailController,
                        borderColor: _authController.emailTextFieldBorderColor,
                        settingsProvider: settingsProvider),
                    SizeConfig.customSizedBox(
                      null,
                      15,
                      null,
                    ),
                    CustomAuthenticationTextField(
                      hintText:
                          TranslationService().translate('enter_password'),
                      settingsProvider: settingsProvider,
                      obscureText: true,
                      textEditingController: _authController.passwordController,
                      borderColor: _authController.passwordTextFieldBorderColor,
                    ),
                    SizeConfig.customSizedBox(
                      null,
                      15,
                      null,
                    ),
                    SizeConfig.customSizedBox(
                      312,
                      48,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: AppColors.textFieldBorderColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                width: SizeConfig.getProportionalWidth(10),
                                height: SizeConfig.getProportionalHeight(10),
                                child: Checkbox(
                                  activeColor: AppColors.backgroundColor,
                                  checkColor: AppColors.fontColor,
                                  value: _authController.rememberMe,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      _authController.toggleRememberMe();
                                    });
                                  },
                                  side: const BorderSide(
                                      color: AppColors
                                          .textFieldBorderColor),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: SizeConfig.getProportionalWidth(10)),
                                child: Text(
                                  TranslationService().translate("remember_me"),
                                  style: TextStyle(
                                    fontFamily: AppFonts.primaryFont,
                                    fontSize: 15,
                                    color: AppColors.fontColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              TranslationService().translate("forgot_password"),
                              style: TextStyle(
                                fontFamily: AppFonts.primaryFont,
                                fontSize: 16,
                                color: AppColors.errorColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizeConfig.customSizedBox(null, 15, null),
                    CustomAuthBtn(
                      text: TranslationService().translate('login'),
                      onTap: () async {
                        _authController.checkEmptyFields(true);
                        if (!_authController.noneIsEmpty) {
                          setState(() {
                            _authController.changeTextFieldsColors(true);
                          });
                          return;
                        } else {
                          setState(() {
                            _authController.changeTextFieldsColors(true);
                          });

                          var checkedEmailAdmin = await AdminsProvider()
                              .getAdminByEmail(
                                  _authController.emailController.text);
                          var admin = await AuthProvider().login(
                            _authController.emailController.text,
                            _authController.passwordController.text,
                          );

                          if (admin == null || checkedEmailAdmin == null) {
                            setState(() {
                              _authController.setWrongEmailOrPassword();
                            });

                            return;
                          } else {
                            if (_authController.rememberMe == true) {
                              Get.toNamed('/dashboard');
                              _authController.saveLoginInfo(
                                admin.user!.email!,
                                _authController.passwordController.text,
                              );
                            }
                          }
                        }
                      },
                    ),

                    CustomAuthFooter(
                        headingText: "do_not_have_account",
                        tailText: "signup",
                        onTap: () => {Get.toNamed('/')},
                        settingsProvider: settingsProvider)
                  ])),
        ));
  }
}
