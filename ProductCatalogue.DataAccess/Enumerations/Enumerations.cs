using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ProductCatalogue.DataAccess.Enumerations
{
    public enum BusinessContactType
    {
        Tourism = 1,
        Research = 2
    }

    public enum ResearchClass
    {
        Apartment = 1,
        BedBreakfast = 2,
        BedBreakfastInn = 3,
        CottageCabin = 4,
        Hostel = 5,
        Hotel = 6,
        HuntingLodge = 7,
        Inn = 8,
        Motel = 9,
        Resort = 10,
        TouristHome = 11,
        University = 12,
        Seasonal = 50,
        ShortTerm = 51
    }
    
    public enum ResearchUnitType
    {
        Apartment = 1,
        BedBreakfast = 2,
        BedBreakfastInn = 3,
        Cabin = 4,
        CondoCottage = 5,
        Cottage = 6,
        DormStyle = 7,
        GuestRoom = 8,
        Hostel = 9,
        Hotel = 10,
        Inn = 11,
        Lodge = 12,
        MiniHome = 13,
        Motel = 14,
        Resort = 15,
        TouristHome = 16,
        VacationHome = 17,
        Seasonal = 50,
        ShortTerm = 51
    }

    public enum ResearchFormatType
    {
        Pdf = 1,
        Excel = 2
    }

    public enum ResearchReportType
    {
        AccOccupancyByProduct = 1,
        CampOccupancyByProduct = 2,
        AccOccupancyByGeography = 3,
        CampOccupancyByGeography = 4,
        AccNonReporting = 5,
        CampNonReporting = 6,
        AccConfidential = 7,
        CampConfidential = 8,
        AccVariance = 9,
        CampVariance = 10
    }

    public enum CoordinateEditChecks
    {
        CoordinatesConfirmedByOperator = 1351,
        CoordinatesConfirmedByStaff = 1352,
        CoordinatesMatch = 1353
    }

    public enum PrintGuideFormType
    {
        Application = 1,
        Confirmation = 2,
        ListingProof = 3
    }

    public enum PublishStatus
    {
        Published = 1,
        NotPublished = 2
    }

    public enum ProofDeliveryType
    {
        Email = 1,
        Fax = 2
    }
    
    public enum ContactType
    {
        Primary = 1,
        Secondary = 2
    }
    
    
    public enum AddressType
    {
        Civic = 1,
        Mailing = 2,
        OffSeason = 3
    }

    public enum TollFreeArea
    {
        Canada = 1,
        NorthAmerica = 2
    }

    public enum PhoneType
    {
        Primary = 1,
        Mobile = 2,
        Fax = 3,
        OffSeason = 4,
        Home = 5
    }

    public enum CancellationPolicy
    {
        NoCancellations = 1,
        Noon = 2,
        BookingSpecific = 3,
        HalfDay = 4,
        Day = 5,
        TwoDay = 6,
        ThreeDay = 7,
        FiveDay = 14,
        OneWeek = 8,
        TwoWeek = 9,
        FourWeek = 10,
        EightWeek = 11,
        TwelveWeek = 12,
        FourPm = 13
    }

    public enum CaaRatingType
    {
        BedAndBreakfast = 1,
        CabinCottage = 2,
        Condominium = 3,
        CountryInn = 4,
        Hotel = 5,
        Motel = 6,
        VacationRentalHouse = 7,
        Campground = 8
    }

    public enum CanadaSelectRatingType
    {
        BedAndBreakfast = 1,
        TouristHome = 2,
        BedAndBreakfastInn = 3,
        CottageVacationHome = 4,
        HotelMotel = 5,
        FishingHunting = 6,
        Inn = 7,
        Resort = 8,
        CampingFacilities = 9,
        CampingRecreation = 10,
        Apartment = 11,
        Suite = 12,
        University = 13,
        Hostel = 14
        //GuestHome = 11
    }

    public enum GuideSectionOutdoors
    {
        Beaches = 1,
        //BoatTours = 2,
        DogSledding = 3,
        DiveShops = 4,
        EquipmentRentals = 5,
        FishingGuides = 6,
        FishingStockedLakes = 7,
        Flying = 8,
        Geocaching = 30,
        Geology = 9,
        GolfCourses = 10,
        DrivingRanges = 11,
       // Hunting = 12,
        NationalParks = 14,
        NoveltyGolf = 31,
        //Outdoor = 13,
        ProvincialParks = 15,
        Photography = 16,
        RidingHayRides = 17,
        RiverRafting = 18,
        SailingInstruction = 19,
        SailingLearnToSail = 20,
        SailingMarinas = 21,
        SkiingCrossCountry = 22,
        SkiingDownhill = 23,
        AirAdventure = 24,
        SleighRides = 25,
        Snowmobiling = 26,
        Snowshoeing = 27,
        Surfing = 28,
        WalkingHikingTrails = 29,
        Ziplining = 32
    }

    public enum GuideSectionTourOps
    {
        Sightseeing = 50,
        MultiDay = 51,
        BoatToursCharters = 52,
        MultiactivityAdventure = 53,
        NatureWildlife = 54,
        OutdoorAdventure = 55,
        StepOnGuide = 56,
        Walking = 57
    }


    public enum PeriodOfOperationType
    {
        AllYear = 1,
        Seasonal = 2,
        DateRange = 3
    }

    public enum ProductDescriptionType
    {
        Alpha = 1,
        Beta = 2,
        Gamma = 3,
        Delta = 4
    }

    public enum UrlType
    {
        Facebook = 1,
        Flickr = 2,
        General = 3,
        NearbyLocation = 4,
        TripAdvisor = 5,
        Twitter = 6,
        YouTube = 7,
        YouTubeChannel = 8,
        YouTubePlaylist = 9,
        BookingDotCom = 10,
        Pinterest = 11,
        Instragram = 12
    }

    public enum MediaLanguage
    {
        English = 1,
        French = 2,
        Bilingual = 3
    }

    public enum MediaType
    {
        SummaryThumbnail = 1,
        PhotoViewer = 2,
        Brochure = 3,
        Advertisement = 4
    }

    
    public enum ProductField
    {
        WebDateDescription = 1,
        WebRateDescription = 2,
        WebDescription = 3,
        WebKeywords = 4,
        WebDirections = 5,
        PrintDateDescription = 6,
        PrintRateDescription = 7,
        PrintDescription = 8,
        PrintUnitDescription = 9,
        PrintDirections = 10,
        MediaCaption = 11,
        ExternalLinkTitle = 12,
        ExternalLinkDescription = 13,
        WebCancellationPolicy = 14,
        SupplementalDescription = 15,
        MediaTitle = 16
    }

    public enum ProductFieldType
    {
        Web = 1,
        Print = 2
    }
        
    public enum ProductType
    {
        Accommodation = 1,
        Attraction = 2,
        Campground = 3,
        FineArts = 4,
        Outdoors = 5,
        TourOps = 6,
        Restaurants = 7,
        Transportation = 8,
        Experience = 9,
        FestivalsEvents = 10,
        Packages = 11,
        Archive = 12,
        Trails = 13
    }

    public enum RateType
    {
        Stc = 1,
        Gtd = 2
    }

    public enum RatePeriod
    {
        Daily = 1,
        Weekly = 2,
        Monthly = 3
    }

   

    public enum VersionHistoryType
    {
        Product = 1,
        Url = 2,
        Media = 3,
        GuideDescription = 4
    }

    public enum Action
    {
        Add = 1,
        Edit = 2,
        Delete = 3
    }



    public enum PaymentType
    {
        AmericanExpress = 1,
        DinersClub = 2,
        Discover = 3,
        Mastercard = 4,
        Visa = 5,
        PayPal = 6,
        CashOnly = 7,
        TravellersCheques = 8,
        DebitCard = 9,
        Jcb = 10
    }

    public enum OwnershipType
    {
        Public = 1,
        PrivateNonProfit = 2,
        PrivateForProfit = 3
    }

    public enum CapacityType
    {
        Unlimited = 1,
        Small = 2,
        Medium = 3,
        Large = 4,
        Seasonal = 5
    }

    public enum SustainabilityType
    {
        SelfSupporting = 1,
        PeriodicPublicFunding = 2,
        OngoingPublicFunding = 3,
        PubliclyOperated = 4
    }

    public enum Region
    {
        BrasDor = 1,
        CabotTrail = 2,
        CeilidhTrail = 3,
        FleurDeLis = 4,
        EasternShore = 5,
        FundyShore = 6,
        HalifaxMetro = 7,
        Northumberland = 8,
        SouthShore = 9,
        Yarmouth = 10
    }
    

    public enum AttributeGroup
    {
        AccommodationAmenity = 1,
        AccommodationService = 2,
        AccommodationType = 3,
        Activity = 4,
        ApprovedBy = 5,
        AreaOfInterest = 6,
        ArtType = 7,
        CampgroundAmenity = 8,
        CoreExperience = 9,
        CulturalHeritage = 10,
        Feature = 11,
        GovernmentLevel = 12,
//        GovernmentProgram = 13,
        Medium = 14,
        Membership = 15,
        PetsPolicy = 16,
        PrintOption = 17,
        ProductCategory = 18,
        RestaurantService = 19,
        ShareInformationWith = 20,
    //    SmokingPolicy = 21,
        EditorChecks = 22,
        Cuisine = 23,
        TourType = 24,
        RestaurantType = 25,
        RestaurantSpecialty = 26,
        ExhibitType = 27,
        CoordinateEditChecks = 28,
        TransportationType = 29,
        AccessAdvisor = 30,
        TrailType = 31,
        TrailPetsPolicy = 32,
        TrailSurface = 33,
        CellService = 34
    }

    // Attribute Enums
    public enum AccessAdvisor
    {
        Full = 1451,
        Partial = 1452,
        Sight = 1453,
        Hearing = 1454
    }


    public enum AccommodationAmenity
    {
        AirConditioning = 1,
        CableTv = 2,
        CoffeeMaker = 3,
        DataPort = 5,
        DvdPlayer = 18,
        Fireplace = 19,
        HairDryer = 6,
        Microwave = 7,
        Minifridge = 8,
        Movies = 9,
        Telephone = 20,
        Television = 11,
        Wifi = 12,
//        Dvd = 13,
//        CdPlayer = 14,
        VideoGames = 15,
        Kitchen = 16,
        Kitchenette = 21,
        BathroomEnsuite = 22,
        BathroomPrivate = 23,
        BathroomShared = 24,
        InternetWired = 25,
        SatelliteTv = 17
    }

    public enum AccommodationService
    {
      //  BreakfastIncluded = 51,
        Concierge = 52,
        Outfitters = 57,
        FitnessCentre = 53,
        RoomService = 55,
        Spa = 56
    }

    public enum AccommodationType
    {
        Apartment = 101,
        BedAndBreakfast = 102,
        BedAndBreakfastInn = 103,
        Cabin = 104,
        Condo = 105,
        Cottage = 106,
        GuestRoom = 107,
        Hostel = 108,
        Hotel = 109,
        Inn = 110,
        Lodge = 111,
        MiniHome = 112,
        Motel = 113,
        Resort = 114,
        TouristHome = 115,
        DormStyle = 116,
        VacationHome = 117
    }

    public enum Activity
    {
        Atv = 151,
        Birding = 152, //renamed watchable wildlife in interface
        Camping = 153,
        Canoeing = 154,
        CrossCountrySkiing = 155,
        Cycling = 157,
        Diving = 158,
        DogSledding = 159,
        DownhillSkiing = 160,
        Fishing = 161,
        Flying = 162,
        Geocaching = 179,
        Golf = 163,
        Hiking = 164,
        Kayaking = 165,
        Kitesurfing = 183,
        MountainBiking = 182,
       // MiniGolf = 166,
       // Paragliding = 180,
        Paddleboarding = 184,
        PhotographyLandscapePainting = 171,
        RidingHayRide = 167,
        RiverRafting = 168,
        Sailing = 169,
        Sightseeing = 181,
        AirAdventure = 172,
        SleighRiding = 173,
        Snowmobiling = 178,
        Snowshoeing = 174,
        Surfing = 175,
        WhaleWatching = 176,
        Ziplining = 177
    }

    public enum ApprovedBy
    {
        CanadaSelect = 201,
        Caa = 202,
        NsApproved = 203
    }
    
    //public enum AttractionService
    //{
    //    BusTours = 1,
    //    GenealogicalServices = 2,
    //    Takeoutm
    //    TeaRoom

    //}

    public enum AreaOfInterest
    {
        Agriculture = 251,
        Art = 271,
        Aviation = 252,
        BayOfFundy = 253,
        CommunityHeritage = 254,
       // Firefighting = 255,
        Fossils = 256,
        Genealogy = 269,
       // HarvestCelebration = 257,
        Immigration = 258,
        Industrial = 259,
        Marine = 261,
        Military = 267,
//        Mining = 262,
        Music = 263,
//        NatureWildlife = 264,
        Shopping = 270,
        Sports = 265,
        Trains = 266
    }

    public enum ArtType
    {
        Accessories = 301,
        BathBodyProducts = 302,
        Clothing = 303,
        FineArt = 310,
        Furniture = 304,
        GardenAccessories = 305,
        HomeDecor = 306,
        Jewellery = 307,
        Sculpture = 308,
        VisualArt = 309,
        Food = 311,
        Crafts = 312,
        FolkArt = 313
    }

    public enum CampgroundAmenity
    {
        FlushToilets = 351,
        Playground = 352,
        PullThroughs = 353,
        ShowersFree = 354,
        RecHall = 355,
        DisposalStation = 356,
        ElectricalHookup = 357,
        PitToilet = 358,
        SewageHookup = 359,
        Unserviced = 360,
        WaterHookup = 361,
        KitchenetteFacilities = 362,
        CampCabinsTrailers = 363,
        CookingShelter = 364,
        Laundromat = 365, 
        OpenSites = 366,
        Propane = 367,
        ShadedSites = 368,
        ShowersPay = 369,
        Store = 370,
        SwimmingLake = 371,
        SwimmingOcean = 372,
        SwimmingRiver = 373
    }

    public enum CoreExperience
    {
        BeachesSeacoast = 401,
        CitiesTowns = 402,
        FoodWine = 403,
        History = 404,
        OurCulture = 405,
        OutdoorAdventure = 406
    }

    public enum CulturalHeritage
    {
        Acadian = 451,
        AfricanNovaScotian = 452,
        GaelicScottish = 453,
        Mikmaq = 454
    }

    public enum ExhibitType
    {
        ArtisanStudios = 1301,
        ShopsAndGalleries = 1302
    }

    public enum Feature
    {
        //Beach = 501,
        MultiLingual = 517,
        BusTours = 502,
        ChildrensActivities = 524,
      //  EnvironmentallyFriendly = 503,
      //  EquipmentRental = 523,
        //Gardens = 504,
     //   GenealogicalServices = 518,
        GiftShop = 505,
        InternetAccess = 519,
     //   LiveMusic = 520,
        MeetingFacilities = 506,
        OceanView = 507,
        Parking = 508,
        PicnicTables = 509,
        PoolIndoor = 525,
        PoolOutdoor = 510,
        PublicWashroom = 511,
        Restaurant = 512,
        SmokingPermitted = 521,
        Takeout = 514,
        TeaRoom = 513,
        TravelAgentCommission = 522,
        WheelChairAccessible = 515,
        LimitedAccessibility = 516
    }

    public enum GovernmentLevel
    {
        National = 551,
        Provincial = 552
    }

    //public enum GovernmentProgram
    //{
    //    NsGovernment = 601,
    //    ParksCanada = 602,
    //    TasteOfNs = 603
    //}

    public enum Medium
    {
        BooksCards = 651,
        Candles = 665,
        Clay = 652,
        //DecorativeArt = 653,
        Fibre = 654,
        //Food = 655,
        Glass = 656,
        Leather = 657,
        Metal = 658,
        //Organics = 659,
        PaintingPrints = 659,
        Paper = 660,
        Photography = 662,
        StoneBone = 661,
        //VisualArt = 662,
        Wood = 663,
        MultipleMedia = 664
    }

    public enum Membership
    {
        Igns = 701,
        Nsbba = 702,
        Tians = 703,
        Coans = 704,
        Hans = 705,
        //Checkin = 706,
        Nsata = 707,
        GolfNs = 708,
        Rans = 709,
        TasteOfNs = 710,
        DestinationHfx = 711,
        Bienvenue = 712
    }

    public enum PetsPolicy
    {
        PetsLiveOnPremises = 751,
        PetsNotWelcome = 752,
        PetsWelcome = 753
    }

    public enum PrintOption
    {
        PrintGps = 801,
        AddEnglishAdRef = 802,
        AddFrenchAdRef = 803,
        HasEnglishGuideAd = 804,
        HasFrenchGuideAd = 805,
        BrochureAvailable = 806
    }

    public enum ProductCategory
    {
        Archive = 851,
        BeachSupervised = 852,
        BeachUnsupervised = 875,
        BreweryDistillery = 853,
        CasinoGaming = 854,
        Collection = 877,
        DiveShop = 876,
        DrivingRange = 878,
        Economuseum = 855,
        EquipmentRental = 881,
        FarmersMarket = 885,
        FunPark = 856,
        Garden = 857,
        GolfCourse = 858,
        HistoryHeritageSite = 859,
        InterpretiveCentre = 860,
        Lighthouse = 861,
        MarinaYachtClub = 883,
        MemorialMonument = 862,
        Museum = 863,
        NonProfitArtGallery = 864,
        NoveltyGolfCourse = 882,
        Park = 865,
        SailingCharter = 880,
        SailingInstructor = 884,
        ScienceCentre = 867,
        SpecialtyFoodShop = 868,
        StockedPond = 866,
        TheatreVenue = 869,
        Trail = 870,
        Unesco = 871,
        Waterfall = 872,
        Winery = 873,
        ZooWildlifeFarm = 874
    }

    public enum RestaurantService
    {
        BusToursWelcome = 901,
        ChildrensMenu = 902,
        Delivery = 903,
        DiningRoom = 904,
        Licensed = 905,
        LiveEntertainment = 906,
        Patio = 907,
        ReservationsAccepted = 908,
        SmokingArea = 909,
        Takeout = 910
    }

    public enum ShareInformationWith
    {
        CanadaSelect = 951,
        Caa = 952,
        NsApproved = 953
    }

    public enum TransportationType
    {
        Bus = 1401,
        CarRental = 1402,
        Ferry = 1403,
        MajorAirport = 1404,
        VisitorCentre = 1405,
        ServiceAirport = 1406,
        Shuttle = 1407,
        Train = 1408 
    }


    public enum TrailType
    {
        DayUse = 1500,
        Linear = 1501,
        Urban = 1502,
        Wilderness = 1503
    }

    public enum TrailPetsPolicy
    {
        OffLeash = 1551,
        Leashed = 1552,
        NotAllowed = 1553
    }

    public enum TrailSurface
    {
        Hard = 1600,
        Gravel = 1601,
        Natural = 1602
    }

    public enum CellService
    {
        Full = 1651,
        Partial = 1652,
        NoService = 1653
    }

    public enum EditorCheck
    {
        RenewalFormOut = 1051,
        UpdatesEntered = 1052,
        QueriesToCheck = 1053,
        CheckingWithQa = 1054,
        EntryCompleted = 1055,
        FaxProof = 1056,
        EmailProof = 1057,
        ProofSent = 1058,
        ProofSigned = 1059,
        TranslationProofed = 1060,
        Miscellaneous = 1061,
        ReadyForPrint = 1062,
        DoNotPrint = 1063,
        IsEnhancedListing = 1064
    }

    public enum Cuisine
    {
        Local = 1101,
        LobsterSeafood = 1102,
        Organic = 1103
    }

    public enum TourType
    {
        BoatsToursCharters = 1151,
        SightseeingDayTour = 1152,
        MultiDayTour = 1153,
        MultiActivityAdventure = 1154,
        NatureWildlife = 1155,
        OutdoorActivity = 1156,
        StepOn = 1157,
        WalkingTour = 1158
    }

    public enum RestaurantType
    {
        CoffeeShop = 1200,
        Continental = 1201,
        FamilyDining = 1202,
        FastFood = 1203,
        FineDining = 1204,
        Gourmet = 1205,
        Informal = 1206,
        Lounge = 1207,
        Pub = 1208
    }

    public enum RestaurantSpecialty
    {
        Acadian = 1251,
        //Burgers = 1252,
        Canadian = 1253,
        Asian = 1254,
        European = 1255,
        FishAndChips = 1256,
     //   German = 1257,
     //   Italian = 1258,
     //   Pasta = 1259,
        PizzaAndBurgers = 1260,
        Sandwiches = 1261,
        Seafood = 1262,
        Steaks = 1263,
        Vegetarian = 1264,
        Latin = 1265,
        Indian = 1266,
        MiddleEastern = 1267,
        Desserts = 1268,
        GlutenFree = 1269
    }

    public enum FestivalDesignation
    {
        Signature = 1300,
        HometownPride = 1301,
        DontMiss = 1302,
        CommunityCelebration = 1303,
        NoDesignation = 1304,
        AdventuresInTaste = 1305
    }

    public enum FesivalCategory
    {
        Agriculture = 1350,
        Animals = 1351,
        Antiques = 1352,
        ArtsCrafts = 1353,
        CarsMotorcycles = 1354,
        Celebrations = 1355,
        ChildrensEvents = 1356,
        ClanFamilyGathering = 1357,
        Culture = 1358,
        Food = 1359,
        Heritage = 1360,
        Military = 1361,
        Music = 1362,
        Nature = 1363,
        Outdoor = 1364,
        SportsRecreation = 1365,
        Theatre = 1366
    }
}
