import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikee/components/button.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {},
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        // whole
        child: Container(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
            // whole
            child: Column(
              children: [
                Expanded(
                    child: ListView(children: [
                  // title
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Community",
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "meet friends, make friends, explore...",
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),

                  // Cards
                  Card(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    shadowColor: Colors.black,
                    child: Column(
                      children: [
                        Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              'https://ychef.files.bbci.co.uk/live/624x351/p0973lkk.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: IntrinsicHeight(child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "XX Hiking Club",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris",
                                      style: TextStyle(color: Colors.grey))
                                ],
                              )),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("123 members"),
                                    Button(
                                      onPressed: () {},
                                      child: Text("JOIN"),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),),
                          
                        )
                      ],
                    ),
                  ),

                  Card(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    shadowColor: Colors.black,
                    child: Column(
                      children: [
                        Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              'https://ychef.files.bbci.co.uk/live/624x351/p0973lkk.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: IntrinsicHeight(child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "XX Hiking Club",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris",
                                      style: TextStyle(color: Colors.grey))
                                ],
                              )),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("123 members"),
                                    Button(
                                      onPressed: () {},
                                      child: Text("JOIN"),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),),
                          
                        )
                      ],
                    ),
                  ),

                  Card(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    shadowColor: Colors.black,
                    child: Column(
                      children: [
                        Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              'https://ychef.files.bbci.co.uk/live/624x351/p0973lkk.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: IntrinsicHeight(child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "XX Hiking Club",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris",
                                      style: TextStyle(color: Colors.grey))
                                ],
                              )),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("123 members"),
                                    Button(
                                      onPressed: () {},
                                      child: Text("JOIN"),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),),
                          
                        )
                      ],
                    ),
                  ),
                  
                ])),

                // Expanded(
                //     child: ListView.builder(
                //   //padding: const EdgeInsets.all(32),
                //   itemCount: 5,
                //   itemBuilder: (BuildContext context, int index) {
                //     return Card(
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(15)),
                //       shadowColor: Colors.black,
                //       child: Column(
                //         children: [
                //           Image.network(
                //             'https://ychef.files.bbci.co.uk/live/624x351/p0973lkk.jpg',
                //             fit: BoxFit.cover,
                //           ),
                //           Text("HI"),
                //         ],
                //       ),
                //     );
                //   },
                // ))
              ],
            )),
      ),
    );
  }
}
