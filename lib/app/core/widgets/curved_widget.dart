import 'package:swb_advance/app/core/widgets/curverd_edges.dart';
import 'package:flutter/material.dart';

class CurvedWidget extends StatelessWidget {
  const CurvedWidget({super.key, this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return ClipPath(clipper: CurvedEdges(), child: child);
  }
}
