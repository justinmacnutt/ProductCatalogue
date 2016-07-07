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
    public partial class WebTranslation : System.Web.UI.Page
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

                ddlField.DataSource = EnumerationUtils.GetFieldListItems();
                ddlField.DataTextField = "Text";
                ddlField.DataValueField = "Value";
                ddlField.DataBind();
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
            int fieldId = Int32.TryParse(ddlField.SelectedValue, out fieldId) ? fieldId : -1;
            int productId = Int32.TryParse(tbProductId.Text, out productId) ? productId : -1;

            IQueryable<TranslationStatus> translationList = reportBs.SearchTranslationStatuses(1,
                productType, Int32.Parse(ddlRegion.SelectedValue), fieldId, productId, tbProductName.Text);

            List<ListItemVos.TranslationListItem> tl = new List<ListItemVos.TranslationListItem>();
            foreach (var t in translationList)
            {
                var tli = new ListItemVos.TranslationListItem();

                tli.fieldId = t.fieldId;
                //tli.fieldName = ResourceUtils.GetProductFieldLabel((ProductField)t.fieldId);
                tli.fieldName = GetTranslationFieldNameLabel((ProductField)t.fieldId,t);
                tli.productId = t.productId;
                tli.productName = t.Product.productName;
                tli.statusDate = t.statusDate;

                tl.Add(tli);
            }

            return tl;
        }

        private string GetTranslationFieldNameLabel (ProductField pf, TranslationStatus ts)
        {
            ProductBs productBs = new ProductBs();
            MediaBs mediaBs = new MediaBs();
            UrlTranslation ut;
            Media m;
            string productFieldLabel = ResourceUtils.GetProductFieldLabel((ProductField) ts.fieldId);
            string supplementaryLabel;

            switch (pf)
            {
                case ProductField.ExternalLinkTitle:
                    ut = productBs.GetUrlTranslation((int) ts.secondaryId, "en");
                    supplementaryLabel = (ut != null) ? ut.title : "";
                    return String.Format("{0}: {1}", productFieldLabel, supplementaryLabel);
                 case ProductField.ExternalLinkDescription:
                    ut = productBs.GetUrlTranslation((int) ts.secondaryId, "en");
                    supplementaryLabel = (ut != null) ? ut.title : "";
                    return String.Format("{0}: {1}", productFieldLabel, supplementaryLabel);
                 case ProductField.MediaCaption:
                     m = mediaBs.GetMedia((int) ts.secondaryId);
                     supplementaryLabel = (m != null) ? m.originalFileName : "";
                     return String.Format("{0}: {1}", productFieldLabel, supplementaryLabel);
                 case ProductField.MediaTitle:
                     m = mediaBs.GetMedia((int)ts.secondaryId);
                     supplementaryLabel = (m != null) ? m.originalFileName : "";
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