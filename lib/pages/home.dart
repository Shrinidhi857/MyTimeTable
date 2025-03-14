import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:mytimetable/components/heatmap.dart';
import 'package:mytimetable/data/dataset.dart';
import 'package:mytimetable/helper/adHelper.dart';
import 'package:mytimetable/pages/timetable.dart';
import 'package:mytimetable/auth/google_auth.dart';
import 'package:tuple/tuple.dart';
import '../components/todo_tile.dart';
import '../data/database.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box("mybox");
  TimeTableDatabase db = TimeTableDatabase();
  String day = DateFormat('EEEE').format(DateTime.now());
  List<Tuple3<String, bool, bool>> TodayClasses = [];
  BannerAd? _bannerAd;
  bool isAdLoaded = false;
  bool isLoading = true;
  User? user = FirebaseAuth.instance.currentUser;
  DatasetDatabase heatmapdata = DatasetDatabase();
  String? get userId => FirebaseAuth.instance.currentUser?.uid;
  late Map<DateTime, int> dataset = {};



  @override
  void initState() {
    super.initState();
    fetchData();
    loadBannerAd();
    loadHeatMapData();

  }

  Future<void> loadHeatMapData() async {
    await heatmapdata.loadData();
    setState(() {
      dataset = heatmapdata.dataset;
    });
  }


  Future<void> fetchData() async {
    db.loadData();
    List<Tuple3<String, bool, bool>> localData = (db.timeTable[day] as List<dynamic>?)
        ?.map((classDetail) => Tuple3(classDetail.toString(), false, false))
        .toList() ??
        [];

    if (userId != null) {
      await getUserData(userId!, day);
    }

    setState(() {
      isLoading = false;
      TodayClasses = localData;
    });
  }

  Future<void> getUserData(String userId, String day) async {
    try {
      QuerySnapshot scheduleSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('timetable')
          .doc(day)
          .collection('schedule')
          .get();

      if (scheduleSnapshot.docs.isNotEmpty) {
        setState(() {
          TodayClasses = scheduleSnapshot.docs.map((doc) {
            String subjectName = doc['subject'] ?? 'Unknown';
            return Tuple3(subjectName, false, false);
          }).toList();
        });
      }
    } catch (e) {
      print("\n❌Error fetching schedule: $e \n");
    }
  }

  Future<void> updateAttendance(String subjectName, String field, int change) async {
    try {
      if (userId == null) return;

      String sanitizedSubjectName = subjectName.replaceAll(RegExp(r'[^\w\s]'), '').replaceAll(' ', '_');
      DocumentReference docRef = FirebaseFirestore.instance
          .collection("Users")
          .doc(userId)
          .collection("week")
          .doc(sanitizedSubjectName);

      await docRef.set({field: FieldValue.increment(change)}, SetOptions(merge: true));
      print("\n✅$field updated for $sanitizedSubjectName with change: $change \n");
    } catch (e) {
      print("\n❌Error updating $field count: $e \n");
    }
  }

  Future<void> checkBoxChanged(bool? value, int index) async {
    if (value == null) return;
    var current = TodayClasses[index];
    heatmapdata.loadData();
    if (current.item2 != value) {
      int change = value ? 1 : -1;
      await updateAttendance(current.item1, "attended", change);
      if(current.item2!=true){
        DateTime currentDate = DateTime.now();
        DateTime newDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
        heatmapdata.addData(newDate,change);
      }
    }

    setState(() {
      TodayClasses[index] = Tuple3(current.item1, value, current.item3);
    });
  }

  Future<void> markAsSkipped(int index) async {
    setState(() {
      var current = TodayClasses[index];
      TodayClasses[index] = Tuple3(current.item1, current.item2, !current.item3);
    });
    await updateAttendance(TodayClasses[index].item1, "skipped", TodayClasses[index].item3 ? 1 : -1);
    heatmapdata.loadData();
  }

  void openTimeTablePage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TimeTablePage(refresh: fetchData)),
    );
    fetchData();
  }

  void logout() async {
    FirebaseAuth.instance.signOut();
    await _myBox.clear();
    GoogleSignIn().signOut();
  }
  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
            isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print("\n❌Failed to load the banner ad: ${err.message}");
          ad.dispose();
          setState(() {
            isAdLoaded = false;
          });
        },
      ),
    );

    _bannerAd?.load(); // Load the ad
  }

  String StringEditor(String input) {
    RegExp regex = RegExp(r':(.*?),');
    Match? match = regex.firstMatch(input);
    return match != null ? match.group(1)!.trim() : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("MyTimeTable", style: GoogleFonts.roboto(
          color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.w900,
            fontSize: 25,
        )),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fixed HeatMap at the top
          SizedBox(
            height: 250,// Adjust height as needed
            child: Container(
              margin: const EdgeInsets.only(top: 12.0,bottom: 12,left: 12,right: 12),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary, // Background color
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              child: MyHeatMap(),
            ),
          ),

          if (isAdLoaded && _bannerAd != null)
            Container(
              margin: EdgeInsets.only(top: 20,bottom: 20),
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),

          // Loading Indicator or No Classes Message
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (TodayClasses.isEmpty)
            const Center(child: Text("No classes today!"))
          else
          // Scrollable ListView
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: _bannerAd != null ? _bannerAd!.size.height.toDouble() : 0,
                ),
                child: ListView.builder(
                  itemCount: TodayClasses.length,
                  itemBuilder: (context, index) {
                    final classInfo = TodayClasses[index];
                    return ToDoTile(
                      taskName: StringEditor(classInfo.item1),
                      subjectAttended: classInfo.item2,
                      subjectBunked: classInfo.item3,
                      onChangedg: (value) => checkBoxChanged(value, index),
                      onChangedr: (value) => markAsSkipped(index),
                    );
                  },
                ),
              ),
            ),
        ],
      ),


      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                backgroundColor: Colors.grey,
                child: user?.photoURL == null ? Icon(Icons.person, size: 50, color: Colors.white) : null,
              ),
            ),

            Text(user?.displayName ?? "User",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

            SizedBox(height: 30,),

            GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.settings, size: 20,color: Theme.of(context).colorScheme.secondary,),
                  Text("Settings", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Theme.of(context).colorScheme.secondary),),
                ],
              ),
              onTap: ()=> Navigator.pushNamed(context, '/settingspage'),
            ),

            SizedBox(height: 30,),

            GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, size: 20,color:Theme.of(context).colorScheme.secondary,),
                  Text("Logout", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Theme.of(context).colorScheme.secondary)),
                ],
              ),
              onTap: logout,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openTimeTablePage,
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}