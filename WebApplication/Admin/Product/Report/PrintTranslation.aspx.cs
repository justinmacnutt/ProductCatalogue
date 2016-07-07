using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ProductCatalogue.BusinessServices;
using ProductCatalogue.DataAccess;
using ProductCatalogue.DataAccess.Enumerations;
using WebApplication.Utilities;
using WebApplication.ValueObjects;

namespace WebApplication.Admin.Report
{
    public partial class PrintTranslation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Populate dropdown lists for search
            if (!IsPostBack)
            {
                ProductBs productBs = new ProductBs();

                ddlProductType.DataSource = EnumerationUtils.GetProductTypeListItems();
                ddlProductType.DataTextField = "Text";
                ddlProductType.DataValueField = "Value";
                ddlProductType.DataBind();

                ddlRegion.DataSource = productBs.GetAllRegions();
                ddlRegion.DataTextField = "regionName";
                ddlRegion.DataValueField = "id";
                ddlRegion.DataBind();

            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            lvTranslations.DataSource = GenerateTranslationList();
            lvTranslations.DataBind();
            base.OnPreRender(e);
        }

        private List<ListItemVos.TranslationListItem> GenerateTranslationList()
        {
            ReportBs reportBs = new ReportBs();

            int productType = Int32.TryParse(ddlProductType.SelectedValue, out productType) ? productType : -1;
            
            IQueryable<TranslationStatus> translationList = reportBs.SearchTranslationStatuses(2,
                productType, Int32.Parse(ddlRegion.SelectedValue), -1, -1, "");

            List<ListItemVos.TranslationListItem> tl = new List<ListItemVos.TranslationListItem>();
            foreach (var t in translationList)
            {
                var tli = new ListItemVos.TranslationListItem();

                tli.fieldId = t.fieldId;
                tli.fieldName = GetTranslationFieldNameLabel((ProductField)t.fieldId, t);
                tli.productId = t.productId;
                tli.productName = t.Product.productName;
                tli.statusDate = t.statusDate;

                tl.Add(tli);
            }

            return tl;
        }

        private string GetTranslationFieldNameLabel(ProductField pf, TranslationStatus ts)
        {
            string productFieldLabel = ResourceUtils.GetProductFieldLabel((ProductField)ts.fieldId);
            string supplementaryLabel;

            switch (pf)
            {
                case ProductField.SupplementalDescription:
                    supplementaryLabel = ResourceUtils.GetGuideSectionLabel((int)ts.secondaryId);
                    return String.Format("{0}: {1}", productFieldLabel, supplementaryLabel);
                default:
                    return productFieldLabel;
            }
        }

        protected void btnFilter_OnClick(object sender, EventArgs e)
        {
            // Do something
        }
    }
}