using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ProductCatalogue.BusinessServices;

namespace WebApplication.ValueObjects
{
    public class ListItemVos
    {
        public class MediaListItem
        {
            public int mediaId { get; set; }
            public string mediaOriginalFileName { get; set; }
            public string mediaPath { get; set; }
            public string mediaType { get; set; }
        }

        public class NearbyLocationListItem
        {
            public int locationId { get; set; }
            public string locationName { get; set; }
            public string locationUrl { get; set; }
            public string locationDistance { get; set; }
        }

        public class LinkListItem
        {
            public int linkId { get; set; }
            public string linkName { get; set; }
            public string linkType { get; set; }
            public string linkUrl { get; set; }
            
        }

        public class SupplementalDescriptionListItem
        {
            public string descriptionTypeId { get; set; }
            public string descriptionTypeName { get; set; }
            public string descriptionEn { get; set; }
            public string descriptionFr { get; set; }

        }

        public class PrimaryContactListItem
        {
            public string contactId { get; set; }
            public string contactFullName { get; set; }
        }

        public class AddressListItem
        {
            public string addressId { get; set;}
            public string line1 { get; set; }
            public string addressType { get; set; }
            public string city { get; set;}
            public string provinceRegion { get; set;}
            public string postalCode { get; set;}
            public string country { get; set;}
        }

        public class BusinessContactListItem
        {
            public string contactId { get; set; }
            public string contactType { get; set; }
            public string isPrimary { get; set; }
            public string firstName { get; set; }
            public string lastName { get; set; }
            public string jobTitle { get; set; }
            public string email { get; set; }
            public bool enableDelete { get; set; }
        }

        public class PhoneListItem
        {
            public string phoneId { get; set; }
            public string phoneType { get; set; }
            public string phoneNumber { get; set; }
        }

        public class ProductListItem
        {
            public string productId { get; set; }
            public string productName { get; set; }
            public string productType { get; set; }
            public string productCommunity { get; set; }
            public string productRegion { get; set; }
            public string productContactName { get; set; }
        }

        public class BusinessSearchListItem
        {
            public string businessId { get; set; }
            public string businessName { get; set; }
            public string primaryContactName { get; set; }
            public string primaryContactPhone { get; set; }
            public string primaryContactEmail { get; set; }
        }

        public class ContactSearchListItem
        {
            public string contactId { get; set; }
            public string contactType { get; set; }
            public string contactName { get; set; }
            public string jobTitle { get; set; }
            public string email { get; set; }
            public string telephone { get; set; }
            public List<ProductListItem> productList { get; set; }
        }

        public class ProductSearchListItem
        {
            public string productId { get; set; }
            public string productName { get; set; }
            public string productType { get; set; }
            public string communityName { get; set; }
            public string regionName { get; set; }
            public string contactId { get; set; }
            public string primaryContactName { get; set; }
            public string businessId { get; set; }
            public string businessName { get; set; }
            public string isDisplayed { get; set; }
        }

        public class ProductContactListItem
        {
            public string contactId { get; set; }
            public string contactName { get; set; }
            public string businessContactType { get; set; }
            public string contactTypeId { get; set; }
            public string jobTitle { get; set; }
            public string email { get; set; }
            public string businessId { get; set; }
            public string businessName { get; set; }
        }

        public class VersionHistoryListItem
        {
            public DateTime modificationDate { get; set; }
            public string modifiedBy { get; set; }
            public string typeId { get; set; }
            public string actionId { get; set; }
            public string versionId { get; set; }
        }

        public class TranslationListItem
        {
            public int productId { get; set; }
            public string productName { get; set; }
            public int fieldId { get; set; }
            public string fieldName { get; set; }
            public DateTime statusDate { get; set; }
        }
    }
}