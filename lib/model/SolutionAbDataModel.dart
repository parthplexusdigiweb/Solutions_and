class SolutionAbDataModel {
  var id;
  var label;
  var description;
  var notes;
  var provider;
  var inPlace;
  var priority;
  var attachment;
  bool confirmed;

  SolutionAbDataModel({
    required this.id,
    required this.label,
    required this.description,
    required this.notes,
    required this.provider,
    required this.inPlace,
    required this.priority,
    required this.attachment,
    this.confirmed = false,
  });
}