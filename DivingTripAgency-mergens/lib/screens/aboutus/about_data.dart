class AboutData {
  final String image, name, stdID;
  final int id;

  AboutData({this.id, this.image, this.name, this.stdID});
}

// Demo List of my works
List<AboutData> AboutDatas = [
  AboutData(
    id: 1,
    name: "Alex",
    // image: "assets/images/bum.jpg",
    stdID: "61090001"
  ),
  AboutData(
    id: 2,
    name: "Numchok",
    // image: "assets/images/byungchan.jpg",
    stdID: "61090017"
  ),
  AboutData(
    id: 3,
    name: "Oranich",
    // image: "assets/images/best.jpg",
    stdID: "61090018"
  ),
  AboutData(
    id: 4,
    name: "Pokin",
    // image: "assets/images/inhyuk.jpg",
    stdID: "61090050"
  ),
];