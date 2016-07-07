using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Linq;
using System.Xml.Xsl;
using ProductCatalogue.BusinessServices;
using ProductCatalogue.DataAccess;
using WebApplication.Utilities;
//using AttributeGroup = ProductCatalogue.DataAccess.Enumerations.AttributeGroup;
using ProductCatalogue.DataAccess.Enumerations;
using WebApplication.ValueObjects;
using Action = ProductCatalogue.DataAccess.Enumerations.Action;
using AttributeGroup = ProductCatalogue.DataAccess.Enumerations.AttributeGroup;
using MediaListItem = WebApplication.ValueObjects.ListItemVos.MediaListItem;
using LinkListItem = WebApplication.ValueObjects.ListItemVos.LinkListItem;
using ProductContactListItem = WebApplication.ValueObjects.ListItemVos.ProductContactListItem;
using VersionHistoryListItem = WebApplication.ValueObjects.ListItemVos.VersionHistoryListItem;

namespace WebApplication.Admin.Product
{
    public partial class Edit : System.Web.UI.Page
    {

        #region Global Variables/Constants
        private int _productId;

        private string _sourcePath =
            System.Web.Configuration.WebConfigurationManager.AppSettings["ManagedMediaUploadPath"] +
            System.Web.Configuration.WebConfigurationManager.AppSettings["ManagedMediaIngestSubDir"];

        private string _targetPath = System.Web.Configuration.WebConfigurationManager.AppSettings["ManagedMediaUploadPath"];

        private const string NoGeneralAreaMsg = "No general area exists for the selected community";
        #endregion

        protected string AvailableTags;
        private JavaScriptSerializer _ser = new JavaScriptSerializer();

        #region Page Events
        protected void Page_Init(object sender, EventArgs e)
        {
            ddlLinkType.DataSource = EnumerationUtils.GetLinkTypeListItems();
            ddlLinkType.DataTextField = "Text";
            ddlLinkType.DataValueField = "Value";
            ddlLinkType.DataBind();

            ddlMediaLanguage.DataSource = EnumerationUtils.GetMediaLanguageListItems();
            ddlMediaLanguage.DataTextField = "Text";
            ddlMediaLanguage.DataValueField = "Value";
            ddlMediaLanguage.DataBind();

            ddlMediaType.DataSource = EnumerationUtils.GetMediaTypeListItems();
            ddlMediaType.DataTextField = "Text";
            ddlMediaType.DataValueField = "Value";
            ddlMediaType.DataBind();

            ddlSustainabilityType.DataSource = EnumerationUtils.GetSustainabilityTypeListItems();
            ddlSustainabilityType.DataTextField = "Text";
            ddlSustainabilityType.DataValueField = "Value";
            ddlSustainabilityType.DataBind();

            ddlOwnershipType.DataSource = EnumerationUtils.GetOwnershipTypeListItems();
            ddlOwnershipType.DataTextField = "Text";
            ddlOwnershipType.DataValueField = "Value";
            ddlOwnershipType.DataBind();

            ddlCapacityType.DataSource = EnumerationUtils.GetCapacityTypeListItems();
            ddlCapacityType.DataTextField = "Text";
            ddlCapacityType.DataValueField = "Value";
            ddlCapacityType.DataBind();

            ddlCaaClass.DataSource = EnumerationUtils.GetCaaRatingListItems();
            ddlCaaClass.DataTextField = "Text";
            ddlCaaClass.DataValueField = "Value";
            ddlCaaClass.DataBind();

            ddlRateType.DataSource = EnumerationUtils.GetRateTypeListItems();
            ddlRateType.DataTextField = "Text";
            ddlRateType.DataValueField = "Value";
            ddlRateType.DataBind();

            ddlRatePeriod.DataSource = EnumerationUtils.GetRatePeriodListItems();
            ddlRatePeriod.DataTextField = "Text";
            ddlRatePeriod.DataValueField = "Value";
            ddlRatePeriod.DataBind();

            ddlCancellationPolicy.DataSource = EnumerationUtils.GetCancellationPolicyListItems();
            ddlCancellationPolicy.DataTextField = "Text";
            ddlCancellationPolicy.DataValueField = "Value";
            ddlCancellationPolicy.DataBind();

            ddlPrintRateType.DataSource = EnumerationUtils.GetRateTypeListItems();
            ddlPrintRateType.DataTextField = "Text";
            ddlPrintRateType.DataValueField = "Value";
            ddlPrintRateType.DataBind();

            ddlPrintRatePeriod.DataSource = EnumerationUtils.GetRatePeriodListItems();
            ddlPrintRatePeriod.DataTextField = "Text";
            ddlPrintRatePeriod.DataValueField = "Value";
            ddlPrintRatePeriod.DataBind();

            ddlPrintCancellationPolicy.DataSource = EnumerationUtils.GetCancellationPolicyListItems();
            ddlPrintCancellationPolicy.DataTextField = "Text";
            ddlPrintCancellationPolicy.DataValueField = "Value";
            ddlPrintCancellationPolicy.DataBind();

            //ddlProductType.DataSource = EnumerationUtils.GetProductTypeListItems();
            //ddlProductType.DataTextField = "Text";
            //ddlProductType.DataValueField = "Value";
            //ddlProductType.DataBind();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                _productId = Int32.Parse(hdnProductId.Value);
            }
            else
            {
                _productId = Int32.Parse(Request.QueryString["id"]);
                hdnProductId.Value = _productId.ToString();

                MySessionVariables.CurrentIndex.Value = MySessionVariables.ProductSearchItems.Value.IndexOf(_productId);

                btnPrevProduct.Enabled = (MySessionVariables.CurrentIndex.Value == 0) ? false : true;
                btnNextProduct.Enabled = (MySessionVariables.CurrentIndex.Value == MySessionVariables.ProductSearchItems.Value.Count - 1) ? false : true;
            }

            ProductBs productBs = new ProductBs();
            BusinessBs businessBs = new BusinessBs();
            //  CurrentProduct = accommodationBs.GetProduct(id);
            ProductCatalogue.DataAccess.Product p = productBs.GetProduct(_productId);
            ProductCatalogue.DataAccess.Contact c = businessBs.GetPrimaryContact(p);

            hdnProductTypeId.Value = p.productTypeId.ToString();

            //ProductCatalogue.DataAccess.PrintVersion pv = productBs.GetPrintVersion(id);

            if (!IsPostBack)
            {
                AvailableTags = string.Join(",", productBs.GetAllTags().Select(z => _ser.Serialize(z.tagName)).ToArray());
                hdnTags.Value = string.Join(",", productBs.GetProductTags(_productId).Select(z => z.Tag.tagName).ToArray());

                ddlListingQuality.SelectedValue = p.listingQuality.ToString();
                cbIsFeaturedListing.Checked = p.isFeatured;

                ddlCaaLevel.DataSource = EnumerationUtils.GetCaaLevelListItems((ProductType)p.productTypeId);
                ddlCaaLevel.DataTextField = "Text";
                ddlCaaLevel.DataValueField = "Value";
                ddlCaaLevel.DataBind();

                lblOnsiteContact.Text = String.Format("{0} {1}", c.firstName, c.lastName);
                lnkOnsiteContact.Attributes.Add("href", String.Format("../Contact/Edit.aspx?id={0}", c.id));
                tbProductName.Text = p.productName;
                litProductType.Text = ResourceUtils.GetProductTypeLabel((ProductType)p.productTypeId);

                tbLine1.Text = p.line1;
                tbLine2.Text = p.line2;
                tbLine3.Text = p.line3;
                //                tbCity.Text = p.city;
                tbPostalCode.Text = p.postalCode;
                tbLatitude.Text = p.latitude.ToString();
                tbLongitude.Text = p.longitude.ToString();

                cbCheckinMember.Checked = p.isCheckinMember;
                tbCheckinId.Text = p.checkInId;
                tbLicenseNumber.Text = p.licenseNumber;
                tbRegistryNumber.Text = p.registryNumber;
                
                tbOtherMemberships.Text = p.otherMemberships;
                tbSeatingCapacityInterior.Text = p.seatingCapacityInterior.ToString();
                tbSeatingCapacityExterior.Text = p.seatingCapacityExterior.ToString();
                tbParkingSpaces.Text = p.parkingSpaces.ToString();

                tbProprietor.Text = p.proprietor;
                tbEmail.Text = p.email;
                tbWeb.Text = p.web;
                tbPhone.Text = p.telephone;
                tbSecondaryPhone.Text = p.secondaryPhone;
                tbOffSeasonPhone.Text = p.offSeasonPhone;
                cbReservationsOnly.Checked = p.reservationsOnly;
                tbFax.Text = p.fax;
                tbTollFree.Text = p.tollfree;

                ddlTollFreeArea.SelectedValue = p.tollfreeAreaId.ToString();

                tbCheckboxLabel.Text = p.checkboxLabel;

                rblGuideSection.SelectedValue = (p.productTypeId == (int)ProductType.TourOps) ? ((int)ProductType.TourOps).ToString() : ((int)ProductType.Outdoors).ToString();

                lblProductStatus.Text = ResourceUtils.GetProductStatusLabel(p.isActive);
                lblValidationStatus.Text = ResourceUtils.GetValidationStatusLabel(p.isValid);
                lblErrorsOverridden.Text = ResourceUtils.GetErrorsOverwriddenLabel(p.overrideErrors);

                foreach (var csr in p.ProductCanadaSelectRatings)
                {
                    InitializeCanadaSelectRating(csr);
                }

                foreach (var psr in p.ProductCaaRatings)
                {
                    InitializeCaaRating(psr);
                }

                tbLowRate.Text = p.lowRate.ToString();
                tbHighRate.Text = p.highRate.ToString();
                tbExtraPersonRate.Text = p.extraPersonRate.ToString();

                tbTrailDistance.Text = p.trailDistance.ToString();
                tbTrailDuration.Text = p.trailDuration.ToString();

                rblPeriodOfOperation.SelectedValue = p.periodOfOperationTypeId.ToString();
                cbHasOffSeasonRates.Checked = p.hasOffSeasonRates;
                cbHasOffSeasonDates.Checked = p.hasOffSeasonDates;
                cbNoTax.Checked = p.noTax;

                ddlOpenMonth.SelectedValue = ((p.openMonth == null || p.openMonth == 0)) ? "-1" : p.openMonth.ToString();
                ddlOpenDay.SelectedValue = ((p.openDay == null || p.openDay == 0)) ? "-1" : p.openDay.ToString();
                ddlCloseMonth.SelectedValue = ((p.closeMonth == null || p.closeMonth == 0)) ? "-1" : p.closeMonth.ToString();
                ddlCloseDay.SelectedValue = ((p.closeDay == null || p.closeDay == 0)) ? "-1" : p.closeDay.ToString();

                tbPrintLowRate.Text = (p.PrintVersion == null) ? "" : p.PrintVersion.lowRate.ToString();
                tbPrintHighRate.Text = (p.PrintVersion == null) ? "" : p.PrintVersion.highRate.ToString();
                tbPrintExtraPersonRate.Text = (p.PrintVersion == null) ? "" : p.PrintVersion.extraPersonRate.ToString();

                rblPrintPeriodOfOperation.SelectedValue = (p.PrintVersion == null) ? "1" : p.PrintVersion.periodOfOperationTypeId.ToString();
                cbPrintHasOffSeasonRates.Checked = (p.PrintVersion != null && p.PrintVersion.hasOffSeasonRates);
                cbPrintHasOffSeasonDates.Checked = (p.PrintVersion != null && p.PrintVersion.hasOffSeasonDates);
                cbPrintNoTax.Checked = (p.PrintVersion != null && p.PrintVersion.noTax);

                ddlPrintOpenMonth.SelectedValue = (p.PrintVersion == null || (p.PrintVersion.openMonth == null || p.PrintVersion.openMonth == 0)) ? "-1" : p.PrintVersion.openMonth.ToString();
                ddlPrintOpenDay.SelectedValue = (p.PrintVersion == null || (p.PrintVersion.openDay == null || p.PrintVersion.openDay == 0)) ? "-1" : p.PrintVersion.openDay.ToString();
                ddlPrintCloseMonth.SelectedValue = (p.PrintVersion == null || (p.PrintVersion.closeMonth == null || p.PrintVersion.closeMonth == 0)) ? "-1" : p.PrintVersion.closeMonth.ToString();
                ddlPrintCloseDay.SelectedValue = (p.PrintVersion == null || (p.PrintVersion.closeDay == null || p.PrintVersion.closeDay == 0)) ? "-1" : p.PrintVersion.closeDay.ToString();

                IQueryable<ProductTranslation> ptl = productBs.GetProductTranslations(p.id);


                IQueryable<ProductTranslation> enPt = from item in ptl
                                                      where item.languageId == "en"
                                                      select item;

                IQueryable<ProductTranslation> frPt = from item in ptl
                                                      where item.languageId == "fr"
                                                      select item;

                if (enPt.Count() > 0)
                {

                    tbWebDateDescriptionEn.Text = enPt.First().dateDescription;
                    tbWebDirectionsEn.Text = enPt.First().directions;
                    tbWebKeywordsEn.Text = enPt.First().keywords;
                    tbWebRateDescriptionEn.Text = enPt.First().rateDescription;
                    tbWebDescriptionEn.Text = enPt.First().webDescription;
                    tbWebCancellationPolicyEn.Text = enPt.First().cancellationPolicy;
                }


                if (frPt.Count() > 0)
                {
                    tbWebDateDescriptionFr.Text = frPt.First().dateDescription;
                    tbWebDirectionsFr.Text = frPt.First().directions;
                    tbWebKeywordsFr.Text = frPt.First().keywords;
                    tbWebRateDescriptionFr.Text = frPt.First().rateDescription;
                    tbWebDescriptionFr.Text = frPt.First().webDescription;
                    tbWebCancellationPolicyFr.Text = frPt.First().cancellationPolicy;
                }

                IQueryable<PrintVersionTranslation> pvt = productBs.GetPrintVersionTranslations(p.id);


                IQueryable<PrintVersionTranslation> enPvt = from item in pvt
                                                            where item.languageId == "en"
                                                            select item;

                IQueryable<PrintVersionTranslation> frPvt = from item in pvt
                                                            where item.languageId == "fr"
                                                            select item;

                if (enPvt.Count() > 0)
                {
                    tbPrintDateDescriptionEn.Text = enPvt.First().dateDescription;
                    tbPrintDirectionsEn.Text = enPvt.First().directions;
                    tbPrintDescriptionEn.Text = enPvt.First().printDescription;
                    tbPrintRateDescriptionEn.Text = enPvt.First().rateDescription;
                    tbPrintUnitDescriptionEn.Text = enPvt.First().unitDescription;
                }


                if (frPvt.Count() > 0)
                {
                    tbPrintDateDescriptionFr.Text = frPvt.First().dateDescription;
                    tbPrintDirectionsFr.Text = frPvt.First().directions;
                    tbPrintDescriptionFr.Text = frPvt.First().printDescription;
                    tbPrintRateDescriptionFr.Text = frPvt.First().rateDescription;
                    tbPrintUnitDescriptionFr.Text = frPvt.First().unitDescription;
                }

                ddlAccessCanadaRating.SelectedValue = (p.accessCanadaRating == null) ? "" : p.accessCanadaRating.ToString();

                //ddlProductType.SelectedValue = p.productTypeId.ToString();
                ddlRateType.SelectedValue = (p.rateTypeId == null) ? "-1" : p.rateTypeId.ToString();
                ddlRatePeriod.SelectedValue = (p.ratePeriodId == null) ? "-1" : p.ratePeriodId.ToString();
                ddlCancellationPolicy.SelectedValue = (p.cancellationPolicyId == null) ? "-1" : p.cancellationPolicyId.ToString();
                ddlPrintRateType.SelectedValue = (p.PrintVersion == null || p.PrintVersion.rateTypeId == null) ? "-1" : p.PrintVersion.rateTypeId.ToString();
                ddlPrintRatePeriod.SelectedValue = (p.PrintVersion == null || p.PrintVersion.ratePeriodId == null) ? "-1" : p.PrintVersion.ratePeriodId.ToString();
                ddlPrintCancellationPolicy.SelectedValue = (p.PrintVersion == null || p.PrintVersion.cancellationPolicyId == null) ? "-1" : p.PrintVersion.cancellationPolicyId.ToString();
                ddlSustainabilityType.SelectedValue = (p.sustainabilityTypeId == null) ? "" : p.sustainabilityTypeId.ToString();
                ddlOwnershipType.SelectedValue = (p.ownershipTypeId == null) ? "" : p.ownershipTypeId.ToString();
                ddlCapacityType.SelectedValue = (p.capacityTypeId == null) ? "" : p.capacityTypeId.ToString();

                cbTicketed.Checked = p.isTicketed;
                cbIsActive.Checked = p.isActive;
                cbIsComplete.Checked = p.isComplete;
                cbOverrideErrors.Checked = p.overrideErrors;

                tbConfirmationDueDate.Text = (p.confirmationDueDate != null) ? p.confirmationDueDate.Value.ToString("dd-MM-yyyy") : "";
                tbConfirmationLastReceived.Text = (p.confirmationLastReceived != null) ? p.confirmationLastReceived.Value.ToString("dd-MM-yyyy") : "";

                tbAttendance.Text = p.attendance.ToString();

                tbPaymentAmount.Text = p.paymentAmount.ToString();
                cbPaymentReceived.Checked = p.paymentReceived;

                ddlCommunity.DataSource = productBs.GetAllCommunities();
                ddlCommunity.DataTextField = "interfaceName";
                ddlCommunity.DataValueField = "id";
                ddlCommunity.SelectedValue = p.communityId.ToString();
                ddlCommunity.DataBind();

                litSubRegion.Text = (p.communityId != null && p.refCommunity.subRegionId != null) ? p.refCommunity.refSubRegion.subRegionName : NoGeneralAreaMsg;

                GenerateContactList();
                GenerateMediaList();
                GenerateLinkList();
                GenerateOperationalPeriodList(_productId);
                GenerateProductVersionList();
                GenerateNoteList();
                GenerateSupplementalDescriptionList();

                //Transportation products do not appear in the guide
                if (p.productTypeId != (int)ProductType.Transportation)
                {
                    GeneratePrintPreview();    
                }
                
                InitializeTranslationMarks();
                InitializeRegions();
                InitializeUnitNumbers(p);

                if (p.communityId != null)
                {
                    InitializeCommunityParentRegion(p.refCommunity.regionId);
                }

                InitializePaymentTypes();

                //List<ProductCatalogue.DataAccess.ProductAttribute> pal;
                IQueryable<ProductCatalogue.DataAccess.ProductAttribute> paq;
                List<CheckBox> cbl;

                //pal = productBs.GetProductAttributes(_productId).ToList();
                paq = productBs.GetProductAttributes(_productId);
                foreach (var jus in paq)
                {
                    string name = String.Format("cbAtt{0}_{1}", jus.attributeGroupId, jus.attributeId);
                    Control ac = this.Master.FindControl("cphMainContent").FindControl(name);
                    CheckBox cb = (CheckBox)ac;
                    if (cb != null)
                    {
                        cb.Checked = true;
                    }
                }

                //
                InitializeExhibitType(paq);

                if (String.IsNullOrEmpty(p.fileMakerId))
                {
                    lnkViewFileMakerCommentArchive.Visible = false;
                    lnkViewFileMakerHistoryArchive.Visible = false;
                }
            }
        }

        #endregion
        
        #region Product Data Initialization Methods
        private void InitializeExhibitType(IQueryable<ProductCatalogue.DataAccess.ProductAttribute> paq)
        {
            var i = (from a in paq where a.attributeGroupId == (int)AttributeGroup.ExhibitType select a).FirstOrDefault();

            if (i != null)
            {
                ddlExhibitType.SelectedValue = i.attributeId.ToString();
            }
        }

        private void InitializePaymentTypes()
        {
            ProductBs productBs = new ProductBs();
            IQueryable<ProductPaymentType> ptq = productBs.GetProductPaymentTypes(_productId);

            cbPaymentTypeAmex.Checked = (from item in ptq where item.paymentTypeId == (int)PaymentType.AmericanExpress select item).Count() != 0;
            cbPaymentTypeCashOnly.Checked = (from item in ptq where item.paymentTypeId == (int)PaymentType.CashOnly select item).Count() != 0;
            cbPaymentTypeDebitCard.Checked = (from item in ptq where item.paymentTypeId == (int)PaymentType.DebitCard select item).Count() != 0;
            cbPaymentTypeDiners.Checked = (from item in ptq where item.paymentTypeId == (int)PaymentType.DinersClub select item).Count() != 0;
            cbPaymentTypeDiscover.Checked = (from item in ptq where item.paymentTypeId == (int)PaymentType.Discover select item).Count() != 0;
            cbPaymentTypeMasterCard.Checked = (from item in ptq where item.paymentTypeId == (int)PaymentType.Mastercard select item).Count() != 0;
            cbPaymentTypePayPal.Checked = (from item in ptq where item.paymentTypeId == (int)PaymentType.PayPal select item).Count() != 0;
            cbPaymentTypeVisa.Checked = (from item in ptq where item.paymentTypeId == (int)PaymentType.Visa select item).Count() != 0;
            cbPaymentTypeJcb.Checked = (from item in ptq where item.paymentTypeId == (int)PaymentType.Jcb select item).Count() != 0;
            //  cbPaymentTypeTravellersCheques.Checked = (from item in ptq where item.paymentTypeId == (int)PaymentType.TravellersCheques select item).Count() != 0;

        }

        private void InitializeTranslationMarks()
        {
            ProductBs productBs = new ProductBs();
            IQueryable<TranslationStatus> tsq = productBs.GetTranslationStatus(_productId);

            cbTransMarkWebDescription.Checked = (from item in tsq where item.fieldId == (int)ProductField.WebDescription select item).Count() != 0;
            cbTransMarkWebDirections.Checked = (from item in tsq where item.fieldId == (int)ProductField.WebDateDescription select item).Count() != 0;
            cbTransMarkPrintDirections.Checked = (from item in tsq where item.fieldId == (int)ProductField.PrintDirections select item).Count() != 0;
            cbTransMarkWebDirections.Checked = (from item in tsq where item.fieldId == (int)ProductField.WebDirections select item).Count() != 0;
            cbTransMarkWebKeywords.Checked = (from item in tsq where item.fieldId == (int)ProductField.WebKeywords select item).Count() != 0;
            cbTransMarkPrintDescription.Checked = (from item in tsq where item.fieldId == (int)ProductField.PrintDescription select item).Count() != 0;
            cbTransMarkPrintUnit.Checked = (from item in tsq where item.fieldId == (int)ProductField.PrintUnitDescription select item).Count() != 0;
            cbTransMarkWebDate.Checked = (from item in tsq where item.fieldId == (int)ProductField.WebDateDescription select item).Count() != 0;
            cbTransMarkWebRate.Checked = (from item in tsq where item.fieldId == (int)ProductField.WebRateDescription select item).Count() != 0;
            cbTransMarkPrintDate.Checked = (from item in tsq where item.fieldId == (int)ProductField.PrintDateDescription select item).Count() != 0;
            cbTransMarkPrintRate.Checked = (from item in tsq where item.fieldId == (int)ProductField.PrintRateDescription select item).Count() != 0;
            cbTransMarkWebCancellationPolicy.Checked = (from item in tsq where item.fieldId == (int)ProductField.WebCancellationPolicy select item).Count() != 0;
        }

        private void InitializeCaaRating(ProductCaaRating pcr)
        {
            if (pcr.caaRatingTypeId != (int)CaaRatingType.Campground)
            {
                ddlCaaClass.SelectedValue = pcr.caaRatingTypeId.ToString();
            }

            ddlCaaLevel.SelectedValue = pcr.ratingValue.ToString();
        }

        private void InitializeCanadaSelectRating(ProductCanadaSelectRating csr)
        {
            switch (csr.canadaSelectRatingTypeId)
            {
                case ((int)CanadaSelectRatingType.Apartment):
                    ddlRatingApartment.SelectedValue = csr.ratingValue.ToString();
                    break;
                case ((int)CanadaSelectRatingType.BedAndBreakfast):
                    ddlRatingBedAndBreakfast.SelectedValue = csr.ratingValue.ToString();
                    break;
                case ((int)CanadaSelectRatingType.TouristHome):
                    ddlRatingTouristHome.SelectedValue = csr.ratingValue.ToString();
                    break;
                case ((int)CanadaSelectRatingType.BedAndBreakfastInn):
                    ddlRatingBedAndBreakfastInn.SelectedValue = csr.ratingValue.ToString();
                    break;
                case ((int)CanadaSelectRatingType.CottageVacationHome):
                    ddlRatingCottage.SelectedValue = csr.ratingValue.ToString();
                    break;
                case ((int)CanadaSelectRatingType.HotelMotel):
                    ddlRatingHotelMotel.SelectedValue = csr.ratingValue.ToString();
                    break;
                case ((int)CanadaSelectRatingType.Inn):
                    ddlRatingInn.SelectedValue = csr.ratingValue.ToString();
                    break;
                case ((int)CanadaSelectRatingType.Resort):
                    ddlRatingResort.SelectedValue = csr.ratingValue.ToString();
                    break;
                case ((int)CanadaSelectRatingType.FishingHunting):
                    ddlRatingFishing.SelectedValue = csr.ratingValue.ToString();
                    break;
                case ((int)CanadaSelectRatingType.CampingFacilities):
                    ddlRatingFacilities.SelectedValue = csr.ratingValue.ToString();
                    break;
                case ((int)CanadaSelectRatingType.CampingRecreation):
                    ddlRatingRecreation.SelectedValue = csr.ratingValue.ToString();
                    break;
                case ((int)CanadaSelectRatingType.Suite):
                    ddlRatingSuite.SelectedValue = csr.ratingValue.ToString();
                    break;
                case ((int)CanadaSelectRatingType.University):
                    ddlRatingUniversity.SelectedValue = csr.ratingValue.ToString();
                    break;
                case ((int)CanadaSelectRatingType.Hostel):
                    ddlRatingHostel.SelectedValue = csr.ratingValue.ToString();
                    break;
                default:
                    break;
            }

        }

        private void InitializeUnitNumbers(ProductCatalogue.DataAccess.Product p)
        {
            //only used for accommodations and campgrounds
            if (p.productTypeId != (int)ProductType.Accommodation && p.productTypeId != (int)ProductType.Campground)
            {
                return;
            }

            ProductBs productBs = new ProductBs();
            IQueryable<ProductUnitNumber> punq = productBs.GetProductUnitNumbers(p.id);

            foreach (Control c in pnlProductAttributes.Controls)
            {
                if (c.GetType() == typeof(TextBox))
                {
                    TextBox tb = (TextBox)c;
                    if (tb.ID.Substring(0, 7) == "tbUnits")
                    {
                        var typeId = byte.Parse(tb.ID.Substring(7));

                        if ((from item in punq where item.unitTypeId == typeId select item).Count() != 0)
                        {
                            tb.Text =
                                (from item in punq where item.unitTypeId == typeId select item).First().units.
                                    ToString();
                        }
                    }
                }
            }
        }

        private void GeneratePrintPreview()
        {

            ExportBs exportBs = new ExportBs();

            XDocument xdoc = exportBs.GenerateFormXml(null, null, _productId);

            XmlReader read = xdoc.CreateReader();

            StringBuilder sb = new StringBuilder();

            var sw = new StringWriter();

            XmlWriterSettings settings = new XmlWriterSettings();
            settings.OmitXmlDeclaration = true;
            settings.ConformanceLevel = ConformanceLevel.Fragment;
            settings.CheckCharacters = false;
            settings.CloseOutput = false;

            using (var xw = XmlWriter.Create(sw, settings))
            {
                // Build Xml with xw.XmlWriterSettings settings = new XmlWriterSettings();
                XslCompiledTransform xsl = new XslCompiledTransform();

                xsl.Load(Server.MapPath("/Templates/PrintPreview.xslt"));
                xsl.Transform(read, xw);
            }

            litPrintPreview.Text = sw.ToString();
        }

        private void GenerateProductVersionList()
        {
            ProductBs productBs = new ProductBs();
            List<ProductCatalogue.DataAccess.VersionHistory> vhl = productBs.GetProductVersions(_productId).ToList();

            List<VersionHistoryListItem> vhlil = new List<VersionHistoryListItem>();

            foreach (VersionHistory vh in vhl)
            {
                VersionHistoryListItem vhli = new VersionHistoryListItem();
                vhli.modificationDate = vh.modificationDate;
                vhli.modifiedBy = vh.modifiedBy;

                vhli.typeId = ResourceUtils.GetVersionHistoryTypeLabel((VersionHistoryType)vh.typeId);
                vhli.actionId = ResourceUtils.GetActionLabel((Action)vh.actionId);
                vhli.versionId = vh.id.ToString();

                vhlil.Add(vhli);
            }

            rptProductVersion.DataSource = vhlil;
            rptProductVersion.DataBind();

        }


        #endregion

        #region Product Data Processing Methods

        protected void lbDeleteProduct_onClick(object sender, EventArgs e)
        {
            ProductBs productBs = new ProductBs();
            productBs.DeleteProduct(_productId, HttpContext.Current.User.Identity.Name);

            Response.Redirect("Index.aspx");
        }

        private void ProcessPrintVersionData()
        {
            ProductBs productBs = new ProductBs();
            PrintVersion pv = productBs.GetPrintVersion(_productId);

            decimal myDecimal;
            byte myByte;

            decimal? highRate = decimal.TryParse(tbPrintHighRate.Text, out myDecimal) ? myDecimal : (decimal?)null;
            decimal? lowRate = decimal.TryParse(tbPrintLowRate.Text, out myDecimal) ? myDecimal : (decimal?)null;
            decimal? extraPersonRate = decimal.TryParse(tbPrintExtraPersonRate.Text, out myDecimal) ? myDecimal : (decimal?)null;
            byte? openMonth = (byte.TryParse(ddlPrintOpenMonth.SelectedValue, out myByte)) ? myByte : (byte?)null;
            byte? openDay = (byte.TryParse(ddlPrintOpenDay.SelectedValue, out myByte)) ? myByte : (byte?)null;
            byte? closeMonth = (byte.TryParse(ddlPrintCloseMonth.SelectedValue, out myByte)) ? myByte : (byte?)null;
            byte? closeDay = (byte.TryParse(ddlPrintCloseDay.SelectedValue, out myByte)) ? myByte : (byte?)null;
            byte? cancellationPolicyId = (byte.TryParse(ddlPrintCancellationPolicy.SelectedValue, out myByte)) ? myByte : (byte?)null;
            byte? ratePeriodId = (byte.TryParse(ddlPrintRatePeriod.SelectedValue, out myByte)) ? myByte : (byte?)null;
            byte? rateTypeId = (byte.TryParse(ddlPrintRateType.SelectedValue, out myByte)) ? myByte : (byte?)null;
            bool hasOffSeasonRates = cbPrintHasOffSeasonRates.Checked;
            bool hasOffSeasonDates = cbPrintHasOffSeasonDates.Checked;
            byte periodOfOperation = byte.Parse(rblPrintPeriodOfOperation.SelectedValue);
            bool rateIncludesTax = cbPrintNoTax.Checked;

            if (pv == null)
            {
                productBs.AddPrintVersion(_productId, highRate, lowRate, extraPersonRate, openMonth, openDay, closeMonth, closeDay,
                                          hasOffSeasonRates, hasOffSeasonDates, periodOfOperation, cancellationPolicyId, rateIncludesTax,
                                          ratePeriodId, rateTypeId);

            }
            else
            {
                pv.highRate = highRate;
                pv.lowRate = lowRate;
                pv.extraPersonRate = extraPersonRate;
                pv.openMonth = openMonth;
                pv.openDay = openDay;
                pv.closeMonth = closeMonth;
                pv.closeDay = closeDay;
                pv.cancellationPolicyId = cancellationPolicyId;
                pv.ratePeriodId = ratePeriodId;
                pv.rateTypeId = rateTypeId;
                pv.hasOffSeasonRates = hasOffSeasonRates;
                pv.hasOffSeasonDates = hasOffSeasonDates;
                pv.periodOfOperationTypeId = periodOfOperation;
                pv.noTax = rateIncludesTax;
            }

            productBs.Save();

        }

        private void ProcessTranslationMarkCheckbox(int? secondaryId, CheckBox cb, ProductField pf, IQueryable<TranslationStatus> tsq)
        {
            ProductBs productBs = new ProductBs();

            if (cb.Checked && (from item in tsq where item.fieldId == (int)pf select item).Count() == 0)
            {
                productBs.AddTranslationStatus(_productId, pf, secondaryId);
            }
            else if (!cb.Checked && (from item in tsq where item.fieldId == (int)pf select item).Count() != 0)
            {
                productBs.DeleteTranslationStatus(_productId, pf, secondaryId);
            }
        }

        private void ProcessPaymentTypeCheckbox(CheckBox cb, PaymentType pt, IQueryable<ProductPaymentType> ptq)
        {
            ProductBs productBs = new ProductBs();

            if (cb.Checked && (from item in ptq where item.paymentTypeId == (byte)pt select item).Count() == 0)
            {
                productBs.AddProductPaymentType(_productId, (byte)pt);
            }
            else if (!cb.Checked && (from item in ptq where item.paymentTypeId == (byte)pt select item).Count() != 0)
            {
                productBs.DeleteProductPaymentType(_productId, (byte)pt);
            }

        }

        private void ProcessProductAttributes(ProductCatalogue.DataAccess.Product p)
        {
            ProductBs productBs = new ProductBs();

            productBs.DeleteProductAttributes(p);
            ProcessPanelProductAttributes(p, pnlProductAttributes);
            ProcessPanelProductAttributes(p, pnlEditorAttributes);
            ProcessPanelProductAttributes(p, pnlCoordinateEditChecks);

            ProcessExhibitTypeAttribute(p);
        }

        private void ProcessExhibitTypeAttribute(ProductCatalogue.DataAccess.Product p)
        {
            ProductBs productBs = new ProductBs();

            if (ddlExhibitType.SelectedValue != "")
            {
                productBs.CreateProductAttribute(p, (int)(AttributeGroup.ExhibitType), short.Parse(ddlExhibitType.SelectedValue));
            }
        }

        private void ProcessPanelProductAttributes(ProductCatalogue.DataAccess.Product p, Panel panel)
        {
            ProductBs productBs = new ProductBs();

            foreach (Control c in panel.Controls)
            {
                if (c.GetType() == typeof(CheckBox))
                {
                    CheckBox cb = (CheckBox)c;
                    if (cb.Checked && cb.ID.Substring(0, 5) == "cbAtt")
                    {
                        string[] a = c.ID.Split('_');
                        byte groupId = byte.Parse(a[0].Substring(5));
                        short attributeId = short.Parse(a[1]);
                        productBs.CreateProductAttribute(p, groupId, attributeId);
                    }
                }
            }
        }

        private void ProcessUnitNumbers(ProductCatalogue.DataAccess.Product p)
        {
            //only used for accommodations and campgrounds
            if (p.productTypeId != (int)ProductType.Accommodation && p.productTypeId != (int)ProductType.Campground)
            {
                return;
            }

            ProductBs productBs = new ProductBs();

            productBs.DeleteUnitNumbers(p);

            foreach (Control c in pnlProductAttributes.Controls)
            {
                if (c.GetType() == typeof(TextBox))
                {
                    TextBox tb = (TextBox)c;
                    if (tb.ID.Substring(0, 7) == "tbUnits" && tb.Text != "")
                    {
                        var typeId = byte.Parse(tb.ID.Substring(7));
                        var unitNumber = Int32.Parse(tb.Text);

                        productBs.CreateProductUnitNumber(p, typeId, unitNumber);
                    }
                }
            }

        }

        private void ProcessTags(ProductCatalogue.DataAccess.Product p)
        {
            ProductBs productBs = new ProductBs();

            productBs.DeleteProductTags(p);

            //var masterTagList = productBs.GetAllTags();

            var productTags = hdnTags.Value.Split(',').ToList();
        
            foreach (var t in productTags)
            {
                productBs.CreateProductTag(p.id, t);
            }

            productBs.Save();
        }

        private void UpdatePrintVersionTranslations()
        {
            ProductBs productBs = new ProductBs();
            IQueryable<PrintVersionTranslation> pvt = productBs.GetPrintVersionTranslations(_productId);


            IQueryable<PrintVersionTranslation> enPvt = from item in pvt
                                                        where item.languageId == "en"
                                                        select item;

            IQueryable<PrintVersionTranslation> frPvt = from item in pvt
                                                        where item.languageId == "fr"
                                                        select item;

            if (enPvt.Count() > 0)
            {
                enPvt.First().dateDescription = tbPrintDateDescriptionEn.Text;
                enPvt.First().directions = tbPrintDirectionsEn.Text;
                enPvt.First().printDescription = tbPrintDescriptionEn.Text;
                enPvt.First().rateDescription = tbPrintRateDescriptionEn.Text;
                enPvt.First().unitDescription = tbPrintUnitDescriptionEn.Text;
            }
            else
            {
                productBs.AddPrintVersionTranslation(_productId, "en", tbPrintDateDescriptionEn.Text, tbPrintDirectionsEn.Text,
                                                     tbPrintDescriptionEn.Text, tbPrintRateDescriptionEn.Text, tbPrintUnitDescriptionEn.Text);
            }

            if (frPvt.Count() > 0)
            {
                frPvt.First().dateDescription = tbPrintDateDescriptionFr.Text;
                frPvt.First().directions = tbPrintDirectionsFr.Text;
                frPvt.First().printDescription = tbPrintDescriptionFr.Text;
                frPvt.First().rateDescription = tbPrintRateDescriptionFr.Text;
                frPvt.First().unitDescription = tbPrintUnitDescriptionFr.Text;
            }
            else
            {
                productBs.AddPrintVersionTranslation(_productId, "fr", tbPrintDateDescriptionFr.Text, tbPrintDirectionsFr.Text,
                                                     tbPrintDescriptionFr.Text, tbPrintRateDescriptionFr.Text, tbPrintUnitDescriptionFr.Text);
            }
            productBs.Save();
        }

        private void UpdateProductTranslations()
        {
            ProductBs productBs = new ProductBs();
            IQueryable<ProductTranslation> ptl = productBs.GetProductTranslations(_productId);


            IQueryable<ProductTranslation> enPt = from item in ptl
                                                  where item.languageId == "en"
                                                  select item;

            IQueryable<ProductTranslation> frPt = from item in ptl
                                                  where item.languageId == "fr"
                                                  select item;

            if (enPt.Count() > 0)
            {
                enPt.First().dateDescription = tbWebDateDescriptionEn.Text;
                enPt.First().directions = tbWebDirectionsEn.Text;
                enPt.First().keywords = tbWebKeywordsEn.Text;
                enPt.First().rateDescription = tbWebRateDescriptionEn.Text;
                enPt.First().webDescription = tbWebDescriptionEn.Text;
                enPt.First().cancellationPolicy = tbWebCancellationPolicyEn.Text;
            }
            else
            {
                productBs.AddProductTranslation(_productId, "en", tbWebDateDescriptionEn.Text, tbWebDirectionsEn.Text,
                                                tbWebKeywordsEn.Text, tbWebRateDescriptionEn.Text, tbWebDescriptionEn.Text, tbWebCancellationPolicyEn.Text);
            }


            if (frPt.Count() > 0)
            {
                frPt.First().dateDescription = tbWebDateDescriptionFr.Text;
                frPt.First().directions = tbWebDirectionsFr.Text;
                frPt.First().keywords = tbWebKeywordsFr.Text;
                frPt.First().rateDescription = tbWebRateDescriptionFr.Text;
                frPt.First().webDescription = tbWebDescriptionFr.Text;
                frPt.First().cancellationPolicy = tbWebCancellationPolicyFr.Text;

            }
            else if (tbWebDateDescriptionFr.Text != "" || tbWebDirectionsFr.Text != "" || tbWebKeywordsFr.Text != "" || tbWebRateDescriptionFr.Text != "" || tbWebDescriptionFr.Text != "" || tbWebCancellationPolicyFr.Text != "")
            {
                productBs.AddProductTranslation(_productId, "fr", tbWebDateDescriptionFr.Text, tbWebDirectionsFr.Text,
                                                tbWebKeywordsFr.Text, tbWebRateDescriptionFr.Text, tbWebDescriptionFr.Text, tbWebCancellationPolicyFr.Text);
            }

            productBs.Save();
        }

        private void UpdateProduct()
        {
            ProductBs productBs = new ProductBs();
            ProductCatalogue.DataAccess.Product p = productBs.GetProduct(_productId);

            p.productName = tbProductName.Text;
            //p.productTypeId = Int32.Parse(ddlProductType.SelectedValue);

            p.line1 = tbLine1.Text;
            p.line2 = tbLine2.Text;
            p.line3 = tbLine3.Text;
            //      p.city = tbCity.Text;
            p.communityId = (ddlCommunity.SelectedValue == "") ? (short?)null : short.Parse(ddlCommunity.SelectedValue);

            p.postalCode = (tbPostalCode.Text.Length == 6) ? String.Format("{0} {1}", tbPostalCode.Text.Substring(0, 3), tbPostalCode.Text.Substring(3, 3)) : tbPostalCode.Text;

            p.proprietor = tbProprietor.Text;
            p.email = tbEmail.Text;
            if (!String.IsNullOrEmpty(tbWeb.Text) && Regex.IsMatch(tbWeb.Text.Trim().ToLower(), "^https?://"))
                p.web = tbWeb.Text.Trim();
            else
                p.web = String.IsNullOrEmpty(tbWeb.Text) ? "" : String.Concat("http://", tbWeb.Text.Trim());
            p.telephone = tbPhone.Text;
            p.secondaryPhone = tbSecondaryPhone.Text;
            p.offSeasonPhone = tbOffSeasonPhone.Text;
            p.tollfree = tbTollFree.Text;
            p.tollfreeAreaId = (ddlTollFreeArea.SelectedValue == "") ? (byte?)null : byte.Parse(ddlTollFreeArea.SelectedValue);
            p.reservationsOnly = cbReservationsOnly.Checked;

            p.fax = tbFax.Text;
            p.checkInId = tbCheckinId.Text;
            p.isCheckinMember = cbCheckinMember.Checked;
            p.checkboxLabel = tbCheckboxLabel.Text;
            p.licenseNumber = tbLicenseNumber.Text;
            p.registryNumber = tbRegistryNumber.Text;
            p.otherMemberships = tbOtherMemberships.Text;
            p.accessCanadaRating = (ddlAccessCanadaRating.SelectedValue == "") ? (byte?)null : Byte.Parse(ddlAccessCanadaRating.SelectedValue);

            p.hasOffSeasonRates = cbHasOffSeasonRates.Checked;
            p.hasOffSeasonDates = cbHasOffSeasonDates.Checked;

            p.periodOfOperationTypeId = byte.Parse(rblPeriodOfOperation.SelectedValue);
            p.noTax = cbNoTax.Checked;

            p.primaryGuideSectionId = (ddlPrimaryGuideSection.SelectedValue == "") ? (byte?)null : byte.Parse(ddlPrimaryGuideSection.SelectedValue);

            decimal myDecimal;
            byte myByte;
            short myShort;
            int myInteger;

            p.listingQuality = (byte.TryParse(ddlListingQuality.SelectedValue, out myByte)) ? myByte : (byte?)null;
            p.isFeatured = cbIsFeaturedListing.Checked;

            p.seatingCapacityInterior = short.TryParse(tbSeatingCapacityInterior.Text, out myShort) ? myShort : (short?)null;
            p.seatingCapacityExterior = short.TryParse(tbSeatingCapacityExterior.Text, out myShort) ? myShort : (short?)null;
            p.parkingSpaces = short.TryParse(tbParkingSpaces.Text, out myShort) ? myShort : (short?)null;

            p.latitude = decimal.TryParse(tbLatitude.Text, out myDecimal) ? myDecimal : (decimal?)null;
            p.longitude = decimal.TryParse(tbLongitude.Text, out myDecimal) ? myDecimal : (decimal?)null;

            p.highRate = decimal.TryParse(tbHighRate.Text, out myDecimal) ? myDecimal : (decimal?)null;
            p.lowRate = decimal.TryParse(tbLowRate.Text, out myDecimal) ? myDecimal : (decimal?)null;
            p.extraPersonRate = decimal.TryParse(tbExtraPersonRate.Text, out myDecimal) ? myDecimal : (decimal?)null;

            p.trailDistance = decimal.TryParse(tbTrailDistance.Text, out myDecimal) ? myDecimal : (decimal?)null;
            p.trailDuration = decimal.TryParse(tbTrailDuration.Text, out myDecimal) ? myDecimal : (decimal?)null;

            p.openMonth = (byte.TryParse(ddlOpenMonth.SelectedValue, out myByte)) ? myByte : (byte?)null;
            p.openDay = (byte.TryParse(ddlOpenDay.SelectedValue, out myByte)) ? myByte : (byte?)null;
            p.closeMonth = (byte.TryParse(ddlCloseMonth.SelectedValue, out myByte)) ? myByte : (byte?)null;
            p.closeDay = (byte.TryParse(ddlCloseDay.SelectedValue, out myByte)) ? myByte : (byte?)null;
            p.cancellationPolicyId = (byte.TryParse(ddlCancellationPolicy.SelectedValue, out myByte)) ? myByte : (byte?)null;
            p.ratePeriodId = (byte.TryParse(ddlRatePeriod.SelectedValue, out myByte)) ? myByte : (byte?)null;
            p.rateTypeId = (byte.TryParse(ddlRateType.SelectedValue, out myByte)) ? myByte : (byte?)null;
            p.ownershipTypeId = (byte.TryParse(ddlOwnershipType.SelectedValue, out myByte)) ? myByte : (byte?)null;
            p.sustainabilityTypeId = (byte.TryParse(ddlSustainabilityType.SelectedValue, out myByte)) ? myByte : (byte?)null;
            p.capacityTypeId = (byte.TryParse(ddlCapacityType.SelectedValue, out myByte)) ? myByte : (byte?)null;

            p.isTicketed = cbTicketed.Checked;
            p.isActive = cbIsActive.Checked;
            p.isValid = hdnIsValid.Value.Length > 0;
            p.isComplete = cbIsComplete.Checked;
            p.overrideErrors = cbOverrideErrors.Checked;

            if (tbConfirmationDueDate.Text == "")
            {
                p.confirmationDueDate = null;
            }
            else
            {
                try
                {
                    p.confirmationDueDate = DateTime.ParseExact(tbConfirmationDueDate.Text, "dd-MM-yyyy", null);
                }
                catch (Exception exc)
                {

                }
            }

            if (tbConfirmationLastReceived.Text == "")
            {
                p.confirmationLastReceived = null;
            }
            else
            {
                try
                {
                    p.confirmationLastReceived = DateTime.ParseExact(tbConfirmationLastReceived.Text, "dd-MM-yyyy", null);
                }
                catch (Exception exc)
                {

                }
            }

            p.attendance = int.TryParse(tbAttendance.Text, out myInteger) ? myInteger : (int?)null;

            p.paymentAmount = decimal.TryParse(tbPaymentAmount.Text, out myDecimal) ? myDecimal : (decimal?)null;
            p.paymentReceived = cbPaymentReceived.Checked;

            p.lastModifiedBy = HttpContext.Current.User.Identity.Name;
            p.lastModifiedDate = DateTime.Now;

            //ProcessCreditCards(p);
            //ProcessPaymentTypes(p);

            ProcessProductAttributes(p);

            UpdateProductTranslations();
            UpdatePrintVersionTranslations();
            UpdateCanadaSelectRatings();
            UpdateCaaRatings(p.productTypeId);
            UpdateTranslationMarks();
            UpdateRegions();
            UpdatePaymentTypes();
            ProcessPrintVersionData();
            ProcessUnitNumbers(p);
            ProcessTags(p);
            // ProcessOperationPeriod(p);

            if (hdnPrimaryContactId.Value != "")
            {
                int contactId = Int32.Parse(hdnPrimaryContactId.Value);
                productBs.SetProductPrimaryContact(p.id, contactId);
                GenerateContactList();
            }
            productBs.Save();

            productBs.LogProductVersion(p.id, Action.Edit, HttpContext.Current.User.Identity.Name);
        }

        private void UpdatePaymentTypes()
        {
            ProductBs productBs = new ProductBs();
            IQueryable<ProductPaymentType> ptq = productBs.GetProductPaymentTypes(_productId);

            ProcessPaymentTypeCheckbox(cbPaymentTypeAmex, PaymentType.AmericanExpress, ptq);
            ProcessPaymentTypeCheckbox(cbPaymentTypeCashOnly, PaymentType.CashOnly, ptq);
            ProcessPaymentTypeCheckbox(cbPaymentTypeDebitCard, PaymentType.DebitCard, ptq);
            ProcessPaymentTypeCheckbox(cbPaymentTypeDiners, PaymentType.DinersClub, ptq);
            ProcessPaymentTypeCheckbox(cbPaymentTypeDiscover, PaymentType.Discover, ptq);
            ProcessPaymentTypeCheckbox(cbPaymentTypeMasterCard, PaymentType.Mastercard, ptq);
            ProcessPaymentTypeCheckbox(cbPaymentTypePayPal, PaymentType.PayPal, ptq);
            ProcessPaymentTypeCheckbox(cbPaymentTypeVisa, PaymentType.Visa, ptq);
            ProcessPaymentTypeCheckbox(cbPaymentTypeJcb, PaymentType.Jcb, ptq);
            //            ProcessPaymentTypeCheckbox(cbPaymentTypeTravellersCheques, PaymentType.TravellersCheques, ptq);
        }

        private void UpdateTranslationMarks()
        {
            ProductBs productBs = new ProductBs();
            IQueryable<TranslationStatus> tsq = productBs.GetTranslationStatus(_productId);

            ProcessTranslationMarkCheckbox(null, cbTransMarkPrintDate, ProductField.PrintDateDescription, tsq);
            ProcessTranslationMarkCheckbox(null, cbTransMarkPrintDescription, ProductField.PrintDescription, tsq);
            ProcessTranslationMarkCheckbox(null, cbTransMarkPrintDirections, ProductField.PrintDirections, tsq);
            ProcessTranslationMarkCheckbox(null, cbTransMarkPrintRate, ProductField.PrintRateDescription, tsq);
            ProcessTranslationMarkCheckbox(null, cbTransMarkPrintUnit, ProductField.PrintUnitDescription, tsq);
            ProcessTranslationMarkCheckbox(null, cbTransMarkWebDate, ProductField.WebDateDescription, tsq);
            ProcessTranslationMarkCheckbox(null, cbTransMarkWebDescription, ProductField.WebDescription, tsq);
            ProcessTranslationMarkCheckbox(null, cbTransMarkWebDirections, ProductField.WebDirections, tsq);
            ProcessTranslationMarkCheckbox(null, cbTransMarkWebKeywords, ProductField.WebKeywords, tsq);
            ProcessTranslationMarkCheckbox(null, cbTransMarkWebRate, ProductField.WebRateDescription, tsq);
            ProcessTranslationMarkCheckbox(null, cbTransMarkWebCancellationPolicy, ProductField.WebCancellationPolicy, tsq);
        }

        private void UpdateCaaRatings(byte productTypeId)
        {
            ProductBs productBs = new ProductBs();
            productBs.DeleteProductCaaRatings(_productId);

            if (ddlCaaLevel.SelectedValue != "")
            {
                if (productTypeId == (byte)ProductType.Campground)
                {
                    productBs.AddProductCaaRating(_productId, CaaRatingType.Campground, byte.Parse(ddlCaaLevel.SelectedValue));
                }
                else if ((productTypeId == (byte)ProductType.Accommodation) && ddlCaaClass.SelectedValue != "")
                {
                    productBs.AddProductCaaRating(_productId, (CaaRatingType)Int32.Parse(ddlCaaClass.SelectedValue),
                                                  byte.Parse(ddlCaaLevel.SelectedValue));
                }
            }

        }

        private void UpdateCanadaSelectRatings()
        {
            ProductBs productBs = new ProductBs();
            productBs.DeleteProductCanadaSelectRatings(_productId);

            if (ddlRatingApartment.SelectedValue != "")
            {
                productBs.AddProductCanadaSelectRating(_productId, CanadaSelectRatingType.Apartment,
                                                       byte.Parse(ddlRatingApartment.SelectedValue));
            }

            if (ddlRatingBedAndBreakfast.SelectedValue != "")
            {
                productBs.AddProductCanadaSelectRating(_productId, CanadaSelectRatingType.BedAndBreakfast,
                                                       byte.Parse(ddlRatingBedAndBreakfast.SelectedValue));
            }

            if (ddlRatingBedAndBreakfastInn.SelectedValue != "")
            {
                productBs.AddProductCanadaSelectRating(_productId, CanadaSelectRatingType.BedAndBreakfastInn,
                                                       byte.Parse(ddlRatingBedAndBreakfastInn.SelectedValue));
            }

            if (ddlRatingCottage.SelectedValue != "")
            {
                productBs.AddProductCanadaSelectRating(_productId, CanadaSelectRatingType.CottageVacationHome,
                                                       byte.Parse(ddlRatingCottage.SelectedValue));
            }

            if (ddlRatingFishing.SelectedValue != "")
            {
                productBs.AddProductCanadaSelectRating(_productId, CanadaSelectRatingType.FishingHunting,
                                                       byte.Parse(ddlRatingFishing.SelectedValue));
            }

            if (ddlRatingHotelMotel.SelectedValue != "")
            {
                productBs.AddProductCanadaSelectRating(_productId, CanadaSelectRatingType.HotelMotel,
                                                       byte.Parse(ddlRatingHotelMotel.SelectedValue));
            }

            if (ddlRatingInn.SelectedValue != "")
            {
                productBs.AddProductCanadaSelectRating(_productId, CanadaSelectRatingType.Inn,
                                                       byte.Parse(ddlRatingInn.SelectedValue));
            }

            if (ddlRatingResort.SelectedValue != "")
            {
                productBs.AddProductCanadaSelectRating(_productId, CanadaSelectRatingType.Resort,
                                                       byte.Parse(ddlRatingResort.SelectedValue));
            }

            if (ddlRatingTouristHome.SelectedValue != "")
            {
                productBs.AddProductCanadaSelectRating(_productId, CanadaSelectRatingType.TouristHome,
                                                       byte.Parse(ddlRatingTouristHome.SelectedValue));
            }

            if (ddlRatingFacilities.SelectedValue != "")
            {
                productBs.AddProductCanadaSelectRating(_productId, CanadaSelectRatingType.CampingFacilities,
                                                       byte.Parse(ddlRatingFacilities.SelectedValue));
            }

            if (ddlRatingRecreation.SelectedValue != "")
            {
                productBs.AddProductCanadaSelectRating(_productId, CanadaSelectRatingType.CampingRecreation,
                                                       byte.Parse(ddlRatingRecreation.SelectedValue));
            }
            if (ddlRatingSuite.SelectedValue != "")
            {
                productBs.AddProductCanadaSelectRating(_productId, CanadaSelectRatingType.Suite,
                                                       byte.Parse(ddlRatingSuite.SelectedValue));
            }

            if (ddlRatingUniversity.SelectedValue != "")
            {
                productBs.AddProductCanadaSelectRating(_productId, CanadaSelectRatingType.University,
                                                       byte.Parse(ddlRatingUniversity.SelectedValue));
            }

            if (ddlRatingHostel.SelectedValue != "")
            {
                productBs.AddProductCanadaSelectRating(_productId, CanadaSelectRatingType.Hostel,
                                                       byte.Parse(ddlRatingHostel.SelectedValue));
            }
        }

        protected void btnSubmit_onClick(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                UpdateProduct();

                // Reload the current page.
                //Response.Redirect(Request.RawUrl);
                Response.Redirect(String.Format("Edit.aspx?id={0}{1}", _productId, hdnCurrentTabHash.Value));
            }
        }

        #endregion

        #region Media Methods

        private void ClearMediaForm()
        {
            tbMediaTitleEn.Text = "";
            tbMediaCaptionEn.Text = "";

            tbMediaTitleFr.Text = "";
            tbMediaCaptionFr.Text = "";

            ddlMediaLanguage.SelectedValue = "";
            ddlMediaType.SelectedValue = "";

            cbTransMarkMediaCaption.Checked = false;
            cbTransMarkMediaTitle.Checked = false;

            hdnMediaId.Value = "";
        }

        private void AddMedia()
        {
            byte myByte;

            byte? mediaLanguage = (byte.TryParse(ddlMediaLanguage.SelectedValue, out myByte)) ? myByte : (byte?)null;
            string fileExtension = GetFileExtension(hdnOrigFileName.Value);



            if (IsMediaTypeAllowed(fileExtension, ddlMediaType.SelectedValue))
            {


                MediaBs mediaBs = new MediaBs();

                Media m = mediaBs.AddMedia(hdnOrigFileName.Value, fileExtension, mediaLanguage, byte.Parse(ddlMediaType.SelectedValue), _productId, HttpContext.Current.User.Identity.Name);

                string sourceFileName = String.Format("{0}{1}.{2}", _sourcePath, hdnTempFileName.Value, m.fileExtension);
                string targetFileName = String.Format("{0}{1}.{2}", _targetPath, m.id, m.fileExtension);

                try
                {
                    File.Copy(sourceFileName, targetFileName, true);
                }
                catch (Exception exc)
                {

                }

                //afuFile.PostedFile.SaveAs(path + m.id.ToString() + "." + fileExtension);

                mediaBs.AddMediaTranslation(m, "en", tbMediaTitleEn.Text, tbMediaCaptionEn.Text);

                if (tbMediaTitleFr.Text != "" || tbMediaCaptionFr.Text != "")
                {
                    mediaBs.AddMediaTranslation(m, "fr", tbMediaTitleFr.Text, tbMediaCaptionFr.Text);
                }

                mediaBs.LogMediaVersion(m.id, Action.Add, HttpContext.Current.User.Identity.Name);

                ProductBs productBs = new ProductBs();
                IQueryable<TranslationStatus> tsq = productBs.GetTranslationStatus(m.productId, ProductField.MediaCaption, m.id);
                ProcessTranslationMarkCheckbox(m.id, cbTransMarkMediaCaption, ProductField.MediaCaption, tsq);

                IQueryable<TranslationStatus> tsq2 = productBs.GetTranslationStatus(m.productId, ProductField.MediaTitle, m.id);
                ProcessTranslationMarkCheckbox(m.id, cbTransMarkMediaTitle, ProductField.MediaTitle, tsq2);
            }

            GenerateMediaList();
            ClearMediaForm();


        }

        private void UpdateMedia()
        {
            MediaBs mediaBs = new MediaBs();

            int mediaId = Int32.Parse(hdnMediaId.Value);
            string path = System.Web.Configuration.WebConfigurationManager.AppSettings["ManagedMediaUploadPath"];

            Media m = mediaBs.GetMedia(mediaId);

            IQueryable<MediaTranslation> mt = mediaBs.GetMediaTranslations(mediaId);

            IQueryable<MediaTranslation> enMt = from item in mt
                                                where item.languageId == "en"
                                                select item;

            IQueryable<MediaTranslation> frMt = from item in mt
                                                where item.languageId == "fr"
                                                select item;

            if (enMt.Count() > 0)
            {
                enMt.First().mediaTitle = tbMediaTitleEn.Text;
                enMt.First().caption = tbMediaCaptionEn.Text;
            }
            else
            {
                mediaBs.AddMediaTranslation(m, "en", tbMediaTitleEn.Text, tbMediaCaptionEn.Text);
            }


            if (frMt.Count() > 0)
            {
                frMt.First().mediaTitle = tbMediaTitleFr.Text;
                frMt.First().caption = tbMediaCaptionFr.Text;
            }
            else if (tbMediaTitleFr.Text != "" || tbMediaCaptionFr.Text != "")
            {
                mediaBs.AddMediaTranslation(m, "fr", tbMediaTitleFr.Text, tbMediaCaptionFr.Text);
            }

            byte myByte;
            byte? mediaLanguage = (byte.TryParse(ddlMediaLanguage.SelectedValue, out myByte)) ? myByte : (byte?)null;

            m.mediaTypeId = byte.Parse(ddlMediaType.SelectedValue);
            m.mediaLanguageId = mediaLanguage;

            m.lastModifiedBy = HttpContext.Current.User.Identity.Name;
            m.lastModifiedDate = DateTime.Now;



            if (hdnTempFileName.Value != "" && IsMediaTypeAllowed(GetFileExtension(hdnOrigFileName.Value), m.mediaTypeId.ToString()))
            {
                m.originalFileName = hdnOrigFileName.Value;
                m.fileExtension = GetFileExtension(hdnOrigFileName.Value);

                string sourceFileName = String.Format("{0}{1}.{2}", _sourcePath, hdnTempFileName.Value, m.fileExtension);
                string targetFileName = String.Format("{0}{1}.{2}", _targetPath, m.id, m.fileExtension);

                try
                {
                    File.Copy(sourceFileName, targetFileName, true);
                }
                catch (Exception exc)
                {

                }
            }

            mediaBs.Save();

            mediaBs.LogMediaVersion(m.id, Action.Edit, HttpContext.Current.User.Identity.Name);

            ProductBs productBs = new ProductBs();
            IQueryable<TranslationStatus> tsq = productBs.GetTranslationStatus(m.productId, ProductField.MediaCaption, m.id);
            ProcessTranslationMarkCheckbox(m.id, cbTransMarkMediaCaption, ProductField.MediaCaption, tsq);

            IQueryable<TranslationStatus> tsq2 = productBs.GetTranslationStatus(m.productId, ProductField.MediaTitle, m.id);
            ProcessTranslationMarkCheckbox(m.id, cbTransMarkMediaTitle, ProductField.MediaTitle, tsq2);

            //    litMessage.Text = "EDITSubmitted" + tbMediaTitle.Text + ":::" + afuFile.FileName;

            GenerateMediaList();
            ClearMediaForm();
        }

        private void GenerateMediaList()
        {
            //Media
            MediaBs mediaBs = new MediaBs();

            IQueryable<Media> mq = mediaBs.GetProductMedia(_productId);

            // List<Media> ml = mediaBs.GetProductMedia(productId).ToList();
            List<Media> ml = mq.ToList();

            List<MediaListItem> photoList = new List<MediaListItem>();
            List<MediaListItem> documentList = new List<MediaListItem>();
            List<MediaListItem> summaryList = new List<MediaListItem>();

            foreach (Media m in ml)
            {
                MediaListItem mli = new MediaListItem();
                mli.mediaId = m.id;
                //mli.mediaPath = System.Web.Configuration.WebConfigurationManager.AppSettings["ManagedMediaUploadRelativePath"] + m.id + "." + m.fileExtension;
                mli.mediaPath = String.Format("/{0}{1}.{2}", System.Web.Configuration.WebConfigurationManager.AppSettings["ManagedMediaDir"], m.id, m.fileExtension);
                mli.mediaOriginalFileName = m.originalFileName;
                mli.mediaType = ResourceUtils.GetMediaTypeLabel((MediaType)m.mediaTypeId);

                switch ((MediaType)m.mediaTypeId)
                {
                    case MediaType.Advertisement:
                        documentList.Add(mli);
                        break;
                    case MediaType.Brochure:
                        documentList.Add(mli);
                        break;
                    case MediaType.PhotoViewer:
                        photoList.Add(mli);
                        break;
                    case MediaType.SummaryThumbnail:
                        summaryList.Add(mli);
                        // Remove summary thumbnail option from dropdown if it exists
                        if (ddlMediaType.Items.Contains(ddlMediaType.Items.FindByValue(((int)MediaType.SummaryThumbnail).ToString())))
                            ddlMediaType.Items.Remove(ddlMediaType.Items.FindByValue(((int)MediaType.SummaryThumbnail).ToString()));
                        break;
                    default:
                        break;
                }
            }

            lvDocuments.DataSource = documentList;
            lvDocuments.DataBind();

            lvPhoto.DataSource = photoList;
            lvPhoto.DataBind();

            lvSummaryImage.DataSource = summaryList;
            lvSummaryImage.DataBind();
        }

        private void RefreshPhotoViewerList()
        {
            //Media
            MediaBs mediaBs = new MediaBs();

            IQueryable<Media> mq = mediaBs.GetProductMedia(_productId, MediaType.PhotoViewer);

            // List<Media> ml = mediaBs.GetProductMedia(productId).ToList();
            List<Media> ml = mq.ToList();

            List<MediaListItem> photoList = new List<MediaListItem>();


            foreach (Media m in mq)
            {
                MediaListItem mli = new MediaListItem();
                mli.mediaId = m.id;
                //                mli.mediaPath = System.Web.Configuration.WebConfigurationManager.AppSettings["ManagedMediaUploadRelativePath"] + m.id + "." + m.fileExtension;
                mli.mediaPath = String.Format("~/{0}{1}.{2}", System.Web.Configuration.WebConfigurationManager.AppSettings["ManagedMediaDir"], m.id, m.fileExtension);
                mli.mediaOriginalFileName = m.originalFileName;
                mli.mediaType = ResourceUtils.GetMediaTypeLabel((MediaType)m.mediaTypeId);

                photoList.Add(mli);
            }

            lvPhoto.DataSource = photoList;
            lvPhoto.DataBind();
        }

        private string GetFileExtension(string fileName)
        {
            string[] arr = fileName.Split('.');
            return arr.Last().ToString();
        }

        private bool IsMediaTypeAllowed(string fileExtension, string mediaType)
        {
            if ((mediaType == ((int)MediaType.Advertisement).ToString() || mediaType == ((int)MediaType.Brochure).ToString()) && fileExtension.ToLower() == "pdf")
                return true;
            else if ((mediaType == ((int)MediaType.PhotoViewer).ToString() || mediaType == ((int)MediaType.SummaryThumbnail).ToString()) &&
                (fileExtension.ToLower() == "gif" || fileExtension.ToLower() == "jpg" || fileExtension.ToLower() == "png"))
                return true;

            return false;
        }

        protected void btnMediaSubmit_onClick(object sender, EventArgs e)
        {
            if (hdnMediaId.Value != "")
            {
                UpdateMedia();
            }
            else
            {
                AddMedia();
            }

        }

        protected void lbMediaCancel_onClick(object sender, EventArgs e)
        {
            ClearMediaForm();
            //ClearSession_AsyncFileUpload(afuFile.ClientID);
            GenerateMediaList();
        }

        protected void btnEditMedia_onClick(object sender, EventArgs e)
        {
            LinkButton b = (LinkButton)sender;
            //            litMessage.Text =  b.CommandArgument;
            hdnMediaId.Value = b.CommandArgument;

            int mediaId = Int32.Parse(b.CommandArgument);
            MediaBs mediaBs = new MediaBs();

            Media m = mediaBs.GetMedia(mediaId);

            IQueryable<MediaTranslation> mt = mediaBs.GetMediaTranslations(mediaId);

            IQueryable<MediaTranslation> engMt = from item in mt
                                                 where item.languageId == "en"
                                                 select item;

            IQueryable<MediaTranslation> frMt = from item in mt
                                                where item.languageId == "fr"
                                                select item;

            if (engMt.Count() > 0)
            {
                tbMediaTitleEn.Text = engMt.First().mediaTitle;
                tbMediaCaptionEn.Text = engMt.First().caption;
            }

            if (frMt.Count() > 0)
            {
                tbMediaTitleFr.Text = frMt.First().mediaTitle;
                tbMediaCaptionFr.Text = frMt.First().caption;
            }

            ProductBs productBs = new ProductBs();

            IQueryable<TranslationStatus> tsq = productBs.GetTranslationStatus(m.productId, ProductField.MediaCaption, m.id);
            cbTransMarkMediaCaption.Checked = (tsq.Count() > 0);

            IQueryable<TranslationStatus> tsq2 = productBs.GetTranslationStatus(m.productId, ProductField.MediaTitle, m.id);
            cbTransMarkMediaTitle.Checked = (tsq2.Count() > 0);
            //cbTransMarkMediaCaption.Checked = (productBs.GetTranslationStatus(m.productId, ProductField.ImageCaption, m.id).Count() > 0);

            ddlMediaLanguage.SelectedValue = m.mediaLanguageId.ToString();

            if (m.mediaTypeId == (int)MediaType.SummaryThumbnail)
            {
                ddlMediaType.Items.Add(new ListItem(ResourceUtils.GetMediaTypeLabel(MediaType.SummaryThumbnail), ((int)MediaType.SummaryThumbnail).ToString()));
            }

            ddlMediaType.SelectedValue = m.mediaTypeId.ToString();
            hdnOrigFileName.Value = m.originalFileName;
        }

        protected void btnDeleteMedia_onClick(object sender, EventArgs e)
        {
            LinkButton b = (LinkButton)sender;
            int mediaId = Int32.Parse(b.CommandArgument);

            MediaBs mediaBs = new MediaBs();
            Media m = mediaBs.GetMedia(mediaId);

            string path = System.Web.Configuration.WebConfigurationManager.AppSettings["ManagedMediaUploadPath"];
            File.Delete(String.Format("{0}{1}.{2}", path, m.id, m.fileExtension));

            if (m.mediaTypeId == (int)MediaType.SummaryThumbnail)
            {
                ddlMediaType.Items.Add(new ListItem(ResourceUtils.GetMediaTypeLabel(MediaType.SummaryThumbnail), ((int)MediaType.SummaryThumbnail).ToString()));
            }

            mediaBs.DeleteMedia(mediaId);

            if (hdnMediaId.Value == mediaId.ToString())
            {
                ClearMediaForm();
            }

            GenerateMediaList();
        }

        protected void btnUpdateOrder_OnClick(object sender, EventArgs e)
        {
            string sortOrder = hdnPhotoOrder.Value;
            string[] tokens = sortOrder.Split(',');

            MediaBs mediaBs = new MediaBs();

            for (int a = 0; a < tokens.Length; a++)
            {
                string token = tokens[a];
                if (!String.IsNullOrEmpty(token))
                    mediaBs.UpdateMediaSortOrder(Int32.Parse(token), (short)(a + 1), HttpContext.Current.User.Identity.Name);
            }

            RefreshPhotoViewerList();
        }
        
        
        #endregion

        #region Link Methods

        private void ClearLinkForm()
        {
            tbLinkTitleEn.Text = "";
            tbLinkTitleFr.Text = "";
            tbLinkDescriptionEn.Text = "";
            tbLinkDescriptionFr.Text = "";

            tbLinkUrl.Text = "";
            tbLinkDistance.Text = "";
            ddlLinkType.SelectedValue = "";
            hdnLinkId.Value = "";

            cbTransMarkLinkTitle.Checked = false;
            cbTransMarkLinkDesc.Checked = false;
        }

        protected void btnLinkSubmit_onClick(object sender, EventArgs e)
        {
            if (hdnLinkId.Value != "")
            {
                UpdateLink();
            }
            else
            {
                AddLink();
            }
        }

        private void GenerateLinkList()
        {
            ProductBs productBs = new ProductBs();

            IQueryable<Url> ul = productBs.GetUrls(_productId);

            List<LinkListItem> linkList = new List<LinkListItem>();

            foreach (Url u in ul)
            {
                LinkListItem lli = new LinkListItem();
                lli.linkId = u.id;
                lli.linkType = ResourceUtils.GetUrlTypeLabel((UrlType)u.urlTypeId);
                lli.linkUrl = u.url;

                //p.ProductUrls

                IEnumerable<UrlTranslation> engUt = from item in u.UrlTranslations
                                                    where item.languageId == "en"
                                                    select item;


                lli.linkName = (engUt.Count() > 0) ? engUt.First().title : "";
                linkList.Add(lli);
            }

            rptLink.DataSource = linkList;
            rptLink.DataBind();
        }

        private void AddLink()
        {
            ProductBs productBs = new ProductBs();
            decimal myDecimal;
            decimal? linkDistance = decimal.TryParse(tbLinkDistance.Text, out myDecimal) ? myDecimal : (decimal?)null;

            Url u = productBs.AddUrl(_productId, tbLinkUrl.Text, byte.Parse(ddlLinkType.SelectedValue), linkDistance, HttpContext.Current.User.Identity.Name);

            if (tbLinkTitleEn.Text != "" || tbLinkDescriptionEn.Text != "")
            {
                productBs.AddUrlTranslation(u, "en", tbLinkTitleEn.Text, tbLinkDescriptionEn.Text);
            }

            if (tbLinkTitleFr.Text != "" || tbLinkDescriptionFr.Text != "")
            {
                productBs.AddUrlTranslation(u, "fr", tbLinkTitleFr.Text, tbLinkDescriptionFr.Text);
            }

            productBs.LogUrlVersion(u.id, Action.Add, HttpContext.Current.User.Identity.Name);

            IQueryable<TranslationStatus> tsq = productBs.GetTranslationStatus(u.productId, null, u.id);
            ProcessTranslationMarkCheckbox(u.id, cbTransMarkLinkTitle, ProductField.ExternalLinkTitle, tsq);
            ProcessTranslationMarkCheckbox(u.id, cbTransMarkLinkDesc, ProductField.ExternalLinkDescription, tsq);

            GenerateLinkList();

            ClearLinkForm();

        }

        private void UpdateLink()
        {
            int linkId = Int32.Parse(hdnLinkId.Value);
            ProductBs productBs = new ProductBs();
            Url u = productBs.GetUrl(linkId);

            decimal myDecimal;

            u.url = tbLinkUrl.Text;
            u.urlTypeId = byte.Parse(ddlLinkType.SelectedValue);

            u.lastModifiedBy = HttpContext.Current.User.Identity.Name;
            u.lastModifiedDate = DateTime.Now;

            u.distance = decimal.TryParse(tbLinkDistance.Text, out myDecimal) ? myDecimal : (decimal?)null;

            IEnumerable<UrlTranslation> engUt = from item in u.UrlTranslations
                                                where item.languageId == "en"
                                                select item;

            IEnumerable<UrlTranslation> frUt = from item in u.UrlTranslations
                                               where item.languageId == "fr"
                                               select item;

            if (engUt.Count() > 0)
            {
                engUt.First().title = tbLinkTitleEn.Text;
                engUt.First().description = tbLinkDescriptionEn.Text;
            }
            else
            {
                productBs.AddUrlTranslation(u, "en", tbLinkTitleEn.Text, tbLinkDescriptionEn.Text);
            }

            if (frUt.Count() > 0)
            {
                frUt.First().title = tbLinkTitleFr.Text;
                frUt.First().description = tbLinkDescriptionFr.Text;
            }
            else
            {
                productBs.AddUrlTranslation(u, "fr", tbLinkTitleFr.Text, tbLinkDescriptionFr.Text);
            }

            productBs.Save();

            productBs.LogUrlVersion(u.id, Action.Edit, HttpContext.Current.User.Identity.Name);

            int productId = Int32.Parse(hdnProductId.Value);

            IQueryable<TranslationStatus> tsq = productBs.GetTranslationStatus(u.productId, null, u.id);
            ProcessTranslationMarkCheckbox(u.id, cbTransMarkLinkTitle, ProductField.ExternalLinkTitle, tsq);
            ProcessTranslationMarkCheckbox(u.id, cbTransMarkLinkDesc, ProductField.ExternalLinkDescription, tsq);

            GenerateLinkList();
            //ProductCatalogue.DataAccess.Product p = productBs.GetProduct(productId);
            //rptLocations.DataSource = p.NearbyLocations;
            //rptLocations.DataBind();

            ClearLinkForm();

        }

        protected void btnDeleteLink_onClick(object sender, EventArgs e)
        {
            LinkButton b = (LinkButton)sender;
            int linkId = Int32.Parse(b.CommandArgument);

            ProductBs productBs = new ProductBs();
            productBs.DeleteUrl(linkId);

            if (hdnLinkId.Value == linkId.ToString())
            {
                ClearLinkForm();
            }

            GenerateLinkList();
        }

        protected void btnEditLink_onClick(object sender, EventArgs e)
        {

            ClearLinkForm();
            LinkButton b = (LinkButton)sender;

            hdnLinkId.Value = b.CommandArgument;

            int urlId = Int32.Parse(b.CommandArgument);

            ProductBs productBs = new ProductBs();
            Url u = productBs.GetUrl(urlId);

            IEnumerable<UrlTranslation> engUt = from item in u.UrlTranslations
                                                where item.languageId == "en"
                                                select item;

            IEnumerable<UrlTranslation> frUt = from item in u.UrlTranslations
                                               where item.languageId == "fr"
                                               select item;

            tbLinkUrl.Text = u.url;
            tbLinkDistance.Text = (u.distance == null) ? "" : u.distance.ToString();
            ddlLinkType.SelectedValue = u.urlTypeId.ToString();

            if (engUt.Count() > 0)
            {
                tbLinkTitleEn.Text = engUt.First().title;
                tbLinkDescriptionEn.Text = engUt.First().description;
            }

            if (frUt.Count() > 0)
            {
                tbLinkTitleFr.Text = frUt.First().title;
                tbLinkDescriptionFr.Text = frUt.First().description;
            }

            IQueryable<TranslationStatus> tsq = productBs.GetTranslationStatus(u.productId, null, u.id);

            cbTransMarkLinkTitle.Checked = ((from item in tsq where item.fieldId == (int)ProductField.ExternalLinkTitle select item).Count() > 0);
            cbTransMarkLinkDesc.Checked = ((from item in tsq where item.fieldId == (int)ProductField.ExternalLinkDescription select item).Count() > 0);
        }

        #endregion

        #region Note Methods
        
        protected void btnCancelReminder_onClick(object sender, EventArgs e)
        {
            LinkButton b = (LinkButton)sender;

            int noteId = Int32.Parse(b.CommandArgument);

            BusinessBs businessBs = new BusinessBs();
            ProductBs productBs = new ProductBs();
            businessBs.CancelNoteReminder(noteId);
            rptNote.DataSource = productBs.GetProductNotes(_productId);
            rptNote.DataBind();
        }

        protected void btnDeleteNote_onClick(object sender, EventArgs e)
        {
            LinkButton b = (LinkButton)sender;

            int noteId = Int32.Parse(b.CommandArgument);

            ProductBs productBs = new ProductBs();
            productBs.DeleteNote(noteId);

            GenerateNoteList();
        }

        private void GenerateNoteList()
        {
            ProductBs productBs = new ProductBs();

            var nl = productBs.GetProductNotes(_productId).ToList();

            litNoteCount.Text = String.Format("({0})", nl.Count);
            rptNote.DataSource = nl;
            rptNote.DataBind();

        }

        protected void btnNoteSubmit_onClick(object sender, EventArgs e)
        {
            ProductBs productBs = new ProductBs();
            ProductCatalogue.DataAccess.Product p = productBs.GetProduct(_productId);

            DateTime? dt = null;
            try
            {
                dt = DateTime.ParseExact(tbNoteReminderDate.Text, "dd-MM-yyyy", null);
            }
            catch (Exception exc)
            {
                //do nothing
            }


            productBs.AddNote(p, tbNote.Text, dt, HttpContext.Current.User.Identity.Name);

            //rptNote.DataSource = productBs.GetProductNotes(_productId);
            //rptNote.DataBind();
            GenerateNoteList();
            ClearNoteForm();
        }

        private void ClearNoteForm()
        {
            tbNote.Text = "";
            tbNoteReminderDate.Text = "";
        }


        #endregion

        #region Contact Methods

        protected void btnRemoveContact_onClick(object sender, EventArgs e)
        {
            LinkButton b = (LinkButton)sender;
            int contactId = Int32.Parse(b.CommandArgument);

            ProductBs productBs = new ProductBs();
            productBs.DeleteContactProduct(_productId, contactId);

            GenerateContactList();
        }

        private void GenerateContactList()
        {
            ProductBs productBs = new ProductBs();

            List<ProductCatalogue.DataAccess.Contact> cl = productBs.GetProductContacts(_productId).ToList();

            List<ProductContactListItem> contactList = new List<ProductContactListItem>();

            foreach (ProductCatalogue.DataAccess.Contact c in cl)
            {

                ProductContactListItem cli = new ProductContactListItem();

                cli.contactId = c.id.ToString();
                cli.contactName = String.Format("{0} {1}", c.firstName, c.lastName);
                cli.businessContactType = ResourceUtils.GetBusinessContactTypeLabel((BusinessContactType)c.contactTypeId);
                cli.jobTitle = c.jobTitle;
                cli.email = c.email;

                var q = from a in c.ContactProducts
                        where a.productId == _productId
                        select a;

                cli.contactTypeId = q.First().contactTypeId.ToString();
                cli.businessName = c.Business.businessName;
                cli.businessId = c.businessId.ToString();

                contactList.Add(cli);
            }

            rptContact.DataSource = contactList;
            rptContact.DataBind();
        }

        protected void btnContactSubmit_onClick(object sender, EventArgs e)
        {
            int contactId = Int32.Parse(ddlContact.SelectedValue);
            byte contactTypeId = (byte)ContactType.Secondary;

            ProductBs productBs = new ProductBs();
            productBs.AddContactProduct(_productId, contactId, contactTypeId);
            GenerateContactList();
            ClearContactForm();
        }

        private void ClearContactForm()
        {
            tbBusinessName.Text = "";
            hdnBusinessId.Value = "";

            //ddlContact.Visible = false;
            //btnContactSubmit.Enabled = false;
            //dvNoContacts.Visible = false;
            //dvEmptyContact.Visible = true;
        }

        protected void lbRefreshContactDropDown_OnClick(object sender, EventArgs e)
        {
            BusinessBs businessBs = new BusinessBs();

            int businessId = businessBs.GetBusinessId(tbBusinessName.Text);
            hdnBusinessId.Value = businessId.ToString();

            if (businessId > 0)
            {
                RefreshContactDropDownListItems(businessId);
            }
            else
            {
                cvBusinessName.IsValid = false;
            }
        }

        private void RefreshContactDropDownListItems(int businessId)
        {
            BusinessBs businessBs = new BusinessBs();

            List<ListItem> l = new List<ListItem>();

            List<ProductCatalogue.DataAccess.Contact> cl = businessBs.GetBusinessContacts(businessId, _productId).ToList();

            if (cl.Count > 0)
            {
                foreach (var c in cl)
                {
                    ListItem li = new ListItem(String.Format("{1} {0}", c.lastName, c.firstName), c.id.ToString());
                    l.Add(li);
                }

                ddlContact.DataSource = l;
                ddlContact.DataTextField = "Text";
                ddlContact.DataValueField = "Value";
                ddlContact.DataBind();

                ddlContact.Visible = true;
                btnContactSubmit.Enabled = true;
                dvNoContacts.Visible = false;
            }
            else
            {
                ddlContact.Visible = false;
                btnContactSubmit.Enabled = false;
                dvNoContacts.Visible = true;
            }
        }

        #endregion

        #region Supplemental Description Methods

        private void GenerateSupplementalDescriptionList()
        {
            ProductBs productBs = new ProductBs();
            ProductCatalogue.DataAccess.Product p = productBs.GetProduct(_productId);
            IQueryable<ProductDescription> pdq = productBs.GetProductDescriptions(_productId);
            List<ListItemVos.SupplementalDescriptionListItem> sdlil = new List<ListItemVos.SupplementalDescriptionListItem>();

            byte selectedPrimaryGuideSection = (ddlPrimaryGuideSection.SelectedValue == "") ? (byte)0 : byte.Parse(ddlPrimaryGuideSection.SelectedValue);


            //int[] typeIds = (from item in pdq
            //                 select item.descriptionTypeId).Distinct().ToArray();

            List<byte> typeIds = (from item in pdq
                                  select item.descriptionTypeId).Distinct().ToList();

            foreach (int typeId in typeIds)
            {
                ListItemVos.SupplementalDescriptionListItem sdli = new ListItemVos.SupplementalDescriptionListItem();


                //hack to avoid expense of enum.isdefined
                sdli.descriptionTypeName = (typeId < 50) ? ResourceUtils.GetGuideSectionOutdoorsLabel((GuideSectionOutdoors)typeId) : ResourceUtils.GetGuideSectionTourOpsLabel((GuideSectionTourOps)typeId);

                sdli.descriptionTypeId = typeId.ToString();

                IEnumerable<ProductDescription> enPd = from item in pdq
                                                       where item.languageId == "en" && item.descriptionTypeId == typeId
                                                       select item;

                IEnumerable<ProductDescription> frPd = from item in pdq
                                                       where item.languageId == "fr" && item.descriptionTypeId == typeId
                                                       select item;

                sdli.descriptionEn = (enPd.Count() > 0) ? enPd.First().description : "";
                sdli.descriptionFr = (frPd.Count() > 0) ? frPd.First().description : "";

                sdlil.Add(sdli);
            }

            rptProductDescription.DataSource = sdlil;
            rptProductDescription.DataBind();

            //ddlSupplementalDescriptionType.DataSource = EnumerationUtils.GetProductDescriptionTypeListItems(typeIds);
            //ddlSupplementalDescriptionType.DataTextField = "Text";
            //ddlSupplementalDescriptionType.DataValueField = "Value";
            //ddlSupplementalDescriptionType.DataBind();

            if ((ProductType)p.productTypeId == ProductType.Outdoors)
            {
                ddlPrimaryGuideSection.DataSource = EnumerationUtils.GetGuideSectionOutdoorsListItems(typeIds.ToArray());
                ddlPrimaryGuideSection.DataTextField = "Text";
                ddlPrimaryGuideSection.DataValueField = "Value";
                ddlPrimaryGuideSection.DataBind();
            }
            else if ((ProductType)p.productTypeId == ProductType.TourOps)
            {
                ddlPrimaryGuideSection.DataSource = EnumerationUtils.GetGuideSectionTourOpsListItems(typeIds.ToArray());
                ddlPrimaryGuideSection.DataTextField = "Text";
                ddlPrimaryGuideSection.DataValueField = "Value";
                ddlPrimaryGuideSection.DataBind();
            }

            if (selectedPrimaryGuideSection == 0 || typeIds.ToArray().Contains(selectedPrimaryGuideSection))
            {
                ddlPrimaryGuideSection.SelectedValue = (p.primaryGuideSectionId == null) ? "" : p.primaryGuideSectionId.ToString();
            }
            else
            {
                ddlPrimaryGuideSection.SelectedValue = selectedPrimaryGuideSection.ToString();
            }


            if (p.primaryGuideSectionId != null)
            {
                typeIds.Add((byte)p.primaryGuideSectionId);
            }

            ddlGuideSectionOutdoors.DataSource = EnumerationUtils.GetGuideSectionOutdoorsListItems(typeIds.ToArray());
            ddlGuideSectionOutdoors.DataTextField = "Text";
            ddlGuideSectionOutdoors.DataValueField = "Value";
            ddlGuideSectionOutdoors.DataBind();

            ddlGuideSectionTourOps.DataSource = EnumerationUtils.GetGuideSectionTourOpsListItems(typeIds.ToArray());
            ddlGuideSectionTourOps.DataTextField = "Text";
            ddlGuideSectionTourOps.DataValueField = "Value";
            ddlGuideSectionTourOps.DataBind();


        }

        protected void btnEditSupplementalDescription_onClick(object sender, EventArgs e)
        {
            LinkButton b = (LinkButton)sender;
            int descriptionTypeId = Int32.Parse(b.CommandArgument);

            ProductBs productBs = new ProductBs();
            IQueryable<ProductDescription> pdq = productBs.GetProductDescriptions(_productId);
            IQueryable<TranslationStatus> tsq = productBs.GetTranslationStatus(_productId,
                                                                               ProductField.SupplementalDescription,
                                                                               descriptionTypeId);


            IEnumerable<ProductDescription> enPd = from item in pdq
                                                   where item.languageId == "en" && item.descriptionTypeId == descriptionTypeId
                                                   select item;

            IEnumerable<ProductDescription> frPd = from item in pdq
                                                   where item.languageId == "fr" && item.descriptionTypeId == descriptionTypeId
                                                   select item;



            tbSupplementalDescriptionEn.Text = (enPd.Count() > 0) ? enPd.First().description : "";
            tbSupplementalDescriptionFr.Text = (frPd.Count() > 0) ? frPd.First().description : "";
            cbTransMarkSupplementalDescription.Checked = (tsq.Count() > 0);

            byte[] typeIds = (from item in pdq
                              where item.descriptionTypeId != descriptionTypeId
                              select item.descriptionTypeId).Distinct().ToArray();

            //ddlSupplementalDescriptionType.DataSource = EnumerationUtils.GetProductDescriptionTypeListItems(typeIds);
            //ddlSupplementalDescriptionType.DataTextField = "Text";
            //ddlSupplementalDescriptionType.DataValueField = "Value";
            //ddlSupplementalDescriptionType.DataBind();

            ddlGuideSectionOutdoors.DataSource = EnumerationUtils.GetGuideSectionOutdoorsListItems(typeIds);
            ddlGuideSectionOutdoors.DataTextField = "Text";
            ddlGuideSectionOutdoors.DataValueField = "Value";
            ddlGuideSectionOutdoors.DataBind();

            ddlGuideSectionTourOps.DataSource = EnumerationUtils.GetGuideSectionTourOpsListItems(typeIds);
            ddlGuideSectionTourOps.DataTextField = "Text";
            ddlGuideSectionTourOps.DataValueField = "Value";
            ddlGuideSectionTourOps.DataBind();

            hdnSupplementalDescriptionTypeId.Value = descriptionTypeId.ToString();
            // ddlSupplementalDescriptionType.SelectedValue = descriptionTypeId.ToString();

            //hack to avoid expense of enum.isdefined
            if (descriptionTypeId <= 50)
            {
                rblGuideSection.SelectedValue = ((int)ProductType.Outdoors).ToString();
                ddlGuideSectionOutdoors.SelectedValue = descriptionTypeId.ToString();
            }
            else
            {
                rblGuideSection.SelectedValue = ((int)ProductType.TourOps).ToString();
                ddlGuideSectionTourOps.SelectedValue = descriptionTypeId.ToString();
            }
        }

        protected void btnDeleteSupplementalDescription_onClick(object sender, EventArgs e)
        {
            LinkButton b = (LinkButton)sender;
            byte descriptionTypeId = byte.Parse(b.CommandArgument);

            ProductBs productBs = new ProductBs();
            productBs.DeleteProductDescription(_productId, descriptionTypeId);

            if (hdnSupplementalDescriptionTypeId.Value == descriptionTypeId.ToString())
            {
                ClearSupplementalDescriptionForm();
            }

            GenerateSupplementalDescriptionList();
        }

        protected void btnSupplementalDescriptionSubmit_onClick(object sender, EventArgs e)
        {
            if (hdnSupplementalDescriptionTypeId.Value != "")
            {
                UpdateSupplementalDescription();
            }
            else
            {
                AddSupplementalDescription();
            }
        }

        private void AddSupplementalDescription()
        {
            byte descriptionTypeId = rblGuideSection.SelectedValue == ((int)ProductType.Outdoors).ToString()
                                    ? byte.Parse(ddlGuideSectionOutdoors.SelectedValue)
                                    : byte.Parse(ddlGuideSectionTourOps.SelectedValue);

            //int descriptionTypeId = Int32.Parse(hdnSupplementalDescriptionTypeId.Value);
            ProductBs productBs = new ProductBs();

            // this is a hack ... requirements were wrong, trying to kludge what was developed to fit updated requirements (text is only used for equipment rentals for some reason)
            //string descriptionEn = (rblGuideSection.SelectedValue == ((int) ProductType.Outdoors).ToString() &&
            //                        ddlGuideSectionOutdoors.SelectedValue ==
            //                        ((int) GuideSectionOutdoors.EquipmentRentals).ToString())
            //                           ? tbSupplementalDescriptionEn.Text
            //                           : "";

            //string descriptionfr = (rblGuideSection.SelectedValue == ((int)ProductType.Outdoors).ToString() &&
            //            ddlGuideSectionOutdoors.SelectedValue ==
            //            ((int)GuideSectionOutdoors.EquipmentRentals).ToString())
            //               ? tbSupplementalDescriptionFr.Text
            //               : "";

            productBs.AddProductDescription(_productId, "en", descriptionTypeId, tbSupplementalDescriptionEn.Text);

            productBs.AddProductDescription(_productId, "fr", descriptionTypeId, tbSupplementalDescriptionFr.Text);

            productBs.LogDescriptionVersion(_productId, descriptionTypeId, Action.Add, HttpContext.Current.User.Identity.Name);

            IQueryable<TranslationStatus> tsq = productBs.GetTranslationStatus(_productId, ProductField.SupplementalDescription, descriptionTypeId);

            ProcessTranslationMarkCheckbox(descriptionTypeId, cbTransMarkSupplementalDescription, ProductField.SupplementalDescription, tsq);

            GenerateSupplementalDescriptionList();

            ClearSupplementalDescriptionForm();
        }

        private void UpdateSupplementalDescription()
        {
            byte oldDescriptionTypeId = byte.Parse(hdnSupplementalDescriptionTypeId.Value);

            byte newDescriptionTypeId = rblGuideSection.SelectedValue == ((int)ProductType.Outdoors).ToString()
                                    ? byte.Parse(ddlGuideSectionOutdoors.SelectedValue)
                                    : byte.Parse(ddlGuideSectionTourOps.SelectedValue);

            ProductBs productBs = new ProductBs();

            productBs.DeleteProductDescription(_productId, oldDescriptionTypeId);

            productBs.AddProductDescription(_productId, "en", newDescriptionTypeId, tbSupplementalDescriptionEn.Text);

            //if (tbSupplementalDescriptionEn.Text != "")
            //{
            //   productBs.AddProductDescription(_productId, "en", newDescriptionTypeId, tbSupplementalDescriptionEn.Text);
            //}

            if (tbSupplementalDescriptionFr.Text != "")
            {
                productBs.AddProductDescription(_productId, "fr", newDescriptionTypeId, tbSupplementalDescriptionFr.Text);
            }

            productBs.Save();

            productBs.LogDescriptionVersion(_productId, newDescriptionTypeId, Action.Edit, HttpContext.Current.User.Identity.Name);

            productBs.DeleteTranslationStatus(_productId, ProductField.SupplementalDescription, oldDescriptionTypeId);

            if (cbTransMarkSupplementalDescription.Checked)
            {
                productBs.AddTranslationStatus(_productId, ProductField.SupplementalDescription, newDescriptionTypeId);
            }

            GenerateSupplementalDescriptionList();

            ClearSupplementalDescriptionForm();

        }

        private void ClearSupplementalDescriptionForm()
        {
            tbSupplementalDescriptionEn.Text = "";
            tbSupplementalDescriptionFr.Text = "";
            hdnSupplementalDescriptionTypeId.Value = "";
            // ddlSupplementalDescriptionType.SelectedValue = "";

            cbTransMarkSupplementalDescription.Checked = false;
        }


        #endregion

        #region Operational Period Methods

        private void GenerateOperationalPeriodList(int productId)
        {
            ProductBs productBs = new ProductBs();

            var opl = productBs.GetProductOperationPeriods(productId);

            rptOperationalPeriods.DataSource = opl;
            rptOperationalPeriods.DataBind();
        }

        protected void btnOperationalPeriodSubmit_onClick(object sender, EventArgs e)
        {
            //var openDate = tbOperationalOpenDate.Text;
            //var closeDate = tbOperationalCloseDate.Text;
            ProductBs productBs = new ProductBs();
            DateTime? openDate = null;
            DateTime? closeDate = null;

            var id = (hdnOperationalPeriodId.Value != "") ? Int32.Parse(hdnOperationalPeriodId.Value) : (int?)null;

            DateTime myDate;

            //DateTime openDate = DateTime.ParseExact(tbOperationPeriodOpen.Text, "dd-MM-yyyy", null);
            bool success = DateTime.TryParseExact(tbOperationalOpenDate.Text, "dd-MM-yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out myDate);
            if (success)
            {
                openDate = myDate;
            }

            success = DateTime.TryParseExact(tbOperationalCloseDate.Text, "dd-MM-yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out myDate);
            if (success)
            {
                closeDate = myDate;
            }

            productBs.ProcessOperationPeriod(id, _productId, openDate.Value, closeDate);
            ClearOperationalPeriodForm();
            GenerateOperationalPeriodList(_productId);
        }

        protected void btnDeleteOperationalPeriod_onClick(object sender, EventArgs e)
        {
            LinkButton b = (LinkButton)sender;
            int periodId = Int32.Parse(b.CommandArgument);

            ProductBs productBs = new ProductBs();
            productBs.DeleteOperationPeriod(periodId);

            if (hdnOperationalPeriodId.Value == periodId.ToString())
            {
                ClearOperationalPeriodForm();
            }

            GenerateOperationalPeriodList(_productId);
        }

        protected void btnEditOperationalPeriod_onClick(object sender, EventArgs e)
        {
            ClearOperationalPeriodForm();
            LinkButton b = (LinkButton)sender;

            hdnOperationalPeriodId.Value = b.CommandArgument;

            int operationalPeriodId = Int32.Parse(b.CommandArgument);

            ProductBs productBs = new ProductBs();
            var op = productBs.GetOperationPeriod(operationalPeriodId);

            tbOperationalOpenDate.Text = op.openDate.ToString("dd-MM-yyyy");
            tbOperationalCloseDate.Text = (op.closeDate != null) ? op.closeDate.Value.ToString("dd-MM-yyyy") : "";
        }

        private void ClearOperationalPeriodForm()
        {
            hdnOperationalPeriodId.Value = "";

            tbOperationalOpenDate.Text = "";
            tbOperationalCloseDate.Text = "";

        }

        #endregion

        #region Promotional Period Methods

        public class PromotionListVo
        {
            public string productId { get; set; }
            public string promotionPeriodId { get; set; }
            public string startDateDisplay { get; set; }
            public string endDateDisplay { get; set; }
            public string startDate { get; set; }
            public string endDate { get; set; }
        } 

        [WebMethod]
        public static List<PromotionListVo> GetPromotionPeriodList(string productId)
        {
            List<PromotionListVo> plvl = new List<PromotionListVo>();
            
            //no products
            if (String.IsNullOrEmpty(productId))
            {
                return plvl;
            }

            var productBs = new ProductBs();
            var id = int.Parse(productId);

            var product = productBs.GetProduct(id);

            foreach (var pp in product.PromotionPeriods)
            {
                plvl.Add(new PromotionListVo
                {
                    productId = pp.productId.ToString(),
                    promotionPeriodId = pp.id.ToString(),
                    startDateDisplay = pp.startDate.ToString("MMM d, yyyy"),
                    endDateDisplay = (pp.endDate.HasValue) ? pp.endDate.Value.ToString("MMM d, yyyy") : "",
                    startDate = pp.startDate.ToString("dd-MM-yyyy"),
                    endDate = (pp.endDate.HasValue) ? pp.endDate.Value.ToString("dd-MM-yyyy") : ""
                });
            }

            return plvl;
        }

        [WebMethod]
        public static void ProcessPromotionPeriod(string productId, string promotionPeriodId, string startDate, string endDate)
        {
            ProductBs productBs = new ProductBs();
            DateTime? start = null;
            DateTime? end = null;

            var id = (promotionPeriodId != "") ? Int32.Parse(promotionPeriodId) : (int?)null;
            var pId = int.Parse(productId);

            DateTime myDate;

            //DateTime openDate = DateTime.ParseExact(tbOperationPeriodOpen.Text, "dd-MM-yyyy", null);
            bool success = DateTime.TryParseExact(startDate, "dd-MM-yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out myDate);
            if (success)
            {
                start = myDate;
            }

            success = DateTime.TryParseExact(endDate, "dd-MM-yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out myDate);
            if (success)
            {
                end = myDate;
            }

            productBs.ProcessPromotionPeriod(id, pId, start.Value, end);
        }

        [WebMethod]
        public static void DeletePromotionPeriod(string promotionPeriodId)
        {
            ProductBs productBs = new ProductBs();
            var pId = int.Parse(promotionPeriodId);

            productBs.DeletePromotionPeriod(pId);
        }

        #endregion

        #region Community/Region Methods

        private void InitializeRegions()
        {
            ProductBs productBs = new ProductBs();
            IQueryable<ProductRegionOfOperation> proq = productBs.GetProductRegionsOfOperation(_productId);

            cbRegBrasDor.Checked = (from item in proq where item.regionId == (int)Region.BrasDor select item).Count() != 0;
            cbRegCabotTrail.Checked = (from item in proq where item.regionId == (int)Region.CabotTrail select item).Count() != 0;
            cbRegCeilidh.Checked = (from item in proq where item.regionId == (int)Region.CeilidhTrail select item).Count() != 0;
            cbRegEasternShore.Checked = (from item in proq where item.regionId == (int)Region.EasternShore select item).Count() != 0;
            cbRegFleurDeLis.Checked = (from item in proq where item.regionId == (int)Region.FleurDeLis select item).Count() != 0;
            cbRegFundyShore.Checked = (from item in proq where item.regionId == (int)Region.FundyShore select item).Count() != 0;
            cbRegHalifax.Checked = (from item in proq where item.regionId == (int)Region.HalifaxMetro select item).Count() != 0;
            cbRegNorthumberland.Checked = (from item in proq where item.regionId == (int)Region.Northumberland select item).Count() != 0;
            cbRegSouthShore.Checked = (from item in proq where item.regionId == (int)Region.SouthShore select item).Count() != 0;
            cbRegYarmouth.Checked = (from item in proq where item.regionId == (int)Region.Yarmouth select item).Count() != 0;
        }

        private void ProcessRegionCheckbox(CheckBox cb, Region r, IQueryable<ProductRegionOfOperation> proq)
        {
            ProductBs productBs = new ProductBs();

            if (cb.Checked && cb.Enabled && (from item in proq where item.regionId == (int)r select item).Count() == 0)
            {
                productBs.AddProductRegionOfOperation(_productId, r);
            }
            else if ((!cb.Checked || !cb.Enabled) && (from item in proq where item.regionId == (int)r select item).Count() != 0)
            {
                productBs.DeleteProductRegionOfOperation(_productId, r);
            }
        }

        private void UpdateRegions()
        {
            ProductBs productBs = new ProductBs();
            IQueryable<ProductRegionOfOperation> proq = productBs.GetProductRegionsOfOperation(_productId);

            ProcessRegionCheckbox(cbRegBrasDor, Region.BrasDor, proq);
            ProcessRegionCheckbox(cbRegCabotTrail, Region.CabotTrail, proq);
            ProcessRegionCheckbox(cbRegCeilidh, Region.CeilidhTrail, proq);
            ProcessRegionCheckbox(cbRegEasternShore, Region.EasternShore, proq);
            ProcessRegionCheckbox(cbRegFleurDeLis, Region.FleurDeLis, proq);
            ProcessRegionCheckbox(cbRegFundyShore, Region.FundyShore, proq);
            ProcessRegionCheckbox(cbRegHalifax, Region.HalifaxMetro, proq);
            ProcessRegionCheckbox(cbRegNorthumberland, Region.Northumberland, proq);
            ProcessRegionCheckbox(cbRegSouthShore, Region.SouthShore, proq);
            ProcessRegionCheckbox(cbRegYarmouth, Region.Yarmouth, proq);

        }

        protected void ddlCommunity_onIndexChanged(object sender, EventArgs e)
        {
            short communityId = (ddlCommunity.SelectedValue != "") ? short.Parse(ddlCommunity.SelectedValue) : (short)0;

            InitializeRegions();
            EnableRegionCheckboxes();

            if (communityId != 0)
            {
                ProductBs productBs = new ProductBs();
                refCommunity rc = productBs.GetCommunity(communityId);
                InitializeCommunityParentRegion(rc.regionId);
                litSubRegion.Text = (rc.subRegionId != null) ? rc.refSubRegion.subRegionName : NoGeneralAreaMsg;
            }
        }

        private void EnableRegionCheckboxes()
        {
            cbRegBrasDor.Enabled = true;
            cbRegCabotTrail.Enabled = true;
            cbRegCeilidh.Enabled = true;
            cbRegEasternShore.Enabled = true;
            cbRegFleurDeLis.Enabled = true;
            cbRegFundyShore.Enabled = true;
            cbRegHalifax.Enabled = true;
            cbRegNorthumberland.Enabled = true;
            cbRegSouthShore.Enabled = true;
            cbRegYarmouth.Enabled = true;
        }

        private void InitializeCommunityParentRegion(byte regionId)
        {
            EnableRegionCheckboxes();

            switch ((Region)regionId)
            {
                case Region.BrasDor:
                    cbRegBrasDor.Checked = true;
                    cbRegBrasDor.Enabled = false;
                    break;
                case Region.CabotTrail:
                    cbRegCabotTrail.Checked = true;
                    cbRegCabotTrail.Enabled = false;
                    break;
                case Region.CeilidhTrail:
                    cbRegCeilidh.Checked = true;
                    cbRegCeilidh.Enabled = false;
                    break;
                case Region.EasternShore:
                    cbRegEasternShore.Checked = true;
                    cbRegEasternShore.Enabled = false;
                    break;
                case Region.FleurDeLis:
                    cbRegFleurDeLis.Checked = true;
                    cbRegFleurDeLis.Enabled = false;
                    break;
                case Region.FundyShore:
                    cbRegFundyShore.Checked = true;
                    cbRegFundyShore.Enabled = false;
                    break;
                case Region.HalifaxMetro:
                    cbRegHalifax.Checked = true;
                    cbRegHalifax.Enabled = false;
                    break;
                case Region.Northumberland:
                    cbRegNorthumberland.Checked = true;
                    cbRegNorthumberland.Enabled = false;
                    break;
                case Region.SouthShore:
                    cbRegSouthShore.Checked = true;
                    cbRegSouthShore.Enabled = false;
                    break;
                case Region.Yarmouth:
                    cbRegYarmouth.Checked = true;
                    cbRegYarmouth.Enabled = false;
                    break;
                default:
                    break;
            }

        }

        #endregion

        #region Custom Validators
        protected void cvBusinessName_ServerValidate(object source, ServerValidateEventArgs args)
        {
            BusinessBs businessBs = new BusinessBs();
            args.IsValid = businessBs.GetBusinessId(tbBusinessName.Text.Trim()) > 0;
        }

        protected void cvLicenseNumber_ServerValidate(object source, ServerValidateEventArgs args)
        {
            ProductBs productBs = new ProductBs();

            var ids = productBs.GetProductsByLicenseNumber(tbLicenseNumber.Text).Select(z => z.id).ToList();

            if (!((ids.Count == 0) || (ids.Count == 1 && ids.Contains(_productId))))
            {
                args.IsValid = false;
                cvLicenseNumber.IsValid = false;
            }
            else
            {
                args.IsValid = true;
                cvLicenseNumber.IsValid = true;
            }
        }
        #endregion
        
        #region Navigation methods

        protected void btnPrevProduct_OnClick(object sender, EventArgs e)
        {
            int i = MySessionVariables.ProductSearchItems.Value[MySessionVariables.CurrentIndex.Value - 1];

            Response.Redirect(String.Format("Edit.aspx?id={0}{1}", i, hdnCurrentTabHash.Value));
        }

        protected void btnNextProduct_OnClick(object sender, EventArgs e)
        {
            int i = MySessionVariables.ProductSearchItems.Value[MySessionVariables.CurrentIndex.Value + 1];

            Response.Redirect(String.Format("Edit.aspx?id={0}{1}", i, hdnCurrentTabHash.Value));
        }

        #endregion

        
    }
}
