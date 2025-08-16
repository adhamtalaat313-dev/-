import 'package:flutter/material.dart';
import '../api.dart';

class NewListingScreen extends StatefulWidget {
  const NewListingScreen({super.key});

  @override
  State<NewListingScreen> createState() => _NewListingScreenState();
}

class _NewListingScreenState extends State<NewListingScreen> {
  final title = TextEditingController();
  final desc = TextEditingController();
  final city = TextEditingController();
  final price = TextEditingController();
  String type = 'RENT';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Listing')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: title, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: desc, decoration: const InputDecoration(labelText: 'Description')),
            TextField(controller: city, decoration: const InputDecoration(labelText: 'City')),
            TextField(controller: price, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            DropdownButton<String>(
              value: type,
              items: const [
                DropdownMenuItem(value: 'RENT', child: Text('Rent')),
                DropdownMenuItem(value: 'SALE', child: Text('Sale')),
              ],
              onChanged: (v) => setState(() => type = v ?? 'RENT'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                final body = {
                  'title': title.text,
                  'description': desc.text,
                  'city': city.text,
                  'price': int.tryParse(price.text) ?? 0,
                  'type': type,
                  'mediaUrls': []
                };
                final res = await createListing(body);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res == null ? 'Failed' : 'Submitted for approval')));
                if (res != null) Navigator.pop(context);
              },
              child: const Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}
