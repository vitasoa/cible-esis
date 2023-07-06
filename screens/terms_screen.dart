import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List itemRead = [
      {
        "description":
            "Un Système Informatique Intégré de Suivi Evaluation (SIISE) est l’ensemble des composantes en interaction permettant d’orienter un projet, programme ou institution en fonction de sa finalité, en adéquation avec ses valeurs et incorporé à son mode de gouvernance. \n\nA travers cette définition, le SIISE n’est pas un simple processus d’aide à la décision à destination des décideurs. Il agit comme un dispositif d’accompagnement, intégré à l’objet même de l’institution, dans une double responsabilité de transparence et d’apprentissage.",
        "title": "Système Informatique Intégré de Suivi Evaluation",
      },
      {
        "description":
            "Mionjo, soutien aux moyens de subsistance résilients dans le Sud de Madagascar est un projet du Gouvernement malagasy, piloté par le Ministère de l’Intérieur et de la Décentralisation. Il vise à asseoir la résilience des populations du Sud, périodiquement impactées par des situations de catastrophes naturelles et un isolement faute d’infrastructures.",
        "title": "Mionjo",
      },
      {
        "description": """
ARTICLE 1 – OBJET DES CONDITIONS GENERALES D’UTILISATION\n
Les présentes conditions générales d’utilisation (ci-après « CGU ») ont pour objet de définir les règles d’utilisation de l’application mobile « SIISE MIONJO ».\n
En installant l’Application sur votre terminal et/ou en accédant à l’Application, vous acceptez sans réserve l’intégralité des présentes CGU et vous engagez à respecter les obligations à votre charge. 
Dans le cas où vous n’accepteriez pas les CGU ou auriez des réserves, merci de ne pas utiliser l’Application.\n\nNous vous conseillons donc de consulter cette page régulièrement afin de prendre connaissance des CGU en vigueur lorsque vous utilisez l’Application.\n\n
ARTICLE 2 – OBJET ET FONCTIONNALITES DE L’APPLICATION\n
L’Application permet de suivre les évolutions sous l’ensemble des composantes en interaction permettant d’orienter un projet, programme ou institution en fonction de sa finalité.\n\n
ARTICLE 3 - ACCES A L’APPLICATION\n
L’Application n’est pas téléchargeable depuis les plateformes « Apple Store » mais déjà installé dans les tablettes mises à disposition à des agents de chaque localité.\n
La version du logiciel de l’Application peut être mise à jour de temps à autre pour ajouter de nouvelles fonctions et de nouveaux services.\n
Une fois l’Application installée sur votre tablette, il vous suffit de vous connecter en utilisant le « code de votre commune ».\n\n
ARTICLE 4 – LICENCE D’UTILISATION\n
L’application et la tablette sont uniquement utilisables pour les suivis des projets et non à des fins personnelles.
            """,
        "title": "CGU - Application mobile sous Android",
      },
      {
        "description": """
ARTICLE 5 - DONNÉES PERSONNELLES\n
Les données utilisées sont principalement des données de MIONJO et strictement interdites de partager ou de divulguer à des fins personnelles.\n\n
ARTICLE 6 - DROIT APPLICABLE -LITIGES\n
Les présentes CGU sont soumises au droit Malagasy.\n
Tout litige concernant l'Application ou l’interprétation des présentes CGU sera soumis au tribunal compétent d’Antananarivo.\n\n
ARTICLE 7 - CONTACT\n
Vous pouvez adresser vos questions ou remarques relatives aux présentes CGU en écrivant à MIONJO https://www.mionjo.mg/
            """,
        "title": "CGU - Données et Confidentialités",
      },
    ];
    return Align(
      alignment: Alignment.topLeft,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              "CONDITIONS GENERALES D’UTILISATION",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            elevation: 1,
          ),
          body: Scrollbar(
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(1),
              itemBuilder: (BuildContext context, int index) {
                return _buildExpandableTile(itemRead[index]);
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  thickness: 0.9,
                  indent: 20,
                  endIndent: 20,
                );
              },
              itemCount: itemRead.length,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableTile(item) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ExpansionTile(
        title: Text(
          item['title'].toString().toUpperCase(),
          style: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: <Widget>[
          // SizedBox(
          //   height: 1,
          // ),
          ListTile(
            title: Text(
              item['description'],
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
              ),
            ),
          ),
          // SizedBox(
          //   height: 1,
          // ),
        ],
      ),
    );
  }
}
