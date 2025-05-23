import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:routefly/routefly.dart';

import '../design_system/constants/spaces.dart';
import '../design_system/theme/theme.dart';
import '../design_system/widgets/button_widget.dart';

class FeedbackErrorPage extends StatefulWidget {
  const FeedbackErrorPage({super.key});

  @override
  State<FeedbackErrorPage> createState() => _FeedbackErrorPageState();
}

class _FeedbackErrorPageState extends State<FeedbackErrorPage> {
  late final FeedbackErrorArgument arguments;

  @override
  void initState() {
    super.initState();
    assert(
      Routefly.query.arguments is FeedbackErrorArgument,
      'FeedbackErrorPage espera um argumento do tipo FeedbackErrorArgument via Routefly.query.arguments, mas recebeu: ${Routefly.query.arguments.runtimeType}',
    );

    arguments = Routefly.query.arguments as FeedbackErrorArgument;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: Spaces.l,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Spaces.xxxxl,
              height: Spaces.xxxxl,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Spaces.xxxxl),
                border: Border.all(color: context.colors.errorLightColor),
              ),
              child: Icon(
                Iconsax.danger,
                color: context.colors.errorLightColor,
                size: Spaces.xl,
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                'Não foi possível concluir o cadastro',
                textAlign: TextAlign.center,
                style: context.text.bodyXL18Bold.copyWith(
                  color: context.colors.whiteColor,
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                'Verifique a sua conexão e tente novamente!',
                textAlign: TextAlign.center,
                style: context.text.bodyL16Bold.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              width: 250,
              margin: const EdgeInsets.only(top: Spaces.l),
              child: ButtonWidget.filledPrimary(
                onPressed: arguments.onRetry,
                text: 'Tentar novamente',
                padding: const EdgeInsets.symmetric(
                  vertical: Spaces.xl - Spaces.xs,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedbackErrorArgument {
  final VoidCallback onRetry;

  FeedbackErrorArgument({required this.onRetry});
}