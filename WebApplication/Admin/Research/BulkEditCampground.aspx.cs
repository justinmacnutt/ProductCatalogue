using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using ProductCatalogue.BusinessServices;
using ProductCatalogue.DataAccess;
using ProductCatalogue.DataAccess.Enumerations;
using WebApplication.Utilities;

namespace WebApplication.Admin.Research
{
	public partial class BulkEditCampground : System.Web.UI.Page
	{
        private int _month;
        private int _year;

        protected void Page_Load(object sender, EventArgs e)
        {
            lvProducts.PagePropertiesChanged += new EventHandler(lvProducts_PagePropertiesChanged);

            if (!IsPostBack)
            {
                //_month = 10;
                //_year = 2011;

                ddlProductType.Items.Add(new ListItem(ResourceUtils.GetProductTypeLabel(ProductType.Accommodation), ((int)ProductType.Accommodation).ToString()));
                ddlProductType.Items.Add(new ListItem(ResourceUtils.GetProductTypeLabel(ProductType.Campground), ((int)ProductType.Campground).ToString()));

                ddlProductType.SelectedValue = ((int) ProductType.Campground).ToString();

                for (var i = DateTime.Now.Year; i > 1992; i--)
                {
                    ddlYear.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }

                for (var i = 1; i <= 12; i++)
                {
                    ddlMonth.Items.Add(new ListItem(CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(i), i.ToString()));
                }

                //if january default to december of previous year
                if (DateTime.Now.Month == 1)
                {
                    ddlYear.SelectedValue = (DateTime.Now.Year - 1).ToString();
                    ddlMonth.SelectedValue = "12";
                }
                else
                {
                    ddlMonth.SelectedValue = (DateTime.Now.Month - 1).ToString();    
                }

                _month = Int32.Parse(ddlMonth.SelectedValue);
                _year = Int32.Parse(ddlYear.SelectedValue);

                //ResearchBs rb = new ResearchBs();
                //var x = rb.GetOperationalAccommodations(_month, _year);

                lvProducts.DataSource = GenerateCampgroundList();
                lvProducts.DataBind();
            }
        }

        private List<BulkEditCampgroundRow> GenerateCampgroundList()
        {
            ResearchBs researchBs = new ResearchBs();
           
            int myInteger;
            IQueryable<CampgroundOccupancy> previouslySavedData = null;

            List<BulkEditCampgroundRow> berl = new List<BulkEditCampgroundRow>();

            _month = Int32.Parse(ddlMonth.SelectedValue);
            _year = Int32.Parse(ddlYear.SelectedValue);

            if (_year >= DateTime.Now.Year && _month >= DateTime.Now.Month)
            {
                return berl;
            }

            var ln = tbLicenseNumber.Text;
            var includeRecentlySaved = cbKeepSavedProducts.Checked;

            var minModifiedDate = DateTime.Now.AddDays(-1);

            if (includeRecentlySaved)
            {
                previouslySavedData = researchBs.GetCampgroundsWithRecentlySavedData(_month, _year, minModifiedDate) ;
            }

            var productList = researchBs.GetCampgroundsForBulkEdit(_month, _year, ln, includeRecentlySaved);

            foreach (var p in productList)
            {
                var q = previouslySavedData != null ? (from psd in previouslySavedData
                        where psd.productId == p.id
                        select psd).FirstOrDefault() : null;

                berl.Add(q != null ? FillBulkEditRow(p, q) : FillDefaultBulkEditRow(p));
            }

            return berl;
        }

        protected BulkEditCampgroundRow FillBulkEditRow(ProductCatalogue.DataAccess.Product p, CampgroundOccupancy co)
        {
            BulkEditCampgroundRow becr = new BulkEditCampgroundRow();

            becr.ProductId = co.productId.ToString();
            becr.LicenseNumber = co.licenseNumber;
            becr.ProductName = p.productName;
            becr.Year = _year.ToString();
            becr.Month = _month.ToString();
            becr.OpenDays = co.daysOpen.ToString();

            becr.AvailableSeasonal = co.seasonalAvailable.ToString();
            becr.AvailableSeasonalMonth = (co.daysOpen*co.seasonalAvailable).ToString();
            becr.AvailableShortTerm = co.shortTermAvailable.ToString();
            becr.AvailableShortTermMonth = (co.daysOpen*co.shortTermAvailable).ToString();
            becr.AvailableUnitsMonth = (co.daysOpen*(co.seasonalAvailable + co.shortTermAvailable)).ToString();

            becr.TentsNs = co.nsTents.ToString();
            becr.TentsCan = co.canTents.ToString();
            becr.TentsUs = co.usTents.ToString();
            becr.TentsInt = co.intTents.ToString();

            becr.RvsNs = co.nsRvs.ToString();
            becr.RvsCan = co.canRvs.ToString();
            becr.RvsUs = co.usRvs.ToString();
            becr.RvsInt = co.intRvs.ToString();

            becr.CabinsNs = co.nsCabins.ToString();
            becr.CabinsCan = co.canCabins.ToString();
            becr.CabinsUs = co.usCabins.ToString();
            becr.CabinsInt = co.intCabins.ToString();

            becr.SeasonalUnitsSold = co.seasonalSold.ToString();
            becr.ShortTermUnitsSold = co.shortTermSold.ToString();
            becr.StarClassRating = co.starClassRating.ToString();
            becr.TotalGuests = co.totalGuests.ToString();
            becr.TotalSeasonalUnits = (co.daysOpen*co.seasonalSold).ToString();
            becr.TotalUnitsSold = ((co.daysOpen * co.seasonalSold)+ co.shortTermSold).ToString();

            becr.StarClassRating = co.starClassRating.ToString();

            becr.PreviouslySavedData = "1";
            
            return becr;
        }

        protected BulkEditCampgroundRow FillDefaultBulkEditRow(ProductCatalogue.DataAccess.Product p)
        {
            BulkEditCampgroundRow becr = new BulkEditCampgroundRow();

            int openDays = ((p.periodOfOperationTypeId == (int)PeriodOfOperationType.DateRange)
                 ? ResearchUtils.GetDefaultOpenDays(_month, _year, p.openMonth, p.closeMonth, p.openDay, p.closeDay)
                 : DateTime.DaysInMonth(_year, _month));

            int seasonalUnitsDay = (from pun in p.ProductUnitNumbers
                                    where pun.unitTypeId == (int)ResearchUnitType.Seasonal
                                    select pun.units).Sum();

            int shortTermUnitsDay = (from pun in p.ProductUnitNumbers
                                     where pun.unitTypeId == (int)ResearchUnitType.ShortTerm
                                     select pun.units).Sum();

            var starRating = (from pcsr in p.ProductCanadaSelectRatings
                              where pcsr.canadaSelectRatingTypeId == (int)CanadaSelectRatingType.CampingFacilities
                              select pcsr.ratingValue).FirstOrDefault();

            //ber.ResearchClassId = "1";
            becr.StarClassRating = (starRating != 0) ? starRating.ToString() : "";

            becr.ProductId = p.id.ToString();
            becr.LicenseNumber = p.licenseNumber;
            becr.ProductName = p.productName;
            becr.Year = _year.ToString();
            becr.Month = _month.ToString();
            becr.OpenDays = openDays.ToString();
            becr.AvailableSeasonal = seasonalUnitsDay.ToString();
            becr.AvailableShortTerm = shortTermUnitsDay.ToString();
            becr.AvailableSeasonalMonth = (openDays*seasonalUnitsDay).ToString();
            becr.AvailableShortTermMonth = (openDays * shortTermUnitsDay).ToString();
            becr.AvailableUnitsMonth = (openDays*(seasonalUnitsDay+shortTermUnitsDay)).ToString();

            becr.SeasonalUnitsSold = (openDays == 0) ? "0" : "";
            becr.ShortTermUnitsSold = (openDays == 0) ? "0" : "";
            becr.TotalGuests = (openDays == 0) ? "0" : "";

            becr.TotalSeasonalUnits = (openDays == 0) ? "0" : "";
            becr.TotalUnitsSold = (openDays == 0) ? "0" : "";

            becr.PreviouslySavedData = "0";

            return becr;
        }

        private void lvProducts_PagePropertiesChanged(object sender, EventArgs e)
        {
            lvProducts.DataSource = GenerateCampgroundList();
            lvProducts.DataBind();
        }

        protected void btnSearch_OnClick(object sender, EventArgs e)
        {
            var al = GenerateCampgroundList();
            lvProducts.DataSource = al;
            lvProducts.DataBind();

            dpProductPager.SetPageProperties(0,20,true);
        }

        protected class BulkEditCampgroundRow
        {
            public string Year { get; set; }
            public string Month { get; set; }
            public string LicenseNumber { get; set; }
            public string ProductName { get; set; }
            public string OpenDays { get; set; }
            
            public string AvailableSeasonal { get; set; }
            public string AvailableShortTerm { get; set; }

            public string AvailableSeasonalMonth { get; set; }
            public string AvailableShortTermMonth { get; set; }
            public string AvailableUnitsMonth { get; set; }

            public string ProductId { get; set; }

            public string StarClassRating { get; set; }
            
            public string SeasonalUnitsSold { get; set; }
            public string ShortTermUnitsSold { get; set; }
            
            public string TotalGuests { get; set; }

            public string TotalSeasonalUnits { get; set; }
            public string TotalUnitsSold { get; set; }
            
            public string TentsNs { get; set; }
            public string TentsCan { get; set; }
            public string TentsUs { get; set; }
            public string TentsInt { get; set; }
            public string TentsTotal { get; set; }

            public string RvsNs { get; set; }
            public string RvsCan { get; set; }
            public string RvsUs { get; set; }
            public string RvsInt { get; set; }
            public string RvsTotal { get; set; }

            public string CabinsNs { get; set; }
            public string CabinsCan { get; set; }
            public string CabinsUs { get; set; }
            public string CabinsInt { get; set; }
            public string CabinsTotal { get; set; }

            public string PreviouslySavedData { get; set; }
        }

        protected void btnSave_OnClick(object sender, EventArgs e)
	    {
            //ProductBs productBs = new ProductBs();
            ResearchBs researchBs = new ResearchBs();
            var month = Int32.Parse(ddlMonth.SelectedValue);
            var year = Int32.Parse(ddlYear.SelectedValue);
            var myReportDate = new DateTime(year, month, 1);

	        for (var i = 0; i < lvProducts.Items.Count;i++)
            {
                CampgroundOccupancy co = new CampgroundOccupancy();
                byte myByte;
                short myShort;
                int myInt;

                var openDays = byte.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbOpenDays")).Text, out myByte) ? myByte : (byte?)null;
                var seasonalAvailable = short.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbAvailableSeasonal")).Text, out myShort) ? myShort : (short?)null;
                var shortTermAvailable = short.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbAvailableShortTerm")).Text, out myShort) ? myShort : (short?)null;
                var seasonalSold = short.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbSeasonalUnitsSold")).Text, out myShort) ? myShort : (short?)null;
                var shortTermSold = short.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbShortTermUnitsSold")).Text, out myShort) ? myShort : (short?)null;
                var totalGuests = int.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbTotalGuests")).Text, out myInt) ? myInt : (int?)null;

                var tentsNs = int.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbTentsNs")).Text, out myInt) ? myInt : (int?)null;
                var tentsCan = int.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbTentsCan")).Text, out myInt) ? myInt : (int?)null;
                var tentsUs = int.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbTentsUs")).Text, out myInt) ? myInt : (int?)null;
                var tentsInt = int.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbTentsInt")).Text, out myInt) ? myInt : (int?)null;

                var rvsNs = int.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbRvsNs")).Text, out myInt) ? myInt : (int?)null;
                var rvsCan = int.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbRvsCan")).Text, out myInt) ? myInt : (int?)null;
                var rvsUs = int.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbRvsUs")).Text, out myInt) ? myInt : (int?)null;
                var rvsInt = int.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbRvsInt")).Text, out myInt) ? myInt : (int?)null;

                var cabinsNs = int.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbCabinsNs")).Text, out myInt) ? myInt : (int?)null;
                var cabinsCan = int.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbCabinsCan")).Text, out myInt) ? myInt : (int?)null;
                var cabinsUs = int.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbCabinsUs")).Text, out myInt) ? myInt : (int?)null;
                var cabinsInt = int.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbCabinsInt")).Text, out myInt) ? myInt : (int?)null;

                if (!ResearchUtils.ValidateCampgroundRowData(month, year, openDays, seasonalAvailable,shortTermAvailable, seasonalSold, shortTermSold,totalGuests))
                {
                    //if row is not valid, just skip it
                    continue;   
                }

                //primary key fields
                co.productId = Int32.Parse(((HiddenField)lvProducts.Items[i].FindControl("hdnProductId")).Value);
                co.reportDate = myReportDate;

                //mandatory fields
                co.daysOpen = openDays.Value;
                co.seasonalAvailable = seasonalAvailable.Value;
                co.shortTermAvailable = shortTermAvailable.Value;
                co.seasonalSold = seasonalSold.Value;
                co.shortTermSold = shortTermSold.Value;
                co.totalGuests = totalGuests.Value;

                co.nsTents = tentsNs;
                co.canTents = tentsCan;
                co.usTents = tentsUs;
                co.intTents = tentsInt;

                co.nsRvs = rvsNs;
                co.canRvs = rvsCan;
                co.usRvs = rvsUs;
                co.intRvs = rvsInt;

                co.nsCabins = cabinsNs;
                co.canCabins = cabinsCan;
                co.usCabins = cabinsUs;
                co.intCabins = cabinsInt;

                //derived from product catalogue
                co.licenseNumber = ((Literal)lvProducts.Items[i].FindControl("litLicenseNumber")).Text;

                //co.starClassRating = byte.TryParse(((DropDownList)lvProducts.Items[i].FindControl("ddlClassRating")).SelectedValue, out myByte) ? myByte : (byte?)null; 

                co.lastModifiedDate = DateTime.Now;

                researchBs.ProcessCampgroundOccupancyRow(co);
            }

            lvProducts.DataSource = GenerateCampgroundList();
            lvProducts.DataBind();

	    }

        [WebMethod]
        public static ResearchUtils.CampgroundOccupancyRowDefaults DeleteResearchRow(string productId, string year, string month)
        {
            return ResearchUtils.DeleteCampgroundResearchRow(productId, year, month);
        }
	}
}