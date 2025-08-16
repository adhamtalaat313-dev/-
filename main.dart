
import 'package:flutter/material.dart';

void main() {
  runApp(SouqAlAqaratApp());
}

class SouqAlAqaratApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سوق العقارات',
      theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Arial'),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('سوق العقارات')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ElevatedButton(
            child: Text("تسجيل الدخول / إنشاء حساب"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
            },
          ),
          SizedBox(height: 10),
          ElevatedButton(
            child: Text("إضافة إعلان"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AddAdPage()));
            },
          ),
          SizedBox(height: 10),
          ElevatedButton(
            child: Text("عرض المنازل"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AdsListPage()));
            },
          ),
        ],
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("تسجيل الدخول / إنشاء حساب")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: "البريد الإلكتروني")),
            TextField(decoration: InputDecoration(labelText: "كلمة المرور"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("تسجيل الدخول"),
              onPressed: () {},
            ),
            TextButton(
              child: Text("إنشاء حساب جديد"),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}

class AddAdPage extends StatelessWidget {
  final titleController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إضافة إعلان جديد")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: "عنوان الإعلان")),
            TextField(controller: priceController, decoration: InputDecoration(labelText: "السعر")),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("نشر الإعلان"),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم إضافة الإعلان (تجريبي)")));
              },
            )
          ],
        ),
      ),
    );
  }
}

class AdsListPage extends StatelessWidget {
  final List<Map<String, String>> ads = [
    {"title": "منزل للبيع في بغداد", "price": "120,000$"},
    {"title": "شقة للإيجار في أربيل", "price": "500$/شهر"},
    {"title": "أرض للبيع في البصرة", "price": "90,000$"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("قائمة المنازل")),
      body: ListView.builder(
        itemCount: ads.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(ads[index]["title"]!),
            subtitle: Text("السعر: ${ads[index]["price"]}"),
          );
        },
      ),
    );
  }
}
