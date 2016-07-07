using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Linq;
using System.Xml.Xsl;
using ProductCatalogue.BusinessServices;
using ProductCatalogue.DataAccess.Enumerations;


namespace WebApplication.Admin.Report
{
    public partial class FormGeneration : System.Web.UI.Page
    {
        private const string AppFormAccCampXslt = "/Templates/AppFormAccCamp.xslt";
        private const string AppFormCampgroundXslt = "/Templates/AppFormCampground.xslt";
        private const string AppFormAttractionXslt = "/Templates/AppFormAttraction.xslt";
        private const string AppFormOutdoorXslt = "/Templates/AppFormOutdoor.xslt";
        private const string AppFormTourOpXslt = "/Templates/AppFormTourOp.xslt";
        private const string AppFormFineArtsXslt = "/Templates/AppFormFineArts.xslt";
        private const string AppFormRestaurantXslt = "/Templates/AppFormRestaurant.xslt";
        private const string AppFormTrailXslt = "/Templates/AppFormTrail.xslt";

        private const string ConfFormAccCampXslt = "/Templates/ConfFormAccCamp.xslt";
        private const string ConfFormCampgroundXslt = "/Templates/ConfFormCampground.xslt";
        private const string ConfFormAttractionXslt = "/Templates/ConfFormAttraction.xslt";
        private const string ConfFormOutdoorXslt = "/Templates/ConfFormOutdoor.xslt";
        private const string ConfFormTourOpXslt = "/Templates/ConfFormTourOp.xslt";
        private const string ConfFormFineArtsXslt = "/Templates/ConfFormFineArts.xslt";
        private const string ConfFormRestaurantXslt = "/Templates/ConfFormRestaurant.xslt";
        private const string ConfFormTrailXslt = "/Templates/ConfFormTrail.xslt";
        
        private const string ListingProofXslt = "/Templates/ListingProof.xslt";

        protected void Page_Load(object sender, EventArgs e)
        {
            int? productId = null, productTypeId = null, publishStatusId = null, proofDeliveryTypeId = null, regionId = null;

            int myInt;

            int printGuideFormTypeId = Int32.Parse(Request.QueryString["printGuideFormTypeId"]);

            string response = "";

            if (!String.IsNullOrEmpty(Request.QueryString["productId"]))
            {
                productId = Int32.Parse(Request.QueryString["productId"]);
                ProductBs productBs = new ProductBs();
                productTypeId = productBs.GetProduct(productId.Value).productTypeId;
            }
            else
            {
                productTypeId = Int32.TryParse(Request.QueryString["productTypeId"], out myInt) ? myInt : (int?) null;
                publishStatusId = Int32.TryParse(Request.QueryString["publishStatusId"], out myInt) ? myInt : (int?)null;
                proofDeliveryTypeId = Int32.TryParse(Request.QueryString["proofDeliveryTypeId"], out myInt) ? myInt : (int?)null;
                regionId = Int32.TryParse(Request.QueryString["regionId"], out myInt) ? myInt : (int?)null;
            }

            PublishStatus? ps = (publishStatusId != null) ? (PublishStatus) publishStatusId: (PublishStatus?)null;
            
            switch ((PrintGuideFormType)printGuideFormTypeId)
            {
                case (PrintGuideFormType.Application):
                    response = GenerateApplicationForm(productTypeId.Value);
                    break;
                case (PrintGuideFormType.Confirmation):
                    response = GenerateConfirmationForm(productTypeId.Value, ps, productId, regionId);
                    break;
                case (PrintGuideFormType.ListingProof):
                    ProofDeliveryType? pdt = (proofDeliveryTypeId != null) ? (ProofDeliveryType)proofDeliveryTypeId : (ProofDeliveryType?)null;
                    response = GenerateListingProofForm(productTypeId.Value, ps, pdt, regionId, productId);
                    break;
            }

            Response.Clear();
            Response.AddHeader("Content-Type", "text/html");
            Response.Write(response);
            Response.End();
            //GenerateConfirmationForm();
        }

        private string GetConfirmationFormXslt (ProductType pt)
        {
            switch (pt)
            {
                case ProductType.Accommodation:
                    return ConfFormAccCampXslt;
                case ProductType.Attraction:
                    return ConfFormAttractionXslt;
                case ProductType.Campground:
                    return ConfFormCampgroundXslt;
                case ProductType.FineArts:
                    return ConfFormFineArtsXslt;
                case ProductType.Outdoors:
                    return ConfFormOutdoorXslt;
                case ProductType.Restaurants:
                    return ConfFormRestaurantXslt;
                case ProductType.TourOps:
                    return ConfFormTourOpXslt;
                case ProductType.Trails:
                    return ConfFormTrailXslt;
                default:
                    return "";
            }
        }

        private string GetApplicationFormXslt(ProductType pt)
        {
            switch (pt)
            {
                case ProductType.Accommodation:
                    return AppFormAccCampXslt;
                case ProductType.Attraction:
                    return AppFormAttractionXslt;
                case ProductType.Campground:
                    return AppFormCampgroundXslt;
                case ProductType.FineArts:
                    return AppFormFineArtsXslt;
                case ProductType.Outdoors:
                    return AppFormOutdoorXslt;
                case ProductType.Restaurants:
                    return AppFormRestaurantXslt;
                case ProductType.TourOps:
                    return AppFormTourOpXslt;
                case ProductType.Trails:
                    return AppFormTrailXslt;
                default:
                    return "";
            }
        }

        private string GenerateConfirmationForm(int productTypeId, PublishStatus? publishStatus, int? productId, int? regionId)
        {
            ExportBs exportBs = new ExportBs();

            Region? r = (regionId != null) ? (Region) regionId : (Region?)null;

            XDocument xdoc = exportBs.GenerateFormXml(productTypeId, publishStatus, productId, "en", r);

            XElement elem = new XElement("myDates",
                               new XElement("currentYear", String.Format("{0:yyyy}", DateTime.Now)),
                               new XElement("nextYear", String.Format("{0:yyyy}", DateTime.Now.AddYears(1)))
                           );

            xdoc.Element("products").Add(elem);

            XmlReader read = xdoc.CreateReader();

            StringBuilder sb = new StringBuilder();

            var sw = new StringWriter();

            XmlWriterSettings settings = new XmlWriterSettings();
            settings.OmitXmlDeclaration = true;
            settings.ConformanceLevel = ConformanceLevel.Fragment;
            settings.CheckCharacters = false;
            settings.CloseOutput = false;

            using (var xw = XmlWriter.Create(sw, settings))
            {
                // Build Xml with xw.XmlWriterSettings settings = new XmlWriterSettings();
                XslCompiledTransform xsl = new XslCompiledTransform();

                xsl.Load(Server.MapPath(GetConfirmationFormXslt((ProductType) productTypeId)));
                xsl.Transform(read, xw);
            }
            return sw.ToString();
        }

        private string GenerateListingProofForm(int productTypeId, PublishStatus? publishStatus, ProofDeliveryType? proofDeliveryType, int? regionId, int? productId)
        {
            ExportBs exportBs = new ExportBs();

            Region? r = (regionId != null) ? (Region)regionId : (Region?)null;

            XDocument xdoc = exportBs.GenerateFormXml(productTypeId, publishStatus, productId, proofDeliveryType, PrintGuideFormType.ListingProof, "en", r);

            XElement elem = new XElement("myDates",
                             new XElement("currentYear", String.Format("{0:yyyy}", DateTime.Now)),
                             new XElement("nextYear", String.Format("{0:yyyy}", DateTime.Now.AddYears(1)))
                         );

            xdoc.Element("products").Add(elem);

            XmlReader read = xdoc.CreateReader();

            StringBuilder sb = new StringBuilder();

            var sw = new StringWriter();

            XmlWriterSettings settings = new XmlWriterSettings();
            settings.OmitXmlDeclaration = true;
            settings.ConformanceLevel = ConformanceLevel.Fragment;
            settings.CheckCharacters = false;
            settings.CloseOutput = false;

            using (var xw = XmlWriter.Create(sw, settings))
            {
                // Build Xml with xw.XmlWriterSettings settings = new XmlWriterSettings();
                XslCompiledTransform xsl = new XslCompiledTransform();

                xsl.Load(Server.MapPath(ListingProofXslt));
                xsl.Transform(read, xw);
            }
            return sw.ToString();

        }

        private XDocument GenerateApplicationFormXml()
        {
            XDocument xdoc = new XDocument();

            XElement elem = new XElement("myDates",
                                new XElement("currentYear", String.Format("{0:yyyy}", DateTime.Now)),
                                new XElement("nextYear", String.Format("{0:yyyy}", DateTime.Now.AddYears(1)))
                            );
            
            xdoc.Add(elem);

            return xdoc;
        }

        private string GenerateApplicationForm(int productTypeId)
        {
            XDocument xdoc = GenerateApplicationFormXml();

            XmlReader read = xdoc.CreateReader();

            var sw = new StringWriter();

            XmlWriterSettings settings = new XmlWriterSettings();
            settings.OmitXmlDeclaration = true;
            settings.ConformanceLevel = ConformanceLevel.Fragment;
            settings.CheckCharacters = false;
            settings.CloseOutput = false;

            using (var xw = XmlWriter.Create(sw, settings))
            {
                // Build Xml with xw.XmlWriterSettings settings = new XmlWriterSettings();
                XslCompiledTransform xsl = new XslCompiledTransform();

                xsl.Load(Server.MapPath(GetApplicationFormXslt((ProductType) productTypeId)));
                xsl.Transform(read, xw);
            }
            return sw.ToString();
        }
    }
}