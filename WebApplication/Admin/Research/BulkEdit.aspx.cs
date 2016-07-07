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
	public partial class BulkEdit : System.Web.UI.Page
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

                lvProducts.DataSource = GenerateAccommodationList();
                lvProducts.DataBind();
            }
        }

        private List<BulkEditRow> GenerateAccommodationList()
        {
            ResearchBs researchBs = new ResearchBs();
           
            int myInteger;
            IQueryable<AccommodationOccupancy> previouslySavedData = null;

            List<BulkEditRow> berl = new List<BulkEditRow>();

            _month = Int32.Parse(ddlMonth.SelectedValue);
            _year = Int32.Parse(ddlYear.SelectedValue);

            if (_year >= DateTime.Now.Year && _month >= DateTime.Now.Month)
            {
                return berl;
            }

            var ln = Int32.TryParse(tbLicenseNumber.Text, out myInteger) ? myInteger : (int?)null;
            var includeRecentlySaved = cbKeepSavedProducts.Checked;

            var minModifiedDate = DateTime.Now.AddDays(-1);

            if (includeRecentlySaved)
            {
                previouslySavedData = researchBs.GetAccommodationsWithRecentlySavedData(_month, _year, minModifiedDate) ;
            }

            var productList = researchBs.GetAccommodationsForBulkEdit(_month, _year, ln, includeRecentlySaved);

            foreach (var p in productList)
            {
                var q = previouslySavedData != null ? (from psd in previouslySavedData
                        where psd.productId == p.id
                        select psd).FirstOrDefault() : null;

                berl.Add(q != null ? FillBulkEditRow(p, q) : FillDefaultBulkEditRow(p));
            }

            return berl;
        }

        protected BulkEditRow FillBulkEditRow(ProductCatalogue.DataAccess.Product p, AccommodationOccupancy ao)
        {
            BulkEditRow ber = new BulkEditRow();

            ber.ProductId = ao.productId.ToString();
            ber.LicenseNumber = ao.licenseNumber;
            ber.ProductName = p.productName;
            ber.Year = _year.ToString();
            ber.Month = _month.ToString();
            ber.OpenDays = ao.daysOpen.ToString();
            ber.AvailableUnitsDay = ao.unitsAvailable.ToString();
            ber.AvailableUnitsMonth = (ao.daysOpen*ao.unitsAvailable).ToString();
            ber.BusinessPct = ao.businessPct.ToString();
            ber.ConventionPct = ao.conventionPct.ToString();
            ber.MotorcoachPct = ao.motorcoachPct.ToString();
            ber.OtherPct = ao.otherPct.ToString();
            ber.VacationPct = ao.vacationPct.ToString();
            ber.ResearchClassId = ao.accommodationTypeId.ToString();
            ber.StarClassRating = ao.starClassRating.ToString();
            ber.TotalGuests = ao.totalGuests.ToString();
            ber.TotalUnitsSold = ao.totalUnitsSold.ToString();
            ber.PreviouslySavedData = "1";
            
            return ber;
        }

        protected BulkEditRow FillDefaultBulkEditRow(ProductCatalogue.DataAccess.Product p)
        {
            BulkEditRow ber = new BulkEditRow();

            int openDays = ((p.periodOfOperationTypeId == (int)PeriodOfOperationType.DateRange)
                 ? ResearchUtils.GetDefaultOpenDays(_month, _year, p.openMonth, p.closeMonth, p.openDay, p.closeDay)
                 : DateTime.DaysInMonth(_year, _month));

            int availableUnitsDay = (from pun in p.ProductUnitNumbers
                                     select pun.units).Sum();

            var rc = ResearchBs.GetResearchClass(p);
            var starRating = ResearchBs.GetResearchStarRating(p);

            ber.ResearchClassId = (rc != null) ? ((int)rc).ToString() : "";
            //ber.ResearchClassId = "1";
            ber.StarClassRating = (starRating != null) ? starRating.ratingValue.ToString() : "";

            ber.ProductId = p.id.ToString();
            ber.LicenseNumber = p.licenseNumber;
            ber.ProductName = p.productName;
            ber.Year = _year.ToString();
            ber.Month = _month.ToString();
            ber.OpenDays = openDays.ToString();
            ber.AvailableUnitsDay = availableUnitsDay.ToString();
            ber.AvailableUnitsMonth = (openDays * availableUnitsDay).ToString();

            ber.TotalUnitsSold = (openDays == 0) ? "0" : "";
            ber.TotalGuests = (openDays == 0) ? "0" : "";

            ber.PreviouslySavedData = "0";

            return ber;
        }

        private void lvProducts_PagePropertiesChanged(object sender, EventArgs e)
        {
            lvProducts.DataSource = GenerateAccommodationList();
            lvProducts.DataBind();
        }

        protected void btnSearch_OnClick(object sender, EventArgs e)
        {
            var al = GenerateAccommodationList();
            lvProducts.DataSource = al;
            lvProducts.DataBind();

            dpProductPager.SetPageProperties(0,20,true);
        }

        protected class BulkEditRow
        {
            public string Year { get; set; }
            public string Month { get; set; }
            public string LicenseNumber { get; set; }
            public string ProductName { get; set; }
            public string OpenDays { get; set; }
            public string AvailableUnitsDay { get; set; }
            public string AvailableUnitsMonth { get; set; }
            public string ProductId { get; set; }
            public string ResearchClassId { get; set; }
            public string StarClassRating { get; set; }
            public string TotalUnitsSold { get; set; }
            public string TotalGuests { get; set; }
            public string VacationPct { get; set; }
            public string BusinessPct { get; set; }
            public string ConventionPct { get; set; }
            public string MotorcoachPct { get; set; }
            public string OtherPct { get; set; }
            public string PreviouslySavedData { get; set; }

        }

        //ValidateAccommodationRowData(month, year, openDays, unitsAvailable, totalUnitsSold, totalGuests, vacationPct, businessPct, conventionPct, motorcoachPct, otherPct))
        private bool ValidateAccommodationRowData(int month, int year, int? openDays, int? unitsAvailable, int? unitsSold, int? totalGuests, int? vacationPct, int? businessPct, int? conventionPct, int? motorcoachPct, int? otherPct)
        {

            if (openDays == null || unitsAvailable == null || unitsSold == null || totalGuests == null)
            {
                return false;
            }

            //ensure openDays is less than or equal to number of days in month
            if (openDays > DateTime.DaysInMonth(year, month))
            {
                return false;
            }

            if ( unitsSold > ((openDays)*(unitsAvailable)) )
            {
                return false;
            }

            if (unitsSold > totalGuests)
            {
                return false;
            }

            if ((vacationPct != null || businessPct != null || conventionPct != null || motorcoachPct != null || otherPct != null) && ((vacationPct ?? 0) + (businessPct ?? 0) + (conventionPct ?? 0) + (motorcoachPct ?? 0) + (otherPct ?? 0) != 100))
            {
                return false;
            }

            return true;
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
                AccommodationOccupancy ao = new AccommodationOccupancy();
                byte myByte;
                short myShort;
                int myInt;

                var openDays = byte.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbOpenDays")).Text, out myByte) ? myByte : (byte?)null;
                var unitsAvailable = short.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbAvailableUnitsDay")).Text, out myShort) ? myShort : (short?)null;
                var totalUnitsSold = short.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbUnitsSold")).Text, out myShort) ? myShort : (short?)null;
                var totalGuests = int.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbTotalGuests")).Text, out myInt) ? myInt : (int?)null;

                var vacationPct = byte.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbVacationGuests")).Text, out myByte) ? myByte : (byte?)null;
                var businessPct = byte.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbBusinessGuests")).Text, out myByte) ? myByte : (byte?)null;
                var conventionPct = byte.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbConventionGuests")).Text, out myByte) ? myByte : (byte?)null;
                var motorcoachPct = byte.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbMotorcoachGuests")).Text, out myByte) ? myByte : (byte?)null;
                var otherPct = byte.TryParse(((TextBox)lvProducts.Items[i].FindControl("tbOtherGuests")).Text, out myByte) ? myByte : (byte?)null;

                if (!ValidateAccommodationRowData(month, year, openDays, unitsAvailable, totalUnitsSold, totalGuests, vacationPct, businessPct, conventionPct, motorcoachPct, otherPct))
                {
                    //if row is not valid, just skip it
                    continue;   
                }

                //primary key fields
                ao.productId = Int32.Parse(((HiddenField)lvProducts.Items[i].FindControl("hdnProductId")).Value);
                ao.reportDate = myReportDate;

                //mandatory fields
                ao.daysOpen = openDays.Value;
                ao.unitsAvailable = unitsAvailable.Value;
                ao.totalUnitsSold = totalUnitsSold.Value;
                ao.totalGuests = totalGuests.Value;

                //derived from product catalogue
                ao.licenseNumber = ((Literal)lvProducts.Items[i].FindControl("litLicenseNumber")).Text;

                ao.accommodationTypeId = byte.TryParse(((DropDownList)lvProducts.Items[i].FindControl("ddlResearchClass")).SelectedValue, out myByte) ? myByte : (byte?)null;
                ao.starClassRating = byte.TryParse(((DropDownList)lvProducts.Items[i].FindControl("ddlClassRating")).SelectedValue, out myByte) ? myByte : (byte?)null; 

                ao.lastModifiedDate = DateTime.Now;

                //optional fields
                ao.vacationPct = vacationPct;
                ao.businessPct = businessPct;
                ao.conventionPct = conventionPct;
                ao.motorcoachPct = motorcoachPct;
                ao.otherPct = otherPct;

                researchBs.ProcessAccommodationOccupancyRow(ao);
            }

            lvProducts.DataSource = GenerateAccommodationList();
            lvProducts.DataBind();

	    }

        [WebMethod]
        public static ResearchUtils.OccupancyRowDefaults DeleteResearchRow(string productId, string year, string month)
        {
            return ResearchUtils.DeleteResearchRow(productId, year, month);
        }
	}
}