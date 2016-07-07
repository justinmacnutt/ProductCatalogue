using System;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using System.Linq;
using System.Data.Linq.SqlClient;
using System.Text;
using System.Xml.Linq;
using ProductCatalogue.DataAccess;
using ProductCatalogue.DataAccess.Enumerations;

namespace ProductCatalogue.BusinessServices
{
    public class ResearchBs
    {
        private TourismDataContext db = new TourismDataContext(ConfigurationManager.ConnectionStrings["Tourism2ConnectionString"].ConnectionString);
        private ResearchDataContext researchDb = new ResearchDataContext(ConfigurationManager.ConnectionStrings["Tourism2ConnectionString"].ConnectionString);

        private const int ReportingRateMin = 85;
        private const int PropertyNumberMin = 6;

        private const int ChunkSize = 2000;

        private readonly List<int> _monthNos = new List<int> { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 };

        private class OccupancyReportRow
        {
            public int theMonth { get; set; }
            public int theYear { get; set; }
            public int totalUnitsSold { get; set; }
            public int rowCount { get; set; }
            public int openProperties { get; set; }
            public int openPropertiesReported { get; set; }
            public double reportingRate { get; set; }
            public int totalUnitsAvailable { get; set; }
            public int totalUnitsAvailableUnreported { get; set; }
            public double occupancyRate { get; set; }
            public double projectedUnitsSold { get; set; }
            public bool displayRow { get; set; }
            public string status { get; set; }
            public List<int> reportedProductIds { get; set; }
            public List<int> operationallyOpenProductIds { get; set; }

        }

        private class CampOccupancyReportRow
        {
            public int theMonth { get; set; }
            public int theYear { get; set; }
            public int seasonalSold { get; set; }
            public int shortTermSold { get; set; }
            public int totalUnitsSold { get; set; }
            public int rowCount { get; set; }
            public int openProperties { get; set; }
            public int openPropertiesReported { get; set; }
            public double reportingRate { get; set; }
            public int seasonalAvailable { get; set; }
            public int shortTermAvailable { get; set; }
            public int unitsAvailableReported { get; set; }
            public int seasonalAvailableUnreported { get; set; }
            public int shortTermAvailableUnreported { get; set; }
            public int unitsAvailableUnreported { get; set; }
            public int seasonalAvailableEstimated { get; set; }
            public int shortTermAvailableEstimated { get; set; }
            public int unitsAvailableEstimated { get; set; }
            public double seasonalOccupancyRate { get; set; }
            public double shortTermOccupancyRate { get; set; }
            public double occupancyRate { get; set; }
            public double projectedSeasonalSold { get; set; }
            public double projectedShortTermSold { get; set; }
            public double projectedUnitsSold { get; set; }
            public bool displayRow { get; set; }
            public string status { get; set; }
            public List<int> reportedProductIds { get; set; }
            public List<int> operationallyOpenProductIds { get; set; }
        }

        private class NonReportingReportRow
        {
            public string licenseNumber { get; set; }
            public int productId { get; set; }
            public string productName { get; set; }
            public string contactName { get; set; }
            public string nonReportingMonths { get; set; }
            public string officePhone { get; set; }
            public string mobilePhone { get; set; }
            public string totalUnits { get; set; }
            public string email { get; set; }
            public string isOpenAllYear { get; set; }
            public string region { get; set; }
            public int reportYear { get; set; }
        }

        private enum OccupancyReportGeographyType
        {
            Areas = 1,
            Counties = 2,
            Regions = 3
        }

        public IQueryable<AccommodationOccupancy> GetAccommodationOccupancyData(int productId, int year)
        {
            var q = from d in researchDb.AccommodationOccupancies
                    where d.reportDate.Year == year && d.productId == productId
                    select d;

            return q;
        }

        public IQueryable<CampgroundOccupancy> GetCampgroundOccupancyData(int productId, int year)
        {
            var q = from d in researchDb.CampgroundOccupancies
                    where d.reportDate.Year == year && d.productId == productId
                    select d;

            return q;
        }

        public IQueryable<AccommodationOccupancy> GetAccommodationOccupancyData(int productId, int year, int month)
        {
            var q = from d in researchDb.AccommodationOccupancies
                    where d.reportDate.Year == year && d.productId == productId && d.reportDate.Month == month
                    select d;

            return q;
        }

        public IQueryable<CampgroundOccupancy> GetCampgroundOccupancyData(int productId, int year, int month)
        {
            var q = from d in researchDb.CampgroundOccupancies
                    where d.reportDate.Year == year && d.productId == productId && d.reportDate.Month == month
                    select d;

            return q;
        }

        public void DeleteAccommodationOccupancyData(int productId, int year, int month)
        {
            var row = GetAccommodationOccupancyData(productId, year, month);
            researchDb.AccommodationOccupancies.DeleteAllOnSubmit(row);
            researchDb.SubmitChanges();
        }

        public void DeleteCampgroundOccupancyData(int productId, int year, int month)
        {
            var row = GetCampgroundOccupancyData(productId, year, month);
            researchDb.CampgroundOccupancies.DeleteAllOnSubmit(row);
            researchDb.SubmitChanges();
        }

        public IQueryable<Product> GetAccommodationsForBulkEdit(int month, int year)
        {
            return GetAccommodationsForBulkEdit(month, year, null, false);

            //return q.ToList().OrderBy(p => ConvertLicenseNumberToInt(p.licenseNumber)).ToList();
        }

        public IQueryable<Product> GetCampgroundsForBulkEdit(int month, int year)
        {
            return GetCampgroundsForBulkEdit(month, year, null, false);

            //return q.ToList().OrderBy(p => ConvertLicenseNumberToInt(p.licenseNumber)).ToList();
        }

        public IQueryable<Product> GetAccommodationsForBulkEdit(int month, int year, int? licenseNumber, bool includeRecentlySaved)
        {
            var accommodationsWithData = GetAccommodationsWithData(month, year, !includeRecentlySaved);
            //var nonOperationalProductIds = GetNonOperationalProducts(month, year);
            var productIdsToBeExcluded = accommodationsWithData.ToList();

            var myDate = new DateTime(year, month, 1);

            var q = from p in db.Products
                    join op in db.OperationPeriods on p.id equals op.productId
                    where p.productTypeId == (int) ProductType.Accommodation 
                    && !productIdsToBeExcluded.Contains(p.id) 
                    && !p.isDeleted
                    //&& (p.periodOfOperationTypeId != (int) PeriodOfOperationType.DateRange || (p.openMonth <= month && p.closeMonth >= month))
                    && (licenseNumber == null || Convert.ToInt32(p.licenseNumber) >= licenseNumber)
                    && (op.openDate <= myDate && (op.closeDate == null || op.closeDate > myDate))
                    orderby Convert.ToInt32(p.licenseNumber) 
                    //orderby p.licenseNumber 
                    select p;

            return q;

            //return q.ToList().OrderBy(p => ConvertLicenseNumberToInt(p.licenseNumber)).ToList();
        }

        public IQueryable<Product> GetCampgroundsForBulkEdit(int month, int year, string licenseNumber, bool includeRecentlySaved)
        {
            var campgroundsWithData = GetCampgroundsWithData(month, year, !includeRecentlySaved);
            //var nonOperationalProductIds = GetNonOperationalProducts(month, year);
            var productIdsToBeExcluded = campgroundsWithData.ToList();

            var myDate = new DateTime(year, month, 1);

            var q = from p in db.Products
                    join op in db.OperationPeriods on p.id equals op.productId
                    where p.productTypeId == (int)ProductType.Campground
                    && !productIdsToBeExcluded.Contains(p.id)
                    && !p.isDeleted
                        //&& (p.periodOfOperationTypeId != (int) PeriodOfOperationType.DateRange || (p.openMonth <= month && p.closeMonth >= month))
                    && (String.IsNullOrEmpty(licenseNumber) || p.licenseNumber.CompareTo(licenseNumber) >= 0)
                    && (op.openDate <= myDate && (op.closeDate == null || op.closeDate > myDate))
                    orderby p.licenseNumber
                    //orderby p.licenseNumber 
                    select p;

            return q;

            //return q.ToList().OrderBy(p => ConvertLicenseNumberToInt(p.licenseNumber)).ToList();
        }

        //public List<int> GetOperationalAccommodations(int month, int year)
        //{
        //    var myDate = new DateTime(year, month, 1);

        //    var q = (from p in db.Products
        //             join op in db.OperationPeriods on p.id equals op.productId into outerTemp
        //             from op in outerTemp.DefaultIfEmpty()
        //             where (op.openDate == null || op.openDate <= myDate) && (op.closeDate == null || op.closeDate > myDate)
        //             select p.id).ToList();

        //    return q;
        //}

        //public List<int> GetNonOperationalProducts(int month, int year, ProductType? pt)
        //{
        //    var myDate = new DateTime(year, month, 1);

        //    var q = (from op in db.OperationPeriods
        //             join p in db.Products on op.productId equals p.id
        //             where (pt == null || p.productTypeId == (int)pt) && ((op.openDate != null && op.openDate > myDate) || (op.closeDate != null && op.closeDate < myDate))
        //             select op.productId).ToList();

        //    return q;
        //}


        //public List<int> GetNonOperationalProducts(int month, int year)
        //{
        //    var myDate = new DateTime(year, month, 1);
            
        //    var q = (from op in db.OperationPeriods 
        //             join p in db.Products on op.productId equals p.id
        //             where (p.productTypeId == (int)ProductType.Accommodation || p.productTypeId == (int)ProductType.Campground) && 
        //             ((op.openDate != null && op.openDate > myDate) || (op.closeDate != null && op.closeDate < myDate))
        //             select op.productId).ToList();

        //    return q;
        //}

        public IQueryable<Product> SearchProducts(string productName, ProductType? pt)
        {
            var query = from p in db.Products
                        where p.productName.Contains(productName)
                        //orderby p.productName
                        select p;

            if (pt != null)
            {
                query = from p in query
                        where p.productTypeId == (int)pt
                        select p;
            }
            else
            {
                query = from p in query
                        where
                            p.productTypeId == (int)ProductType.Accommodation ||
                            p.productTypeId == (int)ProductType.Campground
                        select p;
            }

            query = from p in query
                    orderby p.productName
                    select p;

            return query;

        }

        public IQueryable<Product> GetProductsByLicenseNumber(List<string> licenseNumbers)
        {
            //var query = from p in db.Products
            //            where licenseNumbers.Contains(p.licenseNumber)
            //            select p;

            //return query;
            return GetProductsByLicenseNumber(licenseNumbers, null);
        }

        public IQueryable<Product> GetProductsByLicenseNumber(List<string> licenseNumbers, ProductType? pt)
        {
            var query = from p in db.Products
                        where licenseNumbers.Contains(p.licenseNumber)
                        && (pt == null || p.productTypeId == (int)pt.Value)
                        select p;

            //var query = from p in db.Products
            //            where "justin" == p.licenseNumber
            //            select p;

            return query;
        }

        public IQueryable<Product> GetProductsForResearch(List<int> productIds)
        {
            var query = from p in db.Products
                        where productIds.Contains(p.id)
                        orderby Convert.ToInt32(p.licenseNumber)
                        select p;

            return query;
        }

        public IQueryable<Product> GetProductsForResearch(List<int> productIds, ProductType pt)
        {
            var query = from p in db.Products
                        where productIds.Contains(p.id)
                        select p;

            if (pt == ProductType.Accommodation)
            {
                query = from p in query
                        orderby Convert.ToInt32(p.licenseNumber)
                        select p;
            }
            else
            {
                query = from p in query
                        orderby p.licenseNumber
                        select p;
            }

            return query;
        }
        
        public IQueryable<Product> GetAccommodations(string productName)
        {
            var q = from p in db.Products
                    where p.productTypeId == (int) ProductType.Accommodation
                    && p.productName.Contains(productName)
                    select p;

            return q;
        }

        public IQueryable<Product> GetCampgrounds(string productName)
        {
            var q = from p in db.Products
                    where p.productTypeId == (int)ProductType.Campground
                    && p.productName.Contains(productName)
                    select p;

            return q;
        }

        public Product GetAccommodationByName(string productName)
        {
            return db.Products.SingleOrDefault(p => p.productName == productName);
        }

        public List<int> GetAccommodationsWithData(int month, int year, bool includeRecentlySaved)
        {
            var maxModifiedDate = DateTime.Now.AddDays(-1);

            return (from d in researchDb.AccommodationOccupancies
                    where d.reportDate.Year == year && d.reportDate.Month == month && ((includeRecentlySaved) || (d.lastModifiedDate < maxModifiedDate))
                    select d.productId).ToList();
        }

        public List<int> GetCampgroundsWithData(int month, int year, bool includeRecentlySaved)
        {
            var maxModifiedDate = DateTime.Now.AddDays(-1);

            return (from d in researchDb.CampgroundOccupancies
                    where d.reportDate.Year == year && d.reportDate.Month == month && ((includeRecentlySaved) || (d.lastModifiedDate < maxModifiedDate))
                    select d.productId).ToList();
        }

        public IQueryable<AccommodationOccupancy> GetAccommodationsWithRecentlySavedData(int month, int year, DateTime minLastModifiedDate)
        {
            return from d in researchDb.AccommodationOccupancies
                    where d.reportDate.Year == year && d.reportDate.Month == month && d.lastModifiedDate > minLastModifiedDate
                    select d;
        }

        public IQueryable<CampgroundOccupancy> GetCampgroundsWithRecentlySavedData(int month, int year, DateTime minLastModifiedDate)
        {
            return from d in researchDb.CampgroundOccupancies
                   where d.reportDate.Year == year && d.reportDate.Month == month && d.lastModifiedDate > minLastModifiedDate
                   select d;
        }


        public byte? GetResearchUnitType(int productId)
        {
            var q = (from pun in db.ProductUnitNumbers
                     where pun.productId == productId
                     orderby pun.units descending
                     select pun.unitTypeId).FirstOrDefault();

            return q;
        }

        public static byte? GetResearchStarRatingOld(Product p)
        {
            var rc = GetResearchClass(p);

            switch (rc)
            {
                case ResearchClass.Apartment:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.CottageVacationHome
                                    || csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.TouristHome)
                            select (byte?)csr.ratingValue).Max();
                case ResearchClass.BedBreakfast:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.BedAndBreakfast
                                    || csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.TouristHome)
                            select (byte?)csr.ratingValue).Max();
                case ResearchClass.BedBreakfastInn:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.BedAndBreakfastInn)
                            select (byte?)csr.ratingValue).Max();
                case ResearchClass.CottageCabin:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.CottageVacationHome)
                            select (byte?)csr.ratingValue).Max();
                case ResearchClass.University:
                case ResearchClass.Hostel:
                    return null;
                case ResearchClass.TouristHome:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.TouristHome || csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.CottageVacationHome)
                            select (byte?)csr.ratingValue).Max();
                case ResearchClass.Hotel:
                case ResearchClass.Motel:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.HotelMotel)
                            select (byte?)csr.ratingValue).Max();
                case ResearchClass.Inn:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.Inn)
                            select (byte?)csr.ratingValue).Max();
                case ResearchClass.HuntingLodge:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.FishingHunting)
                            select (byte?)csr.ratingValue).Max();
                case ResearchClass.Resort:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.Resort)
                            select (byte?)csr.ratingValue).Max();
                default:
                    return null;
            }
        }

        public static ProductCanadaSelectRating GetResearchStarRating(Product p)
        {
            var rc = GetResearchClass(p);

            switch (rc)
            {
                case ResearchClass.Apartment:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int) CanadaSelectRatingType.CottageVacationHome
                                   || csr.canadaSelectRatingTypeId == (int) CanadaSelectRatingType.TouristHome)
                            orderby csr.ratingValue descending
                            select csr).FirstOrDefault();
                case ResearchClass.BedBreakfast:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.BedAndBreakfast
                                    || csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.TouristHome)
                            orderby csr.ratingValue descending
                            select csr).FirstOrDefault();
                case ResearchClass.BedBreakfastInn:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.BedAndBreakfastInn)
                            orderby csr.ratingValue descending
                            select csr).FirstOrDefault();
                case ResearchClass.CottageCabin:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.CottageVacationHome)
                            orderby csr.ratingValue descending
                            select csr).FirstOrDefault();
                case ResearchClass.University:
                case ResearchClass.Hostel:
                    return null;
                case ResearchClass.TouristHome:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.TouristHome || csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.CottageVacationHome)
                            orderby csr.ratingValue descending
                            select csr).FirstOrDefault();
                case ResearchClass.Hotel:
                case ResearchClass.Motel:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.HotelMotel)
                            orderby csr.ratingValue descending
                            select csr).FirstOrDefault();
                case ResearchClass.Inn:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.Inn)
                            orderby csr.ratingValue descending
                            select csr).FirstOrDefault();
                case ResearchClass.HuntingLodge:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.FishingHunting)
                            orderby csr.ratingValue descending
                            select csr).FirstOrDefault();
                case ResearchClass.Resort:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.Resort)
                            orderby csr.ratingValue descending
                            select csr).FirstOrDefault();
                case ResearchClass.Seasonal:
                case ResearchClass.ShortTerm:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.CampingFacilities)
                            orderby csr.ratingValue descending
                            select csr).FirstOrDefault();
                default:
                    return null;
            }
        }

        public static byte? GetResearchStarRating(ResearchUnitType rut, Product p)
        {
            switch (rut)
            {
                case ResearchUnitType.Apartment:
                case ResearchUnitType.GuestRoom:
                case ResearchUnitType.MiniHome:
                case ResearchUnitType.VacationHome:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.CottageVacationHome
                                    || csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.TouristHome)
                            select (byte?)csr.ratingValue).Max();
                case ResearchUnitType.BedBreakfast:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.BedAndBreakfast
                                    || csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.TouristHome)
                            select (byte?)csr.ratingValue).Max();
                case ResearchUnitType.BedBreakfastInn:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.BedAndBreakfastInn)
                            select (byte?)csr.ratingValue).Max();
                case ResearchUnitType.Cabin:
                case ResearchUnitType.CondoCottage:
                case ResearchUnitType.Cottage:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.CottageVacationHome)
                            select (byte?)csr.ratingValue).Max();
                case ResearchUnitType.DormStyle:
                case ResearchUnitType.Hostel:
                    return null;
                case ResearchUnitType.TouristHome:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.TouristHome)
                            select (byte?)csr.ratingValue).Max();
                case ResearchUnitType.Hotel:
                case ResearchUnitType.Motel:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.HotelMotel)
                            select (byte?)csr.ratingValue).Max();
                case ResearchUnitType.Inn:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.Inn)
                            select (byte?)csr.ratingValue).Max();
                case ResearchUnitType.Lodge:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.FishingHunting)
                            select (byte?)csr.ratingValue).Max();
                case ResearchUnitType.Resort:
                    return (from csr in p.ProductCanadaSelectRatings
                            where (csr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.Resort)
                            select (byte?)csr.ratingValue).Max();
                default:
                    return null;
            }
        }

       
        public static Dictionary<ResearchClass,int> GetResearchClassUnitTotals(Product p)
        {
            var researchClassUnits = new Dictionary<ResearchClass, int>() { };

            var unitList = (from pun in p.ProductUnitNumbers
                            select pun).ToList();

            foreach (var i in unitList)
            {
                var rc = GetResearchClass((ResearchUnitType)i.unitTypeId);
                if (rc != null)
                {
                    if (researchClassUnits.ContainsKey(rc.Value))
                    {
                        researchClassUnits[rc.Value] = researchClassUnits[rc.Value] + i.units;
                    }
                    else
                    {
                        researchClassUnits.Add(rc.Value, i.units);
                    }
                }
            }

            return researchClassUnits;
        }

        public static ResearchClass? GetResearchClass (Product p)
        {
            var researchClassUnits = GetResearchClassUnitTotals(p);

            return (researchClassUnits.Count > 0) ? researchClassUnits.Aggregate((l, r) => l.Value > r.Value ? l : r).Key : (ResearchClass?)null;
        }

        public static ResearchClass? GetResearchClass(ResearchUnitType rut)
        {
            switch (rut)
            {
                case ResearchUnitType.Apartment:
                    return ResearchClass.Apartment;
                case ResearchUnitType.BedBreakfast:
                    return ResearchClass.BedBreakfast;
                case ResearchUnitType.BedBreakfastInn:
                    return ResearchClass.BedBreakfastInn;
                case ResearchUnitType.Cabin:
                case ResearchUnitType.CondoCottage:
                case ResearchUnitType.Cottage:
                    return ResearchClass.CottageCabin;
                case ResearchUnitType.DormStyle:
                    return ResearchClass.University;
                case ResearchUnitType.GuestRoom:
                case ResearchUnitType.MiniHome:
                case ResearchUnitType.TouristHome:
                case ResearchUnitType.VacationHome:
                    return ResearchClass.TouristHome;
                case ResearchUnitType.Hostel:
                    return ResearchClass.Hostel;
                case ResearchUnitType.Hotel:
                    return ResearchClass.Hotel;
                case ResearchUnitType.Inn:
                    return ResearchClass.Inn;
                case ResearchUnitType.Lodge:
                    return ResearchClass.HuntingLodge;
                case ResearchUnitType.Motel:
                    return ResearchClass.Motel;
                case ResearchUnitType.Resort:
                    return ResearchClass.Resort;
                case ResearchUnitType.Seasonal:
                    return ResearchClass.Seasonal;
                case ResearchUnitType.ShortTerm:
                    return ResearchClass.ShortTerm;
            }
            //error
            return null;
        }

        private static int ConvertLicenseNumberToInt(string licenseNumber)
        {
            int myInteger;

            return Int32.TryParse(licenseNumber, out myInteger) ? myInteger : 0;
        }

        private static bool IsOperational(int productId, int year, int month)
        {
            ProductBs productBs = new ProductBs();
            var opl = productBs.GetProductOperationPeriods(productId).ToList();

            return IsOperational(opl, year, month);
        }

        private static bool IsOperational(List<OperationPeriod> opl, int year, int month)
        {
            //short circuit for products with no operational period data
            if (opl.Count == 0)
            {
                return true;
            }

            foreach (var op in opl)
            {
                if ((op.openDate.Year < year || (op.openDate.Year == year && op.openDate.Month <= month)) && (op.closeDate == null || (op.closeDate.Value.Year > year || (op.closeDate.Value.Year == year && op.closeDate.Value.Month >= month))))
                {
                    return true;
                }
            }
            return false;
        }

        public Contact GetResearchContact(int productId)
        {
            var productBs = new ProductBs();

            var cl = productBs.GetProductContacts(productId).ToList();

            var q = (from c in cl
                    where c.contactTypeId == (int)BusinessContactType.Research
                    select c).ToList();

            if (q.Count() > 0)
            {
                return q.First();
            }
            
            q = (from c in cl
                join cp in db.ContactProducts on c.id equals cp.contactId
                where cp.contactTypeId == (int)ContactType.Primary
                select c).ToList();

            if (q.Count() > 0)
            {
                return q.First();    
            }

            return null;
        }

        public static int GetEstimatedAvailableUnits (int year, int month, int productId)
        {
            return GetEstimatedAvailableUnits(year, month, productId, null, new List<int>(), new List<int>());
        }

        private static int GetEstimatedAvailableUnits(int year, int month, int productId, ResearchUnitType rut)
        {
            return GetEstimatedAvailableUnits(year, month, productId, rut, new List<int>(), new List<int>());
        }

        private static int GetEstimatedAvailableUnits(int year, int month, int productId, ResearchUnitType rut, List<int> starClasses)
        {
            return GetEstimatedAvailableUnits(year, month, productId, rut, new List<int>(), starClasses);
        }

        public static int GetEstimatedAvailableUnits(int year, int month, int productId, ResearchUnitType? rut, List<int> researchClasses, List<int> starClasses  )
        {
            var productBs = new ProductBs();
            var researchBs = new ResearchBs();
            var p = productBs.GetProduct(productId, true);
            //var opl = productBs.GetProductOperationPeriods(productId).ToList();

            bool meetsResearchClassCriteria = true;
            bool meetsStarClassCriteria = true;

            if (researchClasses.Count() != 0)
            {
                var productResearchClass = GetResearchClass(p);
                meetsResearchClassCriteria = (productResearchClass.HasValue && researchClasses.Contains((int) productResearchClass));
            }
            
            if (starClasses.Count() != 0)
            {
                var productResearchStarRating = GetResearchStarRating(p);
                meetsStarClassCriteria = (productResearchStarRating != null && starClasses.Contains(productResearchStarRating.ratingValue));
            }

            //ensure the product exists, that it meets the research class and star class criteria, and that the occupancy report does not already exist (perhaps under a different research class or star rating)
            if (p == null || !meetsResearchClassCriteria || !meetsStarClassCriteria || 
                (p.productTypeId == (int)ProductType.Accommodation && researchBs.GetAccommodationOccupancyData(productId, year, month).Count() != 0) ||
                (p.productTypeId == (int)ProductType.Campground && researchBs.GetCampgroundOccupancyData(productId, year, month).Count() != 0)
                )
            {
                return 0;
            }
            else
            {
                //var au = p.ProductUnitNumbers.Sum(z => z.units);

                var au = (from pun in p.ProductUnitNumbers
                          where rut == null || pun.unitTypeId == (int)rut
                          select pun.units).Sum(); 

                return ((p.periodOfOperationTypeId == (int)PeriodOfOperationType.DateRange)
                 ? GetDefaultOpenDays(month, year, p.openMonth, p.closeMonth, p.openDay, p.closeDay)
                 : DateTime.DaysInMonth(year, month)) * au;
            }
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
            else if (theMonth == openMonth)
            {
                return DateTime.DaysInMonth(theYear, theMonth) - (openDay ?? 0) + 1;
            }
            else if (theMonth == closeMonth)
            {
                return closeDay ?? DateTime.DaysInMonth(theYear, theMonth);
            }
            else if (openMonth > closeMonth && ((theMonth > openMonth) || (theMonth < closeMonth)))
            {
                return DateTime.DaysInMonth(theYear, theMonth);
            }
            else
            {
                return 0;
            }
        }

        public List<int> GetProductIdsByGeography(int geographyTypeId, List<int> geographyIds)
        {
            var pq = from p in db.Products
                     where p.productTypeId == (int)ProductType.Accommodation
                     select p;

            ProductBs productBs = new ProductBs();

            switch ((OccupancyReportGeographyType)geographyTypeId)
            {
                case OccupancyReportGeographyType.Areas:
                    pq = from p in pq
                         where (p.communityId != null && geographyIds.Contains((int)p.refCommunity.subRegionId))
                         select p;
                    break;
                case OccupancyReportGeographyType.Counties:
                    pq = from p in pq
                         where (p.communityId != null && geographyIds.Contains((int)p.refCommunity.countyId))
                         select p;
                    break;
                case OccupancyReportGeographyType.Regions:
                    pq = from p in pq
                         where (p.communityId != null && geographyIds.Contains(p.refCommunity.regionId))
                         select p;
                    break;
                default:
                    break;
            }

            return (from p in pq
                    select p.id).ToList();
        }

        private XElement GenerateOccupancyReportBody(List<int> productIds, List<int> years, bool enforceReportingRateMin, bool displayActuals, bool ignoreNumberMin, bool enforceOneThird)
        {
            return GenerateOccupancyReportBody(productIds, new List<int>(), new List<int>(), years, enforceReportingRateMin, displayActuals, ignoreNumberMin, enforceOneThird);  

        }

        private XElement GenerateOccupancyReportBody(List<int> productIds, List<int> researchClasses, List<int> starClasses, List<int> years, bool enforceReportingRateMin, bool displayActuals, bool ignoreNumberMin, bool enforceOneThird)
        {
            var myIds = new List<int>();

            var productBs = new ProductBs();

            // Query to get all REPORTED data for the supplied product ids
            var tq = from r in researchDb.AccommodationOccupancies
                     where (myIds.Count > 0 && myIds.Contains(r.productId)) 
                     && years.Contains(r.reportDate.Year)
                     && (starClasses.Count == 0 || starClasses.Contains((int)r.starClassRating))
                     && (researchClasses.Count == 0 || researchClasses.Contains((int)r.accommodationTypeId))
                     select r;

            var q2 = new List<AccommodationOccupancy>();
            
            //CHUNK out the ids to overcome LINQ parameter limitation (as a result of the productIds.Contains clause in tq query above
            for (var j = 0; j <= myIds.Count; j += ChunkSize)
            {
                myIds = productIds.GetRange(j, (productIds.Count - j > ChunkSize) ? ChunkSize : productIds.Count - j);
                q2.AddRange(tq.ToList());
            }

            //var reportedIds = (from ao in q2 select ao.productId).Distinct().ToList();

            // Actually Get all REPORTED data for the supplied product ids
            var q = from ao in q2
                    group ao by new {ao.reportDate.Year, ao.reportDate.Month} into a
                      select new OccupancyReportRow
                      {
                          theMonth = a.Key.Month,
                          theYear = a.Key.Year,
                          totalUnitsSold = a.Sum(z => z.totalUnitsSold).HasValue ? a.Sum(z => z.totalUnitsSold).Value : 0,
                          rowCount = a.Count(),
                          openPropertiesReported = a.Sum(z => (z.daysOpen > 0) ? 1 : 0),
                          totalUnitsAvailable = a.Sum(z => (z.unitsAvailable * z.daysOpen)),
                          totalUnitsAvailableUnreported = 0, //set to 0 for now, will update later in code
                          displayRow = true,
                          reportedProductIds = a.Select(z => z.productId).ToList(),
                          operationallyOpenProductIds = new List<int>()
                      };

            //var unreportedProductIds = productIds.Except(q.Select(z => z.productId).ToList());

            //Generate monthly rows in the report for which NO data has been reported for the supplied productids
            foreach (var year in years)
            {
                var usedMonths = (from ae in q
                                  where ae.theYear == year
                                  select ae.theMonth).ToList();

                var nullRows = (from m in _monthNos
                                where !usedMonths.Contains(m)
                                select new OccupancyReportRow
                                {
                                    theMonth = m,
                                    theYear = year,
                                    totalUnitsSold = 0,
                                    rowCount = 0,
                                    reportingRate = 0,
                                    totalUnitsAvailable = 0,
                                    totalUnitsAvailableUnreported = 0,
                                    reportedProductIds = new List<int>(),
                                    operationallyOpenProductIds = new List<int>()
                                }).ToList();

                q = q.Union(nullRows).ToList();
            }

            q = q.OrderBy(a => a.theYear).ThenBy(a => a.theMonth).ToList();

            //Cycle through all rows of the report, and for each, calculate open properties, totalUnitsAvailableUnreported, occupancyRate, reportingRate, and projectedUnitsSold
            (from j in q
             select j).ToList().ForEach(delegate(OccupancyReportRow row)
             {
                 row.operationallyOpenProductIds = CalculateOpenProperties(row.theYear, row.theMonth, productIds);
                 row.openProperties = row.operationallyOpenProductIds.Count;
                 row.totalUnitsAvailableUnreported = CalculateUnreportedUnitsAvailable(row.theYear, row.theMonth, row.operationallyOpenProductIds, row.reportedProductIds, researchClasses, starClasses);
                 row.occupancyRate = CalculateOccupancyRate(row.totalUnitsAvailable, row.totalUnitsSold);
                 row.reportingRate = CalculateReportingRate(row.totalUnitsAvailable, row.totalUnitsAvailableUnreported);
                 row.projectedUnitsSold = CalculateProjectedUnitsSold(row.totalUnitsAvailable, row.totalUnitsSold, row.totalUnitsAvailableUnreported);
             });

            //Cycle through all rows of the report and for each determine whether the report row should be hidden based on the supplied report variables enforceREportingRateMin, ignoreNumberMin, and enforceOneThird  
            (from h in q
             where HideOccupancyReportRow(enforceReportingRateMin, ignoreNumberMin, enforceOneThird, (h.totalUnitsAvailable + h.totalUnitsAvailableUnreported), productIds, h.reportedProductIds, h.theYear, h.theMonth, h.reportingRate, h.openPropertiesReported, researchClasses, starClasses)
             select h).ToList().ForEach(delegate(OccupancyReportRow row)
             {
                 row.displayRow = false;
             });

            var distinctYears = (from y in q
                                 select y.theYear).Distinct();


            XElement reportDataXml = new XElement("reports",
                                          (from y in distinctYears
                                           select new XElement("report",
                                                                new XAttribute("id", y.ToString()),
                                                               from h in q
                                                               where h.theYear == y
                                                               select new XElement("month",
                                                                                   new XAttribute("id", h.theMonth),
                                                                                   new XAttribute("shortName", new DateTime(1, h.theMonth, 1).ToString("MMM")),
                                                                                   new XElement("totalUnitsAvailable", (h.totalUnitsAvailable + h.totalUnitsAvailableUnreported)),
                                                                                   new XElement("totalUnitsAvailableReported", h.totalUnitsAvailable),
                                                                                   new XElement("totalUnitsSold", h.totalUnitsSold),
                                                                                   new XElement("projectedUnitsSold", h.projectedUnitsSold),
                                                                                   new XElement("occupancyRate", Math.Round(h.occupancyRate * 100, 1)),
                                                                                   new XElement("rowCount", h.rowCount),
                                                                                   new XElement("openProperties", h.openProperties),
                                                                                   new XElement("openPropertiesReported", h.openPropertiesReported),
                                                                                   new XElement("reportingRate", Math.Round(h.reportingRate * 100, 1)),
                                                                                   new XElement("displayRow", h.displayRow)
                                                                   ),
                                                                   from t in q
                                                                   where t.theYear == y && t.displayRow
                                                                   group t by new { t.theYear } into a
                                                                   select new XElement("summary",
                                                                                       new XElement("occupancyRateAvg", a.Sum(z => z.totalUnitsAvailable) > 0 ? Math.Round(Convert.ToDouble(a.Sum(z => z.totalUnitsSold)) / a.Sum(z => z.totalUnitsAvailable) * 100, 1) : 0),
                                                                                       new XElement("totalUnitsAvailableSum", a.Sum(z => z.totalUnitsAvailable + z.totalUnitsAvailableUnreported)),
                                                                                       new XElement("totalUnitsAvailableReportedSum", a.Sum(z => z.totalUnitsAvailable)),
                                                                                       new XElement("totalUnitsSoldSum", a.Sum(z => z.totalUnitsSold)),
                                                                                       new XElement("projectedUnitsSoldSum", a.Sum(z => z.projectedUnitsSold)),
                                                                                       new XElement("reportingRateAvg", Math.Round(CalculateReportingRate(a.Sum(z => z.totalUnitsAvailable), a.Sum(z => z.totalUnitsAvailableUnreported)) * 100, 1))
                                                                       )

                                               )
                                          )
                                  );

            return reportDataXml;

        }

        public XDocument GenerateOccupancyReportXml(List<int> productIds, List<int> years, bool enforceReportingRateMin, bool displayActuals, bool ignoreNumberMin, bool enforceOneThird, string clientName, string description)
        {
            //Get the products based on supplied product ids
            var query = from p in db.Products
                        where (productIds.Count > 0 && productIds.Contains(p.id))
                        orderby Convert.ToInt32(p.licenseNumber)
                        select p;

            XDocument xdoc = new XDocument();
            XElement metaDataXml = new XElement("metaData",
                                                new XElement("clientName", clientName),
                                                new XElement("description", description),
                                                new XElement("years", string.Join(",", years.Select(z => z.ToString()).ToArray())),
                                                new XElement("displayActuals", displayActuals)
                                               );

            XElement productListXml = new XElement("products",
                                                  from p in query
                                                  select new XElement("product",
                                                                        new XAttribute("id", p.id),
                                                                        new XElement("productName", p.productName),
                                                                        new XElement("licenseNumber", p.licenseNumber)
                                                                      )
                                                         );

            var reportDataXml = GenerateOccupancyReportBody(productIds, years,
                                                            enforceReportingRateMin, displayActuals, ignoreNumberMin,
                                                            enforceOneThird);

            xdoc.Add(new XElement("reportFile", metaDataXml, productListXml, reportDataXml));

            return xdoc;
        }

        public XDocument GenerateOccupancyReportXml(int geographyTypeId, List<int> geographyIds, List<int> researchClasses, List<int> starClasses, List<int> years, bool enforceReportingRateMin, bool enforceOneThird, bool displayActuals, bool ignoreNumberMin, string clientName, string description)
        {
            XDocument xdoc = new XDocument();

            XElement geographyTypeXml = new XElement("geographyTypeLabel");
            XElement geographicAreasXml = new XElement("geographicAreas");
            XElement accommodationTypesXml = new XElement("accommodationTypes");

            accommodationTypesXml.SetValue(string.Join(", ", (from at in researchClasses select GetResearchClassLabel((ResearchClass)at)).ToArray()));

            var pq = from p in db.Products
                     where p.productTypeId == (int)ProductType.Accommodation
                     select p;

            ProductBs productBs = new ProductBs();

            switch ((OccupancyReportGeographyType)geographyTypeId)
            {
                case OccupancyReportGeographyType.Areas:
                    geographyTypeXml.SetValue("Areas");
                    geographicAreasXml.SetValue(string.Join(", ", (from sr in productBs.GetSubRegions(geographyIds) select sr.subRegionName).ToArray()));

                    pq = from p in pq
                         where (p.communityId != null && geographyIds.Contains((int)p.refCommunity.subRegionId))
                         select p;
                    break;
                case OccupancyReportGeographyType.Counties:
                    geographyTypeXml.SetValue("Counties");
                    geographicAreasXml.SetValue(string.Join(", ", (from c in productBs.GetCounties(geographyIds) select c.countyName).ToArray()));

                    pq = from p in pq
                         where (p.communityId != null && geographyIds.Contains((int)p.refCommunity.countyId))
                         select p;
                    break;
                case OccupancyReportGeographyType.Regions:
                    geographyTypeXml.SetValue("Regions");
                    geographicAreasXml.SetValue(string.Join(", ", (from r in productBs.GetRegions(geographyIds) select r.regionName).ToArray()));

                    pq = from p in pq
                         where (p.communityId != null && geographyIds.Contains(p.refCommunity.regionId))
                         select p;
                    break;
            }

            XElement metaDataXml = new XElement("metaData",
                                                new XElement("clientName", clientName),
                                                new XElement("description", description),
                                                new XElement("years", string.Join(", ", years.Select(z => z.ToString()).ToArray())),
                                                new XElement("starClasses", string.Join(", ", starClasses.Select(z => String.Format("{0:0.0}", (double)z / 2)).ToArray())),
                                                new XElement("displayActuals", displayActuals),
                                                geographyTypeXml,
                                                geographicAreasXml,
                                                accommodationTypesXml
                                               );

            List<int> productIds = (from p in pq
                                    select p.id).ToList();

            var reportDataXml = GenerateOccupancyReportBody(productIds, researchClasses, starClasses, years,
                                                            enforceReportingRateMin, displayActuals, ignoreNumberMin,
                                                            enforceOneThird);

            xdoc.Add(new XElement("reportFile", metaDataXml, reportDataXml));

            return xdoc;
        }

        private XElement GenerateCampOccupancyReportBody(List<int> productIds, List<int> years, bool enforceReportingRateMin, bool ignoreNumberMin, bool enforceOneThird)
        {
            return GenerateCampOccupancyReportBody(productIds, new List<int>(), years, enforceReportingRateMin, ignoreNumberMin, enforceOneThird);
        }

        private XElement GenerateCampOccupancyReportBody(List<int> productIds, List<int> starClasses, List<int> years, bool enforceReportingRateMin, bool ignoreNumberMin, bool enforceOneThird)
        {
            var myIds = new List<int>();

            // Query to get all REPORTED data for the supplied product ids
            var tq = from r in researchDb.CampgroundOccupancies
                     where (myIds.Count > 0 && myIds.Contains(r.productId))
                     && years.Contains(r.reportDate.Year)
                     && (starClasses.Count == 0 || starClasses.Contains((int)r.starClassRating))
                     select r;

            var q2 = new List<CampgroundOccupancy>();

            //CHUNK out the ids to overcome LINQ parameter limitation (as a result of the productIds.Contains clause in tq query above
            for (var j = 0; j <= myIds.Count; j += ChunkSize)
            {
                myIds = productIds.GetRange(j, (productIds.Count - j > ChunkSize) ? ChunkSize : productIds.Count - j);
                q2.AddRange(tq.ToList());
            }

            // Actually Get all REPORTED data for the supplied product ids
            var q = from ao in q2
                    group ao by new { ao.reportDate.Year, ao.reportDate.Month } into a
                    select new CampOccupancyReportRow
                    {
                        theMonth = a.Key.Month,
                        theYear = a.Key.Year,
                        seasonalSold = a.Sum(z => z.seasonalSold * z.daysOpen).HasValue ? a.Sum(z => z.seasonalSold * z.daysOpen).Value : 0,
                        shortTermSold = a.Sum(z => z.shortTermSold).HasValue ? a.Sum(z => z.shortTermSold).Value : 0,
                        totalUnitsSold = 0, //set to 0 for now, will update later in code
                        rowCount = a.Count(),
                        openPropertiesReported = a.Sum(z => (z.daysOpen > 0) ? 1 : 0),
                        //reportingRate = Convert.ToDouble(a.Count()) / Convert.ToDouble(productIds.Count),
                        seasonalAvailable = a.Sum(z => (z.seasonalAvailable * z.daysOpen)),
                        shortTermAvailable = a.Sum(z => (z.shortTermAvailable * z.daysOpen)),
                        unitsAvailableReported = 0, //set to 0 for now, will update later in code
                        seasonalAvailableUnreported = 0, //set to 0 for now, will update later in code
                        shortTermAvailableUnreported = 0, //set to 0 for now, will update later in code
                        unitsAvailableUnreported = 0, //set to 0 for now, will update later in code
                        seasonalAvailableEstimated = 0,//set to 0 for now, will update later in code
                        shortTermAvailableEstimated = 0,//set to 0 for now, will update later in code
                        unitsAvailableEstimated = 0,//set to 0 for now, will update later in code
                        //displayRow = DisplayOccupancyReportRow(enforceReportingRateMin, ignoreNumberMin, Convert.ToDouble(a.Count()) / Convert.ToDouble(productIds.Count), a.Count())
                        displayRow = true,
                        reportedProductIds = a.Select(z => z.productId).ToList(),
                        operationallyOpenProductIds = new List<int>()
                    };

            foreach (var year in years)
            {
                var usedMonths = (from ae in q
                                  where ae.theYear == year
                                  select ae.theMonth).ToList();

                var nullRows = (from m in _monthNos
                                where !usedMonths.Contains(m)
                                select new CampOccupancyReportRow
                                {
                                    theMonth = m,
                                    theYear = year,
                                    seasonalSold = 0,
                                    shortTermSold = 0,
                                    totalUnitsSold = 0,
                                    rowCount = 0,
                                    reportingRate = 0,
                                    seasonalAvailable = 0,
                                    shortTermAvailable = 0,
                                    unitsAvailableReported = 0, //set to 0 for now, will update later in code
                                    seasonalAvailableUnreported = 0, //set to 0 for now, will update later in code
                                    shortTermAvailableUnreported = 0, //set to 0 for now, will update later in code
                                    unitsAvailableUnreported = 0, //set to 0 for now, will update later in code
                                    seasonalAvailableEstimated = 0,//set to 0 for now, will update later in code
                                    shortTermAvailableEstimated = 0,//set to 0 for now, will update later in code
                                    unitsAvailableEstimated = 0,//set to 0 for now, will update later in code
                                    operationallyOpenProductIds = new List<int>()
                                }).ToList();

                q = q.Union(nullRows).ToList();
            }

            q = q.OrderBy(a => a.theYear).ThenBy(a => a.theMonth).ToList();

            (from j in q
             select j).ToList().ForEach(delegate(CampOccupancyReportRow row)
             {
                 row.operationallyOpenProductIds = CalculateOpenProperties(row.theYear, row.theMonth, productIds);
                 row.openProperties = row.operationallyOpenProductIds.Count;
                 row.totalUnitsSold = row.seasonalSold + row.shortTermSold;
                 row.unitsAvailableUnreported = CalculateCampUnreportedUnitsAvailable(row.theYear, row.theMonth, row.operationallyOpenProductIds, row.reportedProductIds, starClasses);
                 row.seasonalAvailableUnreported = CalculateCampUnreportedUnitsAvailable(row.theYear, row.theMonth, row.operationallyOpenProductIds,row.reportedProductIds, starClasses, ResearchUnitType.Seasonal);
                 row.shortTermAvailableUnreported = CalculateCampUnreportedUnitsAvailable(row.theYear, row.theMonth, row.operationallyOpenProductIds, row.reportedProductIds, starClasses, ResearchUnitType.ShortTerm);
                 row.seasonalOccupancyRate = CalculateOccupancyRate(row.seasonalAvailable, row.seasonalSold);
                 row.shortTermOccupancyRate = CalculateOccupancyRate(row.shortTermAvailable, row.shortTermSold);
                 row.occupancyRate = CalculateOccupancyRate((row.seasonalAvailable + row.shortTermAvailable), (row.shortTermSold + row.seasonalSold));
                 row.reportingRate = CalculateReportingRate((row.shortTermAvailable + row.seasonalAvailable), row.unitsAvailableUnreported);
                 row.projectedUnitsSold = CalculateProjectedUnitsSold((row.shortTermAvailable + row.seasonalAvailable), (row.seasonalSold + row.shortTermSold), row.unitsAvailableUnreported);
                 row.projectedSeasonalSold = CalculateProjectedUnitsSold(row.seasonalAvailable, row.seasonalSold, row.seasonalAvailableUnreported);
                 row.projectedShortTermSold = CalculateProjectedUnitsSold(row.shortTermAvailable, row.shortTermSold, row.shortTermAvailableUnreported);
                 
                 row.unitsAvailableReported = row.seasonalAvailable + row.shortTermAvailable;
                 row.seasonalAvailableEstimated = row.seasonalAvailable + row.seasonalAvailableUnreported;
                 row.shortTermAvailableEstimated = row.shortTermAvailable + row.shortTermAvailableUnreported;
                 row.unitsAvailableEstimated = row.seasonalAvailableEstimated + row.shortTermAvailableEstimated;
                 
             });

            //hide the rows as required
            (from h in q
             //where HideOccupancyReportRow(enforceReportingRateMin, ignoreNumberMin, h.reportingRate, h.openPropertiesReported)
             where HideCampOccupancyReportRow(enforceReportingRateMin, ignoreNumberMin, enforceOneThird, (h.seasonalAvailable + h.shortTermAvailable + h.unitsAvailableUnreported), h.operationallyOpenProductIds, h.reportedProductIds,h.theYear, h.theMonth, h.reportingRate, h.openPropertiesReported, starClasses)
             select h).ToList().ForEach(delegate(CampOccupancyReportRow row)
             {
                 row.displayRow = false;
             });

            var distinctYears = (from y in q
                                 select y.theYear).Distinct();


            XElement reportDataXml = new XElement("reports",
                                          (from y in distinctYears
                                           select new XElement("report",
                                                                new XAttribute("id", y.ToString()),
                                                               from h in q
                                                               where h.theYear == y
                                                               select new XElement("month",
                                                                                   new XAttribute("id", h.theMonth),
                                                                                   new XAttribute("shortName", new DateTime(1, h.theMonth, 1).ToString("MMM")),
                                                                                   new XElement("seasonalAvailable", h.seasonalAvailable),
                                                                                   new XElement("shortTermAvailable", h.shortTermAvailable),
                                                                                   new XElement("unitsAvailableReported", h.unitsAvailableReported),
                                                                                   new XElement("seasonalAvailableEstimated", h.seasonalAvailableEstimated),
                                                                                   new XElement("shortTermAvailableEstimated", h.shortTermAvailableEstimated),
                                                                                   new XElement("unitsAvailableEstimated", h.unitsAvailableEstimated),
                                                                                   new XElement("unitsAvailableUnreported", h.unitsAvailableUnreported),
                                                                                   new XElement("seasonalSold", h.seasonalSold),
                                                                                   new XElement("shortTermSold", h.shortTermSold),
                                                                                   new XElement("totalUnitsSold", h.totalUnitsSold),
                                                                   //new XElement("projectedUnitsSold", CalculateProjectedUnitsSold(h.totalUnitsAvailable, h.totalUnitsSold,h.totalUnitsAvailableUnreported)),
                                                                                   new XElement("projectedUnitsSold", h.projectedUnitsSold),
                                                                                   new XElement("projectedSeasonalSold", h.projectedSeasonalSold),
                                                                                   new XElement("projectedShortTermSold", h.projectedShortTermSold),
                                                                                   new XElement("occupancyRate", Math.Round(h.occupancyRate * 100, 1)),
                                                                                   new XElement("seasonalOccupancyRate", Math.Round(h.seasonalOccupancyRate * 100, 1)),
                                                                                   new XElement("shortTermOccupancyRate", Math.Round(h.shortTermOccupancyRate * 100, 1)),
                                                                                   new XElement("rowCount", h.rowCount),
                                                                                   new XElement("openProperties", h.openProperties),
                                                                                   new XElement("openPropertiesReported", h.openPropertiesReported),
                                                                                   new XElement("reportingRate", Math.Round(h.reportingRate * 100, 1)),
                                                                                   new XElement("displayRow", h.displayRow)
                                                                   ),
                                                                   from t in q
                                                                   where t.theYear == y && t.displayRow
                                                                   group t by new { t.theYear } into a
                                                                   select new XElement("summary",
                                                                       //new XElement("occupancyRateAvg", Math.Round(a.Average(z => z.occupancyRate * 100), 1)),
                                                                                       new XElement("occupancyRateAvg", a.Sum(z => (z.seasonalAvailable + z.shortTermAvailable)) > 0 ? Math.Round(Convert.ToDouble(a.Sum(z => z.totalUnitsSold)) / a.Sum(z => (z.seasonalAvailable + z.shortTermAvailable)) * 100, 1) : 0),
                                                                                       new XElement("openPropertiesReportedSum", a.Sum(z => z.openPropertiesReported)),
                                                                                       new XElement("shortTermOccupancyRateAvg", Math.Round(a.Average(z => z.shortTermOccupancyRate * 100), 1)),
                                                                                       new XElement("seasonalOccupancyRateAvg", Math.Round(a.Average(z => z.seasonalOccupancyRate * 100), 1)),
                                                                                       new XElement("unitsAvailableReportedSum", a.Sum(z => z.unitsAvailableReported)),
                                                                                       new XElement("seasonalAvailableSum", a.Sum(z => z.seasonalAvailable)),
                                                                                       new XElement("shortTermAvailableSum", a.Sum(z => z.shortTermAvailable)),
                                                                                       new XElement("totalUnitsSoldSum", a.Sum(z => (z.seasonalSold + z.shortTermSold))),
                                                                                       new XElement("totalSeasonalSoldSum", a.Sum(z => z.seasonalSold)),
                                                                                       new XElement("totalShortTermSoldSum", a.Sum(z => z.shortTermSold)),
                                                                                       new XElement("projectedUnitsSoldSum", a.Sum(z => z.projectedUnitsSold)),
                                                                                       new XElement("projectedSeasonalSoldSum", a.Sum(z => z.projectedSeasonalSold)),
                                                                                       new XElement("projectedShortTermSoldSum", a.Sum(z => z.projectedShortTermSold)),

                                                                                       new XElement("seasonalAvailableEstimatedSum", a.Sum(z => z.seasonalAvailableEstimated)),
                                                                                       new XElement("shortTermAvailableEstimatedSum", a.Sum(z => z.shortTermAvailableEstimated)),
                                                                                       new XElement("unitsAvailableEstimatedSum", a.Sum(z => z.unitsAvailableEstimated)),

                                                                       //new XElement("reportingRateAvg", Math.Round(a.Average(z => z.reportingRate * 100), 1))
                                                                                       new XElement("reportingRateAvg", Math.Round(CalculateReportingRate(a.Sum(z => (z.seasonalAvailable + z.shortTermAvailable)), a.Sum(z => (z.seasonalAvailableUnreported + z.shortTermAvailableUnreported))) * 100, 1))
                                                                       )

                                               )
                                          )
                                  );
            return reportDataXml;
        }
        
        
        public XDocument GenerateCampOccupancyReportXml(List<int> productIds, List<int> years, bool enforceReportingRateMin, bool displayActuals, bool ignoreNumberMin, bool enforceOneThird, string clientName, string description)
        {
            var query = from p in db.Products
                        where (productIds.Count > 0 && productIds.Contains(p.id))
                        orderby p.licenseNumber
                        select p;

            XDocument xdoc = new XDocument();
            XElement metaDataXml = new XElement("metaData",
                                                new XElement("clientName", clientName),
                                                new XElement("description", description),
                                                new XElement("years", string.Join(",", years.Select(z => z.ToString()).ToArray())),
                                                new XElement("displayActuals", displayActuals)
                                               );

            XElement productListXml = new XElement("products",
                                                  from p in query
                                                  select new XElement("product",
                                                                        new XAttribute("id", p.id),
                                                                        new XElement("productName", p.productName),
                                                                        new XElement("licenseNumber", p.licenseNumber)
                                                                      )
                                                         );



            var reportDataXml = GenerateCampOccupancyReportBody(productIds, years, enforceReportingRateMin,
                                                                ignoreNumberMin, enforceOneThird);

            xdoc.Add(new XElement("reportFile", metaDataXml, productListXml, reportDataXml));

            return xdoc;
        }
        
        public XDocument GenerateCampOccupancyReportXml(int geographyTypeId, List<int> geographyIds, List<int> starClasses, List<int> years, bool enforceReportingRateMin, bool enforceOneThird, bool displayActuals, bool ignoreNumberMin, string clientName, string description)
        {
            XDocument xdoc = new XDocument();

            XElement geographyTypeXml = new XElement("geographyTypeLabel");
            XElement geographicAreasXml = new XElement("geographicAreas");


            var pq = from p in db.Products
                     where p.productTypeId == (int)ProductType.Campground
                     select p;

            ProductBs productBs = new ProductBs();

            switch ((OccupancyReportGeographyType)geographyTypeId)
            {
                case OccupancyReportGeographyType.Areas:
                    geographyTypeXml.SetValue("Areas");
                    geographicAreasXml.SetValue(string.Join(", ", (from sr in productBs.GetSubRegions(geographyIds) select sr.subRegionName).ToArray()));

                    pq = from p in pq
                         where (p.communityId != null && geographyIds.Contains((int)p.refCommunity.subRegionId))
                         select p;
                    break;
                case OccupancyReportGeographyType.Counties:
                    geographyTypeXml.SetValue("Counties");
                    geographicAreasXml.SetValue(string.Join(", ", (from c in productBs.GetCounties(geographyIds) select c.countyName).ToArray()));

                    pq = from p in pq
                         where (p.communityId != null && geographyIds.Contains((int)p.refCommunity.countyId))
                         select p;
                    break;
                case OccupancyReportGeographyType.Regions:
                    geographyTypeXml.SetValue("Regions");
                    geographicAreasXml.SetValue(string.Join(", ", (from r in productBs.GetRegions(geographyIds) select r.regionName).ToArray()));

                    pq = from p in pq
                         where (p.communityId != null && geographyIds.Contains(p.refCommunity.regionId))
                         select p;
                    break;
            }

            XElement metaDataXml = new XElement("metaData",
                                                new XElement("clientName", clientName),
                                                new XElement("description", description),
                                                new XElement("years", string.Join(", ", years.Select(z => z.ToString()).ToArray())),
                                                new XElement("starClasses", string.Join(", ", starClasses.Select(z => String.Format("{0:0.0}", (double)z / 2)).ToArray())),
                                                new XElement("displayActuals", displayActuals),
                                                geographyTypeXml,
                                                geographicAreasXml
                                               );

            List<int> productIds = (from p in pq
                                    select p.id).ToList();

            var reportDataXml = GenerateCampOccupancyReportBody(productIds, starClasses, years, enforceReportingRateMin,
                                                                ignoreNumberMin, enforceOneThird);

            xdoc.Add(new XElement("reportFile", metaDataXml, reportDataXml));

            return xdoc;
        }

        public XDocument GenerateConfidentialXml(string productName, string licenseNumber, List<int> years)
        {
            //Product p;
            ResearchBs researchBs = new ResearchBs();
            
            Product product = !String.IsNullOrEmpty(licenseNumber) ? researchBs.GetProductsByLicenseNumber(new List<string> {licenseNumber}, ProductType.Accommodation).FirstOrDefault() : researchBs.GetAccommodationByName(productName);


            XDocument xdoc = new XDocument();
            XElement metaDataXml = new XElement("metaData",
                                                new XElement("productName", product.productName),
                                                new XElement("licenseNumber", product.licenseNumber),
                                                new XElement("years", string.Join(", ", years.Select(z => z.ToString()).ToArray()))
                                               );

            var q = (from r in researchDb.AccommodationOccupancies
                     where r.productId == product.id && years.Contains(r.reportDate.Year)
                     select new OccupancyReportRow
                     {
                         theMonth = r.reportDate.Month,
                         theYear = r.reportDate.Year,
                         totalUnitsSold = (r.totalUnitsSold != null) ? r.totalUnitsSold.Value : 0,
                         totalUnitsAvailable = r.unitsAvailable * r.daysOpen,
                         rowCount = 1,
                         displayRow = true,
                         status = (r.daysOpen > 0) ? "Open" : "Closed"
                     }).ToList();

            //Generate empty rows
            foreach (var year in years)
            {
                var usedMonths = (from ae in q
                                  where ae.theYear == year
                                  select ae.theMonth).ToList();

                var nullRows = (from m in _monthNos
                                where !usedMonths.Contains(m)
                                select new OccupancyReportRow
                                {
                                    theMonth = m,
                                    theYear = year,
                                    totalUnitsSold = 0,
                                    rowCount = 0,
                                    reportingRate = 0,
                                    totalUnitsAvailable = 0,
                                    totalUnitsAvailableUnreported = 0,
                                    displayRow = false,
                                    status = IsOperational(product.id,year,m) ? "Missing Report" : "Operationally Closed"
                                }).ToList();

                q = q.Union(nullRows).ToList();
            }

            q = q.OrderBy(a => a.theYear).ThenBy(a => a.theMonth).ToList();

            //SET the total units available for the unreported properties
            (from j in q
             select j).ToList().ForEach(delegate(OccupancyReportRow row)
             {
                 row.occupancyRate = CalculateOccupancyRate(row.totalUnitsAvailable, row.totalUnitsSold);
             });

            /*
            //SET the reporting rates
            (from j in q
             select j).ToList().ForEach(delegate(OccupancyReportRow row)
                                            {
                                                row.reportingRate = (row.totalUnitsAvailable)/(row.totalUnitsAvailable + row.totalUnitsAvailableUnreported)
                                            });
             */

            var distinctYears = (from y in q
                                 select y.theYear).Distinct();


            XElement reportDataXml = new XElement("reports",
                                          (from y in distinctYears
                                           select new XElement("report",
                                                                new XAttribute("id", y.ToString()),
                                                               from h in q
                                                               where h.theYear == y
                                                               select new XElement("month",
                                                                                   new XAttribute("id", h.theMonth),
                                                                                   new XAttribute("shortName", new DateTime(1, h.theMonth, 1).ToString("MMM")),
                                                                                   new XElement("totalUnitsAvailable", h.totalUnitsAvailable),
                                                                                   new XElement("totalUnitsSold", h.totalUnitsSold),
                                                                                    new XElement("displayRow", h.displayRow),
                                                                                    new XElement("status", h.status),
                                                                   //new XElement("projectedUnitsSold", CalculateProjectedUnitsSold(h.totalUnitsAvailable, h.totalUnitsSold,h.totalUnitsAvailableUnreported)),
                                                                                   new XElement("occupancyRate", Math.Round(h.occupancyRate * 100, 1))
                                                                   ),
                                                                   from t in q
                                                                   where t.theYear == y && t.displayRow && t.totalUnitsAvailable > 0
                                                                   group t by new { t.theYear } into a
                                                                   select new XElement("summary",
                                                                       //new XElement("occupancyRateAvg", a.Average(z => Math.Round((z.totalUnitsAvailable > 0 ? Convert.ToDouble(z.totalUnitsSold) / Convert.ToDouble(z.totalUnitsAvailable) : 0) * 100, 1))),
                                                                                       new XElement("occupancyRateAvg", Math.Round(a.Average(z => z.occupancyRate * 100), 1)),
                                                                                       new XElement("totalUnitsAvailableSum", a.Sum(z => z.totalUnitsAvailable)),
                                                                                       new XElement("totalUnitsSoldSum", a.Sum(z => z.totalUnitsSold))
                                                                       )

                                               )
                                          )
                                  );

            xdoc.Add(new XElement("reportFile", metaDataXml, reportDataXml));

            return xdoc;
        }

        public XDocument GenerateCampConfidentialXml(string productName, string licenseNumber, List<int> years)
        {
            //Product p;
            ResearchBs researchBs = new ResearchBs();

            Product product = !String.IsNullOrEmpty(licenseNumber) ? researchBs.GetProductsByLicenseNumber(new List<string> { licenseNumber }, ProductType.Campground).FirstOrDefault() : researchBs.GetAccommodationByName(productName);


            XDocument xdoc = new XDocument();
            XElement metaDataXml = new XElement("metaData",
                                                new XElement("productName", product.productName),
                                                new XElement("licenseNumber", product.licenseNumber),
                                                new XElement("years", string.Join(", ", years.Select(z => z.ToString()).ToArray()))
                                               );

            var q = (from r in researchDb.CampgroundOccupancies
                     where r.productId == product.id && years.Contains(r.reportDate.Year)
                     select new CampOccupancyReportRow
                     {
                         status = (r.daysOpen > 0) ? "Open" : "Closed",

                         theMonth = r.reportDate.Month,
                         theYear = r.reportDate.Year,
                         seasonalSold = r.seasonalSold.GetValueOrDefault() * r.daysOpen,
                         shortTermSold = r.shortTermSold.GetValueOrDefault(),
                         totalUnitsSold = 0, //set to 0 for now, will update later in code
                         rowCount = 1,
                         openPropertiesReported = (r.daysOpen > 0) ? 1 : 0,
                         seasonalAvailable = r.seasonalAvailable * r.daysOpen,
                         shortTermAvailable = r.shortTermAvailable * r.daysOpen,
                         seasonalAvailableUnreported = 0, //set to 0 for now, will update later in code
                         shortTermAvailableUnreported = 0, //set to 0 for now, will update later in code
                         unitsAvailableUnreported = 0, //set to 0 for now, will update later in code
                         displayRow = true,
                         reportedProductIds = new List<int>(product.id)

                     }).ToList();

            //Generate empty rows
            foreach (var year in years)
            {
                var usedMonths = (from ae in q
                                  where ae.theYear == year
                                  select ae.theMonth).ToList();

                var nullRows = (from m in _monthNos
                                where !usedMonths.Contains(m)
                                select new CampOccupancyReportRow
                                {
                                    theMonth = m,
                                    theYear = year,
                                    seasonalSold = 0,
                                    shortTermSold = 0,
                                    totalUnitsSold = 0,
                                    rowCount = 0,
                                    reportingRate = 0,
                                    seasonalAvailable = 0,
                                    shortTermAvailable = 0,
                                    seasonalAvailableUnreported = 0, //set to 0 for now, will update later in code
                                    shortTermAvailableUnreported = 0, //set to 0 for now, will update later in code
                                    unitsAvailableUnreported = 0, //set to 0 for now, will update later in code
                                    status = IsOperational(product.id, year, m) ? "Missing Report" : "Operationally Closed"
                                }).ToList();

                q = q.Union(nullRows).ToList();
            }

            q = q.OrderBy(a => a.theYear).ThenBy(a => a.theMonth).ToList();

            var productIds = new List<int> {product.id};

            //SET the total units available for the unreported properties
            (from j in q
             select j).ToList().ForEach(delegate(CampOccupancyReportRow row)
             {
                 row.operationallyOpenProductIds = CalculateOpenProperties(row.theYear, row.theMonth, productIds);
                 row.openProperties = row.operationallyOpenProductIds.Count;
                 row.totalUnitsSold = row.seasonalSold + row.shortTermSold;
                 row.unitsAvailableUnreported = CalculateCampUnreportedUnitsAvailable(row.theYear, row.theMonth, productIds, row.reportedProductIds);
                 row.seasonalAvailableUnreported = CalculateCampUnreportedUnitsAvailable(row.theYear, row.theMonth, productIds, row.reportedProductIds, ResearchUnitType.Seasonal);
                 row.shortTermAvailableUnreported = CalculateCampUnreportedUnitsAvailable(row.theYear, row.theMonth, productIds, row.reportedProductIds, ResearchUnitType.ShortTerm);
                 row.seasonalOccupancyRate = CalculateOccupancyRate(row.seasonalAvailable, row.seasonalSold);
                 row.shortTermOccupancyRate = CalculateOccupancyRate(row.shortTermAvailable, row.shortTermSold);
                 row.occupancyRate = CalculateOccupancyRate((row.seasonalAvailable + row.shortTermAvailable), (row.shortTermSold + row.seasonalSold));
                 row.reportingRate = CalculateReportingRate((row.shortTermAvailable + row.seasonalAvailable), row.unitsAvailableUnreported);
                 row.projectedUnitsSold = CalculateProjectedUnitsSold((row.shortTermAvailable + row.seasonalAvailable), (row.seasonalSold + row.shortTermSold), row.unitsAvailableUnreported);
                 row.projectedSeasonalSold = CalculateProjectedUnitsSold(row.seasonalAvailable, row.seasonalSold, row.seasonalAvailableUnreported);
                 row.projectedShortTermSold = CalculateProjectedUnitsSold(row.shortTermAvailable, row.shortTermSold, row.shortTermAvailableUnreported);
             });

            var distinctYears = (from y in q
                                 select y.theYear).Distinct();


            XElement reportDataXml = new XElement("reports",
                                          (from y in distinctYears
                                           select new XElement("report",
                                                                new XAttribute("id", y.ToString()),
                                                               from h in q
                                                               where h.theYear == y
                                                               select new XElement("month",
                                                                                   new XAttribute("id", h.theMonth),
                                                                                   new XAttribute("shortName", new DateTime(1, h.theMonth, 1).ToString("MMM")),
                                                                                   new XElement("seasonalAvailable", h.seasonalAvailable),
                                                                                   new XElement("shortTermAvailable", h.shortTermAvailable),
                                                                                   new XElement("totalUnitsAvailableUnreported", h.unitsAvailableUnreported),
                                                                                   new XElement("seasonalSold", h.seasonalSold),
                                                                                   new XElement("shortTermSold", h.shortTermSold),
                                                                                   new XElement("totalUnitsSold", h.totalUnitsSold),
                                                                                   new XElement("projectedUnitsSold", h.projectedUnitsSold),
                                                                                   new XElement("projectedSeasonalSold", h.projectedSeasonalSold),
                                                                                   new XElement("projectedShortTermSold", h.projectedShortTermSold),
                                                                                   new XElement("occupancyRate", Math.Round(h.occupancyRate * 100, 1)),
                                                                                   new XElement("seasonalOccupancyRate", Math.Round(h.seasonalOccupancyRate * 100, 1)),
                                                                                   new XElement("shortTermOccupancyRate", Math.Round(h.shortTermOccupancyRate * 100, 1)),
                                                                                   new XElement("rowCount", h.rowCount),
                                                                                   new XElement("openProperties", h.openProperties),
                                                                                   new XElement("openPropertiesReported", h.openPropertiesReported),
                                                                                   new XElement("reportingRate", Math.Round(h.reportingRate * 100, 1)),
                                                                                   new XElement("displayRow", h.displayRow),
                                                                                   new XElement("status", h.status)
                                                                   ),
                                                                   from t in q
                                                                   where t.theYear == y && t.displayRow
                                                                   group t by new { t.theYear } into a
                                                                   select new XElement("summary",
                                                                                       new XElement("occupancyRateAvg", Math.Round(a.Average(z => z.occupancyRate * 100), 1)),
                                                                                       new XElement("openPropertiesReportedSum", a.Sum(z => z.openPropertiesReported)),
                                                                                       new XElement("shortTermOccupancyRateAvg", Math.Round(a.Average(z => z.shortTermOccupancyRate * 100), 1)),
                                                                                       new XElement("seasonalOccupancyRateAvg", Math.Round(a.Average(z => z.seasonalOccupancyRate * 100), 1)),
                                                                                       new XElement("totalUnitsAvailableSum", a.Sum(z => (z.seasonalAvailable + z.shortTermAvailable))),
                                                                                       new XElement("seasonalAvailableSum", a.Sum(z => z.seasonalAvailable)),
                                                                                       new XElement("shortTermAvailableSum", a.Sum(z => z.shortTermAvailable)),
                                                                                       new XElement("totalUnitsSoldSum", a.Sum(z => (z.seasonalSold + z.shortTermSold))),
                                                                                       new XElement("totalSeasonalSoldSum", a.Sum(z => z.seasonalSold)),
                                                                                       new XElement("totalShortTermSoldSum", a.Sum(z => z.shortTermSold)),
                                                                                       new XElement("projectedUnitsSoldSum", a.Sum(z => z.projectedUnitsSold)),
                                                                                       new XElement("projectedSeasonalSoldSum", a.Sum(z => z.projectedSeasonalSold)),
                                                                                       new XElement("projectedShortTermSoldSum", a.Sum(z => z.projectedShortTermSold)),
                                                                                       new XElement("reportingRateAvg", Math.Round(a.Average(z => z.reportingRate * 100), 1))
                                                                       )

                                               )
                                          )
                                  );

            xdoc.Add(new XElement("reportFile", metaDataXml, reportDataXml));

            return xdoc;
        }

        public XDocument GenerateVarianceReportXml (int startMonth, int startYear, int endMonth, int endYear, int variance, bool filterByAmount)
        {
            var vr = researchDb.GetVarianceReport(startMonth, startYear, endMonth, endYear, variance, filterByAmount).ToList();

            var startDate = new DateTime(startYear, startMonth, 1);
            var endDate = new DateTime(endYear, endMonth, 1);

            XDocument xdoc = new XDocument();

            

            XElement metaDataXml = new XElement("metaData",
                                                new XElement("startDate", String.Format("{0:MMM yyyy}", startDate)),
                                                new XElement("endDate", String.Format("{0:MMM yyyy}", endDate)),
                                                new XElement("amountDifference", (filterByAmount) ? variance.ToString() : "N/A"),
                                                new XElement("percentageDifference", (filterByAmount) ? "N/A" : variance.ToString())
                                               );


            XElement reportDataXml = new XElement("report",
                                           from v in vr
                                           select new XElement("product",
                                                                new XAttribute("id", v.id),
                                                                new XElement("licenseNumber", v.licenseNumber),
                                                                new XElement("productName", v.productName),
                                                                new XElement("communityName", v.communityName),
                                                                new XElement("regionName", v.regionName),
                                                                new XElement("startUnitsSold", v.startUnitsSold),
                                                                new XElement("endUnitsSold", v.endUnitsSold),
                                                                new XElement("percentageDifference", v.percentageDifference),
                                                                new XElement("amountDifference", v.amountDifference)
                                            )
                                           
                                        );
                                  

            xdoc.Add(new XElement("reportFile", metaDataXml, reportDataXml));

            return xdoc;
        }

        public XDocument GenerateCampVarianceReportXml(int startMonth, int startYear, int endMonth, int endYear, int variance, bool filterByAmount)
        {
            var vr = researchDb.GetCampVarianceReport(startMonth, startYear, endMonth, endYear, variance, filterByAmount).ToList();

            var startDate = new DateTime(startYear, startMonth, 1);
            var endDate = new DateTime(endYear, endMonth, 1);

            XDocument xdoc = new XDocument();



            XElement metaDataXml = new XElement("metaData",
                                                new XElement("startDate", String.Format("{0:MMM yyyy}", startDate)),
                                                new XElement("endDate", String.Format("{0:MMM yyyy}", endDate)),
                                                new XElement("amountDifference", (filterByAmount) ? variance.ToString() : "N/A"),
                                                new XElement("percentageDifference", (filterByAmount) ? "N/A" : variance.ToString())
                                               );


            XElement reportDataXml = new XElement("report",
                                           from v in vr
                                           select new XElement("product",
                                                                new XAttribute("id", v.id),
                                                                new XElement("licenseNumber", v.licenseNumber),
                                                                new XElement("productName", v.productName),
                                                                new XElement("communityName", v.communityName),
                                                                new XElement("regionName", v.regionName),
                                                                new XElement("startUnitsSold", v.startUnitsSold),
                                                                new XElement("endUnitsSold", v.endUnitsSold),
                                                                new XElement("percentageDifference", v.percentageDifference),
                                                                new XElement("amountDifference", v.amountDifference)
                                            )

                                        );


            xdoc.Add(new XElement("reportFile", metaDataXml, reportDataXml));

            return xdoc;
        }

        

        public XDocument GenerateNonReportingXml(int startMonth, int startYear, int endMonth, int endYear)
        {
            var startDate = new DateTime(startYear, startMonth, 1);
            var endDate = new DateTime(endYear, endMonth, 1);

            var spanInMonths = ((endYear - startYear)*12) + endMonth - startMonth + 1;

            //products that are up to date with their reporting for the period
            var completeProducts = (from r in researchDb.AccommodationOccupancies
                     where (r.reportDate >= startDate) && (r.reportDate <= endDate) //&& ((new List<int> {2572,2592,2593,2595,2596}).Contains(r.productId))
                     group r by new { r.productId } into a
                     where a.Count() == spanInMonths
                     select a.Key.productId).ToList();

            var openProductsInPeriod = (from p in db.Products
                                        join op in db.OperationPeriods on p.id equals op.productId
                                        where p.productTypeId == (int)ProductType.Accommodation
                                        && op.openDate < endDate
                                        && (op.closeDate == null || op.closeDate > startDate) //&& ((new List<int> { 2572, 2592, 2593, 2595, 2596 }).Contains(op.productId))
                                        select op.productId).Distinct().ToList();

            //openProductsInPeriod - completeProducts
            var incompleteProducts = openProductsInPeriod.Except(completeProducts).ToList();

            var businessBs = new BusinessBs();
            var productBs = new ProductBs();

            var q = (from p in db.Products
                    where incompleteProducts.Contains(p.id)
                    orderby Convert.ToInt32(p.licenseNumber)
                    select p).ToList();

            List<NonReportingReportRow> nrrrl = new List<NonReportingReportRow>();

            for(var y = startYear; y <= endYear; y++)
            {
                foreach (var product in q)
                {
                    var c = GetResearchContact(product.id);
                    string officePhone = "";
                    string mobilePhone = "";

                    if (c != null)
                    {
                        var pl = businessBs.GetContactPhones(c.id).ToList();
                        var op = (from p in pl
                                            where p.phoneTypeId == (int) (PhoneType.Primary)
                                            select p).FirstOrDefault();
                        officePhone = (op != null) ? op.phoneNumber : "";

                        var mp = (from p in pl
                                    where p.phoneTypeId == (int)(PhoneType.Mobile)
                                    select p).FirstOrDefault();
                        mobilePhone = (mp != null) ? mp.phoneNumber : "";

                    }
                
                    //var pl = businessBs.GetContactPhones(c.id).ToList();

                    var nonReportingMonthList = GenerateNonReportingMonths(product.id, y, startDate, endDate);

                    if (nonReportingMonthList.Count() > 0)
                    {
                        var ul = productBs.GetProductUnitNumbers(product.id);
                        var nrrr = new NonReportingReportRow
                                       {
                                           contactName =
                                               (c != null) ? String.Format("{0} {1}", c.firstName, c.lastName) : "",
                                           isOpenAllYear =
                                               (product.periodOfOperationTypeId == (int) PeriodOfOperationType.AllYear)
                                                   ? "Y"
                                                   : "",
                                           licenseNumber = product.licenseNumber,
                                           mobilePhone = mobilePhone,
                                           officePhone = officePhone,
                                           totalUnits = (ul.Count() > 0) ? ul.Sum(z => z.units).ToString() : "",
                                           email = (c != null) ? c.email : "",
                                           nonReportingMonths = string.Join(", ", nonReportingMonthList.Select(z => CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(z).ToString()).ToArray()),
                                           productId = product.id,
                                           productName = product.productName,
                                           reportYear = y,
                                           //region = (product.communityId != null) ? ResourceUtils.GetRegionLabel((Region)product.refCommunity.regionId) : "";
                                           region = (product.communityId != null) ? product.refCommunity.refRegion.regionName : ""
                                       };

                        nrrrl.Add(nrrr);
                    }
                }
            }
            
            XDocument xdoc = new XDocument();

            var distinctYears = (from y in nrrrl
                                 select y.reportYear).Distinct();

            XElement metaDataXml = new XElement("metaData",
                                                new XElement("startDate", String.Format("{0:MMM yyyy}", startDate)),
                                                new XElement("endDate", String.Format("{0:MMM yyyy}", endDate))
                                               );


            XElement reportDataXml = new XElement("reports",
                                          (from y in distinctYears
                                           select new XElement("report",
                                                                new XAttribute("id", y.ToString()),
                                                               from h in nrrrl
                                                               where h.reportYear == y
                                                               select new XElement("product",
                                                                                   new XAttribute("id", h.productId),
                                                                                   new XElement("contactName", h.contactName),
                                                                                   new XElement("isOpenAllYear", h.isOpenAllYear),
                                                                                   new XElement("licenseNumber", h.licenseNumber),
                                                                                   new XElement("mobilePhone", h.mobilePhone),
                                                                                   new XElement("nonReportingMonths", h.nonReportingMonths),
                                                                                   new XElement("officePhone", h.officePhone),
                                                                                   new XElement("totalUnits", h.totalUnits),
                                                                                   new XElement("email", h.email),
                                                                                   new XElement("productName", h.productName),
                                                                                   new XElement("region", h.region)
                                                                   )
                                               )
                                          )
                                  );

            xdoc.Add(new XElement("reportFile", metaDataXml, reportDataXml));

            return xdoc;
        }

        public XDocument GenerateCampNonReportingXml(int startMonth, int startYear, int endMonth, int endYear)
        {
            var startDate = new DateTime(startYear, startMonth, 1);
            var endDate = new DateTime(endYear, endMonth, 1);

            var spanInMonths = ((endYear - startYear) * 12) + endMonth - startMonth + 1;

            //products that are up to date with their reporting for the period
            var completeProducts = (from r in researchDb.CampgroundOccupancies
                                    where (r.reportDate >= startDate) && (r.reportDate <= endDate) //&& ((new List<int> { 2572, 2592, 2593, 2595, 2596 }).Contains(r.productId))
                                    group r by new { r.productId } into a
                                    where a.Count() == spanInMonths
                                    select a.Key.productId).ToList();

            var openProductsInPeriod = (from p in db.Products
                                        join op in db.OperationPeriods on p.id equals op.productId
                                        where p.productTypeId == (int)ProductType.Campground
                                        && op.openDate < endDate
                                        && (op.closeDate == null || op.closeDate > startDate) //&& ((new List<int> { 2572, 2592, 2593, 2595, 2596 }).Contains(op.productId))
                                        select op.productId).Distinct().ToList();

            //openProductsInPeriod - completeProducts
            var incompleteProducts = openProductsInPeriod.Except(completeProducts).ToList();

            var businessBs = new BusinessBs();
            var productBs = new ProductBs();

            var q = (from p in db.Products
                     where incompleteProducts.Contains(p.id)
                     orderby p.licenseNumber
                     select p).ToList();

            List<NonReportingReportRow> nrrrl = new List<NonReportingReportRow>();

            for (var y = startYear; y <= endYear; y++)
            {
                foreach (var product in q)
                {
                    var c = GetResearchContact(product.id);
                    string officePhone = "";
                    string mobilePhone = "";

                    if (c != null)
                    {
                        var pl = businessBs.GetContactPhones(c.id).ToList();
                        var op = (from p in pl
                                  where p.phoneTypeId == (int)(PhoneType.Primary)
                                  select p).FirstOrDefault();
                        officePhone = (op != null) ? op.phoneNumber : "";

                        var mp = (from p in pl
                                  where p.phoneTypeId == (int)(PhoneType.Mobile)
                                  select p).FirstOrDefault();
                        mobilePhone = (mp != null) ? mp.phoneNumber : "";

                    }

                    //var pl = businessBs.GetContactPhones(c.id).ToList();

                    var nonReportingMonthList = GenerateCampNonReportingMonths(product.id, y, startDate, endDate);

                    if (nonReportingMonthList.Count() > 0)
                    {
                        var ul = productBs.GetProductUnitNumbers(product.id);
                        var nrrr = new NonReportingReportRow
                        {
                            contactName =
                                (c != null) ? String.Format("{0} {1}", c.firstName, c.lastName) : "",
                            isOpenAllYear =
                                (product.periodOfOperationTypeId == (int)PeriodOfOperationType.AllYear)
                                    ? "Y"
                                    : "",
                            licenseNumber = product.licenseNumber,
                            mobilePhone = mobilePhone,
                            officePhone = officePhone,
                            totalUnits = (ul.Count() > 0) ? ul.Sum(z => z.units).ToString() : "",
                            email = (c != null) ? c.email : "",
                            nonReportingMonths = string.Join(", ", nonReportingMonthList.Select(z => CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(z).ToString()).ToArray()),
                            productId = product.id,
                            productName = product.productName,
                            reportYear = y
                        };

                        nrrrl.Add(nrrr);
                    }
                }
            }

            XDocument xdoc = new XDocument();

            var distinctYears = (from y in nrrrl
                                 select y.reportYear).Distinct();

            XElement metaDataXml = new XElement("metaData",
                                                new XElement("startDate", String.Format("{0:MMM yyyy}", startDate)),
                                                new XElement("endDate", String.Format("{0:MMM yyyy}", endDate))
                                               );


            XElement reportDataXml = new XElement("reports",
                                          (from y in distinctYears
                                           select new XElement("report",
                                                                new XAttribute("id", y.ToString()),
                                                               from h in nrrrl
                                                               where h.reportYear == y
                                                               select new XElement("product",
                                                                                   new XAttribute("id", h.productId),
                                                                                   new XElement("contactName", h.contactName),
                                                                                   new XElement("isOpenAllYear", h.isOpenAllYear),
                                                                                   new XElement("licenseNumber", h.licenseNumber),
                                                                                   new XElement("mobilePhone", h.mobilePhone),
                                                                                   new XElement("nonReportingMonths", h.nonReportingMonths),
                                                                                   new XElement("officePhone", h.officePhone),
                                                                                   new XElement("totalUnits", h.totalUnits),
                                                                                   new XElement("email", h.email),
                                                                                   new XElement("productName", h.productName)
                                                                   )
                                               )
                                          )
                                  );

            xdoc.Add(new XElement("reportFile", metaDataXml, reportDataXml));

            return xdoc;
        }
        
        private List<int> GenerateNonReportingMonths(int productId, int year, DateTime startDate, DateTime endDate)
        {
            List<int> expectedReports = new List<int>();

            int lowEnd = 0;
            int highEnd = 0;

            if (startDate.Year == endDate.Year)
            {
                lowEnd = startDate.Month;
                highEnd = endDate.Month;
                //expectedReports = endDate.Month - startDate.Month + 1;
            }
            else if (year == startDate.Year)
            {
                lowEnd = startDate.Month;
                highEnd = 12;
                //expectedReports = 12 - startDate.Month + 1;
            }
            else if (year == endDate.Year)
            {
                lowEnd = 1;
                highEnd = endDate.Month;
                //expectedReports = endDate.Month;
            }
            else
            {
                lowEnd = 1;
                highEnd = 12;
            }

            for (var i = lowEnd; i <= highEnd; i++)
            {
                if (IsOperational(productId,year,i))
                {
                    expectedReports.Add(i);    
                }
            }

            var q = (from d in researchDb.AccommodationOccupancies
                    where d.reportDate.Year == year 
                    && d.productId == productId
                    && d.reportDate >= startDate
                    && d.reportDate <= endDate
                    select d.reportDate.Month).ToList();

            return expectedReports.Except(q).ToList();
        }

        private List<int> GenerateCampNonReportingMonths(int productId, int year, DateTime startDate, DateTime endDate)
        {
            List<int> expectedReports = new List<int>();

            int lowEnd = 0;
            int highEnd = 0;

            if (startDate.Year == endDate.Year)
            {
                lowEnd = startDate.Month;
                highEnd = endDate.Month;
                //expectedReports = endDate.Month - startDate.Month + 1;
            }
            else if (year == startDate.Year)
            {
                lowEnd = startDate.Month;
                highEnd = 12;
                //expectedReports = 12 - startDate.Month + 1;
            }
            else if (year == endDate.Year)
            {
                lowEnd = 1;
                highEnd = endDate.Month;
                //expectedReports = endDate.Month;
            }
            else
            {
                lowEnd = 1;
                highEnd = 12;
            }

            for (var i = lowEnd; i <= highEnd; i++)
            {
                if (IsOperational(productId, year, i))
                {
                    expectedReports.Add(i);
                }
            }

            var q = (from d in researchDb.CampgroundOccupancies
                     where d.reportDate.Year == year
                     && d.productId == productId
                     && d.reportDate >= startDate
                     && d.reportDate <= endDate
                     select d.reportDate.Month).ToList();

            return expectedReports.Except(q).ToList();
        }

        private List<int> CalculateOpenProperties(int year, int month, List<int> productIds)
        {
            var dt = new DateTime(year,month,1);
            var idListString = String.Join(",", productIds.Select(z => z.ToString()).ToArray());

            return researchDb.CalculateOpenProperties(dt, idListString).Select(z => z.id).ToList();
        }

        private List<int> CalculateOpenPropertiesOld(int year, int month, List<int> productIds)
        {
            List<int> operationallyOpenProductIds = new List<int>();
            ProductBs productBs = new ProductBs();

            foreach (var productId in productIds)
            {
                if (productId == 280)
                {
                    var just = "in";
                }
                var p = productBs.GetProduct(productId,true);
                var opl = (p != null && p.OperationPeriods != null) ? p.OperationPeriods.ToList() : new List<OperationPeriod>();

                if (p == null || !IsOperational(opl, year, month))
                {
                   // return 0;
                }
                else
                {
                    var isConsideredOpen = ((p.periodOfOperationTypeId == (int)PeriodOfOperationType.DateRange)
                     ? GetDefaultOpenDays(month, year, p.openMonth, p.closeMonth, p.openDay, p.closeDay)
                     : DateTime.DaysInMonth(year, month)) > 0;
                   
                    if (isConsideredOpen)
                    {
                        operationallyOpenProductIds.Add(productId);
                    }
                }
            }

            return operationallyOpenProductIds;
        }

        private int CalculateUnreportedUnitsAvailable(int year, int month, List<int> productIds, List<int> reportedProductIds, List<int> researchClasses, List<int> starClasses)
        {
            var estimatedUnreportedUnitsAvailable = 0;

            foreach (var id in productIds.Except(reportedProductIds))
            {
                estimatedUnreportedUnitsAvailable += GetEstimatedAvailableUnits(year, month, id, null, researchClasses, starClasses);
            }

            return estimatedUnreportedUnitsAvailable;
        }


        private int CalculateCampUnreportedUnitsAvailable(int year, int month, List<int> productIds, List<int> reportedProductIds)
        {
            return CalculateCampUnreportedUnitsAvailable(year, month, productIds, reportedProductIds, new List<int>(), null);
        }
        
        private int CalculateCampUnreportedUnitsAvailable(int year, int month, List<int> productIds, List<int> reportedProductIds, List<int> starClasses  )
        {
            return CalculateCampUnreportedUnitsAvailable(year, month, productIds, reportedProductIds, starClasses, null);
        }

        private int CalculateCampUnreportedUnitsAvailable(int year, int month, List<int> productIds, List<int> reportedProductIds, ResearchUnitType? rut)
        {
            return CalculateCampUnreportedUnitsAvailable(year, month, productIds, reportedProductIds, new List<int>(), rut);
        }

        private int CalculateCampUnreportedUnitsAvailable(int year, int month, List<int> productIds, List<int> reportedProductIds, List<int> starClasses, ResearchUnitType? rut)
        {
            //var productIdsReported = (from r in researchDb.CampgroundOccupancies
            //                          where (productIds.Count > 0 && productIds.Contains(r.productId))
            //                                && r.reportDate.Year == year
            //                                && r.reportDate.Month == month
            //                          select r.productId).ToList();

            var estimatedUnreportedUnitsAvailable = 0;

            foreach (var id in productIds.Except(reportedProductIds ?? new List<int>()))
            {
                //estimatedUnreportedUnitsAvailable += GetEstimatedAvailableUnits(year, month, id, starClasses, rut));
                estimatedUnreportedUnitsAvailable += GetEstimatedAvailableUnits(year, month, id, rut, new List<int>(), starClasses);
            }

            return estimatedUnreportedUnitsAvailable;
        }
        
        private double CalculateReportingRate(int totalUnitsAvailable, int totalUnitsAvailableUnreported)
        {
            //return Math.Round(Convert.ToDouble(totalUnitsAvailable)/(totalUnitsAvailable + totalUnitsAvailableUnreported), 2);
            //return (totalUnitsAvailable + totalUnitsAvailableUnreported) > 0 ? Convert.ToDouble(totalUnitsAvailable) / (totalUnitsAvailable + totalUnitsAvailableUnreported) : 0;
            if (totalUnitsAvailable == 0 && totalUnitsAvailableUnreported == 0)
            {
                return 1;
            }
            else if ((totalUnitsAvailable + totalUnitsAvailableUnreported) > 0)
            {
                return Convert.ToDouble(totalUnitsAvailable)/(totalUnitsAvailable + totalUnitsAvailableUnreported);
            }
            else
            {
                return 0;
            }

        }

        private double CalculateOccupancyRate(int totalUnitsAvailable, int totalUnitsSold)
        {
            //return Math.Round((totalUnitsAvailable > 0 ? Convert.ToDouble(totalUnitsSold) / totalUnitsAvailable : 0), 2);
            return (totalUnitsAvailable > 0 ? Convert.ToDouble(totalUnitsSold) / totalUnitsAvailable : 0);
            
        }

        private double CalculateProjectedUnitsSold(int totalUnitsAvailable, int totalUnitsSold, int totalUnitsAvailableUnreported)
        {
            var occRate = CalculateOccupancyRate(totalUnitsAvailable, totalUnitsSold);
            return Math.Round((occRate * totalUnitsAvailableUnreported) + totalUnitsSold, 0);

        }

        public AccommodationOccupancy ProcessAccommodationOccupancyRow(AccommodationOccupancy ao)
        {
            ResearchBs researchBs = new ResearchBs();
            var aoq = researchBs.GetAccommodationOccupancyData(ao.productId, ao.reportDate.Year);

            var myRow = (from d in aoq where d.reportDate.Month == ao.reportDate.Month && d.productId == ao.productId select d).FirstOrDefault();
            
            if (myRow != null)
            {
                myRow.licenseNumber = ao.licenseNumber;

                myRow.accommodationTypeId = ao.accommodationTypeId;
                myRow.starClassRating = ao.starClassRating;

                myRow.daysOpen = ao.daysOpen;
                myRow.unitsAvailable = ao.unitsAvailable;
                myRow.totalUnitsSold = ao.totalUnitsSold;
                myRow.totalGuests = ao.totalGuests;

                myRow.vacationPct = ao.vacationPct;
                myRow.businessPct = ao.businessPct;
                myRow.conventionPct = ao.conventionPct;
                myRow.motorcoachPct = ao.motorcoachPct;
                myRow.otherPct = ao.otherPct;

                myRow.lastModifiedDate = ao.lastModifiedDate;

                researchBs.Save();
                return myRow;
            }
            else
            {
                return researchBs.AddAccommodationOccupancy(ao);
            }
            
        }

        public CampgroundOccupancy ProcessCampgroundOccupancyRow(CampgroundOccupancy co)
        {
            ResearchBs researchBs = new ResearchBs();
            //var aoq = researchBs.GetAccommodationOccupancyData(co.productId, co.reportDate.Year);
            var coq = researchBs.GetCampgroundOccupancyData(co.productId, co.reportDate.Year);

            var myRow = (from d in coq where d.reportDate.Month == co.reportDate.Month && d.productId == co.productId select d).FirstOrDefault();

            if (myRow != null)
            {
                myRow.licenseNumber = co.licenseNumber;

                //myRow.accommodationTypeId = co.accommodationTypeId;
                //myRow.starClassRating = co.starClassRating;

                myRow.daysOpen = co.daysOpen;
                myRow.seasonalAvailable = co.seasonalAvailable;
                myRow.shortTermAvailable = co.shortTermAvailable;
                myRow.seasonalSold = co.seasonalSold;
                myRow.shortTermSold = co.shortTermSold;
                myRow.totalGuests = co.totalGuests;

                myRow.nsTents = co.nsTents;
                myRow.canTents = co.canTents;
                myRow.usTents = co.usTents;
                myRow.intTents = co.intTents;

                myRow.nsRvs = co.nsRvs;
                myRow.canRvs = co.canRvs;
                myRow.usRvs = co.usRvs;
                myRow.intRvs = co.intRvs;

                myRow.nsCabins = co.nsCabins;
                myRow.canCabins = co.canCabins;
                myRow.usCabins = co.usCabins;
                myRow.intCabins = co.intCabins;

                myRow.lastModifiedDate = co.lastModifiedDate;

                researchBs.Save();
                return myRow;
            }
            else
            {
                return researchBs.AddCampgroundOccupancy(co);
            }

        }

        public AccommodationOccupancy AddAccommodationOccupancy (AccommodationOccupancy ao)
        {
            researchDb.AccommodationOccupancies.InsertOnSubmit(ao);
            researchDb.SubmitChanges();

            return ao;
        }

        public CampgroundOccupancy AddCampgroundOccupancy(CampgroundOccupancy co)
        {
            researchDb.CampgroundOccupancies.InsertOnSubmit(co);
            researchDb.SubmitChanges();

            return co;
        }

        public void Save()
        {
            researchDb.SubmitChanges();
        }

        private bool HideOccupancyReportRow(bool enforceReportingRateMin, bool ignoreNumberMin, bool enforceOneThird, int totalAvailableUnits, List<int> productIds, List<int> reportedProductIds, int year, int month, double reportingRate, int propertyNumber, List<int> researchClasses, List<int> starClasses  )
        {
            var hideRow = false;
            if (enforceReportingRateMin && (reportingRate * 100)  < ReportingRateMin)
            {
                hideRow = true;
            }
            else if (!ignoreNumberMin && propertyNumber < PropertyNumberMin)
            {
                hideRow = true;
            }
            else if (enforceOneThird && IsOneThirdRuleViolated(productIds, reportedProductIds, year, month, totalAvailableUnits, researchClasses, starClasses))
            {
                hideRow = true;
            }

            return hideRow;
        }

        private bool HideCampOccupancyReportRow(bool enforceReportingRateMin, bool ignoreNumberMin, bool enforceOneThird, int totalAvailableUnits, List<int> productIds, List<int> reportedProductIds, int year, int month, double reportingRate, int propertyNumber, List<int> starClasses)
        {
            var hideRow = false;
            if (enforceReportingRateMin && (reportingRate * 100) < ReportingRateMin)
            {
                hideRow = true;
            }
            else if (!ignoreNumberMin && propertyNumber < PropertyNumberMin)
            {
                hideRow = true;
            }
            else if (enforceOneThird && IsCampOneThirdRuleViolated(productIds, reportedProductIds, year, month, totalAvailableUnits, starClasses))
            {
                hideRow = true;
            }

            return hideRow;
        }

        public static string GetResearchClassLabel(ResearchClass rc)
        {
            switch (rc)
            {
                case (ResearchClass.Apartment):
                    return "Apartment";
                case (ResearchClass.BedBreakfast):
                    return "B&B";
                case (ResearchClass.BedBreakfastInn):
                    return "B&B Inn";
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

        public List<int> GetProductsExceedOneThirdTotalUnits (List<int> productIds)
        {
            var q = from pu in db.ProductUnitNumbers
                     where productIds.Contains(pu.productId)
                     select pu.units;

            var totalUnits = (q.Count() > 0) ? q.Sum() : 0;

            var q2 = from pu in db.ProductUnitNumbers
                    where productIds.Contains(pu.productId)
                    group pu by new {pu.productId} into a
                    where a.Sum(z => z.units) > totalUnits/3
                    select a.Key.productId;

            return q2.ToList();
        }

        public bool IsOneThirdRuleViolated(List<int> productIds, List<int> reportedProductIds, int year, int month, int totalAvailableUnits, List<int> researchClasses, List<int> starClasses  )
        {
            reportedProductIds = reportedProductIds ?? new List<int> {};

            var q = from ao in researchDb.AccommodationOccupancies
                    where ao.reportDate.Year == year &&
                          ao.reportDate.Month == month
                          && reportedProductIds.Contains(ao.productId)
                          && (ao.unitsAvailable * ao.daysOpen) > ((double)totalAvailableUnits / 3)
                    select ao;

            if (q.Count() > 0)
            {
                return true;
            }

            var unreportedProductIds = productIds.Except(reportedProductIds).ToList();

            var q2 = (from id in unreportedProductIds
                     where GetEstimatedAvailableUnits(year, month, id, null, researchClasses, starClasses) > ((double)totalAvailableUnits / 3)
                     select id).ToList();

            if (q2.Count() > 0)
            {
                return true;
            }

            return false;
        }

        public bool IsCampOneThirdRuleViolated(List<int> productIds, List<int> reportedProductIds, int year, int month, int totalAvailableUnits, List<int> starClasses)
        {
            reportedProductIds = reportedProductIds ?? new List<int> {};

            var q = from co in researchDb.CampgroundOccupancies
                    where co.reportDate.Year == year &&
                          co.reportDate.Month == month
                          && reportedProductIds.Contains(co.productId)
                          && ((co.seasonalAvailable + co.shortTermAvailable) * co.daysOpen) > ((double)totalAvailableUnits / 3)
                    select co;

            if (q.Count() > 0)
            {
                return true;
            }

            var unreportedProductIds = productIds.Except(reportedProductIds).ToList();

            var q2 = (from id in unreportedProductIds
                      where GetEstimatedAvailableUnits(year, month, id, null, new List<int>(), starClasses) > ((double)totalAvailableUnits / 3)
                      select id).ToList();

            if (q2.Count() > 0)
            {
                return true;
            }

            return false;
        }
    }
}