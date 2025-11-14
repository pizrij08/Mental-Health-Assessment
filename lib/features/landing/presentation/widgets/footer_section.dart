import 'package:flutter/material.dart';
import 'package:flutter_application_mhproj/design_system/components/section_container.dart';
import 'package:flutter_application_mhproj/design_system/tokens/color_tokens.dart';
import 'package:flutter_application_mhproj/design_system/tokens/typography.dart';

class MindWellFooter extends StatelessWidget {
  const MindWellFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return MindWellSection(
      backgroundColor: MindWellColors.darkGray,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              return Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment:
                    isWide ? CrossAxisAlignment.start : CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _FooterColumn(
                    title: 'MindWell',
                    links: const ['Our Philosophy', 'Press & Media', 'Careers'],
                  ),
                  _FooterColumn(
                    title: 'Programmes',
                    links: const ['Stress & Burnout', 'Anxiety & Mood', 'Mindfulness', 'Performance'],
                  ),
                  _FooterColumn(
                    title: 'Locations',
                    links: const ['The Lake House, Alps', 'The Coast, Sylt', 'The Urban Retreat, London'],
                  ),
                  _NewsletterBlock(),
                ],
              );
            },
          ),
          const SizedBox(height: 64),
          const Divider(color: Color(0xFF565F56)),
          const SizedBox(height: 32),
          Text(
            '© 2025 MindWell Clinic. All rights reserved.',
            textAlign: TextAlign.center,
            style: MindWellTypography.body(color: Colors.grey.shade400),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 18,
            alignment: WrapAlignment.center,
            children: [
              _FooterLink(label: 'Privacy Policy'),
              const _FooterSeparator(),
              _FooterLink(label: 'Legal Notice'),
              const _FooterSeparator(),
              _FooterLink(label: 'Sitemap'),
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  const _FooterColumn({required this.title, required this.links});

  final String title;
  final List<String> links;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: MindWellTypography.body(color: MindWellColors.lightGreen)
                  .copyWith(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 2),
            ),
            const SizedBox(height: 18),
            for (final link in links)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _FooterLink(label: link),
              ),
          ],
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: MindWellTypography.body(color: Colors.grey.shade400)
          .copyWith(decoration: TextDecoration.underline, decorationColor: Colors.transparent),
    );
  }
}

class _FooterSeparator extends StatelessWidget {
  const _FooterSeparator();

  @override
  Widget build(BuildContext context) {
    return Text('|', style: MindWellTypography.body(color: Colors.grey.shade600));
  }
}

class _NewsletterBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stay Connected',
              style: MindWellTypography.body(color: MindWellColors.lightGreen)
                  .copyWith(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 2),
            ),
            const SizedBox(height: 18),
            _NewsletterField(),
            const SizedBox(height: 18),
            Text('Tel: +1 800 555 1234',
                style: MindWellTypography.body(color: Colors.grey.shade300)),
            const SizedBox(height: 12),
            _FooterLink(label: 'info@mindwell.com'),
          ],
        ),
      ),
    );
  }
}

class _NewsletterField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          style: MindWellTypography.body(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF4A5449),
            hintText: 'Your Email Address',
            hintStyle: MindWellTypography.body(color: Colors.grey.shade400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4A5449)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: MindWellColors.lightGreen, width: 1.6),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: MindWellColors.darkGray,
            foregroundColor: MindWellColors.cream,
            side: const BorderSide(color: MindWellColors.lightGreen),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          child: Text(
            'Subscribe to Newsletter'.toUpperCase(),
            style: MindWellTypography.button(color: MindWellColors.cream).copyWith(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

