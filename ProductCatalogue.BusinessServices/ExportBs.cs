using System;
using System.Collections.Generic;
using System.Globalization;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml.Linq;
using OfficeOpenXml;
using ProductCatalogue.DataAccess;
using ProductCatalogue.DataAccess.Enumerations;
using AttributeGroup = ProductCatalogue.DataAccess.Enumerations.AttributeGroup;

namespace ProductCatalogue.BusinessServices
{
    public class ExportBs
    {
        private TourismDataContext db = new TourismDataContext(ConfigurationManager.ConnectionStrings["Tourism2ConnectionString"].ConnectionString);

  //      @01 Listing Head-Camp=<Ps100p100t0Y1h95z8.25k0b0cKf"Frutiger-BlackCn"n0oL0G0>
//@02 Contact Info-Camp=<Ps100p100t0Y1h100z7.25k0b0cKf"Frutiger-BoldCn"n0oL0G0>
    
        private const string ListingHeadTab = "@01 Listing Head Tab-2008:";
        private const string ListingHeadTabV2 = "@01 Listing Head Tab-Attractions:";
        private const string ListingHeadTabV3 = "@01 Listing Head Tab-Camp:";
        private const string ListingHeadTabV4 = "@01-1 Listing Head Tab-Restaurants:";
        private const string ListingHeadTabV5 = "@01 Listing Head Tab-Trails:";
        private const string ListingHead = "@01-1 Listing Head-2008:";
        private const string ListingHeadV2 = "@01-1 Listing Head-Attractions:";
        private const string ListingHeadV3 = "@01 Listing Head-Camp:";
        private const string ListingHeadV4 = "@01-1 Listing Head-Trails:";
        private const string CoordinateHead = "<@04 Coordinate Head-2008>{0}\t";
        private const string ListingHeadName = "<@01-1 Listing Head Name-2008>{0}\t";
        private const string ListingHeadNameV2 = "<@01-1 Listing Head-Attractions>{0}";
        private const string ListingHeadNameV3 = "@01-1 Listing Head-Restaurants:";
        private const string ListingHeadBullet = "<@01-7 Listing Head Bullet>•<@$p>";
        private const string ListingHeadItalics = "<@01-2 Listing Head Italic-2008>";
        private const string ListingHeadSymbols = "<@01 Listing Head Symbols-2008>";
        private const string EscapedAtSign = "<\\@>";
        private const string SectionBreak = "<@$p>";
        private const string Bullet = " <@02-1 Contact bullet 2009>•<@$p> ";
        private const string BulletHtml = " • ";
        private const string MainListingHead = "@03 Listing-2008:";
        private const string MainListingHeadV2 = "@03 Listing-Attrac_FA:\t";
        private const string MainListingHeadV3 = "@03 Listing-Camp:\t";
        private const string MainListingHeadV4 = "@03 Listing-Restaurants:\t";
        private const string MainListingHeadV5 = "@03 Listing-Trails:\t";
        //@03 Listing-Camp=<Ps100p100t0Y1h100z8k0b0cKf"Frutiger-LightCn"n0oL0G0>
        private const string ContactHead = "@02 Contact Info-2008:";
        private const string ContactHeadV2 = "@02 Contact Info-Attrac_FA:";
        private const string ContactHeadV3 = "@02 Contact Info-Camp:";
        private const string ContactHeadV4 = "@02 Contact Info-Restaurants:";
        //@02-1 Contact Info Tab-Camp=<Ps100p100t0Y1h95z7.75k0b0cKf"Frutiger-BoldCn"n0oL0G0>
        //@03 Listing Tab-Camp=<Ps100p100t0Y1h100z8k0b0cKf"Frutiger-LightCn"n0oL0G0>
        private const string Eol = "\r\n";
        private const string ListingBold = "<@03 Listing Bold-2008>";
        private const string ListingItalic = "<@03-1 Listing Italic-2008>";
        private const string ListingStars = "<@01-4 Stars-2008>";
        private const string GpsString = " GPS N{0} {1} W{2} {3}.";
        private const string RegionDotHead = "<@07 Region dot>";
        private const string NsApprovedTag = "<@01-6 NSA-2011>";
        private const string GolfSymbolTag = "<@Golf Symbol>";
        private const string CategoryTag = "<@02-2 Contact Roman>{0}<@$p>";
        private const string FineArtsMediaTag = "<@FA Media>";
        private const string FineArtsMediaRomanTag = "<@FA Media Roman>";
        private const string GridText = "<@Grid text>{0}\t";
        private const string GridBullet = "<@Grid bullets>•";
        private const string GridHalfBullet = "<@Grid bullets><\\<>";
        private const string CrossAdRef = "<@Cross ref>";

        private const string FacebookTag = "<@Facebook>A";
        private const string TwitterTag = "<@Twitter>E";
        //<@Facebook>A<@03 Listing Bold-2008>Innon<\h>eLake <@Twitter>E<@03 Listing Bold-2008><\@>InnontheLakeNS<@$p>

        private Regex ProprietorRegex = new Regex(@"^(The )(.*)( family)$");
        private Regex CircaRegex = new Regex(@"^(.*)(c )([0-9]+)(.*)$");

        private BusinessBs businessBs = new BusinessBs();
        private ProductBs productBs = new ProductBs();

        private string ExtractFacebookProfileId (string s)
        {
            if (String.IsNullOrEmpty(s))
            {
                return String.Empty;
            }

            if (!s.StartsWith("http"))
            {
                s = String.Format("http://{0}", s);
            }

            Uri u = new Uri(s);

            var sa = u.AbsolutePath.Split('/');

            double myNum;

            foreach (var a in sa)
            {
                if (String.IsNullOrEmpty(a) || a == "pages" || a == "#!" || a == "groups" || double.TryParse(a, out myNum))
                {
                    //ignore
                }
                else
                {
                  //  this is assumed to be the profileId
                    return a;
                }
            }
            
            return String.Empty;
        }


        private string GenerateSocialMediaString(Product p)
        {
            StringBuilder sb = new StringBuilder();

            string facebookUrl = p.Urls.Where(z => z.urlTypeId == (int)UrlType.Facebook).Select(z => z.url).FirstOrDefault();
            string twitterUrl = p.Urls.Where(z => z.urlTypeId == (int)UrlType.Twitter).Select(z => z.url).FirstOrDefault();

            if(!String.IsNullOrEmpty(facebookUrl))
            {
                var facebookProfileId = ExtractFacebookProfileId(facebookUrl);
                sb.AppendFormat(FacebookTag, facebookProfileId);
            }

            if (!String.IsNullOrEmpty(twitterUrl))
            {
                var tp = twitterUrl.Split('/').Last();
               sb.AppendFormat(TwitterTag, tp);
            }

            sb.Append(SectionBreak);

            return sb.ToString();
        }


        private string ApostrophizeSingleQuotes(string s)
        {
            if (String.IsNullOrEmpty(s))
            {
                return s;
            }
            
            return s.Replace('\'', '’');
        }

        private enum ExportType
        {
            Print = 1,
            Html = 2
        }

        public XDocument GenerateFormXml (ref XDocument xdoc, Product p, string languageId)
        {
            XElement xe = GenerateFormXml(p, languageId);
           // xdoc.Element("products").Add(xe);

            if (p.productTypeId == (int)ProductType.Outdoors || p.productTypeId == (int)ProductType.TourOps)
            {
                var q = productBs.GetProductDescriptions(p.id);

                q = from item in q
                    where item.languageId == languageId
                    select item;

                foreach (ProductDescription pd in q)
                {
                    //xe.Add(GenerateCrossReferenceFormXml(xe, p, pd, languageId));
                    string gs = (pd.descriptionTypeId < 50) ? GetOutdoorsGuideSectionTitle((GuideSectionOutdoors)pd.descriptionTypeId, languageId) : GetTourOpGuideSectionTitle((GuideSectionTourOps)pd.descriptionTypeId, languageId);
                    string desc = pd.description;

                    var xref = new XElement("xref", 
                        new XElement("xrefGuideSection", gs),
                        new XElement("xrefDescription", desc)
                        );

                    xe.Element("xrefs").Add(xref);
                    
                    //xdoc.Element("xrefs").Add(GenerateCrossReferenceFormXml(xe, p, pd, languageId));
                }
            }

            xdoc.Element("products").Add(xe);

            return xdoc;
        }

        public XDocument GenerateFormXml(int? productTypeId, PublishStatus? publishStatus, int? productId)
        {
            XDocument xdoc = new XDocument();
            xdoc.Add(new XElement("products"));

            if (productId != null)
            {
                Product p = productBs.GetProduct(productId.Value);
                GenerateFormXml(ref xdoc, p, "en");
                GenerateFormXml(ref xdoc, p, "fr");
            }
            else
            {
                IQueryable<ProductCatalogue.DataAccess.Product> pq = productBs.GetProductsForFormGeneration(productTypeId.Value, publishStatus.Value);

                foreach (ProductCatalogue.DataAccess.Product p in pq)
                {
                    GenerateFormXml(ref xdoc, p, "en");
                    GenerateFormXml(ref xdoc, p, "fr");
                }
            }

            return xdoc;
        }


        public XDocument GenerateFormXml(int? productTypeId, PublishStatus? publishStatus, int? productId, string languageId, Region? r)
        {
            return GenerateFormXml(productTypeId, publishStatus,  productId, null, null, languageId, r);
        }

        public XDocument GenerateFormXml(int? productTypeId, PublishStatus? publishStatus, int? productId, string languageId)
        {
            return GenerateFormXml(productTypeId, publishStatus, productId, null, null, languageId, null);
        }

        public XDocument GenerateFormXml(int? productTypeId, PublishStatus? publishStatus, int? productId, ProofDeliveryType? proofDeliveryType, PrintGuideFormType? pgft, string languageId)
        {
            return GenerateFormXml(productTypeId, publishStatus, productId, proofDeliveryType, pgft, languageId, null);
        }

        public XDocument GenerateFormXml(int? productTypeId, PublishStatus? publishStatus, int? productId, ProofDeliveryType? proofDeliveryType, PrintGuideFormType? pgft, string languageId, Region? region)
        {
            XDocument xdoc = new XDocument();
            xdoc.Add(new XElement("products"));

            if (productId != null)
            {
                Product p = productBs.GetProduct(productId.Value);
                GenerateFormXml(ref xdoc, p, languageId);
            }
            else
            {
                //IQueryable<ProductCatalogue.DataAccess.Product> pq = productBs.GetProductsForFormGeneration(productTypeId.Value, publishStatusId.Value);
                IQueryable<Product> pq = productBs.GetProductsForFormGeneration(productTypeId.Value, publishStatus.Value, proofDeliveryType, pgft, region);

                foreach (Product p in pq)
                {
                    GenerateFormXml(ref xdoc, p, languageId);
                }
            }

            return xdoc;
        }

        public XElement GenerateFormXml(Product p, string languageId)
        {
            
            Contact c = businessBs.GetPrimaryContact(p);
            IQueryable<Phone> phoneq = businessBs.GetContactPhones(c.id);

            Phone contactOfficePhone =
                (from phone in phoneq
                 where phone.phoneTypeId == (int)PhoneType.Primary
                 select phone).FirstOrDefault();

            Phone contactFax =
                (from phone in phoneq
                 where phone.phoneTypeId == (int)PhoneType.Fax
                 select phone).FirstOrDefault();

            Phone contactOffSeason =
                (from phone in phoneq
                 where phone.phoneTypeId == (int)PhoneType.OffSeason 
                 select phone).FirstOrDefault();

            Phone contactMobile =
                (from phone in phoneq
                 where phone.phoneTypeId == (int)PhoneType.Mobile
                 select phone).FirstOrDefault();

            Phone contactHomePhone =
                (from phone in phoneq
                 where phone.phoneTypeId == (int)PhoneType.Home
                 select phone).FirstOrDefault();

            IQueryable<ProductAttribute> paq = productBs.GetProductAttributes(p.id);
            //IQueryable<PrintVersionTranslation> pvtq = productBs.GetPrintVersionTranslations(p.id);
            ProductTranslation pt = productBs.GetProductTranslation(p.id, languageId);
            var pvt = productBs.GetPrintVersionTranslation(p.id, languageId);
            
            string listingBody = GenerateListingBody(p, paq, languageId, ExportType.Html);
            string contactString = GenerateContactString(p, ExportType.Html, languageId);
            string paymentOptionsString = GeneratePaymentTypeString(p.ProductPaymentTypes.AsQueryable(), languageId);

            string rateString = GenerateRateString(p, languageId, pvt.rateDescription).TrimEnd('.');

            rateString = (rateString.Length > 6) ? rateString.Substring(7) : "";

            string restaurantSpecialty = "";
            string restaurantCategory = "";
            string fineArtsCategory = "";
            string fineArtsMedia = "";

            string facebookUrl = p.Urls.Where(z => z.urlTypeId == (int)UrlType.Facebook).Select(z => z.url).FirstOrDefault();
            string twitterUrl = p.Urls.Where(z => z.urlTypeId == (int)UrlType.Twitter).Select(z => z.url).FirstOrDefault();

            facebookUrl = String.IsNullOrEmpty(facebookUrl) ? "" : Regex.Replace(facebookUrl,"^https?://", "");
            twitterUrl = String.IsNullOrEmpty(twitterUrl) ? "" : Regex.Replace(twitterUrl, "^https?://", "");

            if (p.productTypeId == (byte)ProductType.Restaurants)
            {
                restaurantSpecialty = GenerateRestaurantSpecialtyString(paq, languageId,ExportType.Html);
                restaurantCategory = GenerateRestaurantTypeString(paq, languageId, ExportType.Html);

                if (restaurantSpecialty.IndexOf(":") > 0)
                {
                    restaurantSpecialty = restaurantSpecialty.Substring(restaurantSpecialty.IndexOf(":") + 2);
                }

                if (restaurantCategory.IndexOf(":") > 0)
                {
                    restaurantCategory = restaurantCategory.Substring(restaurantCategory.IndexOf(":") + 2);
                }
            }

            if (p.productTypeId == (byte) ProductType.FineArts)
            {
                fineArtsMedia = GenerateFineArtsMediaString(paq, languageId, ExportType.Html);
                fineArtsCategory = GenerateFineArtsCategoryString(paq, languageId, ExportType.Html);

                if (fineArtsMedia.IndexOf(":") > 0)
                {
                    fineArtsMedia = fineArtsMedia.Substring(fineArtsMedia.IndexOf(":") + 2);
                }

                if (fineArtsCategory.IndexOf(":") > 0)
                {
                    fineArtsCategory = fineArtsCategory.Substring(fineArtsCategory.IndexOf(":") + 2);
                }
                
            }

            var exhibitType = (from a in paq where a.attributeGroupId == (int)AttributeGroup.ExhibitType && a.attributeId == (int)ExhibitType.ArtisanStudios select a).FirstOrDefault();

            XElement elem = new XElement("product",
                             new XAttribute("id", p.id),
                             new XElement("productId", p.id),
                             new XElement("productTypeId", p.productTypeId),
                             new XElement("productName", ApostrophizeSingleQuotes((languageId == "fr") ? TranslateProductName(p.productName) : p.productName)),
                             new XElement("proprietor", ApostrophizeSingleQuotes((languageId == "fr") ? TranslateProprietor(p.proprietor) : p.proprietor)),
                             //START NEW
                             new XElement("phone", (languageId == "en") ? p.telephone : TranslatePhoneNumber(p.telephone) ),
                             new XElement("secondaryPhone", (languageId == "en") ? p.secondaryPhone : TranslatePhoneNumber(p.secondaryPhone) ),
                             new XElement("offSeasonPhone", (languageId == "en") ? p.offSeasonPhone : TranslatePhoneNumber(p.offSeasonPhone) ),
                             new XElement("tollfree", (languageId == "en") ? p.tollfree : TranslatePhoneNumber(p.tollfree)),
                             new XElement("fax", (languageId == "en") ? p.fax : TranslatePhoneNumber(p.fax)),
                             new XElement("email", p.email),
        // new XElement("web", Regex.Replace(p.web, "^https?://", "")), 
                            new XElement("web", Regex.Replace(p.web, @"^(?:http(?:s)?://)?(?:www(?:[0-9]+)?\.)?", string.Empty, RegexOptions.IgnoreCase)),
                             new XElement("facebookUrl", facebookUrl),
                             new XElement("twitterUrl", twitterUrl),
                             new XElement("longitude", p.longitude),
                             new XElement("latitude", p.latitude),
                             //new XElement("gpsString", (p.longitude.HasValue && p.latitude.HasValue) ? GenerateGpsString(p.latitude.Value,p.longitude.Value).Replace("GPS ","").TrimEnd('.') : ""),
                             new XElement("gpsString", (p.longitude.HasValue && p.latitude.HasValue) ? String.Format("{0}, {1}",p.latitude, p.longitude) : ""),
                             new XElement("address", GenerateAddressString(p.line1, p.line2, p.line3, (p.communityId != null) ? p.refCommunity.communityName : "", p.postalCode)),
                             new XElement("addressLine1", p.line1),
                             new XElement("accommodationTypeString", String.Join(", ",(from a in paq where a.attributeGroupId == (short)AttributeGroup.AccommodationType select GetAccommodationTypeAbbreviation((AccommodationType)a.attributeId, languageId)).ToArray())),
                             new XElement("directions", (pvt != null) ? pvt.directions : ""),
                             new XElement("unitDescription", (pvt != null) ? pvt.unitDescription : ""),
                             new XElement("printDescription", (pvt != null) ? String.Format("{0}{1}", (String.IsNullOrEmpty(pvt.unitDescription)) ? "" : String.Format("{0} ", pvt.unitDescription), pvt.printDescription) : ""),
                             new XElement("rateString", rateString),
                             new XElement("cancellationPolicy", (p.PrintVersion.cancellationPolicyId != null) ? GetCancellationPolicyAbbreviation((CancellationPolicy)p.PrintVersion.cancellationPolicyId, languageId) : ""),
                             new XElement("cancellationPolicyDescription", (pt != null) ? pt.cancellationPolicy : ""),
                             //hack to reuse existing logic
                             new XElement("openCloseDates", GenerateHoursString(p,languageId, ExportType.Html).Replace("<b>","").Replace("</b>","")),
                             new XElement("dateDetails", (pvt != null) ? pvt.dateDescription : ""),
                             new XElement("offSeason", p.PrintVersion.hasOffSeasonDates ? "Yes" : ""),
                             new XElement("paymentOptions", paymentOptionsString.TrimEnd('.')),
                             new XElement("seatingCapacityExterior", p.seatingCapacityExterior),
                             new XElement("seatingCapacityInterior", p.seatingCapacityInterior),
                             new XElement("xrefs", ""),
                             new XElement("restaurantCategory", restaurantCategory),
                             new XElement("restaurantSpecialty", restaurantSpecialty),
                             new XElement("fineArtsCategory", fineArtsCategory),
                             new XElement("fineArtsMedia", fineArtsMedia),
                             //END NEW
                             new XElement("trailDistance", p.trailDistance),
                             new XElement("trailDuration", p.trailDuration),
                             //new XElement("exhibitType", (p.productTypeId == (int)ProductType.FineArts) ? GetExhibitTypeLabel(paq, languageId) : ""),
                             new XElement("exhibitType", (exhibitType != null) ? "Yes" : "No"),
                             new XElement("fineArtsTypeDescription", (p.productTypeId == (int)ProductType.FineArts) ? GenerateFineArtsTypeDescription(p, paq, ExportType.Html, languageId) : ""),
                             new XElement("restaurantSubLine", (p.productTypeId == (int)ProductType.Restaurants) ? GenerateRestaurantSubLine(paq, ExportType.Html, languageId) : ""),
                             new XElement("guideSection", GetGuideSectionTitle(p,languageId)),
                             new XElement("productType", GetProductTypeLabel((ProductType)p.productTypeId)),
                             new XElement("region", (p.communityId != null) ? GetRegionTitle((Region)p.refCommunity.regionId, languageId) : ""),
                             new XElement("communityName", (p.communityId != null) ? p.refCommunity.communityName : ""),
                             new XElement("communityMapIndex", (p.communityId != null) ? p.refCommunity.guideIndex : ""),
                             new XElement("productContactString", contactString),
                             new XElement("symbolString", GenerateSymbolString(p, paq, languageId)),
                             new XElement("listingBody", listingBody),
                             new XElement("webDescription", (pt != null) ? pt.webDescription : ""),
                             new XElement("currentDate", String.Format("{0:MMMM d, yyyy}", DateTime.Now)),
                             new XElement("characterCount", CalculateCharacterCount(listingBody + contactString)),
                             new XElement("contactId", c.id),
                             new XElement("contactEmail", c.email),
                             new XElement("contactTelephone",
                                          contactOfficePhone != null ? contactOfficePhone.phoneNumber : ""),
                             new XElement("contactMobile",
                                          contactMobile != null ? contactMobile.phoneNumber : ""),
                             new XElement("contactHomePhone",
                                          contactHomePhone != null ? contactHomePhone.phoneNumber : ""),
                             new XElement("contactOffSeason",
                                          contactOffSeason != null ? contactOffSeason.phoneNumber : ""),
                             new XElement("contactFax", contactFax != null ? contactFax.phoneNumber : ""),
                             new XElement("contactMailingAddress", GenerateContactMailingAddress(c)),
                             new XElement("confirmationFormDueDate", String.Format("{0:MMM d, yyyy}", p.confirmationDueDate))
                );

            return elem;
        }

        private XElement GenerateCrossReferenceFormXml(XElement parentXml, Product p, ProductDescription pd, string languageId)
        {
            XElement xe = new XElement(parentXml);

            //hack
            string gs = (pd.descriptionTypeId < 50) ? GetOutdoorsGuideSectionTitle((GuideSectionOutdoors)pd.descriptionTypeId, languageId) : GetTourOpGuideSectionTitle((GuideSectionTourOps)pd.descriptionTypeId, languageId);
            string listingBody = GenerateCrossReferenceListingBody(p, pd, parentXml.Element("guideSection").Value, languageId, ExportType.Html);

            xe.Element("guideSection").SetValue(gs);
            xe.Element("listingBody").SetValue(listingBody);
            xe.Element("characterCount").SetValue(CalculateCharacterCount(listingBody + parentXml.Element("productContactString").Value));

            //GenerateCrossReferenceListingBody(p, pd, parentXml.Element("guideSection").Value, languageId, ExportType.Html);

            return xe;
        }


        public int CalculateCharacterCount(string s)
        {
            s = Regex.Replace(s, "</?b>", "");
            s = Regex.Replace(s, "</?sup>", "");
            s = Regex.Replace(s, "[^a-zA-z0-9é]", "");
            s = s.Replace("See ad p. XXX.", "");

            return s.Length;
        }



        public string GenerateContactMailingAddress (Contact c)
        {
            IQueryable<Address> aq = businessBs.GetContactAddresses(c.id);
            
            Address address =
                (from a in aq where a.addressTypeId == (int) AddressType.Mailing select a).FirstOrDefault();

            StringBuilder sb = new StringBuilder();
            sb.AppendFormat("{0} {1}<br/>", c.firstName, c.lastName);

            if (!String.IsNullOrEmpty(c.jobTitle))
            {
                sb.AppendFormat("{0}<br/>", c.jobTitle);
            }

            sb.AppendFormat("{0}<br/>", c.Business.businessName);
            
            if (address != null)
            {
                if (!String.IsNullOrEmpty(address.line1))
                {
                    sb.AppendFormat("{0}", address.line1);
                }

                if (!String.IsNullOrEmpty(address.line2))
                {
                    sb.AppendFormat(", {0}", address.line2);
                }

                if (!String.IsNullOrEmpty(address.line3))
                {
                    sb.AppendFormat(", {0}", address.line3);
                }

                sb.Append("<br/>");

                sb.AppendFormat("{0}", address.city);

                if (address.countryId == "CA")
                {
                    sb.AppendFormat(", {0}&nbsp;&nbsp;&nbsp;&nbsp;{1}<br/>", address.provinceStateId, address.postalCode);
                }
                else if (address.countryId == "US")
                {
                    sb.AppendFormat(", {0}&nbsp;&nbsp;&nbsp;&nbsp;{1}<br/>{2}", address.provinceStateId, address.postalCode, address.refCountry.countryName);
                }
                else
                {
                    sb.AppendFormat(", {0}<br/>", address.otherRegion);
                    
                    if (!String.IsNullOrEmpty(address.postalCode))
                    {
                        sb.AppendFormat("{0}<br/>", address.postalCode);
                    }

                    if (!String.IsNullOrEmpty(address.countryId))
                    {
                        sb.AppendFormat("{0}<br/>", address.refCountry.countryName);
                    }
                }
            }

            return sb.ToString();
        }

        private string GenerateAdRefString(IQueryable<ProductAttribute> paq, string languageId, ExportType et, string spacing)
        {
            StringBuilder sb = new StringBuilder();

            if ((languageId == "en") && ((from a in paq where a.attributeId == (short)PrintOption.AddEnglishAdRef select a).Count() > 0))
            {
                return sb.AppendFormat("{0}{1}{2}", (et == ExportType.Print) ? CrossAdRef : "", spacing, "See ad p. XXX.").ToString();
            }

            if ((languageId == "fr") && ((from a in paq where a.attributeId == (short)PrintOption.AddFrenchAdRef select a).Count() > 0))
            {
                return sb.AppendFormat("{0}{1}{2}", (et == ExportType.Print) ? CrossAdRef : "", spacing, "Voir annonce à la p. XXX.").ToString();
            }

            return "";
        }

        private string[] SplitCommunityName(string communityName)
        {
            var origCommunityName = communityName;
            var maxLength = 9;

            var a = new string[3] {"", "", ""};

            if (communityName.Length <= maxLength)
            {
                a[0] = String.Format(CoordinateHead, communityName);
                return a;
            }

            for (var j=0;j <=2; j++)
            {
                if (communityName.Length == 0)
                {
                    break;
                }

                if (communityName.Length >= (maxLength + 1) && communityName[maxLength] == ' ')
                {
                    a[j] = String.Format(CoordinateHead, communityName.Substring(0, Math.Min(communityName.Length, maxLength + 1)));

                    communityName = communityName.Remove(0, maxLength + 1);
                }
                else if (communityName.Substring(0, Math.Min(communityName.Length, maxLength)).Contains(" "))
                {
                    a[j] = String.Format(CoordinateHead, communityName.Substring(0, communityName.Substring(0, Math.Min(communityName.Length, maxLength)).LastIndexOf(' ')));

                    communityName = communityName.Remove(0, communityName.Substring(0, Math.Min(communityName.Length, maxLength)).LastIndexOf(' ') + 1);
                }
                else
                {
                    //a[j] = communityName.Substring(0, Math.Min(communityName.Length, maxLength));
                    //a[j] = String.Format("{0}{1}", String.Format(CoordinateHead, communityName.Substring(0, Math.Min(communityName.Length, maxLength))),(communityName.Length > maxLength) ? "-" : "");
                    //a[j] = String.Format(CoordinateHead, String.Format("{0}{1}", communityName.Substring(0, Math.Min(communityName.Length, maxLength)), (communityName.Length > maxLength) ? "-" : ""));
                    a[j] = String.Format(CoordinateHead,communityName);
                    communityName = "";

                }

                if (j > 0 && a[j] != "")
                {
                    a[j] = a[j] + SectionBreak;
                }
            }

            return a;
        }

       public string ExportAccommodations(Region r, string languageId)
        {
            IQueryable<Product> pq = productBs.GetProductsForPrintExport(ProductType.Accommodation, r);

            StringBuilder sb = new StringBuilder();

            short lastCommunityId = -1;

            foreach (Product p in pq)
            {
                IQueryable<ProductAttribute> paq = productBs.GetProductAttributes(p.id);
            
                var communityCells = new string[3] {"", "", ""};
            
                if (p.communityId != lastCommunityId)
                {
                    lastCommunityId = p.communityId.Value;
                    sb.Append(ListingHeadTab);

                    communityCells = SplitCommunityName(p.refCommunity.communityName);

                    sb.AppendFormat(communityCells[0]);
                }
                else
                {
                    sb.Append(ListingHead);
                }

                sb.AppendFormat(ListingHeadName, ApostrophizeSingleQuotes((languageId == "en") ? p.productName : TranslateProductName(p.productName)));

                sb.AppendFormat("{0} ", ListingHeadSymbols);

                sb.Append(GenerateAccommodationSymbolString(p, paq, productBs.GetProductCaaRatings(p.id), productBs.GetProductCanadaSelectRatings(p.id), ExportType.Print, languageId));

                sb.Append("\t");

                sb.Append(GenerateAccommodationGrid(p, paq, languageId, ExportType.Print));

                sb.Append(Eol);

                string contactString = GenerateContactString(p, ExportType.Print, languageId);

                
                sb.AppendFormat("{0}{1}{2}", ContactHead, (communityCells[1].Length > 0) ? communityCells[1] : "\t", contactString);
                
                //if (!String.IsNullOrEmpty(contactString))
                //{
                //    sb.AppendFormat("{0}{1}{2}", ContactHead, (communityCells[1].Length > 0) ? communityCells[1] : "\t", contactString);
                //}

                sb.Append(GenerateAccommodationGridLine2(p, paq, languageId, ExportType.Print));

                sb.Append(MainListingHead);

                sb.Append(communityCells[2]);

                sb.Append(GenerateAccommodationListingBody(p, paq, languageId, ExportType.Print));

                sb.Append(Eol);
            }

            return sb.ToString();
        }

        private string TranslateProprietor (string proprietor)
        {
            if (String.IsNullOrEmpty(proprietor))
            {
                return proprietor;
            }

            string newProprietor = proprietor;

            Match match = ProprietorRegex.Match(proprietor);
            if (match.Success)
            {
                string s = match.Groups[2].Value;
                newProprietor = String.Format("La famille {0}", s);
            }

            newProprietor = newProprietor.Replace("&", "et");
            newProprietor = newProprietor.Replace(" and ", " et ");

            return newProprietor;
        }

        private string TranslateProductName(string productName)
        {
            if (String.IsNullOrEmpty(productName))
            {
                return productName;
            }

            string newProductName = productName;

            Match match = CircaRegex.Match(productName);

            if (match.Success)
            {
                newProductName = String.Format("{0}v {1}{2}", match.Groups[1].Value, match.Groups[3].Value, match.Groups[4].Value);
            }

            newProductName = newProductName.Replace("formerly", "autrefois");
            
            return newProductName;
        }

        private string TranslatePhoneNumber(string phoneNumber)
        {
            return String.IsNullOrEmpty(phoneNumber) ? phoneNumber : phoneNumber.Replace("ext", "poste");
        }

        

        private string GenerateAccommodationListingBody (Product p, IQueryable<ProductAttribute> paq, string languageId, ExportType et)
        {
            StringBuilder sb = new StringBuilder();
            
            IQueryable<PrintVersionTranslation> pvtq = productBs.GetPrintVersionTranslations(p.id);
            
            PrintVersionTranslation pvt = (from w in pvtq where w.languageId == languageId select w).FirstOrDefault();

            if (!String.IsNullOrEmpty(p.proprietor))
            {
                sb.AppendFormat("{0}.", (languageId == "en") ? p.proprietor : TranslateProprietor(p.proprietor));
            }

            sb.Append(GenerateAddressString(p));

            if (p.latitude.HasValue && p.longitude.HasValue && (from a in paq where a.attributeId == (short)PrintOption.PrintGps select a).Count() > 0)
            {
                sb.AppendFormat(" GPS {0}, {1}.", Math.Round(p.latitude.Value, 5) , Math.Round(p.longitude.Value, 5));
            }

            sb.Append(GenerateAccommodationTypeHeader(paq, et, languageId));

            if (pvt != null && !String.IsNullOrEmpty(pvt.unitDescription))
            {
                sb.AppendFormat(" {0}", pvt.unitDescription);
            }

            if (pvt != null && !String.IsNullOrEmpty(pvt.printDescription))
            {
                sb.AppendFormat(" {0}", pvt.printDescription);
            }

            sb.Append(GenerateAbbrRateString(p, languageId, pvt.rateDescription));
            
            sb.Append(GenerateHoursString(p, languageId, et));

            if (pvt != null && !String.IsNullOrEmpty(pvt.dateDescription))
            {
                sb.AppendFormat(", {0}", (pvt.dateDescription.Substring(pvt.dateDescription.Length - 1) == ".") ? pvt.dateDescription.Substring(0, pvt.dateDescription.Length - 1) : pvt.dateDescription);
            }

            if (p.PrintVersion.hasOffSeasonDates)
            {
                sb.AppendFormat("; {0}", (languageId == "en") ? "O/S by reservation" : "HS sur réservation");
            }
            
            sb.Append(".");

            //sb.Append(GenerateSocialMediaString(p));
            
            //sb.Append(GenerateAdRefString(paq, languageId, et));
             
            return ApostrophizeSingleQuotes(sb.ToString().Trim()); 
        }
       
        private string GenerateAccommodationGrid (Product p, IQueryable<ProductAttribute> paq, string languageId, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            var rateString = new StringBuilder();

            if (p.PrintVersion.lowRate != null && p.PrintVersion.highRate != null && p.PrintVersion.lowRate != p.PrintVersion.highRate)
            {
                rateString.AppendFormat(languageId == "fr" ? "{0}–{1}$" : "${0}–{1}", Math.Round(p.PrintVersion.lowRate.Value), Math.Round(p.PrintVersion.highRate.Value));
            }
            else if (p.PrintVersion.lowRate != null || p.PrintVersion.highRate != null)
            {
                rateString.AppendFormat(languageId == "fr" ? "{0}$" : "${0}", (p.PrintVersion.lowRate != null) ? Math.Round(p.PrintVersion.lowRate.Value) : Math.Round(p.PrintVersion.highRate.Value));
            }

            if (p.PrintVersion.ratePeriodId != null && p.PrintVersion.ratePeriodId == (int)RatePeriod.Weekly)
            {
                rateString.Append(languageId == "fr" ? "/sem" : "w");
            }
            else if (p.PrintVersion.ratePeriodId != null && p.PrintVersion.ratePeriodId == (int)RatePeriod.Monthly)
            {
                rateString.Append(languageId == "fr" ? "/m" : "m");
            }

            sb.AppendFormat(GridText, rateString);

            sb.AppendFormat(GridText, (from ppt in p.ProductPaymentTypes
                                       where ppt.paymentTypeId == ((int) PaymentType.AmericanExpress)
                                             || ppt.paymentTypeId == ((int) PaymentType.DinersClub)
                                             || ppt.paymentTypeId == ((int) PaymentType.Discover)
                                             || ppt.paymentTypeId == ((int) PaymentType.Jcb)
                                             || ppt.paymentTypeId == ((int) PaymentType.Mastercard)
                                             || ppt.paymentTypeId == ((int) PaymentType.Visa)
                                       select ppt).Count() > 0
                                          ? GridBullet
                                          : " ");

            var bathroomString = new StringBuilder();
            
            if ((from pa in paq where pa.attributeId == ((int)AccommodationAmenity.BathroomEnsuite) select pa).Count() > 0)
            {
                bathroomString.AppendFormat("{0},", languageId == "fr" ? "Att" : "E");
            }
            
            if ((from pa in paq where pa.attributeId == ((int)AccommodationAmenity.BathroomPrivate) select pa).Count() > 0)
            {
                bathroomString.AppendFormat("{0},", languageId == "fr" ? "Pri" : "P");
            }

            if ((from pa in paq where pa.attributeId == ((int)AccommodationAmenity.BathroomShared) select pa).Count() > 0)
            {
                bathroomString.AppendFormat("{0},", languageId == "fr" ? "Par" : "S");
            }

            sb.AppendFormat(GridText, (bathroomString.Length > 0) ? bathroomString.ToString().TrimEnd(',') : bathroomString.ToString());

            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)AccommodationAmenity.CableTv) || pa.attributeId == ((int)AccommodationAmenity.SatelliteTv) select pa).Count() > 0 ? GridBullet : "");

            var internetString = new StringBuilder();

            if ((from pa in paq where pa.attributeId == ((int)AccommodationAmenity.InternetWired) select pa).Count() > 0)
            {
                internetString.AppendFormat("{0},", EscapedAtSign);
            }
            
            if ((from pa in paq where pa.attributeId == ((int)AccommodationAmenity.Wifi) select pa).Count() > 0)
            {
                internetString.Append("W,");
            }

            sb.AppendFormat(GridText, internetString.ToString().TrimEnd(','));

            if ((from pa in paq where pa.attributeId == ((int)AccommodationAmenity.Kitchen) select pa).Count() > 0)
            {
                sb.AppendFormat(GridText, GridBullet);
            }
            else if ((from pa in paq where pa.attributeId == ((int)AccommodationAmenity.Kitchenette) select pa).Count() > 0)
            {
                sb.AppendFormat(GridText, GridHalfBullet);
            }
            else
            {
                sb.AppendFormat(GridText, "");
            }

            var poolString = new StringBuilder();
            
            if ((from pa in paq where pa.attributeId == ((int)Feature.PoolIndoor) select pa).Count() > 0)
            {
                poolString.AppendFormat("{0},", languageId == "fr" ? "I" : "I");
            }
            
            if ((from pa in paq where pa.attributeId == ((int)Feature.PoolOutdoor) select pa).Count() > 0)
            {
                poolString.AppendFormat("{0},", languageId == "fr" ? "E" : "O");
            }

            sb.AppendFormat(GridText, poolString.ToString().TrimEnd(','));

            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int) Feature.Restaurant) select pa).Count() > 0 ? GridBullet : "");

            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)Feature.MultiLingual) select pa).Count() > 0 ? GridBullet : "");

            sb.AppendFormat(GridText, (p.PrintVersion.cancellationPolicyId != null) ? GetGridCancellationPolicyAbbreviation((CancellationPolicy)p.PrintVersion.cancellationPolicyId, languageId) : "*");

            return sb.ToString();
        }

        private string GenerateAttractionGrid(Product p, IQueryable<ProductAttribute> paq, string languageId, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            var q = (from pvt in p.PrintVersionTranslations
                    where pvt.languageId == "en"
                    select pvt.rateDescription).ToList();

            //Admission column; hack for guide does the rateDescription include "$"
            var admissionChar = "";
            if ((from t in q where t.Contains("$") || t.ToUpper().Contains("ADMISSION CHARGED") select t).Count() > 0)
            {
                admissionChar = "$";
            }
            else if ((from t in q where t.Contains("donation") select t).Count() > 0)
            {
                admissionChar = "D";
            }

            //admission column
            sb.AppendFormat(GridText, admissionChar);

            //credit card column
            sb.AppendFormat(GridText, (from ppt in p.ProductPaymentTypes
                                       where ppt.paymentTypeId == ((int)PaymentType.AmericanExpress)
                                             || ppt.paymentTypeId == ((int)PaymentType.DinersClub)
                                             || ppt.paymentTypeId == ((int)PaymentType.Discover)
                                             || ppt.paymentTypeId == ((int)PaymentType.Jcb)
                                             || ppt.paymentTypeId == ((int)PaymentType.Mastercard)
                                             || ppt.paymentTypeId == ((int)PaymentType.Visa)
                                       select ppt).Count() > 0
                                          ? GridBullet
                                          : " ");

            
            //bus tour column
            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)Feature.BusTours) select pa).Count() > 0 ? GridBullet : "");

            //food service column: restaurant or takeout or tearoom
            sb.AppendFormat(GridText, (from pa in paq where (pa.attributeId == ((int)Feature.Restaurant) || pa.attributeId == ((int)Feature.Takeout) || pa.attributeId == ((int)Feature.TeaRoom)) select pa).Count() > 0 ? GridBullet : "");

            //gift ship column
            sb.AppendFormat(GridText, (from pa in paq where (pa.attributeId == ((int)Feature.GiftShop)) select pa).Count() > 0 ? GridBullet : "");
            
            //parking space column
            sb.AppendFormat(GridText, p.parkingSpaces);

            //picnic tables column
            sb.AppendFormat(GridText, (from pa in paq where (pa.attributeId == ((int)Feature.PicnicTables)) select pa).Count() > 0 ? GridBullet : "");

            return sb.ToString();
        }

        private string GenerateCampgroundGrid(Product p, IQueryable<ProductAttribute> paq, string languageId, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            //rates column
            var rateString = "";
            if (p.PrintVersion.lowRate != null && p.PrintVersion.highRate != null && p.PrintVersion.lowRate != p.PrintVersion.highRate)
            {
                rateString = String.Format(languageId == "fr" ? "{0}–{1}$" : "${0}–{1}", Math.Round(p.PrintVersion.lowRate.Value), Math.Round(p.PrintVersion.highRate.Value));
            }
            else if (p.PrintVersion.lowRate != null || p.PrintVersion.highRate != null)
            {
                rateString = String.Format(languageId == "fr" ? "{0}$" : "${0}", (p.PrintVersion.lowRate != null) ? Math.Round(p.PrintVersion.lowRate.Value) : Math.Round(p.PrintVersion.highRate.Value));
            }

            sb.AppendFormat(GridText, rateString);

            //credit card column
            sb.AppendFormat(GridText, (from ppt in p.ProductPaymentTypes
                                       where ppt.paymentTypeId == ((int)PaymentType.AmericanExpress)
                                             || ppt.paymentTypeId == ((int)PaymentType.DinersClub)
                                             || ppt.paymentTypeId == ((int)PaymentType.Discover)
                                             || ppt.paymentTypeId == ((int)PaymentType.Jcb)
                                             || ppt.paymentTypeId == ((int)PaymentType.Mastercard)
                                             || ppt.paymentTypeId == ((int)PaymentType.Visa)
                                       select ppt).Count() > 0
                                               ? GridBullet
                                               : " ");


            //short term sites
            sb.AppendFormat(GridText, (from pun in p.ProductUnitNumbers where pun.unitTypeId == (int)ResearchUnitType.ShortTerm select pun.units).Sum());

            //seasonal sites
            sb.AppendFormat(GridText, (from pun in p.ProductUnitNumbers where pun.unitTypeId == (int)ResearchUnitType.Seasonal select pun.units).Sum() );

            //cabin/hut/trailers 
            sb.AppendFormat(GridText, (from pa in paq where (pa.attributeId == ((int)CampgroundAmenity.CampCabinsTrailers)) select pa).Count() > 0 ? GridBullet : "");

            //pull throughs
            sb.AppendFormat(GridText, (from pa in paq where (pa.attributeId == ((int)CampgroundAmenity.PullThroughs)) select pa).Count() > 0 ? GridBullet : "");

            //open/shaded
            var openShaded = new StringBuilder();

            if ((from pa in paq where pa.attributeId == ((int)CampgroundAmenity.OpenSites) select pa).Count() > 0)
            {
                openShaded.AppendFormat("{0},", languageId == "fr" ? "D" : "O");
            }

            if ((from pa in paq where pa.attributeId == ((int)CampgroundAmenity.ShadedSites) select pa).Count() > 0)
            {
                openShaded.AppendFormat("{0},", languageId == "fr" ? "O" : "S");
            }

            sb.AppendFormat(GridText, (openShaded.Length > 0) ? openShaded.ToString().TrimEnd(',') : openShaded.ToString());

            //services 
            var services = new StringBuilder();

            var servicesCount = (from pa in paq where pa.attributeId == ((int)CampgroundAmenity.SewageHookup)
                                    || pa.attributeId == ((int)CampgroundAmenity.WaterHookup)
                                    || pa.attributeId == ((int)CampgroundAmenity.ElectricalHookup)
                                        select pa).Count();


            services.AppendFormat(servicesCount > 0 ? String.Format("{0},",servicesCount.ToString()) : "");

            if ((from pa in paq where pa.attributeId == ((int)CampgroundAmenity.Unserviced) select pa).Count() > 0)
            {
                services.AppendFormat("{0},", languageId == "fr" ? "NA" : "U");
            }
            sb.AppendFormat(GridText, (services.Length > 0) ? services.ToString().TrimEnd(',') : services.ToString());

            //toilets
            var toilets = new StringBuilder();

            if ((from pa in paq where pa.attributeId == ((int)CampgroundAmenity.FlushToilets) select pa).Count() > 0)
            {
                toilets.AppendFormat("{0},", languageId == "fr" ? "C" : "F");
            }

            if ((from pa in paq where pa.attributeId == ((int)CampgroundAmenity.PitToilet) select pa).Count() > 0)
            {
                toilets.AppendFormat("{0},", languageId == "fr" ? "L" : "P");
            }

            sb.AppendFormat(GridText, (toilets.Length > 0) ? toilets.ToString().TrimEnd(',') : toilets.ToString());

            //showers
            var showers = new StringBuilder();
            if ((from pa in paq where pa.attributeId == ((int)CampgroundAmenity.ShowersFree) select pa).Count() > 0)
            {
                showers.AppendFormat("{0},", GridBullet);
            }

            if ((from pa in paq where pa.attributeId == ((int)CampgroundAmenity.ShowersPay) select pa).Count() > 0)
            {
                showers.Append("$,");
            }

            sb.AppendFormat(GridText, (showers.Length > 0) ? showers.ToString().TrimEnd(',') : showers.ToString());

            //Disposal Station
            sb.AppendFormat(GridText, (from pa in paq where (pa.attributeId == ((int)CampgroundAmenity.DisposalStation)) select pa).Count() > 0 ? GridBullet : "");

            //Propane
            sb.AppendFormat(GridText, (from pa in paq where (pa.attributeId == ((int)CampgroundAmenity.Propane)) select pa).Count() > 0 ? GridBullet : "");

            //Store
            sb.AppendFormat(GridText, (from pa in paq where (pa.attributeId == ((int)CampgroundAmenity.Store)) select pa).Count() > 0 ? GridBullet : "");

            //takeout/canteen
            sb.AppendFormat(GridText, (from pa in paq where (pa.attributeId == ((int)Feature.Takeout)) select pa).Count() > 0 ? GridBullet : "");

            //laundromat
            sb.AppendFormat(GridText, (from pa in paq where (pa.attributeId == ((int)CampgroundAmenity.Laundromat)) select pa).Count() > 0 ? GridBullet : "");

            //shelters
            sb.AppendFormat(GridText, (from pa in paq where (pa.attributeId == ((int)CampgroundAmenity.CookingShelter)) select pa).Count() > 0 ? GridBullet : "");

            //swimming
            var swimming = new StringBuilder();

            if ((from pa in paq where pa.attributeId == ((int)CampgroundAmenity.SwimmingLake) select pa).Count() > 0)
            {
                swimming.AppendFormat("{0},", languageId == "fr" ? "L" : "L");
            }

            if ((from pa in paq where pa.attributeId == ((int)CampgroundAmenity.SwimmingOcean) select pa).Count() > 0)
            {
                swimming.AppendFormat("{0},", languageId == "fr" ? "M" : "O");
            }

            if ((from pa in paq where pa.attributeId == ((int)Feature.PoolOutdoor) || pa.attributeId == ((int)Feature.PoolIndoor) select pa).Count() > 0)
            {
                swimming.AppendFormat("{0},", languageId == "fr" ? "P" : "P");
            }

            if ((from pa in paq where pa.attributeId == ((int)CampgroundAmenity.SwimmingRiver) select pa).Count() > 0)
            {
                swimming.AppendFormat("{0},", languageId == "fr" ? "R" : "R");
            }

            sb.AppendFormat(GridText, (swimming.Length > 0) ? swimming.ToString().TrimEnd(',') : swimming.ToString());

            //playground
            sb.AppendFormat(GridText, (from pa in paq where (pa.attributeId == ((int)CampgroundAmenity.Playground)) select pa).Count() > 0 ? GridBullet : "");

            //rechall
            sb.AppendFormat(GridText, (from pa in paq where (pa.attributeId == ((int)CampgroundAmenity.RecHall)) select pa).Count() > 0 ? GridBullet : "");

            return sb.ToString();
        }

        private string GenerateCampgroundGridLine2(Product p, IQueryable<ProductAttribute> paq, string languageId, ExportType et)
        {
            var noTax = "\t";

            if (p.PrintVersion.noTax)
            {
                noTax = String.Format(GridText,(languageId == "fr") ? "sans taxes" : "no tax");
            }

           return String.Format("\t\t{0}\t\t\t\t\t\t\t{1}",noTax,String.Format(GridText, GenerateAdRefString(paq, languageId, et, "   ")));
        }

        private string GenerateFineArtsGrid(Product p, IQueryable<ProductAttribute> paq, string languageId, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            //Accessories column
            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)ArtType.Accessories) select pa).Count() > 0 ? GridBullet : "");

            //Clothing column
            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)ArtType.Clothing) select pa).Count() > 0 ? GridBullet : "");

            //Fine art column
            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)ArtType.FineArt) || pa.attributeId == ((int)ArtType.Sculpture) || pa.attributeId == ((int)ArtType.VisualArt) select pa).Count() > 0 ? GridBullet : "");

            //Food column
            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)ArtType.Food) select pa).Count() > 0 ? GridBullet : "");

            //Home & Garden column
            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)ArtType.GardenAccessories) || pa.attributeId == ((int)ArtType.HomeDecor) || pa.attributeId == ((int)ArtType.Furniture) select pa).Count() > 0 ? GridBullet : "");

            //Jewellery column
            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)ArtType.Jewellery) select pa).Count() > 0 ? GridBullet : "");

            //Bath & body column
            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)ArtType.BathBodyProducts) select pa).Count() > 0 ? GridBullet : "");

            return sb.ToString();
        }

        private string GenerateOutdoorsGrid(Product p, IQueryable<ProductAttribute> paq, string languageId, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            //Accessibility column
            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)Feature.WheelChairAccessible) select pa).Count() > 0 ? GridBullet : (from pa in paq where pa.attributeId == ((int)Feature.LimitedAccessibility) select pa).Count() > 0 ? "p" : "");

            //Tours offered column
            sb.AppendFormat(GridText, (from pd in p.ProductDescriptions where pd.descriptionTypeId >= 50 select pd).Count() > 0 ? GridBullet : "");

            //Hiking column
            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)Activity.Hiking) select pa).Count() > 0 ? GridBullet : "");

            //Cycling column
            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)Activity.Cycling) select pa).Count() > 0 ? GridBullet : "");

            //Canoeing/Kayaking column
            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)Activity.Kayaking) || pa.attributeId == ((int)Activity.Canoeing) select pa).Count() > 0 ? GridBullet : "");

            //Snowmobiling column
            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)Activity.Atv) || pa.attributeId == ((int)Activity.Snowmobiling) select pa).Count() > 0 ? GridBullet : "");

            //Winter Activities column
            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)Activity.DogSledding) || pa.attributeId == ((int)Activity.CrossCountrySkiing) || pa.attributeId == ((int)Activity.DownhillSkiing)
                                       || pa.attributeId == ((int)Activity.SleighRiding) || pa.attributeId == ((int)Activity.Snowshoeing)
                                       select pa).Count() > 0 ? GridBullet : "");

            return sb.ToString();
        }

        private string GenerateTrailGrid(Product p, IQueryable<ProductAttribute> paq, string languageId, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            //Length/Distance column
            var trailDistance = "";
            if (p.trailDistance.HasValue) 
            {
                trailDistance = (p.trailDistance % 1) == 0 ? ((int)p.trailDistance).ToString() : Math.Round(p.trailDistance.Value,1).ToString();
            }

            sb.AppendFormat(GridText, (languageId == "en") ? trailDistance : trailDistance.Replace('.', ','));

            //Trail Type column
            var trailType = "";
            if ((from pa in paq where pa.attributeId == ((int)TrailType.DayUse) select pa).Count() > 0)
            {
                trailType = "D";
            }
            else if ((from pa in paq where pa.attributeId == ((int)TrailType.Linear) select pa).Count() > 0)
            {
                trailType = "L";
            }
            else if ((from pa in paq where pa.attributeId == ((int)TrailType.Urban) select pa).Count() > 0)
            {
                trailType = "U";
            }
            else if ((from pa in paq where pa.attributeId == ((int)TrailType.Wilderness) select pa).Count() > 0)
            {
                trailType = "W";
            }
            sb.AppendFormat(GridText, trailType);

            //Time to complete/Duration column
            //var trailDuration = "";
            //if (p.trailDuration.HasValue)
            //{
            //    trailDuration = (p.trailDuration % 1) == 0 ? ((int)p.trailDuration).ToString() : Math.Round(p.trailDuration.Value, 1).ToString();
            //}
            //sb.AppendFormat(GridText, (languageId == "en") ? trailDuration : trailDuration.Replace('.', ','));

            //Cell Service column
            var cellService = "";
            if ((from pa in paq where pa.attributeId == ((int)CellService.Full) select pa).Count() > 0)
            {
                cellService = "F";
            }
            else if ((from pa in paq where pa.attributeId == ((int)CellService.Partial) select pa).Count() > 0)
            {
                cellService = "P";
            }
            else if ((from pa in paq where pa.attributeId == ((int)CellService.NoService) select pa).Count() > 0)
            {
                cellService = "N";
            }
            sb.AppendFormat(GridText, cellService);

            //Dogs Permitted column
            var petsPolicy = "";
            if ((from pa in paq where pa.attributeId == ((int)TrailPetsPolicy.Leashed) select pa).Count() > 0)
            {
                petsPolicy = "L";
            }
            else if ((from pa in paq where pa.attributeId == ((int)TrailPetsPolicy.OffLeash) select pa).Count() > 0)
            {
                petsPolicy = "O";
            }
            else if ((from pa in paq where pa.attributeId == ((int)TrailPetsPolicy.NotAllowed) select pa).Count() > 0)
            {
                petsPolicy = "N";
            } 
            
            sb.AppendFormat(GridText, petsPolicy);
            
            //Trail Surface column
            var trailSurface = "";
            if ((from pa in paq where pa.attributeId == ((int)TrailSurface.Gravel) select pa).Count() > 0)
            {
                trailSurface = "G";
            }
            else if ((from pa in paq where pa.attributeId == ((int)TrailSurface.Hard) select pa).Count() > 0)
            {
                trailSurface = "H";
            }
            else if ((from pa in paq where pa.attributeId == ((int)TrailSurface.Natural) select pa).Count() > 0)
            {
                trailSurface = "N";
            }
            sb.AppendFormat(GridText, trailSurface);

            //Accessibility column
            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)Feature.WheelChairAccessible) select pa).Count() > 0 ? GridBullet : (from pa in paq where pa.attributeId == ((int)Feature.LimitedAccessibility) select pa).Count() > 0 ? "P" : "");                           

            return sb.ToString();
        }

        private string GenerateRestaurantGrid(Product p, IQueryable<ProductAttribute> paq, string languageId, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            //interior seating column
            sb.AppendFormat(GridText, p.seatingCapacityInterior);

            //exterior seating column
            sb.AppendFormat(GridText, p.seatingCapacityExterior);

            //children's menu column
            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)RestaurantService.ChildrensMenu) select pa).Count() > 0 ? GridBullet : "");

            //Dining room column
            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)RestaurantService.DiningRoom) select pa).Count() > 0 ? GridBullet : "");

            //Licensed column
            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)RestaurantService.Licensed) select pa).Count() > 0 ? GridBullet : "");

            //Entertainment column
            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)RestaurantService.LiveEntertainment) select pa).Count() > 0 ? GridBullet : "");

            //Patio column
            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)RestaurantService.Patio) select pa).Count() > 0 ? GridBullet : "");

            //Reservations Rec. column
            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)RestaurantService.ReservationsAccepted) select pa).Count() > 0 ? GridBullet : "");

            //Takeout column
            sb.AppendFormat(GridText, (from pa in paq where pa.attributeId == ((int)RestaurantService.Takeout) select pa).Count() > 0 ? GridBullet : "");

            //Credit/Debit column
            sb.AppendFormat(GridText, ((from ppt in p.ProductPaymentTypes
                                        where ppt.paymentTypeId == ((int)PaymentType.AmericanExpress)
                                        || ppt.paymentTypeId == ((int)PaymentType.DinersClub)
                                        || ppt.paymentTypeId == ((int)PaymentType.Discover)
                                        || ppt.paymentTypeId == ((int)PaymentType.Jcb)
                                        || ppt.paymentTypeId == ((int)PaymentType.Mastercard)
                                        || ppt.paymentTypeId == ((int)PaymentType.Visa)
                                        || ppt.paymentTypeId == ((int)PaymentType.DebitCard)
                                        select ppt).Count() > 0) ? "Y" : "");

            return sb.ToString();
        }

        private string GenerateAccommodationGridLine2(Product p, IQueryable<ProductAttribute> paq, string languageId, ExportType et)
        {
            var sb = new StringBuilder();

            if (p.PrintVersion.extraPersonRate != null)
            {
                sb.AppendFormat(languageId == "fr" ? "ADD {0}$" : "XP ${0}", Math.Round(p.PrintVersion.extraPersonRate.Value));
            }

            if (p.PrintVersion.noTax)
            {
                sb.AppendFormat("{0}{1}", (sb.Length > 0) ? "; " : "" ,(languageId == "fr") ? "sans taxes" : "no tax");
            }

            var adRef = String.Format("\t\t{0}", String.Format(GridText, GenerateAdRefString(paq, languageId, et, "   ")));
            //sb.Append(GenerateAdRefString(paq, languageId, et));

        //    return (sb.Length > 0) ? String.Format("\t{0}{1}", String.Format(GridText, sb.ToString()), Eol) : Eol;
            return String.Format("\t{0}{1}{2}", String.Format(GridText, sb.ToString()), adRef, Eol);
        }

        private string GenerateAttractionListingBody(Product p, IQueryable<ProductAttribute> paq, string languageId, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            IQueryable<PrintVersionTranslation> pvtq = productBs.GetPrintVersionTranslations(p.id);
            PrintVersionTranslation pvt = (from w in pvtq where w.languageId == languageId select w).FirstOrDefault();

            sb.Append(GenerateAddressString(p));

            //if (!String.IsNullOrEmpty(pvt.directions))
            //{
            //    sb.AppendFormat(" {0}", pvt.directions);
            //}

            if (p.latitude.HasValue && p.longitude.HasValue && (from a in paq where a.attributeId == (short)PrintOption.PrintGps select a).Count() > 0)
            {
                sb.AppendFormat(" GPS {0}, {1}.", Math.Round(p.latitude.Value, 5), Math.Round(p.longitude.Value, 5));
            }

            if (pvt != null && !String.IsNullOrEmpty(pvt.printDescription))
            {
                sb.AppendFormat(" {0}", pvt.printDescription);
            }

            //sb.Append(GenerateAttractionCodeString(paq, p.parkingSpaces.ToString(), languageId));

            if (pvt != null && !String.IsNullOrEmpty(pvt.rateDescription))
            {
                sb.AppendFormat(" {0}", pvt.rateDescription);
            }

            //sb.Append(GeneratePaymentTypeString(productBs.GetProductPaymentTypes(p.id), languageId));
            try
            {
                sb.Append(GenerateHoursString(p, languageId, et));    
            }
            catch (Exception e)
            {
                var x = "";
            }
            

            if (pvt != null && !String.IsNullOrEmpty(pvt.dateDescription))
            {
                sb.AppendFormat(", {0}", pvt.dateDescription);
            }
            else
            {
                sb.Append(".");
            }

            //sb.Append(GenerateAdRefString(paq, languageId, et));

            return ApostrophizeSingleQuotes(sb.ToString().Trim());
        }

        private string GenerateFineArtsListingBody(Product p, IQueryable<ProductAttribute> paq, string languageId, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            IQueryable<PrintVersionTranslation> pvtq = productBs.GetPrintVersionTranslations(p.id);
            PrintVersionTranslation pvt = (from w in pvtq where w.languageId == languageId select w).FirstOrDefault();

            sb.Append(GenerateFineArtsAddressString(p));

            if (p.latitude.HasValue && p.longitude.HasValue && (from a in paq where a.attributeId == (short)PrintOption.PrintGps select a).Count() > 0)
            {
                sb.AppendFormat(" GPS {0}, {1}.", Math.Round(p.latitude.Value, 5), Math.Round(p.longitude.Value, 5));
            }

            if (pvt != null && !String.IsNullOrEmpty(pvt.printDescription))
            {
                sb.AppendFormat(" {0}", pvt.printDescription);
            }

            sb.Append(GeneratePaymentTypeString(productBs.GetProductPaymentTypes(p.id), languageId));

            sb.Append(GenerateHoursString(p, languageId, et));

            if (pvt != null && !String.IsNullOrEmpty(pvt.dateDescription))
            {
                sb.AppendFormat(", {0}", pvt.dateDescription);
            }
            else
            {
                sb.Append(".");
            }

            return ApostrophizeSingleQuotes(sb.ToString().Trim());
       }

        private string GenerateOutdoorCrossReferenceListingBody(Product p, IQueryable<ProductAttribute> paq, string languageId, ExportType et, byte? sectionId)
        {
            StringBuilder sb = new StringBuilder();

            var desc = (from pd in p.ProductDescriptions where pd.descriptionTypeId == sectionId && pd.languageId == languageId select pd.description).FirstOrDefault();

            //IQueryable<PrintVersionTranslation> pvtq = productBs.GetPrintVersionTranslations(p.id);
            //PrintVersionTranslation pvt = (from w in pvtq where w.languageId == languageId select w).FirstOrDefault();

            //if (!String.IsNullOrEmpty(p.proprietor))
            //{
            //    sb.AppendFormat("{0}. ", p.proprietor);
            //}

            //sb.Append(GenerateAddressString(p));

            if (!String.IsNullOrEmpty(desc))
            {
                sb.AppendFormat(" {0}", desc);
            }

            //sb.Append(GeneratePaymentTypeString(productBs.GetProductPaymentTypes(p.id), languageId));

            //sb.Append(GenerateHoursString(p, languageId, et));

            //if (pvt != null && !String.IsNullOrEmpty(pvt.dateDescription))
            //{
            //    sb.AppendFormat(": {0}", pvt.dateDescription);
            //}
            //else
            //{
            //    sb.Append(".");
            //}

            return sb.ToString();
        }

        private string GenerateOutdoorListingBody(Product p, IQueryable<ProductAttribute> paq, string languageId, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            IQueryable<PrintVersionTranslation> pvtq = productBs.GetPrintVersionTranslations(p.id);
            PrintVersionTranslation pvt = (from w in pvtq where w.languageId == languageId select w).FirstOrDefault();

            if (!String.IsNullOrEmpty(p.proprietor))
            {
                sb.AppendFormat("{0}. ", (languageId == "en") ? p.proprietor : TranslateProprietor(p.proprietor));
            }

            sb.Append(GenerateAddressString(p));

            //if (!String.IsNullOrEmpty(pvt.directions))
            //{
            //    sb.AppendFormat(" {0}", pvt.directions);
            //}

            if (p.latitude.HasValue && p.longitude.HasValue && (from a in paq where a.attributeId == (short)PrintOption.PrintGps select a).Count() > 0)
            {
                sb.AppendFormat(" GPS {0}, {1}.", Math.Round(p.latitude.Value, 5), Math.Round(p.longitude.Value, 5));
            }

            if (pvt != null && !String.IsNullOrEmpty(pvt.printDescription))
            {
                sb.AppendFormat(" {0}", pvt.printDescription);
            }

           // sb.Append(GeneratePaymentTypeString(productBs.GetProductPaymentTypes(p.id), languageId));

            //HACK FOR supervised beaches
            if (p.primaryGuideSectionId == (int)GuideSectionOutdoors.Beaches)
            {
                sb.Append(languageId == "en"
                              ? GenerateHoursString(p, languageId, et).Replace("Open", "Supervised")
                              : GenerateHoursString(p, languageId, et).Replace("Ouvert", "Surveillée"));
            }
            else
            {
                sb.Append(GenerateHoursString(p, languageId, et));
            }

            if (pvt != null && !String.IsNullOrEmpty(pvt.dateDescription))
            {
                sb.AppendFormat(", {0}", pvt.dateDescription);
            }
            else
            {
                sb.Append(".");
            }

            //sb.Append(GenerateAdRefString(paq, languageId, et));

            return ApostrophizeSingleQuotes(sb.ToString().Trim());
        }

        private string GenerateTrailListingBody(Product p, IQueryable<ProductAttribute> paq, string languageId, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            IQueryable<PrintVersionTranslation> pvtq = productBs.GetPrintVersionTranslations(p.id);
            PrintVersionTranslation pvt = (from w in pvtq where w.languageId == languageId select w).FirstOrDefault();

            //if (!String.IsNullOrEmpty(p.proprietor))
            //{
            //    sb.AppendFormat("{0}. ", (languageId == "en") ? p.proprietor : TranslateProprietor(p.proprietor));
            //}

            sb.Append(GenerateAddressString(p));

            //if (!String.IsNullOrEmpty(pvt.directions))
            //{
            //    sb.AppendFormat(" {0}", pvt.directions);
            //}

            if (p.latitude.HasValue && p.longitude.HasValue && (from a in paq where a.attributeId == (short)PrintOption.PrintGps select a).Count() > 0)
            {
                sb.AppendFormat(" GPS {0}, {1}.", Math.Round(p.latitude.Value, 5), Math.Round(p.longitude.Value, 5));
            }

            if (pvt != null && !String.IsNullOrEmpty(pvt.printDescription))
            {
                sb.AppendFormat(" {0}", pvt.printDescription);
            }

            // sb.Append(GeneratePaymentTypeString(productBs.GetProductPaymentTypes(p.id), languageId));

            
            sb.Append(GenerateHoursString(p, languageId, et));
            
            if (pvt != null && !String.IsNullOrEmpty(pvt.dateDescription))
            {
                sb.AppendFormat(", {0}", pvt.dateDescription);
            }
            else
            {
                sb.Append(".");
            }

           // sb.Append(GenerateAdRefString(paq, languageId, et));

            return ApostrophizeSingleQuotes(sb.ToString().Trim());
        }

        private string GenerateTourOpListingBody(Product p, IQueryable<ProductAttribute> paq, string languageId, ExportType et)
        {   
            StringBuilder sb = new StringBuilder();

            IQueryable<PrintVersionTranslation> pvtq = productBs.GetPrintVersionTranslations(p.id);
            PrintVersionTranslation pvt = (from w in pvtq where w.languageId == languageId select w).FirstOrDefault();
             
            sb.Append(GenerateAddressString(p));

            if (p.latitude.HasValue && p.longitude.HasValue && (from a in paq where a.attributeId == (short)PrintOption.PrintGps select a).Count() > 0)
            {
                sb.AppendFormat(" GPS {0}, {1}.", Math.Round(p.latitude.Value, 5), Math.Round(p.longitude.Value, 5));
            }

            if (pvt != null && !String.IsNullOrEmpty(pvt.printDescription))
            {
                sb.AppendFormat(" {0}", pvt.printDescription);
            }

            sb.Append(GeneratePaymentTypeString(productBs.GetProductPaymentTypes(p.id), languageId));

            sb.Append(GenerateHoursString(p, languageId, et));

            if (pvt != null && !String.IsNullOrEmpty(pvt.dateDescription))
            {
                sb.AppendFormat(", {0}", pvt.dateDescription);
            }
            else
            {
                sb.Append(".");
            }

            sb.Append(GenerateAdRefString(paq, languageId, et," "));

            return ApostrophizeSingleQuotes(sb.ToString().Trim());
        }

        private string GenerateCrossReferenceListingBody(Product p, ProductDescription pd, string primaryGuideSection, string languageId, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(GenerateAddressString(p));


            if (pd == null || String.IsNullOrEmpty(pd.description))
            {
                sb.AppendFormat(" {0} {1}.", languageId == "en" ? "See listing under" : "Voir la rubrique", primaryGuideSection);
                sb.AppendFormat("{0}.", GenerateHoursString(p, languageId, et));
            }
            else
            {
                sb.AppendFormat(" {0}", pd.description);
                sb.AppendFormat(" {0} {1}.", languageId == "en" ? "See listing under" : "Voir la rubrique", primaryGuideSection);
            }

            return ApostrophizeSingleQuotes(sb.ToString().Trim());
        }


        private string GenerateRestaurantListingBody(Product p, IQueryable<ProductAttribute> paq, string languageId, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            IQueryable<PrintVersionTranslation> pvtq = productBs.GetPrintVersionTranslations(p.id);
            PrintVersionTranslation pvt = (from w in pvtq where w.languageId == languageId select w).FirstOrDefault();

            sb.Append(GenerateRestaurantAddressString(p));

            if ((from pa in paq where pa.attributeId == ((int)RestaurantService.BusToursWelcome) select pa).Count() > 0)
            {
                sb.Append((languageId == "fr") ? " Bus tours welcome." : " Bus tours welcome.");
            }

            //sb.Append(GenerateRestaurantTypeString(paq, languageId));

            //sb.Append(GenerateRestaurantSpecialtyString(paq, languageId));

            //sb.Append(GeneratePaymentTypeString(productBs.GetProductPaymentTypes(p.id), languageId));

            //sb.Append(GenerateRestaurantSeatingString(p, languageId));

            //sb.Append(GenerateRestaurantServiceString(paq, languageId));

            sb.Append(GenerateHoursString(p, languageId, et));

            if (pvt != null && !String.IsNullOrEmpty(pvt.dateDescription))
            {
                sb.AppendFormat(", {0}", pvt.dateDescription);
            }
            else
            {
                sb.Append(".");
            }

            //sb.Append(GenerateAdRefString(paq, languageId, et, ""));

            return ApostrophizeSingleQuotes(sb.ToString().Trim());
        }
        

        public string ExportCampgrounds(Region r, string languageId)
        {
            IQueryable<Product> pq = productBs.GetProductsForPrintExport(ProductType.Campground, r);

            StringBuilder sb = new StringBuilder();

            short lastCommunityId = -1;
            
            foreach (Product p in pq)
            {
                IQueryable<ProductAttribute> paq = productBs.GetProductAttributes(p.id);

                var communityCells = new string[3] { "", "", "" };

                if (p.communityId != lastCommunityId)
                {
                    lastCommunityId = p.communityId.Value;
                    sb.Append(ListingHeadTabV3);
                    
                    communityCells = SplitCommunityName(p.refCommunity.communityName);
                    sb.AppendFormat(communityCells[0]);
                }
                else
                {
                    sb.Append(ListingHeadV3);
                }

                sb.AppendFormat(ListingHeadName, ApostrophizeSingleQuotes((languageId == "en") ? p.productName : TranslateProductName(p.productName)));

                sb.AppendFormat("{0} ", ListingHeadSymbols);

                sb.Append(GenerateAccommodationSymbolString(p, paq, productBs.GetProductCaaRatings(p.id), productBs.GetProductCanadaSelectRatings(p.id), ExportType.Print, languageId));

                sb.Append("\t");

                sb.Append(GenerateCampgroundGrid(p, paq, languageId, ExportType.Print));

                sb.Append(Eol);

                string contactString = GenerateContactString(p, ExportType.Print, languageId);

                //if (!String.IsNullOrEmpty(contactString))
                //{
                //    sb.AppendFormat("{0}{1}{2}", ContactHeadV3, (communityCells[1].Length > 0) ? communityCells[1] : "\t", contactString);
                //}

                sb.AppendFormat("{0}{1}{2}", ContactHeadV3, (communityCells[1].Length > 0) ? communityCells[1] : "\t", contactString);

                sb.Append(GenerateCampgroundGridLine2(p, paq, languageId, ExportType.Print));

                sb.Append(Eol);

                sb.Append(MainListingHeadV3);

                sb.Append(communityCells[2]);

                sb.Append(GenerateAccommodationListingBody(p, paq, languageId, ExportType.Print));

                sb.Append(Eol);
            }

            return sb.ToString();
        }

        public string ExportAttractions(Region r, string languageId)
        {
            IQueryable<Product> pq = productBs.GetProductsForPrintExport(ProductType.Attraction, r);

            StringBuilder sb = new StringBuilder();

            short lastCommunityId = -1;

            foreach (Product p in pq)
            {
                IQueryable<ProductAttribute> paq = productBs.GetProductAttributes(p.id);

                var communityCells = new string[3] { "", "", "" };
      
                if (p.communityId != lastCommunityId)
                {
                    lastCommunityId = p.communityId.Value;
                    sb.Append(ListingHeadTabV2);

                    //sb.AppendFormat(CoordinateHead, p.refCommunity.communityName);
                    communityCells = SplitCommunityName(p.refCommunity.communityName);

                    sb.AppendFormat(communityCells[0]);
                }
                else
                {
                    sb.Append(ListingHeadV2);
                }

                sb.AppendFormat(ListingHeadNameV2, ApostrophizeSingleQuotes((languageId == "en") ? p.productName : TranslateProductName(p.productName)));

                sb.Append("\t");
                
                sb.AppendFormat("{0} ", ListingHeadSymbols);

                sb.Append(GenerateAttractionSymbolString(p, paq, ExportType.Print));

                sb.Append("\t");

                sb.AppendFormat(GenerateAttractionGrid(p, paq, languageId, ExportType.Print));

                //sb.Append(SectionBreak);

                sb.Append(Eol);

                string contactString = GenerateContactString(p, ExportType.Print, languageId);
                
                //if (!String.IsNullOrEmpty(contactString))
                //{
                //    sb.AppendFormat("{0}{1}{2}", ContactHeadV2, (communityCells[1].Length > 0) ? communityCells[1] : "\t", contactString);
                //}

                sb.AppendFormat("{0}{1}{2}", ContactHeadV2, (communityCells[1].Length > 0) ? communityCells[1] : "\t", contactString);

                sb.AppendFormat("\t\t\t{0}{1}", String.Format(GridText, GenerateAdRefString(paq, languageId, ExportType.Print,"")), Eol);
                
                sb.Append(MainListingHeadV2);

                sb.Append(communityCells[2]);

                sb.Append(GenerateAttractionListingBody(p, paq, languageId, ExportType.Print));

                sb.Append(Eol);
            }

            return sb.ToString();
        }

        public string ExportFineArts(Region r, string languageId)
        {
            IQueryable<Product> pq = productBs.GetProductsForPrintExport(ProductType.FineArts, r);

            StringBuilder sb = new StringBuilder();

            short lastCommunityId = -1;

            foreach (Product p in pq)
            {
                IQueryable<ProductAttribute> paq = productBs.GetProductAttributes(p.id);

                var communityCells = new string[3] { "", "", "" };

                if (p.communityId != lastCommunityId)
                {
                    lastCommunityId = p.communityId.Value;
                    sb.Append(ListingHeadTabV2);

                    communityCells = SplitCommunityName(p.refCommunity.communityName);
                    sb.AppendFormat(communityCells[0]);
                }
                else
                {
                    sb.Append(ListingHeadV2);
                }

                sb.AppendFormat(ListingHeadNameV2, ApostrophizeSingleQuotes((languageId == "en") ? p.productName : TranslateProductName(p.productName)));

                if (!String.IsNullOrEmpty(p.proprietor))
                {
                    sb.AppendFormat(" {0} {1}{2}", ListingHeadBullet, ListingHeadItalics, p.proprietor);
                }

                sb.AppendFormat("{0} ", ListingHeadSymbols);

                sb.Append(GenerateFineArtsSymbolString(p, paq, ExportType.Print));

                sb.Append("\t");

                string exhibitTypeString = GetExhibitTypeLabel(paq, languageId);
                string fineArtsMediaString = GenerateFineArtsMediaString(paq, languageId, ExportType.Print);

                if (!String.IsNullOrEmpty(exhibitTypeString))
                {
                    //sb.AppendFormat("{0}{1}{2}", ContactHead, categoryString, Eol);
                    sb.AppendFormat("{0}{1}", FineArtsMediaTag, exhibitTypeString);
                }

                if ((!String.IsNullOrEmpty(exhibitTypeString)) && (!String.IsNullOrEmpty(fineArtsMediaString)))
                {
                    sb.AppendFormat(Bullet);
                }

                sb.Append(fineArtsMediaString);

                sb.Append("\t");

                sb.Append(GenerateFineArtsGrid(p, paq, languageId, ExportType.Print));

                sb.Append(Eol);

                string contactString = GenerateContactString(p, ExportType.Print, languageId);

                //if (!String.IsNullOrEmpty(contactString))
                //{
                //    sb.AppendFormat("{0}{1}{2}", ContactHeadV2, (communityCells[1].Length > 0) ? communityCells[1] : "\t", contactString);
                //}

                sb.AppendFormat("{0}{1}{2}", ContactHeadV2, (communityCells[1].Length > 0) ? communityCells[1] : "\t", contactString);

                sb.AppendFormat("\t\t\t{0}{1}", String.Format(GridText, GenerateAdRefString(paq, languageId, ExportType.Print, "")), Eol);

                sb.Append(MainListingHeadV2);

                sb.Append(communityCells[2]);

                sb.Append(GenerateFineArtsListingBody(p, paq, languageId, ExportType.Print));

                sb.Append(Eol);
            }

            return sb.ToString();
        }

        public string ExportOutdoors(Region r, string languageId)
        {
            List<ProductBs.OutdoorExportVo> oevl = productBs.GetOutdoorsProductsForPrintExport(ProductType.Outdoors, r);

            StringBuilder sb = new StringBuilder();

            short lastCommunityId = -1;

            foreach (ProductBs.OutdoorExportVo oev in oevl)
            {
                Product p = productBs.GetProduct(oev.productId);
                IQueryable<ProductAttribute> paq = productBs.GetProductAttributes(oev.productId);

                var communityCells = new string[3] { "", "", "" };
                //symbolString = GenerateAccommodationSymbolString(p, productBs.GetProductAttributes(p.id), productBs.GetProductCaaRatings(p.id), productBs.GetProductCanadaSelectRatings(p.id)) ;)))
                if (p.communityId != null && p.communityId != lastCommunityId)
                {
                    lastCommunityId = p.communityId.Value;
                    sb.Append(ListingHeadTabV2);

                    communityCells = SplitCommunityName(p.refCommunity.communityName);

                    //sb.AppendFormat(CoordinateHead, p.refCommunity.communityName);
                    sb.AppendFormat(communityCells[0]);
                }
                else
                {
                    sb.Append(ListingHeadV2);
                }

                sb.AppendFormat(ListingHeadNameV2, ApostrophizeSingleQuotes((languageId == "en") ? p.productName : TranslateProductName(p.productName)));

                //if (!String.IsNullOrEmpty(p.proprietor))
                //{
                //    sb.AppendFormat(" {0} {1}{2}", ListingHeadBullet, ListingHeadItalics, p.proprietor);
                //}

                sb.AppendFormat("{0} ", ListingHeadSymbols);

                sb.Append(GenerateOutdoorSymbolString(p, paq, ExportType.Print));

                sb.Append("\t");

                //string fineArtsMediaString = GenerateFineArtsMediaString(paq, languageId, ExportType.Print);
               //string outdoorsCategoryString = GetOutdoorsGuideSectionTitle((GuideSectionOutdoors)oev.guideSectionId.Value, languageId);

                if (oev.guideSectionId.HasValue)
                {
                    sb.Append(GenerateOutdoorsCategoryString(oev.guideSectionId.Value, languageId));
                }

                sb.Append("\t");

                sb.Append(GenerateOutdoorsGrid(p, paq, languageId, ExportType.Print));

                sb.Append(Eol);

                string contactString = GenerateContactString(p, ExportType.Print, languageId);

                //if (!String.IsNullOrEmpty(contactString))
                //{
                //    //sb.AppendFormat("{0}{1}{2}", ContactHead, contactString, Eol);
                //    sb.AppendFormat("{0}{1}{2}", ContactHeadV2, (communityCells[1].Length > 0) ? communityCells[1] : "\t", contactString);
                //}

                sb.AppendFormat("{0}{1}{2}", ContactHeadV2, (communityCells[1].Length > 0) ? communityCells[1] : "\t", contactString);

                sb.AppendFormat("\t\t\t{0}{1}", String.Format(GridText, GenerateAdRefString(paq, languageId, ExportType.Print, "")), Eol);

                sb.Append(MainListingHeadV2);

                sb.Append(communityCells[2]);

                sb.Append(oev.isCrossReference
                              ? GenerateOutdoorCrossReferenceListingBody(p, paq, languageId, ExportType.Print,
                                                                         oev.guideSectionId)
                              : GenerateOutdoorListingBody(p, paq, languageId, ExportType.Print));


                sb.Append(Eol);
            }

            return sb.ToString();
        }

        public string ExportTrails(Region r, string languageId)
        {
            IQueryable<Product> pq = productBs.GetProductsForPrintExport(ProductType.Trails, r);

            StringBuilder sb = new StringBuilder();

            short lastCommunityId = -1;

            foreach (Product p in pq)
            {
                IQueryable<ProductAttribute> paq = productBs.GetProductAttributes(p.id);

                var communityCells = new string[3] { "", "", "" };
                
                if (p.communityId != null && p.communityId != lastCommunityId)
                {
                    lastCommunityId = p.communityId.Value;
                    sb.Append(ListingHeadTabV5);

                    communityCells = SplitCommunityName(p.refCommunity.communityName);

                    sb.AppendFormat(communityCells[0]);
                }
                else
                {
                    sb.Append(ListingHeadV4);
                }

                sb.AppendFormat(ListingHeadNameV2, ApostrophizeSingleQuotes((languageId == "en") ? p.productName : TranslateProductName(p.productName)));

                //sb.AppendFormat("{0} ", ListingHeadSymbols);

                //sb.Append(GenerateTrailSymbolString(p, paq, ExportType.Print));

                sb.Append("\t");

                //string fineArtsMediaString = GenerateFineArtsMediaString(paq, languageId, ExportType.Print);
                //string outdoorsCategoryString = GetOutdoorsGuideSectionTitle((GuideSectionOutdoors)oev.guideSectionId.Value, languageId);

                var trailSymbolString = GenerateTrailSymbolString(p, paq, ExportType.Print);

                if (trailSymbolString.Length > 0)
                {
                    sb.AppendFormat("{0}{1}:{2} {3}{4}", FineArtsMediaTag, (languageId == "fr") ? "Trail Uses" : "Trail Uses", ListingHeadSymbols, trailSymbolString, SectionBreak);    
                }
                
                sb.Append("\t");

                sb.Append(GenerateTrailGrid(p, paq, languageId, ExportType.Print));

                sb.Append(Eol);

                string contactString = GenerateContactString(p, ExportType.Print, languageId);

                //if (!String.IsNullOrEmpty(contactString) || communityCells[1].Length > 0)
                //{
                //    sb.AppendFormat("{0}{1}{2}", ContactHeadV2, (communityCells[1].Length > 0) ? communityCells[1] : "\t", contactString);
                //}

                sb.AppendFormat("{0}{1}{2}", ContactHeadV2, (communityCells[1].Length > 0) ? communityCells[1] : "\t", contactString);

                sb.AppendFormat("\t\t\t{0}{1}", String.Format(GridText, GenerateAdRefString(paq, languageId, ExportType.Print, "")), Eol);

                sb.Append(MainListingHeadV5);

                sb.Append(communityCells[2]);

                sb.Append(GenerateTrailListingBody(p, paq, languageId, ExportType.Print));

                sb.Append(Eol);
            }

            return sb.ToString();
        }


        private string GenerateOutdoorsCategoryString (int guideSectionId, string languageId)
        {
            var gs = GetOutdoorsGuideSectionTitle((GuideSectionOutdoors)guideSectionId, languageId);

            return String.Format("{0}{1}:{2} {3}{4}",FineArtsMediaTag ,(languageId == "fr") ? "Category" : "Category", FineArtsMediaRomanTag, gs, SectionBreak);
            
        }

        public string ExportRestaurants(Region r, string languageId)
        {
             IQueryable<Product> pq = productBs.GetProductsForPrintExport(ProductType.Restaurants, r);

            StringBuilder sb = new StringBuilder();

            short lastCommunityId = -1;

            foreach (Product p in pq)
            {
                IQueryable<ProductAttribute> paq = productBs.GetProductAttributes(p.id);

                var communityCells = new string[3] { "", "", "" };

                if (p.communityId != lastCommunityId)
                {
                    lastCommunityId = p.communityId.Value;
                    sb.Append(ListingHeadNameV3);

                    communityCells = SplitCommunityName(p.refCommunity.communityName);
                    sb.AppendFormat(communityCells[0]);
                }
                else
                {
                    sb.Append(ListingHeadTabV4);
                }

                sb.AppendFormat(ListingHeadName, ApostrophizeSingleQuotes((languageId == "en") ? p.productName : TranslateProductName(p.productName)));

                string restaurantTypeString = GenerateRestaurantTypeString(paq, languageId, ExportType.Print);
                string restaurantSpecialtyString = GenerateRestaurantSpecialtyString(paq, languageId, ExportType.Print);

                if (!String.IsNullOrEmpty(restaurantTypeString))
                {
                    sb.Append(restaurantTypeString);
                }

                if ((!String.IsNullOrEmpty(restaurantTypeString)) && (!String.IsNullOrEmpty(restaurantSpecialtyString)))
                {
                    sb.AppendFormat(Bullet);
                }

                sb.Append(restaurantSpecialtyString);

                sb.Append("\t");

                sb.Append(GenerateRestaurantGrid(p, paq, languageId, ExportType.Print));

                sb.Append(Eol);

                string contactString = GenerateContactString(p, ExportType.Print, languageId);

                //if (!String.IsNullOrEmpty(contactString))
                //{
                //    sb.AppendFormat("{0}{1}{2}", ContactHeadV4, (communityCells[1].Length > 0) ? communityCells[1] : "\t", contactString);
                //}

                sb.AppendFormat("{0}{1}{2}", ContactHeadV4, (communityCells[1].Length > 0) ? communityCells[1] : "\t", contactString);

                sb.Append("\t");

                sb.AppendFormat("{0} {1}",ListingHeadSymbols, GenerateRestaurantSymbolString(p, paq, ExportType.Print));

                sb.AppendFormat("\t\t\t\t{0}{1}", String.Format(GridText, GenerateAdRefString(paq, languageId, ExportType.Print, "  ")), Eol);

                sb.Append(MainListingHeadV4);

                sb.Append(communityCells[2]);

                sb.Append(GenerateRestaurantListingBody(p, paq, languageId, ExportType.Print));

                sb.Append(Eol);
            }

            return sb.ToString();
        }

        public string ExportTourOps(string languageId)
        {
            List<ProductBs.OutdoorExportVo> oevl = productBs.GetOutdoorsProductsForPrintExport(ProductType.TourOps, null);

            StringBuilder sb = new StringBuilder();

            byte lastPrimaryGuideSectionId = 0;

            //foreach (Product p in pq)
            foreach (ProductBs.OutdoorExportVo oev in oevl)
            {
                Product p = productBs.GetProduct(oev.productId);
                IQueryable<ProductAttribute> paq = productBs.GetProductAttributes(p.id);
                IQueryable<ProductRegionOfOperation> prooq = productBs.GetProductRegionsOfOperation(p.id);

                //if (p.primaryGuideSectionId != lastPrimaryGuideSectionId)
                if ((!oev.isCrossReference && p.primaryGuideSectionId != lastPrimaryGuideSectionId) || (oev.isCrossReference && oev.guideSectionId != lastPrimaryGuideSectionId))
                {
                    byte? guideSectionId = (oev.isCrossReference) ? oev.guideSectionId : p.primaryGuideSectionId;
                    lastPrimaryGuideSectionId = guideSectionId.Value;
                    sb.AppendFormat("{0}{1}", GetTourOpGuideSectionTitle((GuideSectionTourOps)guideSectionId, languageId), Eol);
                }

                sb.AppendFormat("{0}{1}", ListingHead, ApostrophizeSingleQuotes((languageId == "en") ? p.productName : TranslateProductName(p.productName)));

                sb.Append("\t");

                sb.AppendFormat("{0} ", ListingHeadSymbols);

                sb.Append(GenerateOutdoorSymbolString(p, paq, ExportType.Print));

                sb.Append(SectionBreak);

                sb.Append(GenerateRegionDotString(p, prooq));
                
                sb.Append(Eol);

                string contactString = GenerateContactString(p, ExportType.Print, languageId);

                if (!String.IsNullOrEmpty(contactString))
                {
                    sb.AppendFormat("{0}{1}{2}", ContactHead, contactString, Eol);
                }

                sb.Append(MainListingHead);

                string listingBody;

                if (oev.isCrossReference)
                {
                    ProductDescription xrefDesc = productBs.GetProductDescription(oev.productId, oev.guideSectionId.Value, languageId);
                    string pgs = (p.primaryGuideSectionId < 50) ? GetOutdoorsGuideSectionTitle((GuideSectionOutdoors)p.primaryGuideSectionId, languageId) : GetTourOpGuideSectionTitle((GuideSectionTourOps)p.primaryGuideSectionId, languageId);
                    listingBody = GenerateCrossReferenceListingBody(p, xrefDesc, pgs, languageId, ExportType.Print);
                }
                else
                {
                    listingBody = GenerateTourOpListingBody(p, paq, languageId, ExportType.Print);
                }

                //sb.Append(GenerateTourOpListingBody(p, paq, languageId, ExportType.Print));
                sb.Append(listingBody);
                //GenerateCancellationString
                sb.Append(Eol);
            }

            return sb.ToString();
        }

        private string GenerateRestaurantSeatingString(Product p, string languageId)
        {
            StringBuilder sb = new StringBuilder();

            if (languageId == "en")
            {
                if (p.seatingCapacityInterior > 0 && p.seatingCapacityExterior > 0)
                {
                    sb.AppendFormat(" Seats {0} (int), {1} (ext).", p.seatingCapacityInterior, p.seatingCapacityExterior);
                }
                else if (p.seatingCapacityInterior > 0 || p.seatingCapacityExterior > 0)
                {
                    sb.AppendFormat(" Seats {0}.", (p.seatingCapacityInterior > 0) ? p.seatingCapacityInterior : p.seatingCapacityExterior);
                }
                else
                {
                    return "";
                }
            }
            else
            {
                if (p.seatingCapacityInterior > 0 && p.seatingCapacityExterior > 0)
                {
                    sb.AppendFormat(" {0} places (int), {1} (ext).", p.seatingCapacityInterior, p.seatingCapacityExterior);
                }
                else if (p.seatingCapacityInterior > 0 || p.seatingCapacityExterior > 0)
                {
                    sb.AppendFormat(" {0} places.", (p.seatingCapacityInterior > 0) ? p.seatingCapacityInterior : p.seatingCapacityExterior);
                }
                else
                {
                    return "";
                }
            }

            return sb.ToString();
        }

        private string GenerateRegionDotString(Product p, IQueryable<ProductRegionOfOperation> prooq)
        {
            StringBuilder sb = new StringBuilder();

            string halifaxDot = ((from a in prooq where a.regionId == (short)Region.HalifaxMetro select a).Count() > 0) || (p.communityId != null && p.refCommunity.regionId == (short)Region.HalifaxMetro) ? "•" : "";
            string southShoreDot = ((from a in prooq where a.regionId == (short)Region.SouthShore select a).Count() > 0) || (p.communityId != null && p.refCommunity.regionId == (short)Region.SouthShore) ? "•" : "";
            string yarmouthDot = ((from a in prooq where a.regionId == (short)Region.Yarmouth select a).Count() > 0) || (p.communityId != null && p.refCommunity.regionId == (short)Region.Yarmouth) ? "•" : "";
            string fundyDot = ((from a in prooq where a.regionId == (short)Region.FundyShore select a).Count() > 0) || (p.communityId != null && p.refCommunity.regionId == (short)Region.FundyShore) ? "•" : "";
            string northumberlandDot = ((from a in prooq where a.regionId == (short)Region.Northumberland select a).Count() > 0) || (p.communityId != null && p.refCommunity.regionId == (short)Region.Northumberland) ? "•" : "";
            string capeBretonDot = ((from a in prooq where a.regionId == (short)Region.BrasDor || a.regionId == (short)Region.CabotTrail || a.regionId == (short)Region.CeilidhTrail || a.regionId == (short)Region.FleurDeLis select a).Count() > 0) || (p.communityId != null && (p.refCommunity.regionId == (short)Region.BrasDor || p.refCommunity.regionId == (short)Region.CabotTrail || p.refCommunity.regionId == (short)Region.CeilidhTrail || p.refCommunity.regionId == (short)Region.FleurDeLis)) ? "•" : "";
            string easternShoreDot = ((from a in prooq where a.regionId == (short)Region.EasternShore select a).Count() > 0) || (p.communityId != null && p.refCommunity.regionId == (short)Region.EasternShore) ? "•" : "";

            return sb.AppendFormat("{0}\t{1}\t{2}\t{3}\t{4}\t{5}\t{6}\t{7}", RegionDotHead, halifaxDot, southShoreDot, yarmouthDot, fundyDot, northumberlandDot, capeBretonDot, easternShoreDot).ToString();
        }

        private string GenerateHoursString(Product p, string languageId, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            switch ((PeriodOfOperationType)p.PrintVersion.periodOfOperationTypeId)
            {
                case PeriodOfOperationType.AllYear:
                    sb.Append((languageId == "en") ? "Year-round" : "Toute l’année");
                    break;
                case PeriodOfOperationType.Seasonal:
                    sb.Append((languageId == "en") ? "Seasonal" : "En saison");
                    break;
                case PeriodOfOperationType.DateRange:
                    if (p.PrintVersion.openMonth != null && p.PrintVersion.closeMonth != null)
                    {
                        if (p.PrintVersion.openDay != null && p.PrintVersion.closeDay != null)
                        {
                            if (languageId == "en")
                            {
                                sb.AppendFormat("{0} {1}–{2} {3}", GetAbbreviatedMonthName((int)p.PrintVersion.openMonth, languageId), p.PrintVersion.openDay, GetAbbreviatedMonthName((int)p.PrintVersion.closeMonth, languageId), p.PrintVersion.closeDay);    
                            }
                            else
                            {
                                sb.AppendFormat("{0} {1} au {2} {3}", (p.PrintVersion.openDay == 1) ? ((et == ExportType.Html) ? "1<sup>er</sup>" : "1<+>er<$>") : p.PrintVersion.openDay.Value.ToString(), GetAbbreviatedMonthName((int)p.PrintVersion.openMonth, languageId), (p.PrintVersion.closeDay == 1) ? ((et == ExportType.Html) ? "1<sup>er</sup>" : "1<+>er<$>") : p.PrintVersion.closeDay.Value.ToString(), GetAbbreviatedMonthName((int)p.PrintVersion.closeMonth, languageId));
                            }
                        }
                        else
                        {
                            sb.AppendFormat(languageId == "en" ? "{0}-{1}" : "{0} au {1}",
                                            GetAbbreviatedMonthName((int) p.PrintVersion.openMonth, languageId),
                                            GetAbbreviatedMonthName((int) p.PrintVersion.closeMonth, languageId));
                        }
                    }
                    else
                    {
                        sb.Append("");
                    }
                    break;
                    
                default:
                    break;
            }
            
            return (et == ExportType.Print) ? String.Format(" {0}{1}{2}", ListingBold, sb.ToString(), SectionBreak) : String.Format(" <b>{0}</b>", sb.ToString());
        }

        //private string GenerateAccommodationRateString(Product p, string languageId, string rateDescription)
        //{
        //    StringBuilder sb = new StringBuilder();

        //    sb.Append(" Rates");

        //    if (p.rateTypeId != null)
        //    {
        //        sb.AppendFormat(" {0}", GetRateTypeAbbreviation((RateType)p.rateTypeId, languageId));
        //    }

        //    if (p.noTax)
        //    {
        //        sb.AppendFormat(" {0}", (languageId == "fr") ? "(tarifs sans)" : "(no tax)");
        //    }

        //    if (p.lowRate != null && p.highRate != null && p.lowRate != p.highRate)
        //    {
        //        sb.AppendFormat(languageId == "fr" ? " {0}-{1}$" : " ${0}-{1}", p.lowRate, p.highRate);
        //    }
        //    else if (p.lowRate != null || p.highRate != null)
        //    {
        //        sb.AppendFormat(languageId == "fr" ? " {0}$" : " ${0}", p.highRate ?? p.lowRate);
        //    }

        //    if (p.ratePeriodId != null)
        //    {
        //        sb.AppendFormat(" {0}", GetRatePeriodAbbreviation((RatePeriod)p.ratePeriodId));
        //    }

        //    if (!String.IsNullOrEmpty(rateDescription))
        //    {
        //        sb.AppendFormat(", {0}", rateDescription);
        //    }

        //    if (p.cancellationPolicyId != null)
        //    {
        //        sb.AppendFormat("; {0}", GetCancellationPolicyAbbreviation((CancellationPolicy)p.cancellationPolicyId));
        //    }

        //    if (p.hasOffSeasonRates)
        //    {
        //        sb.AppendFormat("; {0}", "O/S rates");
        //    }

        //    sb.Append(".");

        //    return sb.ToString();
        //}

        private string GetAbbreviatedMonthName (int month, string languageId)
        {
            switch (month)
            {
                case 1:
                    return (languageId == "en") ? "Jan" : "jan";
                case 2:
                    return (languageId == "en") ? "Feb" : "fév";
                case 3:
                    return (languageId == "en") ? "Mar" : "mars";
                case 4:
                    return (languageId == "en") ? "Apr" : "avr";
                case 5:
                    return (languageId == "en") ? "May" : "mai";
                case 6:
                    return (languageId == "en") ? "Jun" : "juin";
                case 7:
                    return (languageId == "en") ? "Jul" : "juil";
                case 8:
                    return (languageId == "en") ? "Aug" : "août";
                case 9:
                    return (languageId == "en") ? "Sep" : "sep";
                case 10:
                    return (languageId == "en") ? "Oct" : "oct";
                case 11:
                    return (languageId == "en") ? "Nov" : "nov";
                case 12:
                    return (languageId == "en") ? "Dec" : "déc";
                default:
                    return "";
            }
            
        }

        private string GenerateAbbrRateString(Product p, string languageId, string rateDescription)
        {
            StringBuilder sb = new StringBuilder();

            sb.Append((languageId == "fr") ? " Tarifs" : " Rates");

            if (p.PrintVersion.rateTypeId != null)
            {
                sb.AppendFormat(" {0}", GetRateTypeAbbreviation((RateType)p.PrintVersion.rateTypeId, languageId));
            }

            if (!String.IsNullOrEmpty(rateDescription))
            {
                sb.AppendFormat("; {0}", rateDescription);
            }

            if (p.PrintVersion.hasOffSeasonRates)
            {
                sb.AppendFormat("{0} {1}", sb.ToString().Substring(sb.Length - 1) != "." ? ";" : "", (languageId == "fr") ? "tarifs HS" : "O/S rates");
            }

            if (p.productTypeId == (int)ProductType.Campground)
            {
                if (p.PrintVersion.cancellationPolicyId != null)
                {
                    sb.AppendFormat("{0} {1}", sb.ToString().Substring(sb.Length - 1) != "." ? ";" : "", GetCancellationPolicyAbbreviation((CancellationPolicy)p.PrintVersion.cancellationPolicyId, languageId));
                }
            }

            if (sb.ToString().Substring(sb.Length - 1) != ".")
            {
                sb.Append(".");
            }

            return sb.ToString();
        }

        private string GenerateRateString(Product p, string languageId, string rateDescription)
        {
            StringBuilder sb = new StringBuilder();

            sb.Append((languageId == "fr") ? " Tarifs" : " Rates");

            if (p.PrintVersion.rateTypeId != null)
            {
                sb.AppendFormat(" {0}", GetRateTypeAbbreviation((RateType)p.PrintVersion.rateTypeId, languageId));
            }

            if (p.PrintVersion.noTax)
            {
                sb.AppendFormat(" {0}", (languageId == "fr") ? "(sans taxes)" : "(no tax)");
            }

            if (p.PrintVersion.lowRate != null && p.PrintVersion.highRate != null && p.PrintVersion.lowRate != p.PrintVersion.highRate)
            {
                sb.AppendFormat(languageId == "fr" ? " {0}–{1}$" : " ${0}–{1}", Math.Round(p.PrintVersion.lowRate.Value), Math.Round(p.PrintVersion.highRate.Value));
            }
            else if (p.PrintVersion.lowRate != null || p.PrintVersion.highRate != null)
            {
                sb.AppendFormat(languageId == "fr" ? " {0}$" : " ${0}", (p.PrintVersion.lowRate != null) ? Math.Round(p.PrintVersion.lowRate.Value) : Math.Round(p.PrintVersion.highRate.Value));
            }

            if (p.PrintVersion.ratePeriodId != null && p.PrintVersion.ratePeriodId != (int)RatePeriod.Daily)
            {
                sb.AppendFormat("{0}", GetRatePeriodAbbreviation((RatePeriod)p.PrintVersion.ratePeriodId, languageId));
            }

            if (p.PrintVersion.extraPersonRate != null)
            {
                sb.AppendFormat(languageId == "fr" ? ", ADD {0}$" : ", XP ${0}", Math.Round(p.PrintVersion.extraPersonRate.Value));
            }

            if (!String.IsNullOrEmpty(rateDescription))
            {
                sb.AppendFormat("; {0}", rateDescription);
            }

            if (p.PrintVersion.cancellationPolicyId != null)
            {
                sb.AppendFormat("{0} {1}", sb.ToString().Substring(sb.Length - 1) != "." ? ";" : "", GetCancellationPolicyAbbreviation((CancellationPolicy)p.PrintVersion.cancellationPolicyId, languageId));
            }

            if (p.PrintVersion.hasOffSeasonRates)
            {
                sb.AppendFormat("{0} {1}", sb.ToString().Substring(sb.Length - 1) != "." ? ";" : "", (languageId == "fr") ? "tarifs HS" : "O/S rates");
            }

            if  (sb.ToString().Substring(sb.Length - 1) != ".")
            {
                sb.Append(".");    
            }

            return sb.ToString();
        }


        private string GenerateAccommodationTypeHeader(IQueryable<ProductAttribute> paq, ExportType et, string languageId)
        {
            StringBuilder sb = new StringBuilder();

            var q = from a in paq where a.attributeGroupId == (short)AttributeGroup.AccommodationType select a;

            foreach (var x in q)
            {
                sb.AppendFormat(", {0}", GetAccommodationTypeAbbreviation((AccommodationType)x.attributeId, languageId));
            }
            
            //return (sb.Length > 0) ? sb.ToString().Substring(2) : "";
            if (sb.Length > 0)
            {
                return (et == ExportType.Print)
                           ? String.Format(" {0}{1}:{2}", ListingBold, sb.ToString().Substring(2), SectionBreak)
                           : String.Format("<b> {0}:</b>", sb.ToString().Substring(2)); 
                           //: String.Format("<span class='accommodationType'> {0}:</span>", sb.ToString().Substring(2)); 
            }
            else
            {
                return "";    
            }
            
        }

        private string GenerateRestaurantServiceString(IQueryable<ProductAttribute> paq, string languageId)
        {
            StringBuilder sb = new StringBuilder();

            if ((from a in paq where a.attributeId == (short)RestaurantService.BusToursWelcome select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "B" : "B");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantService.ChildrensMenu select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "ME" : "CM");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantService.Delivery select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "LIV" : "DEL");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantService.DiningRoom select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "SM" : "DR");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantService.Licensed select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "PA" : "L");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantService.LiveEntertainment select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "Spec" : "LE");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantService.Patio select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "Terr" : "Pa");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantService.ReservationsAccepted select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "RR" : "RR");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantService.SmokingArea select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "SF" : "SA");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantService.Takeout select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "EMP" : "TO");
            }

            return (sb.Length > 0) ? String.Format(" {0}.", sb.ToString().Substring(2)) : "";
        }
        private string GenerateAttractionCodeString(IQueryable<ProductAttribute> paq, string parkingNumber, string languageId)
        {
            StringBuilder sb = new StringBuilder();

            if ((from a in paq where a.attributeId == (short)Feature.GiftShop select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId=="en") ? "G" : "BC");
            }

            if ((from a in paq where a.attributeId == (short)Feature.BusTours select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId=="en") ? "B" : "B");
            }

            if ((from a in paq where a.attributeId == (short)Feature.PicnicTables select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId=="en") ? "Pic" : "P-N");
            }

            if ((from a in paq where a.attributeId == (short)Feature.Parking select a).Count() > 0)
            {
                sb.AppendFormat(", {0}{1}", (languageId=="en") ? "P" : "S", parkingNumber);
            }

            if ((from a in paq where a.attributeId == (short)Feature.Restaurant select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId=="en") ? "R" : "R");
            }

            if ((from a in paq where a.attributeId == (short)Feature.TeaRoom select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId=="en") ? "TR" : "ST");
            }

            if ((from a in paq where a.attributeId == (short)Feature.Takeout select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "en") ? "TO" : "EMP");
            }

            return (sb.Length > 0) ? String.Format(" {0}.", sb.ToString().Substring(2)) : "";
        }

        private string GenerateMembershipString(IQueryable<ProductAttribute> paq, string otherMemberships, string languageId)
        {
            StringBuilder sb = new StringBuilder();

            if ((from a in paq where a.attributeId == (short)Membership.Igns select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", "IGNS");
            }

            if ((from a in paq where a.attributeId == (short)Membership.Nsbba select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", "NSBBA");
            }

            if ((from a in paq where a.attributeId == (short)Membership.Tians select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", "TIANS");
            }

            if ((from a in paq where a.attributeId == (short)Membership.Coans select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", "COANS");
            }

            if ((from a in paq where a.attributeId == (short)Membership.Hans select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", "HANS");
            }

            if ((from a in paq where a.attributeId == (short)Membership.DestinationHfx select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", "DH");
            }

            if (!String.IsNullOrEmpty(otherMemberships))
            {
                sb.AppendFormat(", {0}", otherMemberships);
            }

            return (sb.Length > 0) ? String.Format(" {0} {1}.", (languageId == "fr") ? "Membre:" : "Member:", sb.ToString().Substring(2)) : "";
        }

        private string GenerateRestaurantTypeString(IQueryable<ProductAttribute> paq, string languageId, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            if ((from a in paq where a.attributeId == (short)RestaurantType.CoffeeShop select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "café" : "cafe/tea room");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantType.Continental select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "cuisine continentale" : "continental");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantType.FamilyDining select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "restaurant familial" : "family dining");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantType.FastFood select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "restauration rapide" : "fast food");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantType.FineDining select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "fine cuisine" : "fine dining");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantType.Gourmet select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "cuisine gastronomique" : "gourmet");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantType.Informal select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "sans prétention" : "informal");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantType.Lounge select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "bar-salon" : "lounge");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantType.Pub select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "pub" : "pub");
            }

            string returnValue = "";

            if (sb.Length > 0)
            {
                returnValue = sb.ToString().Substring(2);
                returnValue = String.Format("{0}{1}", returnValue.First().ToString().ToUpper(), returnValue.Substring(1));
                returnValue = (et == ExportType.Print) ? String.Format("{0}{1}", FineArtsMediaRomanTag, returnValue) : returnValue;
                returnValue = String.Format("{0}{1}: {2}", (et == ExportType.Print) ? FineArtsMediaTag : "",(languageId == "fr") ? "Type" : "Type", returnValue);
            }

            return returnValue;
        }

        private string GenerateRestaurantSpecialtyString(IQueryable<ProductAttribute> paq, string languageId, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Acadian select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "cuisine acadienne" : "Acadian");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Canadian select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "cuisine canadienne" : "Canadian");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Asian select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "Asian" : "Asian");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.European select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "cuisine européenne" : "European");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.FishAndChips select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "poissons-frites" : "fish and chips");
            }

            //if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.German select a).Count() > 0)
            //{
            //    sb.AppendFormat(", {0}", (languageId == "fr") ? "cuisine allemande" : "German");
            //}

            //if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Italian select a).Count() > 0)
            //{
            //    sb.AppendFormat(", {0}", (languageId == "fr") ? "cuisine italienne" : "Italian");
            //}

            //if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Pasta select a).Count() > 0)
            //{
            //    sb.AppendFormat(", {0}", (languageId == "fr") ? "pâtes" : "pasta");
            //}

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.PizzaAndBurgers select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "pizza/burgers" : "pizza/burgers");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Sandwiches select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "sandwiches" : "sandwiches");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Seafood select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "fruits de mer" : "seafood");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Steaks select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "steaks" : "steaks");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Vegetarian select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "plats végétariens" : "vegetarian");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.GlutenFree select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "gluten free" : "gluten free");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Latin select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "Latin" : "Latin");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Indian select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "Indian" : "Indian");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.MiddleEastern select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "Middle Eastern" : "Middle Eastern");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Desserts select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "desserts" : "desserts");
            }

            string returnValue = "";

            if (sb.Length > 0)
            {
                returnValue = sb.ToString().Substring(2);
                returnValue = String.Format("{0}{1}", returnValue.First().ToString().ToUpper(), returnValue.Substring(1));
                returnValue = (et == ExportType.Print) ? String.Format("{0}{1}", FineArtsMediaRomanTag, returnValue) : returnValue;
                returnValue = String.Format("{0}{1}: {2}", (et == ExportType.Print) ? FineArtsMediaTag : "", (languageId == "fr") ? "Spécialité" : "Specialty", returnValue);
            }

            return returnValue;
        }


        private string GenerateFineArtsCategoryString(IQueryable<ProductAttribute> paq, string languageId, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            if ((from a in paq where a.attributeId == (short)ArtType.Accessories select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "accessoires" : "accessories");
            }

            if ((from a in paq where a.attributeId == (short)ArtType.BathBodyProducts select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "produits pour le corps et le bain" : "bath & body products");
            }

            if ((from a in paq where a.attributeId == (short)ArtType.Clothing select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "vêtements" : "clothing");
            }

            if ((from a in paq where a.attributeId == (short)ArtType.Crafts select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "artisanat" : "crafts");
            }

            if ((from a in paq where a.attributeId == (short)ArtType.FineArt select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "oeuvres d’art" : "fine art");
            }

            if ((from a in paq where a.attributeId == (short)ArtType.FolkArt select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "art populaire" : "folk art");
            }

            if ((from a in paq where a.attributeId == (short)ArtType.Food select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "nourriture" : "food");
            }

            if ((from a in paq where a.attributeId == (short)ArtType.Furniture select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "mobilier" : "furniture");
            }

            if ((from a in paq where a.attributeId == (short)ArtType.GardenAccessories select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "accessoires de jardin" : "garden accessories");
            }

            if ((from a in paq where a.attributeId == (short)ArtType.HomeDecor select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "objets décoratifs pour la maison" : "home décor");
            }

            if ((from a in paq where a.attributeId == (short)ArtType.Jewellery select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "bijoux" : "jewellery");
            }

            if ((from a in paq where a.attributeId == (short)ArtType.Sculpture select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "sculpture" : "sculpture");
            }

            if ((from a in paq where a.attributeId == (short)ArtType.VisualArt select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "arts visuels" : "visual art");
            }

            string returnValue = "";

            if (sb.Length > 0)
            {
                returnValue = sb.ToString().Substring(2);
                returnValue = String.Format("{0}{1}", returnValue.First().ToString().ToUpper(), returnValue.Substring(1));
                returnValue = (et == ExportType.Print) ? String.Format(CategoryTag, returnValue) : returnValue;
                returnValue = String.Format("{0}: {1}", (languageId == "fr") ? "Catégorie" : "Category", returnValue);
            }

            return returnValue;
        }

        private string GenerateFineArtsMediaString(IQueryable<ProductAttribute> paq, string languageId, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            if ((from a in paq where a.attributeId == (short)Medium.BooksCards select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "livres et cartes" : "books & cards");
            }

            if ((from a in paq where a.attributeId == (short)Medium.Candles select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "bougies" : "candles");
            }

            if ((from a in paq where a.attributeId == (short)Medium.Clay select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "argile" : "clay");
            }

            if ((from a in paq where a.attributeId == (short)Medium.Fibre select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "fibres" : "fibre");
            }

            if ((from a in paq where a.attributeId == (short)Medium.Glass select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "verre" : "glass");
            }

            if ((from a in paq where a.attributeId == (short)Medium.Leather select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "cuir" : "leather");
            }

            if ((from a in paq where a.attributeId == (short)Medium.Metal select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "métal" : "metal");
            }

            if ((from a in paq where a.attributeId == (short)Medium.MultipleMedia select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "matières diverses" : "multiple media");
            }

            if ((from a in paq where a.attributeId == (short)Medium.PaintingPrints select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "tableaux et gravures" : "paintings & prints");
            }

            if ((from a in paq where a.attributeId == (short)Medium.Paper select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "papier" : "paper");
            }

            if ((from a in paq where a.attributeId == (short)Medium.Photography select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "photographie" : "photography");
            }

            if ((from a in paq where a.attributeId == (short)Medium.StoneBone select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "pierre et os" : "stone & bone");
            }

            if ((from a in paq where a.attributeId == (short)Medium.Wood select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "bois" : "wood");
            }

            string returnValue = "";

            if (sb.Length > 0)
            {
                returnValue = sb.ToString().Substring(2);
                //capitalize first letter
                returnValue = String.Format("{0}{1}", returnValue.First().ToString().ToUpper(), returnValue.Substring(1));

                returnValue = String.Format("{0}{1}: {2}{3}", (et == ExportType.Print) ? FineArtsMediaTag : "", (languageId == "fr") ? "Matière" : "Media", (et == ExportType.Print) ? FineArtsMediaRomanTag : "", returnValue);
               // returnValue = (et == ExportType.Print) ? String.Format(FineArtsMediaTag, (languageId == "fr") ? "Matière" : "Media", returnValue) : returnValue;
            }

            return returnValue;
        }

        private string GeneratePaymentTypeString(IQueryable<ProductPaymentType> q, string languageId)
        {
            StringBuilder sb = new StringBuilder();

            if ((from a in q where a.paymentTypeId == (short)PaymentType.CashOnly select a).Count() > 0)
            {
                return sb.Append(languageId == "fr" ? " $/CV." : " $/TC.").ToString();
            }

            if ((from a in q where a.paymentTypeId == (short)PaymentType.Mastercard || a.paymentTypeId == (short)PaymentType.Visa || a.paymentTypeId == (short)PaymentType.AmericanExpress || a.paymentTypeId == (short)PaymentType.DinersClub || a.paymentTypeId == (short)PaymentType.Discover || a.paymentTypeId == (short)PaymentType.Jcb select a).Count() > 2)
            {
                sb.AppendFormat(", {0}", (languageId == "fr" ? "PCCA" : "AMCC"));
            }
            else
            {
                if ((from a in q where a.paymentTypeId == (short)PaymentType.Visa select a).Count() > 0)
                {
                    sb.AppendFormat(", {0}", "VS");
                }

                if ((from a in q where a.paymentTypeId == (short)PaymentType.Mastercard select a).Count() > 0)
                {
                    sb.AppendFormat(", {0}", "MC");
                }

                if ((from a in q where a.paymentTypeId == (short)PaymentType.AmericanExpress select a).Count() > 0)
                {
                    sb.AppendFormat(", {0}", "AE");
                }

                if ((from a in q where a.paymentTypeId == (short)PaymentType.DinersClub select a).Count() > 0)
                {
                    sb.AppendFormat(", {0}", "DC");
                }

                if ((from a in q where a.paymentTypeId == (short)PaymentType.Jcb select a).Count() > 0)
                {
                    sb.AppendFormat(", {0}", "JCB");
                }

                if ((from a in q where a.paymentTypeId == (short)PaymentType.Discover select a).Count() > 0)
                {
                    sb.AppendFormat(", {0}", "DIS");
                }
            }

            if ((from a in q where a.paymentTypeId == (short)PaymentType.DebitCard select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr" ? "PD" : "DD"));
            }

            if ((from a in q where a.paymentTypeId == (short)PaymentType.PayPal select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", "PP");
            }

            return (sb.Length > 0) ? String.Format(" {0}.", sb.ToString().Substring(2)) : "";
        }

        private string GenerateAddressString (string line1, string line2, string line3, string city, string postalCode)
        {
            StringBuilder sb = new StringBuilder();

            if (!String.IsNullOrEmpty(line1))
            {
                sb.AppendFormat(" {0}", line1);
            }

            if (!String.IsNullOrEmpty(line2))
            {
                sb.AppendFormat("{0}{1}", (sb.Length > 0) ? ", " : "", line2);
            }

            if (!String.IsNullOrEmpty(line3))
            {
                sb.AppendFormat("{0}{1}", (sb.Length > 0) ? ", " : "", line3);
            }

            sb.AppendFormat("{0}{1}", (sb.Length > 0) ? ", " : "", city);
            

            if (sb.Length > 0)
            {
                sb.Append(", NS");
            }

            if (!(String.IsNullOrEmpty(postalCode) || (postalCode.Trim().Length == 0)))
            {
                sb.AppendFormat("{0}{1} {2}", (sb.Length > 0) ? ", " : "", postalCode.Substring(0, 3), postalCode.Substring(3));
            }

            return sb.ToString();
        }

        private string GenerateAddressString(Product p)
        {
            StringBuilder sb = new StringBuilder();

            if (!String.IsNullOrEmpty(p.line1))
            {
                sb.AppendFormat(" {0}", p.line1);
            }

            if (!String.IsNullOrEmpty(p.line2))
            {
                sb.AppendFormat("{0}{1}", (sb.Length > 0) ? ", " : "", p.line2);
            }

            if (!String.IsNullOrEmpty(p.line3))
            {
                sb.AppendFormat("{0}{1}", (sb.Length > 0) ? ", " : "", p.line3);
            }

            if ((p.productTypeId == (int)ProductType.TourOps)  && p.communityId != null)
            {
                sb.AppendFormat("{0}{1}", (sb.Length > 0) ? ", " : "", p.refCommunity.communityName);
            }

            //if (sb.Length > 0)
            //{
            //    sb.Append(", NS");
            //}

            //if (!(String.IsNullOrEmpty(p.postalCode) || (p.postalCode.Trim().Length == 0)))
            //{
            //    sb.AppendFormat("{0}{1} {2}", (sb.Length > 0) ? ", " : "", p.postalCode.Substring(0, 3), p.postalCode.Substring(3));
            //}

            if (sb.Length > 0)
            {
                sb.Append(".");
            }

            return sb.ToString();
        }

        private string GenerateRestaurantAddressString(Product p)
        {
            StringBuilder sb = new StringBuilder();

            if (!String.IsNullOrEmpty(p.line1))
            {
                sb.AppendFormat("{0}", p.line1);
            }

            if (!String.IsNullOrEmpty(p.line2))
            {
                sb.AppendFormat("{0}{1}", (sb.Length > 0) ? ", " : "", p.line2);
            }

            if (!String.IsNullOrEmpty(p.line3))
            {
                sb.AppendFormat("{0}{1}", (sb.Length > 0) ? ", " : "", p.line3);
            }

            if (sb.Length > 0)
            {
                sb.Append(".");
            }

            return sb.ToString();
        }

        private string GenerateFineArtsAddressString(Product p)
        {
            StringBuilder sb = new StringBuilder();

            //if (p.communityId != null)
            //{
            //    //sb.AppendFormat("{0} {1}:", p.refCommunity.communityName, p.refCommunity.guideIndex);
            //    sb.AppendFormat("{0}:", p.refCommunity.communityName);
            //}

            if (!String.IsNullOrEmpty(p.line1))
            {
                sb.AppendFormat("{0}", p.line1);
            }

            if (!String.IsNullOrEmpty(p.line2))
            {
                sb.AppendFormat("{0}{1}", (sb.Length > 0) ? ", " : "", p.line2);
            }

            if (!String.IsNullOrEmpty(p.line3))
            {
                sb.AppendFormat("{0}{1}", (sb.Length > 0) ? ", " : "", p.line3);
            }

            if (sb.Length > 0)
            {
                sb.Append(".");
            }

            return sb.ToString();
        }

        private string GenerateGpsString(decimal latitude, decimal longitude)
        {
            latitude = Math.Abs(latitude);
            longitude = Math.Abs(longitude);

            decimal latDegrees = Math.Truncate(latitude);
            decimal lonDegrees = Math.Truncate(longitude);

            decimal latMinutes = Math.Round((latitude - Math.Truncate(latitude)) * 60, 3);
            decimal lonMinutes = Math.Round((longitude - Math.Truncate(longitude)) * 60, 3);

            return String.Format(GpsString, latDegrees, (latMinutes < 10) ? "0" + latMinutes.ToString() : latMinutes.ToString(), lonDegrees, (lonMinutes < 10) ? "0" + lonMinutes.ToString() : lonMinutes.ToString());
        }

        private string GenerateContactString(Product p, ExportType et, string languageId)
        {
            StringBuilder sb = new StringBuilder();

            string telephone = (languageId == "en") ? p.telephone : TranslatePhoneNumber(p.telephone);
            string secondaryPhone = (languageId == "en") ? p.secondaryPhone : TranslatePhoneNumber(p.secondaryPhone);
            string offSeasonPhone = (languageId == "en") ? p.offSeasonPhone : TranslatePhoneNumber(p.offSeasonPhone);

            bool phoneFaxSame = (p.telephone == p.fax) ? true : false;

            if (!String.IsNullOrEmpty(p.telephone))
            {
                if (phoneFaxSame)
                {
                    sb.Append((languageId == "fr") ? "Tél/téléc " : "tel/fax ");
                }
                //sb.Append(telephone.Replace("902-", ""));
                sb.Append(telephone);
            }

            if (!String.IsNullOrEmpty(p.secondaryPhone))
            {
                if (sb.Length > 0)
                {
                    sb.Append("; ");
                }
                //sb.Append(secondaryPhone.Replace("902-", ""));
                sb.Append(secondaryPhone);
            }

            if (!String.IsNullOrEmpty(p.offSeasonPhone))
            {
                if (sb.Length > 0)
                {
                    sb.Append("; ");
                }
                //sb.Append(String.Format("{0} {1}", (languageId=="fr") ? "HS": "O/S", offSeasonPhone.Replace("902-", "")));
                sb.Append(String.Format("{0} {1}", (languageId == "fr") ? "HS" : "O/S", offSeasonPhone));
            }

            if (!String.IsNullOrEmpty(p.tollfree))
            {
                StringBuilder tf = new StringBuilder();

                if (sb.Length > 0)
                {
                    sb.Append(et == ExportType.Print ? Bullet : BulletHtml);
                }

                if (p.reservationsOnly)
                {
                    tf.Append((languageId == "fr") ? "réservations" : "reservations");
                }

                if (p.tollfreeAreaId != null)
                {
                    if (tf.Length > 0)
                    {
                        tf.Append(", ");
                    }

                    tf.Append(GetTollFreeAreaLabel((TollFreeArea) p.tollfreeAreaId, languageId));
                }

                if (tf.Length > 0)
                {
                    sb.AppendFormat("{0} ({1})", p.tollfree, tf.ToString());
                }
                else
                {
                    sb.Append(p.tollfree);
                }

                //sb.Append(Regex.IsMatch(p.offSeasonPhone, "^902-") ? p.offSeasonPhone.Substring(4) : p.telephone);
            }

            if (!String.IsNullOrEmpty(p.fax) && !phoneFaxSame)
            {
                if (sb.Length > 0)
                {
                    sb.Append(et == ExportType.Print ? Bullet : BulletHtml);
                }

                //sb.Append(String.Format("{0} {1}", languageId == "en" ? "fax" : "téléc" , p.fax.Replace("902-", "")));
                sb.Append(String.Format("{0} {1}", languageId == "en" ? "fax" : "téléc", p.fax));
            }

            if (!String.IsNullOrEmpty(p.email))
            {
                if (sb.Length > 0)
                {
                    sb.Append(et == ExportType.Print ? Bullet : BulletHtml);
                }

                sb.Append(et == ExportType.Print ? p.email.Replace("@", EscapedAtSign) : p.email);
            }

            if (!String.IsNullOrEmpty(p.web))
            {
                if (sb.Length > 0)
                {
                    sb.Append(et == ExportType.Print ? Bullet : BulletHtml);
                }

                sb.Append(Regex.Replace(p.web, "^https?://", ""));
                //sb.Append(p.web);
            }

            //sb.Append(SectionBreak);

            return sb.ToString();
        }

        private string GenerateListingBody(Product p, IQueryable<ProductAttribute> paq, string languageId, ExportType et)
        {
          
            switch (p.productTypeId)
            {
                case (int)ProductType.Accommodation:
                    return GenerateAccommodationListingBody(p, paq, languageId, et);
                case (int)ProductType.Campground:
                    return GenerateAccommodationListingBody(p, paq, languageId, et);
                case (int)ProductType.Attraction:
                    return GenerateAttractionListingBody(p, paq, languageId, et);
                case (int)ProductType.Outdoors:
                    return GenerateOutdoorListingBody(p, paq, languageId, et);
                case (int)ProductType.TourOps:
                    return GenerateTourOpListingBody(p, paq, languageId, et);
                case (int)ProductType.Restaurants:
                    return GenerateRestaurantListingBody(p, paq, languageId, et);
                case (int)ProductType.FineArts:
                    return GenerateFineArtsListingBody(p, paq, languageId, et);
                case (int)ProductType.Trails:
                    return GenerateTrailListingBody(p, paq, languageId, et);
                default:
                    return "";
            }
        }

        private string GenerateSymbolString(Product p, IQueryable<ProductAttribute> paq, string languageId)
        {
            switch (p.productTypeId)
            {
                case (int)ProductType.Accommodation:
                    return GenerateAccommodationSymbolString(p, paq,
                                                             productBs.GetProductCaaRatings(p.id),
                                                             productBs.GetProductCanadaSelectRatings(p.id), ExportType.Html, languageId);
                case (int)ProductType.Campground:
                    return GenerateAccommodationSymbolString(p, paq,
                                                             productBs.GetProductCaaRatings(p.id),
                                                             productBs.GetProductCanadaSelectRatings(p.id), ExportType.Html, languageId);
                case (int)ProductType.Attraction:
                    return GenerateAttractionSymbolString(p, paq, ExportType.Html);
                case (int)ProductType.Outdoors:
                    return GenerateOutdoorSymbolString(p, paq, ExportType.Html);
                case (int)ProductType.TourOps:
                    return GenerateOutdoorSymbolString(p, paq, ExportType.Html);
                case (int)ProductType.Restaurants:
                    return GenerateRestaurantSymbolString(p, paq, ExportType.Html);
                case (int)ProductType.FineArts:
                    return GenerateFineArtsSymbolString(p, paq, ExportType.Html);
                case (int)ProductType.Trails:
                    return GenerateTrailSymbolString(p, paq, ExportType.Html);
                default:
                    return "";
            }
        }

        private string GenerateFineArtsSymbolString(Product p, IQueryable<ProductAttribute> paq, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            string facebookUrl = p.Urls.Where(z => z.urlTypeId == (int)UrlType.Facebook).Select(z => z.url).FirstOrDefault();
            string twitterUrl = p.Urls.Where(z => z.urlTypeId == (int)UrlType.Twitter).Select(z => z.url).FirstOrDefault();

            if (!String.IsNullOrEmpty(facebookUrl))
            {
                sb.Append(et == ExportType.Print ? FacebookTag : "A");
            }

            if (!String.IsNullOrEmpty(twitterUrl))
            {
              
                sb.Append(et == ExportType.Print ? TwitterTag : "E");
            }

            if (sb.Length > 0 && et == ExportType.Print)
            {
                sb.Append(ListingHeadSymbols);
            }

            if ((from a in paq where a.attributeId == (short)Membership.Bienvenue select a).Count() > 0)
            {
                sb.Append("a");
            }

            if ((from a in paq where a.attributeId == (short)Feature.WheelChairAccessible select a).Count() > 0)
            {
                sb.Append("W");
            }

            if ((from a in paq where a.attributeId == (short)Feature.LimitedAccessibility select a).Count() > 0)
            {
                sb.Append(";");
            }

            return sb.ToString();
        }

        private string GenerateRestaurantSubLine(IQueryable<ProductAttribute> paq, ExportType et, string languageId)
        {
            StringBuilder sb = new StringBuilder();

            string categoryString = GenerateRestaurantTypeString(paq, languageId, et);
            string specialtyString = GenerateRestaurantSpecialtyString(paq, languageId, et);

            sb.Append(categoryString);

            if (categoryString.Length > 0 && specialtyString.Length > 0)
            {
                sb.Append((et == ExportType.Html) ? BulletHtml : Bullet);
            }

            sb.Append(specialtyString);

            return sb.ToString();
        }

        private string GenerateFineArtsTypeDescription(Product p, IQueryable<ProductAttribute> paq, ExportType et, string languageId)
        {
            return GenerateFineArtsMediaString(paq, languageId, et);
        }

        private string GenerateOutdoorSymbolString(Product p, IQueryable<ProductAttribute> paq, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            string facebookUrl = p.Urls.Where(z => z.urlTypeId == (int)UrlType.Facebook).Select(z => z.url).FirstOrDefault();
            string twitterUrl = p.Urls.Where(z => z.urlTypeId == (int)UrlType.Twitter).Select(z => z.url).FirstOrDefault();

            if (!String.IsNullOrEmpty(facebookUrl))
            {
                sb.Append(et == ExportType.Print ? FacebookTag : "A");
            }

            if (!String.IsNullOrEmpty(twitterUrl))
            {
                sb.Append(et == ExportType.Print ? TwitterTag : "E");
            }

            if (sb.Length > 0 && et == ExportType.Print)
            {
                sb.Append(ListingHeadSymbols);
            }

            if ((from a in paq where a.attributeId == (short)GovernmentLevel.Provincial select a).Count() > 0)
            {
                sb.Append("v");
            }

            if ((from a in paq where a.attributeId == (short)GovernmentLevel.National || a.attributeId == (short)ProductCategory.Park select a).Count() > 1)
            {
                sb.Append("P");
            }

            //if (p.isCheckinMember)
            //{
            //    sb.Append("x");
            //}

            if ((from a in paq where a.attributeId == (short)Membership.Bienvenue select a).Count() > 0)
            {
                sb.Append("a");
            }

            if ((from a in paq where a.attributeId == (short)Membership.GolfNs select a).Count() > 0)
            {
                if (et == ExportType.Print)
                {
                    sb.AppendFormat("{0}*{1}", GolfSymbolTag,ListingHeadSymbols);
                }
                else
                {
                    sb.Append("*");
                }
            }

            if ((from a in paq where a.attributeId == (short)Feature.WheelChairAccessible select a).Count() > 0)
            {
                sb.Append("W");
            }

            if ((from a in paq where a.attributeId == (short)Feature.LimitedAccessibility select a).Count() > 0)
            {
                sb.Append(";");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Canoeing select a).Count() > 0)
            {
                sb.Append("{");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Kayaking select a).Count() > 0)
            {
                sb.Append("}");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Diving select a).Count() > 0)
            {
                sb.Append("D");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Fishing select a).Count() > 0)
            {
                sb.Append("f");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Sailing select a).Count() > 0)
            {
                sb.Append("b");
            }

            if ((from a in paq where a.attributeId == (short)Activity.WhaleWatching select a).Count() > 0)
            {
                sb.Append("w");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Birding select a).Count() > 0)
            {
                sb.Append("Y");
            }

            if ((from a in paq where a.attributeId == (short)AreaOfInterest.Fossils select a).Count() > 0)
            {
                sb.Append("'");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Cycling select a).Count() > 0)
            {
                sb.Append("K");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Atv select a).Count() > 0)
            {
                sb.Append(">");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Golf select a).Count() > 0)
            {
                sb.Append("G");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Hiking select a).Count() > 0)
            {
                sb.Append("L");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Sightseeing select a).Count() > 0)
            {
                sb.Append("t");
            }

            if ((from a in paq where a.attributeId == (short)Activity.CrossCountrySkiing || a.attributeId == (short)Activity.DownhillSkiing select a).Count() > 0)
            {
                sb.Append("S");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Snowmobiling select a).Count() > 0)
            {
                sb.Append("s");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Snowshoeing select a).Count() > 0)
            {
                sb.Append("y");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Camping select a).Count() > 0)
            {
                sb.Append("|");
            }

            return sb.ToString();
        }

        private string GenerateTrailSymbolString(Product p, IQueryable<ProductAttribute> paq, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            string facebookUrl = p.Urls.Where(z => z.urlTypeId == (int)UrlType.Facebook).Select(z => z.url).FirstOrDefault();
            string twitterUrl = p.Urls.Where(z => z.urlTypeId == (int)UrlType.Twitter).Select(z => z.url).FirstOrDefault();

            if (!String.IsNullOrEmpty(facebookUrl))
            {
                sb.Append(et == ExportType.Print ? FacebookTag : "A");
            }

            if (!String.IsNullOrEmpty(twitterUrl))
            {
                sb.Append(et == ExportType.Print ? TwitterTag : "E");
            }


            if (sb.Length > 0 && et == ExportType.Print)
            {
                sb.Append(ListingHeadSymbols);
            }
            
            if ((from a in paq where a.attributeId == (short)Activity.Canoeing select a).Count() > 0)
            {
                sb.Append("{");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Kayaking select a).Count() > 0)
            {
                sb.Append("}");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Diving select a).Count() > 0)
            {
                sb.Append("D");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Fishing select a).Count() > 0)
            {
                sb.Append("f");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Sailing select a).Count() > 0)
            {
                sb.Append("b");
            }

            if ((from a in paq where a.attributeId == (short)Activity.WhaleWatching select a).Count() > 0)
            {
                sb.Append("w");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Birding select a).Count() > 0)
            {
                sb.Append("Y");
            }

            if ((from a in paq where a.attributeId == (short)AreaOfInterest.Fossils select a).Count() > 0)
            {
                sb.Append("'");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Cycling select a).Count() > 0)
            {
                sb.Append("K");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Atv select a).Count() > 0)
            {
                sb.Append(">");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Golf select a).Count() > 0)
            {
                sb.Append("G");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Hiking select a).Count() > 0)
            {
                sb.Append("L");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Sightseeing select a).Count() > 0)
            {
                sb.Append("t");
            }

            if ((from a in paq where a.attributeId == (short)Activity.CrossCountrySkiing || a.attributeId == (short)Activity.DownhillSkiing select a).Count() > 0)
            {
                sb.Append("S");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Snowmobiling select a).Count() > 0)
            {
                sb.Append("s");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Snowshoeing select a).Count() > 0)
            {
                sb.Append("y");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Camping select a).Count() > 0)
            {
                sb.Append("|");
            }

            return sb.ToString();
        }

        private string GenerateAccommodationSymbolString(Product p, IQueryable<ProductAttribute> paq, IQueryable<ProductCaaRating> pcrq, IQueryable<ProductCanadaSelectRating> pcsrq, ExportType et, string languageId)
        {
            StringBuilder sb = new StringBuilder();

            string facebookUrl = p.Urls.Where(z => z.urlTypeId == (int)UrlType.Facebook).Select(z => z.url).FirstOrDefault();
            string twitterUrl = p.Urls.Where(z => z.urlTypeId == (int)UrlType.Twitter).Select(z => z.url).FirstOrDefault();

            if (!String.IsNullOrEmpty(facebookUrl))
            {
                sb.Append(et == ExportType.Print ? FacebookTag : "A");
            }

            if (!String.IsNullOrEmpty(twitterUrl))
            {
                sb.Append(et == ExportType.Print ? TwitterTag : "E");
            }

            if (sb.Length > 0 && et == ExportType.Print)
            {
                sb.Append(ListingHeadSymbols);
            }
            //if (p.accessCanadaRating == 2)
            //{
            //    sb.Append("#");
            //}

            //if (p.accessCanadaRating == 1)
            //{
            //    sb.Append('"');
            //}
            if ((from a in paq where a.attributeId == (short)AccessAdvisor.Full select a).Count() > 0)
            {
                sb.Append("#");
            }

            if ((from a in paq where a.attributeId == (short)AccessAdvisor.Partial select a).Count() > 0)
            {
                sb.Append("\"");
            }

            if ((from a in paq where a.attributeId == (short)AccessAdvisor.Hearing select a).Count() > 0)
            {
                sb.Append("$");
            }

            if ((from a in paq where a.attributeId == (short)AccessAdvisor.Sight select a).Count() > 0)
            {
                sb.Append("%");
            }

            if ((from a in paq where a.attributeId == (short)GovernmentLevel.Provincial select a).Count() > 0)
            {
                sb.Append("v");
            }

            if ((from a in paq where a.attributeId == (short)ProductCategory.Park || a.attributeId == (short)GovernmentLevel.National select a).Count() > 1)
            {
                sb.Append("P");
            }

            //access advisor goes here....

            //if (p.isCheckinMember)
            //{
            //    sb.Append("x");
            //}

            if ((from a in paq where a.attributeId == (short)Membership.Bienvenue select a).Count() > 0)
            {
                sb.Append("a");
            }

            if ((from a in paq where a.attributeId == (short)Membership.TasteOfNs select a).Count() > 0)
            {
                sb.Append("N");
            }

            //if ((from a in paq where a.attributeId == (short)AccommodationAmenity.Kitchen || a.attributeId == (short)CampgroundAmenity.KitchenetteFacilities select a).Count() > 0)
            //{
            //    sb.Append("o");
            //}

            //campgrounds only
            if ((p.productTypeId == (int)ProductType.Campground) && (from a in paq where a.attributeId == (short)Feature.InternetAccess select a).Count() > 0)
            {
                sb.Append((et == ExportType.Html) ? "@" : EscapedAtSign);
            }

            //campgrounds only
            if ( (p.productTypeId == (int)ProductType.Campground) &&  (from a in paq where a.attributeId == (short)Feature.LimitedAccessibility select a).Count() > 0)
            {
                sb.Append(";");
            }

            //campgrounds only
            if ((p.productTypeId == (int)ProductType.Campground) && (from a in paq where a.attributeId == (short)Feature.WheelChairAccessible select a).Count() > 0)
            {
                sb.Append("W");
            }

            if ((from a in paq where a.attributeId == (short)Feature.SmokingPermitted select a).Count() > 0)
            {
                sb.Append("+");
            }

            if ((from a in paq where a.attributeId == (short)PetsPolicy.PetsWelcome select a).Count() > 0)
            {
                sb.Append("p");
            }

            if ((from a in paq where a.attributeId == (short)PetsPolicy.PetsNotWelcome select a).Count() > 0)
            {
                sb.Append("q");
            }

            if ((from a in paq where a.attributeId == (short)PetsPolicy.PetsLiveOnPremises select a).Count() > 0)
            {
                sb.Append(",");
            }

            if ((from a in paq where a.attributeId == (short)AccommodationService.Outfitters select a).Count() > 0)
            {
                sb.Append("O");
            }

            //if ((from a in paq where a.attributeId == (short)ProductCategory.Museum select a).Count() > 0)
            //{
            //    sb.Append("z");
            //}

            //if ((from a in paq where a.attributeId == (short)ProductCategory.Winery select a).Count() > 0)
            //{
            //    sb.Append("u");
            //}

            if ((from a in paq where a.attributeId == (short)Activity.Canoeing select a).Count() > 0)
            {
                sb.Append("{");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Kayaking select a).Count() > 0)
            {
                sb.Append("}");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Fishing select a).Count() > 0)
            {
                sb.Append("f");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Cycling select a).Count() > 0)
            {
                sb.Append("K");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Hiking select a).Count() > 0)
            {
                sb.Append("L");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Golf select a).Count() > 0)
            {
                sb.Append("G");
            }

            if ((from a in paq where a.attributeId == (short)Activity.CrossCountrySkiing || a.attributeId == (short)Activity.DownhillSkiing select a).Count() > 0)
            {
                sb.Append("S");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Snowshoeing select a).Count() > 0)
            {
                sb.Append("y");
            }

            //if ((from a in paq where a.attributeId == (short)AreaOfInterest.Genealogy select a).Count() > 0)
            //{
            //    sb.Append("\\");
            //}

            var last = pcsrq.Count();
            var k = 0;
            foreach (var b in pcsrq)
            {
                k++;
                if (k == 1)
                {
                    sb.Append((et == ExportType.Print) ? ListingStars : "");
                }
                
                for (int i = 0; i < (b.ratingValue - b.ratingValue % 2); i = i + 2)
                {
                    sb.Append("c");
                }

                if (b.ratingValue % 2 == 1)
                {
                    sb.Append("d");
                }

                if (b.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.CampingFacilities)
                {
                    sb.Append((et == ExportType.Print) ? ListingHeadSymbols : "");
                    sb.Append("[F]");
                    if (k != last && et == ExportType.Print)
                    {
                        sb.Append(ListingStars);
                    }
                    continue;
                }

                if (b.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.CampingRecreation)
                {
                    sb.Append((et == ExportType.Print) ? ListingHeadSymbols : "");
                    sb.Append("[R]");
                    if (k != last && et == ExportType.Print)
                    {
                        sb.Append(ListingStars);
                    }
                    continue;
                }

                if (k != last)
                {
                    if (et == ExportType.Print)
                    {
                        //sb.Append("/");    
                        sb.AppendFormat("<@01-1 Listing Head Name-2008>/{0}", ListingStars);
                    }
                    else
                    {
                        sb.Append("/");
                    }
                }
            }

            if ((from a in paq where a.attributeId == (short)ApprovedBy.NsApproved select a).Count() > 0)
            {
                sb.AppendFormat("{0}{1}", (et == ExportType.Print) ? NsApprovedTag : "", ".");
            }

            if (pcrq.Count() > 0)
            {
                sb.Append((et == ExportType.Print) ? ListingStars : "");
                for (int j = 1; j <= pcrq.First().ratingValue; j++)
                {
                    sb.Append("J");
                }
            }

            return sb.ToString();
        }

        private string GenerateAttractionSymbolString(Product p, IQueryable<ProductAttribute> paq, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            string facebookUrl = p.Urls.Where(z => z.urlTypeId == (int)UrlType.Facebook).Select(z => z.url).FirstOrDefault();
            string twitterUrl = p.Urls.Where(z => z.urlTypeId == (int)UrlType.Twitter).Select(z => z.url).FirstOrDefault();

            if (!String.IsNullOrEmpty(facebookUrl))
            {
                sb.Append(et == ExportType.Print ? FacebookTag : "A");
            }

            if (!String.IsNullOrEmpty(twitterUrl))
            {
                sb.Append(et == ExportType.Print ? TwitterTag : "E");
            }


            if (sb.Length > 0 && et == ExportType.Print)
            {
                sb.Append(ListingHeadSymbols);
            }

            if ((from a in paq where a.attributeId == (short)GovernmentLevel.Provincial select a).Count() > 0)
            {
                sb.Append("v");
            }

            if ((from a in paq where a.attributeId == (short)ProductCategory.Park || a.attributeId == (short)GovernmentLevel.National select a).Count() > 1)
            {
                sb.Append("P");
            }

            if ((from a in paq where a.attributeId == (short)ProductCategory.Museum select a).Count() > 0)
            {
                sb.Append("z");
            }

            if ((from a in paq where a.attributeId == (short)Membership.Bienvenue select a).Count() > 0)
            {
                sb.Append("a");
            }

            if ((from a in paq where a.attributeId == (short)Membership.TasteOfNs select a).Count() > 0)
            {
                sb.Append("N");
            }

            if ((from a in paq where a.attributeId == (short)Feature.WheelChairAccessible select a).Count() > 0)
            {
                sb.Append("W");
            }

            if ((from a in paq where a.attributeId == (short)Feature.LimitedAccessibility select a).Count() > 0)
            {
                sb.Append(";");
            }

            if ((from a in paq where a.attributeId == (short)Feature.InternetAccess select a).Count() > 0)
            {
                sb.Append((et == ExportType.Html) ? "@" : EscapedAtSign);
            }

            if ((from a in paq where a.attributeId == (short)AreaOfInterest.Genealogy select a).Count() > 0)
            {
                sb.Append("\\");
            }

            if ((from a in paq where a.attributeId == (short)AreaOfInterest.Fossils select a).Count() > 0)
            {
                sb.Append("'");
            }

            // Need to add fossils and rockhounding symbol here

            if ((from a in paq where a.attributeId == (short)ProductCategory.Winery select a).Count() > 0)
            {
                sb.Append("u");
            }


            //if ((from a in paq where a.attributeId == (short)Feature.SmokingPermitted select a).Count() > 0)
            //{
            //    sb.Append("+");
            //}

            //if ((from a in paq where a.attributeId == (short)PetsPolicy.PetsWelcome select a).Count() > 0)
            //{
            //    sb.Append("p");
            //}

            //if ((from a in paq where a.attributeId == (short)PetsPolicy.PetsNotWelcome select a).Count() > 0)
            //{
            //    sb.Append("q");
            //}

            //if ((from a in paq where a.attributeId == (short)PetsPolicy.PetsLiveOnPremises select a).Count() > 0)
            //{
            //    sb.Append(",");
            //}

            //if ((from a in paq where a.attributeId == (short)ApprovedBy.NsApproved select a).Count() > 0)
            //{
            //    sb.AppendFormat("{0}{1}", (et == ExportType.Print) ? NsApprovedTag : "", ".");
            //}

            return sb.ToString();
        }

        private string GenerateRestaurantSymbolString(Product p, IQueryable<ProductAttribute> paq, ExportType et)
        {
            StringBuilder sb = new StringBuilder();

            string facebookUrl = p.Urls.Where(z => z.urlTypeId == (int)UrlType.Facebook).Select(z => z.url).FirstOrDefault();
            string twitterUrl = p.Urls.Where(z => z.urlTypeId == (int)UrlType.Twitter).Select(z => z.url).FirstOrDefault();

            if (!String.IsNullOrEmpty(facebookUrl))
            {
                sb.Append(et == ExportType.Print ? FacebookTag : "A");
            }

            if (!String.IsNullOrEmpty(twitterUrl))
            {
                sb.Append(et == ExportType.Print ? TwitterTag : "E");
            }

            if (sb.Length > 0 && et == ExportType.Print)
            {
                sb.Append(ListingHeadSymbols);
            }

            if ((from a in paq where a.attributeId == (short)AccessAdvisor.Full select a).Count() > 0)
            {
                sb.Append("#");
            }

            if ((from a in paq where a.attributeId == (short)AccessAdvisor.Partial select a).Count() > 0)
            {
                sb.Append("\"");
            }

            if ((from a in paq where a.attributeId == (short)AccessAdvisor.Hearing select a).Count() > 0)
            {
                sb.Append("$");
            }

            if ((from a in paq where a.attributeId == (short)AccessAdvisor.Sight select a).Count() > 0)
            {
                sb.Append("%");
            }

            if ((from a in paq where a.attributeId == (short)Membership.TasteOfNs select a).Count() > 0)
            {
                sb.Append("N");
            }

            if ((from a in paq where a.attributeId == (short)Membership.Rans select a).Count() > 0)
            {
                sb.Append("r");
            }

            if ((from a in paq where a.attributeId == (short)Membership.Bienvenue select a).Count() > 0)
            {
                sb.Append("a");
            }

            if ((from a in paq where a.attributeId == (short)Feature.InternetAccess select a).Count() > 0)
            {
                sb.Append((et == ExportType.Html) ? "@" : EscapedAtSign);
            }

            if ((from a in paq where a.attributeId == (short)Feature.WheelChairAccessible select a).Count() > 0)
            {
                sb.Append("W");
            }

            if ((from a in paq where a.attributeId == (short)Feature.LimitedAccessibility select a).Count() > 0)
            {
                sb.Append(";");
            }

            //if ((from a in paq where a.attributeId == (short)ApprovedBy.NsApproved select a).Count() > 0)
            //{
            //    sb.AppendFormat("{0}{1}", (et == ExportType.Print) ? NsApprovedTag : "", ".");
            //}

            return sb.ToString();
        }


        private string GetRatePeriodAbbreviation(RatePeriod rt, string languageId)
        {
            switch (rt)
            {
                case RatePeriod.Daily:
                    return "";
                case RatePeriod.Monthly:
                    return (languageId == "fr") ? "/mois" : " monthly";
                case RatePeriod.Weekly:
                    return (languageId == "fr") ? "/sem" : " weekly";
                default:
                    return "";
            }
        }

        private string GetRateTypeAbbreviation(RateType rt, string languageId)
        {
            switch (rt)
            {
                case RateType.Gtd:
                    return (languageId == "fr") ? "GAR" : "GTD";
                case RateType.Stc:
                    return (languageId == "fr") ? "SAM" : "STC";
                default:
                    return "";
            }
        }

        private string GetGuideSectionTitle(Product p, string languageId)
        {
            switch (p.productTypeId)
            {
                case ((int)ProductType.Outdoors):
                    return GetGuideSectionTitle(p.productTypeId, p.primaryGuideSectionId ?? -1, languageId);
                case ((int)ProductType.TourOps):
                    return GetGuideSectionTitle(p.productTypeId, p.primaryGuideSectionId ?? -1, languageId);
                default:
                    return "";
            }
        }

        private string GetGuideSectionTitle(int productTypeId, int guideSectionId, string languageId)
        {
            switch (productTypeId)
            {
                case ((int)ProductType.Outdoors):
                    return GetOutdoorsGuideSectionTitle((GuideSectionOutdoors)guideSectionId, languageId);
                case ((int)ProductType.TourOps):
                    return GetTourOpGuideSectionTitle((GuideSectionTourOps)guideSectionId, languageId);
                default:
                    return "";
            }
        }

        private string GetExhibitTypeLabel(IQueryable<ProductAttribute> paq, string languageId)
        {
            var q = (from a in paq where a.attributeGroupId == (int) AttributeGroup.ExhibitType select a).FirstOrDefault();

            if (q != null)
            {
                switch ((ExhibitType)q.attributeId)
                {
                    case ExhibitType.ArtisanStudios:
                        //return (languageId == "fr") ? "Studios d’artistes et d’artisans" : "Artisan Studios";
                        return (languageId == "fr") ? "Studios d'artistes et d'artisans" : "Open Studio Artisan";
                    case ExhibitType.ShopsAndGalleries:
                        //return (languageId == "fr") ? "Boutiques et galeries" : "Shops & Galleries"; 
                        return "";
                    default:
                        return "";
                }
            }

            return "";
        }

        private string GetCancellationPolicyAbbreviation(CancellationPolicy cp, string languageId)
        {
            switch (cp)
            {
                case CancellationPolicy.BookingSpecific:
                    return (languageId == "en") ? "booking-specific CXL" : "ANN (s’informer)";
                case CancellationPolicy.Day:
                    return (languageId == "en") ? "24-hr CXL" : "ANN 24h";
                case CancellationPolicy.FiveDay:
                    return (languageId == "en") ? "5-day CXL" : "ANN 5 jours";
                case CancellationPolicy.FourWeek:
                    return (languageId == "en") ? "4-wk CXL" : "ANN 4 sem";
                case CancellationPolicy.FourPm:
                    return (languageId == "en") ? "4pm CXL" : "ANN avant 16h";
                case CancellationPolicy.HalfDay:
                    return (languageId == "en") ? "12-hr CXL" : "ANN 12h";
                case CancellationPolicy.NoCancellations:
                    return (languageId == "en") ? "no CXL" : "aucune polituque en cas d’annulation";
                case CancellationPolicy.Noon:
                    return (languageId == "en") ? "noon CXL" : "ANN avant midi";
                case CancellationPolicy.OneWeek:
                    return (languageId == "en") ? "1-wk CXL" : "ANN 1 sem";
                case CancellationPolicy.ThreeDay:
                    return (languageId == "en") ? "72-hr CXL" : "ANN 72h";
                case CancellationPolicy.TwoDay:
                    return (languageId == "en") ? "48-hr CXL" : "ANN 48h";
                case CancellationPolicy.TwoWeek:
                    return (languageId == "en") ? "2-wk CXL" : "ANN 2 sem";
                case CancellationPolicy.EightWeek:
                    return (languageId == "en") ? "8-wk CXL" : "ANN 8 sem";
                case CancellationPolicy.TwelveWeek:
                    return (languageId == "en") ? "12-wk CXL" : "ANN 12 sem";
                default:
                    return "";
            }
        }

        private string GetGridCancellationPolicyAbbreviation(CancellationPolicy cp, string languageId)
        {
            switch (cp)
            {
                case CancellationPolicy.BookingSpecific:
                    return (languageId == "en") ? "*" : "*";
                case CancellationPolicy.Day:
                    return (languageId == "en") ? "24-hr" : "ANN 24h";
                case CancellationPolicy.FiveDay:
                    return (languageId == "en") ? "5-day" : "ANN 5 jours";
                case CancellationPolicy.FourWeek:
                    return (languageId == "en") ? "4-wk" : "ANN 4 sem";
                case CancellationPolicy.FourPm:
                    return (languageId == "en") ? "4pm" : "ANN avant 16h";
                case CancellationPolicy.HalfDay:
                    return (languageId == "en") ? "12-hr" : "ANN 12h";
                case CancellationPolicy.NoCancellations:
                    return (languageId == "en") ? "" : "";
                case CancellationPolicy.Noon:
                    return (languageId == "en") ? "noon": "midi";
                case CancellationPolicy.OneWeek:
                    return (languageId == "en") ? "1-wk": "1 sem";
                case CancellationPolicy.ThreeDay:
                    return (languageId == "en") ? "72-hr": "72h";
                case CancellationPolicy.TwoDay:
                    return (languageId == "en") ? "48-hr": "48h";
                case CancellationPolicy.TwoWeek:
                    return (languageId == "en") ? "2-wk": "2 sem";
                case CancellationPolicy.EightWeek:
                    return (languageId == "en") ? "8-wk" : "8 sem";
                case CancellationPolicy.TwelveWeek:
                    return (languageId == "en") ? "12-wk" : "12 sem";
                default:
                    return "";
            }
        }

        private string GetCanadaSelectAbbreviation(CanadaSelectRatingType csrt, string languageId)
        {
            switch (csrt)
            {
                case CanadaSelectRatingType.CampingFacilities:
                    return "[F]";
                case CanadaSelectRatingType.CampingRecreation:
                    return "[R]";
                default:
                    return "";
            }
        }

        private string GetCanadaSelectAbbreviationPre2015(CanadaSelectRatingType csrt, string languageId)
        {
            switch (csrt)
            {
                case CanadaSelectRatingType.Apartment:
                    return "[CA]";
                case CanadaSelectRatingType.BedAndBreakfast:
                    return "[BB]";
                case CanadaSelectRatingType.BedAndBreakfastInn:
                    return "[BBI]";
                case CanadaSelectRatingType.CampingFacilities:
                    return "[F]";
                case CanadaSelectRatingType.CampingRecreation:
                    return "[R]";
                case CanadaSelectRatingType.CottageVacationHome:
                    return "[C]";
                case CanadaSelectRatingType.FishingHunting:
                    return "[FH]";
                case CanadaSelectRatingType.HotelMotel:
                    return "[HM]";
                case CanadaSelectRatingType.Inn:
                    return "[I]";
                case CanadaSelectRatingType.Resort:
                    return "[R]";
                case CanadaSelectRatingType.TouristHome:
                    return "[TH]";
                default:
                    return "";
            }
        }

        private string GetAccommodationTypeAbbreviation(AccommodationType at, string languageId)
        {
            switch (at)
            {
                case AccommodationType.Apartment:
                    return (languageId == "fr") ? "App" : "Apt.";
                case AccommodationType.BedAndBreakfast:
                    return (languageId == "fr") ? "Gîte" : "B&B";
                case AccommodationType.BedAndBreakfastInn:
                    return (languageId == "fr") ? "Auberge-gîte" : "B&B Inn";
                case AccommodationType.Cabin:
                    return (languageId == "fr") ? "Cabine" : "Cabin";
                case AccommodationType.Condo:
                    return (languageId == "fr") ? "Condo" : "Condo";
                case AccommodationType.Cottage:
                    return (languageId == "fr") ? "Chalet" : "Cottage";
                case AccommodationType.GuestRoom:
                    return (languageId == "fr") ? "CH" : "Guest Room";
                case AccommodationType.Hostel:
                    return (languageId == "fr") ? "Auberge de jeunesse" : "Hostel";
                case AccommodationType.Hotel:
                    return (languageId == "fr") ? "Hôtel" : "Hotel";
                case AccommodationType.Inn:
                    return (languageId == "fr") ? "Auberge" : "Inn";
                case AccommodationType.Lodge:
                    return (languageId == "fr") ? "Pavillon" : "Lodge";
                case AccommodationType.MiniHome:
                    return (languageId == "fr") ? "Maisonnette" : "Mini-home";
                case AccommodationType.Motel:
                    return (languageId == "fr") ? "Motel" : "Motel";
                case AccommodationType.Resort:
                    return (languageId == "fr") ? "Centre de villégiature" : "Resort";
                case AccommodationType.TouristHome:
                    return (languageId == "fr") ? "Chalet pour touristes" : "Tourist Home";
                case AccommodationType.DormStyle:
                    return (languageId == "fr") ? "Style dortoir" : "Dorm-style";
                case AccommodationType.VacationHome:
                    return (languageId == "fr") ? "Chalet de vacances" : "Vac. Home";
                default:
                    return (languageId == "fr") ? "" : "";
            }
        }

        private string GetTollFreeAreaLabel (TollFreeArea tfa, string languageId)
        {
            switch (tfa)
            {
                case TollFreeArea.Canada:
                    return (languageId == "fr") ? "Canada" : "Canada";
                case TollFreeArea.NorthAmerica:
                    return (languageId == "fr") ? "Amérique du Nord" : "North America";
                default:
                    return "";
            }
        }
        
        private string GetRegionTitle(Region r, string languageId)
        {
            switch (r)
            {
                case Region.BrasDor:
                    return (languageId == "fr") ? "Bras D’Or" : "Bras D’Or";
                case Region.CabotTrail:
                    return (languageId == "fr") ? "Cabot" : "Cabot";
                case Region.CeilidhTrail:
                    return (languageId == "fr") ? "Ceilidh" : "Ceilidh";
                case Region.EasternShore:
                    return (languageId == "fr") ? "Eastern Shore" : "Eastern Shore";
                case Region.FleurDeLis:
                    return (languageId == "fr") ? "Fleur-de-lis & Marconi" : "Fleur-de-lis & Marconi";
                case Region.FundyShore:
                    return (languageId == "fr") ? "Fundy Shore" : "Fundy Shore";
                case Region.HalifaxMetro:
                    return (languageId == "fr") ? "Halifax Metro" : "Halifax Metro";
                case Region.Northumberland:
                    return (languageId == "fr") ? "Northumberland" : "Northumberland";
                case Region.SouthShore:
                    return (languageId == "fr") ? "South Shore" : "South Shore";
                case Region.Yarmouth:
                    return (languageId == "fr") ? "Yarmouth" : "Yarmouth";
                default:
                    return "";
            }
        }

        private string GetOutdoorsGuideSectionTitle(GuideSectionOutdoors gst, string languageId)
        {
            switch (gst)
            {
                case GuideSectionOutdoors.Beaches:
                    return (languageId == "fr") ? "Plages surveillées" : "Supervised Beaches";
                //case GuideSectionOutdoors.BoatTours:
                //    return (languageId == "fr") ? "Croisières et forfaits" : "Boat Tours & Charters";
                case GuideSectionOutdoors.DiveShops:
                    return (languageId == "fr") ? "Plongée - boutiques" : "Dive Shops";
                case GuideSectionOutdoors.DogSledding:
                    return (languageId == "fr") ? "Promenades en traîneau à chiens" : "Dog Sledding";
                case GuideSectionOutdoors.DrivingRanges:
                    return (languageId == "fr") ? "Golf : Terrains d’exercice" : "Golf Driving Ranges";
                case GuideSectionOutdoors.EquipmentRentals:
                    return (languageId == "fr") ? "Locations" : "Equipment Rentals";
                case GuideSectionOutdoors.FishingGuides:
                    return (languageId == "fr") ? "Pêche : Guides de pêche" : "Fishing Guides";
                case GuideSectionOutdoors.FishingStockedLakes:
                    return (languageId == "fr") ? "Pêche : Lacs peuplés" : "Fishing: Stocked Lakes";
                case GuideSectionOutdoors.Flying:
                    return (languageId == "fr") ? "Pilotage" : "Flying";
                case GuideSectionOutdoors.Geocaching:
                    return (languageId == "fr") ? "Géocachette" : "Geocaching";
                case GuideSectionOutdoors.Geology:
                    return (languageId == "fr") ? "Géologie : roches, minéraux et fossiles" : "Geology: Rocks, Minerals & Fossils";
                case GuideSectionOutdoors.GolfCourses:
                    return (languageId == "fr") ? "Golf : Terrains de golf" : "Golf Courses";
                //case GuideSectionOutdoors.Hunting:
                //    return (languageId == "fr") ? "Chasse" : "Hunting";
                case GuideSectionOutdoors.NationalParks:
                    return (languageId == "fr") ? "Parcs nationaux" : "National Parks";
                case GuideSectionOutdoors.NoveltyGolf:
                    return (languageId == "fr") ? "Jeux inspirés du golf" : "Novelty Golf";
                //case GuideSectionOutdoors.Outdoor:
                //    return (languageId == "fr") ? "Excursions et aventures de plein air" : "Outdoor Adventure Tours";
                case GuideSectionOutdoors.Photography:
                    return (languageId == "fr") ? "Photographie et peinture paysagiste" : "Photography & Landscape Painting";
                case GuideSectionOutdoors.ProvincialParks:
                    return (languageId == "fr") ? "Parcs provinciaux et municipaux" : "Parks";
                case GuideSectionOutdoors.RidingHayRides:
                    return (languageId == "fr") ? "Équitation et promenades en charrette à foin" : "Riding & Hay Rides";
                case GuideSectionOutdoors.RiverRafting:
                    return (languageId == "fr") ? "Rafting" : "River Rafting";
                case GuideSectionOutdoors.SailingInstruction:
                    return (languageId == "fr") ? "Voile : Cours de voile" : "Sailing Instruction";
                case GuideSectionOutdoors.SailingLearnToSail:
                    return (languageId == "fr") ? "Voile : Des vacances pour apprendre à naviguer à voile" : "Learn-to-Sail Vacations";
                case GuideSectionOutdoors.SailingMarinas:
                    return (languageId == "fr") ? "Voile : Marinas et clubs de navigation de plaisance" : "Marinas & Yacht Clubs";
                case GuideSectionOutdoors.SkiingCrossCountry:
                    return (languageId == "fr") ? "Ski de fond" : "Skiing: Cross Country";
                case GuideSectionOutdoors.SkiingDownhill:
                    return (languageId == "fr") ? "Ski alpin" : "Skiing: Downhill";
                case GuideSectionOutdoors.AirAdventure:
                    return (languageId == "fr") ? "Parachutisme" : "Air Adventure";
                case GuideSectionOutdoors.SleighRides:
                    return (languageId == "fr") ? "Promenades en traîneau" : "Sleigh Rides";
                case GuideSectionOutdoors.Snowmobiling:
                    return (languageId == "fr") ? "Motoneige" : "Snowmobiling";
                case GuideSectionOutdoors.Snowshoeing:
                    return (languageId == "fr") ? "Raquette" : "Snowshoeing";
                case GuideSectionOutdoors.Surfing:
                    return (languageId == "fr") ? "Surf" : "Surfing";
                case GuideSectionOutdoors.WalkingHikingTrails:
                    return (languageId == "fr") ? "Sentiers pédestres" : "Hiking & Walking";
                case GuideSectionOutdoors.Ziplining:
                    return (languageId == "fr") ? "Tyrolienne" : "Ziplining";
                default:
                    return "";
            }
        }

        private string GetTourOpGuideSectionTitle(GuideSectionTourOps gstp, string languageId)
        {
            switch (gstp)
            {
                case GuideSectionTourOps.BoatToursCharters:
                    return (languageId == "fr") ? "Croisières et forfaits" : "Outdoor Tours: Boat Tours & Charters";
                case GuideSectionTourOps.Sightseeing:
                    return (languageId == "fr") ? "Visites guidées et des excursions d’un jour" : "Sightseeing & Day Tours";
                case GuideSectionTourOps.MultiDay:
                    return (languageId == "fr") ? "Excursions de plusieurs jours" : "Multi-day Tours";
                case GuideSectionTourOps.MultiactivityAdventure:
                    return (languageId == "fr") ? "Voyagistes (l’aventure multipliée)" : "Outdoor Tours: Multi-activity Adventure";
                case GuideSectionTourOps.NatureWildlife:
                    return (languageId == "fr") ? "Nature et faune" : "Outdoor Tours: Nature & Wildlife";
                case GuideSectionTourOps.OutdoorAdventure:
                    return (languageId == "fr") ? "Excursions et aventures de plein air" : "Outdoor Tours: Outdoor Adventure";
                case GuideSectionTourOps.StepOnGuide:
                    return (languageId == "fr") ? "Guides-accompagnateurs" : "Step-on Guide Services";
                case GuideSectionTourOps.Walking:
                    return (languageId == "fr") ? "Visites guidée à pied" : "Walking Tours";
                default:
                    return "";
            }
        }

        private string GetProductTypeLabel(ProductType pt)
        {
            switch (pt)
            {
                case ProductType.Accommodation:
                    return "Accommodations";
                case ProductType.Attraction:
                    return "Attractions";
                case ProductType.Campground:
                    return "Campgrounds";
                case ProductType.FineArts:
                    return "Fine Arts and Crafts";
                case ProductType.Outdoors:
                    return "Outdoors";
                case ProductType.Restaurants:
                    return "Restaurants";
                case ProductType.TourOps:
                    return "Tour Operators";
                case ProductType.Trails:
                    return "Trails";
                default:
                    return "";
            }
        }

        public ExcelPackage ExportListingsNew(Region? r, ProductType pt, string languageId)
        {
            var printExportList = new List<PrintExportVo>();

            if (pt == ProductType.Outdoors || pt == ProductType.TourOps)
            {
                var l = productBs.GetOutdoorsProductsForPrintExportNew(pt, r);

                printExportList = (from p in l
                         select new PrintExportVo
                         {
                             communityExp = (p.product.communityId != null) ? ApostrophizeSingleQuotes(p.product.refCommunity.communityName) : "",
                             productNameExp = ApostrophizeSingleQuotes(p.productName),
                             rateInfoExp = GenerateRateString(p.product, languageId),
                             symbolsExp = GenerateOutdoorSymbolString(p.product, productBs.GetProductAttributes(p.productId)),
                             canadaSelectRating1Exp = "",
                             canadaSelectRatingDivider1Exp = "",
                             canadaSelectRating2Exp = "",
                             canadaSelectRatingDivider2Exp = "",
                             nsApprovedExp = "",
                             caaRatingExp = "",
                             addressExp = GenerateAddressString(p.product),
                             telephoneExp = GenerateTelephoneString(p.product),
                             emailExp = p.product.email,
                             websiteExp = p.product.web,
                             accommodationTypeExp = "",
                             dateRangeExp = GenerateHoursStringNew(p.product, languageId),
                             adReferenceExp = GenerateAdRefString(productBs.GetProductAttributes(p.productId), languageId, ExportType.Html, ""),
                             admissionExp = "",
                             listingBodyExp = p.isCrossReference
                                 ? GenerateOutdoorCrossReferenceListingBody(p.product, productBs.GetProductAttributes(p.productId), languageId, ExportType.Print,
                                                                            p.guideSectionId)
                                 : GenerateListingBody(p.product, languageId),//GenerateListingBody(p, languageId),
                             faOpenStudioExp = "",
                             faMediaListExp = "",
                             restTypeListExp = "",
                             restSpecialtyExp = "",
                             restLicenseAndHoursExp = "",
                             outdoorCategoryExp = GenerateOutdoorCategory(p.product, languageId),
                             outdoorSymbolExp = GenerateOutdoorSymbolString(p.product, productBs.GetProductAttributes(p.productId)),
                             trailDistanceExp = "",
                             trailUsesExp = "",
                             trailHoursExp = ""
                         }).ToList();


                
            }
            else
            {
                IQueryable<Product> pq = productBs.GetProductsForPrintExport(pt, r);

                printExportList = (from p in pq
                         select new PrintExportVo
                         {
                             communityExp = ApostrophizeSingleQuotes(p.refCommunity.communityName),
                             productNameExp = ApostrophizeSingleQuotes(p.productName),
                             rateInfoExp = GenerateRateString(p, languageId),
                             symbolsExp = GenerateSymbolString(p, productBs.GetProductAttributes(p.id), languageId),
                             canadaSelectRating1Exp = GenerateCanadaSelectRatingString(p, productBs.GetProductCanadaSelectRatings(p.id), languageId, 0),
                             canadaSelectRatingDivider1Exp = GenerateCanadaSelectRatingDividerString(p, productBs.GetProductCanadaSelectRatings(p.id), languageId, 0),
                             canadaSelectRating2Exp = GenerateCanadaSelectRatingString(p, productBs.GetProductCanadaSelectRatings(p.id), languageId, 1),
                             canadaSelectRatingDivider2Exp = GenerateCanadaSelectRatingDividerString(p, productBs.GetProductCanadaSelectRatings(p.id), languageId, 1),
                             nsApprovedExp = GenerateNsApprovedString(p, productBs.GetProductAttributes(p.id)),
                             caaRatingExp = GenerateCaaRatingString(p, productBs.GetProductCaaRatings(p.id), languageId),
                             addressExp = GenerateAddressString(p),
                             telephoneExp = GenerateTelephoneString(p),
                             emailExp = p.email,
                             websiteExp = p.web,
                             accommodationTypeExp = GenerateAccommodationTypeString(p, productBs.GetProductAttributes(p.id), languageId),
                             dateRangeExp = GenerateHoursStringNew(p, languageId),
                             adReferenceExp = GenerateAdRefString(productBs.GetProductAttributes(p.id), languageId, ExportType.Html, ""),
                             admissionExp = GenerateAdmissionString(p),
                             listingBodyExp = GenerateListingBody(p, languageId),
                             faOpenStudioExp = GetExhibitTypeLabel(productBs.GetProductAttributes(p.id), languageId),
                             faMediaListExp = GenerateFineArtsMediaString(productBs.GetProductAttributes(p.id), languageId),
                             restTypeListExp = GenerateRestaurantTypeString(productBs.GetProductAttributes(p.id), languageId),
                             restSpecialtyExp = GenerateRestaurantSpecialtyString(productBs.GetProductAttributes(p.id), languageId),
                             restLicenseAndHoursExp = GenerateRestaurantLicenseAndHours(p, productBs.GetProductAttributes(p.id), languageId),
                             outdoorCategoryExp = GenerateOutdoorCategory(p, languageId),
                             outdoorSymbolExp = GenerateOutdoorSymbolString(p, productBs.GetProductAttributes(p.id)),
                             trailDistanceExp = GenerateTrailDistanceString(p),
                             trailUsesExp = GenerateTrailUses(p, productBs.GetProductAttributes(p.id)),
                             trailHoursExp = String.Format("•{0}", GenerateHoursStringNew(p, languageId))
                         }).ToList();

                
            }
            
            var firstRow = true;
            var lastCommunityName = "";

            foreach (var x in printExportList)
            {

                if ((!firstRow) && lastCommunityName == x.communityExp)
                {
                    x.communityExp = "";
                }
                else
                {
                    lastCommunityName = x.communityExp;
                }
                firstRow = false;
            }

            ExcelPackage pck = new ExcelPackage();

            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Export");

            ws.Cells["A1"].Value = "communityExp";
            ws.Cells["B1"].Value = "productNameExp";
            ws.Cells["C1"].Value = "rateInfoExp";
            ws.Cells["D1"].Value = "symbolsExp";
            ws.Cells["E1"].Value = "canadaSelectRating1Exp";
            ws.Cells["F1"].Value = "canadaSelectRatingDivider1Exp";
            ws.Cells["G1"].Value = "canadaSelectRating2Exp";
            ws.Cells["H1"].Value = "canadaSelectRatingDivider2Exp";
            ws.Cells["I1"].Value = "nsApprovedExp";
            ws.Cells["J1"].Value = "caaRatingExp";
            ws.Cells["K1"].Value = "addressExp";
            ws.Cells["L1"].Value = "telephoneExp";
            ws.Cells["M1"].Value = "emailExp";
            ws.Cells["N1"].Value = "websiteExp";
            ws.Cells["O1"].Value = "accommodationTypeExp";
            ws.Cells["P1"].Value = "dateRangeExp";
            ws.Cells["Q1"].Value = "adReferenceExp";
            ws.Cells["R1"].Value = "admissionExp";
            ws.Cells["S1"].Value = "listingBodyExp";

            ws.Cells["T1"].Value = "faOpenStudioExp";
            ws.Cells["U1"].Value = "faMediaListExp";
            ws.Cells["V1"].Value = "restTypeListExp";
            ws.Cells["W1"].Value = "restSpecialtyExp";
            ws.Cells["X1"].Value = "restLicenseAndHoursExp";
            ws.Cells["Y1"].Value = "outdoorCategoryExp";
            ws.Cells["Z1"].Value = "outdoorSymbolExp";
            ws.Cells["AA1"].Value = "trailDistanceExp";
            ws.Cells["AB1"].Value = "trailUsesExp";
            ws.Cells["AC1"].Value = "trailHoursExp";


            ws.Cells["A2"].LoadFromCollection(printExportList);

            return pck;
        }

        private string GenerateFineArtsMediaString(IQueryable<ProductAttribute> paq, string languageId)
        {
            StringBuilder sb = new StringBuilder();

            if ((from a in paq where a.attributeId == (short)Medium.BooksCards select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "livres et cartes" : "books & cards");
            }

            if ((from a in paq where a.attributeId == (short)Medium.Candles select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "bougies" : "candles");
            }

            if ((from a in paq where a.attributeId == (short)Medium.Clay select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "argile" : "clay");
            }

            if ((from a in paq where a.attributeId == (short)Medium.Fibre select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "fibres" : "fibre");
            }

            if ((from a in paq where a.attributeId == (short)Medium.Glass select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "verre" : "glass");
            }

            if ((from a in paq where a.attributeId == (short)Medium.Leather select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "cuir" : "leather");
            }

            if ((from a in paq where a.attributeId == (short)Medium.Metal select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "métal" : "metal");
            }

            if ((from a in paq where a.attributeId == (short)Medium.MultipleMedia select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "matières diverses" : "multiple media");
            }

            if ((from a in paq where a.attributeId == (short)Medium.PaintingPrints select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "tableaux et gravures" : "paintings & prints");
            }

            if ((from a in paq where a.attributeId == (short)Medium.Paper select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "papier" : "paper");
            }

            if ((from a in paq where a.attributeId == (short)Medium.Photography select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "photographie" : "photography");
            }

            if ((from a in paq where a.attributeId == (short)Medium.StoneBone select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "pierre et os" : "stone & bone");
            }

            if ((from a in paq where a.attributeId == (short)Medium.Wood select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "bois" : "wood");
            }

            string returnValue = "";

            if (sb.Length > 0)
            {
                returnValue = sb.ToString().Substring(2);
                //capitalize first letter
                returnValue = String.Format("{0}{1}", returnValue.First().ToString().ToUpper(), returnValue.Substring(1));

                returnValue = String.Format("{0}: {1}", (languageId == "fr") ? "Matière" : "Media", returnValue);
                // returnValue = (et == ExportType.Print) ? String.Format(FineArtsMediaTag, (languageId == "fr") ? "Matière" : "Media", returnValue) : returnValue;
            }

            return returnValue;
        }

        private string GenerateRestaurantTypeString(IQueryable<ProductAttribute> paq, string languageId)
        {
            StringBuilder sb = new StringBuilder();

            if ((from a in paq where a.attributeId == (short)RestaurantType.CoffeeShop select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "café" : "cafe/tea room");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantType.Continental select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "cuisine continentale" : "continental");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantType.FamilyDining select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "restaurant familial" : "family dining");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantType.FastFood select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "restauration rapide" : "fast food");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantType.FineDining select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "fine cuisine" : "fine dining");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantType.Gourmet select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "cuisine gastronomique" : "gourmet");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantType.Informal select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "sans prétention" : "informal");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantType.Lounge select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "bar-salon" : "lounge");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantType.Pub select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "pub" : "pub");
            }

            string returnValue = "";

            if (sb.Length > 0)
            {
                returnValue = sb.ToString().Substring(2);
                returnValue = String.Format("{0}{1}", returnValue.First().ToString().ToUpper(), returnValue.Substring(1));
                returnValue = String.Format("{0}: {1}", (languageId == "fr") ? "Type" : "Type", returnValue);
            }

            return returnValue;
        }

        private string GenerateListingBody(Product p, string languageId)
        {
            StringBuilder sb = new StringBuilder();

            IQueryable<PrintVersionTranslation> pvtq = productBs.GetPrintVersionTranslations(p.id);

            PrintVersionTranslation pvt = (from w in pvtq where w.languageId == languageId select w).FirstOrDefault();

            if (pvt != null && !String.IsNullOrEmpty(pvt.unitDescription))
            {
                sb.AppendFormat(" {0}", pvt.unitDescription);
            }

            if (pvt != null && !String.IsNullOrEmpty(pvt.printDescription))
            {
                sb.AppendFormat(" {0}", pvt.printDescription);
            }


            //sb.Append(GenerateSocialMediaString(p));

            //sb.Append(GenerateAdRefString(paq, languageId, et));

            return ApostrophizeSingleQuotes(sb.ToString().Trim());
        }

        public string GenerateOutdoorSymbolString(Product p, IQueryable<ProductAttribute> paq)
        {
            StringBuilder sb = new StringBuilder();

            if ((from a in paq where a.attributeId == (short)ProductCategory.EquipmentRental select a).Count() == 0)
            {
                return "";
            }
            //Birds & Wildlife, Camping, Canoeing, Cycling, Diving, Hiking, Kayaking, Skiing, Snowshoeing, Sport Fishing
            if ((from a in paq where a.attributeId == (short)Activity.Birding select a).Count() > 0)
            {
                sb.Append("Y");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Camping select a).Count() > 0)
            {
                sb.Append("|");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Canoeing select a).Count() > 0)
            {
                sb.Append("{");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Cycling select a).Count() > 0)
            {
                sb.Append("K");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Diving select a).Count() > 0)
            {
                sb.Append("D");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Hiking select a).Count() > 0)
            {
                sb.Append("L");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Kayaking select a).Count() > 0)
            {
                sb.Append("}");
            }

            if ((from a in paq where a.attributeId == (short)Activity.CrossCountrySkiing || a.attributeId == (short)Activity.DownhillSkiing select a).Count() > 0)
            {
                sb.Append("S");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Snowshoeing select a).Count() > 0)
            {
                sb.Append("y");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Fishing select a).Count() > 0)
            {
                sb.Append("f");
            }

            return sb.ToString();
        }

        private string GenerateRateString(Product p, string languageId)
        {
            StringBuilder sb = new StringBuilder();

            //if (p.PrintVersion.rateTypeId != null)
            //{
            //    sb.AppendFormat(" {0}", GetRateTypeAbbreviation((RateType)p.PrintVersion.rateTypeId, languageId));
            //}



            if (p.PrintVersion.lowRate != null && p.PrintVersion.highRate != null && p.PrintVersion.lowRate != p.PrintVersion.highRate)
            {
                sb.AppendFormat(languageId == "fr" ? " {0}–{1}$" : " ${0}–{1}", Math.Round(p.PrintVersion.lowRate.Value), Math.Round(p.PrintVersion.highRate.Value));
            }
            else if (p.PrintVersion.lowRate != null || p.PrintVersion.highRate != null)
            {
                sb.AppendFormat(languageId == "fr" ? " {0}$" : " ${0}", (p.PrintVersion.lowRate != null) ? Math.Round(p.PrintVersion.lowRate.Value) : Math.Round(p.PrintVersion.highRate.Value));
            }

            if (p.PrintVersion.ratePeriodId != null && p.PrintVersion.ratePeriodId != (int)RatePeriod.Daily)
            {
                sb.AppendFormat("{0}", GetRatePeriodAbbreviation((RatePeriod)p.PrintVersion.ratePeriodId, languageId));
            }

            if (p.PrintVersion.extraPersonRate != null)
            {
                sb.AppendFormat(languageId == "fr" ? ", ADD {0}$" : ", XP ${0}", Math.Round(p.PrintVersion.extraPersonRate.Value));
            }

            if (p.PrintVersion.noTax)
            {
                sb.AppendFormat(" {0}", (languageId == "fr") ? "; sans taxes" : "; no tax");
            }

            //if (p.PrintVersion.cancellationPolicyId != null)
            //{
            //    sb.AppendFormat("{0} {1}", sb.ToString().Substring(sb.Length - 1) != "." ? ";" : "", GetCancellationPolicyAbbreviation((CancellationPolicy)p.PrintVersion.cancellationPolicyId, languageId));
            //}

            //if (p.PrintVersion.hasOffSeasonRates)
            //{
            //    sb.AppendFormat("{0} {1}", sb.ToString().Substring(sb.Length - 1) != "." ? ";" : "", (languageId == "fr") ? "tarifs HS" : "O/S rates");
            //}

            //if (sb.Length > 0 && sb.ToString().Substring(sb.Length - 1) != ".")
            //{
            //    sb.Append(".");
            //}

            return sb.ToString();
        }

        public string GenerateRestaurantLicenseAndHours(Product p, IQueryable<ProductAttribute> paq, string languageId)
        {
            StringBuilder sb = new StringBuilder();

            if ((from a in paq where a.attributeId == (short)RestaurantService.Licensed select a).Count() > 0)
            {
                if (languageId == "en")
                {
                    sb.Append("Licensed • ");
                }
                else
                {
                    sb.Append("Avec permis d’alcool • ");
                }
                
            }

            sb.Append(GenerateHoursStringNew(p, languageId));

            return sb.ToString();
        }

        public string GenerateOutdoorCategory(Product p, string languageId)
        {
            if (p.primaryGuideSectionId != null && p.primaryGuideSectionId < 50)
            {
                return GetOutdoorsGuideSectionTitle((GuideSectionOutdoors)p.primaryGuideSectionId, languageId);
            }
            else
            {
                return "";
            }
        }

        public string GenerateTrailUses(Product p, IQueryable<ProductAttribute> paq)
        {
            if (p.productTypeId != (byte)ProductType.Trails)
            {
                return "";
            }

            StringBuilder sb = new StringBuilder();

            if ((from a in paq where a.attributeId == (short)Activity.Canoeing select a).Count() > 0)
            {
                sb.Append("{");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Kayaking select a).Count() > 0)
            {
                sb.Append("}");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Diving select a).Count() > 0)
            {
                sb.Append("D");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Fishing select a).Count() > 0)
            {
                sb.Append("f");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Sailing select a).Count() > 0)
            {
                sb.Append("b");
            }

            if ((from a in paq where a.attributeId == (short)Activity.WhaleWatching select a).Count() > 0)
            {
                sb.Append("w");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Birding select a).Count() > 0)
            {
                sb.Append("Y");
            }

            if ((from a in paq where a.attributeId == (short)AreaOfInterest.Fossils select a).Count() > 0)
            {
                sb.Append("'");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Cycling select a).Count() > 0)
            {
                sb.Append("K");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Atv select a).Count() > 0)
            {
                sb.Append(">");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Golf select a).Count() > 0)
            {
                sb.Append("G");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Hiking select a).Count() > 0)
            {
                sb.Append("L");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Sightseeing select a).Count() > 0)
            {
                sb.Append("t");
            }

            if ((from a in paq where a.attributeId == (short)Activity.CrossCountrySkiing || a.attributeId == (short)Activity.DownhillSkiing select a).Count() > 0)
            {
                sb.Append("S");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Snowmobiling select a).Count() > 0)
            {
                sb.Append("s");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Snowshoeing select a).Count() > 0)
            {
                sb.Append("y");
            }

            if ((from a in paq where a.attributeId == (short)Activity.Camping select a).Count() > 0)
            {
                sb.Append("|");
            }

            return sb.ToString();
        }

        public string GenerateTrailDistanceString(Product p)
        {
            if (p.trailDistance.HasValue)
            {
                return String.Format("{0} km", p.trailDistance.Value.ToString());
            }
            else
            {
                return "";
            }
        }

        private string GenerateRestaurantSpecialtyString(IQueryable<ProductAttribute> paq, string languageId)
        {
            StringBuilder sb = new StringBuilder();

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Acadian select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "cuisine acadienne" : "Acadian");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Canadian select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "cuisine canadienne" : "Canadian");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Asian select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "Asian" : "Asian");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.European select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "cuisine européenne" : "European");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.FishAndChips select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "poissons-frites" : "fish and chips");
            }

            //if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.German select a).Count() > 0)
            //{
            //    sb.AppendFormat(", {0}", (languageId == "fr") ? "cuisine allemande" : "German");
            //}

            //if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Italian select a).Count() > 0)
            //{
            //    sb.AppendFormat(", {0}", (languageId == "fr") ? "cuisine italienne" : "Italian");
            //}

            //if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Pasta select a).Count() > 0)
            //{
            //    sb.AppendFormat(", {0}", (languageId == "fr") ? "pâtes" : "pasta");
            //}

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.PizzaAndBurgers select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "pizza/burgers" : "pizza/burgers");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Sandwiches select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "sandwiches" : "sandwiches");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Seafood select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "fruits de mer" : "seafood");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Steaks select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "steaks" : "steaks");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Vegetarian select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "plats végétariens" : "vegetarian");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.GlutenFree select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "gluten free" : "gluten free");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Latin select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "Latin" : "Latin");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Indian select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "Indian" : "Indian");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.MiddleEastern select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "Middle Eastern" : "Middle Eastern");
            }

            if ((from a in paq where a.attributeId == (short)RestaurantSpecialty.Desserts select a).Count() > 0)
            {
                sb.AppendFormat(", {0}", (languageId == "fr") ? "desserts" : "desserts");
            }

            string returnValue = "";

            if (sb.Length > 0)
            {
                returnValue = sb.ToString().Substring(2);
                returnValue = String.Format("{0}{1}", returnValue.First().ToString().ToUpper(), returnValue.Substring(1));
                returnValue = String.Format("{0}: {1}", (languageId == "fr") ? "Spécialité" : "Specialty", returnValue);
            }

            return returnValue;
        }

        public string GenerateAccommodationTypeString(Product p, IQueryable<ProductAttribute> paq, string languageId)
        {
            StringBuilder sb = new StringBuilder();

            var q = from a in paq where a.attributeGroupId == (short)AttributeGroup.AccommodationType select a;

            foreach (var x in q)
            {
                sb.AppendFormat(", {0}", GetAccommodationTypeAbbreviation((AccommodationType)x.attributeId, languageId));
            }

            return (sb.Length > 0) ? sb.ToString().Substring(2) : "";
        }

        public string GenerateAdmissionString(Product p)
        {
            StringBuilder sb = new StringBuilder();

            var q = (from pvt in p.PrintVersionTranslations
                     where pvt.languageId == "en"
                     select pvt.rateDescription).ToList();

            //Admission column; hack for guide does the rateDescription include "$"
            var admissionChar = "";
            if ((from t in q where t.Contains("$") || t.ToUpper().Contains("ADMISSION CHARGED") select t).Count() > 0)
            {
                admissionChar = "$";
            }
            else if ((from t in q where t.Contains("donation") select t).Count() > 0)
            {
                admissionChar = "D";
            }

            return sb.Append(admissionChar).ToString();
        }

        private string GenerateHoursStringNew(Product p, string languageId)
        {
            StringBuilder sb = new StringBuilder();

            switch ((PeriodOfOperationType)p.PrintVersion.periodOfOperationTypeId)
            {
                case PeriodOfOperationType.AllYear:
                    sb.Append((languageId == "en") ? "Year-round" : "Toute l’année");
                    break;
                case PeriodOfOperationType.Seasonal:
                    sb.Append((languageId == "en") ? "Seasonal" : "En saison");
                    break;
                case PeriodOfOperationType.DateRange:
                    if (p.PrintVersion.openMonth != null && p.PrintVersion.closeMonth != null)
                    {
                        if (p.PrintVersion.openDay != null && p.PrintVersion.closeDay != null)
                        {
                            if (languageId == "en")
                            {
                                sb.AppendFormat("{0} {1}–{2} {3}", GetAbbreviatedMonthName((int)p.PrintVersion.openMonth, languageId), p.PrintVersion.openDay, GetAbbreviatedMonthName((int)p.PrintVersion.closeMonth, languageId), p.PrintVersion.closeDay);
                            }
                            else
                            {
                                sb.AppendFormat("{0} {1} au {2} {3}", (p.PrintVersion.openDay == 1) ? "1er" : p.PrintVersion.openDay.Value.ToString(), GetAbbreviatedMonthName((int)p.PrintVersion.openMonth, languageId), (p.PrintVersion.closeDay == 1) ? "1er" : p.PrintVersion.closeDay.Value.ToString(), GetAbbreviatedMonthName((int)p.PrintVersion.closeMonth, languageId));
                            
                            }
                        }
                        else
                        {
                            sb.AppendFormat(languageId == "en" ? "{0}-{1}" : "{0} au {1}",
                                            GetAbbreviatedMonthName((int)p.PrintVersion.openMonth, languageId),
                                            GetAbbreviatedMonthName((int)p.PrintVersion.closeMonth, languageId));
                        }
                    }
                    else
                    {
                        sb.Append("");
                    }
                    break;

                default:
                    break;
            }

            return sb.ToString();
        }

        public string GenerateTelephoneString(Product p)
        {
            StringBuilder sb = new StringBuilder();

            if (!String.IsNullOrEmpty(p.telephone))
            {
                sb.Append(p.telephone);
            }

            if (!String.IsNullOrEmpty(p.tollfree))
            {
                if (sb.Length > 0)
                {
                    sb.Append(", ");
                }
                //sb.Append(secondaryPhone.Replace("902-", ""));
                sb.Append(p.tollfree);
            }

            return sb.ToString();
        }


        public string GenerateCaaRatingString(Product p, IQueryable<ProductCaaRating> pcrq, string languageId)
        {
            StringBuilder sb = new StringBuilder();

            if (pcrq.Count() > 0)
            {
                for (int j = 1; j <= pcrq.First().ratingValue; j++)
                {
                    sb.Append("J");
                }
            }

            return sb.ToString();
        }

        public string GenerateCanadaSelectRatingDividerString(Product p, IQueryable<ProductCanadaSelectRating> pcsrq, string languageId, int ratingIndex)
        {
            StringBuilder sb = new StringBuilder();

            if (p.productTypeId == (byte)ProductType.Accommodation && pcsrq.Count() > 1 && ratingIndex == 0)
            {
                sb.Append("/");
            }

            if (p.productTypeId == (byte)ProductType.Campground)
            {
                var k = 0;
                foreach (var b in pcsrq)
                {
                    if (k++ != ratingIndex)
                    {
                        continue;
                    }


                    if (b.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.CampingFacilities)
                    {
                        sb.Append("[F]");
                        break;
                    }

                    if (b.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.CampingRecreation)
                    {
                        sb.Append("[R]");
                        break;
                    }
                }
            }
            return sb.ToString();
        }


        public string GenerateCanadaSelectRatingString(Product p, IQueryable<ProductCanadaSelectRating> pcsrq, string languageId, int ratingIndex)
        {
            StringBuilder sb = new StringBuilder();

            var k = 0;
            foreach (var b in pcsrq)
            {
                if (k++ != ratingIndex)
                {
                    continue;
                }

                for (int i = 0; i < (b.ratingValue - b.ratingValue % 2); i = i + 2)
                {
                    sb.Append("c");
                }

                if (b.ratingValue % 2 == 1)
                {
                    sb.Append("d");
                }

                //if (b.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.CampingFacilities)
                //{
                //    sb.Append("[F]");
                //    continue;
                //}

                //if (b.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.CampingRecreation)
                //{
                //    sb.Append("[R]");
                //    continue;
                //}
            }

            return sb.ToString();
        }

        public string GenerateNsApprovedString(Product p, IQueryable<ProductAttribute> paq)
        {
            StringBuilder sb = new StringBuilder();

            if ((from a in paq where a.attributeId == (short)ApprovedBy.NsApproved select a).Count() > 0)
            {
                sb.Append(".");
            }

            return sb.ToString();
        }



        public class PrintExportVo
        {
            public string communityExp { get; set; }
            public string productNameExp { get; set; }
            public string rateInfoExp { get; set; }
            public string symbolsExp { get; set; }
            public string canadaSelectRating1Exp { get; set; }
            public string canadaSelectRatingDivider1Exp { get; set; }
            public string canadaSelectRating2Exp { get; set; }
            public string canadaSelectRatingDivider2Exp { get; set; }
            public string nsApprovedExp { get; set; }
            public string caaRatingExp { get; set; }
            public string addressExp { get; set; }
            public string telephoneExp { get; set; }
            public string emailExp { get; set; }
            public string websiteExp { get; set; }
            public string accommodationTypeExp { get; set; }
            public string dateRangeExp { get; set; }
            public string adReferenceExp { get; set; }
            public string admissionExp { get; set; }
            public string listingBodyExp { get; set; }
            public string faOpenStudioExp { get; set; }
            public string faMediaListExp { get; set; }
            public string restTypeListExp { get; set; }
            public string restSpecialtyExp { get; set; }
            public string restLicenseAndHoursExp { get; set; }
            public string outdoorCategoryExp { get; set; }
            public string outdoorSymbolExp { get; set; }
            public string trailDistanceExp { get; set; }
            public string trailUsesExp { get; set; }
            public string trailHoursExp { get; set; }
        }
    }

    
}
    
