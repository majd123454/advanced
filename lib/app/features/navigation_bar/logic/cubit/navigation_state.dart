import 'package:equatable/equatable.dart';

abstract class NavigationState extends Equatable {}

class NavigationInitialState extends NavigationState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

// ignore: must_be_immutable
class ChangeSelectedIndex extends NavigationState {
  int selectedIndex = 0;
  ChangeSelectedIndex(this.selectedIndex);
  List<Object?> get props => [selectedIndex];
}
