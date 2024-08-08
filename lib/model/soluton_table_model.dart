class SolutionModel {
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
  var attachment_link;
  var attachment;
  var InPlace;
  var Provider;
  var LinkedChallenges;
  var OSD;
  var Help,PositiveImpactstoEmployee,PositiveImpactstoOrganisation,RelatedSolutionsTags,SuggestedChallengesTags;

  bool isConfirmed; // Add a boolean for confirmation status

  // var attachments;
  // var provider;
  // var inPlace;
  // var priority;

  SolutionModel({
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
    this.attachment_link,
    this.attachment,
    this.Provider,
    this.InPlace,
    this.Help,
    this.PositiveImpactstoEmployee,
    this.PositiveImpactstoOrganisation,
    this.RelatedSolutionsTags,
    this.SuggestedChallengesTags,
    this.LinkedChallenges,
    this.OSD,

    this.isConfirmed = false, // Default to false for not confirmed
    // this.attachments,
    // required this.provider,
    // required this.inPlace,
    // required this.priority,
  });
}