using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using ProductCatalogue.BusinessServices;
using ProductCatalogue.DataAccess;
using ProductCatalogue.DataAccess.Enumerations;
using WebApplication.Utilities;
using WebApplication.ValueObjects;
using AttributeGroup = ProductCatalogue.DataAccess.Enumerations.AttributeGroup;
using ProductSearchListItem = WebApplication.ValueObjects.ListItemVos.ProductSearchListItem;
using Region = ProductCatalogue.DataAccess.Enumerations.Region;

namespace WebApplication.Admin.Product
{
    public partial class Index : System.Web.UI.Page
    {
        private string[] letters = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K",
                     "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V",
                     "W", "X", "Y", "Z"};

        private const int DefaultFilterDisplayNumber = 3;
        private const int DefaultMediaDisplayNumber = 1;
        private const int DefaultLinkDisplayNumber = 1;

        private Color DarkBlue = Color.FromArgb(10, 78, 146);
        private Color LightBlue = Color.FromArgb(102, 153, 204);


        //protected override void OnPreRender(EventArgs e)
        //{
        //   // lvProducts.DataSource = GenerateProductList(SearchProducts().ToList());
        //    lvProducts.DataSource = GenerateProductList();
        //    lvProducts.DataBind();
        //    base.OnPreRender(e);
        //}

        //private List<ListItemVos.ProductSearchListItem> GenerateProductList()
        private List<ListItemVos.ProductSearchListItem> GenerateProductList()
        {
            ProductBs productBs = new ProductBs();
            BusinessBs businessBs = new BusinessBs();

            MySessionVariables.SearchParameters.Clear();

            SearchParameters mySearchParams = new SearchParameters();

            //IQueryable<ProductCatalogue.DataAccess.Product> productList = productBs.GetAllProducts();
            //IQueryable<ProductCatalogue.DataAccess.Product> productList = productBs.GetProducts(-1, "", "", "Aber", -1, -1, -1);
            byte myByte;
            short myShort;
            int myInt;

            int? productId = Int32.TryParse(tbProductId.Text, out myInt) ? myInt : (int?)null;
            byte? productTypeId = byte.TryParse(ddlProductType.SelectedValue, out myByte) ? myByte : (byte?) null;
            short? communityId = short.TryParse(ddlCommunity.SelectedValue, out myShort) ? myShort : (short?)null;
            short? subRegionId = short.TryParse(ddlSubRegion.SelectedValue, out myShort) ? myShort : (short?)null;
            byte? regionId = byte.TryParse(ddlRegion.SelectedValue, out myByte) ? myByte : (byte?)null;

            byte? isActive = byte.TryParse(ddlProductStatus.SelectedValue, out myByte) ? myByte : (byte?)null;
            byte? isValid = byte.TryParse(ddlValidationStatus.SelectedValue, out myByte) ? myByte : (byte?)null;
            byte? isComplete = byte.TryParse(ddlCompletionStatus.SelectedValue, out myByte) ? myByte : (byte?)null;
            byte? overrideErrors = byte.TryParse(ddlErrorsOverridden.SelectedValue, out myByte) ? myByte : (byte?)null;

            byte? isCheckInMember = byte.TryParse(ddlCheckInMember.SelectedValue, out myByte) ? myByte : (byte?)null;

            List<int> attListTrue = new List<int>();
            List<int> attListFalse = new List<int>();

            List<int> mediaListTrue = new List<int>();
            List<int> mediaListFalse = new List<int>();

            List<int> linkListTrue = new List<int>();
            List<int> linkListFalse = new List<int>();

            for (var j = 1; j <= 10; j++)
            {
                Control ac = this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlFeatureType{0}", j));
                DropDownList ddlType = (DropDownList)ac;

                ac = this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlFeatureValue{0}", j));
                DropDownList ddlValue = (DropDownList)ac;
                
                ac = this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlFeatureStatus{0}", j));
                DropDownList ddlStatus = (DropDownList)ac;

                if (ddlValue.SelectedValue != "" && ddlStatus.SelectedValue != "")
                {
                    FilterUnit fu = new FilterUnit
                                        {
                                            FilterType = ddlType.SelectedValue,
                                            FilterValue = ddlValue.SelectedValue,
                                            FilterStatus = ddlStatus.SelectedValue
                                        };

                    mySearchParams.FilterUnitList.Add(fu);

                    if (ddlStatus.SelectedValue == "1")
                    {
                        attListTrue.Add(Int32.Parse(ddlValue.SelectedValue));
                    }
                    else
                    {
                        attListFalse.Add(Int32.Parse(ddlValue.SelectedValue));
                    }
                }
            }

            for (var j = 1; j <= 5; j++)
            {
                Control ac = this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlMediaType{0}", j));
                DropDownList ddlValue = (DropDownList)ac;

                ac = this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlMediaStatus{0}", j));
                DropDownList ddlStatus = (DropDownList)ac;

                if (ddlValue.SelectedValue != "" && ddlStatus.SelectedValue != "")
                {
                    MediaUnit mu = new MediaUnit
                    {
                        MediaType = ddlValue.SelectedValue,
                        MediaStatus = ddlStatus.SelectedValue
                    };

                    mySearchParams.MediaUnitList.Add(mu);

                    if (ddlStatus.SelectedValue == "1")
                    {
                        mediaListTrue.Add(Int32.Parse(ddlValue.SelectedValue));
                    }
                    else
                    {
                        mediaListFalse.Add(Int32.Parse(ddlValue.SelectedValue));
                    }
                }
            }

            for (var j = 1; j <= 5; j++)
            {
                Control ac = this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlLinkType{0}", j));
                DropDownList ddlValue = (DropDownList)ac;

                ac = this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlLinkStatus{0}", j));
                DropDownList ddlStatus = (DropDownList)ac;

                if (ddlValue.SelectedValue != "" && ddlStatus.SelectedValue != "")
                {
                    LinkUnit lu = new LinkUnit
                    {
                        LinkType = ddlValue.SelectedValue,
                        LinkStatus = ddlStatus.SelectedValue
                    };

                    mySearchParams.LinkUnitList.Add(lu);

                    if (ddlStatus.SelectedValue == "1")
                    {
                        linkListTrue.Add(Int32.Parse(ddlValue.SelectedValue));
                    }
                    else
                    {
                        linkListFalse.Add(Int32.Parse(ddlValue.SelectedValue));
                    }
                }
            }

            string notesString = tbNote.Text;

            DateTime myDateTime;
            
            DateTime? noteStartDate = null;
            noteStartDate = DateTime.TryParse(tbNoteStartDate.Text, out myDateTime) ? myDateTime : (DateTime?)null;

            DateTime? noteEndDate = null;
            noteEndDate = DateTime.TryParse(tbNoteEndDate.Text, out myDateTime) ? myDateTime : (DateTime?)null;

            string searchString = tbAdvSearch.Text;
            bool searchUnit = cbUnitDescription.Checked;
            bool searchPrint = cbPrintDescription.Checked;
            bool searchWeb = cbWebDescription.Checked;
            bool searchLicenseNumber = cbLicenseNumber.Checked;
            bool searchFilemakerId = cbFileMakerId.Checked;
            bool searchCheckInId = cbCheckInId.Checked;

            bool attListUseAnd = (ddlFilterOperator.SelectedValue == "1");
            bool mediaListUseAnd = (ddlMediaOperator.SelectedValue == "1");
            bool linkListUseAnd = (ddlLinkOperator.SelectedValue == "1");

            mySearchParams.BusinessName = tbBusinessName.Text;
            mySearchParams.Community = ddlCommunity.SelectedValue;
            mySearchParams.CompletionStatus = ddlCompletionStatus.SelectedValue;
            mySearchParams.ContactFirstName = tbContactFirstName.Text;
            mySearchParams.ContactLastName = tbContactLastName.Text;
            mySearchParams.ErrorsOverridden = ddlErrorsOverridden.SelectedValue;
            mySearchParams.FilterOperator = ddlFilterOperator.SelectedValue;
            mySearchParams.GeneralArea = ddlSubRegion.SelectedValue;
            mySearchParams.IsCheckInMember = ddlCheckInMember.SelectedValue;
            mySearchParams.LinkOperator = ddlLinkOperator.SelectedValue;
            mySearchParams.MediaOperator = ddlMediaOperator.SelectedValue;
            mySearchParams.NotesEndDate = tbNoteEndDate.Text;
            mySearchParams.NotesStartDate = tbNoteStartDate.Text;
            mySearchParams.NotesSearch = tbNote.Text;
            mySearchParams.ProductId = tbProductId.Text;
            mySearchParams.ProductName = tbProductName.Text;
            mySearchParams.ProductStatus = ddlProductStatus.SelectedValue;
            mySearchParams.ProductType = ddlProductType.SelectedValue;
            mySearchParams.Region = ddlRegion.SelectedValue;
            mySearchParams.SearchCheckInId = cbCheckInId.Checked;
            mySearchParams.SearchFileMakerId = cbFileMakerId.Checked;
            mySearchParams.SearchLicenseNumber = cbLicenseNumber.Checked;
            mySearchParams.SearchPrint = cbPrintDescription.Checked;
            mySearchParams.SearchString = tbAdvSearch.Text;
            mySearchParams.SearchUnit = cbUnitDescription.Checked;
            mySearchParams.SearchWeb = cbWebDescription.Checked;
            mySearchParams.ValidationStatus = ddlValidationStatus.SelectedValue;
            mySearchParams.DisplayAdvancedSearchPanel = hdnShowAdvancedSearchPanel.Value;

            IQueryable<ProductCatalogue.DataAccess.Product> pq = productBs.SearchProducts(productId, tbProductName.Text, productTypeId, communityId, regionId, subRegionId,
                                     tbBusinessName.Text, tbContactFirstName.Text,
                                     tbContactLastName.Text, hdnLetterFilter.Value, isActive, isValid, overrideErrors, isComplete, isCheckInMember,
                                     attListTrue, attListFalse, attListUseAnd, mediaListTrue, mediaListFalse, mediaListUseAnd,
                                     linkListTrue, linkListFalse, linkListUseAnd, searchString, searchUnit, searchPrint, searchWeb,
                                     searchLicenseNumber, searchFilemakerId, searchCheckInId,
                                     notesString, noteStartDate, noteEndDate);

            MySessionVariables.ProductSearchItems.Value.Clear();
            MySessionVariables.CurrentIndex.Value = 0;

            MySessionVariables.SearchParameters.Value = mySearchParams;

            //if (pq.Count() == 1)
            //{
            //    Response.Redirect(String.Format("Edit.aspx?id={0}", pq.First().id));
            //}

            List<ListItemVos.ProductSearchListItem> pl = new List<ListItemVos.ProductSearchListItem>();

            foreach (var p in pq )
            {
                var pli = new ProductSearchListItem();

                //pli.contactId = "1";
                //pli.primaryContactName = String.Format("{0}, {1}", "MacNutt", "Justin");
                //var c = businessBs.GetPrimaryContact(p);
                
                //if (c != null)
                //{
                //    pli.contactId = c.id.ToString();
                //    pli.primaryContactName = String.Format("{0}, {1}", c.lastName, c.firstName);
                //}
                
                pli.communityName = (p.communityId != null) ? p.refCommunity.communityName : "";
                pli.regionName = (p.communityId != null) ? p.refCommunity.refRegion.regionName : "";
                pli.productId = p.id.ToString();
                pli.productName = p.productName;
                pli.productType = ResourceUtils.GetProductTypeLabel((ProductType) p.productTypeId);
                pli.isDisplayed = (p.isActive && (p.isValid || p.overrideErrors)) ? "Yes" : "No";

                MySessionVariables.ProductSearchItems.Value.Add(p.id);

                pl.Add(pli);
            }

            return pl;
        }

        protected void Page_Load(object sender, EventArgs e)
        {

            
            //    lvProducts.DataBind();
            lvProducts.PagePropertiesChanged += new EventHandler(lvProducts_PagePropertiesChanged);

            if (!IsPostBack)
            {
                ProductBs productBs = new ProductBs();

                ddlProductType.DataSource = EnumerationUtils.GetProductTypeListItems();
                ddlProductType.DataTextField = "Text";
                ddlProductType.DataValueField = "Value";
                ddlProductType.DataBind();

                ddlCommunity.DataSource = productBs.GetAllCommunities();
                ddlCommunity.DataTextField = "interfaceName";
                ddlCommunity.DataValueField = "id";
                ddlCommunity.DataBind();

                ddlRegion.DataSource = productBs.GetAllRegions();
                ddlRegion.DataTextField = "regionName";
                ddlRegion.DataValueField = "id";
                ddlRegion.DataBind();

                ddlSubRegion.DataSource = productBs.GetAllSubRegions();
                ddlSubRegion.DataTextField = "subRegionName";
                ddlSubRegion.DataValueField = "id";
                ddlSubRegion.DataBind();

                rptLetters.DataSource = letters.ToList();
                rptLetters.DataBind();

                var featureTypeList = EnumerationUtils.GetAttributeGroupListItems(true);
                var mediaTypeList = EnumerationUtils.GetMediaTypeListItems();
                var linkTypeList = EnumerationUtils.GetLinkTypeListItems();

                hdnFeatureDisplayNumber.Value = DefaultFilterDisplayNumber.ToString();
                hdnMediaDisplayNumber.Value = DefaultMediaDisplayNumber.ToString();
                hdnLinkDisplayNumber.Value = DefaultLinkDisplayNumber.ToString();

                for (var j = 1;j<=10;j++)
                {
                    Control ac = this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlFeatureType{0}",j));
                    DropDownList ddlType = (DropDownList)ac;

                    ddlType.DataSource = featureTypeList;
                    ddlType.DataTextField = "Text";
                    ddlType.DataValueField = "Value";
                    ddlType.DataBind();
                }

                for (var j = 1; j <= 5; j++)
                {
                    Control ac = this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlMediaType{0}", j));
                    DropDownList ddlType = (DropDownList)ac;

                    ddlType.DataSource = mediaTypeList;
                    ddlType.DataTextField = "Text";
                    ddlType.DataValueField = "Value";
                    ddlType.DataBind();
                }

                for (var j = 1; j <= 5; j++)
                {
                    Control ac = this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlLinkType{0}", j));
                    DropDownList ddlType = (DropDownList)ac;

                    ddlType.DataSource = linkTypeList;
                    ddlType.DataTextField = "Text";
                    ddlType.DataValueField = "Value";
                    ddlType.DataBind();
                }

                if (MySessionVariables.SearchParameters.HasValue)
                {
                    PopulateSearchForm();    
                }
                
                lvProducts.DataSource = GenerateProductList();
                lvProducts.DataBind();
            }

            
            
        }

        private void lvProducts_PagePropertiesChanged(object sender, EventArgs e)
        {
            lvProducts.DataSource = GenerateProductList();
            lvProducts.DataBind();
        }

        protected void lnkLetter_OnClick(object sender, EventArgs e)
        {
            LinkButton lb = (LinkButton)sender;
            
            hdnLetterFilter.Value = lb.CommandArgument;
            dpProductPager.SetPageProperties(0,20,false);

            lvProducts.DataSource = GenerateProductList();
            lvProducts.DataBind();
        }

        protected void btnFilter_OnClick(object sender, EventArgs e)
        {
            hdnLetterFilter.Value = "";

            lvProducts.DataSource = GenerateProductList();
            lvProducts.DataBind();
            //ProductBs productBs = new ProductBs();
            //productBs.GetProducts(-1, "", "", "Aber", -1, -1, -1);
        }

       protected void ddlFeatureType_onIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddlType = (DropDownList) sender;
            var j = String.Format("ddlFeatureValue{0}",ddlType.ID.Replace("ddlFeatureType",""));

            Control ac = this.Master.FindControl("cphMainContent").FindControl(j);
            DropDownList ddlValue = (DropDownList)ac;

            ddlValue.DataSource = (ddlType.SelectedValue == "") ? EnumerationUtils.GetDefaultListItems() : EnumerationUtils.GetAttributeGroupListItems((AttributeGroup)Int32.Parse(ddlType.SelectedValue), true);
            ddlValue.DataTextField = "Text";
            ddlValue.DataValueField = "Value";
            ddlValue.DataBind();
        }

        private void PopulateSearchForm()
        {
            SearchParameters mySearchParams = MySessionVariables.SearchParameters.Value;

            tbProductName.Text = mySearchParams.ProductName;
            tbProductId.Text = mySearchParams.ProductId;
            ddlProductType.SelectedValue = mySearchParams.ProductType;
            ddlCommunity.SelectedValue = mySearchParams.Community;
            ddlRegion.SelectedValue = mySearchParams.Region;
            ddlSubRegion.SelectedValue = mySearchParams.GeneralArea;
            tbBusinessName.Text = mySearchParams.BusinessName;
            tbContactFirstName.Text = mySearchParams.ContactFirstName;
            tbContactLastName.Text = mySearchParams.ContactLastName;
            ddlProductStatus.SelectedValue = mySearchParams.ProductStatus;
            ddlCompletionStatus.SelectedValue = mySearchParams.CompletionStatus;
            ddlValidationStatus.SelectedValue = mySearchParams.ValidationStatus;
            ddlCheckInMember.SelectedValue = mySearchParams.IsCheckInMember;
            ddlErrorsOverridden.SelectedValue = mySearchParams.ErrorsOverridden;
            tbAdvSearch.Text = mySearchParams.SearchString;
            cbCheckInId.Checked = Convert.ToBoolean(mySearchParams.SearchCheckInId);
            cbFileMakerId.Checked = Convert.ToBoolean(mySearchParams.SearchFileMakerId);
            cbLicenseNumber.Checked = Convert.ToBoolean(mySearchParams.SearchLicenseNumber);
            cbUnitDescription.Checked = Convert.ToBoolean(mySearchParams.SearchUnit);
            cbPrintDescription.Checked = Convert.ToBoolean(mySearchParams.SearchPrint);
            cbWebDescription.Checked = Convert.ToBoolean(mySearchParams.SearchWeb);
            tbNote.Text = mySearchParams.NotesSearch;
            tbNoteStartDate.Text = mySearchParams.NotesStartDate;
            tbNoteEndDate.Text = mySearchParams.NotesEndDate;
            
            ddlFilterOperator.SelectedValue = mySearchParams.FilterOperator;
            ddlMediaOperator.SelectedValue = mySearchParams.MediaOperator;
            ddlLinkOperator.SelectedValue = mySearchParams.LinkOperator;

            hdnFeatureDisplayNumber.Value = (mySearchParams.FilterUnitList.Count > DefaultFilterDisplayNumber) ? mySearchParams.FilterUnitList.Count.ToString() : DefaultFilterDisplayNumber.ToString();
            hdnMediaDisplayNumber.Value = (mySearchParams.MediaUnitList.Count > DefaultMediaDisplayNumber) ? mySearchParams.MediaUnitList.Count.ToString() : DefaultMediaDisplayNumber.ToString();
            hdnLinkDisplayNumber.Value = (mySearchParams.LinkUnitList.Count > DefaultLinkDisplayNumber) ? mySearchParams.LinkUnitList.Count.ToString() : DefaultLinkDisplayNumber.ToString();
            hdnShowAdvancedSearchPanel.Value = mySearchParams.DisplayAdvancedSearchPanel;

            for (var j = 1; j <= mySearchParams.FilterUnitList.Count; j++)
            {
                Control ac = this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlFeatureType{0}", j));
                DropDownList ddlType = (DropDownList)ac;
                ddlType.SelectedValue = mySearchParams.FilterUnitList[j-1].FilterType;

                ac = this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlFeatureValue{0}", j));
                DropDownList ddlValue = (DropDownList)ac;

                ddlValue.DataSource = (ddlType.SelectedValue == "") ? EnumerationUtils.GetDefaultListItems() : EnumerationUtils.GetAttributeGroupListItems((AttributeGroup)Int32.Parse(ddlType.SelectedValue), true);
                ddlValue.DataTextField = "Text";
                ddlValue.DataValueField = "Value";
                ddlValue.DataBind();

                ddlValue.SelectedValue = mySearchParams.FilterUnitList[j - 1].FilterValue;

                ac = this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlFeatureStatus{0}", j));
                DropDownList ddlStatus = (DropDownList)ac;

                ddlStatus.SelectedValue = mySearchParams.FilterUnitList[j - 1].FilterStatus;
                
            }

            for (var j = 1; j <= mySearchParams.MediaUnitList.Count; j++)
            {
                var ac = this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlMediaType{0}", j));
                DropDownList ddlType = (DropDownList)ac;

                ddlType.SelectedValue = mySearchParams.MediaUnitList[j - 1].MediaType;

                ac = this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlMediaStatus{0}", j));
                DropDownList ddlStatus = (DropDownList)ac;

                ddlStatus.SelectedValue = mySearchParams.MediaUnitList[j - 1].MediaStatus;
            }

            for (var j = 1; j <= mySearchParams.LinkUnitList.Count; j++)
            {
                var ac = this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlLinkType{0}", j));
                DropDownList ddlType = (DropDownList)ac;

                ddlType.SelectedValue = mySearchParams.LinkUnitList[j - 1].LinkType;

                ac = this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlLinkStatus{0}", j));
                DropDownList ddlStatus = (DropDownList)ac;

                ddlStatus.SelectedValue = mySearchParams.LinkUnitList[j - 1].LinkStatus;
            }
        }

        protected void btnExport_OnClick(object sender, EventArgs e)
        {
            ExcelPackage pck = new ExcelPackage();
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("SearchResults");
            
            var productBs = new ProductBs();

            int dataRowIndex = 1;

            ws.Cells["A" + dataRowIndex].Value = "Search Export";

            using (ExcelRange rng = ws.Cells[string.Format("A{0}:A{0}", dataRowIndex)])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(DarkBlue);  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }

            dataRowIndex++;
            
            var searchParams = (MySessionVariables.SearchParameters.HasValue) ? MySessionVariables.SearchParameters.Value : null;

            var searchParamFirstRow = dataRowIndex;
            var searchParamLastRow = dataRowIndex;

            if (searchParams != null)
            {
                if (searchParams.ProductName != "")
                {
                    ws.Cells["A" + dataRowIndex].Value = "Product Name:";
                    ws.Cells["B" + dataRowIndex].Value = searchParams.ProductName;
                    dataRowIndex++;
                }

                if (searchParams.ProductId != "")
                {
                    ws.Cells["A" + dataRowIndex].Value = "Product Id:";
                    ws.Cells["B" + dataRowIndex].Value = searchParams.ProductId;
                    dataRowIndex++;
                }

                if (searchParams.ProductType != "")
                {
                    ws.Cells["A" + dataRowIndex].Value = "Product Type:";
                    ws.Cells["B" + dataRowIndex].Value = ResourceUtils.GetProductTypeLabel((ProductType)short.Parse(searchParams.ProductType));
                    dataRowIndex++;
                }

                if (searchParams.Community != "")
                {
                    ws.Cells["A" + dataRowIndex].Value = "Community:";
                    ws.Cells["B" + dataRowIndex].Value = productBs.GetCommunity(short.Parse(searchParams.Community)).communityName;
                    dataRowIndex++;
                }

                if (searchParams.Region != "")
                {
                    ws.Cells["A" + dataRowIndex].Value = "Region:";
                    ws.Cells["B" + dataRowIndex].Value = ResourceUtils.GetRegionLabel((Region)short.Parse(searchParams.Region));
                    dataRowIndex++;
                }

                if (searchParams.GeneralArea != "")
                {
                    ws.Cells["A" + dataRowIndex].Value = "General Area:";
                    ws.Cells["B" + dataRowIndex].Value = productBs.GetSubRegion(short.Parse(searchParams.GeneralArea));
                    dataRowIndex++;
                }

                if (searchParams.BusinessName != "")
                {
                    ws.Cells["A" + dataRowIndex].Value = "Business Name:";
                    ws.Cells["B" + dataRowIndex].Value = searchParams.BusinessName;
                    dataRowIndex++;
                }
                
                if (searchParams.ContactFirstName != "")
                {
                    ws.Cells["A" + dataRowIndex].Value = "Contact First Name:";
                    ws.Cells["B" + dataRowIndex].Value = searchParams.ContactFirstName;
                    dataRowIndex++;
                }

                if (searchParams.ContactLastName != "")
                {
                    ws.Cells["A" + dataRowIndex].Value = "Contact Last Name:";
                    ws.Cells["B" + dataRowIndex].Value = searchParams.ContactLastName;
                    dataRowIndex++;
                }

                if (searchParams.ProductStatus != "")
                {
                    ws.Cells["A" + dataRowIndex].Value = "Product Status:";
                    ws.Cells["B" + dataRowIndex].Value = searchParams.ProductStatus;
                    dataRowIndex++;
                }

                if (searchParams.CompletionStatus != "")
                {
                    ws.Cells["A" + dataRowIndex].Value = "Completion Status:";
                    ws.Cells["B" + dataRowIndex].Value = searchParams.CompletionStatus;
                    dataRowIndex++;
                }

                if (searchParams.ValidationStatus != "")
                {
                    ws.Cells["A" + dataRowIndex].Value = "Validation Status:";
                    ws.Cells["B" + dataRowIndex].Value = searchParams.ValidationStatus;
                    dataRowIndex++;
                }

                if (searchParams.ErrorsOverridden != "")
                {
                    ws.Cells["A" + dataRowIndex].Value = "Errors Overridden:";
                    ws.Cells["B" + dataRowIndex].Value = searchParams.ErrorsOverridden;
                    dataRowIndex++;
                }
                
                //ADVANCED SEARCH FIELDS
                if (searchParams.SearchString != "")
                {
                    ws.Cells["A" + dataRowIndex].Value = "Search String:";
                    ws.Cells["B" + dataRowIndex].Value = searchParams.SearchString;
                    dataRowIndex++;

                    List<string> searchFields = new List<string>();

                    if (searchParams.SearchUnit)
                    {
                        searchFields.Add("Unit Desc.");
                    }

                    if (searchParams.SearchPrint)
                    {
                        searchFields.Add("Print Desc.");
                    }

                    if (searchParams.SearchWeb)
                    {
                        searchFields.Add("Web Desc.");
                    }

                    if (searchParams.SearchLicenseNumber)
                    {
                        searchFields.Add("License Number");
                    }

                    if (searchParams.SearchFileMakerId)
                    {
                        searchFields.Add("File Maker Id");
                    }

                    if (searchParams.SearchCheckInId)
                    {
                        searchFields.Add("Check In Id");
                    }

                    ws.Cells["A" + dataRowIndex].Value = "Search Fields:";
                    ws.Cells["B" + dataRowIndex].Value = (searchFields.Count() > 0)
                                                        ? string.Join(", ", searchFields.ToArray())
                                                        : "None";
                    dataRowIndex++;

                }

                if (searchParams.IsCheckInMember != "")
                {
                    ws.Cells["A" + dataRowIndex].Value = "Is Checkin Member:";
                    ws.Cells["B" + dataRowIndex].Value = searchParams.IsCheckInMember;
                    dataRowIndex++;
                }
                
                if (searchParams.NotesSearch != "")
                {
                    ws.Cells["A" + dataRowIndex].Value = "Notes Text";
                    ws.Cells["B" + dataRowIndex].Value = searchParams.NotesSearch;
                    dataRowIndex++;
                }

                if (searchParams.NotesStartDate != "")
                {
                    ws.Cells["A" + dataRowIndex].Value = "Notes Start Date:";
                    ws.Cells["B" + dataRowIndex].Value = searchParams.NotesStartDate;
                    dataRowIndex++;
                }

                if (searchParams.NotesEndDate != "")
                {
                    ws.Cells["A" + dataRowIndex].Value = "Notes End Date:";
                    ws.Cells["B" + dataRowIndex].Value = searchParams.NotesEndDate;
                    dataRowIndex++;
                }

                //TODO FILTER and MEDIA and Link Searches
            }

            if (searchParamFirstRow == dataRowIndex)
            {
                ws.Cells["A" + dataRowIndex++].Value = "NO SEARCH PARAMS";
            }
            else
            {
                searchParamLastRow = dataRowIndex - 1;
            }
            //else
            //{
            //    ws.Cells["A" + dataRowIndex++].Value = "NO SEARCH PARAMS";
            //}
            using (ExcelRange rng = ws.Cells[string.Format("A{0}:A{1}",searchParamFirstRow, searchParamLastRow)])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(LightBlue);  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }

            ws.Cells[string.Format("A1:B{0}", dataRowIndex)].AutoFitColumns();

            dataRowIndex++;

            var startDataIndex = dataRowIndex;

            ws.Cells[String.Format("A{0}", dataRowIndex)].Value = "Product Id";
            ws.Cells[String.Format("B{0}", dataRowIndex)].Value = "License Number";
            ws.Cells[String.Format("C{0}", dataRowIndex)].Value = "Product Name";
            ws.Cells[String.Format("D{0}", dataRowIndex)].Value = "Product Type";
            ws.Cells[String.Format("E{0}", dataRowIndex)].Value = "Community";
            ws.Cells[String.Format("F{0}", dataRowIndex)].Value = "Region";
            ws.Cells[String.Format("G{0}", dataRowIndex)].Value = "Is Active";
            ws.Cells[String.Format("H{0}", dataRowIndex)].Value = "Is Complete";
            ws.Cells[String.Format("I{0}", dataRowIndex)].Value = "Is Valid";
            ws.Cells[String.Format("J{0}", dataRowIndex)].Value = "Errors Overriden";

            using (ExcelRange rng = ws.Cells[String.Format("A{0}:J{0}", dataRowIndex)])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;      
                rng.Style.Fill.BackgroundColor.SetColor(Color.Black);  
                rng.Style.Font.Color.SetColor(Color.White);
            }

            dataRowIndex++;

            var pl = productBs.GetProducts(MySessionVariables.ProductSearchItems.Value, false);

            foreach (var p in pl)
            {
                ws.Cells["A" + dataRowIndex].Value = p.id;
                ws.Cells["B" + dataRowIndex].Value = p.licenseNumber;
                ws.Cells["C" + dataRowIndex].Value = p.productName;
                //ws.Cells["A" + dataRowIndex].Hyperlink = new Uri(");
                ws.Cells["D" + dataRowIndex].Value = ResourceUtils.GetProductTypeLabel((ProductType)p.productTypeId);
                ws.Cells["E" + dataRowIndex].Value = (p.communityId != null) ? p.refCommunity.communityName : "";
                ws.Cells["F" + dataRowIndex].Value = (p.communityId != null) ? ResourceUtils.GetRegionLabel((Region)p.refCommunity.regionId) : ""; 
                ws.Cells["G" + dataRowIndex].Value = p.isActive;
                ws.Cells["H" + dataRowIndex].Value = p.isComplete;
                ws.Cells["I" + dataRowIndex].Value = p.isValid;
                ws.Cells["J" + dataRowIndex].Value = p.overrideErrors;

                dataRowIndex++;
            }

            ws.Cells[String.Format("A{0}:J{1}", startDataIndex, dataRowIndex - 1)].AutoFitColumns();

            string dateSuffix = DateTime.Now.ToString("yyyy_MM_dd_H_mm");

            string fileName = String.Format("{0}-{1}.xlsx", "ProductExport", dateSuffix);

            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", String.Format("attachment;  filename={0}", fileName));
            Response.BinaryWrite(pck.GetAsByteArray());
            Response.End();
            
            
        }
    }
}
