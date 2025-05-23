import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:routefly/routefly.dart';

import '../../../../app_widget.dart';
import '../../../../config/dependencies.dart';
import '../../../../domain/dto/recover_password_send_email_dto.dart';
import '../../../../domain/validators/recover_password_send_email_validation.dart';
import '../../../design_system/constants/spaces.dart';
import '../../../design_system/theme/theme.dart';
import '../../../design_system/widgets/alert_widget.dart';
import '../../../design_system/widgets/button_widget.dart';
import '../../../design_system/widgets/input_widget.dart';
import 'send_email_viewmodel.dart';

class SendEmailPage extends StatefulWidget {
  const SendEmailPage({super.key});

  @override
  State<SendEmailPage> createState() => _SendEmailPageState();
}

class _SendEmailPageState extends State<SendEmailPage> {
  final viewmodel = injector.get<SendEmailViewmodel>();
  final formKey = GlobalKey<FormState>();
  final validator = RecoverPasswordSendEmailValidation();
  final credentials = RecoverPasswordSendEmailDto();

  final isButtonEnabled = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _updateButtonState();
    viewmodel.requestToRecoverPasswordCommand.addListener(listener);
  }

  void listener() {
    if (viewmodel.requestToRecoverPasswordCommand.isFailure) {
      AlertWidget.error(context, message: 'Não foi possível enviar o código!');
      return;
    }

    if (viewmodel.requestToRecoverPasswordCommand.isSuccess &&
        context.mounted) {
      Routefly.pop(context);
      Routefly.push(
        routePaths.auth.recoverPassword.otp.otpRecover,
        arguments: credentials.email,
      );
    }
  }

  void _updateButtonState() {
    final exceptions = validator.getExceptions(credentials);

    isButtonEnabled.value = exceptions.isNotEmpty;
  }

  _onSubmit() {
    if (formKey.currentState!.validate()) {
      viewmodel.requestToRecoverPasswordCommand.execute(credentials);
    }
  }

  @override
  void dispose() {
    super.dispose();
    viewmodel.requestToRecoverPasswordCommand.removeListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: InkWell(
          onTap: () => Routefly.pop(context),
          child: Icon(
            Iconsax.arrow_left_2,
            size: Spaces.xl,
            color: context.colors.whiteColor,
          ),
        ),
        title: Text(
          'Recuperar senha',
          style: context.text.bodyXL18Bold.copyWith(
            color: context.colors.whiteColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spaces.l),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              spacing: Spaces.l,
              children: [
                Container(
                  width: Spaces.xxxxl,
                  height: Spaces.xxxxl,
                  margin: const EdgeInsets.only(top: Spaces.xxxl),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Spaces.xxxxl),
                    border: Border.all(color: context.colors.errorLightColor),
                  ),
                  child: Icon(
                    Iconsax.sms,
                    color: context.colors.errorLightColor,
                    size: Spaces.xl,
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: Text(
                    'Informe o seu e-mail cadastrado, iremos te enviar um código de verificação!',
                    textAlign: TextAlign.center,
                    style: context.text.bodyL16Bold.copyWith(
                      fontWeight: FontWeight.w400,
                      color: context.colors.whiteColor,
                    ),
                  ),
                ),
                InputWidget(
                  label: 'E-mail',
                  hintText: 'Informe seu email',
                  onChanged: (value) {
                    credentials.setEmail(value);
                    _updateButtonState();
                  },
                  validator: validator.byField(credentials, 'email'),
                ),
                Container(
                  margin: const EdgeInsets.only(top: Spaces.xxxl),
                  width: 250,
                  child: ListenableBuilder(
                    listenable: Listenable.merge([
                      isButtonEnabled,
                      viewmodel.requestToRecoverPasswordCommand,
                    ]),
                    builder: (context, _) {
                      return ButtonWidget.filledPrimary(
                        onPressed: _onSubmit,
                        disabled:
                        isButtonEnabled.value ||
                            viewmodel.requestToRecoverPasswordCommand.isRunning,
                        text: 'Enviar código',
                        padding: const EdgeInsets.symmetric(
                          vertical: Spaces.xl - Spaces.xs,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}