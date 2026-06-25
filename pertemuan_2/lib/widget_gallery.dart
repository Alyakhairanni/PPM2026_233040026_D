import 'package:flutter/material.dart';

class WidgetGallery extends StatelessWidget {
  const WidgetGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      ('Display', Icons.image, const Color(0xFF6366F1)), // Indigo
      ('Input', Icons.edit, const Color(0xFF10B981)), // Emerald
      ('Button', Icons.smart_button, const Color(0xFFF59E0B)), // Amber
      ('Feedback', Icons.notifications, const Color(0xFFEC4899)), // Pink
      ('Layout', Icons.dashboard, const Color(0xFF3B82F6)), // Blue
      ('Animation', Icons.animation, const Color(0xFF8B5CF6)), // Violet
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Widget Gallery')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final (name, icon, color) = categories[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color,
                child: Icon(icon, color: Colors.white),
              ),
              title: Text(name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryPage(name: name),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String name;
  const CategoryPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final body = switch (name) {
      'Display' => const _DisplayDemo(),
      'Input' => const _InputDemo(),
      'Button' => const _ButtonDemo(),
      'Feedback' => const _FeedbackDemo(),
      'Layout' => const _LayoutDemo(),
      'Animation' => const _AnimationDemo(),
      _ => const Center(child: Text('?')),
    };

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: body,
      ),
    );
  }
}

// ============ DISPLAY WIDGETS ============
class _DisplayDemo extends StatelessWidget {
  const _DisplayDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWidgetCard('Text Widget', const Text(
          'This is a sample text widget with multiple lines. You can customize color, size, and style.',
          style: TextStyle(fontSize: 16),
        )),
        _buildWidgetCard('Icon Widget', const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.favorite, size: 40, color: Colors.red),
            Icon(Icons.star, size: 40, color: Colors.yellow),
            Icon(Icons.thumb_up, size: 40, color: Colors.blue),
          ],
        )),
        _buildWidgetCard('Container', Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.blue.shade200,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Center(
            child: Text('Container Widget', style: TextStyle(fontSize: 16)),
          ),
        )),
        _buildWidgetCard('Card', Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Card Widget', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Cards are used to group related content.'),
              ],
            ),
          ),
        )),
        _buildWidgetCard('Tooltip + LinearGradient', Tooltip(
          message: 'Hover atau tap untuk melihat tooltip',
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade400, Colors.purple.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                '🎁 Hover Me!',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        )),
      ],
    );
  }
}

// ============ BUTTON WIDGETS ============
class _ButtonDemo extends StatefulWidget {
  const _ButtonDemo();

  @override
  State<_ButtonDemo> createState() => _ButtonDemoState();
}

class _ButtonDemoState extends State<_ButtonDemo> {
  int clickCount = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWidgetCard('ElevatedButton', ElevatedButton.icon(
          onPressed: () {
            setState(() => clickCount++);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Elevated Button tapped!')),
            );
          },
          icon: const Icon(Icons.check),
          label: const Text('Click Me'),
        )),
        _buildWidgetCard('OutlinedButton', OutlinedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Outlined Button tapped!')),
            );
          },
          icon: const Icon(Icons.info),
          label: const Text('Info Button'),
        )),
        _buildWidgetCard('TextButton', TextButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Text Button tapped!')),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Add'),
        )),
        _buildWidgetCard('FloatingActionButton', Center(
          child: FloatingActionButton.extended(
            onPressed: () {
              setState(() => clickCount++);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Total clicks: $clickCount')),
              );
            },
            icon: const Icon(Icons.add),
            label: Text('Count: $clickCount'),
          ),
        )),
        _buildWidgetCard('IconButton', Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Liked!')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Shared!')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.bookmark),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bookmarked!')),
                );
              },
            ),
          ],
        )),
      ],
    );
  }
}

// ============ INPUT WIDGETS ============
class _InputDemo extends StatefulWidget {
  const _InputDemo();

  @override
  State<_InputDemo> createState() => _InputDemoState();
}

class _InputDemoState extends State<_InputDemo> {
  bool isChecked = false;
  double sliderValue = 50;
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWidgetCard('TextField', const TextField(
          decoration: InputDecoration(
            labelText: 'Enter your name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
        )),
        _buildWidgetCard('Checkbox', Row(
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (value) => setState(() => isChecked = value ?? false),
            ),
            const Text('I agree to terms and conditions'),
          ],
        )),
        _buildWidgetCard('Switch', Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Notifications'),
            Switch(
              value: isSwitched,
              onChanged: (value) => setState(() => isSwitched = value),
            ),
          ],
        )),
        _buildWidgetCard('Slider', Column(
          children: [
            Slider(
              value: sliderValue,
              min: 0,
              max: 100,
              onChanged: (value) => setState(() => sliderValue = value),
            ),
            Text('Value: ${sliderValue.toStringAsFixed(0)}'),
          ],
        )),
      ],
    );
  }
}

// ============ FEEDBACK WIDGETS ============
class _FeedbackDemo extends StatelessWidget {
  const _FeedbackDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWidgetCard('SnackBar', ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('This is a SnackBar message'),
                action: SnackBarAction(label: 'Undo', onPressed: () {}),
              ),
            );
          },
          child: const Text('Show SnackBar'),
        )),
        _buildWidgetCard('AlertDialog', ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Alert'),
                content: const Text('This is an alert dialog'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Show Dialog'),
        )),
        _buildWidgetCard('LinearProgressIndicator', Column(
          children: const [
            LinearProgressIndicator(value: 0.7),
            SizedBox(height: 16),
            CircularProgressIndicator(value: 0.7),
          ],
        )),
      ],
    );
  }
}

// ============ LAYOUT WIDGETS ============
class _LayoutDemo extends StatelessWidget {
  const _LayoutDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWidgetCard('Row', Container(
          padding: const EdgeInsets.all(8),
          color: Colors.grey.shade200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _colorBox(Colors.red, 'Item 1'),
              _colorBox(Colors.green, 'Item 2'),
              _colorBox(Colors.blue, 'Item 3'),
            ],
          ),
        )),
        _buildWidgetCard('Column', Container(
          padding: const EdgeInsets.all(8),
          color: Colors.grey.shade200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _colorBox(Colors.orange, 'Top'),
              _colorBox(Colors.purple, 'Middle'),
              _colorBox(Colors.teal, 'Bottom'),
            ],
          ),
        )),
        _buildWidgetCard('Stack with Positioned', Container(
          height: 200,
          color: Colors.grey.shade300,
          child: Stack(
            children: [
              Positioned(
                left: 10,
                top: 10,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('Top Left', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('Top Right', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ),
              Positioned(
                left: 30,
                bottom: 10,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('Bottom Left', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ),
              Positioned(
                right: 30,
                bottom: 10,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('Bottom Right', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ),
              const Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Text('Center', style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _colorBox(Color color, String label) {
    return Container(
      width: 80,
      height: 80,
      color: color,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// ============ ANIMATION WIDGETS ============
class _AnimationDemo extends StatefulWidget {
  const _AnimationDemo();

  @override
  State<_AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<_AnimationDemo> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 100).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWidgetCard('ScaleTransition', Center(
          child: ScaleTransition(
            scale: _animation.drive(Tween(begin: 0.5, end: 1.0)),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue.shade400,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('Scale', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        )),
        _buildWidgetCard('RotationTransition', Center(
          child: RotationTransition(
            turns: _animation.drive(Tween(begin: 0, end: 1)),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.cyan.shade400,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('Rotate', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        )),
        _buildWidgetCard('FadeTransition', Center(
          child: FadeTransition(
            opacity: _animation.drive(Tween(begin: 0.3, end: 1.0)),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.lime.shade400,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('Fade', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        )),
        _buildWidgetCard('SlideTransition', SlideTransition(
          position: _animation.drive(Tween(begin: Offset.zero, end: const Offset(0.3, 0))),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.pink.shade400,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('Slide', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        )),
      ],
    );
  }
}

// ============ HELPER FUNCTION ============
Widget _buildWidgetCard(String title, Widget child) {
  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    ),
  );
}