using System;
using System.Collections.Generic;
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
    public partial class EditCampground : System.Web.UI.Page
    {
        private int _productId;
        private int _year;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                _productId = Int32.Parse(Request.QueryString["productId"]);
                _year = (Request.QueryString["year"] != null) ? Int32.Parse(Request.QueryString["year"]) : DateTime.Now.Year;

                for (var i = DateTime.Now.Year; i > 1992; i--)
                {
                    ddlYear.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }

                ddlYear.SelectedValue = _year.ToString();
                hdnProductId.Value = _productId.ToString();

                InitializeFormValues();

            }

        }

        private void GenerateContactList()
        {
            var productBs = new ProductBs();
            var businessBs = new BusinessBs();

            //var cl = productBs.GetProductContacts(_productId).ToList();
            var cl = productBs.GetProductContacts(_productId).ToList();

            var contactList = new List<ContactListItem>();

            foreach (ProductCatalogue.DataAccess.Contact c in cl)
            {

                var cli = new ContactListItem();

                cli.contactName = String.Format("{0} {1}", c.firstName, c.lastName);
                cli.contactType = ResourceUtils.GetBusinessContactTypeLabel((BusinessContactType)c.contactTypeId);
                cli.title = c.jobTitle;
                cli.email = c.email;

                var pl = businessBs.GetContactPhones(c.id).ToList();

                var myPhone = (from p in pl
                               where p.phoneTypeId == (int)(PhoneType.Primary)
                               select p).FirstOrDefault();

                if (myPhone != null)
                    cli.telephone = myPhone.phoneNumber;

                var myFax = (from p in pl
                             where p.phoneTypeId == (int)(PhoneType.Fax)
                             select p).FirstOrDefault();

                if (myFax != null)
                    cli.fax = myFax.phoneNumber;

                contactList.Add(cli);
            }

            contactList = contactList.OrderBy(c => c.contactType).ToList();

            lvContacts.DataSource = contactList;
            lvContacts.DataBind();
        }

        private void GenerateNoteList(int productId)
        {
            ProductBs productBs = new ProductBs();
            lvNotes.DataSource = productBs.GetProductNotes(productId);
            lvNotes.DataBind();
        }

        protected void btnNoteSubmit_onClick(object sender, EventArgs e)
        {
            ProductBs productBs = new ProductBs();

            var productId = Int32.Parse(hdnProductId.Value);

            productBs.AddNote(productId, tbNote.Text, null, HttpContext.Current.User.Identity.Name);

            GenerateNoteList(productId);
            ClearNoteForm();
        }

        private void ClearNoteForm()
        {
            tbNote.Text = "";
            // tbNoteReminderDate.Text = "";
        }

        private bool IsOperational(List<OperationPeriod> opl, int year, int month)
        {
            //short circuit for products with no operational period data
            if (opl.Count == 0)
            {
                return true;
            }

            foreach (var op in opl)
            {
                if ((op.openDate.Year < year || (op.openDate.Year == year && op.openDate.Month <= month)) && (op.closeDate == null || (op.closeDate.Value.Year > year || (op.closeDate.Value.Year == _year && op.closeDate.Value.Month >= month))))
                {
                    return true;
                }
            }
            return false;
        }

        private string GetSeasonalDateLabel(ProductCatalogue.DataAccess.Product p)
        {
            switch ((PeriodOfOperationType)p.periodOfOperationTypeId)
            {
                case PeriodOfOperationType.AllYear:
                    return "Open all year.";
                case PeriodOfOperationType.DateRange:
                    if (p.openMonth != null && p.closeMonth != null)
                    {
                        var myOpenDate = new DateTime(DateTime.Now.Year, p.openMonth.Value, (p.openDay != null) ? p.openDay.Value : 1);
                        var myCloseDate = new DateTime(DateTime.Now.Year, p.closeMonth.Value, (p.closeDay != null) ? p.closeDay.Value : 1);

                        //return String.Format("{0}-{1}", myOpenDate.ToString("mmm DD"), myCloseDate.ToString("mmm DD"));
                        return String.Format("{0} - {1}", String.Format("{0:MMM d}", myOpenDate), String.Format("{0:MMM d}", myCloseDate));
                    }
                    return "Dates not set.";
                case PeriodOfOperationType.Seasonal:
                    return "Open seasonally.";
                default:
                    return "";
            }
        }

        private void InitializeFormValues()
        {
            ResearchBs researchBs = new ResearchBs();
            ProductBs productBs = new ProductBs();

            var p = productBs.GetProduct(_productId, true);
            var coq = researchBs.GetCampgroundOccupancyData(_productId, _year);

            //set labels
            litProductName.Text = p.productName;
            litLicenseNumber.Text = p.licenseNumber;
            litRegion.Text = (p.communityId != null) ? p.refCommunity.refRegion.regionName : "";
            litSubRegion.Text = (p.communityId != null && p.refCommunity.subRegionId != null) ? p.refCommunity.refSubRegion.subRegionName : "";
            litCounty.Text = (p.communityId != null && p.refCommunity.countyId != null) ? p.refCommunity.refCounty.countyName : "";

            int seasonalUnitsDay = (from pun in p.ProductUnitNumbers
                                     where pun.unitTypeId == (int)ResearchUnitType.Seasonal
                                     select pun.units).Sum();

            int shortTermUnitsDay = (from pun in p.ProductUnitNumbers
                                    where pun.unitTypeId == (int)ResearchUnitType.ShortTerm
                                    select pun.units).Sum();

            //var researchClassUnits = ResearchBs.GetResearchClassUnitTotals(p);

            //var researchClass = ResearchBs.GetResearchClass(p);
            //var starRating = ResearchBs.GetResearchStarRating(p);
            var starRating = (from pcsr in p.ProductCanadaSelectRatings
                                  where pcsr.canadaSelectRatingTypeId == (int) CanadaSelectRatingType.CampingFacilities
                                  select pcsr.ratingValue).FirstOrDefault();

            litCanadaSelectClass.Text = "Camping Facilities";

            litCanadaSelectRating.Text = (starRating != 0) ? Math.Round((decimal)starRating / 2, 1).ToString() : "Not Set";

            litProductStatus.Text = (p.isActive) ? "Active" : "Inactive";

            var cll = new List<ClassListItem>();

            //foreach (var c in researchClassUnits.OrderByDescending(rcu => rcu.Value))
            //{
            //    var cli = new ClassListItem();

            //    cli.classLabel = ResourceUtils.GetResearchClassLabel(c.Key);
            //    cli.unitTotal = c.Value.ToString();

            //    cll.Add(cli);
            //}

            lvClasses.DataSource = cll;
            lvClasses.DataBind();

            var opl = productBs.GetProductOperationPeriods(p.id).ToList();

            lvOperationDates.DataSource = opl;
            lvOperationDates.DataBind();

            litSeasonalDates.Text = GetSeasonalDateLabel(p);

            GenerateContactList();
            GenerateNoteList(_productId);

            for (var i = 1; i <= 12; i++)
            {
                // months(rows) with no previously saved data
                if (!(from co in coq select co.reportDate.Month).Contains(i))
                {
                    bool isOperational = IsOperational(opl, _year, i);
                    int openDays = ((PeriodOfOperationType)p.periodOfOperationTypeId == PeriodOfOperationType.DateRange) ? ResearchUtils.GetDefaultOpenDays(i, _year, p.openMonth, p.closeMonth, p.openDay, p.closeDay) : DateTime.DaysInMonth(_year, i);

                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbOpenDays{0}", i))).Text = openDays.ToString();
                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbAvailableSeasonal{0}", i))).Text = seasonalUnitsDay.ToString();
                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbAvailableShortTerm{0}", i))).Text = shortTermUnitsDay.ToString();

                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbSeasonalUnitsSold{0}", i))).Text = (openDays == 0 && isOperational && (_year < DateTime.Now.Year || (_year == DateTime.Now.Year && i < DateTime.Now.Month))) ? "0" : "";
                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbShortTermUnitsSold{0}", i))).Text = (openDays == 0 && isOperational && (_year < DateTime.Now.Year || (_year == DateTime.Now.Year && i < DateTime.Now.Month))) ? "0" : "";
                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbTotalGuests{0}", i))).Text = (openDays == 0 && isOperational && (_year < DateTime.Now.Year || (_year == DateTime.Now.Year && i < DateTime.Now.Month))) ? "0" : "";

                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbTentsNs{0}", i))).Text = "";
                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbTentsCan{0}", i))).Text = "";
                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbTentsUs{0}", i))).Text = "";
                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbTentsInt{0}", i))).Text = "";

                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbRvsNs{0}", i))).Text = "";
                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbRvsCan{0}", i))).Text = "";
                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbRvsUs{0}", i))).Text = "";
                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbRvsInt{0}", i))).Text = "";

                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbCabinsNs{0}", i))).Text = "";
                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbCabinsCan{0}", i))).Text = "";
                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbCabinsUs{0}", i))).Text = "";
                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbCabinsInt{0}", i))).Text = "";

                    ((Literal)this.Master.FindControl("cphMainContent").FindControl(String.Format("litSeasonalTotalUnits{0}", i))).Text = "";
                    ((Literal)this.Master.FindControl("cphMainContent").FindControl(String.Format("litTotalUnitsSold{0}", i))).Text = "";

                    ((Literal)this.Master.FindControl("cphMainContent").FindControl(String.Format("litAvailableSeasonalMonth{0}", i))).Text = (seasonalUnitsDay * openDays).ToString();
                    ((Literal)this.Master.FindControl("cphMainContent").FindControl(String.Format("litAvailableShortTermMonth{0}", i))).Text = (shortTermUnitsDay * openDays).ToString();
                    ((Literal)this.Master.FindControl("cphMainContent").FindControl(String.Format("litAvailableUnitsMonth{0}", i))).Text = ((shortTermUnitsDay + seasonalUnitsDay)*openDays).ToString();
                    ((Literal)this.Master.FindControl("cphMainContent").FindControl(String.Format("litYear{0}", i))).Text = _year.ToString();

                    //((DropDownList)this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlResearchClass{0}", i))).SelectedValue = (researchClass != null) ? ((int)researchClass).ToString() : "";
                    ((DropDownList)this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlClassRating{0}", i))).SelectedValue = (starRating != 0) ? starRating.ToString() : "";

                    ((HiddenField)this.Master.FindControl("cphMainContent").FindControl(String.Format("hdnPreviouslySaved{0}", i))).Value = "0";

                    //((HiddenField)this.Master.FindControl("cphMainContent").FindControl(String.Format("hdnIsEnabled{0}", i))).Value = (isOperational && (_year < DateTime.Now.Year || (_year == DateTime.Now.Year && i < DateTime.Now.Month))) ? "1" : "0";
                    ((HiddenField)this.Master.FindControl("cphMainContent").FindControl(String.Format("hdnIsEnabled{0}", i))).Value = (isOperational) ? "1" : "0";
                }

            }

            //previously saved months(rows)
            foreach (var co in coq)
            {
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbOpenDays{0}", co.reportDate.Month))).Text = co.daysOpen.ToString();
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbAvailableSeasonal{0}", co.reportDate.Month))).Text = co.seasonalAvailable.ToString();
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbAvailableShortTerm{0}", co.reportDate.Month))).Text = co.shortTermAvailable.ToString();

                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbSeasonalUnitsSold{0}", co.reportDate.Month))).Text = co.seasonalSold.ToString();
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbShortTermUnitsSold{0}", co.reportDate.Month))).Text = co.shortTermSold.ToString();
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbTotalGuests{0}", co.reportDate.Month))).Text = co.totalGuests.ToString();

                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbTentsNs{0}", co.reportDate.Month))).Text = co.nsTents.ToString();
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbTentsCan{0}", co.reportDate.Month))).Text = co.canTents.ToString();
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbTentsUs{0}", co.reportDate.Month))).Text = co.usTents.ToString();
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbTentsInt{0}", co.reportDate.Month))).Text = co.intTents.ToString();

                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbRvsNs{0}", co.reportDate.Month))).Text = co.nsRvs.ToString();
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbRvsCan{0}", co.reportDate.Month))).Text = co.canRvs.ToString();
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbRvsUs{0}", co.reportDate.Month))).Text = co.usRvs.ToString();
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbRvsInt{0}", co.reportDate.Month))).Text = co.intRvs.ToString();

                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbCabinsNs{0}", co.reportDate.Month))).Text = co.nsCabins.ToString();
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbCabinsCan{0}", co.reportDate.Month))).Text = co.canCabins.ToString();
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbCabinsUs{0}", co.reportDate.Month))).Text = co.usCabins.ToString();
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbCabinsInt{0}", co.reportDate.Month))).Text = co.intCabins.ToString();

                ((Literal)this.Master.FindControl("cphMainContent").FindControl(String.Format("litAvailableSeasonalMonth{0}", co.reportDate.Month))).Text = (co.seasonalAvailable * co.daysOpen).ToString();
                ((Literal)this.Master.FindControl("cphMainContent").FindControl(String.Format("litAvailableShortTermMonth{0}", co.reportDate.Month))).Text = (co.shortTermAvailable * co.daysOpen).ToString();
                ((Literal)this.Master.FindControl("cphMainContent").FindControl(String.Format("litAvailableUnitsMonth{0}", co.reportDate.Month))).Text = ((co.shortTermAvailable + co.seasonalAvailable) * co.daysOpen).ToString();

                ((Literal)this.Master.FindControl("cphMainContent").FindControl(String.Format("litSeasonalTotalUnits{0}", co.reportDate.Month))).Text = (co.seasonalSold * co.daysOpen).ToString();
                ((Literal)this.Master.FindControl("cphMainContent").FindControl(String.Format("litTotalUnitsSold{0}", co.reportDate.Month))).Text = ((co.seasonalSold * co.daysOpen) + co.shortTermSold).ToString();

                ((Literal)this.Master.FindControl("cphMainContent").FindControl(String.Format("litYear{0}", co.reportDate.Month))).Text = _year.ToString();

                ((HiddenField)this.Master.FindControl("cphMainContent").FindControl(String.Format("hdnPreviouslySaved{0}", co.reportDate.Month))).Value = "1";

                ((DropDownList)this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlClassRating{0}", co.reportDate.Month))).SelectedValue = (co.starClassRating != null) ? co.starClassRating.ToString() : "";

                //should not happen ... i.e. should not be future dated research data
                //((HiddenField)this.Master.FindControl("cphMainContent").FindControl(String.Format("hdnIsEnabled{0}", co.reportDate.Month))).Value = (IsOperational(opl, _year, co.reportDate.Month) && (_year < DateTime.Now.Year || (_year == DateTime.Now.Year && co.reportDate.Month < DateTime.Now.Month))) ? "1" : "0";
            }
        }

        protected void ddlYear_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            _year = Int32.Parse(ddlYear.SelectedValue);
            _productId = Int32.Parse(hdnProductId.Value);
            InitializeFormValues();
        }

        protected void btnSubmit_OnClick(object sender, EventArgs e)
        {
            _year = Int32.Parse(ddlYear.SelectedValue);
            _productId = Int32.Parse(hdnProductId.Value);

            ProductBs productBs = new ProductBs();
            ProductCatalogue.DataAccess.Product p = productBs.GetProduct(_productId, true);

            ResearchBs researchBs = new ResearchBs();

            for (var i = 1; i <= 12; i++)
            {
                var myReportDate = new DateTime(_year, i, 1);

                byte myByte;
                short myShort;
                int myInt;

                var openDays = byte.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbOpenDays{0}", i))).Text, out myByte) ? myByte : (byte?)null;
                var seasonalAvailable = short.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbAvailableSeasonal{0}", i))).Text, out myShort) ? myShort : (short?)null;
                var shortTermAvailable = short.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbAvailableShortTerm{0}", i))).Text, out myShort) ? myShort : (short?)null;
                var seasonalSold = int.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbSeasonalUnitsSold{0}", i))).Text, out myInt) ? myInt : (int?)null;
                var shortTermSold = int.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbShortTermUnitsSold{0}", i))).Text, out myInt) ? myInt : (int?)null;
                var totalGuests = int.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbTotalGuests{0}", i))).Text, out myInt) ? myInt : (int?)null;

                var nsTents = int.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbTentsNs{0}", i))).Text, out myInt) ? myInt : (int?)null;
                var canTents = int.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbTentsCan{0}", i))).Text, out myInt) ? myInt : (int?)null;
                var usTents = int.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbTentsUs{0}", i))).Text, out myInt) ? myInt : (int?)null;
                var intTents = int.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbTentsInt{0}", i))).Text, out myInt) ? myInt : (int?)null;

                var nsRvs = int.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbRvsNs{0}", i))).Text, out myInt) ? myInt : (int?)null;
                var canRvs = int.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbRvsCan{0}", i))).Text, out myInt) ? myInt : (int?)null;
                var usRvs = int.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbRvsUs{0}", i))).Text, out myInt) ? myInt : (int?)null;
                var intRvs = int.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbRvsInt{0}", i))).Text, out myInt) ? myInt : (int?)null;

                var nsCabins = int.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbCabinsNs{0}", i))).Text, out myInt) ? myInt : (int?)null;
                var canCabins = int.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbCabinsCan{0}", i))).Text, out myInt) ? myInt : (int?)null;
                var usCabins = int.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbCabinsUs{0}", i))).Text, out myInt) ? myInt : (int?)null;
                var intCabins = int.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbCabinsInt{0}", i))).Text, out myInt) ? myInt : (int?)null;

                if (!ResearchUtils.ValidateCampgroundRowData(i, _year, openDays, seasonalAvailable, shortTermAvailable, seasonalSold, shortTermSold, totalGuests))
                {
                    //if row is not valid, just skip it
                    continue;
                }

                CampgroundOccupancy co = new CampgroundOccupancy();

                //primary key fields
                co.productId = _productId;
                co.reportDate = myReportDate;

                //mandatory fields
                co.daysOpen = openDays.Value;
                co.seasonalAvailable = seasonalAvailable.Value;
                co.seasonalSold = seasonalSold.Value;
                co.shortTermAvailable = shortTermAvailable.Value;
                co.shortTermSold = shortTermSold.Value;
                co.totalGuests = totalGuests.Value;

                //co.accommodationTypeId = byte.TryParse(((DropDownList)this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlResearchClass{0}", i))).SelectedValue, out myByte) ? myByte : (byte?)null;
                co.starClassRating = byte.TryParse(((DropDownList)this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlClassRating{0}", i))).SelectedValue, out myByte) ? myByte : (byte?)null;

                co.licenseNumber = litLicenseNumber.Text;

                co.lastModifiedDate = DateTime.Now;

                //optional fields
                co.nsTents = (nsTents.HasValue) ? nsTents.Value : (int?)null;
                co.canTents = (canTents.HasValue) ? canTents.Value : (int?)null;
                co.usTents = (usTents.HasValue) ? usTents.Value : (int?)null;
                co.intTents = (intTents.HasValue) ? intTents.Value : (int?)null;

                co.nsRvs = (nsRvs.HasValue) ? nsRvs.Value : (int?)null;
                co.canRvs = (canRvs.HasValue) ? canRvs.Value : (int?)null;
                co.usRvs = (usRvs.HasValue) ? usRvs.Value : (int?)null;
                co.intRvs = (intRvs.HasValue) ? intRvs.Value : (int?)null;

                co.nsCabins = (nsCabins.HasValue) ? nsCabins.Value : (int?)null;
                co.canCabins = (canCabins.HasValue) ? canCabins.Value : (int?)null;
                co.usCabins = (usCabins.HasValue) ? usCabins.Value : (int?)null;
                co.intCabins = (intCabins.HasValue) ? intCabins.Value : (int?)null;

                researchBs.ProcessCampgroundOccupancyRow(co);
            }

            InitializeFormValues();

        }

        [WebMethod]
        public static ResearchUtils.CampgroundOccupancyRowDefaults DeleteResearchRow(string productId, string year, string month)
        {
            return ResearchUtils.DeleteCampgroundResearchRow(productId, year, month);
        }

        private class ClassListItem
        {
            public string classLabel { get; set; }
            public string unitTotal { get; set; }

        }

        private class ContactListItem
        {
            public string contactName { get; set; }
            public string contactType { get; set; }
            public string title { get; set; }
            public string email { get; set; }
            public string telephone { get; set; }
            public string fax { get; set; }
        }


    }
}