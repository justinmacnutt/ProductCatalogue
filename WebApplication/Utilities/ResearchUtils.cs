using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using ProductCatalogue.BusinessServices;
using ProductCatalogue.DataAccess.Enumerations;
using WebApplication.Admin.Research;

namespace WebApplication.Utilities
{
    public class ResearchUtils
    {
        public static OccupancyRowDefaults DeleteResearchRow(string productId, string year, string month)
        {
            var id = Int32.Parse(productId);
            var y = Int32.Parse(year);
            var m = Int32.Parse(month);

            var researchBs = new ResearchBs();
            var productBs = new ProductBs();

            var p = productBs.GetProduct(id);

            researchBs.DeleteAccommodationOccupancyData(id, y, m);

            int availableUnitsDay = (from pun in p.ProductUnitNumbers
                                     select pun.units).Sum();

            var researchClass = ResearchBs.GetResearchClass(p);
            var starRating = ResearchBs.GetResearchStarRating(p);

            var openDays = ((PeriodOfOperationType)p.periodOfOperationTypeId == PeriodOfOperationType.DateRange) ? GetDefaultOpenDays(m, y, p.openMonth, p.closeMonth, p.openDay, p.closeDay) : DateTime.DaysInMonth(y, m);

            var ord = new OccupancyRowDefaults
            {
                openDays = openDays.ToString(),
                productClass = (researchClass != null) ? ((int)researchClass).ToString() : "",
                productRating = (starRating != null) ? starRating.ratingValue.ToString() : "",
                units = availableUnitsDay.ToString()
            };
            
            return ord;
        }

        public static CampgroundOccupancyRowDefaults DeleteCampgroundResearchRow(string productId, string year, string month)
        {
            var id = Int32.Parse(productId);
            var y = Int32.Parse(year);
            var m = Int32.Parse(month);

            var researchBs = new ResearchBs();
            var productBs = new ProductBs();

            var p = productBs.GetProduct(id);

            researchBs.DeleteCampgroundOccupancyData(id, y, m);

            int seasonalUnitsDay = (from pun in p.ProductUnitNumbers
                                    where pun.unitTypeId == (int)ResearchUnitType.Seasonal
                                    select pun.units).Sum();

            int shortTermUnitsDay = (from pun in p.ProductUnitNumbers
                                     where pun.unitTypeId == (int)ResearchUnitType.ShortTerm
                                     select pun.units).Sum();

            
            var openDays = ((PeriodOfOperationType)p.periodOfOperationTypeId == PeriodOfOperationType.DateRange) ? GetDefaultOpenDays(m, y, p.openMonth, p.closeMonth, p.openDay, p.closeDay) : DateTime.DaysInMonth(y, m);

            var ord = new CampgroundOccupancyRowDefaults
            {
                openDays = openDays.ToString(),
                seasonalUnits = seasonalUnitsDay.ToString(),
                shortTermUnits = shortTermUnitsDay.ToString()
            };

            return ord;
        }

        public static int GetDefaultOpenDays(int theMonth, int theYear, int? openMonth, int? closeMonth, int? openDay, int? closeDay)
        {
            if (openMonth == null || closeMonth == null)
            {
                return DateTime.DaysInMonth(theYear, theMonth);
            }
            else if (closeMonth > theMonth && theMonth > openMonth)
            {
                return DateTime.DaysInMonth(theYear, theMonth);
            }
            else if (closeMonth < openMonth && theMonth > openMonth)
            {
                return DateTime.DaysInMonth(theYear, theMonth);
            }
            else if (theMonth == openMonth)
            {
                return DateTime.DaysInMonth(theYear, theMonth) - (openDay ?? 0);
            }
            else if (theMonth == closeMonth)
            {
                return closeDay ?? DateTime.DaysInMonth(theYear, theMonth);
            }
            else
            {
                return 0;
            }
        }

        public static bool ValidateCampgroundRowData(int month, int year, int? openDays, int? seasonalAvailable, int? shortTermAvailable, int? seasonalSold, int? shortTermSold, int? totalGuests)
        {

            if (openDays == null || seasonalAvailable == null || shortTermAvailable == null || seasonalSold == null || shortTermSold == null || totalGuests == null)
            {
                return false;
            }

            //ensure openDays is less than or equal to number of days in month
            if (openDays > DateTime.DaysInMonth(year, month))
            {
                return false;
            }

            if (seasonalSold > seasonalAvailable)
            {
                return false;
            }

            if (shortTermSold > ((openDays) * (shortTermAvailable)))
            {
                return false;
            }

            //if ((shortTermSold + (seasonalSold*openDays))> totalGuests)
            if (shortTermSold > totalGuests)
            {
                return false;
            }

            return true;
        }

        public static List<ListItem> GetResearchClassListItems()
        {
            List<ListItem> l = new List<ListItem>();

           // l.Add(new ListItem("Please select", ""));
            //            l.Add(new ListItem(ResourceUtils.GetCancellationPolicyLabel(CancellationPolicy.NoCancellations), ((int)CancellationPolicy.NoCancellations).ToString()));
            l.Add(new ListItem(ResourceUtils.GetResearchClassLabel(ResearchClass.Apartment), ((int)ResearchClass.Apartment).ToString()));
            l.Add(new ListItem(ResourceUtils.GetResearchClassLabel(ResearchClass.BedBreakfast), ((int)ResearchClass.BedBreakfast).ToString()));
            l.Add(new ListItem(ResourceUtils.GetResearchClassLabel(ResearchClass.BedBreakfastInn), ((int)ResearchClass.BedBreakfastInn).ToString()));
            l.Add(new ListItem(ResourceUtils.GetResearchClassLabel(ResearchClass.CottageCabin), ((int)ResearchClass.CottageCabin).ToString()));
            l.Add(new ListItem(ResourceUtils.GetResearchClassLabel(ResearchClass.Hostel), ((int)ResearchClass.Hostel).ToString()));
            l.Add(new ListItem(ResourceUtils.GetResearchClassLabel(ResearchClass.Hotel), ((int)ResearchClass.Hotel).ToString()));
            l.Add(new ListItem(ResourceUtils.GetResearchClassLabel(ResearchClass.HuntingLodge), ((int)ResearchClass.HuntingLodge).ToString()));
            l.Add(new ListItem(ResourceUtils.GetResearchClassLabel(ResearchClass.Inn), ((int)ResearchClass.Inn).ToString()));
            l.Add(new ListItem(ResourceUtils.GetResearchClassLabel(ResearchClass.Motel), ((int)ResearchClass.Motel).ToString()));
            l.Add(new ListItem(ResourceUtils.GetResearchClassLabel(ResearchClass.Resort), ((int)ResearchClass.Resort).ToString()));
            l.Add(new ListItem(ResourceUtils.GetResearchClassLabel(ResearchClass.TouristHome), ((int)ResearchClass.TouristHome).ToString()));
            l.Add(new ListItem(ResourceUtils.GetResearchClassLabel(ResearchClass.University), ((int)ResearchClass.University).ToString()));

            return l;
        }

        public class OccupancyRowDefaults
        {
            public string openDays { get; set; }
            public string units { get; set; }
            public string productClass { get; set; }
            public string productRating { get; set; }
        }

        public class CampgroundOccupancyRowDefaults
        {
            public string openDays { get; set; }
            public string seasonalUnits { get; set; }
            public string shortTermUnits { get; set; }
        }
    }
}