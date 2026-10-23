import 'package:flutter/material.dart';
import 'package:movira/services/support_service.dart';

import 'help_issues_feedback_screen.dart';

class SupportCenterScreen extends StatefulWidget {
  const SupportCenterScreen({super.key});

  @override
  State<SupportCenterScreen> createState() => _SupportCenterScreenState();
}

class _SupportCenterScreenState extends State<SupportCenterScreen> {
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
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);

  int _selectedSection = 0;
  bool _isCreatingTicket = false;
  final SupportService _supportService = SupportService();
  final TextEditingController _ticketDescriptionController =
      TextEditingController();

  final List<String> _sections = ['Support', 'Live Chat', 'Tickets'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: [
          const _SupportBackground(),
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
                  _buildSearch(),
                  const SizedBox(height: 22),
                  _buildSectionTabs(),
                  const SizedBox(height: 22),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _selectedSection == 0
                        ? _buildSupportSection()
                        : _selectedSection == 1
                        ? _buildLiveChatSection()
                        : _buildTicketsSection(),
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
                'SUPPORT CENTER',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'All MOVIRA support in one place',
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
          child: const Icon(Icons.support_agent_rounded, color: teal),
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
        boxShadow: const [
          BoxShadow(
            color: Color(0x22071B2C),
            blurRadius: 20,
            offset: Offset(0, 9),
          ),
        ],
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
            child: const Icon(Icons.headset_mic_rounded, color: navy, size: 31),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need help?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Call, message, chat live or manage support tickets without leaving this screen.',
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

  Widget _buildSearch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: lightBorder),
      ),
      child: const TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search_rounded, color: teal),
          hintText: 'Search support topics',
          hintStyle: TextStyle(color: textMuted, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildSectionTabs() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: lightBorder),
      ),
      child: Row(
        children: List.generate(_sections.length, (index) {
          final selected = _selectedSection == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedSection = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? navy : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  _sections[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? Colors.white : textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSupportSection() {
    return Column(
      key: const ValueKey('support'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Contact Support', 'Choose the fastest way to reach us'),
        const SizedBox(height: 14),
        _supportAction(
          icon: Icons.call_rounded,
          title: 'Helpline',
          subtitle: 'Speak directly with MOVIRA support',
          accent: teal,
          status: 'Available 24/7',
          onTap: () => _showPlaceholder('Helpline calling'),
        ),
        const SizedBox(height: 12),
        _supportAction(
          icon: Icons.chat_rounded,
          title: 'WhatsApp Support',
          subtitle: 'Start a quick conversation on WhatsApp',
          accent: success,
          status: 'Usually replies fast',
          onTap: () => _showPlaceholder('WhatsApp support'),
        ),
        const SizedBox(height: 12),
        _supportAction(
          icon: Icons.email_rounded,
          title: 'Email Support',
          subtitle: 'Send a detailed support request',
          accent: cyan,
          status: 'Reply within 24 hours',
          onTap: () => _showPlaceholder('Email support'),
        ),
        const SizedBox(height: 24),
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _openHelpIssuesFeedback,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FCFD),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: teal.withValues(alpha: 0.18)),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 46,
                  height: 46,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: softCyan,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Icon(Icons.help_center_rounded, color: teal),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Help, Issues & Feedback',
                        style: TextStyle(
                          color: textDark,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'FAQs, report issues, lost items and ratings.',
                        style: TextStyle(color: textMuted, fontSize: 10.5),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_rounded, color: teal, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _sectionTitle('Urgent Help', 'For immediate travel-related problems'),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7E8),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: warning.withValues(alpha: 0.24)),
          ),
          child: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: warning, size: 25),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Use Helpline or WhatsApp for urgent bus, route or safety-related support.',
                  style: TextStyle(
                    color: Color(0xFF8A5A12),
                    fontSize: 11,
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLiveChatSection() {
    return Column(
      key: const ValueKey('chat'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Live Chat', 'Chat with MOVIRA customer support'),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: lightBorder),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: softCyan,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.support_agent_rounded, color: teal),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MOVIRA Support Agent',
                          style: TextStyle(
                            color: textDark,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.circle, color: success, size: 8),
                            SizedBox(width: 6),
                            Text(
                              'Online now',
                              style: TextStyle(
                                color: textMuted,
                                fontSize: 10.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6FAFB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Hi! How can we help you with your journey today?',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 11.5,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: const TextStyle(color: textMuted, fontSize: 11.5),
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
                  suffixIcon: IconButton(
                    onPressed: () =>
                        _showPlaceholder('Live chat message sending'),
                    icon: const Icon(Icons.send_rounded, color: teal),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTicketsSection() {
    return Column(
      key: const ValueKey('tickets'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _sectionTitle(
                'Support Tickets',
                'Your submitted support requests',
              ),
            ),
            TextButton.icon(
              onPressed: _isCreatingTicket ? null : _showCreateTicketSheet,
              icon: const Icon(Icons.add_rounded),
              label: const Text('New'),
              style: TextButton.styleFrom(foregroundColor: teal),
            ),
          ],
        ),
        const SizedBox(height: 14),
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: _supportService.watchMyRequests(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(color: teal),
                ),
              );
            }

            if (snapshot.hasError) {
              return _ticketMessage(
                'Support requests could not be loaded. Sign in and check your connection.',
                Icons.cloud_off_rounded,
              );
            }

            final tickets = snapshot.data ?? const <Map<String, dynamic>>[];
            if (tickets.isEmpty) {
              return _ticketMessage(
                'You have no support requests yet. Select New to submit one.',
                Icons.inbox_outlined,
              );
            }

            return Column(
              children: List.generate(tickets.length, (index) {
                final ticket = tickets[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == tickets.length - 1 ? 0 : 12,
                  ),
                  child: _ticketCard(ticket),
                );
              }),
            );
          },
        ),
      ],
    );
  }

  Widget _ticketMessage(String message, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: lightBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: teal, size: 30),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: textMuted, fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _supportAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accent,
    required String status,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: lightBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: accent),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: textMuted, fontSize: 10.5),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    status,
                    style: TextStyle(
                      color: accent,
                      fontSize: 9.8,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: textMuted),
          ],
        ),
      ),
    );
  }

  Widget _ticketCard(Map<String, dynamic> ticket) {
    final status = (ticket['status'] ?? 'open').toString();
    final title = (ticket['title'] ?? 'Support request').toString();
    final id = (ticket['id'] ?? '').toString();
    final resolved =
        status.toLowerCase() == 'resolved' || status.toLowerCase() == 'closed';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: lightBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: resolved
                  ? success.withValues(alpha: 0.10)
                  : cyan.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              resolved
                  ? Icons.check_circle_rounded
                  : Icons.confirmation_number_rounded,
              color: resolved ? success : cyan,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Reference: ${id.isEmpty ? 'Pending' : id} | Status: $status",
                  style: TextStyle(
                    color: resolved ? success : textMuted,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
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

  void _openHelpIssuesFeedback() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HelpIssuesFeedbackScreen()),
    );
  }

  void _showPlaceholder(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature will be connected during the backend/integration phase.',
        ),
      ),
    );
  }

  void _showCreateTicketSheet() {
    _ticketDescriptionController.clear();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            decoration: const BoxDecoration(
              color: white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Support Ticket',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _ticketDescriptionController,
                  decoration: InputDecoration(
                    hintText: 'Describe your issue',
                    filled: true,
                    fillColor: const Color(0xFFF7FBFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: lightBorder),
                    ),
                  ),
                  maxLength: 5000,
                  maxLines: 4,
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isCreatingTicket
                        ? null
                        : () => _createTicket(sheetContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isCreatingTicket
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Submit Ticket',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _createTicket(BuildContext sheetContext) async {
    final description = _ticketDescriptionController.text.trim();
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Describe your issue before submitting.')),
      );
      return;
    }
    if (_isCreatingTicket) return;

    setState(() => _isCreatingTicket = true);
    try {
      final id = await _supportService.submitRequest(
        type: 'ticket',
        title: description.length > 160
            ? '${description.substring(0, 157)}...'
            : description,
        description: description,
        details: const <String, dynamic>{'source': 'Support Center'},
      );

      if (!mounted || !sheetContext.mounted) return;
      Navigator.of(sheetContext).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ticket submitted. Reference: $id')),
      );
    } on StateError catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message.toString())));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Ticket submission failed. Check sign-in and connection, then try again.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCreatingTicket = false);
    }
  }

  @override
  void dispose() {
    _ticketDescriptionController.dispose();
    super.dispose();
  }
}

class _SupportBackground extends StatelessWidget {
  const _SupportBackground();

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
