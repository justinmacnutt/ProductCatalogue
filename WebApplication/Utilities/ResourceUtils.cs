using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ProductCatalogue.DataAccess.Enumerations;
using Action = ProductCatalogue.DataAccess.Enumerations.Action;

namespace WebApplication.Utilities
{
    public class ResourceUtils
    {

        public static string GetResearchClassLabel(ResearchClass rc)
        {
            switch (rc)
            {
                case (ResearchClass.Apartment):
                    return "Apartment";
                case (ResearchClass.BedBreakfast):
                    return "B&B";
                case (ResearchClass.BedBreakfastInn):
                    return "B&B inn";
                case (ResearchClass.CottageCabin):
                    return "Cottage/Cabin";
                case (ResearchClass.Hostel):
                    return "Hostel";
                case (ResearchClass.Hotel):
                    return "Hotel";
                case (ResearchClass.HuntingLodge):
                    return "Hunting/Fishing lodge";
                case (ResearchClass.Inn):
                    return "Inn";
                case (ResearchClass.Motel):
                    return "Motel";
                case (ResearchClass.Resort):
                    return "Resort";
                case (ResearchClass.TouristHome):
                    return "Tourist, guest, or vacation home";
                case (ResearchClass.University):
                    return "University";
                case (ResearchClass.Seasonal):
                    return "Seasonal";
                case (ResearchClass.ShortTerm):
                    return "Short-term";
                default:
                    return "ERROR";
            }
            
        }

        public static string GetResearchUnitTypeLabel(ResearchUnitType rut)
        {
            switch (rut)
            {
                case (ResearchUnitType.Apartment):
                    return "Apartment";
                case (ResearchUnitType.BedBreakfast):
                    return "B&B";
                case (ResearchUnitType.BedBreakfastInn):
                    return "B&B inn";
                case (ResearchUnitType.Cabin):
                    return "Cabin";
                case (ResearchUnitType.CondoCottage):
                    return "Condo-cottage";
                case (ResearchUnitType.Cottage):
                    return "Cottage";
                case (ResearchUnitType.DormStyle):
                    return "Dorm-style";
                case (ResearchUnitType.GuestRoom):
                    return "Guest room";
                case (ResearchUnitType.Hostel):
                    return "Hostel";
                case (ResearchUnitType.Hotel):
                    return "Hotel";
                case (ResearchUnitType.Inn):
                    return "Inn";
                case (ResearchUnitType.Lodge):
                    return "Lodge";
                case (ResearchUnitType.MiniHome):
                    return "Minihome";
                case (ResearchUnitType.Motel):
                    return "Motel";
                case (ResearchUnitType.Resort):
                    return "Resort";
                case (ResearchUnitType.Seasonal):
                    return "Seasonal";
                case (ResearchUnitType.ShortTerm):
                    return "Short term";
                case (ResearchUnitType.TouristHome):
                    return "Tourist home";
                case (ResearchUnitType.VacationHome):
                    return "Vacation home";
                default:
                    return "ERROR";
            }

        }

        public static string GetAttributeLabel(int i)
        {
            switch (i)
            {
                case ((int)AccessAdvisor.Full):
                    return "Full mobile accessible";
                case ((int)AccessAdvisor.Hearing):
                    return "Hearing accessible";
                case ((int)AccessAdvisor.Partial):
                    return "Partially accessible";
                case ((int)AccessAdvisor.Sight):
                    return "Sight accessible";

                case ((int)AccommodationAmenity.AirConditioning):
                    return "Air conditioning";
                case ((int)AccommodationAmenity.CableTv):
                    return "Cable TV";
                case ((int)AccommodationAmenity.CoffeeMaker):
                    return "Coffee maker";
                case ((int)AccommodationAmenity.DataPort):
                    return "Data port";
                case ((int)AccommodationAmenity.DvdPlayer):
                    return "Dvd player";
                case ((int)AccommodationAmenity.Fireplace):
                    return "Fireplace";
                case ((int)AccommodationAmenity.HairDryer):
                    return "Hair dryer";
                case ((int)AccommodationAmenity.Kitchen):
                    return "Kitchen";
                case ((int)AccommodationAmenity.Kitchenette):
                    return "Kitchenette";
                case ((int)AccommodationAmenity.Microwave):
                    return "Microwave";
                case ((int)AccommodationAmenity.Minifridge):
                    return "Minifridge";
                case ((int)AccommodationAmenity.Movies):
                    return "Movies";
                case ((int)AccommodationAmenity.SatelliteTv):
                    return "Satellite Tv";
                case ((int)AccommodationAmenity.Telephone):
                    return "Telephone";
                case ((int)AccommodationAmenity.Television):
                    return "Television";
                case ((int)AccommodationAmenity.VideoGames):
                    return "Video games";
                case ((int)AccommodationAmenity.Wifi):
                    return "Wi-fi";
                case ((int)AccommodationAmenity.InternetWired):
                    return "Wired Internet Access";
                case ((int)AccommodationAmenity.BathroomEnsuite):
                    return "Bathroom (Ensuite)";
                case ((int)AccommodationAmenity.BathroomPrivate):
                    return "Bathroom (Private)";
                case ((int)AccommodationAmenity.BathroomShared):
                    return "Bathroom (Shared)";

                case ((int)AccommodationService.Concierge):
                    return "Concierge";
                case ((int)AccommodationService.FitnessCentre):
                    return "Fitness centre";
                case ((int)AccommodationService.Outfitters):
                    return "Outfitters";
                case ((int)AccommodationService.RoomService):
                    return "Room service";
                case ((int)AccommodationService.Spa):
                    return "Spa services";
                case ((int)AccommodationType.Apartment):
                    return "Apartment";
                case ((int)AccommodationType.BedAndBreakfast):
                    return "Bed & breakfast";
                case ((int)AccommodationType.BedAndBreakfastInn):
                    return "Bed & breakfast inn";
                case ((int)AccommodationType.Cabin):
                    return "Cabin";
                case ((int)AccommodationType.Condo):
                    return "Condo-cottage";
                case ((int)AccommodationType.Cottage):
                    return "Cottage";
                case ((int)AccommodationType.DormStyle):
                    return "Dorm-style";
                case ((int)AccommodationType.GuestRoom):
                    return "Guest room";
                case ((int)AccommodationType.Hostel):
                    return "Hostel";
                case ((int)AccommodationType.Hotel):
                    return "Hotel";
                case ((int)AccommodationType.Inn):
                    return "Inn";
                case ((int)AccommodationType.Lodge):
                    return "Lodge";
                case ((int)AccommodationType.MiniHome):
                    return "Minihome";
                case ((int)AccommodationType.Motel):
                    return "Motel";
                case ((int)AccommodationType.Resort):
                    return "Resort";
                case ((int)AccommodationType.TouristHome):
                    return "Tourist home";
                case ((int)AccommodationType.VacationHome):
                    return "Vacation home";
                case ((int)Activity.Atv):
                    return "4-wheeling/ATVs";
                case ((int)Activity.Birding):
                    return "Birding & wildlife";
                case ((int)Activity.Camping):
                    return "Camping";
                case ((int)Activity.Canoeing):
                    return "Canoeing";
                case ((int)Activity.CrossCountrySkiing):
                    return "Cross country skiing";
                case ((int)Activity.Cycling):
                    return "Cycling";
                case ((int)Activity.Diving):
                    return "Diving";
                case ((int)Activity.DogSledding):
                    return "Dog sledding";
                case ((int)Activity.DownhillSkiing):
                    return "Downhill skiing";
                case ((int)Activity.Fishing):
                    return "Sports fishing";
                case ((int)Activity.Flying):
                    return "Flying";
                case ((int)Activity.Geocaching):
                    return "Geocaching";
                case ((int)Activity.Golf):
                    return "Golf";
                case ((int)Activity.Hiking):
                    return "Hiking";
                case ((int)Activity.MountainBiking):
                    return "Mountain biking";
                case ((int)Activity.Kayaking):
                    return "Kayaking";
                case ((int)Activity.Kitesurfing):
                    return "Kitesurfing";
                case ((int)Activity.Paddleboarding):
                    return "Paddleboarding";
                case ((int)Activity.PhotographyLandscapePainting):
                    return "Photography & painting";
                case ((int)Activity.RidingHayRide):
                    return "Riding/Hay rides";
                case ((int)Activity.RiverRafting):
                    return "River rafting";
                case ((int)Activity.Sailing):
                    return "Sailing";
                case ((int)Activity.Sightseeing):
                    return "Sightseeing tour";
                case ((int)Activity.AirAdventure):
                    return "Air Adventure";
                case ((int)Activity.SleighRiding):
                    return "Sleigh ride";
                case ((int)Activity.Snowmobiling):
                    return "Snowmobiling";
                case ((int)Activity.Snowshoeing):
                    return "Snowshoeing";
                case ((int)Activity.Surfing):
                    return "Surfing";
                case ((int)Activity.WhaleWatching):
                    return "Whale watching";
                case ((int)Activity.Ziplining):
                    return "Ziplining";
                case ((int)ApprovedBy.Caa):
                    return "CAA";
                case ((int)ApprovedBy.CanadaSelect):
                    return "Canada Select";
                case ((int)ApprovedBy.NsApproved):
                    return "NS Approved";
                case ((int)AreaOfInterest.Agriculture):
                    return "Agriculture";
                case ((int)AreaOfInterest.Art):
                    return "Art & artisan";
                case ((int)AreaOfInterest.Aviation):
                    return "Aviation";
                case ((int)AreaOfInterest.BayOfFundy):
                    return "Bay of Fundy";
                case ((int)AreaOfInterest.CommunityHeritage):
                    return "Community heritage";
                case ((int)AreaOfInterest.Fossils):
                    return "Fossils & rockhounding";
                case ((int)AreaOfInterest.Genealogy):
                    return "Genealogy";
                case ((int)AreaOfInterest.Immigration):
                    return "Immigration";
                case ((int)AreaOfInterest.Industrial):
                    return "Industrial";
                case ((int)AreaOfInterest.Marine):
                    return "Marine";
                case ((int)AreaOfInterest.Military):
                    return "Military";
                case ((int)AreaOfInterest.Music):
                    return "Music";
                case ((int)AreaOfInterest.Shopping):
                    return "Shopping";
                case ((int)AreaOfInterest.Sports):
                    return "Sports";
                case ((int)AreaOfInterest.Trains):
                    return "Trains";

                case ((int)ArtType.Accessories):
                    return "Accessories";
                case ((int)ArtType.BathBodyProducts):
                    return "Bath body products";
                case ((int)ArtType.Clothing):
                    return "Clothing";
                case ((int)ArtType.Crafts):
                    return "Crafts";
                case ((int)ArtType.FineArt):
                    return "Fine Art";
                case ((int)ArtType.FolkArt):
                    return "Folk Art";
                case ((int)ArtType.Food):
                    return "Food";
                case ((int)ArtType.Furniture):
                    return "Furniture";
                case ((int)ArtType.GardenAccessories):
                    return "Garden accessories";
                case ((int)ArtType.HomeDecor):
                    return "Home decor";
                case ((int)ArtType.Jewellery):
                    return "Jewellery";
                case ((int)ArtType.Sculpture):
                    return "Sculpture";
                case ((int)ArtType.VisualArt):
                    return "Visual art";

                case ((int)CampgroundAmenity.DisposalStation):
                    return "Disposal station";
                case ((int)CampgroundAmenity.ElectricalHookup):
                    return "Electrical hook-up";
                case ((int)CampgroundAmenity.FlushToilets):
                    return "Flush toilets";
                case ((int)CampgroundAmenity.RecHall):
                    return "Rec Hall";
                case ((int)CampgroundAmenity.KitchenetteFacilities):
                    return "Kitchen/Kitchennette";
                case ((int)CampgroundAmenity.PitToilet):
                    return "Pit toilet";
                case ((int)CampgroundAmenity.Playground):
                    return "Playground";
                case ((int)CampgroundAmenity.PullThroughs):
                    return "Pull-throughs";
                case ((int)CampgroundAmenity.SewageHookup):
                    return "Sewage hook-up";
                case ((int)CampgroundAmenity.ShowersFree):
                    return "Showers (Free)";
                case ((int)CampgroundAmenity.ShowersPay):
                    return "Showers (Pay)";
                case ((int)CampgroundAmenity.Unserviced):
                    return "Unserviced";
                case ((int)CampgroundAmenity.WaterHookup):
                    return "Water hook-up";
                case ((int)CampgroundAmenity.SwimmingLake):
                    return "Swimming (Lake)";
                case ((int)CampgroundAmenity.SwimmingOcean):
                    return "Swimming (Ocean)";
                case ((int)CampgroundAmenity.SwimmingRiver):
                    return "Swimming (River)";
                case ((int)CampgroundAmenity.CampCabinsTrailers):
                    return "Camp Cabins/Trailers";
                case ((int)CampgroundAmenity.CookingShelter):
                    return "Cooking Shelter";
                case ((int)CampgroundAmenity.Laundromat):
                    return "Laundromat";
                case ((int)CampgroundAmenity.OpenSites):
                    return "Open sites";
                case ((int)CampgroundAmenity.Propane):
                    return "Propane";
                case ((int)CampgroundAmenity.ShadedSites):
                    return "Shaded Sites";
                case ((int)CampgroundAmenity.Store):
                    return "Store";



                case ((int)CoordinateEditChecks.CoordinatesConfirmedByOperator):
                    return "Confirmed by operator";
                case ((int)CoordinateEditChecks.CoordinatesConfirmedByStaff):
                    return "Confirmed by staff";
                case ((int)CoordinateEditChecks.CoordinatesMatch):
                    return "Coordinates match";
                
                case ((int)CoreExperience.BeachesSeacoast):
                    return "Beaches & Seacoast";
                case ((int)CoreExperience.CitiesTowns):
                    return "Cities & Towns";
                case ((int)CoreExperience.FoodWine):
                    return "Food & Wine";
                case ((int)CoreExperience.History):
                    return "History";
                case ((int)CoreExperience.OurCulture):
                    return "Our culture";
                case ((int)CoreExperience.OutdoorAdventure):
                    return "Outdoor adventure";

                case ((int)Cuisine.LobsterSeafood):
                    return "Lobster & seafood";
                case ((int)Cuisine.Local):
                    return "Local";
                case ((int)Cuisine.Organic):
                    return "Organic";

                case ((int)CulturalHeritage.Acadian):
                    return "Acadian";
                case ((int)CulturalHeritage.AfricanNovaScotian):
                    return "African Nova Scotian";
                case ((int)CulturalHeritage.GaelicScottish):
                    return "Gaelic/Scottish";
                case ((int)CulturalHeritage.Mikmaq):
                    return "Mi'kmaq";

                case ((int)EditorCheck.CheckingWithQa):
                    return "Checking with QA";
                case ((int)EditorCheck.EmailProof):
                    return "Email proof";
                case ((int)EditorCheck.EntryCompleted):
                    return "Entry completed";
                case ((int)EditorCheck.FaxProof):
                    return "Fax proof";
                case ((int)EditorCheck.Miscellaneous):
                    return "Miscellaneous";
                case ((int)EditorCheck.TranslationProofed):
                    return "Translation proofed";
                case ((int)EditorCheck.ProofSent):
                    return "Proof sent";
                case ((int)EditorCheck.ProofSigned):
                    return "Proof signed";
                case ((int)EditorCheck.QueriesToCheck):
                    return "Queries to check";
                case ((int)EditorCheck.ReadyForPrint):
                    return "Ready for print";
                case ((int)EditorCheck.RenewalFormOut):
                    return "Renewal form out";
                case ((int)EditorCheck.UpdatesEntered):
                    return "Updates entered";
                case ((int)EditorCheck.DoNotPrint):
                    return "Do not print";
                case ((int)EditorCheck.IsEnhancedListing):
                    return "Enhanced Listing";


                case ((int)ExhibitType.ArtisanStudios):
                    return "Artisan studios";
                case ((int)ExhibitType.ShopsAndGalleries):
                    return "Shops & galleries";
                
                case ((int)Feature.MultiLingual):
                    return "Bilingual/Multilingual";
                case ((int)Feature.BusTours):
                    return "Bus tours";
                case ((int)Feature.ChildrensActivities):
                    return "Children's activities";
                case ((int)Feature.GiftShop):
                    return "Gift shop";
                case ((int)Feature.InternetAccess):
                    return "Internet access";
                case ((int)Feature.LimitedAccessibility):
                    return "Limited accessibility";
                case ((int)Feature.MeetingFacilities):
                    return "Meeting facilities";
                case ((int)Feature.OceanView):
                    return "Ocean view";
                case ((int)Feature.Parking):
                    return "Parking";
                case ((int)Feature.PicnicTables):
                    return "Picnic tables";
                case ((int)Feature.PoolOutdoor):
                    return "Pool (Outdoor)";
                case ((int)Feature.PoolIndoor):
                    return "Pool (Indoor)";
                case ((int)Feature.PublicWashroom):
                    return "Public washroom";
                case ((int)Feature.Restaurant):
                    return "Restaurant";
                case ((int)Feature.SmokingPermitted):
                    return "Smoking permitted";
                case ((int)Feature.Takeout):
                    return "Takeout";
                case ((int)Feature.TeaRoom):
                    return "Tea room";
                case ((int)Feature.TravelAgentCommission):
                    return "Travel agent commission";
                case ((int)Feature.WheelChairAccessible):
                    return "Wheelchair accessible";

                case ((int)GovernmentLevel.National):
                    return "National";
                case ((int)GovernmentLevel.Provincial):
                    return "Provincial";

                case ((int)Medium.BooksCards):
                    return "Books & cards";
                case ((int)Medium.Candles):
                    return "Candles";
                case ((int)Medium.Clay):
                    return "Clay";
                case ((int)Medium.Fibre):
                    return "Fibre";
                case ((int)Medium.Glass):
                    return "Glass";
                case ((int)Medium.Leather):
                    return "Leather";
                case ((int)Medium.Metal):
                    return "Metal";
                case ((int)Medium.MultipleMedia):
                    return "Multiple media";
                case ((int)Medium.PaintingPrints):
                    return "Painting & prints";
                case ((int)Medium.Paper):
                    return "Paper";
                case ((int)Medium.Photography):
                    return "Photography";
                case ((int)Medium.StoneBone):
                    return "Stone & bone";
                case ((int)Medium.Wood):
                    return "Wood";
                case ((int)Membership.Bienvenue):
                    return "Bienvenue";
                case ((int)Membership.Coans):
                    return "COANS";
                case ((int)Membership.DestinationHfx):
                    return "Destination Halifax";
                case ((int)Membership.GolfNs):
                    return "Golf NS";
                case ((int)Membership.Hans):
                    return "HANS";
                case ((int)Membership.Igns):
                    return "IGNS";
                case ((int)Membership.Nsata):
                    return "NSATA";
                case ((int)Membership.Nsbba):
                    return "NSBBA";
                case ((int)Membership.Rans):
                    return "RANS";
                case ((int)Membership.TasteOfNs):
                    return "Taste of NS";
                case ((int)Membership.Tians):
                    return "TIANS";

                case ((int)PetsPolicy.PetsLiveOnPremises):
                    return "Pets live on premises";
                case ((int)PetsPolicy.PetsNotWelcome):
                    return "No pets";
                case ((int)PetsPolicy.PetsWelcome):
                    return "Pets allowed";

                case ((int)PrintOption.AddEnglishAdRef):
                    return "Add English ad ref";
                case ((int)PrintOption.AddFrenchAdRef):
                    return "Add French ad ref";
                case ((int)PrintOption.BrochureAvailable):
                    return "Brochure available";
                case ((int)PrintOption.HasEnglishGuideAd):
                    return "Has English guide ad";
                case ((int)PrintOption.HasFrenchGuideAd):
                    return "Has French guide ad";
                case ((int)PrintOption.PrintGps):
                    return "Print GPS";

                case ((int)ProductCategory.Archive):
                    return "Archive";
                case ((int)ProductCategory.BeachSupervised):
                    return "Beach (supervised)";
                case ((int)ProductCategory.BeachUnsupervised):
                    return "Beach (unsupervised)";
                case ((int)ProductCategory.BreweryDistillery):
                    return "Brewery/Distillery";
                case ((int)ProductCategory.CasinoGaming):
                    return "Casino/Gaming";
                case ((int)ProductCategory.Collection):
                    return "Collection (private)";
                case ((int)ProductCategory.DiveShop):
                    return "Dive shop";
                case ((int)ProductCategory.DrivingRange):
                    return "Driving range";
                case ((int)ProductCategory.Economuseum):
                    return "Economuseum";
                case ((int)ProductCategory.EquipmentRental):
                    return "Equipment rental";
                case ((int)ProductCategory.FarmersMarket):
                    return "Farmers' Market";
                case ((int)ProductCategory.FunPark):
                    return "Fun park";
                case ((int)ProductCategory.Garden):
                    return "Garden";
                case ((int)ProductCategory.GolfCourse):
                    return "Golf course";
                case ((int)ProductCategory.HistoryHeritageSite):
                    return "History/Heritage site";
                case ((int)ProductCategory.InterpretiveCentre):
                    return "Interpretive centre";
                case ((int)ProductCategory.Lighthouse):
                    return "Lighthouse";
                case ((int)ProductCategory.MarinaYachtClub):
                    return "Marina/Yacht club";
                case ((int)ProductCategory.MemorialMonument):
                    return "Memorial/Monument";
                case ((int)ProductCategory.Museum):
                    return "Museum/Collection";
                case ((int)ProductCategory.NonProfitArtGallery):
                    return "Art gallery (non-profit)";
                case ((int)ProductCategory.NoveltyGolfCourse):
                    return "Novelty activity";
                case ((int)ProductCategory.Park):
                    return "Park";
                case ((int)ProductCategory.SailingCharter):
                    return "Sailing charter";
                case ((int)ProductCategory.SailingInstructor):
                    return "Sailing instruction";
                case ((int)ProductCategory.ScienceCentre):
                    return "Science centre";
                case ((int)ProductCategory.SpecialtyFoodShop):
                    return "Specialy food shop";
                case ((int)ProductCategory.StockedPond):
                    return "Stocked pond";
                case ((int)ProductCategory.TheatreVenue):
                    return "Theatre venue";
                case ((int)ProductCategory.Trail):
                    return "Trail";
                case ((int)ProductCategory.Unesco):
                    return "UNESCO site";
                case ((int)ProductCategory.Waterfall):
                    return "Waterfall";
                case ((int)ProductCategory.Winery):
                    return "Winery";
                case ((int)ProductCategory.ZooWildlifeFarm):
                    return "Zoo/Wildlife/Farm";

                case ((int)RestaurantService.BusToursWelcome):
                    return "Bus tours welcome";
                case ((int)RestaurantService.ChildrensMenu):
                    return "Childrens menu";
                case ((int)RestaurantService.Delivery):
                    return "Delivery";
                case ((int)RestaurantService.DiningRoom):
                    return "Dining room";
                case ((int)RestaurantService.Licensed):
                    return "Licensed";
                case ((int)RestaurantService.LiveEntertainment):
                    return "Live entertainment";
                case ((int)RestaurantService.Patio):
                    return "Patio";
                case ((int)RestaurantService.ReservationsAccepted):
                    return "Reservations recommended";
                case ((int)RestaurantService.SmokingArea):
                    return "Smoking area";
                case ((int)RestaurantService.Takeout):
                    return "Takeout";

                case ((int)ShareInformationWith.Caa):
                    return "CAA";
                case ((int)ShareInformationWith.CanadaSelect):
                    return "Canada Select";
                case ((int)ShareInformationWith.NsApproved):
                    return "NS Approved";

                case ((int)RestaurantType.CoffeeShop):
                    return "Coffee shop/Cafe";
                case ((int)RestaurantType.Continental):
                    return "Continental";
                case ((int)RestaurantType.FamilyDining):
                    return "Family dining";
                case ((int)RestaurantType.FastFood):
                    return "Fast food";
                case ((int)RestaurantType.FineDining):
                    return "Fine dining";
                case ((int)RestaurantType.Gourmet):
                    return "Gourmet";
                case ((int)RestaurantType.Informal):
                    return "Informal";
                case ((int)RestaurantType.Lounge):
                    return "Lounge";
                case ((int)RestaurantType.Pub):
                    return "Pub";

                case ((int)RestaurantSpecialty.Acadian):
                    return "Acadian";
                case ((int)RestaurantSpecialty.PizzaAndBurgers):
                    return "Pizza/Burgers";
                case ((int)RestaurantSpecialty.Canadian):
                    return "Canadian";
                case ((int)RestaurantSpecialty.Asian):
                    return "Asian";
                case ((int)RestaurantSpecialty.European):
                    return "European";
                case ((int)RestaurantSpecialty.FishAndChips):
                    return "Fish and chips";
                case ((int)RestaurantSpecialty.Sandwiches):
                    return "Sandwiches";
                case ((int)RestaurantSpecialty.Seafood):
                    return "Seafood";
                case ((int)RestaurantSpecialty.Steaks):
                    return "Steaks";
                case ((int)RestaurantSpecialty.Vegetarian):
                    return "Vegetarian";
                case ((int)RestaurantSpecialty.Desserts):
                    return "Desserts";
                case ((int)RestaurantSpecialty.GlutenFree):
                    return "Gluten Free";
                case ((int)RestaurantSpecialty.Indian):
                    return "Indian";
                case ((int)RestaurantSpecialty.Latin):
                    return "Latin";
                case ((int)RestaurantSpecialty.MiddleEastern):
                    return "Middle Eastern";
                
                case ((int)TransportationType.Bus):
                    return "Bus";
                case ((int)TransportationType.CarRental):
                    return "Car rental";
                case ((int)TransportationType.Ferry):
                    return "Ferry";
                case ((int)TransportationType.MajorAirport):
                    return "Major airport";
                case ((int)TransportationType.ServiceAirport):
                    return "Service airport";
                case ((int)TransportationType.Shuttle):
                    return "Shuttle";
                case ((int)TransportationType.Train):
                    return "Train";
                case ((int)TransportationType.VisitorCentre):
                    return "Visitor information centre";

                case ((int)TourType.BoatsToursCharters):
                    return "Boat tours & charters";
                case ((int)TourType.SightseeingDayTour):
                    return "Sightseeing & day tours";
                case ((int)TourType.MultiDayTour):
                    return "Multi-day tours";
                case ((int)TourType.MultiActivityAdventure):
                    return "Multi-Activity adventure";
                case ((int)TourType.NatureWildlife):
                    return "Nature & wildlife";
                case ((int)TourType.OutdoorActivity):
                    return "Outdoor adventure";
                case ((int)TourType.StepOn):
                    return "Step-On";
                case ((int)TourType.WalkingTour):
                    return "Walking tours";

                case ((int)TrailType.DayUse):
                    return "Day-use trail";
                case ((int)TrailType.Linear):
                    return "Linear park";
                case ((int)TrailType.Urban):
                    return "Urban or community trail";
                case ((int)TrailType.Wilderness):
                    return "Wilderness trail";

                case ((int)TrailSurface.Gravel):
                    return "Gravel";
                case ((int)TrailSurface.Hard):
                    return "Hard";
                case ((int)TrailSurface.Natural):
                    return "Natural";

                case ((int)TrailPetsPolicy.Leashed):
                    return "Leashed";
                case ((int)TrailPetsPolicy.OffLeash):
                    return "Off leash";
                case ((int)TrailPetsPolicy.NotAllowed):
                    return "Not allowed";

                case ((int)CellService.Full):
                    return "Full";
                case ((int)CellService.Partial):
                    return "Partial";
                case ((int)CellService.NoService):
                    return "No service";
                
                
                default:
                    return "ERROR";
            }
        }

        public static string GetValidationStatusLabel (bool b)
        {
            return (b) ? "Valid" : "Invalid";
        }

        public static string GetProductStatusLabel (bool b)
        {
            return (b) ? "Active" : "Inactive";
        }

        public static string GetErrorsOverwriddenLabel(bool b)
        {
            return (b) ? "Yes" : "No";
        }

        public static string GetGuideSectionLabel (int guideSectionId)
        {
            return (guideSectionId <= 50) ? GetGuideSectionOutdoorsLabel((GuideSectionOutdoors)guideSectionId) : GetGuideSectionTourOpsLabel((GuideSectionTourOps)guideSectionId);
        }

        public static string GetCanadaSelectRatingTypeLabel (CanadaSelectRatingType csrt)
        {
            switch (csrt)
            {
                case (CanadaSelectRatingType.Apartment):
                    return "Cottage/Apartment";
                case (CanadaSelectRatingType.BedAndBreakfast):
                    return "Bed & breakfast";
                case (CanadaSelectRatingType.BedAndBreakfastInn):
                    return "B&B/Inn";
                case (CanadaSelectRatingType.CampingFacilities):
                    return "Camping facilities";
                case (CanadaSelectRatingType.CampingRecreation):
                    return "Camping recreation";
                case (CanadaSelectRatingType.CottageVacationHome):
                    return "Cottage/Vacation home";
                case (CanadaSelectRatingType.FishingHunting):
                    return "Fishing & hunting";
                case (CanadaSelectRatingType.HotelMotel):
                    return "Hotel/Motel";
                case (CanadaSelectRatingType.Inn):
                    return "Inn";
                case (CanadaSelectRatingType.Resort):
                    return "Resort";
                case (CanadaSelectRatingType.TouristHome):
                    return "Tourist home";
                default:
                    return "ERROR";

            }
        }

        public static string GetRegionLabel (Region r)
        {
            switch (r)
            {
                case (Region.BrasDor):
                    return "Bras d'Or Lakes Scenic Drive";
                case (Region.CabotTrail):
                    return "Cabot Trail";
                case (Region.CeilidhTrail):
                    return "Ceilidh Trail";
                case (Region.EasternShore):
                    return "Eastern Shore";
                case (Region.FleurDeLis):
                    return "Fleur-de-Lis-Marconi-Metro CB";
                case (Region.FundyShore):
                    return "Fundy Shore & Annapolis Valley";
                case (Region.HalifaxMetro):
                    return "Halifax Metro";
                case (Region.Northumberland):
                    return "Northumberland Shore";
                case (Region.SouthShore):
                    return "South Shore";
                case (Region.Yarmouth):
                    return "Yarmouth & Acadian Shores";
                default:
                    return "ERROR";

            }
        }
        public static string GetGuideSectionOutdoorsLabel (GuideSectionOutdoors gso)
        {
            switch (gso)
            {
                case (GuideSectionOutdoors.Beaches):
                    return "Beaches (supervised)";
                //case (GuideSectionOutdoors.BoatTours):
                //    return "Boat tours and charters";
                case (GuideSectionOutdoors.DiveShops):
                    return "Dive shops";
                case (GuideSectionOutdoors.DogSledding):
                    return "Dog sledding";
                case (GuideSectionOutdoors.DrivingRanges):
                    return "Golf driving ranges";
                case (GuideSectionOutdoors.EquipmentRentals):
                    return "Equipment rentals";
                case (GuideSectionOutdoors.FishingGuides):
                    return "Fishing guides";
                case (GuideSectionOutdoors.FishingStockedLakes):
                    return "Fishing:Stocked lakes";
                case (GuideSectionOutdoors.Flying):
                    return "Flying";
                case (GuideSectionOutdoors.Geocaching):
                    return "Geocaching";
                case (GuideSectionOutdoors.Geology):
                    return "Geology:Rocks, minerals, and fossils";
                case (GuideSectionOutdoors.GolfCourses):
                    return "Golf courses";
                //case (GuideSectionOutdoors.Hunting):
                //    return "Hunting";
                case (GuideSectionOutdoors.NationalParks):
                    return "National parks";
                case (GuideSectionOutdoors.NoveltyGolf):
                    return "Novelty activities";
                //case (GuideSectionOutdoors.Outdoor):
                //    return "Outdoor adventure tours";
                case (GuideSectionOutdoors.Photography):
                    return "Photography & landscape painting";
                case (GuideSectionOutdoors.ProvincialParks):
                    return "Provincial parks & community parks";
                case (GuideSectionOutdoors.RidingHayRides):
                    return "Riding & hay rides";
                case (GuideSectionOutdoors.RiverRafting):
                    return "River rafting";
                case (GuideSectionOutdoors.SailingInstruction):
                    return "Sailing: Instruction";
                case (GuideSectionOutdoors.SailingLearnToSail):
                    return "Sailing: Learn-To-Sail vacations";
                case (GuideSectionOutdoors.SailingMarinas):
                    return "Sailing: Marinas & yacht clubs";
                case (GuideSectionOutdoors.SkiingCrossCountry):
                    return "Skiing: Cross-Country";
                case (GuideSectionOutdoors.SkiingDownhill):
                    return "Skiing: Downhill";
                case (GuideSectionOutdoors.AirAdventure):
                    return "Air Adventure";
                case (GuideSectionOutdoors.SleighRides):
                    return "Sleigh rides";
                case (GuideSectionOutdoors.Snowmobiling):
                    return "Snowmobiling";
                case (GuideSectionOutdoors.Snowshoeing):
                    return "Snowshoeing";
                case (GuideSectionOutdoors.Surfing):
                    return "Surfing";
                case (GuideSectionOutdoors.WalkingHikingTrails):
                    return "Hiking & walking";
                case (GuideSectionOutdoors.Ziplining):
                    return "Ziplining";
                default:
                    return "ERROR";
            }
        }

        public static string GetGuideSectionTourOpsLabel(GuideSectionTourOps gsto)
        {
            switch (gsto)
            {
                case (GuideSectionTourOps.BoatToursCharters):
                    return "Outdoor Tours: Boat tours & charters";
                case (GuideSectionTourOps.Sightseeing):
                    return "Sightseeing & day tour operators";
                case (GuideSectionTourOps.MultiDay):
                    return "Multi-day tours";
                case (GuideSectionTourOps.MultiactivityAdventure):
                    return "Outdoor Tours: Multiactivity adventure";
                case (GuideSectionTourOps.NatureWildlife):
                    return "Outdoor Tours: Nature & wildlife";
                case (GuideSectionTourOps.OutdoorAdventure):
                    return "Outdoor Tours: Outdoor adventure";
                case (GuideSectionTourOps.StepOnGuide):
                    return "Step-on guide services";
                case (GuideSectionTourOps.Walking):
                    return "Walking tours";
                default:
                    return "ERROR";
            }
        }



        public static string GetPeriodOfOperationTypeLabel(PeriodOfOperationType poot)
        {
            switch (poot)
            {
                case (PeriodOfOperationType.AllYear):
                    return "Open all year";
                case (PeriodOfOperationType.DateRange):
                    return "Open during date range";
                case (PeriodOfOperationType.Seasonal):
                    return "Open seasonally";
                default:
                    return "ERROR";
            }
        }

        public static string GetOwnershipTypeLabel (OwnershipType ot)
        {
            switch (ot)
            {
                case (OwnershipType.Public):
                    return "Public";
                case (OwnershipType.PrivateForProfit):
                    return "Private for profit";
                case (OwnershipType.PrivateNonProfit):
                    return "Private non profit";
                default:
                    return "ERROR";
            }
        }

        public static string GetCapacityTypeLabel(CapacityType ct)
        {
            switch (ct)
            {
                case (CapacityType.Large):
                    return "Large";
                case (CapacityType.Medium):
                    return "Medium";
                case (CapacityType.Seasonal):
                    return "Seasonal";
                case (CapacityType.Small):
                    return "Small";
                case (CapacityType.Unlimited):
                    return "Unlimited";
                default:
                    return "ERROR";
            }
        }

        public static string GetSustainabilityTypeLabel(SustainabilityType st)
        {
            switch (st)
            {
                case (SustainabilityType.OngoingPublicFunding):
                    return "Ongoing public funding";
                case (SustainabilityType.PeriodicPublicFunding):
                    return "Periodic public funding";
                case (SustainabilityType.PubliclyOperated):
                    return "Publicly operated";
                case (SustainabilityType.SelfSupporting):
                    return "Self supporting";
                default:
                    return "ERROR";
            }
        }
        
        public static string GetMediaLanguageLabel(MediaLanguage ml)
        {
            switch (ml)
            {
                case (MediaLanguage.English):
                    return "English";
                case (MediaLanguage.French):
                    return "French";
                case (MediaLanguage.Bilingual):
                    return "Bilingual";
                default:
                    return "ERROR";
            }
        }

        public static string GetMediaTypeLabel(MediaType mt)
        {
            switch (mt)
            {
                case MediaType.Advertisement:
                    return "Guide ad";
                case MediaType.Brochure:
                    return "Brochure";
                case MediaType.PhotoViewer:
                    return "Photo viewer";
                case MediaType.SummaryThumbnail:
                    return "Summary thumbnail";
                default:
                    return "ERROR";
            }
        }

        public static string GetPhoneTypeLabel(PhoneType pt)
        {
            switch (pt)
            {
                case PhoneType.Fax:
                    return "Fax";
                case PhoneType.Mobile:
                    return "Mobile";
                case PhoneType.Primary:
                    return "Primary phone";
                case PhoneType.OffSeason:
                    return "Off season";
                case PhoneType.Home:
                    return "Home";
                default:
                    return "ERROR";
            }
        }

        public static string GetBusinessContactTypeLabel(BusinessContactType bct)
        {
            switch (bct)
            {
                case (BusinessContactType.Tourism):
                    return "Marketing";
                case (BusinessContactType.Research):
                    return "Research";
                default:
                    return "ERROR";
            }
        }

        public static string GetContactTypeLabel(ContactType ct)
        {
            switch (ct)
            {
                case (ContactType.Primary):
                    return "Primary";
                case (ContactType.Secondary):
                    return "Secondary";
                default:
                    return "ERROR";
            }
        }

        public static string GetAddressTypeLabel(AddressType at)
        {
            switch (at)
            {
                case (AddressType.Civic):
                    return "Civic";
                case (AddressType.Mailing):
                    return "Mailing";
                case (AddressType.OffSeason):
                    return "Off season";
                default:
                    return "ERROR";
            }
        }

        public static string GetPaymentTypeLabel(PaymentType pt)
        {
            switch (pt)
            {
                case (PaymentType.AmericanExpress):
                    return "American express";
                case (PaymentType.CashOnly):
                    return "Cash only";
                case (PaymentType.DebitCard):
                    return "Debit Card";
                case (PaymentType.DinersClub):
                    return "Diner's club";
                case (PaymentType.Discover):
                    return "Discover";
                case (PaymentType.Jcb):
                    return "JCB";
                case (PaymentType.Mastercard):
                    return "MasterCard";
                case (PaymentType.PayPal):
                    return "PayPal";
                case (PaymentType.TravellersCheques):
                    return "Travellers cheques";
                case (PaymentType.Visa):
                    return "Visa";
                default:
                    return "ERROR";
            }
        }

        public static string GetCaaRatingLabel(CaaRatingType crt)
        {
            switch (crt)
            {
                case (CaaRatingType.BedAndBreakfast):
                    return "Bed & breakfast";
                case (CaaRatingType.CabinCottage):
                    return "Cabin/Cottage";
                case (CaaRatingType.Campground):
                    return "Campground";
                case (CaaRatingType.Condominium):
                    return "Condominium";
                case (CaaRatingType.CountryInn):
                    return "Country inn";
                case (CaaRatingType.Hotel):
                    return "Hotel";
                case (CaaRatingType.Motel):
                    return "Motel";
                case (CaaRatingType.VacationRentalHouse):
                    return "Vacation house";
                default:
                    return "ERROR";
            }
        }

        public static string GetRateTypeLabel(RateType rt)
        {
            switch (rt)
            {
                case (RateType.Gtd):
                    return "Guaranteed";
                case (RateType.Stc):
                    return "Subject to change";
                default:
                    return "ERROR";
            }
        }

        public static string GetCancellationPolicyLabel(CancellationPolicy cp)
        {
            switch (cp)
            {
                case (CancellationPolicy.BookingSpecific):
                    return "Booking-specific";
                case (CancellationPolicy.Day):
                    return "24 hours";
                case (CancellationPolicy.FiveDay):
                    return "5 days";
                case (CancellationPolicy.FourPm):
                    return "4 PM";
                case (CancellationPolicy.FourWeek):
                    return "4 weeks";
                case (CancellationPolicy.HalfDay):
                    return "12 hours";
                case (CancellationPolicy.NoCancellations):
                    return "No cancellations";
                case (CancellationPolicy.Noon):
                    return "Noon";
                case (CancellationPolicy.OneWeek):
                    return "1 week";
                case (CancellationPolicy.ThreeDay):
                    return "72 hours";
                case (CancellationPolicy.TwoDay):
                    return "48 hours";
                case (CancellationPolicy.TwoWeek):
                    return "2 weeks";
                case (CancellationPolicy.EightWeek):
                    return "8 weeks";
                case (CancellationPolicy.TwelveWeek):
                    return "12 weeks";
                default:
                    return "ERROR";
            }
        }

        public static string GetAttributeGroupLabel(AttributeGroup ag)
        {
            switch (ag)
            {
                case (AttributeGroup.AccessAdvisor):
                    return "Access advisor";
                case (AttributeGroup.AccommodationAmenity):
                    return "Accommodation amenity";
                case (AttributeGroup.AccommodationService):
                    return "Accommodation service";
                case (AttributeGroup.AccommodationType):
                    return "Accommodation type";
                case (AttributeGroup.Activity):
                    return "Outdoor activity";
                case (AttributeGroup.ApprovedBy):
                    return "Approved by";
                case (AttributeGroup.AreaOfInterest):
                    return "Area of interest";
                case (AttributeGroup.ArtType):
                    return "Art product type";
                case (AttributeGroup.CampgroundAmenity):
                    return "Campground amenity";
                case (AttributeGroup.CellService):
                    return "Cell service";
                case (AttributeGroup.CoordinateEditChecks):
                    return "Coordinate check";
                case (AttributeGroup.CoreExperience):
                    return "Core experience";
                case (AttributeGroup.Cuisine):
                    return "Cuisine";
                case (AttributeGroup.CulturalHeritage):
                    return "Cultural heritage";
                case (AttributeGroup.EatAndDrinkType):
                    return "Eat & Drink type";
                case (AttributeGroup.EditorChecks):
                    return "Editor check";
                case (AttributeGroup.ExhibitType):
                    return "Exhibit type";
                case (AttributeGroup.Feature):
                    return "Feature";
                case (AttributeGroup.GovernmentLevel):
                    return "Government level";
                case (AttributeGroup.Medium):
                    return "Fine art medium";
                case (AttributeGroup.Membership):
                    return "Membership";
                case (AttributeGroup.PetsPolicy):
                    return "Pets policy";
                case (AttributeGroup.PrintOption):
                    return "Print option";
                case (AttributeGroup.ProductCategory):
                    return "Product category";
                case (AttributeGroup.RestaurantSpecialty):
                    return "Restaurant specialty";
                case (AttributeGroup.RestaurantService):
                    return "Restaurant service";
                case (AttributeGroup.RestaurantType):
                    return "Restaurant type";
                case (AttributeGroup.ShareInformationWith):
                    return "Share information with";
                case (AttributeGroup.TourType):
                    return "Tour type";
                case (AttributeGroup.TrailType):
                    return "Trail type";
                case (AttributeGroup.TrailPetsPolicy):
                    return "Trail pets policy";
                case (AttributeGroup.TrailSurface):
                    return "Trail surface";
                case (AttributeGroup.TransportationType):
                    return "Transportation type";
                default:
                    return "ERROR";
            }
        }

        public static string GetAccommodationTypeLabel(AccommodationType at)
        {
            switch (at)
            {
                case (AccommodationType.Apartment):
                    return "Apartment";
                case (AccommodationType.BedAndBreakfast):
                    return "Bed & breakfast";
                case (AccommodationType.BedAndBreakfastInn):
                    return "Bed & breakfast inn";
                case (AccommodationType.Cabin):
                    return "Cabin";
                case (AccommodationType.Condo):
                    return "Condo";
                case (AccommodationType.Cottage):
                    return "Cottage";
                case (AccommodationType.GuestRoom):
                    return "Guest room";
                case (AccommodationType.Hostel):
                    return "Hostel";
                case (AccommodationType.Hotel):
                    return "Hotel";
                case (AccommodationType.Inn):
                    return "Inn";
                case (AccommodationType.Lodge):
                    return "Lodge";
                case (AccommodationType.MiniHome):
                    return "Mini home";
                case (AccommodationType.Motel):
                    return "Motel";
                case (AccommodationType.Resort):
                    return "Resort";
                case (AccommodationType.TouristHome):
                    return "Tourist home";
                case (AccommodationType.DormStyle):
                    return "Dorm-style";
                case (AccommodationType.VacationHome):
                    return "Vacation home";
                default:
                    return "ERROR";
            }
        }

        public static string GetProductTypeLabel(ProductType pt)
        {
            switch (pt)
            {
                case (ProductType.Accommodation):
                    return "Accommodation";
                case (ProductType.Attraction):
                    return "Attraction";
                case (ProductType.Campground):
                    return "Campground";
                case (ProductType.EatAndDrink):
                    return "Eat & Drink";
                case (ProductType.FineArts):
                    return "Fine arts";
                case (ProductType.Outdoors):
                    return "Outdoors";
                case (ProductType.Restaurants):
                    return "Restaurants";
                case (ProductType.TourOps):
                    return "Tour ops";
                case (ProductType.Transportation):
                    return "Transportation";
                case (ProductType.Trails):
                    return "Trails";
                default:
                    return "ERROR";
            }
        }

        public static string GetAccommodationAmenityLabel(AccommodationAmenity at)
        {
            switch (at)
            {
                case (AccommodationAmenity.AirConditioning):
                    return "Air conditioning";
                case (AccommodationAmenity.CableTv):
                    return "Cable TV";
                case (AccommodationAmenity.CoffeeMaker):
                    return "Coffee maker";
                case (AccommodationAmenity.DataPort):
                    return "Data port";
                case (AccommodationAmenity.HairDryer):
                    return "Hair dryer";
                case (AccommodationAmenity.Microwave):
                    return "Microwave";
                case (AccommodationAmenity.Minifridge):
                    return "Minifridge";
                case (AccommodationAmenity.Movies):
                    return "Movies";
                case (AccommodationAmenity.Television):
                    return "Television";
                case (AccommodationAmenity.VideoGames):
                    return "Video games";
                case (AccommodationAmenity.Wifi):
                    return "Wi-fi";
                case (AccommodationAmenity.Kitchen):
                    return "Kitchen";
                case (AccommodationAmenity.Kitchenette):
                    return "Kitchenette";
                case (AccommodationAmenity.SatelliteTv):
                    return "Satellite Tv";
                case (AccommodationAmenity.InternetWired):
                    return "Wired Internet Access";
                case (AccommodationAmenity.BathroomEnsuite):
                    return "Bathroom (Ensuite)";
                case (AccommodationAmenity.BathroomPrivate):
                    return "Bathroom (Private)";
                case (AccommodationAmenity.BathroomShared):
                    return "Bathroom (Shared)";
                default:
                    return "ERROR";
            }
        }

        public static string GetAccommodationServiceLabel(AccommodationService a)
        {
            switch (a)
            {
                //case (AccommodationService.BreakfastIncluded):
                //    return "Breakfast";
                case (AccommodationService.Concierge):
                    return "Concierge";
                case (AccommodationService.FitnessCentre):
                    return "Fitness centre";
                case (AccommodationService.RoomService):
                    return "Room service";
                case (AccommodationService.Spa):
                    return "Spa services";
                default:
                    return "ERROR";
            }
        }

        public static string GetActivityLabel(Activity a)
        {
            switch (a)
            {
                case (Activity.Atv):
                    return "4-wheeling/ATVs";
                case (Activity.Birding):
                    return "Birding & Wildlife";
                case (Activity.Camping):
                    return "Camping";
                case (Activity.Canoeing):
                    return "Canoeing";
                case (Activity.CrossCountrySkiing):
                    return "Cross country skiing";
                case (Activity.Cycling):
                    return "Cycling";
                case (Activity.Diving):
                    return "Diving";
                case (Activity.DogSledding):
                    return "Dog sledding";
                case (Activity.DownhillSkiing):
                    return "Downhill skiing";
                case (Activity.Fishing):
                    return "Sports fishing";
                case (Activity.Flying):
                    return "Flying";
                case (Activity.Geocaching):
                    return "Geocaching";
                case (Activity.Golf):
                    return "Golf";
                case (Activity.Hiking):
                    return "Hiking";
                case (Activity.Kayaking):
                    return "Kayaking";
                case (Activity.RidingHayRide):
                    return "Riding/Hay rides";
                case (Activity.RiverRafting):
                    return "River rafting";
                case (Activity.Sailing):
                    return "Sailing";
                case (Activity.PhotographyLandscapePainting):
                    return "Photography & painting";
                case (Activity.AirAdventure):
                    return "Air Adventure";
                case (Activity.SleighRiding):
                    return "Sleigh riding";
                case (Activity.Sightseeing):
                    return "Sightseeing";
                case (Activity.Snowmobiling):
                    return "Snowmobiling";
                case (Activity.Snowshoeing):
                    return "Snowshoeing";
                case (Activity.Surfing):
                    return "Surfing";
                case (Activity.WhaleWatching):
                    return "Whale watching";
                case (Activity.Ziplining):
                    return "Ziplining";
                default:
                    return "ERROR";
            }
        }

        public static string GetApprovedByLabel(ApprovedBy a)
        {
            switch (a)
            {
                case (ApprovedBy.Caa):
                    return "CAA";
                case (ApprovedBy.CanadaSelect):
                    return "Canada Select";
                case (ApprovedBy.NsApproved):
                    return "NS Approved";
                default:
                    return "ERROR";
            }
        }

        public static string GetAreaOfInterestLabel(AreaOfInterest a)
        {
            switch (a)
            {
                case (AreaOfInterest.Agriculture):
                    return "Agriculture";
                case (AreaOfInterest.Art):
                    return "Art & artisan";
                case (AreaOfInterest.Aviation):
                    return "Aviation";
                case (AreaOfInterest.BayOfFundy):
                    return "Bay of Fundy";
                case (AreaOfInterest.CommunityHeritage):
                    return "Community life";
                case (AreaOfInterest.Fossils):
                    return "Fossils & rockhounding";
                case (AreaOfInterest.Genealogy):
                    return "Genealogy";
                case (AreaOfInterest.Immigration):
                    return "Immigration";
                case (AreaOfInterest.Industrial):
                    return "Industrial";
                case (AreaOfInterest.Marine):
                    return "Marine";
                case (AreaOfInterest.Military):
                    return "Military";
                case (AreaOfInterest.Music):
                    return "Music";
                case (AreaOfInterest.Shopping):
                    return "Shopping";
                case (AreaOfInterest.Sports):
                    return "Sports";
                case (AreaOfInterest.Trains):
                    return "Trains";
                default:
                    return "ERROR";
            }
        }

        public static string GetArtTypeLabel(ArtType at)
        {
            switch (at)
            {
                case (ArtType.Accessories):
                    return "Accessories";
                case (ArtType.BathBodyProducts):
                    return "Bath body products";
                case (ArtType.Clothing):
                    return "Clothing";
                case (ArtType.Furniture):
                    return "Furniture";
                case (ArtType.GardenAccessories):
                    return "Garden accessories";
                case (ArtType.HomeDecor):
                    return "Home decor";
                case (ArtType.Jewellery):
                    return "Jewellery";
                case (ArtType.Sculpture):
                    return "Sculpture";
                case (ArtType.VisualArt):
                    return "Visual art";
                default:
                    return "ERROR";
            }
        }

        public static string GetCampgroundAmenityLabel(CampgroundAmenity ca)
        {
            switch (ca)
            {
                case (CampgroundAmenity.DisposalStation):
                    return "Disposal Station";
                case (CampgroundAmenity.ElectricalHookup):
                    return "Electrical hook-up";
                case (CampgroundAmenity.FlushToilets):
                    return "Accessories";
                case (CampgroundAmenity.RecHall):
                    return "Rec Hall";
                case (CampgroundAmenity.PitToilet):
                    return "Pit toilet";
                case (CampgroundAmenity.Playground):
                    return "Playground";
                case (CampgroundAmenity.PullThroughs):
                    return "Pull-throughs";
                case (CampgroundAmenity.SewageHookup):
                    return "Sewage hook-up";
                case (CampgroundAmenity.ShowersFree):
                    return "Showers (Free)";
                case (CampgroundAmenity.Unserviced):
                    return "Unserviced";
                case (CampgroundAmenity.WaterHookup):
                    return "Water hook-up";
                case (CampgroundAmenity.SwimmingLake):
                    return "Swimming Lake";
                case (CampgroundAmenity.SwimmingOcean):
                    return "Swimming Ocean";
                case (CampgroundAmenity.SwimmingRiver):
                    return "Swimming River";
                case (CampgroundAmenity.CampCabinsTrailers):
                    return "Camp Cabins/Trailers";
                case (CampgroundAmenity.CookingShelter):
                    return "Cooking Shelter";
                case (CampgroundAmenity.Laundromat):
                    return "Laundromat";
                case (CampgroundAmenity.OpenSites):
                    return "Open sites";
                case (CampgroundAmenity.Propane):
                    return "Propane";
                case (CampgroundAmenity.ShadedSites):
                    return "Shaded Sites";
                case (CampgroundAmenity.ShowersPay):
                    return "Showers (Pay)";
                case (CampgroundAmenity.Store):
                    return "Store";

                default:
                    return "ERROR";
            }
        }

        public static string GetCoreExperienceLabel(CoreExperience ce)
        {
            switch (ce)
            {
                case (CoreExperience.BeachesSeacoast):
                    return "Beaches seacoast";
                case (CoreExperience.CitiesTowns):
                    return "Cities & towns";
                case (CoreExperience.FoodWine):
                    return "Food & wine";
                case (CoreExperience.History):
                    return "History";
                case (CoreExperience.OurCulture):
                    return "Our culture";
                case (CoreExperience.OutdoorAdventure):
                    return "Outdoor adventure";
                default:
                    return "ERROR";
            }
        }

        public static string GetCulturalHeritageLabel(CulturalHeritage ch)
        {
            switch (ch)
            {
                case (CulturalHeritage.Acadian):
                    return "Acadian";
                case (CulturalHeritage.AfricanNovaScotian):
                    return "African Nova Scotian";
                case (CulturalHeritage.GaelicScottish):
                    return "Gaelic/Scottish";
                case (CulturalHeritage.Mikmaq):
                    return "Mikmaq";
                default:
                    return "ERROR";
            }
        }

        public static string GetEatAndDrinkTypeLabel(EatAndDrinkType t)
        {
            switch (t)
            {
                case (EatAndDrinkType.Brewery):
                    return "Brewery";
                case (EatAndDrinkType.BrewPub):
                    return "Brew Pub";
                case (EatAndDrinkType.Cidery):
                    return "Cidery";
                case (EatAndDrinkType.Distillery):
                    return "Distillery";
                case (EatAndDrinkType.SpecialtyFood):
                    return "Specialty Food";
                case (EatAndDrinkType.TasteOfNsRestaurant):
                    return "Taste of NS Restaurant";
                case (EatAndDrinkType.Winery):
                    return "Winery";
                default:
                    return "ERROR";
            }
        }

        public static string GetFeatureLabel(Feature f)
        {
            switch (f)
            {
                case (Feature.MultiLingual):
                    return "Bilingual/Multilingual";
                case (Feature.BusTours):
                    return "Bus tours";
                case (Feature.ChildrensActivities):
                    return "Children's activities";
                case (Feature.GiftShop):
                    return "Gift shop";
                case (Feature.InternetAccess):
                    return "Internet access";
                case (Feature.LimitedAccessibility):
                    return "Limited accessibility";
                case (Feature.MeetingFacilities):
                    return "Meeting facilities";
                case (Feature.OceanView):
                    return "Ocean view";
                case (Feature.Parking):
                    return "Parking";
                case (Feature.PicnicTables):
                    return "Picnic tables";
                case (Feature.PoolIndoor):
                    return "Pool (Indoor)";
                case (Feature.PoolOutdoor):
                    return "Pool (Outdoor)";
                case (Feature.PublicWashroom):
                    return "Public washroom";
                case (Feature.Restaurant):
                    return "Restaurant";
                case (Feature.SmokingPermitted):
                    return "Smoking permitted";
                case (Feature.Takeout):
                    return "Takeout";
                case (Feature.TeaRoom):
                    return "Tea room";
                case (Feature.TravelAgentCommission):
                    return "Travel agent commission";
                case (Feature.WheelChairAccessible):
                    return "Wheelchair accessible";
                default:
                    return "ERROR";
            }
        }

        public static string GetGovernmentLevelLabel(GovernmentLevel gl)
        {
            switch (gl)
            {
                case (GovernmentLevel.National):
                    return "National";
                case (GovernmentLevel.Provincial):
                    return "Provincial";
                default:
                    return "ERROR";
            }
        }

        public static string GetMediumLabel(Medium m)
        {
            switch (m)
            {
                case (Medium.BooksCards):
                    return "Books & cards";
                case (Medium.Candles):
                    return "Candles";
                case (Medium.Clay):
                    return "Clay";
                case (Medium.Fibre):
                    return "Fibre";
                case (Medium.Glass):
                    return "Glass";
                case (Medium.Leather):
                    return "Leather";
                case (Medium.Metal):
                    return "Metal";
                case (Medium.PaintingPrints):
                    return "Painting & prints";
                case (Medium.Paper):
                    return "Paper";
                case (Medium.Photography):
                    return "Photography";
                case (Medium.StoneBone):
                    return "Stone & bone";
                case (Medium.Wood):
                    return "Wood";
                default:
                    return "ERROR";
            }
        }

        public static string GetMembershipLabel(Membership m)
        {
            switch (m)
            {
                //case (Membership.Checkin):
                //    return "Checkin";
                case (Membership.Bienvenue):
                    return "Bienvenue";
                case (Membership.Coans):
                    return "COANS";
                case (Membership.GolfNs):
                    return "Golf NS";
                case (Membership.Hans):
                    return "HANS";
                case (Membership.Igns):
                    return "IGNS";
                case (Membership.Nsata):
                    return "NSATA";
                case (Membership.Nsbba):
                    return "NSBBA";
                case (Membership.Rans):
                    return "RANS";
                case (Membership.Tians):
                    return "TIANS";
                default:
                    return "ERROR";
            }
        }

        public static string GetPetsPolicyLabel(PetsPolicy pp)
        {
            switch (pp)
            {
                case (PetsPolicy.PetsLiveOnPremises):
                    return "Pets live on Premises";
                case (PetsPolicy.PetsNotWelcome):
                    return "Pets not welcome";
                case (PetsPolicy.PetsWelcome):
                    return "Pets allowed";
                default:
                    return "ERROR";
            }
        }

        public static string GetPrintOptionLabel(PrintOption po)
        {
            switch (po)
            {
                case (PrintOption.AddEnglishAdRef):
                    return "Add English Ad Ref";
                case (PrintOption.AddFrenchAdRef):
                    return "Add French Ad Ref";
                case (PrintOption.BrochureAvailable):
                    return "Brochure Available";
                case (PrintOption.HasEnglishGuideAd):
                    return "Has English Guide Ad";
                case (PrintOption.HasFrenchGuideAd):
                    return "Has French Guide Ad";
                case (PrintOption.PrintGps):
                    return "Print GPS";
                default:
                    return "ERROR";
            }
        }

        public static string GetProductCategoryLabel(ProductCategory pc)
        {
            switch (pc)
            {
                case (ProductCategory.Archive):
                    return "Archive";
                case (ProductCategory.BeachSupervised):
                    return "Beach (supervised)";
                case (ProductCategory.BeachUnsupervised):
                    return "Beach (unsupervised)";
                case (ProductCategory.BreweryDistillery):
                    return "Brewery/Distillery";
                case (ProductCategory.CasinoGaming):
                    return "Casino/Gaming";
                case (ProductCategory.Collection):
                    return "Collection";
                case (ProductCategory.DiveShop):
                    return "Dive Shop";
                case (ProductCategory.DrivingRange):
                    return "Driving range";
                case (ProductCategory.Economuseum):
                    return "Economuseum";
                case (ProductCategory.EquipmentRental):
                    return "Equipment rental";
                case (ProductCategory.FarmersMarket):
                    return "Farmers' Market";
                case (ProductCategory.FunPark):
                    return "Fun Park";
                case (ProductCategory.Garden):
                    return "Garden";
                case (ProductCategory.GolfCourse):
                    return "Golf Course";
                case (ProductCategory.HistoryHeritageSite):
                    return "History/Heritage Site";
                case (ProductCategory.InterpretiveCentre):
                    return "Interpretive centre";
                case (ProductCategory.Lighthouse):
                    return "Lighthouse";
                case (ProductCategory.MemorialMonument):
                    return "Memorial/Monument";
                case (ProductCategory.Museum):
                    return "Museum/Collection";
                case (ProductCategory.NonProfitArtGallery):
                    return "Non profit art gallery";
                case (ProductCategory.NoveltyGolfCourse):
                    return "Novelty activity";
                case (ProductCategory.Park):
                    return "Park";
                case (ProductCategory.SailingCharter):
                    return "Sailing Charters";
                case (ProductCategory.SailingInstructor):
                    return "Sailing Instructor";
                case (ProductCategory.ScienceCentre):
                    return "Science centre";
                case (ProductCategory.SpecialtyFoodShop):
                    return "Specialy food shop";
                case (ProductCategory.StockedPond):
                    return "Stocked pond";
                case (ProductCategory.TheatreVenue):
                    return "Theatre venue";
                case (ProductCategory.Trail):
                    return "Trail";
                case (ProductCategory.Unesco):
                    return "Unesco";
                case (ProductCategory.Waterfall):
                    return "Waterfall";
                case (ProductCategory.Winery):
                    return "Winery";
                case (ProductCategory.ZooWildlifeFarm):
                    return "Zoo/Wildlife/Farm";

                default:
                    return "ERROR";
            }
        }

        public static string GetRestaurantServiceLabel(RestaurantService rs)
        {
            switch (rs)
            {
                case (RestaurantService.BusToursWelcome):
                    return "Bus tours welcome";
                case (RestaurantService.ChildrensMenu):
                    return "Children menu";
                case (RestaurantService.Delivery):
                    return "Delivery";
                case (RestaurantService.DiningRoom):
                    return "Dining room";
                case (RestaurantService.Licensed):
                    return "Licensed";
                case (RestaurantService.LiveEntertainment):
                    return "Live entertainment";
                case (RestaurantService.Patio):
                    return "Patio";
                case (RestaurantService.ReservationsAccepted):
                    return "Reservations recommended";
                case (RestaurantService.SmokingArea):
                    return "Smoking area";
                case (RestaurantService.Takeout):
                    return "Takeout";
                default:
                    return "ERROR";
            }
        }

        public static string GetShareInformationWithLabel(ShareInformationWith siw)
        {
            switch (siw)
            {
                case (ShareInformationWith.Caa):
                    return "CAA";
                case (ShareInformationWith.CanadaSelect):
                    return "Canada Select";
                case (ShareInformationWith.NsApproved):
                    return "NS Approved";
                default:
                    return "ERROR";
            }
        }

        //public static string GetSmokingPolicyLabel(SmokingPolicy sp)
        //{
        //    switch (sp)
        //    {
        //        case (SmokingPolicy.NoSmoking):
        //            return "No Smoking";
        //        case (SmokingPolicy.SmokingPermitted):
        //            return "Smoking Permitted";
        //        default:
        //            return "ERROR";
        //    }
        //}

        public static string GetRatePeriodLabel(RatePeriod rp)
        {
            switch (rp)
            {
                case (RatePeriod.Daily):
                    return "Daily";
                case (RatePeriod.Monthly):
                    return "Monthly";
                case (RatePeriod.Weekly):
                    return "Weekly";
                default:
                    return "ERROR";
            }
        }

        public static string GetActionLabel(Action a)
        {
            switch (a)
            {
                case (Action.Add):
                    return "Add";
                case (Action.Edit):
                    return "Edit";
                case (Action.Delete):
                    return "Delete";
                default:
                    return "ERROR";
            }
        }

        public static string GetVersionHistoryTypeLabel(VersionHistoryType vht)
        {
            switch (vht)
            {
                case (VersionHistoryType.Media):
                    return "Media";
                case (VersionHistoryType.Product):
                    return "Product";
                case (VersionHistoryType.Url):
                    return "Url";
                case (VersionHistoryType.GuideDescription):
                    return "Guide Description";
                default:
                    return "ERROR";
            }
        }

        public static string GetUrlTypeLabel(UrlType ut)
        {
            switch (ut)
            {
                case (UrlType.Facebook):
                    return "Facebook";
                case (UrlType.Flickr):
                    return "Flickr";
                case (UrlType.General):
                    return "General";
                case (UrlType.NearbyLocation):
                    return "Nearby location";
                case (UrlType.TripAdvisor):
                    return "Trip advisor";
                case (UrlType.Twitter):
                    return "Twitter";
                case (UrlType.YouTubeChannel):
                    return "YouTube channel";
                case (UrlType.YouTube):
                    return "YouTube";
                case (UrlType.YouTubePlaylist):
                    return "YouTube playlist";
                case (UrlType.BookingDotCom):
                    return "Booking.com";
                case (UrlType.Pinterest):
                    return "Pinterest";
                case (UrlType.Instragram):
                    return "Instagram";
                default:
                    return "ERROR";
            }
        }

        public static string GetRestaurantTypeLabel(RestaurantType rt)
        {
            switch (rt)
            {
                case (RestaurantType.CoffeeShop):
                    return "Cafe/Tea Room";
                case (RestaurantType.Continental):
                    return "Continental";
                case (RestaurantType.FamilyDining):
                    return "Family dining";
                case (RestaurantType.FastFood):
                    return "Fast food";
                case (RestaurantType.FineDining):
                    return "Fine dining";
                case (RestaurantType.Gourmet):
                    return "Gourmet";
                case (RestaurantType.Informal):
                    return "Informal";
                case (RestaurantType.Lounge):
                    return "Lounge";
                case (RestaurantType.Pub):
                    return "Pub";
                default:
                    return "ERROR";
            }
        }

        public static string GetRestaurantSpecialtyLabel(RestaurantSpecialty rs)
        {
            switch (rs)
            {
                case (RestaurantSpecialty.Acadian):
                    return "Acadian";
                case (RestaurantSpecialty.Canadian):
                    return "Canadian";
                case (RestaurantSpecialty.Asian):
                    return "Asian";
                case (RestaurantSpecialty.European):
                    return "European";
                case (RestaurantSpecialty.FishAndChips):
                    return "Fish and chips";
                case (RestaurantSpecialty.PizzaAndBurgers):
                    return "Pizza/Burgers";
                case (RestaurantSpecialty.Sandwiches):
                    return "Sandwiches";
                case (RestaurantSpecialty.Seafood):
                    return "Seafood";
                case (RestaurantSpecialty.Steaks):
                    return "Steaks";
                case (RestaurantSpecialty.Vegetarian):
                    return "Vegetarian";

                case (RestaurantSpecialty.Latin):
                    return "Latin";
                case (RestaurantSpecialty.Indian):
                    return "Indian";
                case (RestaurantSpecialty.MiddleEastern):
                    return "Middle Eastern";
                case (RestaurantSpecialty.Desserts):
                    return "Dessert";
                case (RestaurantSpecialty.GlutenFree):
                    return "Gluten Free";

                default:
                    return "ERROR";
            }
        }

        public static string GetProductFieldLabel(ProductField pf)
        {
            switch (pf)
            {
                case (ProductField.ExternalLinkDescription):
                    return "Link description";
                case (ProductField.ExternalLinkTitle):
                    return "Link title";
                case (ProductField.MediaCaption):
                    return "Image caption";
                case (ProductField.MediaTitle):
                    return "Image title";
                case (ProductField.PrintDateDescription):
                    return "Print date details";
                case (ProductField.PrintDescription):
                    return "Print description";
                case (ProductField.PrintDirections):
                    return "Print directions";
                case (ProductField.PrintRateDescription):
                    return "Print rate details";
                case (ProductField.PrintUnitDescription):
                    return "Print unit description";
                case (ProductField.SupplementalDescription):
                    return "Activity description";
                case (ProductField.WebCancellationPolicy):
                    return "Web cancellation policy";
                case (ProductField.WebDateDescription):
                    return "Web date details";
                case (ProductField.WebDescription):
                    return "Web description";
                case (ProductField.WebDirections):
                    return "Web directions";
                case (ProductField.WebKeywords):
                    return "Web keywords";
                case (ProductField.WebRateDescription):
                    return "Web rate details";
                default:
                    return "ERROR";
            }
        }

        public static string GetTasteOfNsTypeLabel(TasteOfNsType t)
        {
            switch (t)
            {
                case (TasteOfNsType.CasualDining):
                    return "Chef-inspired Casual Dining";
                case (TasteOfNsType.FineDining):
                    return "Chef-inspired Fine Dining";
                case (TasteOfNsType.EssenceOfNs):
                    return "Essence of Nova Scotia";
                default:
                    return "ERROR";
            }
        }

        public static string GetTrailTypeLabel(TrailType tt)
        {
            switch (tt)
            {
                case (TrailType.DayUse):
                    return "Day-use trail";
                case (TrailType.Linear):
                    return "Linear park";
                case (TrailType.Urban):
                    return "Urban or community trail";
                case (TrailType.Wilderness):
                    return "Wilderness trail";
                default:
                    return "ERROR";
            }
        }

        public static string GetTrailSurfaceLabel(TrailSurface ts)
        {
            switch (ts)
            {
                case (TrailSurface.Gravel):
                    return "Gravel";
                case (TrailSurface.Hard):
                    return "Hard";
                case (TrailSurface.Natural):
                    return "Natural";
                default:
                    return "ERROR";
            }
        }

        public static string GetTrailPetsPolicyLabel(TrailPetsPolicy tpp)
        {
            switch (tpp)
            {
                case (TrailPetsPolicy.Leashed):
                    return "Leashed";
                case (TrailPetsPolicy.OffLeash):
                    return "Off leash";
                case (TrailPetsPolicy.NotAllowed):
                    return "Not allowed";
                default:
                    return "ERROR";
            }
        }

        public static string GetCellServiceLabel(CellService cs)
        {
            switch (cs)
            {
                case (CellService.Full):
                    return "Full";
                case (CellService.Partial):
                    return "Partial";
                case (CellService.NoService):
                    return "No service";
                default:
                    return "ERROR";
            }
        }
    }
}
