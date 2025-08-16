import 'package:flutter/material.dart';
import '../api.dart';
import 'new_listing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final q = TextEditingController();
  List items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { loading = true; });
    items = await searchListings(q: q.text);
    setState(() { loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listings'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewListingScreen())),
            icon: const Icon(Icons.add)
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: q,
              decoration: InputDecoration(
                hintText: 'Search city or title',
                suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: _load),
              ),
            ),
          ),
          Expanded(
            child: loading ? const Center(child: CircularProgressIndicator()) :
            ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) {
                final it = items[i];
                return ListTile(
                  title: Text(it['title'] ?? ''),
                  subtitle: Text('${it['city'] ?? ''} • ${it['price'] ?? ''} ${it['currency'] ?? ''}'),
                );
              }
            ),
          )
        ],
      ),
    );
  }
}
