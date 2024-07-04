class EmailModel {
  String? date;
  List<ReportSentTo>? reportSentTo;
  List<ReportSentToCc>? reportSentToCc;

  EmailModel({this.date, this.reportSentTo, this.reportSentToCc});

  EmailModel.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    if (json['Report_sent_to'] != null) {
      reportSentTo = <ReportSentTo>[];
      json['Report_sent_to'].forEach((v) {
        reportSentTo!.add(new ReportSentTo.fromJson(v));
      });
    }
    if (json['Report_sent_to_cc'] != null) {
      reportSentToCc = <ReportSentToCc>[];
      json['Report_sent_to_cc'].forEach((v) {
        reportSentToCc!.add(new ReportSentToCc.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Date'] = this.date;
    if (this.reportSentTo != null) {
      data['Report_sent_to'] =
          this.reportSentTo!.map((v) => v.toJson()).toList();
    }
    if (this.reportSentToCc != null) {
      data['Report_sent_to_cc'] =
          this.reportSentToCc!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReportSentTo {
  String? name;
  String? email;

  ReportSentTo({this.name, this.email});

  ReportSentTo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    return data;
  }
}
class ReportSentToCc {
  String? name;
  String? email;

  ReportSentToCc({this.name, this.email});

  ReportSentToCc.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    return data;
  }
}
