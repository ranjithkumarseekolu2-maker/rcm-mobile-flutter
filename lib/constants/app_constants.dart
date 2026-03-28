class AppConstants {
  //dev
  static const String baseUrl = "https://api.brickboss.app/";
  static const String referUrl = "https://brickboss.app/";
  static const String shareUrl = "https://brickboss.app/";
  static const String projectViewUrl = "https://brickboss.app/";
  //prod
  // static const String baseUrl =
  //     "https://api.realtor.works/"; //"https://api.realtor.works//";//stage1.realtor.works
  // static const String referUrl = "https://app.realtor.works/";
  // static const String shareUrl = "https://app.realtor.works/";
  // static const String projectViewUrl = "https://app.realtor.works/";
  // static const String imageBaseUrl = "https://api.realtor.works/";

  static const List categoriesList = [
    {'name': 'Vegetables', 'image': 'assets/images/vegetables.png'},
    {'name': 'Leafy Vegetables', 'image': 'assets/images/leafy.png'},
    {'name': 'Fruits', 'image': 'assets/images/fruits.png'}
  ];

  static int redAlertQty = 5;
  static int orangeAlertQty = 10;
  static int cartLimit = 20;
  static const List leadsList = ['Lead1', 'Lead2', 'Lead3'];

  static const List leadAge = [15, 30, 45, 60];

  static const List ordersStatusList = [
    {'label': 'All', 'key': 'All'},
    {'label': 'Placed', 'key': 'PLACED'},
    {'label': 'Delivered', 'key': 'DELIVERED'},
    {'label': 'Farm Cancelled', 'key': 'FARM_CANCELLED'},
    {'label': 'Cancelled', 'key': 'CUSTOMER_CANCELLED'},
    {'label': 'Shipped', 'key': 'SHIPPED'},
    {'label': 'Rejected', 'key': 'REJECTED'},
    {'label': 'Refunded', 'key': 'REFUNDED'}
  ];
  static const List quantityList = [
    {'label': '500ml', 'value': 500},
    {'label': '1ltr', 'value': 1},
    {'label': '2ltr', 'value': 2},
    {'label': '3ltr', 'value': 3},
    {'label': '4ltr', 'value': 4},
    {'label': '5ltr', 'value': 5},
  ];

  static const List monthsList = [
    {'id': 1, 'label': "January"},
    {'id': 2, 'label': "February"},
    {'id': 3, 'label': "March"},
    {'id': 4, 'label': "April"},
    {'id': 5, 'label': "May"},
    {'id': 6, 'label': "June"},
    {'id': 7, 'label': "July"},
    {'id': 8, 'label': "August"},
    {'id': 9, 'label': "September"},
    {'id': 10, 'label': "October"},
    {'id': 11, 'label': "November"},
    {'id': 12, 'label': "December"}
  ];
  static const List<String> statuses = [
    'Pre Qualify',
    'Qualify',
    'Schedule Site Visit',
    'Site Visit',
    'Negotiation In Progress',
    'Payment In Progress',
    'Agreement',
    'Closed Won',
    'Closed Lost',
  ];
  static const List<String> projects = [
    'Lake View Apartments',
    'Avenue Green',
    'Vasavi Skyla',
    'Hi-Rise Apartments',
  ];
  List projectsNamesList = [];
  static const List buildersList = [];
  List projectsIds = [];
  List leadActivityList = [
    '15',
    '30',
    '45',
    '60',
  ];

  static const List projectTypes = [
    {
      "label": 'Farm Houses',
      "value": 'Farm Houses',
    },
    {
      "label": 'Plotting',
      "value": 'Plotting',
    },
    {
      "label": 'Residentials',
      "value": 'Residential',
    },
    {
      "label": 'Commercial',
      "value": 'Commercial',
    },
    {
      "label": 'Farm Lands',
      "value": 'Farm Lands',
    },
    {
      "label": 'Independent House',
      "value": 'Independent House',
    },
    {
      "label": 'Others',
      "value": 'Others',
    },
  ];

  static const List transactionTypes = [
    {
      "label": 'New',
      "value": 'New',
    },
    {
      "label": 'Resale',
      "value": 'Resale',
    },
  ];
  static const List possesionStatus = [
    {
      "label": 'Ready To Move',
      "value": 'Ready To Move',
    },
    {
      "label": 'Under Construction',
      "value": 'Under Construction',
    },
  ];
  static const List constructionDone = [
    {
      "label": 'Yes',
      "value": 'Yes',
    },
    {
      "label": 'No',
      "value": 'No',
    },
  ];

  static const List furnishingStatus = [
    {
      "label": 'Furnished',
      "value": 'Furnished',
    },
    {
      "label": 'UnFurnished',
      "value": 'UnFurnished',
    },
    {
      "label": 'Semi Furnished',
      "value": 'Semi Furnished',
    },
  ];

  static const List registrationTypes = [
    {"label": 'Sole Proprietorship', "value": 'Sole Proprietorship'},
    {"label": 'Need Input', "value": 'Need Input'},
  ];

  static const List propertyTypes = [
    {"label": 'Residential', "value": 'Residential'},
    {"label": 'Commercial', "value": 'Commercial'},
  ];

  // const establishedYears = [];
  // const currentYear = new Date().getFullYear();
  // for (let year = 1970; year <= currentYear; year++) {
  //   establishedYears.push({ label: year, value: year });
  // }
}
