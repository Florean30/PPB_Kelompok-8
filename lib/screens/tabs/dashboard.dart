import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lun/components/button.dart';
import 'package:lun/screens/tabs/calendar.dart';
import 'package:lun/services/auth_service.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: Dashboard(),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map<String, dynamic>? userData;
  int totalPeriodNow = 0;
  List<Map<String, String>> oneMonthBeforeEvent = [];
  List<Map<String, dynamic>> recordData = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _initEvents();
  }

  Future<void> _loadUserData() async {
    Map<String, dynamic>? data = await AuthService().getUserData();
    setState(() {
      userData = data;
    });
  }

  Future<QuerySnapshot<Object?>> _loadEvent({int deduction = 0}) async {
    DateTime currentDate = DateTime.now();

    int selectedMonth = currentDate.month - deduction;
    int selectedYear = currentDate.year;

    DateTime startDate = DateTime(selectedYear, selectedMonth, 1);
    DateTime endDate = DateTime(selectedYear, selectedMonth + 1, 0, 23, 59, 59);

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('date', isGreaterThanOrEqualTo: startDate.toIso8601String())
        .where('date', isLessThanOrEqualTo: endDate.toIso8601String())
        .get();

    return snapshot;
  }

  Future<void> _initEvents() async {
    QuerySnapshot snapshotNow = await _loadEvent();
    QuerySnapshot snapshotOneMonthBefore = await _loadEvent(deduction: 1);
    QuerySnapshot snapshotTwoMonthBefore = await _loadEvent(deduction: 2);

    List<Map<String, String>> tempOneMonthBeforeEvent = [];
    List<Map<String, dynamic>> tempRecordData = [];

    // Example of how you might categorize the data
    tempOneMonthBeforeEvent.add({
      "label": "Length of previous menstrual cycle",
      "total": snapshotOneMonthBefore.docs.length.toString(),
      "status":
          snapshotOneMonthBefore.docs.length <= 7 ? "Normal" : "Tidak Normal"
    });

    String textDateNow = "";
    String textLastDateNow = "";

    if (snapshotNow.docs.isNotEmpty) {
      DateTime dateNow = DateTime.parse(snapshotNow.docs[0]['date']);
      DateTime lastDateNow =
          DateTime.parse(snapshotNow.docs[snapshotNow.docs.length - 1]['date']);
      textDateNow = DateFormat('dd MMM').format(dateNow);
      textLastDateNow = DateFormat('dd MMM').format(lastDateNow);
    }

    tempRecordData.add({
      "day": snapshotNow.docs.length.toString(),
      "start_date": textDateNow,
      "end_date": textLastDateNow,
      "period": snapshotNow.docs.isNotEmpty ? snapshotNow.docs : []
    });

    String textOneMonthBefore = "";
    String textLastOneMonthBefore = "";

    if (snapshotOneMonthBefore.docs.isNotEmpty) {
      DateTime dateOneMonthBefore =
          DateTime.parse(snapshotOneMonthBefore.docs[0]['date']);
      DateTime lastDateOneMonthBefore = DateTime.parse(snapshotOneMonthBefore
          .docs[snapshotOneMonthBefore.docs.length - 1]['date']);

      textOneMonthBefore = DateFormat('yyyy-MM-dd').format(dateOneMonthBefore);
      textLastOneMonthBefore =
          DateFormat('yyyy-MM-dd').format(lastDateOneMonthBefore);

      tempRecordData.add({
        "day": snapshotOneMonthBefore.docs.length.toString(),
        "start_date": textOneMonthBefore,
        "end_date": textLastOneMonthBefore,
        "period": snapshotOneMonthBefore.docs.isNotEmpty
            ? snapshotOneMonthBefore.docs
            : []
      });
    }

    String textTwoMonthBefore = "";
    String textLastTwoMonthBefore = "";
    if (snapshotTwoMonthBefore.docs.isNotEmpty) {
      DateTime dateTwoMonthBefore =
          DateTime.parse(snapshotTwoMonthBefore.docs[0]['date']);
      DateTime lastDateTwoMonthBefore = DateTime.parse(snapshotTwoMonthBefore
          .docs[snapshotTwoMonthBefore.docs.length - 1]['date']);

      textTwoMonthBefore = DateFormat('yyyy-MM-dd').format(dateTwoMonthBefore);
      textLastTwoMonthBefore =
          DateFormat('yyyy-MM-dd').format(lastDateTwoMonthBefore);
      tempRecordData.add({
        "day": snapshotTwoMonthBefore.docs.length.toString(),
        "start_date": textTwoMonthBefore,
        "end_date": textLastTwoMonthBefore,
        "period": snapshotTwoMonthBefore.docs.isNotEmpty
            ? snapshotTwoMonthBefore.docs
            : []
      });
    }

    setState(() {
      oneMonthBeforeEvent = tempOneMonthBeforeEvent;
      recordData = tempRecordData;
      totalPeriodNow = snapshotNow.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 120,
              margin: const EdgeInsets.only(right: 150),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(238, 136, 185, 0.5),
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(72)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello ${userData != null ? userData!['name']! : ""}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Color.fromRGBO(247, 65, 143, 1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 160,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Transform.scale(
                  scale: 6,
                  child: CircularProgressIndicator(
                    value: totalPeriodNow > 0 ? (totalPeriodNow / 7) : 1,
                    valueColor: AlwaysStoppedAnimation<Color>(totalPeriodNow > 0
                        ? const Color.fromRGBO(238, 136, 185, 1)
                        : Colors.black12),
                    strokeWidth: 1,
                    strokeCap: StrokeCap.round,
                    semanticsLabel: 'Circular progress indicator',
                    semanticsValue: "$totalPeriodNow%",
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Menstrual period\nhas been',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "$totalPeriodNow  Days",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Color.fromRGBO(247, 65, 143, 1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 160,
            ),
            Button(
              text: '  Any period issues ? ',
              icon: Icons.add,
              withIcon: true,
              textColor: Colors.white,
              onPressed: () {
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const CalendarPage()));
              },
            ),
            const SizedBox(
              height: 32,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(238, 136, 185, 0.5),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My period cycle',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color.fromRGBO(247, 65, 143, 1),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 0),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: oneMonthBeforeEvent.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                oneMonthBeforeEvent[index]['label']!,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                              ),
                              subtitle: Text(
                                "${oneMonthBeforeEvent[index]['total']!} day",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(247, 65, 143, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.pink,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    oneMonthBeforeEvent[index]['status']!,
                                    style: const TextStyle(
                                        color: Colors.pink, fontSize: 14),
                                  ),
                                ],
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                            ),
                            if (index < (oneMonthBeforeEvent.length - 1))
                              Divider(
                                height: 1,
                                color: Colors.grey[200],
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              margin: const EdgeInsets.only(left: 32, right: 32, bottom: 32),
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(238, 136, 185, 0.5),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Menstruation cycle records',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color.fromRGBO(247, 65, 143, 1),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recordData.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                "${index == 0 ? "Siklus haid saat ini: " : ""}${recordData[index]['day']!} hari",
                                style: const TextStyle(
                                  color: Color.fromRGBO(247, 65, 143, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${(index == 0 ? "Dimulai : " : "")}${recordData[index]['start_date']!}${index > 0 ? " - " : ""}${index > 0 ? recordData[index]['end_date']! : ""}",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 8),
                                  if (recordData[index]['period'] != null &&
                                      recordData[index]['period'] is List)
                                    Row(
                                      children: [
                                        ...recordData[index]['period']
                                            .map((e) => Container(
                                                  height: 8,
                                                  width: 8,
                                                  margin: const EdgeInsets.only(
                                                      right: 2),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: recordData[index]
                                                                  ['period']
                                                              .isNotEmpty
                                                          ? Colors.red
                                                          : Colors.black12),
                                                )),
                                      ],
                                    ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                            ),
                            if (index < (recordData.length - 1))
                              Divider(
                                height: 1,
                                color: Colors.grey[200],
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
