using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Data.Linq.SqlClient;
using System.Text;
using System.Xml.Linq;
using ProductCatalogue.DataAccess;
using ProductCatalogue.DataAccess.Enumerations;

namespace ProductCatalogue.BusinessServices
{
    public class ReportBs
    {
        private TourismDataContext db = new TourismDataContext(ConfigurationManager.ConnectionStrings["Tourism2ConnectionString"].ConnectionString);
        
        public IQueryable<TranslationStatus> SearchTranslationStatuses(int fieldTypeId, int productTypeId, int regionId, int fieldId, int productId, string productName)
        {
            // We're not currently using fieldType or region

            var query = from s in db.TranslationStatus
                        select s;

            if (regionId != -1)
            {
                query = from s in query
                        where s.Product.refCommunity.regionId == regionId
                        select s;
            }

            if (productTypeId != -1)
            {
                query = from s in query
                        where s.Product.productTypeId == productTypeId
                        select s;
            }

            if (fieldId != -1)
            {
                query = from s in query
                        where s.fieldId == fieldId
                        select s;
            }

            if (productId != -1)
            {
                query = from s in query
                        where s.productId == productId
                        select s;
            }

            if (fieldTypeId != -1)
            {
                query = from s in query
                        where s.refProductField.fieldTypeId == fieldTypeId
                        select s;
            }

            if (productName != "")
            {
                query = from s in query
                        where SqlMethods.Like(s.Product.productName, "%" + productName + "%")
                        select s;
            }

            return query;
        }
        
    }
}