class InstallationData {
  int floodID;
  int pending;
  int done;

  InstallationData({
    required this.floodID,
    required this.pending,
    required this.done,
  });

  factory InstallationData.fromJson(Map<String, dynamic> json) {
    return InstallationData(
      floodID: json['floodID'] ?? 0,
      pending: json['pending'] ?? 0,
      done: json['done'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['floodID'] = this.floodID;
    data['pending'] = this.pending;
    data['done'] = this.done;
    return data;
  }
}
