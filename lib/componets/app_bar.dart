import 'package:flutter/material.dart';

import '../main.dart';
import '../screens/home.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon:
            Icon(MyApp.themeNotifier.value == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
        onPressed: () {
          // Toggle the theme mode between light and dark
          MyApp.themeNotifier.value =
              MyApp.themeNotifier.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
        },
      ),
      title: const Text(
        'Solax',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      backgroundColor: Colors.amber,
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0, bottom: 8.0),
          child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0, bottom: 8.0),
          child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notes,
                color: Colors.white,
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.contact_support,
                color: Colors.white,
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
                //
                /*
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const CalculatorScreen()));

                   */
              },
              child: const Text('New')),
        ),
        //
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

//
