import 'package:api_cuaca/cuaca.dart';
import 'package:api_cuaca/data_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MainPage());
  }
}

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController controller = TextEditingController();
  DataService dataServices = DataService();
  cuaca weather = cuaca();
  bool isFetch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff060720),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder(
              duration: Duration(seconds: 3),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (BuildContext context, double value, Widget? child) {
                return Opacity(
                  opacity: value,
                  child: child,
                );
              },
              child: Text(
                "Weather API", // Ganti dengan judul bebas yang Anda inginkan
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            isFetch
                ? Column(
                    children: [
                      Image.network(
                        "https://openweathermap.org/img/wn/${weather.icon}@2x.png",
                      ),
                      Text(
                        "${weather.temp}°C",
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.white),
                      ),
                      Text(
                        weather.description,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  )
                : SizedBox(),
            Container(
              width: 150,
              padding: EdgeInsets.symmetric(vertical: 50),
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'City',
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                isFetch = true;
                weather = await dataServices.fetchData(controller.text);
                setState(() {});
              },
              child: Text('Search'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(
                    255, 63, 63, 63), // Ubah warna latar belakang tombol
              ),
            ),
          ],
        ),
      ),
    );
  }
}
