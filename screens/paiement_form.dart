// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:ciblesmionjo/models/subvention_model.dart';
import 'package:ciblesmionjo/services/db_handler.dart';
import 'package:ciblesmionjo/utils/utils.dart';
import 'package:flutter/material.dart';

class PaiementManuelForm extends StatefulWidget {
  int? cibleId;
  String? cibleCommuneId;
  String? cibleNom;
  String? ciblePrenoms;
  String? cibleCin;
  String? cibleDateCin;
  String? cibleCommune;
  String? cibleDistrict;
  Subvention? subv;

  PaiementManuelForm(
      {this.cibleId,
      this.cibleCommuneId,
      this.cibleNom,
      this.ciblePrenoms,
      this.cibleCin,
      this.cibleDateCin,
      this.cibleCommune,
      this.cibleDistrict,
      this.subv});

  @override
  State<PaiementManuelForm> createState() => _PaiementManuelFormState();
}

class _PaiementManuelFormState extends State<PaiementManuelForm> {
  DBHelper? dbHelper;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(20),
      contentPadding: const EdgeInsets.all(20),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      actionsAlignment: MainAxisAlignment.center,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      title: Text(
        'Payer le cible || ${widget.subv!.nom_responsable}'.toUpperCase(),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      content: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scrollbar(
          thumbVisibility: true,
          thickness: 3,
          radius: const Radius.circular(3),
          scrollbarOrientation: ScrollbarOrientation.right,
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Text(
                        '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 5,
                      ),
                      child: Text(
                        "${widget.cibleNom} ${widget.ciblePrenoms}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      "CIN Numéro : ${widget.cibleCin} délivré le : ${widget.cibleDateCin}",
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.brown,
                    thickness: 0.8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "District : ${widget.cibleDistrict} - Commune : ${widget.cibleCommune}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.brown,
                    thickness: 0.8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "PAIEMENT LE : ${widget.subv!.date_sub} - LIEU : ${widget.subv!.lieu}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.brown,
                    thickness: 0.8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "MONTANT : ${UtilsBehavior.formatCurrency(widget.subv!.montant_beneficiaire)} Ariary",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async => {
                        UtilsBehavior.showCircularIndicator(context),
                        await DBHelper().updateCiblePaiementData(
                          widget.cibleCin.toString(),
                          widget.cibleCommuneId.toString(),
                          widget.cibleId.toString(),
                          widget.subv!.date_sub.toString(),
                          widget.subv!.id.toString(),
                          widget.subv!.montant_beneficiaire.toString(),
                        ),
                        UtilsBehavior.hideCircularIndocator(context),
                        Navigator.of(context).pop(true),
                        setState(() {}),
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Paiement cible effectué : ${UtilsBehavior.formatCurrency(widget.subv!.montant_beneficiaire)} Ariary"
                                  .toUpperCase(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 10,
                        ),
                        minimumSize: const Size(
                          150,
                          30,
                        ),
                        alignment: Alignment.center,
                        elevation: 0,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        'PAYER'.toUpperCase(),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
