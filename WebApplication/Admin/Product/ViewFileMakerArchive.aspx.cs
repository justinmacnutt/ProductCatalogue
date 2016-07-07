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

namespace WebApplication.Admin.Product
{
    public partial class ViewFileMakerArchive : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string productId = Request.QueryString["productId"];
            string archiveTypeId = Request.QueryString["archiveTypeId"];
            
            ProductBs productBs = new ProductBs();
            BusinessBs businessBs = new BusinessBs();

            ProductCatalogue.DataAccess.Product p = productBs.GetProduct(Int32.Parse(productId));
            ProductCatalogue.DataAccess.Contact c = businessBs.GetPrimaryContact(p);

            litProductName.Text = p.productName;
            litProductType.Text = ResourceUtils.GetProductTypeLabel((ProductType) p.productTypeId);

            if (c != null)
            {
                litPrimaryContact.Text = String.Format("{0} {1}", c.firstName, c.lastName);
            }

            FileMakerArchive fma = new FileMakerArchive();

            if (p.fileMakerId != null)
            {
                fma = productBs.GetFileMakerArchive(p.fileMakerId, byte.Parse(archiveTypeId));
            }

            if (fma != null)
            {
                litArchive.Text = fma.archive.Replace("","<br/>");
            }
            else
            {
                litArchive.Text = (archiveTypeId == "1") ? "No comment archive exists." : "No history archive exists.";
            }
        }
    }
}