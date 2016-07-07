using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApplication.ValueObjects
{

    public class VersionHistoryVos
    {

        public class GuideDescriptionVersionVo
        {
            public DateTime modificationDate { get; set; }
            public string versionId { get; set; }
            public string modifiedBy { get; set; }
            public string descriptionTypeId { get; set; }
            
            public string descriptionEn { get; set; }

            public string descriptionFr { get; set; }
            
        }

        public class MediaVersionVo
        {
            public DateTime modificationDate { get; set; }
            public string versionId { get; set; }
            public string modifiedBy { get; set; }
            public string originalFileName { get; set; }
            public string mediaTypeId { get; set; }
            public string mediaLanguageId { get; set; }
            public string fileExtension { get; set; }
            public string sortOrder { get; set; }

            public string titleEn { get; set; }
            public string captionEn { get; set; }

            public string titleFr { get; set; }
            public string captionFr { get; set; }
        }

        public class UrlVersionVo
        {
            public DateTime modificationDate { get; set; }
            public string versionId { get; set; }
            public string modifiedBy { get; set; }
            public string url { get; set; }
            public string urlTypeId { get; set; }
            public string productId { get; set; }
            public string distance { get; set; }
            
            public string titleEn { get; set; }
            public string descriptionEn { get; set; }

            public string titleFr { get; set; }
            public string descriptionFr { get; set; }
        }

        public class ProductVersionVo
        {
            public DateTime modificationDate { get; set; }
            public string versionId { get; set; }
            public string modifiedBy { get; set; }
            public string productName { get; set; }
            public string productTypeId { get; set; }
            public string productTypeName { get; set; }
            
            public string line1 { get; set; }
            public string line2 { get; set; }
            public string line3 { get; set; }
            public string postalCode { get; set; }
            public string communityId { get; set; }
            public string communityName { get; set; }
            public string subRegionId { get; set; }
            public string subRegionName { get; set; }
            public string latitude { get; set; }
            public string longitude { get; set; }
            public string proprietor { get; set; }
            public string email { get; set; }
            public string web { get; set; }
            public string telephone { get; set; }
            public string secondaryPhone { get; set; }
            public string offSeasonPhone { get; set; }
            public string fax { get; set; }
            public string tollfree { get; set; }
            public string reservationsOnly { get; set; }
            public string isCheckInMember { get; set; }
            public string checkInId { get; set; }
            public string accessCanadaRating { get; set; }
            public string lowRate { get; set; }
            public string highRate { get; set; }
            public string periodOfOperationTypeId { get; set; }
            public string periodOfOperationTypeName { get; set; }
            public string rateTypeId { get; set; }
            public string rateTypeName { get; set; }
            public string ratePeriodId { get; set; }
            public string ratePeriodName { get; set; }
            public string primaryGuideSectionId { get; set; }
            public string primaryGuideSectionName { get; set; }
            public string openMonth { get; set; }
            public string openMonthName { get; set; }
            public string openDay { get; set; }
            public string closeMonth { get; set; }
            public string closeMonthName { get; set; }
            public string closeDay { get; set; }
            public string hasOffSeasonRates { get; set; }
            public string noTax { get; set; }
            public string cashOnly { get; set; }
            public string cancellationPolicyId { get; set; }
            public string cancellationPolicyName { get; set; }
            public string parkingSpaces { get; set; }
            public string seatingCapacity { get; set; }
            public string otherMemberships { get; set; }
            public string licenseNumber { get; set; }
            public string checkboxLabel { get; set; }
            public string paymentReceived { get; set; }
            public string paymentAmount { get; set; }
            public string confirmationDueDate { get; set; }
            public string ownershipTypeId { get; set; }
            public string ownershipTypeName { get; set; }
            public string sustainabilityTypeId { get; set; }
            public string sustainabilityTypeName { get; set; }
            public string capacityTypeId { get; set; }
            public string capacityTypeName { get; set; }
            public string isTicketed { get; set; }
            public string isValid { get; set; }
            public string isComplete { get; set; }
            public string isActive { get; set; }
            public string overrideErrors { get; set; }
            public string isDeleted { get; set; }

            public List<ContactVo> contacts { get; set; }
            
            public string rateDescriptionEn { get; set; }
            public string dateDescriptionEn { get; set; }
            public string webDescriptionEn { get; set; }
            public string keywordsEn { get; set; }
            public string directionsEn { get; set; }
            public string cancellationPolicyEn { get; set; }

            public string rateDescriptionFr { get; set; }
            public string dateDescriptionFr { get; set; }
            public string webDescriptionFr { get; set; }
            public string keywordsFr { get; set; }
            public string directionsFr { get; set; }
            public string cancellationPolicyFr { get; set; }

            public PrintVersionVo printVersion { get; set; }

            public string caaRatingList { get; set; }
            public string canadaSelectRatingList { get; set; }
            public string descriptionList { get; set; }
            public string paymentTypeList { get; set; }
            public string regionOfOperationList { get; set; }

            public string accessAdvisorList { get; set; }
            public string accommodationAmenityList { get; set; }
            public string accommodationServiceList { get; set; }
            public string accommodationTypeList { get; set; }
            public string activityList { get; set; }
            public string approvedByList { get; set; }
            public string areaOfInterestList { get; set; }
            public string artTypeList { get; set; }
            public string campgroundAmenityList { get; set; }
            public string coreExperienceList { get; set; }
            public string culturalHeritageList { get; set; }
            public string exhibitTypeList { get; set; }
            public string featureList { get; set; }
            public string governmentLevelList { get; set; }
            public string mediumList { get; set; }
            public string membershipList { get; set; }
            public string petsPolicyList { get; set; }
            public string printOptionList { get; set; }
            public string productCategoryList { get; set; }
            public string restaurantServiceList { get; set; }
            public string shareInformationWithList { get; set; }
            public string editorCheckList { get; set; }
            public string cuisineList { get; set; }
            public string tourTypeList { get; set; }
            public string trailTypeList { get; set; }
            public string transportationTypeList { get; set; }
            public string restaurantTypeList { get; set; }
            public string restaurantSpecialtyList { get; set; }
        }

        public class PrintVersionVo
        {
            public string lowRate { get; set; }
            public string highRate { get; set; }
            public string hasOffSeasonRates { get; set; }
            public string rateTypeId { get; set; }
            public string rateTypeName { get; set; }
            public string ratePeriodId { get; set; }
            public string ratePeriodName { get; set; }
            public string openMonth { get; set; }
            public string openMonthName { get; set; }
            public string openDay { get; set; }
            public string closeMonth { get; set; }
            public string closeMonthName { get; set; }
            public string closeDay { get; set; }
            public string periodOfOperationTypeId { get; set; }
            public string periodOfOperationTypeName { get; set; }
            public string noTax { get; set; }
            public string cancellationPolicyId { get; set; }
            public string cancellationPolicyName { get; set; }


            public string rateDescriptionEn { get; set; }
            public string dateDescriptionEn { get; set; }
            public string printDescriptionEn { get; set; }
            public string unitDescriptionEn { get; set; }
            public string directionsEn { get; set; }

            public string rateDescriptionFr { get; set; }
            public string dateDescriptionFr { get; set; }
            public string printDescriptionFr { get; set; }
            public string unitDescriptionFr { get; set; }
            public string directionsFr { get; set; }

        }

        public class ContactVo
        {
            public string contactTypeId { get; set; }
            public string contactTypeName { get; set; }
            public string contactId { get; set; }
            public string firstName { get; set; }
            public string lastName { get; set; }
            
        }
        
    }

}

                                
                    