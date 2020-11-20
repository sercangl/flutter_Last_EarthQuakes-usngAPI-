import 'package:deprem_son/EarthQuakeResponse.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int earthQuakeCount = 10;
  String apiUrl = "https://api.orhanaydogdu.com.tr/deprem/live.php?limit=100";

  Future<EarthQuakeResponse> getData() async {
    final response = await http.get(apiUrl);
    return earthQuakeResponseFromJson(response.body);
  }

  @override
  void initState() {
    super.initState();
    //getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Deprem Uygulaması'),
      ),
      body: Center(
          child: FutureBuilder<EarthQuakeResponse>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Veriler yükleniyor...'),
                    SizedBox(
                      height: 50,
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              );
              break;
            default:
              if (snapshot.hasError)
                return Center(
                  child: Text('Hata: ${snapshot.error}'),
                );
              else
                return ListView.builder(
                  itemCount: snapshot.data.result.length,
                  itemBuilder: (context, index) {
                    List<EarthQuake> response = snapshot.data.result;
                    EarthQuake item = response[index];
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: InkWell(
                        onTap: () => null,
                        child: ListTile(
                          leading: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                item.date,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                          trailing: Text(
                            '${item.mag}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                    );
                  },
                );
          }
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            earthQuakeCount += 5;
          });
        },
        tooltip: 'Yenile',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
