import 'package:flutter/material.dart';
import 'package:hikees/models/faq_item.dart';

// stores ExpansionPanel state information

List<FaqItem> generateItems(int numberOfItems) {
  return List<FaqItem>.generate(numberOfItems, (int index) {
    return FaqItem(
      headerValue: 'Question $index',
      expandedValue: 'This is item number $index',
    );
  });
}

class FAQScreen extends StatefulWidget {
  FAQScreen({Key? key}) : super(key: key);

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final List<FaqItem> _data = [
    FaqItem(
      headerValue:
          'Does the vaccine change any rules about hiking during COVID?',
      expandedValue:
          'The COVID-19 vaccines are totally safe, and we recommend you get one as soon as you can unless it is medically or religiously contraindicated for you.\n\nThe CDC recommends that, when outside:Unvaccinated folks continue to practice social distancing, mask wearing, and preventative hygiene if they find themselves in a crowded area or are spending time with anyone outside of their household (see recommendations below).\n\nVaccinated folks do not need to social distance, nor wear masks.\n\nThat said, if regulations for the area you\'re going to still have those requirements, then obviously you\'ll need to abide by those.',
    ),
    FaqItem(
      headerValue: 'Best Clothes To Wear For Hiking',
      expandedValue:
          'In general, you want to wear non-cotton clothing, usually wool or polyester (see exceptions below under “Special Clothing for Hiking in the Desert.”) You also want to avoid thick articles like heavy coats. Instead, carry multiple, lighter layers that you can add or shed as the temperature changes. One exception to this rule is if you’re hiking in the winter when a down jacket may be a valuable layer. Finally, it’s important to have a rain jacket and pants if you’re hiking in the mountains or in an area with cooler temperatures and a chance of precipitation.',
    ),
    FaqItem(
      headerValue:
          'Should I tell family/friends/employer about my hiking trip?',
      expandedValue:
          'Someone should know your hiking itinerary (include name of the trip leader/ permit holder if not you), your rim destination after the hike, and the date of your return home.',
    ),
    FaqItem(
      headerValue: 'What should i look for in a backpack?',
      expandedValue:
          'The options for backpacks are abundant, to say the least: many companies create a wide range of types, sizes, and colors. Each pack model will have its own array of features.\n\nThe bottom line is we recommend getting a quality pack from major companies like Deuter, Osprey, Black Diamond, Patagonia, North Face, Gregory, Kelty, and Cotopaxi. You want it to have a firm support system, a waist belt, and a sternum strap.\n\nA very handy feature to look for is also a pouch for a hydration system so you can drink while hiking.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
                padding:
                    EdgeInsets.only(top: 32, bottom: 24, left: 24, right: 24),
                child: Row(
                  children: [
                    Text(
                      'FAQ Section',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ],
                )),
            _buildPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      elevation: 0,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((FaqItem item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 24),
              title: Text(
                item.headerValue,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          },
          body: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 24),
              title: Text(item.expandedValue),
              onTap: () {
                // setState(() {
                //   _data.removeWhere((Item currentItem) => item == currentItem);
                // });
              }),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
