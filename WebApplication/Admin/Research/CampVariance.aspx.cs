using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication.Admin.Research
{
    public partial class CampVariance : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                for (var i = DateTime.Now.Year; i > 1992; i--)
                {
                    ddlStartYear.Items.Add(new ListItem(i.ToString(), i.ToString()));
                    ddlEndYear.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }

                for (var i = 1; i <= 12; i++)
                {
                    ddlStartMonth.Items.Add(new ListItem(CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(i), i.ToString()));
                    ddlEndMonth.Items.Add(new ListItem(CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(i), i.ToString()));
                }
            }

        }
    }
}