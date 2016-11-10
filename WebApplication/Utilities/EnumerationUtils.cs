using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using ProductCatalogue.DataAccess.Enumerations;
using Action = ProductCatalogue.DataAccess.Enumerations.Action;


namespace WebApplication.Utilities
{
    public class EnumerationUtils
    {
        public static ListItem GetDefaultListItem ()
        {
            ListItem li = new ListItem();
            li.Text = "Please select";
            li.Value = "";
            return li;
        }

        public static List<ListItem> GetDefaultListItems()
        {
            List<ListItem> l = new List<ListItem>();

            l.Insert(0, new ListItem("Please Select", string.Empty));

            return l;
        }
        
        public static List<ListItem> GetAttributeGroupListItems(bool includePleaseSelect)
        {
            List<ListItem> l = new List<ListItem>();

            var values = Enum.GetValues(typeof(AttributeGroup)).Cast<AttributeGroup>();

            foreach (var v in values)
            {
                l.Add(new ListItem(ResourceUtils.GetAttributeGroupLabel(v), ((int)v).ToString()));
            }

            l.Sort((thisItem, otherItem) => thisItem.Text.CompareTo(otherItem.Text));

            if (includePleaseSelect)
            {
                l.Insert(0, new ListItem("Please Select", string.Empty));
            }

            return l;
        }
        
        public static List<ListItem> GetAttributeGroupListItems(AttributeGroup ag, bool includePleaseSelect)
        {
            switch (ag)
            {
                case AttributeGroup.AccessAdvisor:
                    return GetEnumerationListItems<AccessAdvisor>(includePleaseSelect);
                case AttributeGroup.AccommodationAmenity:
                    return GetEnumerationListItems<AccommodationAmenity>(includePleaseSelect);
                case AttributeGroup.AccommodationService:
                    return GetEnumerationListItems<AccommodationService>(includePleaseSelect);
                case AttributeGroup.AccommodationType:
                    return GetEnumerationListItems<AccommodationType>(includePleaseSelect);
                case AttributeGroup.Activity:
                    return GetEnumerationListItems<Activity>(includePleaseSelect);
                case AttributeGroup.ApprovedBy:
                    return GetEnumerationListItems<ApprovedBy>(includePleaseSelect);
                case AttributeGroup.AreaOfInterest:
                    return GetEnumerationListItems<AreaOfInterest>(includePleaseSelect);
                case AttributeGroup.ArtType:
                    return GetEnumerationListItems<ArtType>(includePleaseSelect);
                case AttributeGroup.CampgroundAmenity:
                    return GetEnumerationListItems<CampgroundAmenity>(includePleaseSelect);
                case AttributeGroup.CellService:
                    return GetEnumerationListItems<CellService>(includePleaseSelect);
                case AttributeGroup.CoordinateEditChecks:
                    return GetEnumerationListItems<CoordinateEditChecks>(includePleaseSelect);
                case AttributeGroup.CoreExperience:
                    return GetEnumerationListItems<CoreExperience>(includePleaseSelect);
                case AttributeGroup.Cuisine:
                    return GetEnumerationListItems<Cuisine>(includePleaseSelect);
                case AttributeGroup.CulturalHeritage:
                    return GetEnumerationListItems<CulturalHeritage>(includePleaseSelect);
                case AttributeGroup.EditorChecks:
                    return GetEnumerationListItems<EditorCheck>(includePleaseSelect);
                case AttributeGroup.ExhibitType:
                    return GetEnumerationListItems<ExhibitType>(includePleaseSelect);
                case AttributeGroup.Feature:
                    return GetEnumerationListItems<Feature>(includePleaseSelect);
                case AttributeGroup.GovernmentLevel:
                    return GetEnumerationListItems<GovernmentLevel>(includePleaseSelect);
                case AttributeGroup.Medium:
                    return GetEnumerationListItems<Medium>(includePleaseSelect);
                case AttributeGroup.Membership:
                    return GetEnumerationListItems<Membership>(includePleaseSelect);
                case AttributeGroup.PetsPolicy:
                    return GetEnumerationListItems<PetsPolicy>(includePleaseSelect);
                case AttributeGroup.PrintOption:
                    return GetEnumerationListItems<PrintOption>(includePleaseSelect);
                case AttributeGroup.ProductCategory:
                    return GetEnumerationListItems<ProductCategory>(includePleaseSelect);
                case AttributeGroup.RestaurantService:
                    return GetEnumerationListItems<RestaurantService>(includePleaseSelect);
                case AttributeGroup.RestaurantSpecialty:
                    return GetEnumerationListItems<RestaurantSpecialty>(includePleaseSelect);
                case AttributeGroup.RestaurantType:
                    return GetEnumerationListItems<RestaurantType>(includePleaseSelect);
                case AttributeGroup.ShareInformationWith:
                    return GetEnumerationListItems<ShareInformationWith>(includePleaseSelect);
                case AttributeGroup.TourType:
                    return GetEnumerationListItems<TourType>(includePleaseSelect);
                case AttributeGroup.TrailPetsPolicy:
                    return GetEnumerationListItems<TrailPetsPolicy>(includePleaseSelect);
                case AttributeGroup.TrailSurface:
                    return GetEnumerationListItems<TrailSurface>(includePleaseSelect);
                case AttributeGroup.TrailType:
                    return GetEnumerationListItems<TrailType>(includePleaseSelect);
                case AttributeGroup.TransportationType:
                    return GetEnumerationListItems<TransportationType>(includePleaseSelect);
                default:
                    return new List<ListItem>();
            }
        }

        public static List<ListItem> GetEnumerationListItems<T>(bool includePleaseSelect)
        {
            var values = Enum.GetValues(typeof(T)).Cast<int>();

            List<ListItem> l = new List<ListItem>();

            foreach (var v in values)
            {
                l.Add(new ListItem(ResourceUtils.GetAttributeLabel(v), v.ToString()));
            }

            l.Sort((thisItem, otherItem) => thisItem.Text.CompareTo(otherItem.Text));

            if (includePleaseSelect)
            {
                l.Insert(0,new ListItem("Please Select", string.Empty));
            }

            return l;
        }

        public static List<ListItem> GetAccommodationAmenityListItems()
        {
            List<ListItem> l = new List<ListItem>();

            var values = Enum.GetValues(typeof(AccommodationAmenity)).Cast<AccommodationAmenity>();

            foreach (var v in values)
            {
                l.Add(new ListItem(ResourceUtils.GetAccommodationAmenityLabel(v), ((int)v).ToString()));
            }

            l.Sort((thisItem, otherItem) => thisItem.Text.CompareTo(otherItem.Text));

            return l;
        }

        public static List<ListItem> GetGuideSectionOutdoorsListItems(byte[] ids)
        {
            List<ListItem> l = new List<ListItem>();

            var values = Enum.GetValues(typeof(GuideSectionOutdoors)).Cast<GuideSectionOutdoors>();

            foreach (var v in values)
            {
                if (!ids.Contains((byte)v))
                {
                    l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(v), ((int)v).ToString()));
                }

            }

            l.Sort((thisItem, otherItem) => thisItem.Text.CompareTo(otherItem.Text));

            return l;
        }

        public static List<ListItem> GetGuideSectionTourOpsListItems(byte[] ids)
        {
            List<ListItem> l = new List<ListItem>();

            var values = Enum.GetValues(typeof(GuideSectionTourOps)).Cast<GuideSectionTourOps>();

            foreach (var v in values)
            {
                if (!ids.Contains((byte)v))
                {
                    l.Add(new ListItem(ResourceUtils.GetGuideSectionTourOpsLabel(v), ((int)v).ToString()));
                }

            }

            l.Sort((thisItem, otherItem) => thisItem.Text.CompareTo(otherItem.Text));

            return l;
        }

        public static List<ListItem> GetCapacityTypeListItems()
        {
            List<ListItem> l = new List<ListItem>();

            l.Add(new ListItem("Please select", ""));

            var values = Enum.GetValues(typeof(CapacityType)).Cast<CapacityType>();

            foreach (var v in values)
            {
                l.Add(new ListItem(ResourceUtils.GetCapacityTypeLabel(v), ((int)v).ToString()));
            }

            return l;
        }

        public static List<ListItem> GetSustainabilityTypeListItems()
        {
            List<ListItem> l = new List<ListItem>();

            l.Add(new ListItem("Please select", ""));

            var values = Enum.GetValues(typeof(SustainabilityType)).Cast<SustainabilityType>();

            foreach (var v in values)
            {
                l.Add(new ListItem(ResourceUtils.GetSustainabilityTypeLabel(v), ((int)v).ToString()));
            }

            return l;
        }

        public static List<ListItem> GetOwnershipTypeListItems()
        {
            List<ListItem> l = new List<ListItem>();

            l.Add(new ListItem("Please select", ""));

            var values = Enum.GetValues(typeof(OwnershipType)).Cast<OwnershipType>();

            foreach (var v in values)
            {
                l.Add(new ListItem(ResourceUtils.GetOwnershipTypeLabel(v), ((int)v).ToString()));
            }

            return l;
        }

       //public static List<ListItem> GetEnumerationListItems<T>()
        //{
        //    Type t = typeof(T);
        //    if (!t.IsEnum)
        //        throw new InvalidOperationException("Type is not Enum");

        //    List<ListItem> l = new List<ListItem>();
        //    l.Add(new ListItem("Please select", ""));

        //    if (t == typeof(ProductDescriptionType))
        //    {
        //        var values = Enum.GetValues(typeof(ProductDescriptionType)).Cast<ProductDescriptionType>();
        //        foreach (var v in values)
        //        {
        //            l.Add(new ListItem(ResourceUtils.GetProductDescriptionTypeLabel(v), ((int)v).ToString()));
        //        }
        //    }
        //    return l;
        //}

        public static List<ListItem> GetGuideSectionOutdoorsListItems()
        {
            List<ListItem> l = new List<ListItem>();

            l.Add(new ListItem("Please select", ""));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.Beaches), ((int)GuideSectionOutdoors.Beaches).ToString()));
           // l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.BoatTours), ((int)GuideSectionOutdoors.BoatTours).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.DiveShops), ((int)GuideSectionOutdoors.DiveShops).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.DogSledding), ((int)GuideSectionOutdoors.DogSledding).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.DrivingRanges), ((int)GuideSectionOutdoors.DrivingRanges).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.EquipmentRentals), ((int)GuideSectionOutdoors.EquipmentRentals).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.FishingGuides), ((int)GuideSectionOutdoors.FishingGuides).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.FishingStockedLakes), ((int)GuideSectionOutdoors.FishingStockedLakes).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.Flying), ((int)GuideSectionOutdoors.Flying).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.Geology), ((int)GuideSectionOutdoors.Geology).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.GolfCourses), ((int)GuideSectionOutdoors.GolfCourses).ToString()));
            //l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.Hunting), ((int)GuideSectionOutdoors.Hunting).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.NationalParks), ((int)GuideSectionOutdoors.NationalParks).ToString()));
            //l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.Outdoor), ((int)GuideSectionOutdoors.Outdoor).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.Photography), ((int)GuideSectionOutdoors.Photography).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.ProvincialParks), ((int)GuideSectionOutdoors.ProvincialParks).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.RidingHayRides), ((int)GuideSectionOutdoors.RidingHayRides).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.RiverRafting), ((int)GuideSectionOutdoors.RiverRafting).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.SailingInstruction), ((int)GuideSectionOutdoors.SailingInstruction).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.SailingLearnToSail), ((int)GuideSectionOutdoors.SailingLearnToSail).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.SailingMarinas), ((int)GuideSectionOutdoors.SailingMarinas).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.SkiingCrossCountry), ((int)GuideSectionOutdoors.SkiingCrossCountry).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.SkiingDownhill), ((int)GuideSectionOutdoors.SkiingDownhill).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.AirAdventure), ((int)GuideSectionOutdoors.AirAdventure).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.SleighRides), ((int)GuideSectionOutdoors.SleighRides).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.Snowmobiling), ((int)GuideSectionOutdoors.Snowmobiling).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.Snowshoeing), ((int)GuideSectionOutdoors.Snowshoeing).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.Surfing), ((int)GuideSectionOutdoors.Surfing).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionOutdoorsLabel(GuideSectionOutdoors.WalkingHikingTrails), ((int)GuideSectionOutdoors.WalkingHikingTrails).ToString()));

            return l;
        }

        public static List<ListItem> GetGuideSectionTourOpsListItems()
        {
            List<ListItem> l = new List<ListItem>();

            l.Add(new ListItem("Please select", ""));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionTourOpsLabel(GuideSectionTourOps.BoatToursCharters), ((int)GuideSectionTourOps.BoatToursCharters).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionTourOpsLabel(GuideSectionTourOps.Sightseeing), ((int)GuideSectionTourOps.Sightseeing).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionTourOpsLabel(GuideSectionTourOps.MultiDay), ((int)GuideSectionTourOps.MultiDay).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionTourOpsLabel(GuideSectionTourOps.MultiactivityAdventure), ((int)GuideSectionTourOps.MultiactivityAdventure).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionTourOpsLabel(GuideSectionTourOps.NatureWildlife), ((int)GuideSectionTourOps.NatureWildlife).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionTourOpsLabel(GuideSectionTourOps.OutdoorAdventure), ((int)GuideSectionTourOps.OutdoorAdventure).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionTourOpsLabel(GuideSectionTourOps.StepOnGuide), ((int)GuideSectionTourOps.StepOnGuide).ToString()));
            l.Add(new ListItem(ResourceUtils.GetGuideSectionTourOpsLabel(GuideSectionTourOps.Walking), ((int)GuideSectionTourOps.Walking).ToString()));

            return l;
        }

        public static List<ListItem> GetBusinessContactTypeListItems()
        {
            List<ListItem> l = new List<ListItem>();

            //l.Add(new ListItem("Please select", ""));
            l.Add(new ListItem(ResourceUtils.GetBusinessContactTypeLabel(BusinessContactType.Tourism), ((int)BusinessContactType.Tourism).ToString()));
            l.Add(new ListItem(ResourceUtils.GetBusinessContactTypeLabel(BusinessContactType.Research), ((int)BusinessContactType.Research).ToString()));

            return l;
        }

        public static List<ListItem> GetContactTypeListItems()
        {
            List<ListItem> l = new List<ListItem>();

            l.Add(new ListItem("Please select", ""));
            l.Add(new ListItem(ResourceUtils.GetContactTypeLabel(ContactType.Primary), ((int)ContactType.Primary).ToString()));
            l.Add(new ListItem(ResourceUtils.GetContactTypeLabel(ContactType.Secondary), ((int)ContactType.Secondary).ToString()));

            return l;
        }

        public static List<ListItem> GetAddressTypeListItems()
        {
            List<ListItem> l = new List<ListItem>();

            l.Add(new ListItem("Please select", ""));
            l.Add(new ListItem(ResourceUtils.GetAddressTypeLabel(AddressType.Civic), ((int)AddressType.Civic).ToString()));
            l.Add(new ListItem(ResourceUtils.GetAddressTypeLabel(AddressType.Mailing), ((int)AddressType.Mailing).ToString()));
            l.Add(new ListItem(ResourceUtils.GetAddressTypeLabel(AddressType.OffSeason), ((int)AddressType.OffSeason).ToString()));

            return l;
        }

        public static List<ListItem> GetFieldTypeListItems()
        {
            List<ListItem> l = new List<ListItem>();

            l.Add(new ListItem("Print", ((int)ProductFieldType.Print).ToString()));
            l.Add(new ListItem("Web", ((int)ProductFieldType.Web).ToString()));

            return l;
        }

        public static List<ListItem> GetFieldListItems()
        {
            List<ListItem> l = new List<ListItem>();

            l.Add(new ListItem("Please select", ""));
            l.Add(new ListItem("Cancellation policy", ((int)ProductField.WebCancellationPolicy).ToString()));
            l.Add(new ListItem("Date details", ((int)ProductField.WebDateDescription).ToString()));
            l.Add(new ListItem("Image caption", ((int)ProductField.MediaCaption).ToString()));
            l.Add(new ListItem("Image title", ((int)ProductField.MediaTitle).ToString()));
            l.Add(new ListItem("Keywords", ((int)ProductField.WebKeywords).ToString()));
            l.Add(new ListItem("Link description", ((int)ProductField.ExternalLinkDescription).ToString()));
            l.Add(new ListItem("Link title", ((int)ProductField.ExternalLinkTitle).ToString()));
            l.Add(new ListItem("Rate details", ((int)ProductField.WebRateDescription).ToString()));
            l.Add(new ListItem("Web description", ((int)ProductField.WebDescription).ToString()));
            l.Add(new ListItem("Web directions", ((int)ProductField.WebDirections).ToString()));

            return l;
        }

        public static List<ListItem> GetMediaTypeListItems()
        {
            List<ListItem> l = new List<ListItem>();

            var values = Enum.GetValues(typeof(MediaType)).Cast<MediaType>();

            foreach (var v in values)
            {
                l.Add(new ListItem(ResourceUtils.GetMediaTypeLabel(v), ((int)v).ToString()));
            }

            l.Sort((thisItem, otherItem) => thisItem.Text.CompareTo(otherItem.Text));

            l.Insert(0, new ListItem("Please Select", string.Empty));
            
            return l;
        }

        

        public static List<ListItem> GetMediaLanguageListItems()
        {
            List<ListItem> l = new List<ListItem>();

            l.Add(new ListItem("Please select", ""));
            l.Add(new ListItem("English", ((int)MediaLanguage.English).ToString()));
            l.Add(new ListItem("French", ((int)MediaLanguage.French).ToString()));
            l.Add(new ListItem("Bilingual", ((int)MediaLanguage.Bilingual).ToString()));

            return l;
        }

        

        //public static List<ListItem> GetCreditCardListItems()
        //{
        //    List<ListItem> l = new List<ListItem>();

        //    l.Add(new ListItem("American Express", ((int)CreditCard.AmericanExpress).ToString()));
        //    l.Add(new ListItem("DinersClub", ((int)CreditCard.DinersClub).ToString()));
        //    l.Add(new ListItem("Discover", ((int)CreditCard.Discover).ToString()));
        //    l.Add(new ListItem("MasterCard", ((int)CreditCard.Mastercard).ToString()));
        //    l.Add(new ListItem("Visa", ((int)CreditCard.Visa).ToString()));

        //    return l;
        //}

        //public static List<ListItem> GetPaymentTypeListItems()
        //{
        //    List<ListItem> l = new List<ListItem>();

        //    l.Add(new ListItem("Money/cash", ((int)PaymentType.CashMoney).ToString()));
        //    l.Add(new ListItem("PayPal", ((int)PaymentType.PayPal).ToString()));
        //    l.Add(new ListItem("Travellers Cheques", ((int)PaymentType.TravellersCheques).ToString()));
            
        //    return l;
        //}

        public static List<ListItem> GetLinkTypeListItems()
        {
            List<ListItem> l = new List<ListItem>();

            var values = Enum.GetValues(typeof(UrlType)).Cast<UrlType>();

            foreach (var v in values)
            {
                l.Add(new ListItem(ResourceUtils.GetUrlTypeLabel(v), ((int)v).ToString()));
            }

            l.Sort((thisItem, otherItem) => thisItem.Text.CompareTo(otherItem.Text));

            l.Insert(0, new ListItem("Please Select", string.Empty));

            return l;
        }

        
        public static List<ListItem> GetCaaLevelListItems(ProductType pt)
        {
            List<ListItem> l = new List<ListItem>();
            
            l.Add(new ListItem("Please select", ""));

            if (pt == ProductType.Campground)
            {
                l.Add(new ListItem("Primitive","0"));
                l.Add(new ListItem("Level 1", "1"));
                l.Add(new ListItem("Level 2", "2"));
                l.Add(new ListItem("Level 3", "3"));
            }
            else
            {
                l.Add(new ListItem("1", "1"));
                l.Add(new ListItem("2", "2"));
                l.Add(new ListItem("3", "3"));
                l.Add(new ListItem("4", "4"));
                l.Add(new ListItem("5", "5"));
            }

            return l;
        }

        //public static List<ListItem> GetCaaRatingListItems(int productTypeId)
        public static List<ListItem> GetCaaRatingListItems()
        {
            List<ListItem> l = new List<ListItem>();

         //   switch (productTypeId)
         //   {
         //       case ((int) ProductType.Accommodation):
                    l.Add(new ListItem("Please select", ""));
                    l.Add(new ListItem("Bed & breakfast", ((int)CaaRatingType.BedAndBreakfast).ToString()));
                    l.Add(new ListItem("Cabin/Cottage", ((int)CaaRatingType.CabinCottage).ToString()));
                    l.Add(new ListItem("Condominium", ((int)CaaRatingType.Condominium).ToString()));
                    l.Add(new ListItem("Country inn", ((int)CaaRatingType.CountryInn).ToString()));
                    l.Add(new ListItem("Hotel", ((int)CaaRatingType.Hotel).ToString()));
                    l.Add(new ListItem("Motel", ((int)CaaRatingType.Motel).ToString()));
                    l.Add(new ListItem("Vacation house", ((int)CaaRatingType.VacationRentalHouse).ToString()));
        //            break;
        //        case ((int) ProductType.Campground):
        //            l.Add(new ListItem("Campground", ((int)CaaRatingType.Campground).ToString()));
        //            break;
        //        default:
        //            break;
        //    }
            return l;
        }

        



        public static List<ListItem> GetPhoneTypeListItems()
        {
            List<ListItem> l = new List<ListItem>();

            l.Add(new ListItem("Please select", ""));
            l.Add(new ListItem("Primary", ((int)PhoneType.Primary).ToString()));
            l.Add(new ListItem("Home", ((int)PhoneType.Home).ToString()));
            l.Add(new ListItem("Mobile", ((int)PhoneType.Mobile).ToString()));
            l.Add(new ListItem("Off season", ((int)PhoneType.OffSeason).ToString()));
            l.Add(new ListItem("Fax", ((int)PhoneType.Fax).ToString()));

            return l;
        }

        public static List<ListItem> GetRateTypeListItems()
        {
            List<ListItem> l = new List<ListItem>();

            l.Add(new ListItem("Please select", ""));
            l.Add(new ListItem("Guaranteed", ((int) RateType.Gtd).ToString()));
            l.Add(new ListItem("Subject to change", ((int)RateType.Stc).ToString()));

            return l;
            
        }

        public static List<ListItem> GetRatePeriodListItems()
        {
            List<ListItem> l = new List<ListItem>();

            l.Add(new ListItem("Please select", ""));
            l.Add(new ListItem("Daily", ((int)RatePeriod.Daily).ToString()));
            l.Add(new ListItem("Weekly", ((int)RatePeriod.Weekly).ToString()));
            l.Add(new ListItem("Monthly", ((int)RatePeriod.Monthly).ToString()));

            return l;
        }

        public static List<ListItem> GetCancellationPolicyListItems()
        {
            List<ListItem> l = new List<ListItem>();

            l.Add(new ListItem("Please select", ""));
//            l.Add(new ListItem(ResourceUtils.GetCancellationPolicyLabel(CancellationPolicy.NoCancellations), ((int)CancellationPolicy.NoCancellations).ToString()));
            l.Add(new ListItem(ResourceUtils.GetCancellationPolicyLabel(CancellationPolicy.Noon), ((int)CancellationPolicy.Noon).ToString()));
            l.Add(new ListItem(ResourceUtils.GetCancellationPolicyLabel(CancellationPolicy.FourPm), ((int)CancellationPolicy.FourPm).ToString()));
            l.Add(new ListItem(ResourceUtils.GetCancellationPolicyLabel(CancellationPolicy.BookingSpecific), ((int)CancellationPolicy.BookingSpecific).ToString()));
            l.Add(new ListItem(ResourceUtils.GetCancellationPolicyLabel(CancellationPolicy.HalfDay), ((int)CancellationPolicy.HalfDay).ToString()));
            l.Add(new ListItem(ResourceUtils.GetCancellationPolicyLabel(CancellationPolicy.Day), ((int)CancellationPolicy.Day).ToString()));
            l.Add(new ListItem(ResourceUtils.GetCancellationPolicyLabel(CancellationPolicy.TwoDay), ((int)CancellationPolicy.TwoDay).ToString()));
            l.Add(new ListItem(ResourceUtils.GetCancellationPolicyLabel(CancellationPolicy.ThreeDay), ((int)CancellationPolicy.ThreeDay).ToString()));
            l.Add(new ListItem(ResourceUtils.GetCancellationPolicyLabel(CancellationPolicy.FiveDay), ((int)CancellationPolicy.FiveDay).ToString()));
            l.Add(new ListItem(ResourceUtils.GetCancellationPolicyLabel(CancellationPolicy.OneWeek), ((int)CancellationPolicy.OneWeek).ToString()));
            l.Add(new ListItem(ResourceUtils.GetCancellationPolicyLabel(CancellationPolicy.TwoWeek), ((int)CancellationPolicy.TwoWeek).ToString()));
            l.Add(new ListItem(ResourceUtils.GetCancellationPolicyLabel(CancellationPolicy.FourWeek), ((int)CancellationPolicy.FourWeek).ToString()));
            l.Add(new ListItem(ResourceUtils.GetCancellationPolicyLabel(CancellationPolicy.EightWeek), ((int)CancellationPolicy.EightWeek).ToString()));
            l.Add(new ListItem(ResourceUtils.GetCancellationPolicyLabel(CancellationPolicy.TwelveWeek), ((int)CancellationPolicy.TwelveWeek).ToString()));

            return l;
        }

        public static List<ListItem> GetAccommodationTypeListItems()
        {
            List<ListItem> l = new List<ListItem>();
            
            l.Add(new ListItem("Apartment", ((int) AccommodationType.Apartment).ToString()));
            l.Add(new ListItem("Bed & Breakfast", ((int) AccommodationType.BedAndBreakfast).ToString()));
            l.Add(new ListItem("Bed & Breakfast Inn", ((int) AccommodationType.BedAndBreakfastInn).ToString()));
            l.Add(new ListItem("Cabin", ((int) AccommodationType.Cabin).ToString()));
            l.Add(new ListItem("Condo", ((int) AccommodationType.Condo).ToString()));
            l.Add(new ListItem("Cottage", ((int) AccommodationType.Cottage).ToString()));
            l.Add(new ListItem("Dorm-style", ((int) AccommodationType.DormStyle).ToString()));
            l.Add(new ListItem("Guest Room", ((int) AccommodationType.GuestRoom).ToString()));
            l.Add(new ListItem("Hostel", ((int) AccommodationType.Hostel).ToString()));
            l.Add(new ListItem("Hotel", ((int) AccommodationType.Hotel).ToString()));
            l.Add(new ListItem("Inn", ((int) AccommodationType.Inn).ToString()));
            l.Add(new ListItem("Lodge", ((int) AccommodationType.Lodge).ToString()));
            l.Add(new ListItem("Mini Home", ((int) AccommodationType.MiniHome).ToString()));
            l.Add(new ListItem("Motel", ((int) AccommodationType.Motel).ToString()));
            l.Add(new ListItem("Resort", ((int) AccommodationType.Resort).ToString()));
            l.Add(new ListItem("Tourist Home", ((int) AccommodationType.TouristHome).ToString()));
            l.Add(new ListItem("Vacation Home", ((int)AccommodationType.VacationHome).ToString()));

            return l;
        }

        

        public static List<ListItem> GetProductTypeListItems()
        {
            List<ListItem> l = new List<ListItem>();

            l.Add(new ListItem("Please select", ""));
            l.Add(new ListItem("Accommodation",((int) ProductType.Accommodation).ToString()));
            l.Add(new ListItem("Attraction", ((int)ProductType.Attraction).ToString()));
            l.Add(new ListItem("Campground", ((int)ProductType.Campground).ToString()));
            l.Add(new ListItem("Eat & Drink", ((int)ProductType.EatAndDrink).ToString()));
            l.Add(new ListItem("Fine arts", ((int)ProductType.FineArts).ToString()));
            l.Add(new ListItem("Outdoors", ((int)ProductType.Outdoors).ToString()));
            l.Add(new ListItem("Restaurant", ((int)ProductType.Restaurants).ToString()));
            l.Add(new ListItem("Tour operator", ((int)ProductType.TourOps).ToString()));
            l.Add(new ListItem("Trails", ((int)ProductType.Trails).ToString()));
            l.Add(new ListItem("Transportation", ((int)ProductType.Transportation).ToString()));
            
            return l;
        }

        public static string GetAttributeLabel(AttributeGroup ag, int attributeId)
        {
            switch(ag)
            {
                case (AttributeGroup.AccommodationAmenity):
                    return ResourceUtils.GetAccommodationAmenityLabel((AccommodationAmenity)attributeId);
                case (AttributeGroup.AccommodationService):
                    return ResourceUtils.GetAccommodationServiceLabel((AccommodationService)attributeId);
                case (AttributeGroup.AccommodationType):
                    return ResourceUtils.GetAccommodationTypeLabel((AccommodationType)attributeId);
                case (AttributeGroup.Activity):
                    return ResourceUtils.GetActivityLabel((Activity)attributeId);
                case (AttributeGroup.ApprovedBy):
                    return ResourceUtils.GetApprovedByLabel((ApprovedBy)attributeId);
                case (AttributeGroup.AreaOfInterest):
                    return ResourceUtils.GetAreaOfInterestLabel((AreaOfInterest)attributeId);
                case (AttributeGroup.ArtType):
                    return ResourceUtils.GetArtTypeLabel((ArtType)attributeId);
                case (AttributeGroup.CampgroundAmenity):
                    return ResourceUtils.GetCampgroundAmenityLabel((CampgroundAmenity)attributeId);
                case (AttributeGroup.CoreExperience):
                    return ResourceUtils.GetCoreExperienceLabel((CoreExperience)attributeId);
                case (AttributeGroup.CulturalHeritage):
                    return ResourceUtils.GetCulturalHeritageLabel((CulturalHeritage)attributeId);
                case (AttributeGroup.EatAndDrinkType):
                    return ResourceUtils.GetEatAndDrinkTypeLabel((EatAndDrinkType)attributeId);
                case (AttributeGroup.Feature):
                    return ResourceUtils.GetFeatureLabel((Feature)attributeId);
                case (AttributeGroup.GovernmentLevel):
                    return ResourceUtils.GetGovernmentLevelLabel((GovernmentLevel)attributeId);
                case (AttributeGroup.Medium):
                    return ResourceUtils.GetMediumLabel((Medium)attributeId);
                case (AttributeGroup.Membership):
                    return ResourceUtils.GetMembershipLabel((Membership)attributeId);
                case (AttributeGroup.PetsPolicy):
                    return ResourceUtils.GetPetsPolicyLabel((PetsPolicy)attributeId);
                case (AttributeGroup.PrintOption):
                    return ResourceUtils.GetPrintOptionLabel((PrintOption)attributeId);
                case (AttributeGroup.ProductCategory):
                    return ResourceUtils.GetProductCategoryLabel((ProductCategory)attributeId);
                case (AttributeGroup.RestaurantService):
                    return ResourceUtils.GetRestaurantServiceLabel((RestaurantService)attributeId);
                case (AttributeGroup.ShareInformationWith):
                    return ResourceUtils.GetShareInformationWithLabel((ShareInformationWith)attributeId);
                case (AttributeGroup.TasteOfNsType):
                    return ResourceUtils.GetTasteOfNsTypeLabel((TasteOfNsType)attributeId);
                //case (AttributeGroup.SmokingPolicy):
                //    return ResourceUtils.GetSmokingPolicyLabel((SmokingPolicy)attributeId);
                default:
                    return "ERROR";
            }

        }

        

       private static CheckBox MakeAttributeCheckBox(int groupId, int attributeId, string attributeName, List<ProductCatalogue.DataAccess.ProductAttribute> pal)
        {
            CheckBox c = new CheckBox();
            c.ID = String.Format("{0}_{1}", groupId, attributeId);
            c.Text = attributeName;
 
            foreach (ProductCatalogue.DataAccess.ProductAttribute pa in pal)
            {
                if (pa.attributeId == attributeId && pa.attributeGroupId == groupId)
                {
                    c.Checked = true;
                    break;
                }
            }
            return c;
        }

    }
}
