import 'package:carcareservice/app/model/service_model.dart';
import 'package:carcareservice/app/view_model/services_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../user_registration/components/login_button_widget.dart';
import '../../../user_registration/components/text_form_field.dart';
import '../../../utils/global_values.dart';
import '../view_model/auth_service.dart';


class ServiceInput extends StatelessWidget {
  final Services? service;
  final UserProvider? provider;
  const ServiceInput({
    super.key,
    this.service, this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final serviceScreenModel = context.read<ServicesProvider>();
    serviceScreenModel.nameCtrl.text = service?.name?? '';
    //serviceScreenModel.rateCtrl.text = service?.rate ?? '';
    return SimpleDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      title: Text(
        service == null ? 'ADD DETAILS' : 'EDIT DETAILS',
        style: const TextStyle(color: Colors.black),
        textAlign: TextAlign.center,
      ),
      children: [
        Form(
          child: Column(
            children: [
              TextFormWidget(
                labelText: 'Name',
                controller: serviceScreenModel.nameCtrl,
                keyType: TextInputType.name,
                textFieldIcon: Icons.car_repair_outlined,
              ),
              AppSizes.kHeight10,
             TextFormWidget(
                controller: serviceScreenModel.rateCtrl,
                labelText: 'Rate',
                keyType: TextInputType.number,
                textFieldIcon: Icons.currency_rupee_outlined,
              ),
              AppSizes.kHeight10,
              Padding(
                padding: const EdgeInsets.only(left:40,right: 40),
                child: LoginButtonWidget(
                  isDialog: true,
                  onPressed:  service == null
                          ? () {
                              serviceScreenModel.addService(userProvider,context);

                            }
                          : () {
                              //serviceScreenModel.update(context, service!.id!);
                            },
                  title: service == null ? 'SAVE service' : 'UPDATE',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
