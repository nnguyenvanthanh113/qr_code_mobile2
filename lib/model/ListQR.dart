class ListQR
{
  int _id;
  String qr_code;
  String Date;
  String Time;
  ListQR(this.qr_code, this.Date, this.Time);

  ListQR.withId(this._id, this.qr_code, this.Date, this.Time);

  int get id => _id;

  String get qrcode => qr_code;

  String get date => Date;

  String get time => Time;




  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['qr_code'] = qr_code;
    map['Date'] = Date;
    map['Time'] = Time;

    return map;
  }

  // Extract a Note object from a Map object
  ListQR.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this.qr_code = map['qr_code'];
    this.Date = map['Date'];
    this.Time = map['Time'];
  }


}