import 'package:flutter/material.dart';
import 'package:movira/services/support_service.dart';

class HelpIssuesFeedbackScreen extends StatefulWidget {
  const HelpIssuesFeedbackScreen({super.key});

  @override
  State<HelpIssuesFeedbackScreen> createState() =>
      _HelpIssuesFeedbackScreenState();
}

class _HelpIssuesFeedbackScreenState extends State<HelpIssuesFeedbackScreen> {
  static const Color navy = Color(0xFF071B2C);
  static const Color navySoft = Color(0xFF123247);
  static const Color teal = Color(0xFF00C7B7);
  static const Color cyan = Color(0xFF21D4FD);
  static const Color ice = Color(0xFFF4FBFD);
  static const Color white = Color(0xFFFFFFFF);
  static const Color softCyan = Color(0xFFDDFBFA);
  static const Color textDark = Color(0xFF12212D);
  static const Color textMuted = Color(0xFF6B7C88);
  static const Color lightBorder = Color(0xFFE1EDF1);
  static const Color warning = Color(0xFFF59E0B);

  int _selectedTab = 0;
  int _rating = 0;
  bool _isSubmitting = false;
  final Map<String, TextEditingController> _fieldControllers = {};

  TextEditingController _controllerFor(String hint) {
    return _fieldControllers.putIfAbsent(hint, () => TextEditingController());
  }

  final List<String> _tabs = ['FAQ', 'Report Issue', 'Lost Item', 'Feedback'];

  final List<Map<String, String>> _faqs = [
    {
      'q': 'How do I track a bus?',
      'a': 'Open Live Tracking from the app and choose your bus or route to view its current journey status.',
    },
    {
      'q': 'How do I save a favorite route?',
      'a': 'Open a route and use the save or favorite option. Saved routes appear in My Trips.',
    },
    {
      'q': 'Why is a bus showing delayed?',
      'a': 'Delay information is shown when MOVIRA receives updated service or traffic information for that route.',
    },
    {
      'q': 'How do trip reminders work?',
      'a': 'Trip reminders can notify you before departure, during delays, and before reaching your destination.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: [
          const _HelpBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildHero(),
                  const SizedBox(height: 22),
                  _buildTabs(),
                  const SizedBox(height: 22),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _selectedTab == 0
                        ? _buildFaqSection()
                        : _selectedTab == 1
                        ? _buildReportIssueSection()
                        : _selectedTab == 2
                        ? _buildLostItemSection()
                        : _buildFeedbackSection(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: lightBorder),
            ),
            child: const Icon(Icons.arrow_back_rounded, color: navy),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: lightBorder),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              'assets/branding/movira_icon.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 11),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HELP & FEEDBACK',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'FAQs, issues, lost items and ratings',
                style: TextStyle(
                  color: textMuted,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: softCyan,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.help_outline_rounded, color: teal),
        ),
      ],
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [navy, navySoft, Color(0xFF15516A)],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(colors: [teal, cyan]),
            ),
            child: const Icon(
              Icons.question_answer_rounded,
              color: navy,
              size: 31,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Everything you need to resolve an issue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Browse FAQs, report problems, submit lost-item details, or rate your experience.',
                  style: TextStyle(
                    color: Color(0xFFC7E3EF),
                    fontSize: 11.5,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: lightBorder),
      ),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: List.generate(_tabs.length, (index) {
          final selected = _selectedTab == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
              decoration: BoxDecoration(
                color: selected ? navy : Colors.transparent,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                _tabs[index],
                style: TextStyle(
                  color: selected ? Colors.white : textMuted,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFaqSection() {
    return Column(
      key: const ValueKey('faq'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          'Frequently Asked Questions',
          'Quick answers to common questions',
        ),
        const SizedBox(height: 14),
        ..._faqs.map((faq) => _faqTile(faq)),
      ],
    );
  }

  Widget _faqTile(Map<String, String> faq) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 14),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        collapsedBackgroundColor: white,
        backgroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: lightBorder),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: lightBorder),
        ),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: softCyan,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.question_mark_rounded, color: teal, size: 18),
        ),
        title: Text(
          faq['q']!,
          style: const TextStyle(
            color: textDark,
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        children: [
          Text(
            faq['a']!,
            style: const TextStyle(
              color: textMuted,
              fontSize: 10.8,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportIssueSection() {
    return Column(
      key: const ValueKey('issue'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Report an Issue', 'Tell us what went wrong'),
        const SizedBox(height: 14),
        _formCard(
          children: [
            _inputField('Issue category', Icons.category_rounded),
            const SizedBox(height: 12),
            _inputField('Bus number or route', Icons.directions_bus_rounded),
            const SizedBox(height: 12),
            _inputField(
              'Describe the problem',
              Icons.description_rounded,
              maxLines: 4,
            ),
            const SizedBox(height: 14),
            _submitButton(
              'Submit Issue Report',
              Icons.report_problem_rounded,
              () => _submitIssueReport(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLostItemSection() {
    return Column(
      key: const ValueKey('lost'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Lost Item', 'Report something left on a bus'),
        const SizedBox(height: 14),
        _formCard(
          children: [
            _inputField('Item name', Icons.inventory_2_outlined),
            const SizedBox(height: 12),
            _inputField('Bus / route', Icons.route_rounded),
            const SizedBox(height: 12),
            _inputField('Date and approximate time', Icons.schedule_rounded),
            const SizedBox(height: 12),
            _inputField(
              'Describe the item',
              Icons.edit_note_rounded,
              maxLines: 4,
            ),
            const SizedBox(height: 14),
            _submitButton(
              'Submit Lost Item Report',
              Icons.search_rounded,
              () => _submitLostItemReport(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeedbackSection() {
    return Column(
      key: const ValueKey('feedback'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Feedback & Ratings', 'Help us improve MOVIRA'),
        const SizedBox(height: 14),
        _formCard(
          children: [
            const Text(
              'Rate your experience',
              style: TextStyle(
                color: textDark,
                fontSize: 13.5,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(5, (index) {
                final selected = index < _rating;
                return IconButton(
                  onPressed: () => setState(() => _rating = index + 1),
                  icon: Icon(
                    selected ? Icons.star_rounded : Icons.star_border_rounded,
                    color: selected ? warning : textMuted,
                    size: 30,
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            _inputField(
              'Write your feedback',
              Icons.rate_review_rounded,
              maxLines: 4,
            ),
            const SizedBox(height: 14),
            _submitButton(
              'Submit Feedback',
              Icons.send_rounded,
              () => _submitFeedback(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _formCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: lightBorder),
      ),
      child: Column(children: children),
    );
  }

  Widget _inputField(String hint, IconData icon, {int maxLines = 1}) {
    return TextField(
      controller: _controllerFor(hint),
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: textMuted, fontSize: 11.5),
        prefixIcon: Icon(icon, color: teal),
        filled: true,
        fillColor: const Color(0xFFF7FBFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: lightBorder),
        ),
      ),
    );
  }

  Widget _submitButton(String text, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isSubmitting ? null : onTap,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: textDark,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: textMuted, fontSize: 11.5),
        ),
      ],
    );
  }

  Future<void> _submitIssueReport() async {
    final category = _controllerFor('Issue category').text.trim();
    final route = _controllerFor('Bus number or route').text.trim();
    final description = _controllerFor('Describe the problem').text.trim();

    if (category.isEmpty || description.isEmpty) {
      _showMessage('Enter an issue category and describe the problem.');
      return;
    }

    await _submitSupportRequest(
      type: 'issue',
      title: 'Issue: $category',
      description: description,
      details: <String, dynamic>{'category': category, 'route': route},
    );
  }

  Future<void> _submitLostItemReport() async {
    final itemName = _controllerFor('Item name').text.trim();
    final route = _controllerFor('Bus / route').text.trim();
    final dateTime = _controllerFor('Date and approximate time').text.trim();
    final description = _controllerFor('Describe the item').text.trim();

    if (itemName.isEmpty || description.isEmpty) {
      _showMessage('Enter the item name and describe the lost item.');
      return;
    }

    await _submitSupportRequest(
      type: 'lost_item',
      title: 'Lost item: $itemName',
      description: description,
      details: <String, dynamic>{
        'itemName': itemName,
        'route': route,
        'dateTime': dateTime,
      },
    );
  }

  Future<void> _submitFeedback() async {
    final feedback = _controllerFor('Write your feedback').text.trim();

    if (feedback.isEmpty) {
      _showMessage('Please write your feedback before submitting.');
      return;
    }

    await _submitSupportRequest(
      type: 'feedback',
      title: 'User feedback',
      description: feedback,
      details: const <String, dynamic>{'source': 'Help and Feedback'},
      rating: _rating > 0 ? _rating : null,
    );
  }

  Future<void> _submitSupportRequest({
    required String type,
    required String title,
    required String description,
    required Map<String, dynamic> details,
    int? rating,
  }) async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      final requestId = await SupportService().submitRequest(
        type: type,
        title: title,
        description: description,
        details: details,
        rating: rating,
      );

      if (mounted) {
        _showMessage('Submitted successfully. Reference: $requestId');
        setState(() {
          for (final controller in _fieldControllers.values) {
            controller.clear();
          }
          if (type == 'feedback') _rating = 0;
        });
      }
    } on StateError catch (error) {
      if (mounted) _showMessage(error.message.toString());
    } catch (_) {
      if (mounted) {
        _showMessage(
          'Submission failed. Check your connection and sign-in, then try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    for (final controller in _fieldControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _HelpBackground extends StatelessWidget {
  const _HelpBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF9FDFF), Color(0xFFF0FAFD), Color(0xFFF7FCFD)],
            ),
          ),
        ),
        Positioned(
          top: -110,
          right: -80,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF21D4FD).withValues(alpha: 0.09),
            ),
          ),
        ),
        Positioned(
          bottom: -130,
          left: -100,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00C7B7).withValues(alpha: 0.07),
            ),
          ),
        ),
      ],
    );
  }
}
