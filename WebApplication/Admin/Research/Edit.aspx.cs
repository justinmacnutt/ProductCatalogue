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
    public partial class Edit : System.Web.UI.Page
    {
        private int _productId;
        private int _year;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                _productId = Int32.Parse(Request.QueryString["productId"]);
                _year = ( Request.QueryString["year"] != null) ? Int32.Parse(Request.QueryString["year"]) : DateTime.Now.Year;

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
                                      where p.phoneTypeId == (int) (PhoneType.Primary)
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

        private bool IsOperational (List<OperationPeriod> opl, int year, int month)
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

        private string GetSeasonalDateLabel (ProductCatalogue.DataAccess.Product p)
        {
            switch((PeriodOfOperationType)p.periodOfOperationTypeId)
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
            var aoq = researchBs.GetAccommodationOccupancyData(_productId, _year);

            //set labels
            litProductName.Text = p.productName;
            litLicenseNumber.Text = p.licenseNumber;
            litRegion.Text = (p.communityId != null) ? p.refCommunity.refRegion.regionName : "";
            litSubRegion.Text = (p.communityId != null && p.refCommunity.subRegionId != null) ? p.refCommunity.refSubRegion.subRegionName : "";
            litCounty.Text = (p.communityId != null && p.refCommunity.countyId != null) ? p.refCommunity.refCounty.countyName : "";

            int availableUnitsDay = (from pun in p.ProductUnitNumbers
                                     select pun.units).Sum();

            var researchClassUnits = ResearchBs.GetResearchClassUnitTotals(p);

            var researchClass = ResearchBs.GetResearchClass(p);
            var starRating = ResearchBs.GetResearchStarRating(p);

            litCanadaSelectClass.Text = (starRating != null)
                                             ? ResourceUtils.GetCanadaSelectRatingTypeLabel(
                                                 (CanadaSelectRatingType) starRating.canadaSelectRatingTypeId)
                                             : "Not Set";

            litCanadaSelectRating.Text = (starRating != null) ? Math.Round((decimal)starRating.ratingValue / 2, 1).ToString() : "Not Set";

            litProductStatus.Text = (p.isActive) ? "Active" : "Inactive";

            var cll = new List<ClassListItem>();

            foreach (var c in researchClassUnits.OrderByDescending(rcu => rcu.Value))
            {
                var cli = new ClassListItem();

                cli.classLabel = ResourceUtils.GetResearchClassLabel(c.Key);
                cli.unitTotal = c.Value.ToString();

                cll.Add(cli);
            }

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
                if (!(from ao in aoq select ao.reportDate.Month).Contains(i))
                {
                    bool isOperational = IsOperational(opl, _year, i);
                    int openDays = ((PeriodOfOperationType)p.periodOfOperationTypeId == PeriodOfOperationType.DateRange) ? ResearchUtils.GetDefaultOpenDays(i, _year, p.openMonth, p.closeMonth, p.openDay, p.closeDay) : DateTime.DaysInMonth(_year, i);

                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbOpenDays{0}", i))).Text = openDays.ToString();
                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbAvailableUnitsDay{0}", i))).Text = availableUnitsDay.ToString();

                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbUnitsSold{0}", i))).Text = (openDays == 0 && isOperational && (_year < DateTime.Now.Year || (_year == DateTime.Now.Year && i < DateTime.Now.Month))) ? "0" : "";
                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbTotalGuests{0}", i))).Text = (openDays == 0 && isOperational && (_year < DateTime.Now.Year || (_year == DateTime.Now.Year && i < DateTime.Now.Month))) ? "0" : "";

                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbVacationGuests{0}", i))).Text = "";
                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbBusinessGuests{0}", i))).Text = "";
                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbConventionGuests{0}", i))).Text = "";
                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbMotorcoachGuests{0}", i))).Text = "";
                    ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbOtherGuests{0}", i))).Text = "";
                    
                    ((Literal)this.Master.FindControl("cphMainContent").FindControl(String.Format("litAvailableUnitsMonth{0}", i))).Text = (availableUnitsDay * openDays).ToString();
                    ((Literal)this.Master.FindControl("cphMainContent").FindControl(String.Format("litYear{0}", i))).Text = _year.ToString();

                    ((DropDownList)this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlResearchClass{0}", i))).SelectedValue = (researchClass != null) ? ((int)researchClass).ToString() : "";
                    ((DropDownList)this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlClassRating{0}", i))).SelectedValue = (starRating != null) ? starRating.ratingValue.ToString() : "";

                    ((HiddenField)this.Master.FindControl("cphMainContent").FindControl(String.Format("hdnPreviouslySaved{0}", i))).Value = "0";
                    
                    //((HiddenField)this.Master.FindControl("cphMainContent").FindControl(String.Format("hdnIsEnabled{0}", i))).Value = (isOperational && (_year < DateTime.Now.Year || (_year == DateTime.Now.Year && i < DateTime.Now.Month))) ? "1" : "0";
                    ((HiddenField)this.Master.FindControl("cphMainContent").FindControl(String.Format("hdnIsEnabled{0}", i))).Value = (isOperational) ? "1" : "0";
                }

            }

            //previously saved months(rows)
            foreach (var ao in aoq)
            {
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbOpenDays{0}", ao.reportDate.Month))).Text = ao.daysOpen.ToString();
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbAvailableUnitsDay{0}", ao.reportDate.Month))).Text = ao.unitsAvailable.ToString();
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbUnitsSold{0}", ao.reportDate.Month))).Text = ao.totalUnitsSold.ToString();
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbTotalGuests{0}", ao.reportDate.Month))).Text = ao.totalGuests.ToString();
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbVacationGuests{0}", ao.reportDate.Month))).Text = ao.vacationPct.ToString();
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbBusinessGuests{0}", ao.reportDate.Month))).Text = ao.businessPct.ToString();
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbConventionGuests{0}", ao.reportDate.Month))).Text = ao.conventionPct.ToString();
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbMotorcoachGuests{0}", ao.reportDate.Month))).Text = ao.motorcoachPct.ToString();
                ((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbOtherGuests{0}", ao.reportDate.Month))).Text = ao.otherPct.ToString();

                ((DropDownList)this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlResearchClass{0}", ao.reportDate.Month))).SelectedValue = ao.accommodationTypeId.ToString();
                ((DropDownList)this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlClassRating{0}", ao.reportDate.Month))).SelectedValue = ao.starClassRating.ToString();

                ((Literal)this.Master.FindControl("cphMainContent").FindControl(String.Format("litAvailableUnitsMonth{0}", ao.reportDate.Month))).Text = (ao.unitsAvailable * ao.daysOpen).ToString();
                ((Literal)this.Master.FindControl("cphMainContent").FindControl(String.Format("litYear{0}", ao.reportDate.Month))).Text = _year.ToString();

                ((HiddenField)this.Master.FindControl("cphMainContent").FindControl(String.Format("hdnPreviouslySaved{0}", ao.reportDate.Month))).Value = "1";

                //should not happen ... i.e. should not be future dated research data
                //((HiddenField)this.Master.FindControl("cphMainContent").FindControl(String.Format("hdnIsEnabled{0}", ao.reportDate.Month))).Value = (IsOperational(opl, _year, ao.reportDate.Month) && (_year < DateTime.Now.Year || (_year == DateTime.Now.Year && ao.reportDate.Month < DateTime.Now.Month))) ? "1" : "0";
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
                var unitsAvailable = short.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbAvailableUnitsDay{0}", i))).Text, out myShort) ? myShort : (short?)null;
                var totalUnitsSold = short.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbUnitsSold{0}", i))).Text, out myShort) ? myShort : (short?)null;
                var totalGuests = int.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbTotalGuests{0}", i))).Text, out myInt) ? myInt : (int?)null;

                var vacationPct = byte.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbVacationGuests{0}", i))).Text, out myByte) ? myByte : (byte?)null;
                var businessPct = byte.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbBusinessGuests{0}", i))).Text, out myByte) ? myByte : (byte?)null;
                var conventionPct = byte.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbConventionGuests{0}", i))).Text, out myByte) ? myByte : (byte?)null;
                var motorcoachPct = byte.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbMotorcoachGuests{0}", i))).Text, out myByte) ? myByte : (byte?)null;
                var otherPct = byte.TryParse(((TextBox)this.Master.FindControl("cphMainContent").FindControl(String.Format("tbOtherGuests{0}", i))).Text, out myByte) ? myByte : (byte?)null;

                if (!ValidateAccommodationRowData(i, _year, openDays, unitsAvailable, totalUnitsSold, totalGuests, vacationPct, businessPct, conventionPct, motorcoachPct, otherPct))
                {
                    //if row is not valid, just skip it
                    continue;
                }

                AccommodationOccupancy ao = new AccommodationOccupancy();
                
                //primary key fields
                ao.productId = _productId;
                ao.reportDate = myReportDate;

                //mandatory fields
                ao.daysOpen = openDays.Value;
                ao.unitsAvailable = unitsAvailable.Value;
                ao.totalUnitsSold = totalUnitsSold.Value;
                ao.totalGuests = totalGuests.Value;

                ao.accommodationTypeId = byte.TryParse(((DropDownList)this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlResearchClass{0}", i))).SelectedValue, out myByte) ? myByte : (byte?)null;
                ao.starClassRating = byte.TryParse(((DropDownList)this.Master.FindControl("cphMainContent").FindControl(String.Format("ddlClassRating{0}", i))).SelectedValue, out myByte) ? myByte : (byte?)null;

                ao.licenseNumber = litLicenseNumber.Text;

                ao.lastModifiedDate = DateTime.Now;

                //optional fields
                ao.vacationPct = vacationPct;
                ao.businessPct = businessPct;
                ao.conventionPct = conventionPct;
                ao.motorcoachPct = motorcoachPct;
                ao.otherPct = otherPct;

                researchBs.ProcessAccommodationOccupancyRow(ao);
            }

            InitializeFormValues();
           
        }

        [WebMethod]
        public static ResearchUtils.OccupancyRowDefaults DeleteResearchRow(string productId, string year, string month)
        {
            return ResearchUtils.DeleteResearchRow(productId, year, month);
        }


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

            if (unitsSold > ((openDays) * (unitsAvailable)))
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