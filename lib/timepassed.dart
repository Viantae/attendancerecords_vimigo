
String time_passed(DateTime datetime, {bool full = true}) {
    DateTime now = DateTime.now();
    DateTime ago = datetime;
    Duration dur = now.difference(ago);
    int days = dur.inDays;
    int years = days ~/ 365;  //(days / 365).toInt()
    int months =  (days - (years * 365)) ~/ 30; //((days - (years * 365)) / 30).toInt()
    int weeks = (days - (years * 365 + months * 30)) ~/ 7; //((days - (years * 365 + months * 30)) / 7).toInt()
    int rdays = days - (years * 365 + months * 30 + weeks * 7).toInt();
    int hours = (dur.inHours % 24).toInt();
    int minutes = (dur.inMinutes % 60).toInt();
    int seconds = (dur.inSeconds % 60).toInt();
    var diff = {
          "d":rdays,
          "w":weeks,
          "m":months,
          "y":years,
          "s":seconds,
          "i":minutes,
          "h":hours
    };

    Map str = {
        'y':'year',
        'm':'month',
        'w':'week',
        'd':'day',
        'h':'hour',
        'i':'minute',
        's':'second',
    };

  

    //unit_key = 'y' for years , unit_name = 'year'

    //creates string description with the difference in time, the unit name, and have an 's if more than 1
    str.forEach((unit_key , unit_name){
        if (diff[unit_key]! > 0) {
            str[unit_key] = diff[unit_key].toString()  +  ' ' + unit_name.toString() +  (diff[unit_key]! > 1 ? 's' : '');
        } else {
            str[unit_key] = "";
        }
    });
    
    //remove empty string descriptions
    str.removeWhere((index, ele)=>ele == "");
    List<String> tlist = [];
    str.forEach((unit_key, unit_name){
      tlist.add(unit_name);
    });

    //display full time description if true
    if(full){
      return str.isNotEmpty?"${tlist.join(", ")} ago":"Just Now";
    }else{
      return str.isNotEmpty?"${tlist[0]} ago":"Just Now";
    }
}