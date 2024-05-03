class ChallengesModel {
  var id;
  var label;
  var description;
  var notes;
  var Source;
  var Status;
  var tags;
  var CreatedBy;
  var CreatedDate;
  var ModifiedBy;
  var ModifiedDate;
  var OriginalDescription;
  var Final_description;
  var Impact;
  var Category;
  var Keywords;
  var PotentialStrengths;
  var HiddenStrengths;
  var attachment_link;
  var attachment;
  bool isConfirmed; // Add a boolean for confirmation status
  bool isChecked; // Add a boolean for confirmation status

  // var attachments;
  // var provider;
  // var inPlace;
  // var priority;

  ChallengesModel({
    this.id,
    this.label,
    this.description,
    this.notes,
    this.Source,
    this.Status,
    this.tags,
    this.CreatedBy,
    this.CreatedDate,
    this.ModifiedBy,
    this.ModifiedDate,
    this.OriginalDescription,
    this.Final_description,
    this.Impact,
    this.Category,
    this.Keywords,
    this.PotentialStrengths,
    this.HiddenStrengths,
    this.attachment_link,
    this.attachment,
    this.isConfirmed = false, // Default to false for not confirmed
    this.isChecked = false, // Default to false for not confirmed
    // required this.attachments,
    // required this.provider,
    // required this.inPlace,
    // required this.priority,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'description': description,
      'notes': notes,
      'Source': Source,
      'Status': Status,
      'tags': tags,
      'CreatedBy': CreatedBy,
      'CreatedDate': CreatedDate,
      'ModifiedBy': ModifiedBy,
      'ModifiedDate': ModifiedDate,
      'OriginalDescription': OriginalDescription,
      'Final_description': Final_description,
      'Impact': Impact,
      'Category': Category,
      'Keywords': Keywords,
      'PotentialStrengths': PotentialStrengths,
      'HiddenStrengths': HiddenStrengths,
      'attachment_link': attachment_link,
      'attachment': attachment,
      'isConfirmed': isConfirmed,
      'isChecked': isChecked,
    };
  }
}