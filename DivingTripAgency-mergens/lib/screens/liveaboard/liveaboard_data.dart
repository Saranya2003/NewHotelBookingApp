class LiveAboardData {
  final String image,
      name,
      description,
      price,
      start,
      end,
      location,
      total,
      type;
  final int id;

  LiveAboardData(
      {this.id,
      this.name,
      this.image,
      this.description,
      this.price,
      this.start,
      this.end,
      this.location,
      this.total,
      this.type});

  String getname() {
    return name;
  }
}

// Demo List of my works
List<LiveAboardData> LiveAboardDatas = [
  LiveAboardData(
      id: 1,
      name: 'Phuket101',
      start: '10/03/2022',
      end: '10/03/2022',
      location: 'Phuket',
      total: '24',
      type: 'Onshore',
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
      image: "assets/images/S__77242370.jpg",
      price: "100"),
  LiveAboardData(
      id: 2,
      name: 'Trat101',
      start: '15/03/2022',
      end: '29/03/2022',
      location: 'Trat',
      total: '25',
      type: 'Offshore',
      description: "jajjsja",
      image: "assets/images/S__77250562.jpg",
      price: "2000"),
  LiveAboardData(
      id: 3,
      name: 'Krabi103',
      start: '10/03/2022',
      end: '18/03/2022',
      location: 'Krabi',
      total: '20',
      type: 'Onshore',
      description: "jajsjjs",
      image: "assets/images/S__77250562.jpg",
      price: "3500"),
  LiveAboardData(
      id: 4,
      name: 'Rayoung102',
      start: '14/03/2022',
      end: '20/03/2022',
      location: 'Rayoung',
      total: '30',
      type: 'Onshore',
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
      image: "assets/images/S__83271689.jpg",
      price: "400"),
  LiveAboardData(
      id: 5,
      name: 'Phuket102',
      start: '17/03/2022',
      end: '25/03/2022',
      location: 'Phuket',
      total: '30',
      type: 'Offshore',
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
      image: "assets/images/S__83271689.jpg",
      price: "400"),
  LiveAboardData(
      id: 6,
      name: 'Phuket103',
      start: '20/03/2022',
      end: '30/03/2022',
      location: 'Phuket',
      total: '50',
      type: 'Onshore',
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
      image: "assets/images/S__83271689.jpg",
      price: "400"),
];
