import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste_target/components/app_text_item.dart';
import 'package:teste_target/components/custom_text_form_field.dart';
import 'package:teste_target/components/new_text.dart';
import 'package:teste_target/models/app_text.dart';
import 'package:teste_target/models/app_text_list.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<AppText> appTextList = [];
  TextEditingController appTextController = TextEditingController();

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    final provider = Provider.of<AppTextList>(context, listen: false);
    await provider.loadAppTexts();
    setState(() {
      appTextList = provider.items;
    });
  }

  @override
  Widget build(BuildContext context) {
    appTextList = Provider.of<AppTextList>(context).items;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(2, 77, 80, 0.878),
                  Color.fromRGBO(10, 131, 113, 0.886),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.4, 0.8],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 40, 30, 10),
            child: SizedBox(
              height: 400,
              child: Card(
                child: ListView.builder(
                  itemCount: appTextList.length,
                  itemBuilder: (context, index) => AppTextItem(
                    appText: appTextList[index],
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              NewAppText(),
              Center(
                child: TextButton(
                  onPressed: () async {
                    const url = 'https://www.google.com';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      throw 'Não foi possível abrir o link $url';
                    }
                  },
                  child: const Text(
                    'Política de Privacidade',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
