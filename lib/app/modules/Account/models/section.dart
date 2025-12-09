
import 'package:tajer/app/modules/Account/models/section_item.dart';

class Section {
  final String title;
  final List<SectionItem> children;
  Section({required this.title, required this.children});
}