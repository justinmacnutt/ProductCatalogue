using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Linq.SqlClient;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml.Linq;
using ProductCatalogue.DataAccess;
using ProductCatalogue.DataAccess.Enumerations;
using Action = ProductCatalogue.DataAccess.Enumerations.Action;
using AttributeGroup = ProductCatalogue.DataAccess.Enumerations.AttributeGroup;

namespace ProductCatalogue.BusinessServices
{
    public class ProductBs
    {
        private readonly TourismDataContext db =
            new TourismDataContext(ConfigurationManager.ConnectionStrings["Tourism2ConnectionString"].ConnectionString);

        private List<int> _listingProofAttTrue = new List<int> {(int) EditorCheck.UpdatesEntered};

        private List<int> _listingProofAttFalse = new List<int>
                                                      {
                                                          (int) EditorCheck.QueriesToCheck,
                                                          (int) EditorCheck.CheckingWithQa,
                                                          (int) EditorCheck.ProofSent
                                                      };

        private const int ChunkSize = 2000;
        //hack to support cape breton national park
        // integer list represents baddeck, margaree, cheticamp, cape north, ingonish, st ann's bay, cbhnp areas
        private List<int> _cbhnpAreas = new List<int> {4,42,17,15,26,63, 73};
        private const int CapeBretonHnpCommunityId = 578;

        #region facade support

        public Product GetProduct(string legacyId)
        {
            return db.Products.SingleOrDefault(p => p.fileMakerId == legacyId && p.isDeleted == false && p.isActive && (p.isValid || p.overrideErrors));
        }
        
        public IEnumerable<Product> GetProducts(List<string> legacyIds)
        {
            var pl = new List<Product>();
            var myIds = new List<string>();

            var query = from p in db.Products
                        where (!p.isDeleted)
                        && (p.isActive)
                        && (p.isValid || p.overrideErrors)
                        && (myIds.Count > 0 && myIds.Contains(p.fileMakerId))
                        select p;

            for (var j = 0; j <= legacyIds.Count; j += ChunkSize)
            {
                myIds = legacyIds.GetRange(j, (legacyIds.Count - j > ChunkSize) ? ChunkSize : legacyIds.Count - j);
                pl.AddRange(query.ToList());
            }

            return pl;
        }
        
        public IEnumerable<Product> GetProducts(List<int> productIds)
        {

            return GetProducts(productIds, true);
            //var pl = new List<Product>();
            //var myIds = new List<int>();

            //var query = from p in db.Products
            //            where (!p.isDeleted)
            //            && (p.isActive)
            //            && (p.isValid || p.overrideErrors)
            //            && (myIds.Count > 0 && myIds.Contains(p.id))
            //            select p;

            //for (var j = 0; j <= productIds.Count; j += ChunkSize)
            //{
            //    myIds = productIds.GetRange(j, (productIds.Count - j > ChunkSize) ? ChunkSize : productIds.Count - j);
            //    pl.AddRange(query.ToList());
            //}

            //return pl;
        }

        public IEnumerable<int> SearchProducts(string productName, List<ProductType> productTypes, int? communityId, Region? region,
           List<int> attListTrue, List<int> attListFalse, bool attListUseAnd)
        {
            return SearchProducts(productName, productTypes, communityId, region, attListTrue, attListFalse,
                                  attListUseAnd, false, null, null);
        }
        
        public IEnumerable<int> SearchProducts(string productName, List<ProductType> productTypes, int? communityId, Region? region,
           List<int> attListTrue, List<int> attListFalse, bool attListUseAnd, bool includeSurroundingAreas)
        {
            return SearchProducts(productName, productTypes, communityId, region, attListTrue, attListFalse,
                                  attListUseAnd, includeSurroundingAreas, null, null);
        }

        public IEnumerable<int> SearchProducts(string productName, List<ProductType> productTypes, int? communityId, Region? region,
           List<int> attListTrue, List<int> attListFalse, bool attListUseAnd, bool includeSurroundingAreas, List<string> keywords)
        {
            return SearchProducts(productName, productTypes, communityId, region, attListTrue, attListFalse,
                                  attListUseAnd, includeSurroundingAreas, keywords, null);
        }

        public IEnumerable<int> SearchProducts(string productName, List<ProductType> productTypes, int? communityId, Region? region,
           List<int> attListTrue, List<int> attListFalse, bool attListUseAnd, bool includeSurroundingAreas, List<string> keywords, string keywordsLanguageId)
        {
            var query = from p in db.Products
                        where (!p.isDeleted)
                        && (p.isActive)
                        && (p.isValid || p.overrideErrors)
                        && (p.productTypeId != (int) ProductType.Restaurants)
                        && (productTypes.Count == 0 || productTypes.Contains((ProductType)p.productTypeId))
                            //&& (communityId == null || p.communityId == communityId)
                        && (String.IsNullOrEmpty(productName) || p.productName.Contains(productName))
                        select p;

            if (communityId != null)
            {
                if (includeSurroundingAreas)
                {
                    var srId = (from c in db.refCommunities
                                where c.id == communityId
                                select c.subRegionId).FirstOrDefault();

                    if (srId != null)
                    {
                        query = from p in query
                                join rc in db.refCommunities on p.communityId equals rc.id
                                where rc.subRegionId == srId
                                || (_cbhnpAreas.Contains(srId.Value) && rc.id == CapeBretonHnpCommunityId)
                                || (rc.subRegionId != null && communityId == CapeBretonHnpCommunityId && _cbhnpAreas.Contains(rc.subRegionId.Value))
                                select p;
                    }
                    else
                    {
                        query = from p in query
                                where (p.communityId == communityId)
                                select p;
                    }
                }
                else
                {
                    query = from p in query
                            where (p.communityId == communityId)
                            select p;
                }
            }

            if (region != null)
            {
                query = from p in query
                        join rc in db.refCommunities on p.communityId equals rc.id
                        where rc.regionId == (int)region
                        select p;
            }

            if (attListTrue.Count > 0 || attListFalse.Count > 0)
            {
                if (attListUseAnd)
                {
                    query = ((from p in query
                              join pa in db.ProductAttributes on p.id equals pa.productId
                              select p).Where(
                             p =>
                             (p.ProductAttributes.Where(pa => (attListTrue.Contains(pa.attributeId))).Count() ==
                              attListTrue.Count) &&
                             (p.ProductAttributes.Where(pa => (attListFalse.Contains(pa.attributeId))).Count() == 0))).Distinct();
                }
                else
                {
                    query = ((from p in query
                              join pa in db.ProductAttributes on p.id equals pa.productId
                              select p).Where(p => (p.ProductAttributes.Where(pa => attListTrue.Contains(pa.attributeId))).Count() > 0 || (attListFalse.Count > 0 && (p.ProductAttributes.Where(pa => attListFalse.Contains(pa.attributeId))).Count() == 0))).Distinct();
                }
            }

            if (keywords != null && keywords.Count > 0)
            {
                var predicate = PredicateBuilder.False<ProductTranslation>();

                var tempQuery = from p in query
                        join pt in db.ProductTranslations on p.id equals pt.productId
                        where (String.IsNullOrEmpty(keywordsLanguageId) && pt.languageId == "en") || pt.languageId == keywordsLanguageId 
                        select pt;

                foreach (var kw in keywords)
                {
                    if (kw.Length > 0)
                    {
                        string temp = kw;

                        predicate = predicate.Or(pt => pt.keywords.Contains(String.Format("{0},", temp)));
                        predicate = predicate.Or(pt => pt.keywords.EndsWith(temp));
                    }
                }

                //tempQuery = tempQuery.Where(predicate);

               var kwIds = tempQuery.Where(predicate).Select(p => p.productId).ToList();
                                
                query = from p in query
                        where kwIds.Contains(p.id)
                        select p;
            }

            return (from p in query select p.id);
        }


        public IEnumerable<int> SearchProducts(double latitude, double longitude, int radius)
        {
            GeographyUtils.Position pos1 = new GeographyUtils.Position { Latitude = latitude, Longitude = longitude };
            GeographyUtils.Haversine hv = new GeographyUtils.Haversine();

            decimal degs = (decimal)GeographyUtils.KmsInDeg / radius;

            decimal upperLat = (decimal)latitude + degs;
            decimal lowerLat = (decimal)latitude - degs;

            decimal upperLon = (decimal)longitude + degs;
            decimal lowerLon = (decimal)longitude - degs;

            //reduce the list to a square area before refining with Haversine
            var query = (from p in db.Products
                         where (!p.isDeleted)
                         && (p.isActive)
                         && (p.isValid || p.overrideErrors)
                         && p.latitude != null && p.longitude != null
                         && p.latitude < upperLat && p.latitude > lowerLat
                         && p.longitude < upperLon && p.longitude > lowerLon
                         select p).ToList();

            return
                (query.Where(
                    p =>
                    hv.Distance(pos1,
                                new GeographyUtils.Position
                                    {Latitude = (double) p.latitude, Longitude = (double) p.longitude},
                                GeographyUtils.DistanceType.Kilometers) < radius)).Select(p => p.id);
        }

        public IEnumerable<int> SearchProducts(double latitude, double longitude, int radius, List<int> attListFalse)
        {
            var pl = SearchProducts(latitude, longitude, radius);

            var filteredOutProducts = (from pa in db.ProductAttributes
                                      where pl.Contains(pa.productId) && attListFalse.Contains(pa.attributeId)
                                      select pa.productId);

            return pl.Except(filteredOutProducts);
        }

        public Product GetActiveProduct(int id)
        {
            return db.Products.SingleOrDefault(p => p.id == id && p.isDeleted == false && p.isActive && (p.isValid || p.overrideErrors));
        }

        public List<string> GetProductKeywords (List<ProductType> productTypes, List<int> attListTrue, Region? region)
        {
            return GetProductKeywords(productTypes, attListTrue, region, "en");
        }

        public List<string> GetProductKeywords(List<ProductType> productTypes, List<int> attListTrue, Region? region, string languageId)
        {
            var idList = SearchProducts(null, productTypes, null, region, attListTrue, null, true, false);

            var query = from pt in db.ProductTranslations
                        where idList.Contains(pt.productId) && pt.languageId == languageId && pt.keywords != null && pt.keywords != ""
                        select pt.keywords;

            return query.ToList();
        }

        public List<string> GetProductKeywords(List<int> idList , string languageId)
        {
            var query = from pt in db.ProductTranslations
                        where idList.Contains(pt.productId) && pt.languageId == languageId && pt.keywords != null && pt.keywords != ""
                        select pt.keywords;

            return query.ToList();
        }
        #endregion

        #region web service support

        public Dictionary<string, int> GetLicenseNumbers(string prefix)
        {
            var query = from p in db.Products
                        where p.licenseNumber.StartsWith(prefix)
                        select p;

            return query.ToDictionary(p => p.licenseNumber, p => p.id);
        }
        #endregion

        public List<Tag> GetAllTags()
        {
            var q = from t in db.Tags
                     select t;

            return q.ToList();
        }

        public IEnumerable<Product> GetProducts(List<int> productIds, bool publicOnly)
        {
            var pl = new List<Product>();
            var myIds = new List<int>();

            var query = from p in db.Products
                        where (myIds.Count > 0 && myIds.Contains(p.id))
                        select p;

            if (publicOnly)
            {
                query = from p in query
                        where (!p.isDeleted)
                        && (p.isActive)
                        && (p.isValid || p.overrideErrors)
                        select p;
            }

            query = from p in query
                    orderby p.productName
                    select p;

            for (var j = 0; j <= productIds.Count; j += ChunkSize)
            {
                myIds = productIds.GetRange(j, (productIds.Count - j > ChunkSize) ? ChunkSize : productIds.Count - j);
                pl.AddRange(query.ToList());
            }

            return pl;
        }

        public IQueryable<Product> SearchProducts(int? productId, string productName, byte? productTypeId, short? communityId, byte? regionId, short? subRegionId, string businessName,
            string contactFirstName, string contactLastName, string filterLetter, byte? isActive, byte? isValid, byte? overrideErrors, byte? isComplete, byte? isCheckInMember,
            List<int> attListTrue, List<int> attListFalse, bool attListUseAnd, List<int> mediaListTrue, List<int> mediaListFalse, bool mediaListUseAnd, List<int> linkListTrue, List<int> linkListFalse, bool linkListUseAnd,
            string searchString, bool searchUnit, bool searchPrint, bool searchWeb, bool searchLicenseNumber, bool searchFileMakerId, bool searchCheckInId,
            string notesString, DateTime? notesStartDate, DateTime? notesEndDate)
        {
            var query = from p in db.Products
                        join cp in db.ContactProducts on p.id equals cp.productId 
                        join c in db.Contacts on cp.contactId equals c.id
                        join b in db.Businesses on c.businessId equals b.id
                        where p.isDeleted == false && cp.contactTypeId == (byte)ContactType.Primary
                        && (productId == null || p.id == productId)
                        && (productName == "" || p.productName.Contains(productName))
                        && (productTypeId == null || p.productTypeId == productTypeId)
                        && (communityId == null || p.communityId == communityId)
                        && (filterLetter == "" || p.productName.StartsWith(filterLetter))
                        && (isActive == null || p.isActive == (Convert.ToBoolean(isActive)))
                        && (isValid == null || p.isValid == (Convert.ToBoolean(isValid)))
                        && (isComplete == null || p.isComplete == (Convert.ToBoolean(isComplete)))
                        && (isCheckInMember == null || p.isCheckinMember == (Convert.ToBoolean(isCheckInMember)))
                        && (overrideErrors == null || p.overrideErrors == (Convert.ToBoolean(overrideErrors)))
                        && (contactFirstName == "" || c.firstName.Contains(contactFirstName))
                        && (contactLastName == "" || c.lastName.Contains(contactLastName))
                        && (businessName == "" || b.businessName.Contains(businessName))
                         
                        select p;

            if (subRegionId != null)
            {
                query = from p in query
                        join rc in db.refCommunities on p.communityId equals rc.id
                        where rc.subRegionId == subRegionId
                        select p;
            }
            
            if (regionId != null) 
            {
                query = from p in query
                        join rc in db.refCommunities on p.communityId equals rc.id
                        where rc.regionId == regionId
                        select p;
            }

            if ((searchString != "") && (searchPrint || searchUnit || searchWeb || searchLicenseNumber || searchFileMakerId || searchCheckInId))
            {
                query = (from p in query
                        join pvt in db.PrintVersionTranslations on p.id equals pvt.productId
                        join pt in db.ProductTranslations on p.id equals pt.productId
                        where (
                        (searchPrint && pvt.printDescription.Contains(searchString)) ||
                        (searchUnit && pvt.unitDescription.Contains(searchString)) ||
                        (searchWeb && pt.webDescription.Contains(searchString)) ||
                        (searchLicenseNumber && p.licenseNumber.Contains(searchString)) ||
                        (searchFileMakerId && p.fileMakerId.Contains(searchString)) ||
                        (searchCheckInId && p.checkInId.Contains(searchString))
                        )
                        select p).Distinct();
            }

            if (notesString != "")
            {
                query = from p in query
                        join pn in db.ProductNotes on p.id equals pn.productId
                        join n in db.Notes on pn.noteId equals n.id
                        where n.noteBody.Contains(notesString)
                        && (notesStartDate == null || n.lastModifiedDate >= notesStartDate)
                        && (notesEndDate == null || n.lastModifiedDate <= notesEndDate)
                        select p;
            }

            if (attListTrue.Count > 0 || attListFalse.Count > 0)
            {
                if (attListUseAnd)
                {
                    query = ((from p in query
                              join pa in db.ProductAttributes on p.id equals pa.productId
                              select p).Where(
                             p =>
                             (p.ProductAttributes.Where(pa => (attListTrue.Contains(pa.attributeId))).Count() ==
                              attListTrue.Count) &&
                             (p.ProductAttributes.Where(pa => (attListFalse.Contains(pa.attributeId))).Count() == 0))).Distinct();
                }
                else
                {
                    query = ((from p in query
                              join pa in db.ProductAttributes on p.id equals pa.productId
                              select p).Where(p => (p.ProductAttributes.Where(pa => attListTrue.Contains(pa.attributeId))).Count() > 0 || (attListFalse.Count > 0 && (p.ProductAttributes.Where(pa => attListFalse.Contains(pa.attributeId))).Count() == 0))).Distinct();
                }
            }


            if (mediaListTrue.Count > 0 || mediaListFalse.Count > 0)
            {
                if (mediaListUseAnd)
                {
                    query = ((from p in query
                              join m in db.Medias on p.id equals m.productId into outerTemp
                              from m in outerTemp.DefaultIfEmpty()
                              select p).Where(p =>
                                              (p.Medias.Where(m => (mediaListTrue.Contains(m.mediaTypeId))).GroupBy(
                                                  m => m.mediaTypeId).Count() == mediaListTrue.Count)
                                                  && ((p.Medias.Where(m => (mediaListFalse.Contains(m.mediaTypeId))).Count() == 0)))).Distinct();
                }
                else
                {
                    query = ((from p in query
                              join m in db.Medias on p.id equals m.productId into outerTemp
                              from m in outerTemp.DefaultIfEmpty()
                              select p).Where(p => (p.Medias.Where(m => mediaListTrue.Contains(m.mediaTypeId))).Count() > 0 || (mediaListFalse.Count > 0 && (p.Medias.Where(m => mediaListFalse.Contains(m.mediaTypeId))).Count() == 0))).Distinct();
                }
            }

            if (linkListTrue.Count > 0 || linkListFalse.Count > 0)
            {
                if (linkListUseAnd)
                {
                    query = ((from p in query
                              join u in db.Urls on p.id equals u.productId into outerTemp
                              from u in outerTemp.DefaultIfEmpty()
                              select p).Where(p =>
                                              (p.Urls.Where(u => (linkListTrue.Contains(u.urlTypeId))).GroupBy(
                                                  u => u.urlTypeId).Count() == linkListTrue.Count)
                                                  && ((p.Urls.Where(u => (linkListFalse.Contains(u.urlTypeId))).Count() == 0)))).Distinct();
                }
                else
                {
                    query = ((from p in query
                              join u in db.Urls on p.id equals u.productId into outerTemp
                              from u in outerTemp.DefaultIfEmpty()
                              select p).Where(p => (p.Urls.Where(u => linkListTrue.Contains(u.urlTypeId))).Count() > 0 || (linkListFalse.Count > 0 && (p.Urls.Where(u => linkListFalse.Contains(u.urlTypeId))).Count() == 0))).Distinct();
                }
            }

            query = from p in query
                    orderby p.productName
                    select p;

            return query;
            
        }
        
        public IQueryable<Product> GetProducts (Business b)
        {
            var query = from p in db.Products
                        join cp in db.ContactProducts on p.id equals cp.productId
                        join c in db.Contacts on cp.contactId equals c.id
                        where c.businessId == b.id && p.isDeleted == false && cp.contactTypeId == (int)ContactType.Primary
                        select p;

            return query;
            
        }

        public IQueryable<Product> GetProducts(Contact c)
        {
            var query = from p in db.Products
                        join cp in db.ContactProducts on p.id equals cp.productId
                        where cp.contactId == c.id && p.isDeleted == false
                        select p;
            
            return query;
        }

        public List<OutdoorExportVo> GetOutdoorsProductsForPrintExport(ProductType pt, Region? r)
        {
            
            var query = from p in db.Products
                        join c in db.refCommunities on p.communityId equals c.id into outerTemp
                        from c in outerTemp.DefaultIfEmpty()
                        join reg in db.refRegions on c.regionId equals reg.id into outerTemp2
                        from reg in outerTemp2.DefaultIfEmpty()
                        where (!p.isDeleted)
                        && (p.isActive)
                        && (p.isValid || p.overrideErrors)
                        && (p.productTypeId == (int)pt)
//                        && (r == null || c.regionId == (int)r)
                        orderby (p.primaryGuideSectionId == null) ? 0 : p.refGuideSection.guideSortOrder, reg.guideSortOrder, p.productName
                        select new OutdoorExportVo
                                   {
                                       productId = p.id,
                                       productName = p.productName,
                                       isCrossReference = false,
                                       guideSectionId = (p.primaryGuideSectionId == null) ? 0 : p.primaryGuideSectionId,
                                       guideSortOrder = (p.primaryGuideSectionId == null) ? 0 : p.refGuideSection.guideSortOrder,
                                       regionSortOrder = reg.guideSortOrder,
                                       communitySortOrder = c.guideSortOrder,
                                       regionId = reg.id
                                   };



            var crossRefQuery = from p in db.Products
                                join pd in db.ProductDescriptions on p.id equals pd.productId
                                join rgs in db.refGuideSections on pd.descriptionTypeId equals rgs.id
                                join c in db.refCommunities on p.communityId equals c.id into outerTemp
                                from c in outerTemp.DefaultIfEmpty()
                                join reg in db.refRegions on c.regionId equals reg.id into outerTemp2
                                from reg in outerTemp2.DefaultIfEmpty()
                                where (rgs.productTypeId == (int)pt)
                                && pd.languageId == "en"
                                && (!p.isDeleted)
                                && (p.isActive)
                                && (p.isValid || p.overrideErrors)
  //                              && (r == null || c.regionId == (int)r)
                                select new OutdoorExportVo
                                {
                                    productId = p.id,
                                    productName = p.productName,
                                    isCrossReference = true,
                                    guideSectionId = pd.descriptionTypeId,
                                    guideSortOrder = rgs.guideSortOrder,
                                    regionSortOrder = reg.guideSortOrder,
                                    communitySortOrder = c.guideSortOrder,
                                    regionId = c.regionId
                                };

            //var sortedCombined = from a in query.Union(crossRefQuery)
            //                     orderby a.guideSortOrder , a.regionSortOrder , a.productName  
            //                     select a;

            var sortedCombined = from a in query.Union(crossRefQuery)
                                 select a;

            //it's region based, so sort by community 
            if (r != null)
            {
                sortedCombined = from a in sortedCombined
                                 where a.regionId == (int)r
                                 orderby a.communitySortOrder, a.productName
                                 select a;
            }
            else
            {
                sortedCombined = from a in sortedCombined
                                 orderby a.guideSortOrder, a.productName
                                 select a;
            }

            return sortedCombined.ToList();
        }

        public List<OutdoorExportVo> GetOutdoorsProductsForPrintExportNew(ProductType pt, Region? r)
        {

            var query = from p in db.Products
                        join c in db.refCommunities on p.communityId equals c.id into outerTemp
                        from c in outerTemp.DefaultIfEmpty()
                        join reg in db.refRegions on c.regionId equals reg.id into outerTemp2
                        from reg in outerTemp2.DefaultIfEmpty()
                        where (!p.isDeleted)
                        && (p.isActive)
                        && (p.isValid || p.overrideErrors)
                        && (p.productTypeId == (int)pt)
                        //                        && (r == null || c.regionId == (int)r)
                        orderby (p.primaryGuideSectionId == null) ? 0 : p.refGuideSection.guideSortOrder, reg.guideSortOrder, p.productName
                        select new OutdoorExportVo
                        {
                            productId = p.id,
                            productName = p.productName,
                            isCrossReference = false,
                            guideSectionId = (p.primaryGuideSectionId == null) ? 0 : p.primaryGuideSectionId,
                            guideSortOrder = (p.primaryGuideSectionId == null) ? 0 : p.refGuideSection.guideSortOrder,
                            regionSortOrder = reg.guideSortOrder,
                            communitySortOrder = c.guideSortOrder,
                            regionId = reg.id,
                            product = p
                        };



            var crossRefQuery = from p in db.Products
                                join pd in db.ProductDescriptions on p.id equals pd.productId
                                join rgs in db.refGuideSections on pd.descriptionTypeId equals rgs.id
                                join c in db.refCommunities on p.communityId equals c.id into outerTemp
                                from c in outerTemp.DefaultIfEmpty()
                                join reg in db.refRegions on c.regionId equals reg.id into outerTemp2
                                from reg in outerTemp2.DefaultIfEmpty()
                                where (rgs.productTypeId == (int)pt)
                                && pd.languageId == "en"
                                && (!p.isDeleted)
                                && (p.isActive)
                                && (p.isValid || p.overrideErrors)
                                //                              && (r == null || c.regionId == (int)r)
                                select new OutdoorExportVo
                                {
                                    productId = p.id,
                                    productName = p.productName,
                                    isCrossReference = true,
                                    guideSectionId = pd.descriptionTypeId,
                                    guideSortOrder = rgs.guideSortOrder,
                                    regionSortOrder = reg.guideSortOrder,
                                    communitySortOrder = c.guideSortOrder,
                                    regionId = c.regionId,
                                    product = p
                                };

            //var sortedCombined = from a in query.Union(crossRefQuery)
            //                     orderby a.guideSortOrder , a.regionSortOrder , a.productName  
            //                     select a;

            var sortedCombined = from a in query.Union(crossRefQuery)
                                 select a;

            //it's region based, so sort by community 
            if (r != null)
            {
                sortedCombined = from a in sortedCombined
                                 where a.regionId == (int)r
                                 orderby a.communitySortOrder, a.productName
                                 select a;
            }
            else
            {
                sortedCombined = from a in sortedCombined
                                 orderby a.guideSortOrder, a.productName
                                 select a;
            }

            return sortedCombined.ToList();
        }
        
        
        public class OutdoorExportVo
        {
            public int productId { get; set; }
            public string productName { get; set; }
            public bool isCrossReference { get; set; }
            public byte? guideSectionId { get; set; }
            public int? guideSortOrder { get; set; }
            public int? regionSortOrder { get; set; }
            public int? communitySortOrder { get; set; }
            public int? regionId { get; set; }
            public Product product { get; set; }
        }
      
        public IQueryable<Product> GetProductsForPrintExport(ProductType pt, Region? r)
        {
            var query = from p in db.Products
                        where (!p.isDeleted)
                        && (p.isActive)
                        && (p.isValid || p.overrideErrors)
                        && (p.productTypeId == (int)pt)
                        select p;

            switch (pt)
            {
                case ProductType.Attraction:
                case ProductType.Accommodation:
                case ProductType.Campground:
                case ProductType.FineArts:
                case ProductType.Trails:
                case ProductType.Restaurants:
                    query = from p in query
                            join c in db.refCommunities on p.communityId equals c.id into outerTemp
                            from c in outerTemp.DefaultIfEmpty()
                            where (c.regionId == (int)r)
                            orderby c.guideSortOrder, p.productName
                            select p;
                    break;
                //case ProductType.Outdoors:
                //    query = from p in query
                //            join c in db.refCommunities on p.communityId equals c.id into outerTemp
                //            from c in outerTemp.DefaultIfEmpty()
                //            join reg in db.refRegions on c.regionId equals reg.id
                //            orderby (p.primaryGuideSectionId == null) ? 0 : p.refGuideSection.guideSortOrder, reg.guideSortOrder, p.productName
                //            select p;
                //    //query = from p in query
                    //        join c in db.refCommunities on p.communityId equals c.id
                    //        join reg in db.refRegions on c.regionId equals reg.id
                    //        orderby (p.primaryGuideSectionId == null) ? 0 : p.refGuideSection.guideSortOrder, reg.guideSortOrder, p.productName
                    //        select p;
                    break;
                //case ProductType.TourOps:
                //    query = from p in query
                //            orderby (p.primaryGuideSectionId == null) ? 0 : p.refGuideSection.guideSortOrder, p.productName
                //            select p;
                //    break;
            }

            return query;
        }
        
        public IQueryable<Product> GetProductsForFormGeneration(int productTypeId, PublishStatus publishStatus)
        {
            return GetProductsForFormGeneration(productTypeId, publishStatus, null, null, null);
        }

        public IQueryable<Product> GetProductsForFormGeneration(int productTypeId, PublishStatus publishStatus, ProofDeliveryType? proofDeliveryType, PrintGuideFormType? pgft, Region? region)
        {
            var query = from p in db.Products
                        join cp in db.ContactProducts on p.id equals cp.productId 
                        where p.isDeleted == false && cp.contactTypeId == 1
                        orderby cp.contactId, p.productName
                        select p;

            if (region != null)
            {
                query = from p in query
                        join c in db.refCommunities on p.communityId equals c.id
                        where c.regionId == (int)region
                        select p;
            }

            //combine accommodations and campgrounds
            if (productTypeId == 1)
            {
                query = from p in query
                        where p.productTypeId == 1 || p.productTypeId == 3
                        select p;
            }
            else
            {
                query = from p in query
                        where p.productTypeId == productTypeId
                        select p;
            }

            if (publishStatus == PublishStatus.Published)
            {
                query = from p in query
                        where p.isActive && (p.isValid || p.overrideErrors)
                        select p;

            }
            else
            {
                query = from p in query
                        where !p.isActive || (!p.isValid && !p.overrideErrors)
                        select p;
            }

            if (proofDeliveryType != null)
            {
                int pdt = (proofDeliveryType == ProofDeliveryType.Email)
                              ? (int) EditorCheck.EmailProof
                              : (int) EditorCheck.FaxProof;
                
                List<int> atl = new List<int>(_listingProofAttTrue) {pdt};

                query = ((from p in query
                          join pa in db.ProductAttributes on p.id equals pa.productId
                          select p).Where(
                             p =>
                             (p.ProductAttributes.Where(pa => (atl.Contains(pa.attributeId))).Count() ==
                              atl.Count) &&
                             (p.ProductAttributes.Where(pa => (_listingProofAttFalse.Contains(pa.attributeId))).Count() == 0))).Distinct();
            }

            if (pgft == PrintGuideFormType.ListingProof)
            {
                query = from p in query
                        orderby p.productName
                        select p;
            }
            
            return query;
        }
        
        public IQueryable<Product> GetProductsByName(string productName)
        {
            var query = from p in db.Products
                        where !p.isDeleted
                        && p.productName.Equals(productName)
                        select p;

            return query;
        }

        public IQueryable<Product> GetProductsByLicenseNumber(string licenseNumber)
        {
            var query = from p in db.Products
                        where !p.isDeleted
                        && p.licenseNumber == licenseNumber
                        select p;

            return query;
        }

        public IQueryable<refCommunity> GetAllCommunities()
        {
            var query = from c in db.refCommunities
                        orderby c.communityName
                        select c;

            return query;
        }

        public IQueryable<refCounty> GetAllCounties()
        {
            var query = from c in db.refCounties
                        orderby c.countyName
                        select c;

            return query;
        }

        public IQueryable<refRegion> GetAllRegions()
        {
            var query = from r in db.refRegions
                        orderby r.regionName
                        select r;

            return query;
        }

        public IQueryable<refSubRegion> GetAllSubRegions()
        {
            var query = from sr in db.refSubRegions
                        orderby sr.subRegionName
                        select sr;

            return query;

        }
        
        public IQueryable<refCounty> GetCounties(List<int> countyIds)
        {
            var query = from c in db.refCounties
                        where countyIds.Contains(c.id)
                        orderby c.countyName
                        select c;

            return query;
        }

        public IQueryable<refRegion> GetRegions(List<int> regionIds)
        {
            var query = from r in db.refRegions
                        where regionIds.Contains(r.id)
                        orderby r.regionName
                        select r;

            return query;
        }

        public IQueryable<refSubRegion> GetSubRegions(List<int> subRegionIds)
        {
            var query = from sr in db.refSubRegions
                        where subRegionIds.Contains(sr.id)
                        orderby sr.subRegionName
                        select sr;

            return query;

        }

        public Product GetProduct(int id)
        {
            return GetProduct(id, false);
        }

        public Product GetProduct(int id, bool includeDeleted)
        {
            return db.Products.SingleOrDefault(p => p.id == id && ( includeDeleted || ((!p.isDeleted) ) ));
        }

        public refCommunity GetCommunity (short id)
        {
            return db.refCommunities.SingleOrDefault(c => c.id == id);
        }

        public refSubRegion GetSubRegion(short id)
        {
            return db.refSubRegions.SingleOrDefault(s => s.id == id);
        }

        public IQueryable<ProductRegionOfOperation> GetProductRegionsOfOperation (int productId)
        {
            var query = from pro in db.ProductRegionOfOperations
                        where pro.productId == productId
                        select pro;
            
            return query;
        }

        public IQueryable<ProductTranslation> GetProductTranslations(int productId)
        {
            var query = from pt in db.ProductTranslations
                        where pt.productId == productId
                        select pt;

            return query;
        }

        public IQueryable<TranslationStatus> GetTranslationStatus(int productId)
        {
            return GetTranslationStatus(productId, null, null);
        }

        public IQueryable<TranslationStatus> GetTranslationStatus (int productId, ProductField pf)
        {
            return GetTranslationStatus(productId, pf, null);
        }

        public IQueryable<TranslationStatus> GetTranslationStatus(int productId, ProductField? pf, int? secondaryId)
        {
            var query = from ts in db.TranslationStatus
                        where ts.productId == productId
                        select ts;

            if (pf != null)
            {
                query = from ts in query
                        where ts.fieldId == (byte)pf
                        select ts; 
            }

            if (secondaryId != null)
            {
                query = from ts in query
                        where ts.secondaryId == secondaryId
                        select ts; 
            }

            return query;
        }

        public ProductRegionOfOperation AddProductRegionOfOperation (int productId, Region r)
        {
            ProductRegionOfOperation pro = new ProductRegionOfOperation();

            pro.productId = productId;
            pro.regionId = (byte) r;

            db.ProductRegionOfOperations.InsertOnSubmit(pro);
            db.SubmitChanges();
            return pro;
        }

        public void DeleteProductRegionOfOperation(int productId, Region r)
        {
            var q = from pro in db.ProductRegionOfOperations
                    where pro.productId == productId && pro.regionId == (byte) r
                    select pro;

            db.ProductRegionOfOperations.DeleteAllOnSubmit(q);
            db.SubmitChanges();
        }

        public TranslationStatus AddTranslationStatus (int productId, ProductField pf, int? secondaryId)
        {
            TranslationStatus ts = new TranslationStatus();

            ts.productId = productId;
            ts.fieldId = (byte) pf;
            ts.statusDate = DateTime.Now;
            ts.secondaryId = secondaryId;

            db.TranslationStatus.InsertOnSubmit(ts);
            db.SubmitChanges();
            return ts;
        }

        public void DeleteTranslationStatus(int productId, ProductField pf, int? secondaryId)
        {
            var q = from ts in db.TranslationStatus
                    where ts.productId == productId && ts.fieldId == (byte) pf
                    select ts;

            if (secondaryId != null)
            {
                q.Where(ts => ts.secondaryId == secondaryId);
            }
            
            db.TranslationStatus.DeleteAllOnSubmit(q);
            db.SubmitChanges();
        }

        public PrintVersion GetPrintVersion(int productId)
        {
            return db.PrintVersions.SingleOrDefault(p => p.productId == productId);
        }

        public IQueryable<PrintVersionTranslation> GetPrintVersionTranslations(int productId)
        {
            var query = from pvt in db.PrintVersionTranslations
                        where pvt.productId == productId
                        select pvt;

            return query;
        }

        public Product AddProduct (int contactId, string productName, byte productTypeId, string line1, string line2, string line3, short? communityId, string postalCode, string proprietor, 
            string email, string web, string telephone, string tollfree, string fax, string userId)
        {
            Product p = new Product();

            p.productTypeId = productTypeId;
            p.productName = productName;
            p.line1 = line1;
            p.line2 = line2;
            p.line3 = line3;
            p.communityId = communityId;
            p.postalCode = postalCode;

            p.proprietor = proprietor;
            p.email = email;
            p.web = web;
            p.telephone = telephone;
            p.tollfree = tollfree;
            p.fax = fax;

            p.periodOfOperationTypeId = (byte)PeriodOfOperationType.AllYear;

            p.lastModifiedBy = userId;
            p.lastModifiedDate = DateTime.Now;

            p.confirmationDueDate = GetDefaultConfirmationFormDueDate((ProductType) productTypeId);

            db.Products.InsertOnSubmit(p);
            db.SubmitChanges();

            ContactProduct cp = new ContactProduct();
            cp.contactId = contactId;
            cp.productId = p.id;
            cp.contactTypeId = 1;
            
            db.ContactProducts.InsertOnSubmit(cp);
            db.SubmitChanges();

            //set up empty records for future use
            AddProductTranslation(p.id, "en", "", "", "", "", "", "");
            AddProductTranslation(p.id, "fr", "","", "", "", "", "");

            AddPrintVersion(p.id, null, null, null, null, null, null, null, false, false, (byte) PeriodOfOperationType.AllYear, null, false, null, null);

            AddPrintVersionTranslation(p.id, "en", "", "", "", "", "");
            AddPrintVersionTranslation(p.id, "fr", "", "", "", "", "");

            return p;
        }

        public ProductCanadaSelectRating AddProductCanadaSelectRating(int productId, CanadaSelectRatingType csrt, byte rating)
        {
            ProductCanadaSelectRating csr = new ProductCanadaSelectRating();

            csr.productId = productId;
            csr.canadaSelectRatingTypeId = (byte)csrt;
            csr.ratingValue = rating;

            db.ProductCanadaSelectRatings.InsertOnSubmit(csr);
            db.SubmitChanges();
            
            return csr;
        }

        public ProductCaaRating AddProductCaaRating(int productId, CaaRatingType crt, byte rating)
        {
            ProductCaaRating pcr = new ProductCaaRating();

            pcr.productId = productId;
            
            pcr.caaRatingTypeId = (byte)crt;
            pcr.ratingValue = rating;

            db.ProductCaaRatings.InsertOnSubmit(pcr);
            db.SubmitChanges();

            return pcr;
        }

        public ProductTranslation AddProductTranslation(int productId, string languageId, string dateDescription, string directions, string keywords, string rateDescription, string webDescription, string cancellationPolicy)
        {
            ProductTranslation pt = new ProductTranslation();
            pt.productId = productId;
            pt.languageId = languageId;
            pt.dateDescription = dateDescription;
            pt.directions = directions;
            pt.keywords = keywords;
            pt.rateDescription = rateDescription;
            pt.webDescription = webDescription;
            pt.cancellationPolicy = cancellationPolicy;

            db.ProductTranslations.InsertOnSubmit(pt);
            db.SubmitChanges();
            return pt;
        }

        public PrintVersionTranslation AddPrintVersionTranslation(int productId, string languageId, string dateDescription, string directions, string printDescription, string rateDescription, string unitDescription)
        {
            PrintVersionTranslation pvt = new PrintVersionTranslation();
            pvt.productId = productId;
            pvt.languageId = languageId;
            
            pvt.dateDescription = dateDescription;
            pvt.directions = directions;
            pvt.printDescription = printDescription;
            pvt.rateDescription = rateDescription;
            pvt.unitDescription = unitDescription;
            
            db.PrintVersionTranslations.InsertOnSubmit(pvt);
            db.SubmitChanges();
            return pvt;
        }

        public PrintVersion AddPrintVersion(int productId, decimal? highRate, decimal? lowRate, decimal? extraPersonRate, byte? openMonth, byte? openDay, byte? closeMonth, byte? closeDay, bool hasOffSeasonRates, bool hasOffSeasonDates,
            byte periodOfOperation, byte? cancellationPolicyId, bool noTax, byte? ratePeriodId, byte? rateTypeId)
        {
            PrintVersion pv = new PrintVersion();
            pv.productId = productId;
            
            pv.highRate = highRate;
            pv.lowRate = lowRate;
            pv.extraPersonRate = extraPersonRate;
            pv.openMonth = openMonth;
            pv.openDay = openDay;
            pv.closeMonth = closeMonth;
            pv.closeDay = closeDay;
            pv.hasOffSeasonRates = hasOffSeasonRates;
            pv.hasOffSeasonDates = hasOffSeasonDates;
            pv.periodOfOperationTypeId = periodOfOperation;
            pv.cancellationPolicyId = cancellationPolicyId;
            pv.noTax = noTax;
            pv.ratePeriodId = ratePeriodId;
            pv.rateTypeId = rateTypeId;

            db.PrintVersions.InsertOnSubmit(pv);
            db.SubmitChanges();
            return pv;
        }

        public void DeleteUrl(int urlId)
        {
            var q = from ut in db.UrlTranslations
                    where ut.urlId == urlId
                    select ut;
            db.UrlTranslations.DeleteAllOnSubmit(q);

            var tsq = from ts in db.TranslationStatus
                    where
                        ts.secondaryId == urlId &&
                        (ts.fieldId == (byte) ProductField.ExternalLinkTitle ||
                         ts.fieldId == (byte) ProductField.ExternalLinkDescription)
                    select ts;
            db.TranslationStatus.DeleteAllOnSubmit(tsq);

            Url u = GetUrl(urlId);
            db.Urls.DeleteOnSubmit(u);
            db.SubmitChanges();
        }

        public Url AddUrl(int productId, string url, byte urlTypeId, decimal? distance, string userId)
        {
            Url u = new Url();

            u.url = url;
            u.productId = productId;
            u.urlTypeId = urlTypeId;
            u.distance = distance;

            u.lastModifiedBy = userId;
            u.lastModifiedDate = DateTime.Now;

            db.Urls.InsertOnSubmit(u);
            db.SubmitChanges();

            return u;
        }

        public UrlTranslation AddUrlTranslation(Url u, string languageId, string title, string description)
        {
            UrlTranslation ut = new UrlTranslation();

            ut.languageId = languageId;
            ut.title = title;
            ut.description = description;

            u.UrlTranslations.Add(ut);
            db.SubmitChanges();
            return ut;
        }

        public Url GetUrl(int urlId)
        {
            return db.Urls.SingleOrDefault(u => u.id == urlId);
        }

        public IQueryable<Url> GetUrls (int productId)
        {
            var query = from u in db.Urls
                        where u.productId == productId
                        select u;

            return query;
        }

        public UrlTranslation GetUrlTranslation(int urlId, string languageId)
        {
            return db.UrlTranslations.SingleOrDefault(ut => ut.urlId == urlId && ut.languageId == languageId);
        }

        public ProductTranslation GetProductTranslation (int productId, string languageId)
        {
            return db.ProductTranslations.SingleOrDefault(pt => pt.productId == productId && pt.languageId == languageId);
        }

        public PrintVersionTranslation GetPrintVersionTranslation(int productId, string languageId)
        {
            return db.PrintVersionTranslations.SingleOrDefault(pvt => pvt.productId == productId && pvt.languageId == languageId);
        }

        public void DeleteProductAttributes(Product p)
        {
            IQueryable<ProductAttribute> pal = GetProductAttributes(p.id);

            db.ProductAttributes.DeleteAllOnSubmit(pal);
            db.SubmitChanges();
        }

        public void DeleteProductAttributes (Product p, AttributeGroup attributeGroup)
        {
            IQueryable<ProductAttribute> pal = GetProductAttributes((short)attributeGroup, p.id, p.productTypeId);

            db.ProductAttributes.DeleteAllOnSubmit(pal);
            db.SubmitChanges();
        }

        public IQueryable<ProductCanadaSelectRating> GetProductCanadaSelectRatings(int productId)
        {
            var query = from pcsr in db.ProductCanadaSelectRatings
                        where pcsr.productId == productId
                        select pcsr;
            return query;
        }

        public void DeleteProductCanadaSelectRatings(int productId)
        {
            IQueryable<ProductCanadaSelectRating> pal = GetProductCanadaSelectRatings(productId);

            db.ProductCanadaSelectRatings.DeleteAllOnSubmit(pal);
            db.SubmitChanges();
        }

        public IQueryable<ProductCaaRating> GetProductCaaRatings(int productId)
        {
            var query = from pcsr in db.ProductCaaRatings
                        where pcsr.productId == productId
                        select pcsr;
            return query;
        }

        public void DeleteProductCaaRatings(int productId)
        {
            IQueryable<ProductCaaRating> pal = GetProductCaaRatings(productId);

            db.ProductCaaRatings.DeleteAllOnSubmit(pal);
            db.SubmitChanges();
        }

        public void Save()
        {
            db.SubmitChanges();
        }

        public IQueryable<ProductCatalogue.DataAccess.Attribute> GetGroupAttributes(short attributeGroupId)
        {
            var query = from a in db.Attributes
                        where a.attributeGroupId == attributeGroupId
                        select a;
            return query;
        }

        public IQueryable<ProductAttribute> GetProductAttributes(int productId)
        {
            var query = from pa in db.ProductAttributes
                        where pa.productId == productId 
                        select pa;
            return query;
        }

        public IQueryable<ProductAttribute> GetProductAttributes (short attributeGroupId, int productId, byte productTypeId)
        {
            var query = from pa in db.ProductAttributes
                        where pa.attributeGroupId == attributeGroupId && pa.productId == productId && pa.productTypeId == productTypeId
                        select pa;
            return query;
        }

        public ProductAttribute CreateProductAttribute(Product p, byte attributeGroupId, short attributeId)
        {

            ProductAttribute pa = CreateProductAttribute(attributeId, attributeGroupId, p.id, p.productTypeId);
            //p.ProductAttributes.Add(pa);
            return pa;
        }

        private ProductAttribute CreateProductAttribute (short attributeId, byte attributeGroupId,int productId,byte productTypeId)
        {
            //start temporary logic for import
            var query = from pa in db.ProductAttributes
                        where pa.attributeGroupId == attributeGroupId && pa.productId == productId && pa.productTypeId == productTypeId && pa.attributeId == attributeId
                        select pa;

            if (query.Count() > 0)
            {
                return query.First();
            }
            //end temporary logic for import


            ProductAttribute productAttribute = new ProductAttribute();
            productAttribute.attributeId = attributeId;
            productAttribute.attributeGroupId = attributeGroupId;
            productAttribute.productId = productId;
            productAttribute.productTypeId = productTypeId;

            db.ProductAttributes.InsertOnSubmit(productAttribute);
            db.SubmitChanges();
            return productAttribute;
        }


        public void AddContactProduct(int productId, int contactId, byte contactTypeId)
        {
            ContactProduct cp = new ContactProduct();
            cp.contactId = contactId;
            cp.productId = productId;
            cp.contactTypeId = contactTypeId;

            db.ContactProducts.InsertOnSubmit(cp);
            db.SubmitChanges();
         }

        public void DeleteContactProduct(int productId, int contactId)
        {
            var q = from cp in db.ContactProducts
                    where cp.productId == productId && cp.contactId == contactId
                    select cp;

            db.ContactProducts.DeleteAllOnSubmit(q);
            db.SubmitChanges();
        }

        

        public ProductPaymentType AddProductPaymentType(int productId, byte paymentTypeId)
        {
            ProductPaymentType pt = new ProductPaymentType();
            pt.productId = productId;
            pt.paymentTypeId = paymentTypeId;

            db.ProductPaymentTypes.InsertOnSubmit(pt);
            db.SubmitChanges();
            return pt;
        }

        public void DeleteProductPaymentType(int productId, byte paymentTypeId)
        {
            var q = from ppt in db.ProductPaymentTypes
                    where ppt.productId == productId && ppt.paymentTypeId == paymentTypeId
                    select ppt;

            db.ProductPaymentTypes.DeleteAllOnSubmit(q);
            db.SubmitChanges();
        }

        public IQueryable<ProductPaymentType> GetProductPaymentTypes(int productId)
        {
            var query = from ppt in db.ProductPaymentTypes
                        where ppt.productId == productId
                        select ppt;
            return query;
        }

        public void DeleteProductPaymentTypes(int productId)
        {
            IQueryable<ProductPaymentType> ppt = GetProductPaymentTypes(productId);

            db.ProductPaymentTypes.DeleteAllOnSubmit(ppt);
            db.SubmitChanges();
        }

        public Note AddNote(int productId, string note, DateTime? reminderDate, string userId)
        {
            Note n = new Note();
            n.noteBody = note;
            n.reminderDate = reminderDate;
            n.creationDate = DateTime.Now;

            n.lastModifiedBy = userId;
            n.lastModifiedDate = DateTime.Now;

            db.Notes.InsertOnSubmit(n);
            db.SubmitChanges();

            ProductNote pn = new ProductNote();
            pn.productId = productId;
            pn.noteId = n.id;
            db.ProductNotes.InsertOnSubmit(pn);
            db.SubmitChanges();

            return n;
        }

        public Note AddNote(Product p, string note, DateTime? reminderDate, string userId)
        {
            return AddNote(p.id, note, reminderDate, userId);
        }

        public Note GetNote(int noteId)
        {
            return db.Notes.SingleOrDefault(n => n.id == noteId);
        }

        public void DeleteNote(int noteId)
        {
            var q = from pn in db.ProductNotes
                    where pn.noteId == noteId
                    select pn;

            db.ProductNotes.DeleteAllOnSubmit(q);

            Note n = GetNote(noteId);
            
            db.Notes.DeleteOnSubmit(n);
            db.SubmitChanges();
        }

        public IQueryable<Note> GetProductNotes(int productId)
        {
            var query = from n in db.Notes
                        join pn in db.ProductNotes on n.id equals pn.noteId
                        where pn.productId == productId
                        orderby n.creationDate descending
                        select n;

            return query;
        }

        public IQueryable<Contact> GetProductContacts(int productId)
        {
            var query = from c in db.Contacts
                        join cp in db.ContactProducts on c.id equals cp.contactId
                        where cp.productId == productId
                        select c;

            return query;
        }

        public ProductDescription GetProductDescription(int productId, byte descriptionTypeId, string languageId)
        {
            return db.ProductDescriptions.SingleOrDefault(pd => pd.productId == productId && pd.descriptionTypeId == descriptionTypeId && pd.languageId == languageId);
        }

        public IQueryable<ProductDescription> GetProductDescriptions(int productId, byte descriptionTypeId)
        {
            var query = from pd in db.ProductDescriptions
                        where pd.productId == productId && pd.descriptionTypeId == descriptionTypeId
                        select pd;

            return query;
        }

        public IQueryable<ProductDescription> GetProductDescriptions(int productId)
        {
            var query = from pd in db.ProductDescriptions
                        where pd.productId == productId 
                        select pd;

            return query;
        }
        
        public ProductDescription AddProductDescription (int productId, string languageId, byte descriptionTypeId, string description)
        {
            ProductDescription pd = new ProductDescription();

            pd.productId = productId;
            pd.languageId = languageId;
            pd.descriptionTypeId = descriptionTypeId;
            pd.description = description;

            db.ProductDescriptions.InsertOnSubmit(pd);
            db.SubmitChanges();
            return pd;
        }

        public void DeleteProductDescription(int productId, byte descriptionTypeId)
        {
            IQueryable<ProductDescription> pdl = GetProductDescriptions(productId, descriptionTypeId);

            db.ProductDescriptions.DeleteAllOnSubmit(pdl);

            var tsq = from ts in db.TranslationStatus
                      where (ts.fieldId == (int)ProductField.SupplementalDescription && ts.secondaryId == descriptionTypeId)
                      select ts;
            db.TranslationStatus.DeleteAllOnSubmit(tsq);

            db.SubmitChanges();
        }

        public List<SearchProductsResult> SearchProducts(int productId, string productName, byte productTypeId, short communityId, byte regionId, string checkInId, string fileMakerId, string licenseNumber, string businessName, string contactFirstName, string contactLastName, string filterLetter, byte? isActive, byte? isValid, byte? overrideErrors)
        {
            return db.SearchProducts(productId, productName, productTypeId, communityId, regionId, checkInId, fileMakerId, licenseNumber,
                              businessName, contactFirstName, contactLastName, filterLetter, isActive,isValid,overrideErrors).ToList();
        }


        public void SetProductPrimaryContact(int productId, int contactId)
        {
            var query = from cp in db.ContactProducts where cp.productId == productId select cp;
            foreach (var contactProduct in query)
            {
                if (contactProduct.contactId == contactId)
                {
                    contactProduct.contactTypeId = (int)ContactType.Primary;
                }
                else
                {
                    contactProduct.contactTypeId = (int)ContactType.Secondary;
                }
            }

            db.SubmitChanges();
        }

        public void LogProductVersion (int productId, Action a, string userId)
        {
            Product p = GetProduct(productId);
            XElement xml = GenerateProductXml(p);
            
            VersionHistory vh = new VersionHistory();
            vh.productId = productId;
            vh.modificationDate = DateTime.Now;
            vh.modifiedBy = userId;
            vh.typeId = (byte)VersionHistoryType.Product;
            vh.actionId = (byte) a;

            vh.versionXml = xml.ToString();

            db.VersionHistories.InsertOnSubmit(vh);

            db.SubmitChanges();
        }

        public void LogUrlVersion(int urlId, Action a, string userId)
        {
            Url u = GetUrl(urlId);
            XElement xml = GenerateUrlXml(u);

            VersionHistory vh = new VersionHistory();
            vh.productId = u.productId;
            vh.secondaryId = urlId;
            vh.modificationDate = DateTime.Now;
            vh.modifiedBy = userId;
            vh.typeId = (byte) VersionHistoryType.Url;
            vh.versionXml = xml.ToString();
            vh.actionId = (byte) a;

            db.VersionHistories.InsertOnSubmit(vh);

            db.SubmitChanges();
        }

        public void LogDescriptionVersion(int productId, byte descriptionTypeId, Action a, string userId)
        {
            //IQueryable<ProductDescription> pdq = GetProductDescriptions(productId, descriptionTypeId);
            XElement xml = GenerateDescriptionXml(productId, descriptionTypeId);

            VersionHistory vh = new VersionHistory();
            vh.productId = productId;
            vh.secondaryId = descriptionTypeId;
            vh.modificationDate = DateTime.Now;
            vh.modifiedBy = userId;
            vh.typeId = (byte)VersionHistoryType.GuideDescription;
            vh.versionXml = xml.ToString();
            vh.actionId = (byte)a;

            db.VersionHistories.InsertOnSubmit(vh);

            db.SubmitChanges();
        }

        public VersionHistory GetVersion(int versionId)
        {
            return db.VersionHistories.SingleOrDefault(vh => vh.id == versionId);
        }

        public VersionHistory GetPreviousVersion(int versionId, int productId, DateTime modificationDate)
        {
            var q = (from vh in db.VersionHistories
                    where vh.productId == productId
                    && vh.typeId == (byte) VersionHistoryType.Product
                    && vh.modificationDate <= modificationDate
                    && vh.id != versionId
                    orderby vh.modificationDate descending 
                    select vh).ToList();

            return q.FirstOrDefault();

            //return db.VersionHistories.SingleOrDefault(vh => vh.id == versionId);
        }

        public IQueryable<VersionHistory> GetProductVersions(int productId)
        {
            var query = from vh in db.VersionHistories
                        where vh.productId == productId
                        orderby vh.modificationDate descending 
                        select vh;

            return query;
        }

        public void DeleteProduct(int productId, string userId)
        {
            Product p = GetProduct(productId);
            p.isDeleted = true;

            p.lastModifiedBy = userId;
            p.lastModifiedDate = DateTime.Now;

            db.SubmitChanges();
        }

        public FileMakerArchive GetFileMakerArchive (string fileMakerId, byte archiveTypeId)
        {
            return db.FileMakerArchives.SingleOrDefault(fma => fma.fileMakerId == fileMakerId && fma.archiveTypeId == archiveTypeId);
        }

        public XElement GenerateDescriptionXml(int productId, byte descriptionTypeId)
        {
            //XElement xml = new XElement("descriptions",
            //                            new XElement("description",
            //                                         new XAttribute("productId", productId),
            //                                         new XAttribute("descriptionTypeId", descriptionTypeId),

            //                                         new XElement("descriptionTranslations",
            //                                                      from pd in db.ProductDescriptions
            //                                                      where pd.productId == productId && pd.descriptionTypeId == descriptionTypeId
            //                                                      select
            //                                                          new XElement("descriptionTranslation",
            //                                                                       new XAttribute("languageId",
            //                                                                                      pd.languageId),
            //                                                                       new XElement("description",
            //                                                                                    pd.description)
            //                                                          )
            //                                             )
            //                                    )
            //                            );

            XElement xml = new XElement("descriptionTranslations",
                                                                new XAttribute("productId", productId),
                                                                new XAttribute("descriptionTypeId", descriptionTypeId),
                                                                  from pd in db.ProductDescriptions
                                                                  where pd.productId == productId && pd.descriptionTypeId == descriptionTypeId
                                                                  select
                                                                      new XElement("descriptionTranslation",
                                                                                   new XAttribute("languageId",
                                                                                                  pd.languageId),
                                                                                   pd.description
                                                                      )
                                                         );

            return xml; 
        }


        public XElement GenerateUrlXml (Url u)
        {
            XElement xml = new XElement("links",
                                        new XElement("link",
                                                     new XAttribute("id", u.id),
                                                     new XAttribute("productId", u.productId),
                                                     new XElement("url", u.url),
                                                     new XElement("urlTypeId", u.urlTypeId),
                                                     new XElement("distance", u.distance),
                                                     new XElement("urlTranslations",
                                                                  from ut in db.UrlTranslations
                                                                  where ut.urlId == u.id
                                                                  select
                                                                      new XElement("urlTranslation",
                                                                                   new XAttribute("languageId",
                                                                                                  ut.languageId),
                                                                                   new XElement("title", ut.title),
                                                                                   new XElement("description",
                                                                                                ut.description)
                                                                      )
                                                         )
                                                )
                                        );
            return xml; 
        }

        public XElement GenerateProductXml (Product p)
        {
            BusinessBs businessBs = new BusinessBs();
            //ProductCatalogue.DataAccess.Contact c = businessBs.GetPrimaryContact(p);

            IQueryable<Contact> cq = GetProductContacts(p.id);
            
            
            XElement xml = new XElement("products",
                            new XElement("product",
                                new XAttribute("id", p.id),
                                new XElement("productName", p.productName),
                                new XElement("productTypeId", p.productTypeId),
                                new XElement("line1", p.line1),
                                new XElement("line2", p.line2),
                                new XElement("line3", p.line3),
                                new XElement("postalCode", p.postalCode),
                                new XElement("communityId", p.communityId),
                                new XElement("latitude", p.latitude),
                                new XElement("longitude", p.longitude),
                                new XElement("proprietor", p.proprietor),
                                new XElement("email", p.email),
                                new XElement("web", p.web),
                                new XElement("telephone", p.telephone),
                                new XElement("secondaryPhone", p.secondaryPhone),
                                new XElement("offSeasonPhone", p.offSeasonPhone),
                                new XElement("fax", p.fax),
                                new XElement("tollfree", p.tollfree),
                                new XElement("reservationsOnly", p.reservationsOnly),
                                new XElement("isCheckInMember", p.isCheckinMember),
                                new XElement("checkInId", p.checkInId),
                                new XElement("accessCanadaRating", p.accessCanadaRating),
                                new XElement("lowRate", p.lowRate),
                                new XElement("highRate", p.highRate),
                                new XElement("extraPersonRate", p.extraPersonRate),
                                new XElement("periodOfOperationTypeId", p.periodOfOperationTypeId),
                                new XElement("rateTypeId", p.rateTypeId),
                                new XElement("ratePeriodId", p.ratePeriodId),
                                new XElement("primaryGuideSectionId", p.primaryGuideSectionId),
                                new XElement("openMonth", p.openMonth),
                                new XElement("openDay", p.openDay),
                                new XElement("closeMonth", p.closeMonth),
                                new XElement("closeDay", p.closeDay),
                                new XElement("hasOffSeasonRates", p.hasOffSeasonRates),
                                new XElement("noTax", p.noTax),
                                new XElement("cancellationPolicyId", p.cancellationPolicyId),
                                //new XElement("fileMakerId", p.fileMakerId),
                                new XElement("parkingSpaces", p.parkingSpaces),
                                new XElement("seatingCapacityInterior", p.seatingCapacityInterior),
                                new XElement("seatingCapacityExterior", p.seatingCapacityExterior),
                                new XElement("otherMemberships", p.otherMemberships),
                                new XElement("licenseNumber", p.licenseNumber),
                                new XElement("checkboxLabel", p.checkboxLabel),
                                new XElement("paymentReceived", p.paymentReceived),
                                new XElement("paymentAmount", p.paymentAmount),
                                new XElement("confirmationDueDate", p.confirmationDueDate.ToString()),
                                new XElement("ownershipTypeId", p.ownershipTypeId),
                                new XElement("sustainabilityTypeId", p.sustainabilityTypeId),
                                new XElement("capacityTypeId", p.capacityTypeId),
                                new XElement("isTicketed", p.isTicketed),
                                new XElement("isValid", p.isValid),
                                new XElement("isComplete", p.isComplete),
                                new XElement("isActive", p.isActive),
                                new XElement("overrideErrors", p.overrideErrors),
                                new XElement("isDeleted", p.isDeleted),
                                new XElement("lastModifiedBy", p.lastModifiedBy),
                                new XElement("lastModifiedDate", p.lastModifiedDate),
                                new XElement("contacts",
                                    from c in cq
                                    select 
                                    new XElement("contact",
                                        new XAttribute("contactId", c.id ),
                                        //new XAttribute("contactTypeId", c.ContactProducts.First().contactTypeId),
                                        new XAttribute("contactTypeId", (from a in c.ContactProducts
                                                                        where a.productId == p.id
                                                                        select a).First().contactTypeId),
                                        new XElement("firstName", c.firstName),
                                        new XElement("lastName", c.lastName)
                                    )
                                ),
                                new XElement("productAttributes",
                                    from pa in db.ProductAttributes
                                    where pa.productId == p.id
                                    orderby pa.attributeGroupId, pa.attributeId
                                    select
                                    new XElement("productAttribute",
                                        new XAttribute("attributeGroupId", pa.attributeGroupId),
                                        new XAttribute("attributeId", pa.attributeId)
                                    )
                                ),
                                new XElement("productCaaRatings",
                                    from pr in db.ProductCaaRatings
                                    where pr.productId == p.id
                                    select
                                    new XElement("productCaaRating",
                                        new XAttribute("caaRatingTypeId", pr.caaRatingTypeId),
                                        new XAttribute("ratingValue", pr.ratingValue)
                                    )
                                ),
                                new XElement("productCanadaSelectRatings",
                                    from pcsr in db.ProductCanadaSelectRatings
                                    where pcsr.productId == p.id
                                    select
                                    new XElement("productCanadaSelectRating",
                                        new XAttribute("canadaSelectRatingTypeId", pcsr.canadaSelectRatingTypeId),
                                        new XAttribute("ratingValue", pcsr.ratingValue)
                                    )
                                ),
                                new XElement("productDescriptions",
                                    from pd in db.ProductDescriptions
                                    where pd.productId == p.id
                                    select
                                    new XElement("productDescription",
                                        new XAttribute("language", pd.languageId),
                                        new XAttribute("descriptionTypeId", pd.descriptionTypeId),
                                        new XElement("description", pd.description)
                                    )
                                ),
                                new XElement("productPaymentTypes",
                                    from ppt in db.ProductPaymentTypes
                                    where ppt.productId == p.id
                                    select
                                    new XElement("productPaymentType",
                                        new XAttribute("paymentTypeId", ppt.paymentTypeId)
                                    )
                                ),
                                new XElement("productRegionOfOperations",
                                    from pro in db.ProductRegionOfOperations
                                    where pro.productId == p.id
                                    select
                                    new XElement("productRegionOfOperation",
                                        new XAttribute("regionId", pro.regionId)
                                    )
                                ),
                                new XElement("productTranslations",
                                    from pt in db.ProductTranslations
                                    where pt.productId == p.id
                                    select
                                    new XElement("productTranslation",
                                        new XAttribute("languageId", pt.languageId),
                                        new XElement("dateDescription", pt.dateDescription),
                                        new XElement("directions", pt.directions),
                                        new XElement("keywords", pt.keywords),
                                        new XElement("rateDescription", pt.rateDescription),
                                        new XElement("webDescription", pt.webDescription),
                                        new XElement("cancellationPolicy", pt.cancellationPolicy)
                                    )
                                ),
                                new XElement("printVersion",
                                    new XElement("periodOfOperationTypeId", (p.PrintVersion != null) ? p.PrintVersion.periodOfOperationTypeId.ToString() : ""),
                                    new XElement("openMonth", (p.PrintVersion != null) ? p.PrintVersion.openMonth.ToString() : ""),
                                    new XElement("openDay", (p.PrintVersion != null) ? p.PrintVersion.openDay.ToString() : "" ),
                                    new XElement("closeMonth", (p.PrintVersion != null) ? p.PrintVersion.closeMonth.ToString() : ""),
                                    new XElement("closeDay", (p.PrintVersion != null) ?  p.PrintVersion.closeDay.ToString() : ""),
                                    new XElement("lowRate", (p.PrintVersion != null) ? p.PrintVersion.lowRate.ToString() : ""),
                                    new XElement("highRate", (p.PrintVersion != null) ? p.PrintVersion.highRate.ToString() : ""),
                                    new XElement("rateTypeId", (p.PrintVersion != null) ? p.PrintVersion.rateTypeId.ToString() : ""),
                                    new XElement("ratePeriodId", (p.PrintVersion != null) ? p.PrintVersion.ratePeriodId.ToString() : ""),
                                    new XElement("hasOffSeasonRates", (p.PrintVersion != null) ? p.PrintVersion.hasOffSeasonRates.ToString() : ""),
                                    new XElement("cancellationPolicyId", (p.PrintVersion != null) ? p.PrintVersion.cancellationPolicyId.ToString() : ""),
                                    new XElement("noTax", (p.PrintVersion != null) ? p.PrintVersion.noTax.ToString() : ""),
                                    new XElement("printVersionTranslations",
                                        from pvt in db.PrintVersionTranslations
                                        where pvt.productId == p.id
                                        select
                                        new XElement("printVersionTranslation",
                                            new XAttribute("languageId", pvt.languageId),
                                            new XElement("dateDescription", pvt.dateDescription),
                                            new XElement("directions", pvt.directions),
                                            new XElement("printDescription", pvt.printDescription),
                                            new XElement("rateDescription", pvt.rateDescription),
                                            new XElement("unitDescription", pvt.unitDescription)
                                        )
                                    )
                                )
                            )
                            );

            return xml;

                        
            
            //XElement xml = new XElement("product",
            //        from c in db.Contacts
            //        orderby c.ContactId
            //        select new XElement("contact",
            //                  new XAttribute("contactId", c.ContactId),
            //                  new XElement("firstName", c.FirstName),
            //                  new XElement("lastName", c.LastName))
            //        );
        }

        private DateTime GetDefaultConfirmationFormDueDate (ProductType pt)
        {
            int currentMonth = DateTime.Now.Month;
            int currentDay = DateTime.Now.Day;

            switch (pt)
            {
                case ProductType.Accommodation:
                    return (currentMonth > 8) ? new DateTime(DateTime.Now.Year + 1, 8, 31) : new DateTime(DateTime.Now.Year, 8, 31);
                case ProductType.Attraction:
                    return (currentMonth > 8 || (currentMonth == 8 && currentDay > 15)) ? new DateTime(DateTime.Now.Year + 1, 8, 15) : new DateTime(DateTime.Now.Year, 8, 15);
                case ProductType.Campground:
                    return (currentMonth > 8) ? new DateTime(DateTime.Now.Year + 1, 8, 31) : new DateTime(DateTime.Now.Year, 8, 31);
                case ProductType.FineArts:
                    return (currentMonth > 9 || (currentMonth == 9 && currentDay > 15)) ? new DateTime(DateTime.Now.Year + 1, 9, 15) : new DateTime(DateTime.Now.Year, 9, 15);
                case ProductType.Outdoors:
                    return (currentMonth > 9 || (currentMonth == 9 && currentDay > 15)) ? new DateTime(DateTime.Now.Year + 1, 9, 15) : new DateTime(DateTime.Now.Year, 9, 15);
                case ProductType.Restaurants:
                    return (currentMonth > 9) ? new DateTime(DateTime.Now.Year + 1, 9, 30) : new DateTime(DateTime.Now.Year, 9, 30);
                case ProductType.TourOps:
                    return (currentMonth > 9) ? new DateTime(DateTime.Now.Year + 1, 9, 15) : new DateTime(DateTime.Now.Year, 9, 15);
                default:
                    return DateTime.Now;

            }
        }

        //private IQueryable<Product> SearchProducts(string productName, List<ProductType> productTypes, int? communityId, Region? region,
        //   List<int> attListTrueAnd, List<int> attListFalseAnd, List<int> attListTrueOr, List<int> attListFalseOr)
        //{
        //    var query = from p in db.Products
        //                where p.isDeleted == false
        //                && (productTypes.Count == 0 || productTypes.Contains((ProductType)p.productTypeId))
        //                && (communityId == null || p.communityId == communityId)
        //                select p;

        //    if (region != null)
        //    {
        //        query = from p in query
        //                join rc in db.refCommunities on p.communityId equals rc.id
        //                where rc.regionId == (int)region
        //                select p;
        //    }

        //    if (!String.IsNullOrEmpty(productName))
        //    {
        //        query = from p in query
        //                where p.productName.Contains(productName)
        //                select p;
        //    }

        //    if (attListTrueAnd.Count > 0 || attListFalseAnd.Count > 0)
        //    {
        //        query = ((from p in query
        //                  join pa in db.ProductAttributes on p.id equals pa.productId
        //                  select p).Where(
        //                      p =>
        //                      (p.ProductAttributes.Where(pa => (attListTrueAnd.Contains(pa.attributeId))).Count() ==
        //                       attListTrueAnd.Count) &&
        //                      (p.ProductAttributes.Where(pa => (attListFalseAnd.Contains(pa.attributeId))).Count() == 0)))
        //            .Distinct();
        //    }

        //    if (attListTrueOr.Count > 0 || attListFalseOr.Count > 0)
        //    {
        //        query = ((from p in query
        //                      join pa in db.ProductAttributes on p.id equals pa.productId
        //                      select p).Where(p => (p.ProductAttributes.Where(pa => attListTrueOr.Contains(pa.attributeId))).Count() > 0 || (attListFalseOr.Count > 0 && (p.ProductAttributes.Where(pa => attListFalseOr.Contains(pa.attributeId))).Count() == 0))).Distinct();
        //    }

        //    return query;
        //}

        //public IQueryable<Product> SearchProducts(List<string> nameKeywords, List<ProductType> productTypes, int? communityId, Region? region,
        //    List<int> attListTrue, List<int> attListFalse, bool attListUseAnd)
        //{
        //    var query = from p in db.Products
        //                where p.isDeleted == false
        //                && (productTypes.Count == 0 || productTypes.Contains((ProductType) p.productTypeId))
        //                && (communityId == null || p.communityId == communityId)
        //                select p;

        //    if (region != null) 
        //    {
        //        query = from p in query
        //                join rc in db.refCommunities on p.communityId equals rc.id
        //                where rc.regionId == (int)region
        //                select p;
        //    }

        //    if (attListTrue.Count > 0 || attListFalse.Count > 0)
        //    {
        //        if (attListUseAnd)
        //        {
        //            query = ((from p in query
        //                      join pa in db.ProductAttributes on p.id equals pa.productId
        //                      select p).Where(
        //                     p =>
        //                     (p.ProductAttributes.Where(pa => (attListTrue.Contains(pa.attributeId))).Count() ==
        //                      attListTrue.Count) &&
        //                     (p.ProductAttributes.Where(pa => (attListFalse.Contains(pa.attributeId))).Count() == 0))).Distinct();
        //        }
        //        else
        //        {
        //            query = ((from p in query
        //                      join pa in db.ProductAttributes on p.id equals pa.productId
        //                      select p).Where(p => (p.ProductAttributes.Where(pa => attListTrue.Contains(pa.attributeId))).Count() > 0 || (attListFalse.Count > 0 && (p.ProductAttributes.Where(pa => attListFalse.Contains(pa.attributeId))).Count() == 0))).Distinct();
        //        }
        //    }

        //    if (nameKeywords.Count > 0)
        //    {
        //        query = (from p in query
        //                 join pt in db.ProductTranslations on p.id equals pt.productId
        //                 where nameKeywords.Any(nk => pt.keywords.Contains(nk))
        //                 select p).Distinct();
        //    }

        //    return query;
        //}


        //public IQueryable<Product> GetAllProducts()
        //{
        //    return db.Products;
        //}

        //public IQueryable<Product> GetProducts(int productId, string fileMakerId, string checkInId, string productName, byte productTypeId, short communityId, byte regionId, string businessName, string contactLastName)
        //{
        //    var query = from p in db.Products
        //                select p;

        //    if (productId != -1)
        //    {
        //        query.Where(p => p.id == productId);
        //    }

        //    if (fileMakerId != "")
        //    {
        //        query.Where(p => p.fileMakerId == fileMakerId);
        //        return query;
        //    }

        //    if (checkInId != "")
        //    {
        //        query.Where(p => p.checkInId == checkInId);
        //    }

        //    if (productName != "")
        //    {
        //        //query.Where(p => p.productName.Contains(productName));
        //        query = from p in query
        //                where p.productName.Contains(productName)
        //                select p; 
        //    }

        //    if (productTypeId != 0)
        //    {
        //        //query.Where(p => p.productTypeId == productTypeId);
        //        query = from p in query
        //                where p.productTypeId == productTypeId
        //                select p; 
        //    }

        //    if (communityId != 0)
        //    {
        //        query = from p in query
        //                where p.communityId == communityId
        //                select p; 
        //    }

        //    if (regionId != 0)
        //    {
        //        query = from p in query 
        //                join rc in db.refCommunities on p.communityId equals rc.id
        //                where rc.regionId == regionId
        //                select p; 
        //    }

        //    if (businessName != "")
        //    {
        //        query = from p in query
        //                join cp in db.ContactProducts on p.id equals cp.productId
        //                join c in db.Contacts on cp.contactId equals c.id
        //                join b in db.Businesses on c.businessId equals b.id
        //                where b.businessName.Contains(businessName)
        //                select p;
        //    }

        //    if (contactLastName != "")
        //    {
        //        query = from p in query
        //                join cp in db.ContactProducts on p.id equals cp.productId
        //                join c in db.Contacts on cp.contactId equals c.id
        //                where c.lastName.Contains(contactLastName)
        //                select p;
        //    }

        //    return query;
        //}

        public void DeleteUnitNumbers(Product p)
        {
            IQueryable<ProductUnitNumber> punl = GetProductUnitNumbers(p.id);

            db.ProductUnitNumbers.DeleteAllOnSubmit(punl);
            db.SubmitChanges();
            
        }

        public Tag GetTag(string tagName)
        {
            return db.Tags.SingleOrDefault(t => t.tagName == tagName);
            
        }

        public Tag CreateTag (string tagName)
        {
            Tag t = new Tag {tagName = tagName};

            db.Tags.InsertOnSubmit(t);
            db.SubmitChanges();

            return t;
        }

        public void CreateProductTag (int productId, string tagName)
        {
            var t = GetTag(tagName) ?? CreateTag(tagName);

            ProductTag pt = new ProductTag { productId = productId, tagId = t.id };

            db.ProductTags.InsertOnSubmit(pt);
        }

        public IQueryable<ProductTag> GetProductTags(int productId)
        {
            var query = from pt in db.ProductTags
                        where pt.productId == productId
                        select pt;
            return query;
        }

        public void DeleteProductTags(Product p)
        {
            IQueryable<ProductTag> ptl = GetProductTags(p.id);

            db.ProductTags.DeleteAllOnSubmit(ptl);
            db.SubmitChanges();
        }

        public ProductUnitNumber CreateProductUnitNumber(Product p, byte typeId, int unitNumber)
        {
            ProductUnitNumber pun = new ProductUnitNumber();
            pun.productId = p.id;
            pun.unitTypeId = typeId;
            pun.units = unitNumber;
            
            db.ProductUnitNumbers.InsertOnSubmit(pun);
            db.SubmitChanges();
            return pun;
            
        }

        public IQueryable<ProductUnitNumber> GetProductUnitNumbers(int productId)
        {
            var query = from pa in db.ProductUnitNumbers
                        where pa.productId == productId
                        select pa;
            return query;
        }

        public IQueryable<OperationPeriod> GetProductOperationPeriods(int productId)
        {
            var query = from op in db.OperationPeriods
                        where op.productId == productId
                        orderby op.openDate
                        select op;
            return query;
        }

        public OperationPeriod GetOperationPeriod(int operationPeriodId)
        {
            return db.OperationPeriods.SingleOrDefault(op => op.id == operationPeriodId);
        }

        public void DeleteOperationPeriod (int operationPeriodId)
        {
            OperationPeriod op = GetOperationPeriod(operationPeriodId);
            db.OperationPeriods.DeleteOnSubmit(op);
            db.SubmitChanges();
        }

        
        private bool ValidateOperationPeriod(int? operationPeriodId, int productId, DateTime openDate, DateTime? closeDate)
        {
            var opq = GetProductOperationPeriods(productId);

            foreach (OperationPeriod op in opq.Where(op => operationPeriodId != op.id))
            {
                if (closeDate == null && op.closeDate == null)
                {
                    return false;
                }

                if (op.openDate < openDate && op.closeDate > openDate)
                {
                    return false;
                }

                if (op.openDate < closeDate && op.closeDate > closeDate)
                {
                    return false;
                }

                if (op.openDate > openDate && ((op.closeDate != null && op.closeDate < closeDate) || closeDate == null))
                {
                    return false;
                }
            }
            return true;
        }

        public void ProcessOperationPeriod(int? operationPeriodId, int productId, DateTime openDate, DateTime? closeDate)
        {
            //if (!ValidateOperationPeriod(operationPeriodId, productId, openDate, closeDate))
            //{
            //    return;
            //}

            OperationPeriod op;

            if (operationPeriodId != null)
            {
                op = GetOperationPeriod(operationPeriodId.Value);
                op.openDate = openDate;
                op.closeDate = closeDate;
            }
            else
            {
                op = new OperationPeriod { productId = productId, openDate = openDate, closeDate = closeDate };
                db.OperationPeriods.InsertOnSubmit(op);
            }

            db.SubmitChanges();
        }

        public PromotionPeriod GetPromotionPeriod(int promotionPeriodId)
        {
            return db.PromotionPeriods.SingleOrDefault(op => op.id == promotionPeriodId);
        }

        public void ProcessPromotionPeriod(int? promotionPeriodId, int productId, DateTime startDate, DateTime? endDate)
        {
            PromotionPeriod pp;

            if (promotionPeriodId != null)
            {
                pp = GetPromotionPeriod(promotionPeriodId.Value);
                pp.startDate = startDate;
                pp.endDate = endDate;
            }
            else
            {
                pp = new PromotionPeriod { productId = productId, startDate = startDate, endDate = endDate };
                db.PromotionPeriods.InsertOnSubmit(pp);
            }

            db.SubmitChanges();
        }

        public void DeletePromotionPeriod(int promotionPeriodId)
        {
            var pp = GetPromotionPeriod(promotionPeriodId);
            
            db.PromotionPeriods.DeleteOnSubmit(pp);
            db.SubmitChanges();
        }
    }

    
}
