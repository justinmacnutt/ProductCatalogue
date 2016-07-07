using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using ProductCatalogue.BusinessServices;
using ProductCatalogue.DataAccess;
using WebApplication.Utilities;
using WebApplication.ValueObjects;
using ProductCatalogue.DataAccess.Enumerations;
using AttributeGroup = ProductCatalogue.DataAccess.Enumerations.AttributeGroup;

namespace WebApplication.Admin.Product
{
    public partial class ViewVersion : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string versionId = Request.QueryString["id"];
            ProductBs productBs = new ProductBs();

            VersionHistory vh = productBs.GetVersion(Int32.Parse(versionId));
            hdnVersionType.Value = vh.typeId.ToString();

            DisplayVersion(vh);
        }

        private void DisplayVersion(VersionHistory vh)
        {
            switch (vh.typeId)
            {
                case (int)VersionHistoryType.Product:
                    VersionHistoryVos.ProductVersionVo pvv = GenerateProductVersionVo(vh);
                    VersionHistoryVos.ProductVersionVo pvv2 = GeneratePreviousProductVersionVo(vh);

                    //var changes = CompareProductVersionVos(pvv, pvv2);
                    var changes = (pvv2 != null) ? string.Join(",",CompareProductVersionVos(pvv, pvv2).ToArray()) : "";
                    hdnProductFieldChangeList.Value = changes;
                    
                    List<VersionHistoryVos.ProductVersionVo> pvvl = new List<VersionHistoryVos.ProductVersionVo>();
                    pvvl.Add(pvv);
                    lvProductVersionView.DataSource = pvvl;
                    lvProductVersionView.DataBind();
                    break;
                case (int)VersionHistoryType.Media:
                    VersionHistoryVos.MediaVersionVo mvv = GenerateMediaVersionVo(vh);
                    List<VersionHistoryVos.MediaVersionVo> mvvl = new List<VersionHistoryVos.MediaVersionVo>();
                    mvvl.Add(mvv);
                    lvMediaVersionView.DataSource = mvvl;
                    lvMediaVersionView.DataBind();
                    break;
                case (int)VersionHistoryType.Url:
                    VersionHistoryVos.UrlVersionVo uvv = GenerateUrlVersionVo(vh);
                    List<VersionHistoryVos.UrlVersionVo> uvvl = new List<VersionHistoryVos.UrlVersionVo>();
                    uvvl.Add(uvv);
                    lvUrlVersionView.DataSource = uvvl;
                    lvUrlVersionView.DataBind();
                    break;
                case (int)VersionHistoryType.GuideDescription:
                    VersionHistoryVos.GuideDescriptionVersionVo gdvv = GenerateGuideDescriptionVersionVo(vh);
                    List<VersionHistoryVos.GuideDescriptionVersionVo> gdvvl = new List<VersionHistoryVos.GuideDescriptionVersionVo>();
                    gdvvl.Add(gdvv);
                    lvGuideDescriptionVersionView.DataSource = gdvvl;
                    lvGuideDescriptionVersionView.DataBind();
                    break;
                default:
                    break;
            }
            
        }


        private string GeneratePaymentTypeList(IEnumerable<XElement> query)
        {
            StringBuilder sb = new StringBuilder();

            foreach (var element in query)
            {
                int paymentTypeId = Int32.Parse(element.Attribute("paymentTypeId").Value);
                sb.AppendFormat("{0}, ", ResourceUtils.GetPaymentTypeLabel((PaymentType) paymentTypeId));
            }

            if (sb.Length > 0)
            {
                sb.Length = sb.Length - 2;
            }
            else
            {
                sb.Append("None");
            }

            return sb.ToString();
        }

        private string GenerateRegionOfOperationList(IEnumerable<XElement> query)
        {
            StringBuilder sb = new StringBuilder();

            foreach (var element in query)
            {
                int id = Int32.Parse(element.Attribute("regionId").Value);
                sb.AppendFormat("{0}, ", ResourceUtils.GetRegionLabel((Region) id));
            }

            if (sb.Length > 0)
            {
                sb.Length = sb.Length - 2;
            }
            else
            {
                sb.Append("None");
            }

            return sb.ToString();
        }

        private string GenerateCanadaSelectRatingList(IEnumerable<XElement> query)
        {
            StringBuilder sb = new StringBuilder();

            foreach (var element in query)
            {
                int id = Int32.Parse(element.Attribute("canadaSelectRatingTypeId").Value);
                string rating = element.Attribute("ratingValue").Value;
                sb.AppendFormat("{0}: {1}, ", ResourceUtils.GetCanadaSelectRatingTypeLabel((CanadaSelectRatingType) id),
                                rating);
            }

            if (sb.Length > 0)
            {
                sb.Length = sb.Length - 2;
            }
            else
            {
                sb.Append("None");
            }

            return sb.ToString();
        }

        

        private string GenerateAttributeList(AttributeGroup ag, IEnumerable<XElement> allAttributesQuery)
        {
            StringBuilder sb = new StringBuilder();

            var attributeList = from attribute in allAttributesQuery
                                      where (string) attribute.Attribute("attributeGroupId") == ((int)ag).ToString()
                                       select attribute;

            foreach (var attribute in attributeList)
            {
                int attributeId = Int32.Parse(attribute.Attribute("attributeId").Value);
                //sb.AppendFormat("{0}, ", EnumerationUtils.GetAttributeLabel(ag, attributeId));
                sb.AppendFormat("{0}, ", ResourceUtils.GetAttributeLabel(attributeId));
            }

            if (sb.Length > 0)
            {
                sb.Length = sb.Length - 2;
            }
            else
            {
                sb.Append("None");    
            }
            
            return sb.ToString();
        }


        private VersionHistoryVos.UrlVersionVo GenerateUrlVersionVo(VersionHistory vh)
        {
            ProductBs productBs = new ProductBs();

            XElement xml = XElement.Parse(vh.versionXml);

            VersionHistoryVos.UrlVersionVo uvv = (from m in xml.Descendants("link")
                                                    select new VersionHistoryVos.UrlVersionVo
                                                    {
                                                        url = (string)m.Element("url"),
                                                        urlTypeId = (string)m.Element("urlTypeId"),
                                                        distance = (string)m.Element("distance"),
                                                    }).First();

            var transQuery =
                from trans in
                    xml.Descendants("link").First().Element("urlTranslations").Descendants("urlTranslation")
                select trans;

            var enTrans = (from trans in transQuery
                           where trans.Attribute("languageId").Value == "en"
                           select trans).First();

            var frTrans = (from trans in transQuery
                           where trans.Attribute("languageId").Value == "fr"
                           select trans).First();

            uvv.titleEn = enTrans.Element("title").Value;
            uvv.descriptionEn = enTrans.Element("description").Value;

            uvv.titleFr = frTrans.Element("title").Value;
            uvv.descriptionFr = frTrans.Element("description").Value;

            uvv.distance = (uvv.distance == "") ? "N/A" : uvv.distance;

            uvv.urlTypeId = ResourceUtils.GetUrlTypeLabel((UrlType)Int32.Parse(uvv.urlTypeId));
            uvv.versionId = vh.id.ToString();
            uvv.modifiedBy = vh.modifiedBy.ToString();
            uvv.modificationDate = vh.modificationDate;

            return uvv;
        }

        private VersionHistoryVos.MediaVersionVo GenerateMediaVersionVo(VersionHistory vh)
        {
            ProductBs productBs = new ProductBs();

            XElement xml = XElement.Parse(vh.versionXml);

            VersionHistoryVos.MediaVersionVo mvv = (from m in xml.Descendants("media")
                    select new VersionHistoryVos.MediaVersionVo
                    {
                        originalFileName = (string) m.Element("originalFileName"),
                        mediaTypeId = (string) m.Attribute("typeId"),
                        mediaLanguageId = (string) m.Element("mediaLanguageId"),
                        fileExtension = (string) m.Element("fileExtension"),
                        sortOrder = (string) m.Element("sortOrder"),
                    }).First();

            var transQuery =
                from trans in
                    xml.Descendants("media").First().Element("mediaTranslations").Descendants("mediaTranslation")
                select trans;

            var enTrans = from trans in transQuery
                          where trans.Attribute("languageId").Value == "en"
                          select trans;

            var frTrans = from trans in transQuery
                          where trans.Attribute("languageId").Value == "fr"
                          select trans;

            if (enTrans.Count() > 0)
            {
                mvv.titleEn = enTrans.First().Element("title").Value;
                mvv.captionEn = enTrans.First().Element("caption").Value;
            }

            if (frTrans.Count() > 0)
            {
                mvv.titleFr = frTrans.First().Element("title").Value;
                mvv.captionFr = frTrans.First().Element("caption").Value;
            }

            MediaType mt = (MediaType) Int32.Parse(mvv.mediaTypeId);
            switch(mt)
            {
                case (MediaType.Advertisement):
                    mvv.mediaLanguageId = ResourceUtils.GetMediaLanguageLabel((MediaLanguage)Int32.Parse(mvv.mediaLanguageId));
                    mvv.sortOrder = "N/A";
                    break;
                case (MediaType.Brochure):
                    mvv.mediaLanguageId = ResourceUtils.GetMediaLanguageLabel((MediaLanguage)Int32.Parse(mvv.mediaLanguageId));
                    mvv.sortOrder = "N/A";
                    break;
                case (MediaType.PhotoViewer):
                    mvv.mediaLanguageId = "N/A";
                    break;
                case (MediaType.SummaryThumbnail):
                    mvv.mediaLanguageId = "N/A";
                    mvv.sortOrder = "N/A";
                    break;

            }

            mvv.mediaTypeId = ResourceUtils.GetMediaTypeLabel(mt);
            mvv.modificationDate = vh.modificationDate;
            mvv.modifiedBy = vh.modifiedBy.ToString();
            mvv.versionId = vh.id.ToString();

            return mvv;
        }

        private VersionHistoryVos.ProductVersionVo GeneratePreviousProductVersionVo(VersionHistory vh)
        {
            ProductBs productBs = new ProductBs();
            var prev = productBs.GetPreviousVersion(vh.id, vh.productId, vh.modificationDate);
            return (prev != null) ? GenerateProductVersionVo(prev) : null;
        }

        private List<string> CompareProductVersionVos (VersionHistoryVos.ProductVersionVo pvv1, VersionHistoryVos.ProductVersionVo pvv2)
        {
            PropertyInfo[] properties = pvv1.GetType().GetProperties();
            PropertyInfo[] printVersionProps = pvv1.printVersion.GetType().GetProperties();

            List<string> sl = new List<string>();
            List<string> fl = new List<string>();

            foreach (var propertyInfo in properties)
            {
                //fl.Add(propertyInfo.Name);
                var a = propertyInfo.GetValue(pvv1, null);
                var b = propertyInfo.GetValue(pvv2, null);
                
                //if (propertyInfo.GetValue(pvv1, null) != propertyInfo.GetValue(pvv2, null))
                if (a != null && b != null && a.ToString() != b.ToString()) 
                {
                    fl.Add(propertyInfo.Name);
                }
            }

            foreach (var propertyInfo in printVersionProps)
            {
                //fl.Add(String.Format("pv_{0}", propertyInfo.Name));
                var a = propertyInfo.GetValue(pvv1.printVersion, null);
                var b = propertyInfo.GetValue(pvv2.printVersion, null);

                //if (propertyInfo.GetValue(pvv1, null) != propertyInfo.GetValue(pvv2, null))
                if (a != null && b != null && a.ToString() != b.ToString())
                {
                    fl.Add(String.Format("pv_{0}", propertyInfo.Name));
                }
            }

            //var x = "justin";
            return fl;

        }

        private VersionHistoryVos.ProductVersionVo GenerateProductVersionVo(VersionHistory vh)
        {
            ProductBs productBs = new ProductBs();

            //ProductVersionVo pvv = new ProductVersionVo();
            //pvv.modificationDate = ph.modificationDate;
            //pvv.modifiedBy = "gkirkwood";
            //pvv.versionId = ph.id.ToString();

            XElement xml = XElement.Parse(vh.versionXml);

            VersionHistoryVos.ProductVersionVo pvv = (from p in xml.Descendants("product")
                    select new VersionHistoryVos.ProductVersionVo
                                {
                                    accessCanadaRating = (string)p.Element("accessCanadaRating"),
                                    cancellationPolicyId = (string)p.Element("cancellationPolicyId"),
                                    capacityTypeId = (string)p.Element("capacityTypeId"),
                                    cashOnly = (string)p.Element("cashOnly"),
                                    checkboxLabel = (string)p.Element("checkboxLabel"),
                                    checkInId = (string)p.Element("checkInId"),
                                    closeDay = (string)p.Element("closeDay"),
                                    closeMonth = (string)p.Element("closeMonth"),
                                    communityId = (string)p.Element("communityId"),
                                    confirmationDueDate = (string)p.Element("confirmationDueDate"),
                                    email = (string)p.Element("email"),
                                    fax = (string)p.Element("fax"),
                                    hasOffSeasonRates = (string)p.Element("hasOffSeasonRates"),
                                    highRate = (string)p.Element("highRate"),
                                    isActive = (string)p.Element("isActive"),
                                    isCheckInMember = (string)p.Element("isCheckInMember"),
                                    isComplete = (string)p.Element("isComplete"),
                                    isDeleted = (string)p.Element("isDeleted"),
                                    isTicketed = (string)p.Element("isTicketed"),
                                    isValid = (string)p.Element("isValid"),
                                    latitude = (string)p.Element("latitude"),
                                    licenseNumber = (string)p.Element("licenseNumber"),
                                    line1 = (string)p.Element("line1"),
                                    line2 = (string)p.Element("line2"),
                                    line3 = (string)p.Element("line3"),
                                    longitude = (string)p.Element("longitude"),
                                    lowRate = (string)p.Element("lowRate"),
                                    noTax = (string)p.Element("noIncludesTax"),
                                    offSeasonPhone = (string)p.Element("offSeasonPhone"),
                                    openDay = (string)p.Element("openDay"),
                                    openMonth = (string)p.Element("openMonth"),
                                    otherMemberships = (string)p.Element("otherMemberships"),
                                    overrideErrors = (string)p.Element("overrideErrors"),
                                    ownershipTypeId = (string)p.Element("ownershipTypeId"),
                                    parkingSpaces = (string)p.Element("parkingSpaces"),
                                    paymentAmount = (string)p.Element("paymentAmount"),
                                    paymentReceived = (string)p.Element("paymentReceived"),
                                    periodOfOperationTypeId  = (string)p.Element("periodOfOperationTypeId"),
                                    postalCode = (string)p.Element("postalCode"),
                                    primaryGuideSectionId = (string)p.Element("primaryGuideSectionId"),
                                    productName = (string)p.Element("productName"),
                                    productTypeId = (string)p.Element("productTypeId"),
                                    proprietor = (string)p.Element("proprietor"),
                                    ratePeriodId = (string)p.Element("ratePeriodId"),
                                    rateTypeId = (string)p.Element("rateTypeId"),
                                    reservationsOnly = (string)p.Element("reservationsOnly"),
                                    secondaryPhone = (string)p.Element("secondaryPhone"),
                                    seatingCapacity = (string)p.Element("seatingCapacity"),
                                    subRegionId = (string)p.Element("subRegionId"),
                                    sustainabilityTypeId = (string)p.Element("sustainabilityTypeId"),
                                    telephone = (string)p.Element("telephone"),
                                    tollfree = (string)p.Element("tollfree"),
                                    web = (string)p.Element("web")
                                }).First();

            pvv.modificationDate = vh.modificationDate;
            pvv.modifiedBy = vh.modifiedBy;
            pvv.versionId = vh.id.ToString();

            if (!String.IsNullOrEmpty(pvv.openMonth))
            {
                pvv.openMonthName = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(Int32.Parse(pvv.openMonth));    
            }

            if (!String.IsNullOrEmpty(pvv.closeMonth))
            {
                pvv.closeMonthName = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(Int32.Parse(pvv.closeMonth));
            }

            pvv.productTypeName = ResourceUtils.GetProductTypeLabel((ProductType)Int32.Parse(pvv.productTypeId));
            
            if (!String.IsNullOrEmpty(pvv.communityId))
            {
                pvv.communityName = productBs.GetCommunity(short.Parse(pvv.communityId)).communityName;    
            }

            if (!String.IsNullOrEmpty(pvv.subRegionId))
            {
                pvv.subRegionName = productBs.GetSubRegion(short.Parse(pvv.subRegionId)).subRegionName;    
            }
            
            if (!String.IsNullOrEmpty(pvv.ratePeriodId))
            {
                pvv.ratePeriodName = ResourceUtils.GetRatePeriodLabel((RatePeriod)Int32.Parse(pvv.ratePeriodId));    
            }

            if (!String.IsNullOrEmpty(pvv.rateTypeId))
            {
                pvv.rateTypeName = ResourceUtils.GetRateTypeLabel((RateType)Int32.Parse(pvv.rateTypeId));
            }

            if (!String.IsNullOrEmpty(pvv.cancellationPolicyId))
            {
                pvv.cancellationPolicyName = ResourceUtils.GetCancellationPolicyLabel((CancellationPolicy)Int32.Parse(pvv.cancellationPolicyId));
            }

            if (!String.IsNullOrEmpty(pvv.capacityTypeId))
            {
                pvv.capacityTypeName = ResourceUtils.GetCapacityTypeLabel((CapacityType)Int32.Parse(pvv.capacityTypeId));
            }

            if (!String.IsNullOrEmpty(pvv.ownershipTypeId))
            {
                pvv.ownershipTypeName = ResourceUtils.GetOwnershipTypeLabel((OwnershipType)Int32.Parse(pvv.ownershipTypeId));
            }

            if (!String.IsNullOrEmpty(pvv.periodOfOperationTypeId))
            {
                pvv.periodOfOperationTypeName = ResourceUtils.GetPeriodOfOperationTypeLabel((PeriodOfOperationType)Int32.Parse(pvv.periodOfOperationTypeId));
            }

            if (!String.IsNullOrEmpty(pvv.sustainabilityTypeId))
            {
                pvv.sustainabilityTypeName = ResourceUtils.GetSustainabilityTypeLabel((SustainabilityType)Int32.Parse(pvv.sustainabilityTypeId));
            }

            List<VersionHistoryVos.ContactVo> cl = new List<VersionHistoryVos.ContactVo>();
            IEnumerable<XElement> contactQuery =
                from contacts in
                    xml.Descendants("product").First().Element("contacts").Descendants("contact")
                select contacts;
            
            foreach (var j in contactQuery)
            {
                VersionHistoryVos.ContactVo cv = new VersionHistoryVos.ContactVo();

                cv.contactId = j.Attribute("contactId").Value;
                cv.contactTypeId = j.Attribute("contactTypeId").Value;
                cv.contactTypeName = ResourceUtils.GetContactTypeLabel((ContactType) Int32.Parse(cv.contactTypeId));
                cv.firstName = j.Element("firstName").Value;
                cv.lastName = j.Element("lastName").Value;

                cl.Add(cv);
            }
            
            pvv.contacts = cl;

            IEnumerable<XElement> paymentTypeQuery =
                from paymentTypes in
                    xml.Descendants("product").First().Element("productPaymentTypes").Descendants("productPaymentType")
                select paymentTypes;

            pvv.paymentTypeList = GeneratePaymentTypeList(paymentTypeQuery);

            IEnumerable<XElement> regionOfOperationQuery =
                from regionOfOperations in
                    xml.Descendants("product").First().Element("productRegionOfOperations").Descendants("productRegionOfOperation")
                select regionOfOperations;

            pvv.regionOfOperationList = GenerateRegionOfOperationList(regionOfOperationQuery);

            IEnumerable<XElement> canadaSelectRatingQuery =
                from canadaSelectRatings in
                    xml.Descendants("product").First().Element("productCanadaSelectRatings").Descendants("productCanadaSelectRating")
                select canadaSelectRatings;

            pvv.canadaSelectRatingList = GenerateCanadaSelectRatingList(canadaSelectRatingQuery);

            IEnumerable<XElement> allAttributesQuery =
                from attributes in
                    xml.Descendants("product").First().Element("productAttributes").Descendants("productAttribute")
                select attributes;

            pvv.accessAdvisorList = GenerateAttributeList(AttributeGroup.AccessAdvisor, allAttributesQuery);
            pvv.exhibitTypeList = GenerateAttributeList(AttributeGroup.ExhibitType, allAttributesQuery);
            pvv.trailTypeList = GenerateAttributeList(AttributeGroup.TrailType, allAttributesQuery);
            pvv.transportationTypeList = GenerateAttributeList(AttributeGroup.TransportationType, allAttributesQuery);

            pvv.accommodationAmenityList = GenerateAttributeList(AttributeGroup.AccommodationAmenity, allAttributesQuery);
            pvv.accommodationServiceList = GenerateAttributeList(AttributeGroup.AccommodationService, allAttributesQuery);
            pvv.accommodationTypeList = GenerateAttributeList(AttributeGroup.AccommodationType, allAttributesQuery);
            pvv.activityList = GenerateAttributeList(AttributeGroup.Activity, allAttributesQuery);
            pvv.approvedByList = GenerateAttributeList(AttributeGroup.ApprovedBy, allAttributesQuery);
            pvv.areaOfInterestList = GenerateAttributeList(AttributeGroup.AreaOfInterest, allAttributesQuery);
            pvv.artTypeList = GenerateAttributeList(AttributeGroup.ArtType, allAttributesQuery);
            pvv.campgroundAmenityList = GenerateAttributeList(AttributeGroup.CampgroundAmenity, allAttributesQuery);
            pvv.coreExperienceList = GenerateAttributeList(AttributeGroup.CoreExperience, allAttributesQuery);
            pvv.culturalHeritageList = GenerateAttributeList(AttributeGroup.CulturalHeritage, allAttributesQuery);
            pvv.featureList = GenerateAttributeList(AttributeGroup.Feature, allAttributesQuery);
            pvv.governmentLevelList = GenerateAttributeList(AttributeGroup.GovernmentLevel, allAttributesQuery);
            pvv.mediumList = GenerateAttributeList(AttributeGroup.Medium, allAttributesQuery);
            pvv.membershipList = GenerateAttributeList(AttributeGroup.Membership, allAttributesQuery);
            pvv.petsPolicyList = GenerateAttributeList(AttributeGroup.PetsPolicy, allAttributesQuery);
            pvv.printOptionList = GenerateAttributeList(AttributeGroup.PrintOption, allAttributesQuery);
            pvv.productCategoryList = GenerateAttributeList(AttributeGroup.ProductCategory, allAttributesQuery);
            pvv.restaurantServiceList = GenerateAttributeList(AttributeGroup.RestaurantService, allAttributesQuery);
            pvv.shareInformationWithList = GenerateAttributeList(AttributeGroup.ShareInformationWith, allAttributesQuery);
            pvv.editorCheckList = GenerateAttributeList(AttributeGroup.EditorChecks, allAttributesQuery);
            pvv.cuisineList = GenerateAttributeList(AttributeGroup.Cuisine, allAttributesQuery);
            pvv.tourTypeList = GenerateAttributeList(AttributeGroup.TourType, allAttributesQuery);
            pvv.restaurantTypeList = GenerateAttributeList(AttributeGroup.RestaurantType, allAttributesQuery);
            pvv.restaurantSpecialtyList = GenerateAttributeList(AttributeGroup.RestaurantSpecialty, allAttributesQuery);
           // pvv.smokingPolicyList = GenerateAttributeList(AttributeGroup.SmokingPolicy, allAttributesQuery);

            var transQuery =
                from trans in
                    xml.Descendants("product").First().Element("productTranslations").Descendants("productTranslation")
                select trans;


            var enTrans = from trans in transQuery
                          where trans.Attribute("languageId").Value == "en"
                          select trans;

            if (enTrans.Count() > 0)
            {
                pvv.webDescriptionEn = enTrans.First().Element("webDescription").Value;
                pvv.rateDescriptionEn = enTrans.First().Element("rateDescription").Value;
                pvv.dateDescriptionEn = enTrans.First().Element("dateDescription").Value;
                pvv.keywordsEn = enTrans.First().Element("keywords").Value;
                pvv.directionsEn = enTrans.First().Element("directions").Value;
                pvv.cancellationPolicyEn = enTrans.First().Element("cancellationPolicy").Value;
            }

            var frTrans = from trans in transQuery
                           where trans.Attribute("languageId").Value == "fr"
                           select trans;

            if (frTrans.Count() > 0)
            {
                pvv.webDescriptionFr = frTrans.First().Element("webDescription").Value;
                pvv.rateDescriptionFr = frTrans.First().Element("rateDescription").Value;
                pvv.dateDescriptionFr = frTrans.First().Element("dateDescription").Value;
                pvv.keywordsFr = frTrans.First().Element("keywords").Value;
                pvv.directionsFr = frTrans.First().Element("directions").Value;
                pvv.cancellationPolicyFr = frTrans.First().Element("cancellationPolicy").Value;
            }


            var printQuery = from pq in xml.Descendants("product").First().Descendants("printVersion")
                             select pq;

            
            VersionHistoryVos.PrintVersionVo printVersionVo = (from p in printQuery
                    select new VersionHistoryVos.PrintVersionVo
                                {
                                    cancellationPolicyId = (string)p.Element("cancellationPolicyId"),
                                    closeDay = (string)p.Element("closeDay"),
                                    closeMonth = (string)p.Element("closeMonth"),
                                    hasOffSeasonRates = (string)p.Element("hasOffSeasonRates"),
                                    highRate = (string)p.Element("highRate"),
                                    lowRate = (string)p.Element("lowRate"),
                                    noTax = (string)p.Element("noTax"),
                                    openDay = (string)p.Element("openDay"),
                                    openMonth = (string)p.Element("openMonth"),
                                    periodOfOperationTypeId = (string)p.Element("periodOfOperationTypeId"),
                                    ratePeriodId = (string)p.Element("ratePeriodId"),
                                    rateTypeId = (string)p.Element("rateTypeId")
                                }).First();

            if (printVersionVo.openMonth != "")
            {
                printVersionVo.openMonthName = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(Int32.Parse(printVersionVo.openMonth));
            }

            if (printVersionVo.closeMonth != "")
            {
                printVersionVo.closeMonthName = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(Int32.Parse(printVersionVo.closeMonth));
            }

            var transQueryPrint =
                from trans in
                    xml.Descendants("product").First().Element("printVersion").Element("printVersionTranslations").Descendants("printVersionTranslation")
                select trans;

            var enTransPrint = from trans in transQueryPrint
                                    where trans.Attribute("languageId").Value == "en"
                                    select trans;

            var frTransPrint = from trans in transQueryPrint
                                    where trans.Attribute("languageId").Value == "fr"
                                    select trans;

            if (enTransPrint.Count() > 0)
            {
                printVersionVo.dateDescriptionEn = (string)enTransPrint.First().Element("dateDescription");
                printVersionVo.directionsEn = (string)enTransPrint.First().Element("directions");
                printVersionVo.printDescriptionEn = (string)enTransPrint.First().Element("printDescription");
                printVersionVo.rateDescriptionEn = (string)enTransPrint.First().Element("rateDescription");
                printVersionVo.unitDescriptionEn = (string)enTransPrint.First().Element("unitDescription");
            }
            
            if (frTransPrint.Count() > 0)
            {
                printVersionVo.dateDescriptionFr = (string) frTransPrint.First().Element("dateDescription");
                printVersionVo.directionsFr = (string) frTransPrint.First().Element("directions");
                printVersionVo.printDescriptionFr = (string) frTransPrint.First().Element("printDescription");
                printVersionVo.rateDescriptionFr = (string) frTransPrint.First().Element("rateDescription");
                printVersionVo.unitDescriptionFr = (string) frTransPrint.First().Element("unitDescription");
            }
            
            pvv.printVersion = printVersionVo;

            return pvv;
        }


//        <descriptionTranslations productId="9181" descriptionTypeId="52">
//<descriptionTranslation languageId="en">boat tours edited with logging? gain?</descriptionTranslation>
//<descriptionTranslation languageId="fr">boat tours? will it?</descriptionTranslation>  
//</descriptionTranslations>
        private VersionHistoryVos.GuideDescriptionVersionVo GenerateGuideDescriptionVersionVo(VersionHistory vh)
        {
            ProductBs productBs = new ProductBs();

            XElement xml = XElement.Parse(vh.versionXml);

            VersionHistoryVos.GuideDescriptionVersionVo gdvv = new VersionHistoryVos.GuideDescriptionVersionVo();

            short descriptionTypeId = short.Parse(xml.Attribute("descriptionTypeId").Value);

            var transQuery =
                from trans in
                    xml.Descendants("descriptionTranslation")
                select trans;

            var enTrans = from trans in transQuery
                          where trans.Attribute("languageId").Value == "en"
                          select trans;

            var frTrans = from trans in transQuery
                          where trans.Attribute("languageId").Value == "fr"
                          select trans;

            if (enTrans.Count() > 0)
            {
                gdvv.descriptionEn = enTrans.First().Value;
            }

            if (frTrans.Count() > 0)
            {
                gdvv.descriptionFr = frTrans.First().Value;
            }

            //gdvv.mediaTypeId = ResourceUtils.GetDescriptionTypeLabel(mt);

            gdvv.descriptionTypeId = (descriptionTypeId <= 50) ? ResourceUtils.GetGuideSectionOutdoorsLabel((GuideSectionOutdoors)descriptionTypeId) : ResourceUtils.GetGuideSectionTourOpsLabel((GuideSectionTourOps)descriptionTypeId);
            gdvv.modificationDate = vh.modificationDate;
            gdvv.modifiedBy = vh.modifiedBy.ToString();
            gdvv.versionId = vh.id.ToString();

            return gdvv;
        }
        

    }
}