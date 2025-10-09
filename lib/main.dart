import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:responsive_builder/responsive_builder.dart';

void main() => runApp(const CVApp());

class CVApp extends StatelessWidget {
  const CVApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.apply(
          fontFamily: 'PlayfairDisplay',
        );

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'PlayfairDisplay',
        textTheme: textTheme.copyWith(
          headlineSmall: textTheme.headlineSmall?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: textTheme.headlineMedium?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: textTheme.bodyLarge?.copyWith(
            fontSize: 16,
          ),
          bodyMedium: textTheme.bodyMedium?.copyWith(
            fontSize: 14,
          ),
          labelLarge: textTheme.labelLarge?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const CVHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Project {
  final String title;
  final String description;
  final String role;
  final List<String> contributions;
  final List<String> outcomes;
  final String imagePath;

  const Project({
    required this.title,
    required this.description,
    required this.role,
    required this.contributions,
    required this.outcomes,
    required this.imagePath,
  });
}

class LinkProject {
  final String name;
  final String url;

  const LinkProject(this.name, this.url);
}

class CourseItem {
  final String title;
  final String? verificationUrl;

  const CourseItem(this.title, this.verificationUrl);
}

class AccomplishmentItem {
  final IconData icon;
  final String text;

  const AccomplishmentItem({required this.icon, required this.text});
}

class EducationTile extends StatelessWidget {
  final String degree;
  final String institution;
  final String period;
  final String details;
  final Color primaryColor;
  final String? launchURL;
  final String? schoolURL;
  final String? systemURL;

  const EducationTile({
    super.key,
    required this.degree,
    required this.institution,
    required this.period,
    required this.details,
    required this.primaryColor,
    this.launchURL,
    this.schoolURL,
    this.systemURL,
  });

  Future<void> _launchLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, primaryColor.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryColor.withOpacity(0.1)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.school, color: primaryColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          degree,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            if (launchURL != null)
                              _linkText(institution, launchURL!)
                            else if (schoolURL != null)
                              _linkText(institution, schoolURL!)
                            else
                              Text(institution, style: const TextStyle(fontSize: 16)),
                            if (systemURL != null)
                              _linkText("(Cambridge International Exams)", systemURL!),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  period,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(details, style: const TextStyle(fontSize: 14, height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _linkText(String text, String url) {
    return GestureDetector(
      onTap: () => _launchLink(url),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class CVHomePage extends StatefulWidget {
  const CVHomePage({super.key});

  @override
  _CVHomePageState createState() => _CVHomePageState();
}

class _CVHomePageState extends State<CVHomePage> with SingleTickerProviderStateMixin {
  String _currentSection = 'welcome';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  final Color _primaryColor = const Color(0xFF2A3F54);
  final Color _secondaryColor = const Color(0xFF1ABB9C);
  final Color _accentColor = const Color(0xFF1ABB9C);
  final Color _lightColor = const Color(0xFFF7F9FC);
  final Color _darkColor = const Color(0xFF1A2A3A);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $phoneNumber')),
      );
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('https://wa.me/$cleanedNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch WhatsApp for $phoneNumber')),
      );
    }
  }

  void _updateSection(String section) {
    setState(() {
      _currentSection = section;
    });
  }

  void _handleMenuTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
      if (_scaffoldKey.currentState!.isDrawerOpen) {
        Navigator.of(context).pop();
      } else {
        _scaffoldKey.currentState!.openDrawer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final isMobile = sizingInformation.isMobile;

        return Scaffold(
          key: _scaffoldKey,
          appBar: isMobile ? _buildMobileAppBar() : null,
          drawer: isMobile ? _buildDrawer() : null,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_lightColor, Colors.white],
              ),
            ),
            child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildMobileAppBar() {
    return AppBar(
      backgroundColor: _primaryColor,
      elevation: 4,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_primaryColor, _accentColor],
          ),
        ),
      ),
      leading: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: IconButton(
                icon: ClipOval(
                  child: Image.asset(
                    'assets/assets/profile.jpeg',
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, color: Colors.white);
                    },
                  ),
                ),
                onPressed: _handleMenuTap,
              ),
            ),
          );
        },
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Takawira Mazando",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            "Software Developer | Data Scientist | AI Engineer",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        _buildContactPopupMenu(),
      ],
    );
  }

  Widget _buildContactPopupMenu() {
    return PopupMenuButton(
      icon: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.purple.shade600],
          ),
        ),
        child: const Icon(Icons.contact_phone, color: Colors.white, size: 18),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          height: 50,
          child: ListTile(
            leading: Icon(FontAwesomeIcons.envelope, color: Colors.red),
            title: const Text("Email"),
            onTap: () => _launchURL('mailto:mazandotakawira@gmail.com'),
          ),
        ),
        PopupMenuItem(
          height: 50,
          child: ListTile(
            leading: Icon(FontAwesomeIcons.phone, color: Colors.green),
            title: const Text("Call"),
            onTap: () => _makePhoneCall("+27672319200"),
          ),
        ),
        PopupMenuItem(
          height: 50,
          child: ListTile(
            leading: Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
            title: const Text("WhatsApp"),
            onTap: () => _openWhatsApp("+27672319200"),
          ),
        ),
        PopupMenuItem(
          height: 50,
          child: ListTile(
            leading: Icon(FontAwesomeIcons.linkedin, color: Colors.blue),
            title: const Text("LinkedIn"),
            onTap: () => _launchURL('https://www.linkedin.com/in/takawira-mazando-3a775715b'),
          ),
        ),
        PopupMenuItem(
          height: 50,
          child: ListTile(
            leading: Icon(FontAwesomeIcons.github, color: Colors.grey),
            title: const Text("GitHub"),
            onTap: () => _launchURL('https://github.com/BantuITBS'),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_lightColor, Colors.white],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _buildDrawerItem(Icons.home, '', 'welcome', _lightColor, Colors.red),
            _buildDrawerItem(Icons.description, 'Full CV', 'full_cv', _lightColor, _secondaryColor),
            _buildDrawerItem(Icons.person, 'Professional Summary', 'summary', _lightColor, Colors.orange),
            _buildDrawerItem(Icons.build, 'Technical Skills', 'skills', _lightColor, Colors.yellow[700]!),
            _buildDrawerItem(Icons.people, 'Soft Skills', 'soft_skills', _lightColor, Colors.green),
            _buildDrawerItem(Icons.work, 'Professional Experience', 'experience', _lightColor, Colors.blue),
            _buildDrawerItem(Icons.school, 'Education', 'education', _lightColor, Colors.indigo),
            _buildDrawerItem(Icons.card_membership, 'Certifications', 'certifications', _lightColor, Colors.purple),
            _buildDrawerItem(Icons.emoji_events, 'Accomplishments', 'accomplishments', _lightColor, Colors.pink),
            _buildDrawerItem(Icons.folder, 'Projects', 'projects', _lightColor, Colors.cyan),
            _buildDrawerItem(Icons.favorite, 'Hobbies & Interests', 'hobbies', _lightColor, Colors.teal),
            _buildDrawerItem(Icons.people_outline, 'References', 'references', _lightColor, Colors.teal),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: _getContent(_currentSection),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      children: [
        _buildMainHeader(),
        Expanded(
          child: Row(
            children: [
              Container(
                width: 280,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_lightColor, Colors.white],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(2, 0),
                    )
                  ],
                ),
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    _buildSidebarItem(Icons.home, '', 'welcome', Colors.red),
                    _buildSidebarItem(Icons.description, 'Full CV', 'full_cv', _secondaryColor),
                    _buildSidebarItem(Icons.person, 'Professional Summary', 'summary', Colors.orange),
                    _buildSidebarItem(Icons.build, 'Technical Skills', 'skills', Colors.yellow[700]!),
                    _buildSidebarItem(Icons.people, 'Soft Skills', 'soft_skills', Colors.green),
                    _buildSidebarItem(Icons.work, 'Professional Experience', 'experience', Colors.blue),
                    _buildSidebarItem(Icons.school, 'Education', 'education', Colors.indigo),
                    _buildSidebarItem(Icons.card_membership, 'Certifications', 'certifications', Colors.purple),
                    _buildSidebarItem(Icons.emoji_events, 'Accomplishments', 'accomplishments', Colors.pink),
                    _buildSidebarItem(Icons.folder, 'Projects', 'projects', Colors.cyan),
                    _buildSidebarItem(Icons.favorite, 'Hobbies & Interests', 'hobbies', Colors.teal),
                    _buildSidebarItem(Icons.people_outline, 'References', 'references', Colors.teal),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    child: _getContent(_currentSection),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_primaryColor, _accentColor],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/profile.jpeg',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.white,
                    child: const Icon(Icons.person, color: Colors.grey, size: 30),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Takawira Mazando",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Software Developer (Mobile & Web) | Data Scientist | AI (LLM-RAG) Engineer",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _buildHeaderContactButtons(),
        ],
      ),
    );
  }

  Widget _buildHeaderContactButtons() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      alignment: WrapAlignment.end,
      children: [
        _buildHeaderContactButton(
          icon: FontAwesomeIcons.envelope,
          color: Colors.red,
          onTap: () => _launchURL('mailto:mazandotakawira@gmail.com'),
        ),
        _buildHeaderContactButton(
          icon: FontAwesomeIcons.phone,
          color: Colors.green,
          onTap: () => _makePhoneCall("+27672319200"),
        ),
        _buildHeaderContactButton(
          icon: FontAwesomeIcons.whatsapp,
          color: Colors.green,
          onTap: () => _openWhatsApp("+27672319200"),
        ),
        _buildHeaderContactButton(
          icon: FontAwesomeIcons.linkedin,
          color: Colors.blue,
          onTap: () => _launchURL('https://www.linkedin.com/in/takawira-mazando-3a775715b'),
        ),
        _buildHeaderContactButton(
          icon: FontAwesomeIcons.github,
          color: Colors.grey,
          onTap: () => _launchURL('https://github.com/BantuITBS'),
        ),
      ],
    );
  }

  Widget _buildHeaderContactButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white.withOpacity(0.2),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          width: 32,
          height: 32,
          padding: const EdgeInsets.all(6),
          child: Icon(icon, color: Colors.white, size: 14),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, String section, Color bgColor, Color iconColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _currentSection == section ? _secondaryColor.withOpacity(0.2) : bgColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: _currentSection == section ? [BoxShadow(color: _secondaryColor.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))] : null,
      ),
      child: ListTile(
        leading: Icon(icon, color: _currentSection == section ? _secondaryColor : iconColor),
        title: Text(
          title,
          style: TextStyle(
            color: _currentSection == section ? _secondaryColor : Colors.grey[700],
            fontWeight: _currentSection == section ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {
          setState(() => _currentSection = section);
          Navigator.pop(context);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, String section, Color iconColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _currentSection == section ? _secondaryColor.withOpacity(0.2) : _lightColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: _currentSection == section ? [BoxShadow(color: _secondaryColor.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))] : null,
      ),
      child: ListTile(
        leading: Icon(icon, color: _currentSection == section ? _secondaryColor : iconColor),
        title: Text(
          title,
          style: TextStyle(
            color: _currentSection == section ? _secondaryColor : Colors.grey[700],
            fontWeight: _currentSection == section ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () => setState(() => _currentSection = section),
      ),
    );
  }

  Widget _getContent(String section) {
    switch (section) {
      case 'welcome':
        return WelcomeContent(
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          onGetStarted: () => _updateSection('projects'),
        );
      case 'summary':
        return ProfessionalSummaryContent(primaryColor: _primaryColor);
      case 'skills':
        return TechnicalSkillsContent(primaryColor: _primaryColor, secondaryColor: _secondaryColor);
      case 'soft_skills':
        return SoftSkillsContent(primaryColor: _primaryColor);
      case 'experience':
        return ProfessionalExperienceContent(primaryColor: _primaryColor, secondaryColor: _secondaryColor);
      case 'education':
        return EducationContent(primaryColor: _primaryColor);
      case 'certifications':
        return CertificationsContent(primaryColor: _primaryColor, launchURL: _launchURL);
      case 'accomplishments':
        return AccomplishmentsContent(primaryColor: _primaryColor);
      case 'references':
        return ReferencesContent(primaryColor: _primaryColor);
      case 'projects':
        return ProjectsContent(
          onProjectTap: _showProjectDetails,
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
        );
      case 'full_cv':
        return FullCVContent(
          launchURL: _launchURL,
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
        );
      case 'hobbies':
        return HobbiesContent(primaryColor: _primaryColor);
      default:
        return WelcomeContent(
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          onGetStarted: () => _updateSection('projects'),
        );
    }
  }

  void _showProjectDetails(Project project) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProjectDetailsModal(
        project: project,
        primaryColor: _primaryColor,
        secondaryColor: _secondaryColor,
      ),
    );
  }
}

class WelcomeContent extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final VoidCallback onGetStarted;

  const WelcomeContent({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.onGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryColor.withOpacity(0.1),
                      secondaryColor.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      "Welcome to My Professional Profile",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontFamily: 'PlayfairDisplay',
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Designing, developing, integrating, and deploying solutions that drive success",
                      style: TextStyle(
                        fontSize: 14,
                        color: primaryColor.withOpacity(0.8),
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // --- Portfolio button
        Center(
          child: ElevatedButton.icon(
            onPressed: onGetStarted,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: secondaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 8,
            ),
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: const Text(
              "View Projects Portfolio",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // --- Navigation button to explore profile sections
        Center(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  // Open the navigation drawer if on mobile
                  if (Scaffold.of(context).hasDrawer) {
                    Scaffold.of(context).openDrawer();
                  }
                  // For desktop, the sidebar is already visible so no action needed
                },
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      ),
                    ],
                    border: Border.all(color: primaryColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.explore, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "Explore All Sections",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "View Professional Summary, Skills, Experience & more",
                style: TextStyle(
                  fontSize: 12,
                  color: primaryColor.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }
}

class HobbiesContent extends StatelessWidget {
  final Color primaryColor;

  const HobbiesContent({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, primaryColor.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite, color: primaryColor, size: 24),
              const SizedBox(width: 12),
              Text(
                "Hobbies & Interests",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildHobbyItem(Icons.family_restroom, "Family Time", "Having a great time at home with my family"),
          _buildHobbyItem(Icons.sports_baseball, "Live Sports", "Watching live sport events"),
          _buildHobbyItem(Icons.beach_access, "Holidays", "Going on holidays with family"),
          _buildHobbyItem(Icons.park, "Outdoors & Wildlife", "I love the outdoors (I'm a wildlife fanatic)"),
          _buildHobbyItem(Icons.menu_book, "Reading", "I'm an avid reader"),
          _buildHobbyItem(Icons.build, "Creative Solutions", "I like creating solutions even during my spare time"),
        ],
      ),
    );
  }

  Widget _buildHobbyItem(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: primaryColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfessionalSummaryContent extends StatelessWidget {
  final Color primaryColor;

  const ProfessionalSummaryContent({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Text(
        "Accomplished Data Scientist and Software Developer with over 15 years of experience, I transform complex data into actionable insights that drive strategic success. Proficient in Python, AI/ML, JavaScript, TypeScript, SQL, Dart, and VBA, I specialize in crafting innovative mobile and web solutions. I contributed to high-impact projects, including a R2.4B inventory optimization for Transnet, utilizing Power BI, TensorFlow, Spark, and Hadoop to optimize supply chain efficiency and auditing processes. With a background in laboratory Analytical Science at the onset of my career, I have an keen eye for detail, I excel in stakeholder engagement, mentoring, and technical reporting. Skilled in Agile methodologies, GDPR/POPIA compliance, SCM analytics, and CAATs, I deliver secure, impactful, and compliant solutions.",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class TechnicalSkillsContent extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;

  const TechnicalSkillsContent({super.key, required this.primaryColor, required this.secondaryColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSkillCategory(context, icon: FontAwesomeIcons.code, title: "Programming Languages", skills: [
          "Python 3 (Advanced: backend, AI/ML, analytics, automation)",
          "JavaScript (Moderate: ES6+, front-end)",
          "TypeScript (Component-based UI)",
          "SQL (Advanced: PostgreSQL, T-SQL, query optimization)",
          "Dart (Flutter, mobile apps)",
          "VBA (Excellent: Excel automation)",
          "Bash (Scripting)",
        ]),
        _buildSkillCategory(context, icon: FontAwesomeIcons.cubes, title: "Frameworks & Libraries", skills: [
          "Pandas (Data manipulation)",
          "Django (REST APIs, Supabase)",
          "Flask (Lightweight APIs)",
          "FastAPI (High-performance APIs)",
          "TensorFlow (Deep learning)",
          "scikit-learn (Machine learning)",
          "PyTorch (Neural networks)",
          "spaCy (NLP)",
          "transformers (NLP models)",
          "nltk (Text processing)",
          "NumPy (Numerical computing)",
          "Plotly (Interactive visualizations)",
          "Dash (Web dashboards)",
          "Matplotlib (Data visualization)",
          "Seaborn (Statistical visualizations)",
          "openpyxl (Excel automation)",
          "xlwings (Excel integration)",
          "pywin32 (Windows automation)",
          "psycopg2 (PostgreSQL connector)",
          "sqlalchemy (ORM)",
          "Bootstrap 5 (Responsive UI)",
          "jQuery (DOM manipulation)",
          "Select2 (Dynamic dropdowns)",
          "Font Awesome (Icons)",
          "libphonenumber-js (Phone number parsing)",
          "SPSS (Statistical analysis)",
          "SSAS (OLAP cubes)",
          "SSRS (Reporting)",
          "SSIS (Data integration)",
          "SSDT (SQL development)",
          "SSMS (SQL Server management)",
        ]),
        _buildSkillCategory(context, icon: FontAwesomeIcons.robot, title: "AI Tools", skills: [
          "Lovable AI (Conversational AI, user engagement)",
          "Grok (AI-driven insights)",
          "Deepseek (Deep learning applications)",
          "MetaAI (AI model integration)",
          "ChatGPT (NLP and automation)",
        ]),
        _buildSkillCategory(context, icon: FontAwesomeIcons.database, title: "Big Data Frameworks", skills: [
          "Spark (Distributed computing)",
          "Hadoop (Big Data processing)",
        ]),
        _buildSkillCategory(context, icon: FontAwesomeIcons.server, title: "Databases", skills: [
          "PostgreSQL (Supabase, CTEs, window functions)",
          "MySQL (Relational databases)",
          "SQLite (Lightweight databases)",
          "MongoDB (NoSQL)",
          "Firebase Firestore (Real-time NoSQL)",
          "Redis (Caching)",
          "SAP (QM, MM, RE-FX tables)",
        ]),
        _buildSkillCategory(context, icon: FontAwesomeIcons.chartBar, title: "BI & Automation Tools", skills: [
          "Power BI (Advanced: Power Query, DAX, MDAX, dashboards)",
          "Power Automate (Workflow automation)",
          "Power Apps (Canvas, Model-Driven apps)",
          "Tableau (Data visualization)",
          "Excel (Advanced: pivot tables, VLOOKUP, INDEX-MATCH, SUMIFS, VBA)",
          "MS Word (Documents)",
          "MS PowerPoint (Presentations)",
          "MS SharePoint (Collaboration)",
          "MS Teams (Communication)",
        ]),
        _buildSkillCategory(context, icon: FontAwesomeIcons.cloud, title: "DevOps & Version Control", skills: [
          "Docker (Containerization)",
          "AWS (EC2, S3, Lambda, SageMaker)",
          "Azure (App Service, Cosmos DB)",
          "Supabase (Backend-as-a-Service)",
          "Firebase (Mobile/web backend)",
          "GitHub Actions (CI/CD)",
          "Jenkins (Automation)",
          "Git (GitHub, GitLab, Bitbucket, Azure DevOps)",
        ]),
        _buildSkillCategory(context, icon: FontAwesomeIcons.lightbulb, title: "Methodologies & Concepts", skills: [
          "Machine Learning (NLP, predictive analytics, recommendation systems, classification, regression, clustering)",
          "Data Modeling (Relational, dimensional)",
          "ETL/ELT (Data pipelines)",
          "CAATs (Computer Assisted Audit Techniques)",
          "Agile (Scrum, Kanban)",
          "Responsive Design",
          "API Development (REST, WebSockets, GraphQL)",
          "KPI Tracking",
          "Excel Automation",
          "Information Security (GDPR, POPIA)",
          "Auditing Methodologies (Forensic auditing)",
          "SCM Analytics (Supply chain optimization)",
          "LIMS (Laboratory Information Management Systems)",
          "Technical Report Writing",
          "Data Engineering",
        ]),
        _buildSkillCategory(context, icon: FontAwesomeIcons.tools, title: "IDEs & Tools", skills: [
          "VS Code (Code editing)",
          "PyCharm (Python development)",
          "Jupyter Notebook (Data analysis)",
          "Jupyter Lab (Interactive computing)",
          "Mito (Excel-like data editing)",
          "Power BI Desktop (BI development)",
          "Supabase Studio (Database management)",
          "Postman (API testing)",
          "pgAdmin (PostgreSQL management)",
          "Chrome DevTools (Web debugging)",
          "Flutter DevTools (Mobile debugging)",
          "Uptime Robot (Monitoring)",
          "Sentry (Error tracking)",
        ]),
      ],
    );
  }

  Widget _buildSkillCategory(BuildContext context, {required IconData icon, required String title, required List<String> skills}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: secondaryColor),
              const SizedBox(width: 8),
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: primaryColor, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: secondaryColor.withOpacity(0.3)),
              ),
              child: Text(skill, style: TextStyle(color: primaryColor, fontSize: 12)),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class SoftSkillsContent extends StatelessWidget {
  final Color primaryColor;

  const SoftSkillsContent({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return SkillGrid();
  }
}

class SkillGrid extends StatelessWidget {
  const SkillGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final isMobile = sizingInformation.isMobile;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SkillItem(icon: Icons.group, text: "Team Leadership: Guided cross-functional teams of developers, analysts, and scientists to achieve project goals, fostering collaboration and innovation.", width: isMobile ? double.infinity : 300),
            SkillItem(icon: Icons.assignment, text: "Project Management: Oversaw end-to-end delivery of complex technical projects, ensuring timely completion within budget and scope.", width: isMobile ? double.infinity : 300),
            SkillItem(icon: Icons.timeline, text: "Strategic Planning: Aligned technical solutions with business objectives, driving organizational success in data-driven initiatives.", width: isMobile ? double.infinity : 300),
            SkillItem(icon: Icons.handshake, text: "Stakeholder Engagement: Communicated effectively with clients, executives, and cross-industry partners to align on project goals and deliverables.", width: isMobile ? double.infinity : 300),
            SkillItem(icon: Icons.lightbulb, text: "Problem-Solving: Developed innovative solutions to complex technical and analytical challenges in development and scientific contexts.", width: isMobile ? double.infinity : 300),
            SkillItem(icon: Icons.comment, text: "Communication: Delivered clear, concise presentations and technical reports to diverse audiences, including students and industry stakeholders.", width: isMobile ? double.infinity : 300),
            SkillItem(icon: Icons.school, text: "Mentoring and Lecturing: Mentored junior developers and analysts, and lectured on data science and microbiology, fostering professional and academic growth.", width: isMobile ? double.infinity : 300),
            SkillItem(icon: Icons.cached, text: "Adaptability: Thrived in fast-paced, dynamic environments, adapting to new technologies and scientific methodologies.", width: isMobile ? double.infinity : 300),
            SkillItem(icon: Icons.access_time, text: "Time Management: Prioritized tasks and managed deadlines effectively across development, analytics, and laboratory projects.", width: isMobile ? double.infinity : 300),
            SkillItem(icon: Icons.mediation, text: "Conflict Resolution: Mediated team disputes to ensure cohesive collaboration and maintain project momentum.", width: isMobile ? double.infinity : 300),
            SkillItem(icon: Icons.gavel, text: "Decision-Making: Made data-driven decisions to optimize outcomes in software development, data analysis, and laboratory operations.", width: isMobile ? double.infinity : 300),
            SkillItem(icon: Icons.people_alt, text: "Collaboration: Built strong interdisciplinary partnerships with developers, scientists, and business teams to drive project success.", width: isMobile ? double.infinity : 300),
            SkillItem(icon: Icons.psychology, text: "Emotional Intelligence: Leveraged empathy and interpersonal awareness to build trust and rapport in professional and academic settings.", width: isMobile ? double.infinity : 300),
          ],
        );
      },
    );
  }
}

class SkillItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final double width;

  const SkillItem({super.key, required this.icon, required this.text, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.blue[700]),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class ProfessionalExperienceContent extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;

  const ProfessionalExperienceContent({super.key, required this.primaryColor, required this.secondaryColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExperienceCard(
          company: "Entsika Consulting Services, Johannesburg",
          role: "Data Scientist",
          period: "January 2021 – December 2024",
          responsibilities: [
            _buildResponsibilityItem(FontAwesomeIcons.users, "Led vibrant Data Analytics teams to deliver 20+ reports and dashboards for finance, healthcare, retail, and manufacturing using Python, SQL, Power BI, Tableau, and Spark."),
            _buildResponsibilityItem(FontAwesomeIcons.brain, "Built ML models with scikit-learn, TensorFlow, and PyTorch for predictive analytics in inventory, churn, and risk assessment."),
            _buildResponsibilityItem(FontAwesomeIcons.chartLine, "Crafted Power BI dashboards with Power Query, DAX, and MDAX, producing a 76-page Market Research Report for a R2B tender."),
            _buildResponsibilityItem(FontAwesomeIcons.cogs, "Applied analytical skills to develop and deploy data models, evaluating and improving existing models to create solutions."),
            _buildResponsibilityItem(FontAwesomeIcons.search, "Reviewed business areas to strengthen analytics, enabling strategic planning and supporting decision-making processes with solid data."),
            _buildResponsibilityItem(FontAwesomeIcons.tachometerAlt, "Developed and refined reporting tools and interfaces for different KPIs to increase transparency and boost staff performance."),
            _buildResponsibilityItem(FontAwesomeIcons.lightbulb, "Offered value-added insights and recommendations to business leaders using specialized techniques, helping businesses adapt to market changes."),
            _buildResponsibilityItem(FontAwesomeIcons.projectDiagram, "Applied custom models and algorithms to data sets to evaluate and solve diverse company problems."),
            _buildResponsibilityItem(FontAwesomeIcons.filter, "Filtered and assessed data from different views, searching for patterns indicating problems or opportunities and communicated results to help drive business growth."),
            _buildResponsibilityItem(FontAwesomeIcons.graduationCap, "Facilitated and executed strategies to educate customers on data analysis and interpretation."),
            _buildResponsibilityItem(FontAwesomeIcons.database, "Identified valuable data sources and used process automation tools to automate collection processes and maintain accuracy of collected information."),
            _buildResponsibilityItem(FontAwesomeIcons.desktop, "Collected and validated analytics data from various sources, creating processes and tools for monitoring and analyzing model performance and data accuracy."),
            _buildResponsibilityItem(FontAwesomeIcons.chartPie, "Applied advanced analytical approaches and algorithms to evaluate business success factors, impact on company profits and growth potential."),
            _buildResponsibilityItem(FontAwesomeIcons.eye, "Developed Power BI visualizations and dynamic and static reports for diverse projects in Internal Auditing, SCM, Disaster Management, KPI Tracking."),
            _buildResponsibilityItem(FontAwesomeIcons.handsHelping, "Mentored and led junior analytics team members, fostering growth in data modeling and BI tools."),
            _buildResponsibilityItem(FontAwesomeIcons.chalkboardTeacher, "Presented reports to stakeholders using data visualization outputs, proposing solutions and strategies to drive business change and solve problems."),
            _buildResponsibilityItem(FontAwesomeIcons.robot, "Automated workflows with Power Automate, Power Apps, and Python (Pandas, NumPy, openpyxl), integrating Supabase, SAP, and Hadoop."),
            _buildResponsibilityItem(FontAwesomeIcons.shieldAlt, "Applied CAATs and auditing methodologies for GDPR/POPIA compliance."),
            _buildResponsibilityItem(FontAwesomeIcons.globe, "Engaged in global seminars on Data Analytics and Business Intelligence."),
          ],
          projects: [
            LinkProject("Transnet Engineering Inventory Optimisation (2022)", "https://link-to-project1.com"),
            LinkProject("Security of Supply – Department of Correctional Services (2024)", "https://link-to-project2.com"),
            LinkProject("Lease Review – Carlton Centre, Transnet Properties (2023)", "https://link-to-project3.com"),
            LinkProject("KwaZulu-Natal Floods Disaster Management (2023)", "https://link-to-project4.com"),
          ],
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
        ),
        ExperienceCard(
          company: "NNT Strategic Solutions, Pretoria",
          role: "Software Developer",
          period: "January 2025 – Present",
          responsibilities: [
            _buildResponsibilityItem(FontAwesomeIcons.laptopCode, "Led teams to build AI-powered platforms and mobile apps with Django, Flask, FastAPI, Flutter, and Power BI."),
            _buildResponsibilityItem(FontAwesomeIcons.palette, "Designed responsive interfaces with HTML5, CSS3, JavaScript, TypeScript, React, Angular, and Vue.js for user engagement."),
            _buildResponsibilityItem(FontAwesomeIcons.server, "Built scalable and secure Django applications with RESTful APIs, GraphQL, and JWT authentication."),
            _buildResponsibilityItem(FontAwesomeIcons.code, "Developed custom Django models, views, templates, and forms to meet complex business requirements."),
            _buildResponsibilityItem(FontAwesomeIcons.database, "Implemented Django ORM for efficient database operations and query optimization."),
            _buildResponsibilityItem(FontAwesomeIcons.userShield, "Utilized Django's built-in authentication and authorization system for secure user management."),
            _buildResponsibilityItem(FontAwesomeIcons.box, "Integrated third-party Django packages and libraries (e.g., Django REST framework, Django Channels) to enhance functionality."),
            _buildResponsibilityItem(FontAwesomeIcons.projectDiagram, "Designed and implemented database schema and migrations using Django's migration framework."),
            _buildResponsibilityItem(FontAwesomeIcons.plug, "Built and consumed APIs using Django REST framework, ensuring API security and performance."),
            _buildResponsibilityItem(FontAwesomeIcons.bolt, "Implemented caching mechanisms (e.g., Redis, Memcached) to improve application performance."),
            _buildResponsibilityItem(FontAwesomeIcons.tasks, "Utilized Celery and RabbitMQ for asynchronous task processing and job queuing."),
            _buildResponsibilityItem(FontAwesomeIcons.comments, "Implemented real-time functionality using Django Channels and WebSockets."),
            _buildResponsibilityItem(FontAwesomeIcons.flask, "Developed Flask applications with RESTful APIs, JWT authentication, and database integration (e.g., SQLAlchemy, Flask-SQLAlchemy)."),
            _buildResponsibilityItem(FontAwesomeIcons.docker, "Built microservices with Flask and containerization using Docker."),
            _buildResponsibilityItem(FontAwesomeIcons.js, "Implemented frontend functionality using JavaScript, TypeScript, and frameworks like React, Angular, and Vue.js."),
            _buildResponsibilityItem(FontAwesomeIcons.toolbox, "Utilized JavaScript libraries like jQuery, Lodash, and Moment.js to enhance frontend functionality."),
            _buildResponsibilityItem(FontAwesomeIcons.mobile, "Implemented responsive design using CSS3, Sass, and Less."),
            _buildResponsibilityItem(FontAwesomeIcons.vial, "Ensured code quality and best practices through code reviews, testing (unit, integration, and functional tests), and continuous integration."),
            _buildResponsibilityItem(FontAwesomeIcons.cloud, "Deployed applications on cloud platforms (e.g., AWS, Google Cloud, Azure) and containerization using Docker."),
            _buildResponsibilityItem(FontAwesomeIcons.cog, "Configured and managed applications using environment variables and configuration files."),
            _buildResponsibilityItem(FontAwesomeIcons.chartLine, "Implemented monitoring and logging tools (e.g., Prometheus, Grafana, ELK Stack) to track application performance and errors."),
            _buildResponsibilityItem(FontAwesomeIcons.robot, "Built ML models with scikit-learn, TensorFlow, PyTorch, and AI tools (Lovable AI, Grok) for predictive analytics and NLP."),
            _buildResponsibilityItem(FontAwesomeIcons.fire, "Integrated Supabase, Firebase, and Power Automate for real-time workflows."),
            _buildResponsibilityItem(FontAwesomeIcons.handsHelping, "Mentored developers, aligning solutions with business goals via stakeholder collaboration."),
            _buildResponsibilityItem(FontAwesomeIcons.shieldAlt, "Applied Agile and GDPR/POPIA compliance for secure, innovative solutions."),
          ],
          projects: [
            LinkProject("Performa360 Platform (2024–2025)", ""),
            LinkProject("Customer Churn Prediction System (2025)", ""),
            LinkProject("AfroDating Mobile Application (2024–Present)", ""),
            LinkProject("AI-Powered Web Platform (WebCraft, 2025)", ""),
            LinkProject("AuPair Connect Platform (2025)", ""),
            LinkProject("LandLink Platform (2025)", ""),
            LinkProject("SurroLink Surrogacy Platform (2025)", ""),
          ],
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
        ),
        ExperienceCard(
          company: "Lucient Engineering & Construction, Witbank",
          role: "Data Scientist",
          period: "January 2015 – December 2020",
          responsibilities: [
            _buildResponsibilityItem(FontAwesomeIcons.database, "Extracted, cleaned, and consolidated operational data from ERP systems, maintenance logs, SCADA systems, and equipment sensors for dragliners and other mining machinery."),
            _buildResponsibilityItem(FontAwesomeIcons.brain, "Developed predictive maintenance models using ML and statistical methods to forecast equipment failures and reduce unplanned downtime."),
            _buildResponsibilityItem(FontAwesomeIcons.chartBar, "Monitored equipment KPIs including utilization, cycle times, and repair turnaround, identifying bottlenecks and operational inefficiencies."),
            _buildResponsibilityItem(FontAwesomeIcons.tools, "Analyzed historical shutdowns and maintenance schedules to optimize resource allocation and minimize operational downtime."),
            _buildResponsibilityItem(FontAwesomeIcons.table, "Built dashboards in Power BI and Tableau for real-time monitoring of equipment health, maintenance status, and project progress."),
            _buildResponsibilityItem(FontAwesomeIcons.wallet, "Evaluated maintenance costs, spare parts usage, and contractor performance to identify opportunities for cost optimization."),
            _buildResponsibilityItem(FontAwesomeIcons.users, "Collaborated with engineering, maintenance, and project teams to translate data insights into actionable recommendations for operational improvements."),
            _buildResponsibilityItem(FontAwesomeIcons.shieldAlt, "Monitored safety and compliance metrics, supporting risk mitigation and ensuring adherence to regulatory standards."),
            _buildResponsibilityItem(FontAwesomeIcons.search, "Performed exploratory data analysis (EDA) on sensor and operational data to identify trends, anomalies, and potential equipment issues."),
            _buildResponsibilityItem(FontAwesomeIcons.chalkboardTeacher, "Presented analytical findings to stakeholders through reports, dashboards, and data-driven storytelling to support decision-making."),
            _buildResponsibilityItem(FontAwesomeIcons.rocket, "Stayed current with industry trends, advanced analytics, and emerging AI/ML technologies to enhance mining operations and predictive capabilities."),
          ],
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
        ),
        ExperienceCard(
          company: "Dairiboard Limited, Harare, Zimbabwe",
          role: "Senior Microbiologist / Laboratory Analyst",
          period: "January 2005 – December 2014",
          responsibilities: [
            _buildResponsibilityItem(FontAwesomeIcons.vial, "Conducted lab tests on inbound, inline, and outbound dairy product samples, ensuring ISO-compliant safety and quality."),
            _buildResponsibilityItem(FontAwesomeIcons.chartLine, "Analyzed SAP QM (LIMS) data for crucial product safety and quality insights, identifying trends and areas for improvement."),
            _buildResponsibilityItem(FontAwesomeIcons.fileAlt, "Presented monthly stakeholder reports on production and quality metrics, highlighting key findings and recommendations."),
            _buildResponsibilityItem(FontAwesomeIcons.clipboardList, "Developed and updated ISO-aligned SOPs and experimental methodologies for laboratory analysis of dairy products."),
            _buildResponsibilityItem(FontAwesomeIcons.userTie, "Supervised and managed junior staff, conducting KPI reviews, mentoring, and ensuring adherence to laboratory protocols."),
            _buildResponsibilityItem(FontAwesomeIcons.search, "Extracted, collated, validated, and analyzed production data for quality control, identifying opportunities for process improvement."),
            _buildResponsibilityItem(FontAwesomeIcons.clipboardCheck, "Participated in internal food safety and quality audits, ensuring compliance with regulatory requirements and company standards."),
            _buildResponsibilityItem(FontAwesomeIcons.award, "Ensured data met stringent quality control standards, flagging any issues and implementing corrective actions."),
            _buildResponsibilityItem(FontAwesomeIcons.handsHelping, "Collaborated with production, supply chain, and regulatory affairs teams to align laboratory tests and data initiatives with organizational goals."),
            _buildResponsibilityItem(FontAwesomeIcons.microscope, "Conducted microbiological testing and analysis of dairy products, including pathogen detection and enumeration."),
            _buildResponsibilityItem(FontAwesomeIcons.flask, "Performed biochemical testing and analysis of dairy products, including compositional analysis and quality control."),
            _buildResponsibilityItem(FontAwesomeIcons.lightbulb, "Developed and implemented new laboratory methods and techniques to improve testing efficiency and accuracy."),
            _buildResponsibilityItem(FontAwesomeIcons.tools, "Maintained laboratory equipment and ensured calibration and validation of instruments."),
            _buildResponsibilityItem(FontAwesomeIcons.checkDouble, "Participated in method validation and verification studies to ensure accuracy and precision of laboratory results."),
            _buildResponsibilityItem(FontAwesomeIcons.userShield, "Collaborated with quality assurance team to develop and implement quality control measures and ensure compliance with regulatory requirements."),
            _buildResponsibilityItem(FontAwesomeIcons.chartBar, "Designed and developed interactive Power BI dashboards to visualize laboratory results, enabling real-time monitoring of dairy product safety and quality trends."),
          ],
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
        ),
      ],
    );
  }

  Widget _buildResponsibilityItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: secondaryColor),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12, height: 1.4))),
        ],
      ),
    );
  }
}

class ExperienceCard extends StatelessWidget {
  final String company;
  final String role;
  final String period;
  final List<Widget> responsibilities;
  final List<LinkProject>? projects;
  final Color primaryColor;
  final Color secondaryColor;

  const ExperienceCard({super.key, required this.company, required this.role, required this.period, required this.responsibilities, this.projects, required this.primaryColor, required this.secondaryColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(company, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: primaryColor)),
            const SizedBox(height: 4),
            Text("$role • $period", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
            const SizedBox(height: 12),
            Text("Responsibilities:", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            ...responsibilities,
            if (projects != null && projects!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text("Key Projects:", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              BulletList(projects!.map((p) => "${p.name}: ${p.url}").toList(), primaryColor: primaryColor),
            ],
          ],
        ),
      ),
    );
  }
}

class BulletList extends StatelessWidget {
  final List<String> items;
  final Color primaryColor;

  const BulletList(this.items, {super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.circle, size: 8, color: primaryColor),
            const SizedBox(width: 8),
            Expanded(child: Text(item, style: Theme.of(context).textTheme.bodyMedium)),
          ],
        ),
      )).toList(),
    );
  }
}

class EducationContent extends StatelessWidget {
  final Color primaryColor;

  const EducationContent({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EducationTile(
          degree: "B.Sc. (Hons)",
          institution: "Midlands State University, Zimbabwe",
          period: "2000 – 2004; 2013 (Honours)",
          details: "Completed 36 modules covering data analysis, scientific methodologies, laboratory management, and microbiology research.\n\n📌 Key modules with strong relevance to my current career as a Software Engineer & Data Scientist:\n• Computers and Computer Architecture\n• Information Systems 1 & 2\n• BioMathematics 1 & 3\n• Applied Statistics 1 & 2\n• Linear Mathematics\n• Analytical Chemistry\n• Calculus\n• Logic\n• Honours Dissertation (Applied Research)",
          primaryColor: primaryColor,
          launchURL: "https://www.msu.ac.zw",
        ),
        EducationTile(
          degree: "A-Levels (Sciences)",
          institution: "Guinea Fowl High School, Zimbabwe",
          period: "1997 – 1998",
          details: "Completed A-Level exams under the Cambridge International Examination system, demonstrating advanced proficiency in core science subjects.\n\nSubjects included: Mathematics, Chemistry, Biology",
          primaryColor: primaryColor,
          schoolURL: "https://www.guineafowlhigh.ac.zw",
          systemURL: "https://www.cambridgeinternational.org",
        ),
        EducationTile(
          degree: "High School Diploma (GCSEs – Ordinary Level)",
          institution: "Mutare Boys High School, Zimbabwe",
          period: "1993 – 1996",
          details: "Completed the Cambridge Syllabi under the Cambridge International Examination system, demonstrating proficiency across a broad range of subjects.\n\nSubjects included: Mathematics, Biology, Physical Sciences, Geography, Metalwork, History, Technical Graphics, French, English Language, and Literature in English.",
          primaryColor: primaryColor,
          schoolURL: "https://www.mutareboyshighschool.ac.zw",
          systemURL: "https://www.cambridgeinternational.org",
        ),
      ],
    );
  }
}

class CertificationsContent extends StatelessWidget {
  final Color primaryColor;
  final Future<void> Function(String) launchURL;

  const CertificationsContent({super.key, required this.primaryColor, required this.launchURL});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CertificationTile(
          title: "IBM Data Science Professional Certificate",
          issuer: "Coursera",
          period: "2021 – 2022",
          courses: [
            CourseItem("📊 What is Data Science?", null),
            CourseItem("🛠️ Tools for Data Science",
                "https://coursera.org/verify/3HN9VHTL9NAV"),
            CourseItem("📋 Data Science Methodology", null),
            CourseItem("🐍 Python for Data Science, AI & Development",
                "https://coursera.org/verify/LXAXG7URCGJJ"),
            CourseItem("💻 Python Project for Data Science",
                "https://coursera.org/verify/LWRHHEGETXSL"),
            CourseItem("🗄️ Databases and SQL for Data Science with Python",
                "https://coursera.org/verify/7PRS4MJPPBZK"),
            CourseItem("📈 Data Analysis with Python", null),
            CourseItem("📊 Data Visualization with Python", null),
            CourseItem("🤖 Machine Learning with Python", null),
            CourseItem("🎓 Applied Data Science Capstone", null),
            CourseItem(
                "✨ Generative AI: Elevate Your Data Science Career", null),
            CourseItem(
                "💼 Data Scientist Career Guide and Interview Preparation",
                null),
          ],
          primaryColor: primaryColor,
          launchURL: launchURL,
          verification:
              "https://coursera.org/verify/specialization/GUSLY3ETUER4",
        ),
        const SizedBox(height: 20),
        CertificationTile(
          title: "Python 3 Programming Specialization",
          issuer: "University of Michigan, Coursera",
          period: "2021 – 2022",
          courses: [
            CourseItem(
                "🔤 Python Basics", "https://coursera.org/verify/8236JMR5K4RW"),
            CourseItem("📥 Data Collection and Processing with Python",
                "https://coursera.org/verify/UH9C2YE7XGFQ"),
            CourseItem("📚 Python Functions, Files, and Dictionaries",
                "https://coursera.org/verify/F6N75RWRYVWM"),
            CourseItem("🏛️ Python Classes and Inheritance",
                "https://coursera.org/verify/YAQ2Z8TYH44Y"),
            CourseItem(
                "🖼️ Python Project: Software Engineering and Image Manipulation",
                "https://coursera.org/verify/XC9QU5PUYSSF"),
          ],
          primaryColor: primaryColor,
          launchURL: launchURL,
          verification:
              "https://www.coursera.org/account/accomplishments/specialization/certificate/EA8H8GA6YGXQ",
        ),
        const SizedBox(height: 20),
        CertificationTile(
          title: "Data Science Fundamentals with Python and SQL",
          issuer: "IBM, Coursera",
          period: "2021 – 2022",
          courses: [
            CourseItem("🛠️ Tools for Data Science",
                "https://coursera.org/verify/3HN9VHTL9NAV"),
            CourseItem("🐍 Python for Data Science, AI & Development",
                "https://coursera.org/verify/LXAXG7URCGJJ"),
            CourseItem("💻 Python Project for Data Science",
                "https://coursera.org/verify/LWRHHEGETXSL"),
            CourseItem("📊 Statistics for Data Science with Python",
                "https://coursera.org/verify/W3A8849BKRNE"),
            CourseItem("🗄️ Databases and SQL for Data Science with Python",
                "https://coursera.org/verify/7PRS4MJPPBZK"),
          ],
          primaryColor: primaryColor,
          launchURL: launchURL,
          verification:
              "https://coursera.org/verify/specialization/GUSLY3ETUER4",
        ),
      ],
    );
  }
}

class CertificationTile extends StatelessWidget {
  final String title;
  final String issuer;
  final String period;
  final List<CourseItem> courses;
  final String? verification;
  final Color primaryColor;
  final Future<void> Function(String) launchURL;

  const CertificationTile({super.key, required this.title, required this.issuer, required this.period, required this.courses, this.verification, required this.primaryColor, required this.launchURL});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white, Colors.grey.shade50]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: primaryColor.withOpacity(0.3)),
                  ),
                  child: Icon(Icons.verified, color: primaryColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: primaryColor)),
                      const SizedBox(height: 4),
                      Text(issuer, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 2),
                      Text(period, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(height: 1, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text("Courses (${courses.length}):", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
            const SizedBox(height: 8),
            ...courses.map((course) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 24, child: Text(course.title.substring(0, 2), style: const TextStyle(fontSize: 14))),
                  const SizedBox(width: 8),
                  Expanded(
                    child: course.verificationUrl != null ? GestureDetector(
                      onTap: () => launchURL(course.verificationUrl!),
                      child: Row(
                        children: [
                          Expanded(child: Text(course.title.substring(2), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blue.shade700, decoration: TextDecoration.underline, fontWeight: FontWeight.w500))),
                          Icon(Icons.launch, size: 16, color: Colors.blue.shade700),
                        ],
                      ),
                    ) : Text(course.title.substring(2), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade800)),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 12),
            if (verification != null) ...[
              Divider(height: 1, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: primaryColor.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.verified_user, color: primaryColor, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Full Certification Verification", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: primaryColor)),
                          GestureDetector(
                            onTap: () => launchURL(verification!),
                            child: Text(verification!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.blue.shade700, decoration: TextDecoration.underline), overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward, color: primaryColor, size: 20),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


class AccomplishmentsContent extends StatelessWidget {
  final Color primaryColor;

  const AccomplishmentsContent({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return AccomplishmentList([
      AccomplishmentItem(
        icon: FontAwesomeIcons.chartLine,
        text: "Developed and implemented a machine learning solution for a client in the freight and rail sector, optimizing a R2.4B inventory by reallocating underutilized materials to high-consumption areas. Integrated with SAP forecasting tables to predict future usage, helping avoid approximately R500 million in procurement costs.",
      ),
      AccomplishmentItem(
        icon: FontAwesomeIcons.searchDollar,
        text: "Uncovered anomalies in Carlton Centre lease data, generating insights that led to significant cost savings through divestment from a loss-making asset.",
      ),
      AccomplishmentItem(
        icon: FontAwesomeIcons.handsHelping,
        text: "Contributed to KwaZulu-Natal Floods Task Team, shaping National Disaster Response Strategy.",
      ),
      AccomplishmentItem(
        icon: FontAwesomeIcons.chartBar,
        text: "Developed 50+ Power BI dashboards for auditing, supply chain, and KPI tracking.",
      ),
      AccomplishmentItem(
        icon: FontAwesomeIcons.award,
        text: "Supported implementation of ISO 22000 and ISO 9001 standards in dairy processing, ensuring food safety and quality compliance.",
      ),
      AccomplishmentItem(
        icon: FontAwesomeIcons.graduationCap,
        text: "Contributed to laboratory accreditation efforts under ISO/IEC 17025 and ISO 14001, strengthening credibility and sustainability initiatives.",
      ),
      AccomplishmentItem(
        icon: FontAwesomeIcons.tools,
        text: "Developed predictive maintenance models for dragliners and mining equipment, reducing unplanned downtime and improving overall equipment efficiency.",
      ),
      AccomplishmentItem(
        icon: FontAwesomeIcons.database,
        text: "Built Power BI dashboards and operational reports integrating ERP, SCADA, and sensor data, enabling the engineering team to optimize shutdown schedules, resource allocation, and maintenance planning.",
      ),
    ], primaryColor: primaryColor);
  }
}

class AccomplishmentList extends StatelessWidget {
  final List<AccomplishmentItem> items;
  final Color primaryColor;

  const AccomplishmentList(this.items, {super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, size: 18, color: primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(item.text, style: Theme.of(context).textTheme.bodyMedium)),
            ],
          ),
        )).toList(),
      ),
    );
  }
}

class ReferencesContent extends StatelessWidget {
  final Color primaryColor;

  const ReferencesContent({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReferenceTile(
          name: "Seiphati Nkuna",
          company: "T3 Telecoms SA (Pty) Ltd, Johannesburg, South Africa",
          position: "Head of BI and Sales Analyst",
          contact: "info@t3telecoms.co.za, +27 794 972 305",
          primaryColor: primaryColor,
        ),
        ReferenceTile(
          name: "Francois Nel",
          company: "Buesquare Brokers (Pty) Ltd, Centurion, South Africa",
          position: "Director",
          contact: "blsq.co.za, +27 826 510 017",
          primaryColor: primaryColor,
        ),
        ReferenceTile(
          name: "Dr Christopher Phiri",
          company: "CMPH Group of Companies Pty Ltd, Johannesburg South Africa",
          position: "Chief Executive Officer",
          contact: "+27603000890",
          primaryColor: primaryColor,
        ),
      ],
    );
  }
}

class ReferenceTile extends StatelessWidget {
  final String name;
  final String company;
  final String position;
  final String contact;
  final Color primaryColor;

  const ReferenceTile({super.key, required this.name, required this.company, required this.position, required this.contact, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Icon(Icons.person, color: primaryColor),
        title: Text(name, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(company, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
            Text(position, style: Theme.of(context).textTheme.bodyMedium),
            Text(contact, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}

class ProjectsContent extends StatelessWidget {
  final Function(Project) onProjectTap;
  final Color primaryColor;
  final Color secondaryColor;

  const ProjectsContent({super.key, required this.onProjectTap, required this.primaryColor, required this.secondaryColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Text(
        "This portfolio presents recent projects (2022–2025) that reflect my expertise in Software Development, Data Science, and Analytics. These initiatives demonstrate effective stakeholder engagement and collaboration with clients, executives, and cross-functional teams to deliver innovative, data-driven solutions. Leveraging Advanced Analytics, Power BI, and cutting-edge AI technologies including Large Language Models (LLMs) and Retrieval-Augmented Generation (RAG), the projects enhance business operations and user experiences, providing actionable insights to support strategic decision-making.",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ),
    const SizedBox(height: 16),
    Text("Info-Tech Business Solutions (iTBS) and Entsika Consulting Projects", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 16, color: primaryColor)),
    const SizedBox(height: 12),
    ProjectGrid(
      onProjectTap: onProjectTap,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
    ),
      ],
    );
  }
}

class ProjectGrid extends StatelessWidget {
  final Function(Project) onProjectTap;
  final Color primaryColor;
  final Color secondaryColor;

  const ProjectGrid({super.key, required this.onProjectTap, required this.primaryColor, required this.secondaryColor});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final crossAxisCount = sizingInformation.isMobile ? 1 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
            mainAxisExtent: 280,
          ),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            return ProjectCard(
              project: projects[index],
              onTap: onProjectTap,
              primaryColor: primaryColor,
              secondaryColor: secondaryColor,
            );
          },
        );
      },
    );
  }
}

class ProjectCard extends StatelessWidget {
  final Project project;
  final Function(Project) onTap;
  final Color primaryColor;
  final Color secondaryColor;

  const ProjectCard({super.key, required this.project, required this.onTap, required this.primaryColor, required this.secondaryColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      child: InkWell(
        onTap: () => onTap(project),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                child: project.imagePath.isNotEmpty ? Image.asset(
                  project.imagePath,
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: secondaryColor.withOpacity(0.1),
                      child: Center(child: Icon(Icons.business_center, size: 40, color: primaryColor)),
                    );
                  },
                ) : Container(
                  color: secondaryColor.withOpacity(0.1),
                  child: Center(child: Icon(Icons.business_center, size: 40, color: primaryColor)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: primaryColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(project.description, maxLines: 3, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectDetailsModal extends StatelessWidget {
  final Project project;
  final Color primaryColor;
  final Color secondaryColor;

  const ProjectDetailsModal({super.key, required this.project, required this.primaryColor, required this.secondaryColor});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(child: Text(project.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: primaryColor, fontSize: 18))),
                  IconButton(icon: Icon(Icons.close, color: primaryColor), onPressed: () => Navigator.of(context).pop()),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: project.imagePath.isNotEmpty ? Image.asset(
                    project.imagePath,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: secondaryColor.withOpacity(0.1),
                        child: Center(child: Icon(Icons.business_center, size: 50, color: primaryColor)),
                      );
                    },
                  ) : Container(
                    color: secondaryColor.withOpacity(0.1),
                    child: Center(child: Icon(Icons.business_center, size: 50, color: primaryColor)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(project.description, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              Text("Role:", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 16, color: primaryColor)),
              const SizedBox(height: 8),
              Text(project.role, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              Text("Contributions:", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 16, color: primaryColor)),
              const SizedBox(height: 8),
              BulletList(project.contributions, primaryColor: primaryColor),
              const SizedBox(height: 12),
              Text("Outcomes:", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 16, color: primaryColor)),
              const SizedBox(height: 8),
              BulletList(project.outcomes, primaryColor: primaryColor),
            ],
          ),
        ),
      ),
    );
  }
}

class FullCVContent extends StatelessWidget {
  final Future<void> Function(String) launchURL;
  final Color primaryColor;
  final Color secondaryColor;

  const FullCVContent({super.key, required this.launchURL, required this.primaryColor, required this.secondaryColor});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(icon: Icons.person, title: "Professional Summary", primaryColor: primaryColor, secondaryColor: secondaryColor, child: Container(padding: const EdgeInsets.all(16), child: ProfessionalSummaryContent(primaryColor: primaryColor))),
          SectionHeader(icon: Icons.build, title: "Technical Skills", primaryColor: primaryColor, secondaryColor: secondaryColor, child: Container(padding: const EdgeInsets.all(16), child: TechnicalSkillsContent(primaryColor: primaryColor, secondaryColor: secondaryColor))),
          SectionHeader(icon: Icons.people, title: "Soft, Leadership, and Interpersonal Skills", primaryColor: primaryColor, secondaryColor: secondaryColor, child: Container(padding: const EdgeInsets.all(16), child: SoftSkillsContent(primaryColor: primaryColor))),
          SectionHeader(icon: Icons.work, title: "Professional Experience", primaryColor: primaryColor, secondaryColor: secondaryColor, child: Container(padding: const EdgeInsets.all(16), child: ProfessionalExperienceContent(primaryColor: primaryColor, secondaryColor: secondaryColor))),
          SectionHeader(icon: Icons.school, title: "Education", primaryColor: primaryColor, secondaryColor: secondaryColor, child: Container(padding: const EdgeInsets.all(16), child: EducationContent(primaryColor: primaryColor))),
          SectionHeader(icon: Icons.card_membership, title: "Certifications", primaryColor: primaryColor, secondaryColor: secondaryColor, child: Container(padding: const EdgeInsets.all(16), child: CertificationsContent(primaryColor: primaryColor, launchURL: launchURL))),
          SectionHeader(icon: Icons.emoji_events, title: "Accomplishments", primaryColor: primaryColor, secondaryColor: secondaryColor, child: Container(padding: const EdgeInsets.all(16), child: AccomplishmentsContent(primaryColor: primaryColor))),
          SectionHeader(icon: Icons.people_outline, title: "References", primaryColor: primaryColor, secondaryColor: secondaryColor, child: Container(padding: const EdgeInsets.all(16), child: ReferencesContent(primaryColor: primaryColor))),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color primaryColor;
  final Color secondaryColor;
  final Widget? child;

  const SectionHeader({super.key, required this.icon, required this.title, required this.primaryColor, required this.secondaryColor, this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [primaryColor, secondaryColor]),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
            ],
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}

const List<Project> projects = [
  Project(
    title: "Transnet Engineering Inventory Optimisation",
    description:
        "Led the development of a data-driven inventory optimization solution for Transnet, managing a R2.4B inventory to enhance supply chain efficiency and reduce costs.",
    role: "Data Scientist & Python Developer",
    contributions: [
      "Led vibrant Data Analytics team to deliver inventory optimization reports using Python, SQL, and Power BI.",
      "Built predictive models with scikit-learn and TensorFlow for inventory demand forecasting.",
      "Integrated SAP data with Python (Pandas, NumPy) and Power Automate for real-time analytics.",
      "Collaborated with stakeholders to align solutions with supply chain objectives."
    ],
    outcomes: [
      "Optimized R2.4B inventory, setting a national standard for efficiency.",
      "Reduced inventory costs by 15% through predictive analytics.",
      "Improved supply chain decision-making with actionable Power BI dashboards."
    ],
    imagePath: "assets/assets/TE.jpeg",
  ),
  Project(
    title: "Transnet Properties Integrated Leases Review",
    description:
        "The TP Integrated Leases Review system was developed to analyze, visualize, and optimize property occupancy statistics across multiple facilities and reporting periods. The platform consolidates lease data, occupancy rates, and tenant metrics into interactive dashboards that empower real estate teams to make informed, data-driven decisions.",
    role: "Power BI Developer & Data Analyst",
    contributions: [
      "Developed automated ETL scripts using Python and PostgreSQL to collect, clean, and consolidate leasing and occupancy data from multiple branches and property management systems.",
      "Built dynamic dashboards for occupancy tracking, lease renewal forecasting, and period-over-period comparisons, improving decision-making for property managers and finance teams.",
      "Integrated visualization layers using Plotly and Power BI for interactive insights into occupancy rates, vacant spaces, and utilization efficiency across portfolio segments.",
      "Implemented data validation pipelines to ensure accuracy of tenant records, lease terms, and occupancy calculations before generating analytics summaries.",
      "Created APIs and background jobs to sync lease records with accounting and facility management systems for end-to-end operational transparency.",
      "Collaborated with business stakeholders to define KPIs such as occupancy percentage, average lease duration, renewal rates, and revenue per square meter.",
      "Designed an intuitive filtering system that allows users to view occupancy statistics by branch, region, lease type, or specific reporting period.",
      "Enhanced performance through database indexing and optimized query aggregation, enabling faster report generation for high-volume datasets.",
      "Provided training materials and support for operational teams to interpret dashboard insights and leverage data for strategic space optimization."
    ],
    outcomes: [
      "Increased operational visibility by 45% through centralized reporting of occupancy and leasing metrics across all sites.",
      "Reduced manual report preparation time by 60% with automated data consolidation and visualization pipelines.",
      "Improved lease renewal forecasting accuracy by 30% through data-driven trend analysis and historical occupancy patterns.",
      "Enabled proactive management of underutilized properties, reducing vacancy duration and improving asset utilization.",
      "Supported data-driven executive decisions with real-time insights accessible across finance, operations, and property divisions."
    ],
    imagePath: "assets/assets/lease_agreement.jpeg",
  ),
  Project(
    title: "Performa360 Platform",
    description:
        "As a key contributor, I helped develop Performa360, a comprehensive performance management ecosystem that transforms strategic planning into executable results. The platform integrates goal cascading, performance evaluations, and talent development through intuitive applications, AI-powered chat support, and interactive visualization tools.",
    role: "Python Developer & Data Analyst",
    contributions: [
      "Collaborated with HR teams and executives to design user-friendly interfaces for strategic goal cascading, performance tracking, and training progress alignment.",
      "Developed an interactive Strategic Goal Metrics Map with hierarchical visualization, enabling organizations to transform strategic objectives into measurable KPIs, deliverables, and evidence-based outcomes.",
      "Implemented dynamic node-based architecture for visual goal mapping, allowing drag-and-drop creation of strategic goals with weighted importance, due dates, and team assignments.",
      "Partnered with cross-functional teams to integrate Power BI dashboards and real-time performance analytics, visualizing strategic alignment and execution progress.",
      "Engineered smart due date management systems with bulk scheduling capabilities and automated deadline tracking across multiple goal hierarchies.",
      "Designed team collaboration features including multi-employee assignment, goal inheritance, and role-based access controls for strategic planning vs. execution.",
      "Built API-driven data integration for automatic population of strategic goals, KPIs, and deliverables from existing enterprise systems.",
      "Engaged stakeholders to implement AI-driven chat features and personalized recommendations, providing real-time strategic guidance and support.",
      "Worked with IT teams to develop secure authentication systems and visual workflow management tools, ensuring safe access while maintaining intuitive user experiences."
    ],
    outcomes: [
      "Reduced performance review time by 30% through automated goal cascading and streamlined evaluation processes co-designed with stakeholders.",
      "Improved strategic alignment visibility by 40% with interactive goal mapping that shows how individual contributions support organizational objectives.",
      "Enhanced user engagement by 25% through intuitive visual interfaces and real-time progress tracking, informed by continuous user feedback.",
      "Accelerated strategic planning cycles by 35% through bulk operations, template reuse, and transversal/departmental goal synchronization.",
      "Empowered organizations with advanced analytics and Power BI integration, driving data-driven decision making through collaborative insights.",
      "Increased goal completion rates by 28% through clear accountability mapping and visual progress indicators across the 4-stage cascading framework."
    ],
    imagePath: "assets/assets/performa360.jpeg",
  ),
  Project(
    title: "AfroDating Mobile Application",
    description:
        "I contributed to AfroDating, a mobile app connecting people of African descent worldwide through location-based matching. By engaging with users and marketing teams, I ensured a culturally sensitive platform that enhances user connectivity and engagement.",
    role: "Mobile Developer & Data Analyst",
    contributions: [
      "Collaborated with user focus groups to develop responsive iOS and Android interfaces, ensuring seamless experiences.",
      "Worked with analytics teams to build Power BI dashboards, tracking engagement and performance metrics.",
      "Partnered with developers to integrate real-time chat and notification features, enhancing user connectivity."
    ],
    outcomes: [
      "Successfully launched on App Store and Google Play, achieving strong adoption through stakeholder-driven design.",
      "Increased user retention by 15% with culturally tailored features, informed by user feedback.",
      "Delivered actionable insights via Advanced Analytics, supporting platform growth through team collaboration."
    ],
    imagePath: "assets/assets/afro.jpeg",
  ),
  Project(
    title: "AI-Powered Web Platform (WebCraft)",
    description:
        "Developed a comprehensive web platform using AI technologies to streamline business processes and enhance user experiences.",
    role: "Full Stack Developer & Data Scientist",
    contributions: [
      "Designed and implemented responsive front-end interfaces using Flutter and React",
      "Developed RESTful APIs and backend services using Django and FastAPI",
      "Integrated AI capabilities for content generation and user recommendations",
      "Implemented real-time data processing and analytics features"
    ],
    outcomes: [
      "Reduced development time by 40% through reusable component architecture",
      "Improved user engagement by 35% with personalized content recommendations",
      "Achieved 99.9% uptime through robust cloud infrastructure and monitoring"
    ],
    imagePath: "assets/assets/webcraft.jpeg",
  ),
  Project(
    title: "AuPair Connect Platform",
    description:
        "Built a platform connecting families with qualified au pairs, featuring advanced matching algorithms and secure communication tools.",
    role: "Mobile & Web Developer",
    contributions: [
      "Developed cross-platform mobile applications using Flutter",
      "Implemented secure messaging and video call features",
      "Created matching algorithm based on family needs and au pair qualifications",
      "Integrated payment processing and background check services"
    ],
    outcomes: [
      "Successfully matched over 500 families with qualified au pairs",
      "Achieved 4.8/5 user satisfaction rating",
      "Reduced matching time from weeks to days through algorithmic optimization"
    ],
    imagePath: "assets/assets/aupair_connect.jpeg",
  ),
  Project(
    title: "LandLink Platform",
    description:
        "Developed a real estate platform connecting landowners with potential developers and investors, featuring advanced property search and analytics.",
    role: "Full Stack Developer & Data Analyst",
    contributions: [
      "Created property search with advanced filters and map integration",
      "Developed analytics dashboard for property valuation and market trends",
      "Implemented secure document sharing and electronic signature capabilities",
      "Built recommendation engine for matching properties with investor preferences"
    ],
    outcomes: [
      "Facilitated over R50M in property transactions",
      "Reduced property search time by 70% through intelligent filtering",
      "Provided data-driven insights for investment decisions"
    ],
    imagePath: "assets/assets/landlink.jpeg",
  ),
  Project(
    title: "SurroLink Surrogacy Platform",
    description:
        "Created a sensitive and secure platform connecting intended parents with surrogate mothers, providing support throughout the surrogacy journey.",
    role: "Full Stack Developer",
    contributions: [
      "Developed secure messaging and medical record sharing system",
      "Created matching algorithm based on medical compatibility and preferences",
      "Implemented calendar and scheduling system for medical appointments",
      "Built support community features with moderated forums"
    ],
    outcomes: [
      "Successfully facilitated over 100 surrogacy matches",
      "Maintained 100% data security and HIPAA compliance",
      "Received recognition from fertility clinics for improving the matching process"
    ],
    imagePath: "assets/assets/surrolink.jpeg",
  ),
];
