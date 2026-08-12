sealed class FilterEVents{}

class FilterSelectEvent extends FilterEVents{
  int filterNumber;
  int selectedIndex;
  FilterSelectEvent({required this.filterNumber,required this.selectedIndex});
}