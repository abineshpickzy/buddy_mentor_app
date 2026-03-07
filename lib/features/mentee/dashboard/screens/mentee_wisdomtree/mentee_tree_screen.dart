import 'package:buddymentor/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class MenteeTreeScreen extends StatelessWidget {
  const MenteeTreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final treeData = getBackendSample();

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Wisdom Tree",
        subtitle: "Explore the Knowledge Hierarchy",
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: treeData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TreeNode(node: treeData[index], level: 0),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TreeNode extends StatefulWidget {
  final Map<String, dynamic> node;
  final int level;

  const TreeNode({super.key, required this.node, required this.level});

  @override
  State<TreeNode> createState() => _TreeNodeState();
}

class _TreeNodeState extends State<TreeNode>
    with SingleTickerProviderStateMixin {
  bool expanded = true;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    if (expanded) _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      expanded = !expanded;
      if (expanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final children = widget.node["children"] as List<dynamic>? ?? [];
    final locked = widget.node["locked"] ?? false;
    final hasChildren = children.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TREE ROW
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// INDENT ONLY
            SizedBox(width: widget.level * 24.0),

            /// NODE CONTENT
            Expanded(
              child: GestureDetector(
                onTap: hasChildren ? _toggleExpanded : null,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      /// Expand Arrow
                      if (hasChildren)
                        AnimatedRotation(
                          turns: expanded ? 0.25 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            Icons.chevron_right_rounded,
                            size: 20,
                            color: AppColors.primary,
                          ),
                        )
                      else
                        const SizedBox(width: 20),

                      const SizedBox(width: 8),

                      /// Status Icon
                      _buildStatusIcon(hasChildren, locked, !hasChildren),

                      const SizedBox(width: 12),

                      /// Title
                      Expanded(
                        child: Text(
                          widget.node["title"],
                          style: TextStyle(
                            fontSize: hasChildren ? 16 : 15,
                            fontWeight: hasChildren
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: locked
                                ? AppColors.textLight
                                : AppColors.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        /// CHILDREN (ANIMATED)
        AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            return ClipRect(
              child: Align(heightFactor: _expandAnimation.value, child: child),
            );
          },
          child: Column(
            children: children.map<Widget>((child) {
              return TreeNode(node: child, level: widget.level + 1);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIcon(bool hasChildren, bool locked, bool isLeaf) {
    if (locked) {
      return Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.lock_outline_rounded,
          size: 18,
          color: Colors.grey,
        ),
      );
    }

    if (hasChildren) {
      return Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.folder_outlined, size: 18, color: AppColors.primary),
      );
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.article_outlined, size: 18, color: Colors.green),
    );
  }
}

List<Map<String, dynamic>> getBackendSample() {
  return [
    {
      "title": "Engineering Fundamentals",
      "locked": false,
      "children": [
        {
          "title": "Mathematics Foundation",
          "locked": false,
          "children": [
            {"title": "Linear Algebra", "locked": false, "children": []},
            {"title": "Calculus & Analysis", "locked": false, "children": []},
            {
              "title": "Advanced Mathematics",
              "locked": true,
              "children": [
                {
                  "title": "Differential Equations",
                  "locked": true,
                  "children": [],
                },
                {"title": "Complex Analysis", "locked": true, "children": []},
              ],
            },
          ],
        },
        {
          "title": "Physics Principles",
          "locked": false,
          "children": [
            {"title": "Classical Mechanics", "locked": false, "children": []},
            {"title": "Thermodynamics", "locked": false, "children": []},
            {"title": "Quantum Physics", "locked": true, "children": []},
          ],
        },
      ],
    },
    {
      "title": "Software Development",
      "locked": false,
      "children": [
        {
          "title": "Programming Languages",
          "locked": false,
          "children": [
            {"title": "Python Basics", "locked": false, "children": []},
            {
              "title": "JavaScript Fundamentals",
              "locked": false,
              "children": [],
            },
            {"title": "Advanced Algorithms", "locked": true, "children": []},
          ],
        },
        {
          "title": "Web Development",
          "locked": true,
          "children": [
            {"title": "Frontend Frameworks", "locked": true, "children": []},
            {"title": "Backend Systems", "locked": true, "children": []},
          ],
        },
      ],
    },
  ];
}
