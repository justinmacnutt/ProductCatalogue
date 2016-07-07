using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ProductCatalogue.BusinessServices;
using WebApplication.Utilities;

namespace WebApplication.Admin.Product
{
    public partial class Export : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            StringBuilder sb = new StringBuilder();

            if (MySessionVariables.ProductSearchItems.HasValue && MySessionVariables.ProductSearchItems.Value.Count > 0)
            {
                ProductBs productBs = new ProductBs();
                var pq = productBs.GetProducts(MySessionVariables.ProductSearchItems.Value);
                foreach (var p in pq)
                {
                    sb.AppendFormat("{0},{1},{2}", p.productName, p.productTypeId,p.communityId);
                    sb.AppendLine();
                }
            }

            Response.Cache.SetCacheability(HttpCacheability.Public);

            Response.ContentEncoding = System.Text.Encoding.UTF7;

            this.EnableViewState = false;

            Response.Clear();
            //Response.ContentType = "application/CSV;charset=utf-16";
            Response.ContentType = "application/vnd.ms-excel;charset=utf-8";
        //   Response.Charset = "iso-8859-8";
        //    Response.ContentEncoding = System.Text.Encoding.UTF8;
            Response.AddHeader("Content-Disposition", "attachment;filename=myfilename.csv");
            Response.Write(sb.ToString());
            Response.End();

        }
    }
}