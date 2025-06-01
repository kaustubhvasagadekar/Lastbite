import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:last_bite/screens/create_order_screen.dart';
import 'screens/home_screen.dart';
import 'screens/order_list_screen.dart';
import 'screens/income_report_screen.dart';
import 'screens/item_management_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const LastBiteApp());
}

class LastBiteApp extends StatelessWidget {
  const LastBiteApp({super.key});

@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Last Bite',
      theme: ThemeData(
        // Primary color: soft sage green
        primaryColor: const Color(0xFFA8B5A2),
        // Color scheme with soft colors
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: createMaterialColor(const Color(0xFFA8B5A2)), // Sage green swatch
          accentColor: const Color(0xFFF4C7AB), // Muted peach accent
          backgroundColor: const Color(0xFFFDF7E8), // Light cream background
        ).copyWith(
          secondary: const Color(0xFFF4C7AB), // Muted peach as secondary
          surface: const Color(0xFFFDF7E8), // Light cream for surfaces
        ),
        // Scaffold background color
        scaffoldBackgroundColor: const Color(0xFFFDF7E8), // Light cream
        // Text theme with soft tones
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFA8B5A2)), // Sage green for body text
          bodyMedium: TextStyle(color: Color(0xFFA8B5A2)),
          titleLarge: TextStyle(
              color: Color(0xFFA8B5A2), fontWeight: FontWeight.bold), // For headings
        ),
        // AppBar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFA8B5A2), // Sage green AppBar
          foregroundColor: Color(0xFFFDF7E8), // Light cream text/icons on AppBar
        ),
        // Button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF4C7AB), // Muted peach for buttons
            foregroundColor: const Color(0xFFFDF7E8), // Light cream text on buttons
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainScreen(),
    );
  }
}

// Helper function to create a MaterialColor swatch from a single color
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const OrderListScreen(),
    const CreateOrderScreen(),
    const IncomeReportScreen(),
    const ItemManagementScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      floatingActionButton: FloatingActionButton(
        splashColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateOrderScreen(),
            ),
          );
        },
        // tooltip: 'Add Item',
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Income',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Items',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
