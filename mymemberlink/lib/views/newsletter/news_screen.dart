import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mymemberlink/models/news.dart';
import 'package:mymemberlink/myconfig.dart';
import 'package:mymemberlink/views/newsletter/edit_news.dart';
import 'package:mymemberlink/views/shared/mydrawer.dart';
import 'package:mymemberlink/views/newsletter/new_news.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<News> newsList = [];
  List<News> filteredNewsList = []; // Filtered list for search functionality
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  String searchQuery = ""; // Store search input
  late double screenWidth, screenHeight;

  @override
  void initState() {
    super.initState();
    loadNewsData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Newsletter"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {
              loadNewsData(); // Reload news
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.lightGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                    filterNews(); // Filter news dynamically
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search News...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            newsList.isEmpty
                ? const Center(
                    child: Text("Loading..."),
                  )
                : Expanded(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text("Page: $curpage | Results: $numofresult"),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredNewsList.length, // Filtered news
                            itemBuilder: (context, index) {
                              News news = filteredNewsList[index];

                              return Card(
                                child: ListTile(
                                  leading: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.article, color: Colors.green),
                                      Text(
                                        "#${index + 1}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        truncateString(
                                            news.newsTitle.toString(), 30),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        df.format(DateTime.parse(
                                            news.newsDate.toString())),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    truncateString(
                                        news.newsDetails.toString(), 100),
                                    textAlign: TextAlign.justify,
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.arrow_forward,
                                        color: Colors.green),
                                    onPressed: () {
                                      showNewsDetailDialog(news); // Open details on arrow click
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        buildPagination(),
                      ],
                    ),
                  ),
          ],
        ),
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (content) => const NewNewsScreen()),
          );
          loadNewsData();
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  String truncateString(String str, int length) {
    if (str.length > length) {
      str = str.substring(0, length);
      return "$str...";
    } else {
      return str;
    }
  }

  void loadNewsData() {
    http
        .get(Uri.parse(
            "${MyConfig.servername}/memberlink/api/load_news.php?pageno=$curpage"))
        .then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['news'];
          newsList.clear();
          for (var item in result) {
            News news = News.fromJson(item);
            newsList.add(news);
          }
          numofpage = int.parse(data['numofpage'].toString());
          numofresult = int.parse(data['numberofresult'].toString());
          filterNews(); // Filter results after loading
        }
      }
    });
  }

  void filterNews() {
    if (searchQuery.isEmpty) {
      filteredNewsList = List.from(newsList);
    } else {
      filteredNewsList = newsList
          .where((news) => news.newsTitle!
              .toLowerCase()
              .contains(searchQuery.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  Widget buildPagination() {
    return SizedBox(
      height: screenHeight * 0.05,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: numofpage,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var color = (curpage - 1 == index) ? Colors.white : Colors.black;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: (curpage - 1 == index) ? Colors.green : Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextButton(
              onPressed: () {
                curpage = index + 1;
                loadNewsData();
              },
              child: Text(
                (index + 1).toString(),
                style: TextStyle(color: color, fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }

  // Function to show the details dialog
  void showNewsDetailDialog(News news) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(news.newsTitle!),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Date: ${df.format(DateTime.parse(news.newsDate!))}"),
              const SizedBox(height: 10),
              Text(news.newsDetails!),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Close"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                deleteNews(news); // Call delete
              },
              child: const Text("Delete"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                navigateToEditNews(news); // Navigate to edit page
              },
              child: const Text("Edit"),
            ),
          ],
        );
      },
    );
  }

  void deleteNews(News news) {
    http
        .post(
            Uri.parse("${MyConfig.servername}/memberlink/api/delete_news.php"),
            body: {"newsid": news.newsId.toString()})
        .then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          loadNewsData(); // Refresh after delete
        }
      }
    });
  }

  // Navigate to the edit news screen
  void navigateToEditNews(News news) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (content) => EditNewsScreen(news: news),
      ),
    );
    loadNewsData(); // Refresh after editing
  }
}
