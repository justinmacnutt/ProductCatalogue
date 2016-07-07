using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ProductCatalogue.BusinessServices;
using ProductCatalogue.DataAccess;
using System.IO;

namespace WebApplication
{
    public partial class MediaMigrate : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnSubmit_OnClick(object sender, EventArgs e)
        {
            MediaBs mediaBs = new MediaBs();

            DateTime dt = DateTime.Parse(tbMediaDate.Text);
            byte productTypeId = Byte.Parse(tbProductType.Text);
            
            string sourcePath = System.Web.Configuration.WebConfigurationManager.AppSettings["ManagedMediaUploadPath"];
            string targetPath = sourcePath + "temp/";

            IQueryable<Media> mq = mediaBs.GetAllMedia();

            var q = from m in mq
                    where m.mediaTypeId == 2 && m.lastModifiedDate > dt && m.Product.productTypeId == productTypeId
                    orderby m.productId, m.sortOrder, m.id
                    select m;

            int lastProductId = 0;
            int sortOrder = 1;
            
            foreach (Media m in q)
            {
                if (lastProductId != m.productId)
                {
                    lastProductId = m.productId;
                    sortOrder = 1;
                }
                
                string sourceFileName = String.Format("{0}{1}.{2}", sourcePath, m.id, m.fileExtension);
                string targetFileName = String.Format("{0}{1}_{2}.{3}", targetPath, m.Product.fileMakerId ?? "J" + m.productId.ToString(), sortOrder, m.fileExtension);

                try
                {
                    File.Copy(sourceFileName, targetFileName, true);    
                }
                catch (Exception exc)
                {
                    
                }
                sortOrder++;
            }


            q = from m in mq
                where m.mediaTypeId == 1 && m.lastModifiedDate > dt && m.Product.productTypeId == productTypeId
                orderby m.productId
                select m;

            foreach (Media m in q)
            {
                string sourceFileName = String.Format("{0}{1}.{2}", sourcePath, m.id, m.fileExtension);
                string targetFileName = String.Format("{0}{1}.{2}", targetPath, m.Product.fileMakerId ?? "J" + m.productId.ToString(), m.fileExtension);

                try
                {
                    File.Copy(sourceFileName, targetFileName, true);
                }
                catch (Exception exc)
                {

                }
                sortOrder++;
            }

        }
    }
}