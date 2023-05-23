import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(RecipeApp());
}

class RecipeApp extends StatelessWidget {
  Future<List<dynamic>> fetchRecipes() async {
    final url = Uri.parse(
        'https://api.spoonacular.com/recipes/random?apiKey=afe47d6e48ad4b139a32cada1a1d3717&number=5');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['recipes'];
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.deepOrangeAccent, // Ubah warna AppBar menjadi oranye
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Recipe App',
            textAlign: TextAlign.center, // Teks "Recipe App" ditengahkan
            style: TextStyle(
              fontSize: 30, // Ubah ukuran teks menjadi 24
              fontWeight: FontWeight.bold, // Tambahkan fontWeight bold
            ),
          ),
          centerTitle: true, // Teks "Recipe App" ditengahkan
        ),
        body: Container(
          color: Colors.white,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 32,
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 22),
                  FutureBuilder<List<dynamic>>(
                    future: fetchRecipes(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Failed to load recipes'),
                        );
                      } else {
                        final recipes = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: recipes.length,
                          itemBuilder: (BuildContext context, int index) {
                            final recipe = recipes[index];
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrangeAccent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    leading: Image.network(
                                      recipe['image'],
                                      width: 150,
                                    ),
                                    title: Text(recipe['title']),
                                    subtitle: Row(
                                      children: [
                                        Text(
                                          'Ready in ${recipe['readyInMinutes']} minutes',
                                        ),
                                        SizedBox(width: 5),
                                        Row(
                                          children: List.generate(
                                            5,
                                            (index) => Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
