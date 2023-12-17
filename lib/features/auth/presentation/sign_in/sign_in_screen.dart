import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../configs/routes/app_router.dart';
import '../../../../utils/commons/functions/functions_common_export.dart';
import '../../../../utils/commons/widgets/widgets_common_export.dart';
import '../../../../utils/constants/asset_constant.dart';
import 'sign_in_controller.dart';
import '../../../../utils/resources/validations.dart';

@RoutePage()
class SignInScreen extends HookConsumerWidget with Validations {
  SignInScreen({super.key});

  // handle submit
  void submit({
    required GlobalKey<FormState> formKey,
    required BuildContext context,
    required WidgetRef ref,
    required String username,
    required String password,
  }) async {
    if (formKey.currentState!.validate()) {
      unfocus(context);
      await ref.read(signInControllerProvider.notifier).signIn(
            username,
            password,
            context,
          );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // init
    final size = MediaQuery.sizeOf(context);
    final username = useTextEditingController();
    final password = useTextEditingController();
    final state = ref.watch(signInControllerProvider);
    final formKey = useMemoized(GlobalKey<FormState>.new, const []);

    // first build
    useEffect(() {
      () async {
        await delay(true);
      };

      FlutterNativeSplash.remove();

      // check permission
      WidgetsBinding.instance.addPostFrameCallback((_) async {});

      return null;
    }, const []);

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.2),
          child: Stack(
            children: [
              const CustomAppBar(title: ''),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(AssetsConstants.defaultBorder),
                ),
                child: Image.asset(
                  AssetsConstants.welcomeImage,
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            right: AssetsConstants.defaultPadding,
            left: AssetsConstants.defaultPadding,
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.02),
                  LabelText(
                    content: 'Chào mừng bạn đến với MBKC'.toUpperCase(),
                    size: AssetsConstants.defaultFontSize - 8.0,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: size.height * 0.01),
                  const LabelText(
                    content: 'Hãy nhập tài khoản để tiếp tục',
                    size: AssetsConstants.defaultFontSize - 11.0,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: size.height * 0.02),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextInput(
                          textController: username,
                          hintText: 'Tài khoản',
                          onValidate: (val) => '',
                          autoFocus: true,
                        ),
                        SizedBox(height: size.height * 0.02),
                        PasswordInput(
                          textEditingController: password,
                          hintText: 'Mật khẩu',
                          onValidate: (val) => passwordMinErrorText(val),
                          autoFocus: false,
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            context.router.push(EnterEmailScreenRoute());
                          },
                          child: const LabelText(
                            content: 'Quên mật khẩu?',
                            size: AssetsConstants.defaultFontSize - 15.0,
                            fontWeight: FontWeight.w700,
                            color: AssetsConstants.subtitleColorM,
                            textDecoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(bottom: size.height * 0.04),
          padding: const EdgeInsets.only(
            right: AssetsConstants.defaultPadding,
            left: AssetsConstants.defaultPadding,
          ),
          child: ValueListenableBuilder2(
            first: username,
            second: password,
            builder: (_, a, b, __) => CustomButton(
              width: size.width * 1,
              height: size.height * 0.05,
              content: 'Đăng nhập',
              onCallback: () => submit(
                context: context,
                formKey: formKey,
                ref: ref,
                username: username.text.trim(),
                password: password.text.trim(),
              ),
              isActive: a.text.isNotEmpty && b.text.isNotEmpty,
              size: AssetsConstants.defaultFontSize - 10.0,
              backgroundColor: (a.text.isNotEmpty && b.text.isNotEmpty)
                  ? AssetsConstants.mainColor
                  : AssetsConstants.subtitleColor,
            ),
          ),
        ),
      ),
    );
  }
}
