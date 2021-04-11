import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plastiex/ui/colors.dart';

class HomeWidget extends StatelessWidget {
  final TextStyle _headingStyle = TextStyle().copyWith(
      fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.white);

  Widget _buildSection(
      {String heading, String textContent, Color color = Colors.white}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 9.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.grey[200], blurRadius: 1.0),
        ],
        borderRadius: BorderRadius.circular(15.0),
        color: color,
      ),
      child: Column(
        children: [
          Text(
            heading,
            style: _headingStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.0),
          Text(
            textContent,
            style: TextStyle().copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: white,
        systemNavigationBarColor: white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Plastiex",
                    style: TextStyle().copyWith(
                      color: Colors.grey[800],
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              _buildSection(
                heading: "What is a plastic?",
                textContent:
                    "Plastics are (mostly) synthetic (human-made) materials, made from polymers, which are long molecules built around chains of carbon atoms, typically with hydrogen, oxygen, sulfur, and nitrogen filling in the spaces.",
                color: green,
              ),
              _buildSection(
                heading: "How does it hurt our enviroment?",
                textContent:
                    "Plastic sticks around in the environment for ages, threatening wildlife and spreading toxins. Plastic also contributes to global warming.Almost all plastics are made from chemicals that come from the production of planet-warming fuels (gas, oil and even coal).Our reliance on plastic therefore prolongs our demand for these dirty fuels. Burning plastics in incinerators also releases climate-wrecking gases and toxic air pollution.",
                color: Colors.indigo[600],
              ),
              _buildSection(
                heading: "What can we do about it?",
                textContent:
                    "In order to attain a plastic free planet and save our environment, we are collecting all used plastic bottles to we can send them to recycling plants where they are properly processed",
                color: Colors.amber,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
