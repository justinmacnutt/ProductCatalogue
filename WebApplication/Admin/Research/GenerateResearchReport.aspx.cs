using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Xml;
using System.Xml.Linq;
using System.Xml.Xsl;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using ProductCatalogue.BusinessServices;
using ProductCatalogue.DataAccess.Enumerations;

namespace WebApplication.Admin.Research
{
    public partial class GenerateResearchReport : System.Web.UI.Page
    {
        private const string OccupancyByProductXslt = "/Templates/OccupancyByProductReport.xslt";
        private const string CampOccupancyByProductXslt = "/Templates/CampOccupancyByProductReport.xslt";
        private const string OccupancyByGeographyXslt = "/Templates/OccupancyByGeographyReport.xslt";
        private const string CampOccupancyByGeographyXslt = "/Templates/CampOccupancyByGeographyReport.xslt";
        private const string NonReportingXslt = "/Templates/NonReportingReport.xslt";
        private const string CampNonReportingXslt = "/Templates/CampNonReportingReport.xslt";
        private const string ConfidentialXslt = "/Templates/ConfidentialReport.xslt";
        private const string CampConfidentialXslt = "/Templates/CampConfidentialReport.xslt";
        private const string VarianceXslt = "/Templates/VarianceReport.xslt";
        private const string CampVarianceXslt = "/Templates/CampVarianceReport.xslt";

        private Color DarkBlue = Color.FromArgb(10, 78, 146);
        private Color LightBlue = Color.FromArgb(102, 153, 204);

        protected void Page_Load(object sender, EventArgs e)
        {
            int researchReportTypeId = Int32.Parse(Request.QueryString["reportTypeId"]);
            int formatTypeId = Int32.Parse(Request.QueryString["formatTypeId"]);
            string response = "";
            List<int> years;
            List<int> productIds;
            int geographyTypeId;
            List<int> geographyIds;
            List<int> accommodationTypes;
            List<int> starClasses;

            string productName = "";
            string licenseNumber = "";

            bool groupGeographyItems;
            bool enforceReportingRateMin;
            bool displayActuals;
            bool ignoreNumberMin;
            bool enforceOneThird;

            string clientName;
            string description;

            int startYear;
            int startMonth;
            int endYear;
            int endMonth;

            int variance;
            bool filterByAmount;

            XDocument xdoc = new XDocument();
            string xslt = ""; 

            ResearchBs researchBs = new ResearchBs();

            switch ((ResearchReportType)researchReportTypeId)
            {
                case (ResearchReportType.AccConfidential):
                    years = Request.QueryString["years"].Split(',').Select(Int32.Parse).ToList();
                    productName = Request.QueryString["productName"];
                    licenseNumber = Request.QueryString["licenseNumber"];

                    xdoc = researchBs.GenerateConfidentialXml(productName, licenseNumber, years);
                    xslt = ConfidentialXslt;

                    //response = TransformXml(xdoc, ConfidentialXslt);
                    break;
                case (ResearchReportType.AccNonReporting):
                    startYear = Int32.Parse(Request.QueryString["startYear"]);
                    endYear = Int32.Parse(Request.QueryString["endYear"]);
                    startMonth = Int32.Parse(Request.QueryString["startMonth"]);
                    endMonth = Int32.Parse(Request.QueryString["endMonth"]);

                    xdoc = researchBs.GenerateNonReportingXml(startMonth, startYear, endMonth, endYear);
                    xslt = NonReportingXslt;
                    //response = TransformXml(xdoc, NonReportingXslt);
                    break;
                case (ResearchReportType.AccOccupancyByGeography):
                    years = Request.QueryString["years"].Split(',').Select(Int32.Parse).ToList();
                    geographyIds = Request.QueryString["geographyIds"].Split(',').Select(Int32.Parse).ToList();
                    geographyTypeId = Int32.Parse(Request.QueryString["geographyTypeId"]);
                    accommodationTypes = (!String.IsNullOrEmpty(Request.QueryString["accommodationTypes"])) ? Request.QueryString["accommodationTypes"].Split(',').Select(Int32.Parse).ToList() : new List<int>();
                    starClasses = (!String.IsNullOrEmpty(Request.QueryString["starClasses"])) ? Request.QueryString["starClasses"].Split(',').Select(int.Parse).ToList() : new List<int>();

                    groupGeographyItems = Convert.ToBoolean(Request.QueryString["groupGeographyItems"]);
                    enforceReportingRateMin = Convert.ToBoolean(Request.QueryString["enforceReportingRateMin"]);
                    displayActuals = Convert.ToBoolean(Request.QueryString["displayActuals"]);
                    ignoreNumberMin = Convert.ToBoolean(Request.QueryString["ignoreNumberMin"]);
                    enforceOneThird = Convert.ToBoolean(Request.QueryString["enforceOneThird"]);

                    clientName = Request.QueryString["clientName"];
                    description = Request.QueryString["desc"];

                    XElement jele = new XElement("reportFiles");

                    if (groupGeographyItems)
                    {
                        var kdoc = researchBs.GenerateOccupancyReportXml(geographyTypeId, geographyIds, accommodationTypes, starClasses, years, enforceReportingRateMin, enforceOneThird, displayActuals, ignoreNumberMin, clientName, description);
                        jele.Add(kdoc.Element("reportFile"));
                        xdoc.Add(jele);
                    }
                    else
                    {
                        
                        foreach (var gi in geographyIds)
                        {
                            var kdoc = researchBs.GenerateOccupancyReportXml(geographyTypeId, new List<int>{gi}, accommodationTypes, starClasses, years, enforceReportingRateMin, enforceOneThird, displayActuals, ignoreNumberMin, clientName, description);
                            jele.Add(kdoc.Element("reportFile"));
                        }
                        xdoc.Add(jele);
                    }
                    xslt = OccupancyByGeographyXslt;
                    
                    //response = TransformXml(xdoc, OccupancyByGeographyXslt);
                    break;
                case (ResearchReportType.AccOccupancyByProduct):
                    productIds = Request.QueryString["productIds"].Split(',').Select(Int32.Parse).ToList();
                    years = Request.QueryString["years"].Split(',').Select(Int32.Parse).ToList();
                    
                    enforceReportingRateMin = Convert.ToBoolean(Request.QueryString["enforceReportingRateMin"]);
                    displayActuals = Convert.ToBoolean(Request.QueryString["displayActuals"]);
                    ignoreNumberMin = Convert.ToBoolean(Request.QueryString["ignoreNumberMin"]);
                    enforceOneThird = Convert.ToBoolean(Request.QueryString["enforceOneThird"]);

                    clientName = Request.QueryString["clientName"];
                    description = Request.QueryString["desc"];

                    xdoc = researchBs.GenerateOccupancyReportXml(productIds, years, enforceReportingRateMin, displayActuals, ignoreNumberMin, enforceOneThird, clientName, description);
                    xslt = OccupancyByProductXslt;

                    //response = TransformXml(xdoc, OccupancyByProductXslt);
                    break;
                case (ResearchReportType.AccVariance):
                    startYear = Int32.Parse(Request.QueryString["startYear"]);
                    endYear = Int32.Parse(Request.QueryString["endYear"]);
                    startMonth = Int32.Parse(Request.QueryString["startMonth"]);
                    endMonth = Int32.Parse(Request.QueryString["endMonth"]);
                    variance = Int32.Parse(Request.QueryString["variance"]);
                    filterByAmount = (Request.QueryString["filterByAmount"] == "1");

                    xdoc = researchBs.GenerateVarianceReportXml(startMonth, startYear, endMonth, endYear, variance,
                                                                filterByAmount);
                    xslt = VarianceXslt;

                    //response = TransformXml(xdoc, VarianceXslt);

                    break;
                case (ResearchReportType.CampConfidential):
                    years = Request.QueryString["years"].Split(',').Select(Int32.Parse).ToList();
                    productName = Request.QueryString["productName"];
                    licenseNumber = Request.QueryString["licenseNumber"];

                    xdoc = researchBs.GenerateCampConfidentialXml(productName, licenseNumber, years);
                    xslt = CampConfidentialXslt;
                    break;
                case (ResearchReportType.CampNonReporting):
                    startYear = Int32.Parse(Request.QueryString["startYear"]);
                    endYear = Int32.Parse(Request.QueryString["endYear"]);
                    startMonth = Int32.Parse(Request.QueryString["startMonth"]);
                    endMonth = Int32.Parse(Request.QueryString["endMonth"]);

                    xdoc = researchBs.GenerateCampNonReportingXml(startMonth, startYear, endMonth, endYear);
                    xslt = CampNonReportingXslt;
                    break;
                case (ResearchReportType.CampOccupancyByGeography):
                    years = Request.QueryString["years"].Split(',').Select(Int32.Parse).ToList();
                    geographyIds = Request.QueryString["geographyIds"].Split(',').Select(Int32.Parse).ToList();
                    geographyTypeId = Int32.Parse(Request.QueryString["geographyTypeId"]);
                    starClasses = (!String.IsNullOrEmpty(Request.QueryString["starClasses"])) ? Request.QueryString["starClasses"].Split(',').Select(int.Parse).ToList() : new List<int>();

                    groupGeographyItems = Convert.ToBoolean(Request.QueryString["groupGeographyItems"]);
                    enforceReportingRateMin = Convert.ToBoolean(Request.QueryString["enforceReportingRateMin"]);
                    displayActuals = Convert.ToBoolean(Request.QueryString["displayActuals"]);
                    ignoreNumberMin = Convert.ToBoolean(Request.QueryString["ignoreNumberMin"]);
                    enforceOneThird = Convert.ToBoolean(Request.QueryString["enforceOneThird"]);

                    clientName = Request.QueryString["clientName"];
                    description = Request.QueryString["desc"];

                    XElement wrapper = new XElement("reportFiles");

                    if (groupGeographyItems)
                    {
                        var kdoc = researchBs.GenerateCampOccupancyReportXml(geographyTypeId, geographyIds, starClasses, years, enforceReportingRateMin, enforceOneThird, displayActuals, ignoreNumberMin, clientName, description);
                        wrapper.Add(kdoc.Element("reportFile"));
                        xdoc.Add(wrapper);
                    }
                    else
                    {
                        
                        foreach (var gi in geographyIds)
                        {
                            var kdoc = researchBs.GenerateCampOccupancyReportXml(geographyTypeId, new List<int>{gi}, starClasses, years, enforceReportingRateMin, enforceOneThird, displayActuals, ignoreNumberMin, clientName, description);
                            wrapper.Add(kdoc.Element("reportFile"));
                        }
                        xdoc.Add(wrapper);
                    }
                    xslt = CampOccupancyByGeographyXslt;
                    
                    //response = TransformXml(xdoc, OccupancyByGeographyXslt);
                    break;

                    break;
                case (ResearchReportType.CampOccupancyByProduct):
                    productIds = Request.QueryString["productIds"].Split(',').Select(Int32.Parse).ToList();
                    years = Request.QueryString["years"].Split(',').Select(Int32.Parse).ToList();
                    
                    enforceReportingRateMin = Convert.ToBoolean(Request.QueryString["enforceReportingRateMin"]);
                    displayActuals = Convert.ToBoolean(Request.QueryString["displayActuals"]);
                    ignoreNumberMin = Convert.ToBoolean(Request.QueryString["ignoreNumberMin"]);
                    enforceOneThird = Convert.ToBoolean(Request.QueryString["enforceOneThird"]);

                    clientName = Request.QueryString["clientName"];
                    description = Request.QueryString["desc"];

                    xdoc = researchBs.GenerateCampOccupancyReportXml(productIds, years, enforceReportingRateMin, displayActuals, ignoreNumberMin, enforceOneThird, clientName, description);
                    xslt = CampOccupancyByProductXslt;
                    break;
                case (ResearchReportType.CampVariance):
                    startYear = Int32.Parse(Request.QueryString["startYear"]);
                    endYear = Int32.Parse(Request.QueryString["endYear"]);
                    startMonth = Int32.Parse(Request.QueryString["startMonth"]);
                    endMonth = Int32.Parse(Request.QueryString["endMonth"]);
                    variance = Int32.Parse(Request.QueryString["variance"]);
                    filterByAmount = (Request.QueryString["filterByAmount"] == "1");

                    xdoc = researchBs.GenerateCampVarianceReportXml(startMonth, startYear, endMonth, endYear, variance,
                                                                filterByAmount);
                    xslt = CampVarianceXslt;
                    break;
            }

            if (formatTypeId == (int)ResearchFormatType.Excel)
            {
                //StreamVarianceReportAsExcel(xdoc);
                StreamReportAsExcel(xdoc, (ResearchReportType)researchReportTypeId);
            }
            else
            {
                StreamReportAsPdf(xdoc, xslt);       
            }
        }

        private void StreamReportAsExcel(XDocument xdoc, ResearchReportType rrt)
        {
            ExcelPackage pck = new ExcelPackage();
            string fileName = "";
            string dateSuffix = DateTime.Now.ToString("yyyy_MM_dd_H_mm");

            switch (rrt)
            {
                case (ResearchReportType.AccConfidential):
                    pck = GenerateConfidentialReportAsExcel(xdoc);
                    fileName = String.Format("{0}-{1}.xlsx", "ConfidentialReport", dateSuffix);
                    break;
                case (ResearchReportType.AccNonReporting):
                    pck = GenerateNonReportingReportAsExcel(xdoc);
                    fileName = String.Format("{0}-{1}.xlsx", "NonReportingReport", dateSuffix);
                    break;
                case (ResearchReportType.AccOccupancyByGeography):
                    pck = GenerateOccupancyByGeographyReportAsExcel(xdoc);
                    fileName = String.Format("{0}-{1}.xlsx", "OccupancyByGeographyReport", dateSuffix);
                    //response = TransformXml(xdoc, ConfidentialXslt);
                    break;
                case (ResearchReportType.AccOccupancyByProduct):
                    pck = GenerateOccupancyByProductReportAsExcel(xdoc);
                    fileName = String.Format("{0}-{1}.xlsx", "OccupancyByProductReport", dateSuffix);
                    break;
                case (ResearchReportType.AccVariance):
                    pck = GenerateVarianceReportAsExcel(xdoc);
                    fileName = String.Format("{0}-{1}.xlsx", "VarianceReport", dateSuffix);
                    //response = TransformXml(xdoc, ConfidentialXslt);
                    break;

                case (ResearchReportType.CampConfidential):
                    pck = GenerateCampConfidentialReportAsExcel(xdoc);
                    fileName = String.Format("{0}-{1}.xlsx", "ConfidentialReport", dateSuffix);
                    break;
                case (ResearchReportType.CampNonReporting):
                    pck = GenerateCampNonReportingReportAsExcel(xdoc);
                    fileName = String.Format("{0}-{1}.xlsx", "NonReportingReport", dateSuffix);
                    break;
                case (ResearchReportType.CampOccupancyByGeography):
                    pck = GenerateCampOccupancyByGeographyReportAsExcel(xdoc);
                    fileName = String.Format("{0}-{1}.xlsx", "OccupancyByGeographyReport", dateSuffix);
                    //response = TransformXml(xdoc, ConfidentialXslt);
                    break;
                case (ResearchReportType.CampOccupancyByProduct):
                    pck = GenerateCampOccupancyByProductReportAsExcel(xdoc);
                    fileName = String.Format("{0}-{1}.xlsx", "OccupancyByProductReport", dateSuffix);
                    break;
                case (ResearchReportType.CampVariance):
                    pck = GenerateCampVarianceReportAsExcel(xdoc);
                    fileName = String.Format("{0}-{1}.xlsx", "VarianceReport", dateSuffix);
                    //response = TransformXml(xdoc, ConfidentialXslt);
                    break;
            }

            //Write it back to the client
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", String.Format("attachment;  filename={0}", fileName));
            Response.BinaryWrite(pck.GetAsByteArray());
            Response.End();
        }

        private ExcelPackage GenerateOccupancyByGeographyReportAsExcel(XDocument xdoc)
        {
            ExcelPackage pck = new ExcelPackage();

            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Occupancy");

            int dataRowIndex = 1;

            var rfl = (from rf in xdoc.Descendants("reportFile")
                      select rf);

            foreach (var rf in rfl)
            {
                string years = rf.Descendants("metaData").First().Element("years").Value;
                string clientName = rf.Descendants("metaData").First().Element("clientName").Value;
                string description = rf.Descendants("metaData").First().Element("description").Value;
                string geographyType = rf.Descendants("metaData").First().Element("geographyTypeLabel").Value;
                //string geographyAreas = string.Join(", ", (from ga in rf.Descendants("metaData").First().Descendants("geographicAreas")
                //                         select ga.Element("geographicArea").Value).ToArray());
                string geographyAreas = rf.Descendants("metaData").First().Element("geographicAreas").Value;
                bool displayActuals = bool.Parse(rf.Descendants("metaData").First().Element("displayActuals").Value);

                string accommodationTypes = rf.Descendants("metaData").First().Element("accommodationTypes").Value;
                string starClasses = rf.Descendants("metaData").First().Element("starClasses").Value;

                var headerIndex = dataRowIndex;

                ws.Cells["A" + dataRowIndex++].Value = "Nova Scotia Tourism Agency";
                ws.Cells["A" + dataRowIndex++].Value = "Fixed Roof Occupancy by Geography Report";

                ws.Cells["A" + dataRowIndex++].Value = String.Format("Client Name: {0}", clientName);
                ws.Cells["A" + dataRowIndex++].Value = String.Format("Description: {0}", description);
                ws.Cells["A" + dataRowIndex++].Value = String.Format("Year(s): {0}", years);
                ws.Cells["A" + dataRowIndex++].Value = String.Format("Geography Type: {0}", geographyType);
                ws.Cells["A" + dataRowIndex++].Value = String.Format("Geography Areas: {0}", geographyAreas);
                //ws.Cells["A" + dataRowIndex++].Value = String.Format("Geography Areas: {0}", accom);
                ws.Cells["A" + dataRowIndex++].Value = String.Format("Accommodation Types: {0}", accommodationTypes);
                ws.Cells["A" + dataRowIndex++].Value = String.Format("Star Classes: {0}", starClasses);

                //Format the header for column 1-3
                using (ExcelRange rng = ws.Cells["A" + headerIndex + ":A" + (headerIndex + 8)])
                {
                    rng.Style.Font.Bold = true;
                    rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                    rng.Style.Fill.BackgroundColor.SetColor(DarkBlue);  //Set color to dark blue
                    rng.Style.Font.Color.SetColor(Color.White);
                }

                dataRowIndex++;

                var rl = (from pl in rf.Descendants("report")
                          select pl);

                foreach (var y in rl)
                {
                    ws.Cells[String.Format("A{0}", dataRowIndex)].Value = "Year";
                    ws.Cells[String.Format("B{0}", dataRowIndex)].Value = "Month";
                    ws.Cells[String.Format("C{0}", dataRowIndex)].Value = "Occupancy Rate";
                    ws.Cells[String.Format("D{0}", dataRowIndex)].Value = "Projected Units Sold";
                    ws.Cells[String.Format("E{0}", dataRowIndex)].Value = "Actual Units Sold";
                    ws.Cells[String.Format("F{0}", dataRowIndex)].Value = "Total Units Available Reported";
                    ws.Cells[String.Format("G{0}", dataRowIndex)].Value = "Total Units Available";
                    ws.Cells[String.Format("H{0}", dataRowIndex)].Value = "Reporting Rate";
                    ws.Cells[String.Format("I{0}", dataRowIndex)].Value = "Properties Reported";

                    using (ExcelRange rng = ws.Cells[String.Format("A{0}:I{0}", dataRowIndex)])
                    {
                        rng.Style.Font.Bold = true;
                        rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                        rng.Style.Fill.BackgroundColor.SetColor(LightBlue);  //Set color to dark blue
                        rng.Style.Font.Color.SetColor(Color.White);
                    }

                    dataRowIndex++;

                    var ml = (from m in y.Descendants("month")
                              select new
                              {
                                  year = m.Parent.Attribute("id").Value,
                                  monthName = m.Attribute("shortName").Value,
                                  occupancyRate = (bool.Parse(m.Element("displayRow").Value)) ? decimal.Parse(m.Element("occupancyRate").Value) : (decimal?)null,
                                  projectedUnitsSold = (bool.Parse(m.Element("displayRow").Value)) ? Int32.Parse(m.Element("projectedUnitsSold").Value) : (int?)null,
                                  totalUnitsSold = (displayActuals && (bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("totalUnitsSold").Value) : (int?)null,
                                  totalUnitsAvailableReported = (displayActuals && bool.Parse(m.Element("displayRow").Value)) ? Int32.Parse(m.Element("totalUnitsAvailableReported").Value) : (int?)null,
                                  totalUnitsAvailable = (bool.Parse(m.Element("displayRow").Value)) ? Int32.Parse(m.Element("totalUnitsAvailable").Value) : (int?)null,
                                  reportingRate = decimal.Parse(m.Element("reportingRate").Value),
                                  propertiesReported = Int32.Parse(m.Element("openPropertiesReported").Value)
                              }).ToList();

                    var sl = (from s in y.Descendants("summary")
                              select new
                              {
                                  summaryLabel = "Summary",
                                  emptyCell1 = "",
                                  occupancyRateAvg = decimal.Parse(s.Element("occupancyRateAvg").Value),
                                  projectedUnitsSoldSum = Int32.Parse(s.Element("projectedUnitsSoldSum").Value),
                                  totalUnitsSoldSum = (displayActuals) ? Int32.Parse(s.Element("totalUnitsSoldSum").Value) : (int?)null,
                                  totalUnitsAvailableReportedSum = (displayActuals) ? Int32.Parse(s.Element("totalUnitsAvailableReportedSum").Value) : (int?)null,
                                  totalUnitsAvailableSum = Int32.Parse(s.Element("totalUnitsAvailableSum").Value),
                                  reportingRateAvg = decimal.Parse(s.Element("reportingRateAvg").Value),
                                  emptyCell2 = ""
                              }).ToList();

                    ws.Cells["A" + dataRowIndex].LoadFromCollection(ml);
                    dataRowIndex += ml.Count();

                    if (sl.Count() > 0)
                    {
                        ws.Cells["A" + dataRowIndex].LoadFromCollection(sl);
                        using (ExcelRange rng = ws.Cells[String.Format("A{0}:I{0}", dataRowIndex)])
                        {
                            rng.Style.Font.Bold = true;
                            rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                            rng.Style.Fill.BackgroundColor.SetColor(DarkBlue);  //Set color to dark blue
                            rng.Style.Font.Color.SetColor(Color.White);
                        }
                    }

                    dataRowIndex += sl.Count();

                    dataRowIndex++;
                }
            }

            ws.Cells["A1:I"+dataRowIndex].AutoFitColumns();
            return pck;
        }

        private ExcelPackage GenerateOccupancyByProductReportAsExcel(XDocument xdoc)
        {
            ExcelPackage pck = new ExcelPackage();

            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Occupancy");

            string years = xdoc.Descendants("metaData").First().Element("years").Value;
            string clientName = xdoc.Descendants("metaData").First().Element("clientName").Value;
            string description = xdoc.Descendants("metaData").First().Element("description").Value;
            bool displayActuals = bool.Parse(xdoc.Descendants("metaData").First().Element("displayActuals").Value);

            int dataRowIndex = 8;

            ws.Cells["A1"].Value = "Nova Scotia Tourism Agency";
            ws.Cells["A2"].Value = "Fixed Roof Occupancy by Product Report";
            ws.Cells["A3"].Value = String.Format("Client Name: {0}", clientName);
            ws.Cells["A4"].Value = String.Format("Description: {0}", description);
            ws.Cells["A5"].Value = String.Format("Year(s): {0}", years);

            //Format the header for column 1-3
            using (ExcelRange rng = ws.Cells["A1:A5"])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(DarkBlue);  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }
            
            ws.Cells["A7"].Value = "Product";
            ws.Cells["B7"].Value = "License Number";

            using (ExcelRange rng = ws.Cells["A7:B7"])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(LightBlue);  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }
            
            var products = (from p in xdoc.Descendants("product")
                      select new
                      {
                          productName = p.Element("productName").Value,
                          licenseNumber = p.Element("licenseNumber").Value,
                      }).ToList();

            ws.Cells["A" + dataRowIndex].LoadFromCollection(products);
            dataRowIndex += products.Count();

            //using (ExcelRange rng = ws.Cells[String.Format("A7:B{0}", dataRowIndex)])
            //{
            //    rng.Style.Font.Bold = true;
            //    rng.Style.Fill.PatternType = ExcelFillStyle.Solid;
            //    rng.Style.Fill.BackgroundColor.SetColor(DarkBlue);
            //    rng.Style.Font.Color.SetColor(Color.White);
            //}

            dataRowIndex++;

            var rl = (from pl in xdoc.Descendants("report")
                      select pl);

            foreach (var y in rl)
            {
                ws.Cells[String.Format("A{0}", dataRowIndex)].Value = "Year";
                ws.Cells[String.Format("B{0}", dataRowIndex)].Value = "Month";
                ws.Cells[String.Format("C{0}", dataRowIndex)].Value = "Occupancy Rate";
                ws.Cells[String.Format("D{0}", dataRowIndex)].Value = "Projected Units Sold";
                ws.Cells[String.Format("E{0}", dataRowIndex)].Value = "Actual Units Sold";
                ws.Cells[String.Format("F{0}", dataRowIndex)].Value = "Total Units Available Reported";
                ws.Cells[String.Format("G{0}", dataRowIndex)].Value = "Total Units Available";
                ws.Cells[String.Format("H{0}", dataRowIndex)].Value = "Reporting Rate";
                ws.Cells[String.Format("I{0}", dataRowIndex)].Value = "Properties Reported";

                using (ExcelRange rng = ws.Cells[String.Format("A{0}:I{0}", dataRowIndex)])
                {
                    rng.Style.Font.Bold = true;
                    rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                    rng.Style.Fill.BackgroundColor.SetColor(LightBlue);  //Set color to dark blue
                    rng.Style.Font.Color.SetColor(Color.White);
                }

                dataRowIndex++;

                var ml = (from m in y.Descendants("month")
                          select new
                          {
                              year = m.Parent.Attribute("id").Value,
                              monthName = m.Attribute("shortName").Value,
                              occupancyRate = (bool.Parse(m.Element("displayRow").Value)) ? decimal.Parse(m.Element("occupancyRate").Value) : (decimal?) null,
                              projectedUnitsSold = (bool.Parse(m.Element("displayRow").Value)) ? Int32.Parse(m.Element("projectedUnitsSold").Value) : (int?)null,
                              totalUnitsSold = (displayActuals && (bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("totalUnitsSold").Value) : (int?)null,
                              totalUnitsAvailableReported = (displayActuals && bool.Parse(m.Element("displayRow").Value)) ? Int32.Parse(m.Element("totalUnitsAvailableReported").Value) : (int?)null,
                              totalUnitsAvailable = (bool.Parse(m.Element("displayRow").Value)) ? Int32.Parse(m.Element("totalUnitsAvailable").Value) : (int?)null,
                              //reportingRate = (bool.Parse(m.Element("displayRow").Value)) ? decimal.Parse(m.Element("reportingRate").Value) : (decimal?)null,
                              reportingRate = decimal.Parse(m.Element("reportingRate").Value),
                              propertiesReported = Int32.Parse(m.Element("openPropertiesReported").Value)
                          }).ToList();

                var sl = (from s in y.Descendants("summary")
                          select new
                          {
                              summaryLabel = "Summary",
                              emptyCell1 = "",
                              occupancyRateAvg = decimal.Parse(s.Element("occupancyRateAvg").Value),
                              projectedUnitsSoldSum = Int32.Parse(s.Element("projectedUnitsSoldSum").Value),
                              totalUnitsSoldSum = (displayActuals) ? Int32.Parse(s.Element("totalUnitsSoldSum").Value) : (int?)null,
                              totalUnitsAvailableReportedSum = (displayActuals) ? Int32.Parse(s.Element("totalUnitsAvailableReportedSum").Value) : (int?)null,
                              totalUnitsAvailableSum = Int32.Parse(s.Element("totalUnitsAvailableSum").Value),
                              reportingRateAvg = decimal.Parse(s.Element("reportingRateAvg").Value),
                              emptyCell2 = ""
                          }).ToList();

                ws.Cells["A" + dataRowIndex].LoadFromCollection(ml);
                dataRowIndex += ml.Count();

                if (sl.Count() > 0)
                {
                    ws.Cells["A" + dataRowIndex].LoadFromCollection(sl);
                    using (ExcelRange rng = ws.Cells[String.Format("A{0}:I{0}", dataRowIndex)])
                    {
                        rng.Style.Font.Bold = true;
                        rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                        rng.Style.Fill.BackgroundColor.SetColor(DarkBlue);  //Set color to dark blue
                        rng.Style.Font.Color.SetColor(Color.White);
                    }
                }
                
                dataRowIndex += sl.Count();

                dataRowIndex++;
            }

            ws.Cells["A1:I" + dataRowIndex].AutoFitColumns();
            return pck;
        }

        private ExcelPackage GenerateNonReportingReportAsExcel(XDocument xdoc)
        {
            ExcelPackage pck = new ExcelPackage();

            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("NonReporting");

            string startDate = xdoc.Descendants("metaData").First().Element("startDate").Value;
            string endDate = xdoc.Descendants("metaData").First().Element("endDate").Value;

            int dataRowIndex = 5;

            var j = (from pl in xdoc.Descendants("product")
                     select new
                     {
                         year = pl.Parent.Attribute("id").Value,
                         licenseNumber = pl.Element("licenseNumber").Value,
                         productName = pl.Element("productName").Value,
                         contactName = pl.Element("contactName").Value,
                         nonReportingMonths = pl.Element("nonReportingMonths").Value,
                         officePhone = pl.Element("officePhone").Value,
                         mobilePhone = pl.Element("mobilePhone").Value,
                         email = pl.Element("email").Value,
                         isOpenAllYear = pl.Element("isOpenAllYear").Value,
                         totalUnits = pl.Element("totalUnits").Value,
                         region = pl.Element("region").Value
                     }).ToList();

            ws.Cells["A1"].Value = "Nova Scotia Tourism Agency";
            ws.Cells["A2"].Value = "Non Reporting Report";
            ws.Cells["A3"].Value = String.Format("{0} - {1}", startDate, endDate);

            //Format the header for column 1-3
            using (ExcelRange rng = ws.Cells["A1:A3"])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(DarkBlue);  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }
            
            ws.Cells[String.Format("A{0}",dataRowIndex)].Value = "Year";
            ws.Cells[String.Format("B{0}", dataRowIndex)].Value = "License Number";
            ws.Cells[String.Format("C{0}", dataRowIndex)].Value = "Product Name";
            ws.Cells[String.Format("D{0}", dataRowIndex)].Value = "Contact Name";
            ws.Cells[String.Format("E{0}", dataRowIndex)].Value = "Missing Months";
            ws.Cells[String.Format("F{0}", dataRowIndex)].Value = "Office Phone";
            ws.Cells[String.Format("G{0}", dataRowIndex)].Value = "Mobile Phone";
            ws.Cells[String.Format("H{0}", dataRowIndex)].Value = "Email";
            ws.Cells[String.Format("I{0}", dataRowIndex)].Value = "Year Round";
            ws.Cells[String.Format("J{0}", dataRowIndex)].Value = "Units";
            ws.Cells[String.Format("K{0}", dataRowIndex)].Value = "Region";

            using (ExcelRange rng = ws.Cells[String.Format("A{0}:K{0}",dataRowIndex)])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(LightBlue);  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }

            dataRowIndex++;

            ws.Cells[String.Format("A{0}", dataRowIndex)].LoadFromCollection(j);
            ws.Cells["A1:K" + dataRowIndex].AutoFitColumns();
            return pck;
        }

        private ExcelPackage GenerateVarianceReportAsExcel(XDocument xdoc)
        {
            ExcelPackage pck = new ExcelPackage();
            
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Variance");

            string startDate = xdoc.Descendants("metaData").First().Element("startDate").Value;
            string endDate = xdoc.Descendants("metaData").First().Element("endDate").Value;
            string amountDifference = xdoc.Descendants("metaData").First().Element("amountDifference").Value;
            string percentageDifference = xdoc.Descendants("metaData").First().Element("percentageDifference").Value;

            int dataRowIndex = 8;
            
            var j = (from pl in xdoc.Descendants("product")
                    select new
                                {
                                    licenseNumber = pl.Element("licenseNumber").Value,
                                    productName = pl.Element("productName").Value,
                                    regionName = pl.Element("regionName").Value,
                                    startUnitsSold = Int32.Parse(pl.Element("startUnitsSold").Value),
                                    endUnitsSold = Int32.Parse(pl.Element("endUnitsSold").Value),
                                    percentageDifference = decimal.Parse(pl.Element("percentageDifference").Value),
                                    amountDifference = Int32.Parse(pl.Element("amountDifference").Value)
                                }).ToList();

            ws.Cells["A1"].Value = "Nova Scotia Tourism Agency";
            ws.Cells["A2"].Value = "Fixed Roof Variance Report";
            ws.Cells["A3"].Value = String.Format("{0} - {1}", startDate, endDate);
            ws.Cells["A4"].Value = String.Format("Amount Difference: {0}", amountDifference);
            ws.Cells["A5"].Value = String.Format("Percent Difference: {0}", percentageDifference);

            using (ExcelRange rng = ws.Cells["A1:A5"])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;
                rng.Style.Fill.BackgroundColor.SetColor(DarkBlue);
                rng.Style.Font.Color.SetColor(Color.White);
            }

            ws.Cells[String.Format("A{0}", dataRowIndex)].Value = "License Number";
            ws.Cells[String.Format("B{0}", dataRowIndex)].Value = "Product Name";
            ws.Cells[String.Format("C{0}", dataRowIndex)].Value = "Region";
            ws.Cells[String.Format("D{0}", dataRowIndex)].Value = "Start Units Sold";
            ws.Cells[String.Format("E{0}", dataRowIndex)].Value = "End Units Sold";
            ws.Cells[String.Format("F{0}", dataRowIndex)].Value = "Percentage Difference";
            ws.Cells[String.Format("G{0}", dataRowIndex)].Value = "Amount Difference";

            using (ExcelRange rng = ws.Cells[String.Format("A{0}:G{0}", dataRowIndex)])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(LightBlue);  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }

            dataRowIndex++;

            ws.Cells[String.Format("A{0}", dataRowIndex)].LoadFromCollection(j);

            ws.Cells["A1:G" + dataRowIndex].AutoFitColumns();
            return pck;
        }

        private ExcelPackage GenerateConfidentialReportAsExcel(XDocument xdoc)
        {
            ExcelPackage pck = new ExcelPackage();

            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Confidential");

            string years = xdoc.Descendants("metaData").First().Element("years").Value;
            string productName = xdoc.Descendants("metaData").First().Element("productName").Value;
            string licenseNumber = xdoc.Descendants("metaData").First().Element("licenseNumber").Value;

            int dataRowIndex = 8;

            ws.Cells["A1"].Value = "Nova Scotia Tourism Agency";
            ws.Cells["A2"].Value = "Fixed Roof Confidential Report";
            ws.Cells["A3"].Value = String.Format("Product Name: {0}", productName);
            ws.Cells["A4"].Value = String.Format("License Number: {0}", licenseNumber);
            ws.Cells["A5"].Value = String.Format("Year(s): {0}", years);

            //Format the header for column 1-3
            using (ExcelRange rng = ws.Cells["A1:A5"])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(DarkBlue);  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }

            var rl = (from pl in xdoc.Descendants("report")
                     select pl);

            foreach (var y in rl)
            {
                ws.Cells[String.Format("A{0}", dataRowIndex)].Value = "Year";
                ws.Cells[String.Format("B{0}", dataRowIndex)].Value = "Month";
                ws.Cells[String.Format("C{0}", dataRowIndex)].Value = "Status";
                ws.Cells[String.Format("D{0}", dataRowIndex)].Value = "Units Sold";
                ws.Cells[String.Format("E{0}", dataRowIndex)].Value = "Available Units";
                ws.Cells[String.Format("F{0}", dataRowIndex)].Value = "Occupancy Rate";

                using (ExcelRange rng = ws.Cells[String.Format("A{0}:F{0}", dataRowIndex)])
                {
                    rng.Style.Font.Bold = true;
                    rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                    rng.Style.Fill.BackgroundColor.SetColor(LightBlue);  //Set color to dark blue
                    rng.Style.Font.Color.SetColor(Color.White);
                }

                dataRowIndex++;

                var ml = (from m in y.Descendants("month")
                         select new
                         {
                             year = m.Parent.Attribute("id").Value,
                             monthName = m.Attribute("shortName").Value,
                             status = m.Element("status").Value,
                             totalUnitsSold = Int32.Parse(m.Element("totalUnitsSold").Value),
                             totalUnitsAvailable = Int32.Parse(m.Element("totalUnitsAvailable").Value),
                             occupancyRate = decimal.Parse(m.Element("occupancyRate").Value),
                         }).ToList();

                var sl = (from s in y.Descendants("summary")
                         select new
                                    {
                                        summaryLabel = "Summary",
                                        emptyCell1 = "",
                                        emptyCell2 = "",
                                        totalUnitsSoldSum = Int32.Parse(s.Element("totalUnitsSoldSum").Value),
                                        totalUnitsAvailableSum = Int32.Parse(s.Element("totalUnitsAvailableSum").Value),
                                        occupancyRateAvg = decimal.Parse(s.Element("occupancyRateAvg").Value),
                                    }).ToList();

                ws.Cells["A" + dataRowIndex].LoadFromCollection(ml);
                dataRowIndex += ml.Count();

                using (ExcelRange rng = ws.Cells[String.Format("A{0}:F{0}", dataRowIndex)])
                {
                    rng.Style.Font.Bold = true;
                    rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                    rng.Style.Fill.BackgroundColor.SetColor(DarkBlue);  //Set color to dark blue
                    rng.Style.Font.Color.SetColor(Color.White);
                }

                ws.Cells["A" + dataRowIndex].LoadFromCollection(sl);
                dataRowIndex += sl.Count();

                dataRowIndex ++;
            }

            ws.Cells["A1:F" + dataRowIndex].AutoFitColumns();
            return pck;
        }

        private ExcelPackage GenerateCampOccupancyByGeographyReportAsExcel(XDocument xdoc)
        {
            ExcelPackage pck = new ExcelPackage();

            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Occupancy");

            int dataRowIndex = 1;

            var rfl = (from rf in xdoc.Descendants("reportFile")
                       select rf);

            foreach (var rf in rfl)
            {
                string years = rf.Descendants("metaData").First().Element("years").Value;
                string clientName = rf.Descendants("metaData").First().Element("clientName").Value;
                string description = rf.Descendants("metaData").First().Element("description").Value;
                string geographyType = rf.Descendants("metaData").First().Element("geographyTypeLabel").Value;
                //string geographyAreas = string.Join(", ", (from ga in rf.Descendants("metaData").First().Descendants("geographicAreas")
                //                         select ga.Element("geographicArea").Value).ToArray());
                string geographyAreas = rf.Descendants("metaData").First().Element("geographicAreas").Value;
                bool displayActuals = bool.Parse(rf.Descendants("metaData").First().Element("displayActuals").Value);

                //string accommodationTypes = rf.Descendants("metaData").First().Element("accommodationTypes").Value;
                string starClasses = rf.Descendants("metaData").First().Element("starClasses").Value;

                var headerIndex = dataRowIndex;

                ws.Cells["A" + dataRowIndex++].Value = "Nova Scotia Tourism Agency";
                ws.Cells["A" + dataRowIndex++].Value = "Campground Occupancy by Geography Report";

                ws.Cells["A" + dataRowIndex++].Value = String.Format("Client Name: {0}", clientName);
                ws.Cells["A" + dataRowIndex++].Value = String.Format("Description: {0}", description);
                ws.Cells["A" + dataRowIndex++].Value = String.Format("Year(s): {0}", years);
                ws.Cells["A" + dataRowIndex++].Value = String.Format("Geography Type: {0}", geographyType);
                ws.Cells["A" + dataRowIndex++].Value = String.Format("Geography Areas: {0}", geographyAreas);
                //ws.Cells["A" + dataRowIndex++].Value = String.Format("Geography Areas: {0}", accom);
                //ws.Cells["A" + dataRowIndex++].Value = String.Format("Accommodation Types: {0}", accommodationTypes);
                ws.Cells["A" + dataRowIndex++].Value = String.Format("Star Classes: {0}", starClasses);

                //Format the header for column 1-3
                using (ExcelRange rng = ws.Cells["A" + headerIndex + ":A" + (dataRowIndex - 1)])
                {
                    rng.Style.Font.Bold = true;
                    rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                    rng.Style.Fill.BackgroundColor.SetColor(DarkBlue);  //Set color to dark blue
                    rng.Style.Font.Color.SetColor(Color.White);
                }

                dataRowIndex++;

                var rl = (from pl in rf.Descendants("report")
                          select pl);

                foreach (var y in rl)
                {
                    ws.Cells[String.Format("A{0}", dataRowIndex)].Value = "Year";
                    ws.Cells[String.Format("B{0}", dataRowIndex)].Value = "Month";

                    ws.Cells[String.Format("C{0}", dataRowIndex)].Value = "Seasonal Occ. Rate";
                    ws.Cells[String.Format("D{0}", dataRowIndex)].Value = "Reported Seasonal Nights Sold";
                    ws.Cells[String.Format("E{0}", dataRowIndex)].Value = "Est. Seasonal Nights Sold";
                    ws.Cells[String.Format("F{0}", dataRowIndex)].Value = "Reported Seasonal Available";
                    ws.Cells[String.Format("G{0}", dataRowIndex)].Value = "Total Seasonal Available";

                    ws.Cells[String.Format("H{0}", dataRowIndex)].Value = "Short Term Occ. Rate";
                    ws.Cells[String.Format("I{0}", dataRowIndex)].Value = "Reported Short Term Sold";
                    ws.Cells[String.Format("J{0}", dataRowIndex)].Value = "Est. Short Term Sold";
                    ws.Cells[String.Format("K{0}", dataRowIndex)].Value = "Reported Short Term Available";
                    ws.Cells[String.Format("L{0}", dataRowIndex)].Value = "Total Short Term Available";

                    ws.Cells[String.Format("M{0}", dataRowIndex)].Value = "Total Occupancy Rate";
                    ws.Cells[String.Format("N{0}", dataRowIndex)].Value = "Reported Total Sold";
                    ws.Cells[String.Format("O{0}", dataRowIndex)].Value = "Est. Total Sold";
                    ws.Cells[String.Format("P{0}", dataRowIndex)].Value = "Reported Total Available";
                    ws.Cells[String.Format("Q{0}", dataRowIndex)].Value = "Total Available";

                    ws.Cells[String.Format("R{0}", dataRowIndex)].Value = "Reporting Rate";
                    ws.Cells[String.Format("S{0}", dataRowIndex)].Value = "Properties Reported";

                    using (ExcelRange rng = ws.Cells[String.Format("A{0}:S{0}", dataRowIndex)])
                    {
                        rng.Style.Font.Bold = true;
                        rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                        rng.Style.Fill.BackgroundColor.SetColor(LightBlue);  //Set color to dark blue
                        rng.Style.Font.Color.SetColor(Color.White);
                    }

                    dataRowIndex++;

                    
                    var ml = (from m in y.Descendants("month")
                              select new
                              {
                                  year = m.Parent.Attribute("id").Value,
                                  monthName = m.Attribute("shortName").Value,

                                  seasonalOccupancyRate = (bool.Parse(m.Element("displayRow").Value)) ? decimal.Parse(m.Element("seasonalOccupancyRate").Value) : (decimal?)null,
                                  reportedSeasonalSold = (displayActuals && (bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("seasonalSold").Value) : (int?)null,
                                  projectedSeasonalSold = ((bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("projectedSeasonalSold").Value) : (int?)null,
                                  reportedSeasonalAvailable = (displayActuals && (bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("seasonalAvailable").Value) : (int?)null,
                                  projectedSeasonalAvailable = ((bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("seasonalAvailableEstimated").Value) : (int?)null,

                                  shortTermOccupancyRate = (bool.Parse(m.Element("displayRow").Value)) ? decimal.Parse(m.Element("shortTermOccupancyRate").Value) : (decimal?)null,
                                  reportedShortTermSold = (displayActuals && (bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("shortTermSold").Value) : (int?)null,
                                  projectedShortTermSold = ((bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("projectedShortTermSold").Value) : (int?)null,
                                  reportedShortTermAvailable = (displayActuals && (bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("shortTermAvailable").Value) : (int?)null,
                                  projectedShortTermAvailable = ((bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("shortTermAvailableEstimated").Value) : (int?)null,

                                  totalOccupancyRate = (bool.Parse(m.Element("displayRow").Value)) ? decimal.Parse(m.Element("occupancyRate").Value) : (decimal?)null,
                                  reportedTotalSold = (displayActuals && (bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("totalUnitsSold").Value) : (int?)null,
                                  projectedTotalSold = ((bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("projectedUnitsSold").Value) : (int?)null,
                                  reportedTotalAvailable = (displayActuals && (bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("unitsAvailableReported").Value) : (int?)null,
                                  projectedTotalAvailable = ((bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("unitsAvailableEstimated").Value) : (int?)null,

                                  reportingRate = decimal.Parse(m.Element("reportingRate").Value),
                                  propertiesReported = Int32.Parse(m.Element("openPropertiesReported").Value)
                              }).ToList();

                    var sl = (from s in y.Descendants("summary")
                              select new
                              {
                                  summaryLabel = "Summary",
                                  emptyCell1 = "",

                                  seasonalOccupancyRateAvg = decimal.Parse(s.Element("seasonalOccupancyRateAvg").Value),
                                  reportedSeasonalSoldSum = (displayActuals) ? Int32.Parse(s.Element("totalSeasonalSoldSum").Value) : (int?)null,
                                  projectedSeasonalSoldSum = Int32.Parse(s.Element("projectedSeasonalSoldSum").Value),
                                  reportedSeasonalAvailableSum = (displayActuals) ? Int32.Parse(s.Element("seasonalAvailableSum").Value) : (int?)null,
                                  projectedSeasonalAvailableSum = Int32.Parse(s.Element("seasonalAvailableEstimatedSum").Value),
                                  //
                                  shortTermOccupancyRateAvg = decimal.Parse(s.Element("shortTermOccupancyRateAvg").Value),
                                  reportedShortTermSoldSum = (displayActuals) ? Int32.Parse(s.Element("totalShortTermSoldSum").Value) : (int?)null,
                                  projectedShortTermSoldSum = Int32.Parse(s.Element("projectedShortTermSoldSum").Value),
                                  reportedShortTermAvailableSum = (displayActuals) ? Int32.Parse(s.Element("shortTermAvailableSum").Value) : (int?)null,
                                  projectedShortTermAvailableSum = Int32.Parse(s.Element("shortTermAvailableEstimatedSum").Value),

                                  totalOccupancyRateAvg = decimal.Parse(s.Element("occupancyRateAvg").Value),
                                  reportedTotalSoldSum = (displayActuals) ? Int32.Parse(s.Element("totalUnitsSoldSum").Value) : (int?)null,
                                  projectedTotalSoldSum = Int32.Parse(s.Element("projectedUnitsSoldSum").Value),
                                  reportedTotalAvailableSum = (displayActuals) ? Int32.Parse(s.Element("unitsAvailableReportedSum").Value) : (int?)null,
                                  projectedTotalAvailableSum = Int32.Parse(s.Element("unitsAvailableEstimatedSum").Value),

                                  reportingRateAvg = decimal.Parse(s.Element("reportingRateAvg").Value),
                                  propertiesReportedSum = ""
                              }).ToList();

                    ws.Cells["A" + dataRowIndex].LoadFromCollection(ml);
                    dataRowIndex += ml.Count();

                    if (sl.Count() > 0)
                    {
                        ws.Cells["A" + dataRowIndex].LoadFromCollection(sl);
                        using (ExcelRange rng = ws.Cells[String.Format("A{0}:S{0}", dataRowIndex)])
                        {
                            rng.Style.Font.Bold = true;
                            rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                            rng.Style.Fill.BackgroundColor.SetColor(DarkBlue);  //Set color to dark blue
                            rng.Style.Font.Color.SetColor(Color.White);
                        }
                    }

                    dataRowIndex += sl.Count();

                    dataRowIndex++;
                }
            }

            ws.Cells["A1:S" + dataRowIndex].AutoFitColumns();
            return pck;
        }

        private ExcelPackage GenerateCampOccupancyByProductReportAsExcel(XDocument xdoc)
        {
            ExcelPackage pck = new ExcelPackage();

            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Occupancy");

            string years = xdoc.Descendants("metaData").First().Element("years").Value;
            string clientName = xdoc.Descendants("metaData").First().Element("clientName").Value;
            string description = xdoc.Descendants("metaData").First().Element("description").Value;
            bool displayActuals = bool.Parse(xdoc.Descendants("metaData").First().Element("displayActuals").Value);

            int dataRowIndex = 8;

            ws.Cells["A1"].Value = "Nova Scotia Tourism Agency";
            ws.Cells["A2"].Value = "Campground Occupancy by Product Report";
            ws.Cells["A3"].Value = String.Format("Client Name: {0}", clientName);
            ws.Cells["A4"].Value = String.Format("Description: {0}", description);
            ws.Cells["A5"].Value = String.Format("Year(s): {0}", years);

            //Format the header for column 1-3
            using (ExcelRange rng = ws.Cells["A1:A5"])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(DarkBlue);  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }

            ws.Cells["A7"].Value = "Product";
            ws.Cells["B7"].Value = "License Number";

            using (ExcelRange rng = ws.Cells["A7:B7"])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(LightBlue);  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }

            var products = (from p in xdoc.Descendants("product")
                            select new
                            {
                                productName = p.Element("productName").Value,
                                licenseNumber = p.Element("licenseNumber").Value,
                            }).ToList();

            ws.Cells["A" + dataRowIndex].LoadFromCollection(products);
            dataRowIndex += products.Count();

            dataRowIndex++;

            var rl = (from pl in xdoc.Descendants("report")
                      select pl);

            foreach (var y in rl)
            {
                ws.Cells[String.Format("A{0}", dataRowIndex)].Value = "Year";
                ws.Cells[String.Format("B{0}", dataRowIndex)].Value = "Month";

                ws.Cells[String.Format("C{0}", dataRowIndex)].Value = "Seasonal Occ. Rate";
                ws.Cells[String.Format("D{0}", dataRowIndex)].Value = "Reported Seasonal Nights Sold";
                ws.Cells[String.Format("E{0}", dataRowIndex)].Value = "Est. Seasonal Nights Sold";
                ws.Cells[String.Format("F{0}", dataRowIndex)].Value = "Reported Seasonal Available";
                ws.Cells[String.Format("G{0}", dataRowIndex)].Value = "Total Seasonal Available";

                ws.Cells[String.Format("H{0}", dataRowIndex)].Value = "Short Term Occ. Rate";
                ws.Cells[String.Format("I{0}", dataRowIndex)].Value = "Reported Short Term Sold";
                ws.Cells[String.Format("J{0}", dataRowIndex)].Value = "Est. Short Term Sold";
                ws.Cells[String.Format("K{0}", dataRowIndex)].Value = "Reported Short Term Available";
                ws.Cells[String.Format("L{0}", dataRowIndex)].Value = "Total Short Term Available";

                ws.Cells[String.Format("M{0}", dataRowIndex)].Value = "Total Occupancy Rate";
                ws.Cells[String.Format("N{0}", dataRowIndex)].Value = "Reported Total Sold";
                ws.Cells[String.Format("O{0}", dataRowIndex)].Value = "Est. Total Sold";
                ws.Cells[String.Format("P{0}", dataRowIndex)].Value = "Reported Total Available";
                ws.Cells[String.Format("Q{0}", dataRowIndex)].Value = "Total Available";
                
                ws.Cells[String.Format("R{0}", dataRowIndex)].Value = "Reporting Rate";
                ws.Cells[String.Format("S{0}", dataRowIndex)].Value = "Properties Reported";

                using (ExcelRange rng = ws.Cells[String.Format("A{0}:S{0}", dataRowIndex)])
                {
                    rng.Style.Font.Bold = true;
                    rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                    rng.Style.Fill.BackgroundColor.SetColor(LightBlue);  //Set color to dark blue
                    rng.Style.Font.Color.SetColor(Color.White);
                }

                dataRowIndex++;

                var ml = (from m in y.Descendants("month")
                          select new
                          {
                            year = m.Parent.Attribute("id").Value,
                            monthName = m.Attribute("shortName").Value,
                            
                            seasonalOccupancyRate = (bool.Parse(m.Element("displayRow").Value)) ? decimal.Parse(m.Element("seasonalOccupancyRate").Value) : (decimal?)null,
                            reportedSeasonalSold = (displayActuals && (bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("seasonalSold").Value) : (int?)null,
                            projectedSeasonalSold = ((bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("projectedSeasonalSold").Value) : (int?)null,
                            reportedSeasonalAvailable = (displayActuals && (bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("seasonalAvailable").Value) : (int?)null,
                            projectedSeasonalAvailable = ((bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("seasonalAvailableEstimated").Value) : (int?)null,

                            shortTermOccupancyRate = (bool.Parse(m.Element("displayRow").Value)) ? decimal.Parse(m.Element("shortTermOccupancyRate").Value) : (decimal?)null,
                            reportedShortTermSold = (displayActuals && (bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("shortTermSold").Value) : (int?)null,
                            projectedShortTermSold = ((bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("projectedShortTermSold").Value) : (int?)null,
                            reportedShortTermAvailable = (displayActuals && (bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("shortTermAvailable").Value) : (int?)null,
                            projectedShortTermAvailable = ((bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("shortTermAvailableEstimated").Value) : (int?)null,

                            totalOccupancyRate = (bool.Parse(m.Element("displayRow").Value)) ? decimal.Parse(m.Element("occupancyRate").Value) : (decimal?)null,
                            reportedTotalSold = (displayActuals && (bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("totalUnitsSold").Value) : (int?)null,
                            projectedTotalSold = ((bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("projectedUnitsSold").Value) : (int?)null,
                            reportedTotalAvailable = (displayActuals && (bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("unitsAvailableReported").Value) : (int?)null,
                            projectedTotalAvailable = ((bool.Parse(m.Element("displayRow").Value))) ? Int32.Parse(m.Element("unitsAvailableEstimated").Value) : (int?)null,
                            
                            reportingRate = decimal.Parse(m.Element("reportingRate").Value),
                            propertiesReported = Int32.Parse(m.Element("openPropertiesReported").Value)
                          }).ToList();


                var sl = (from s in y.Descendants("summary")
                          select new
                          {
                              summaryLabel = "Summary",
                              emptyCell1 = "",

                              seasonalOccupancyRateAvg = decimal.Parse(s.Element("seasonalOccupancyRateAvg").Value),
                              reportedSeasonalSoldSum = (displayActuals) ? Int32.Parse(s.Element("totalSeasonalSoldSum").Value) : (int?)null,
                              projectedSeasonalSoldSum = Int32.Parse(s.Element("projectedSeasonalSoldSum").Value),
                              reportedSeasonalAvailableSum = (displayActuals) ? Int32.Parse(s.Element("seasonalAvailableSum").Value) : (int?)null,
                              projectedSeasonalAvailableSum = Int32.Parse(s.Element("seasonalAvailableEstimatedSum").Value),
                              //
                              shortTermOccupancyRateAvg = decimal.Parse(s.Element("shortTermOccupancyRateAvg").Value),
                              reportedShortTermSoldSum = (displayActuals) ? Int32.Parse(s.Element("totalShortTermSoldSum").Value) : (int?)null,
                              projectedShortTermSoldSum = Int32.Parse(s.Element("projectedShortTermSoldSum").Value),
                              reportedShortTermAvailableSum = (displayActuals) ? Int32.Parse(s.Element("shortTermAvailableSum").Value) : (int?)null,
                              projectedShortTermAvailableSum = Int32.Parse(s.Element("shortTermAvailableEstimatedSum").Value),

                              totalOccupancyRateAvg = decimal.Parse(s.Element("occupancyRateAvg").Value),
                              reportedTotalSoldSum = (displayActuals) ? Int32.Parse(s.Element("totalUnitsSoldSum").Value) : (int?)null,
                              projectedTotalSoldSum = Int32.Parse(s.Element("projectedUnitsSoldSum").Value),
                              reportedTotalAvailableSum = (displayActuals) ? Int32.Parse(s.Element("unitsAvailableReportedSum").Value) : (int?)null,
                              projectedTotalAvailableSum = Int32.Parse(s.Element("unitsAvailableEstimatedSum").Value),

                              reportingRateAvg = decimal.Parse(s.Element("reportingRateAvg").Value),
                              propertiesReportedSum = ""
                          }).ToList();

                ws.Cells["A" + dataRowIndex].LoadFromCollection(ml);
                dataRowIndex += ml.Count();

                if (sl.Count() > 0)
                {
                    ws.Cells["A" + dataRowIndex].LoadFromCollection(sl);
                    using (ExcelRange rng = ws.Cells[String.Format("A{0}:S{0}", dataRowIndex)])
                    {
                        rng.Style.Font.Bold = true;
                        rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                        rng.Style.Fill.BackgroundColor.SetColor(DarkBlue);  //Set color to dark blue
                        rng.Style.Font.Color.SetColor(Color.White);
                    }
                }

                dataRowIndex += sl.Count();

                dataRowIndex++;
            }

            ws.Cells["A1:S" + dataRowIndex].AutoFitColumns();
            return pck;
        }

        private ExcelPackage GenerateCampNonReportingReportAsExcel(XDocument xdoc)
        {
            ExcelPackage pck = new ExcelPackage();

            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("NonReporting");

            string startDate = xdoc.Descendants("metaData").First().Element("startDate").Value;
            string endDate = xdoc.Descendants("metaData").First().Element("endDate").Value;

            int dataRowIndex = 5;

            var j = (from pl in xdoc.Descendants("product")
                     select new
                     {
                         year = pl.Parent.Attribute("id").Value,
                         licenseNumber = pl.Element("licenseNumber").Value,
                         productName = pl.Element("productName").Value,
                         contactName = pl.Element("contactName").Value,
                         nonReportingMonths = pl.Element("nonReportingMonths").Value,
                         officePhone = pl.Element("officePhone").Value,
                         mobilePhone = pl.Element("mobilePhone").Value,
                         email = pl.Element("email").Value,
                         isOpenAllYear = pl.Element("isOpenAllYear").Value
                     }).ToList();

            ws.Cells["A1"].Value = "Nova Scotia Tourism Agency";
            ws.Cells["A2"].Value = "Non Reporting Report";
            ws.Cells["A3"].Value = String.Format("{0} - {1}", startDate, endDate);

            //Format the header for column 1-3
            using (ExcelRange rng = ws.Cells["A1:A3"])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(DarkBlue);  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }

            ws.Cells[String.Format("A{0}", dataRowIndex)].Value = "Year";
            ws.Cells[String.Format("B{0}", dataRowIndex)].Value = "License Number";
            ws.Cells[String.Format("C{0}", dataRowIndex)].Value = "Product Name";
            ws.Cells[String.Format("D{0}", dataRowIndex)].Value = "Contact Name";
            ws.Cells[String.Format("E{0}", dataRowIndex)].Value = "Missing Months";
            ws.Cells[String.Format("F{0}", dataRowIndex)].Value = "Office Phone";
            ws.Cells[String.Format("G{0}", dataRowIndex)].Value = "Mobile Phone";
            ws.Cells[String.Format("H{0}", dataRowIndex)].Value = "Email";
            ws.Cells[String.Format("I{0}", dataRowIndex)].Value = "Year Round";

            using (ExcelRange rng = ws.Cells[String.Format("A{0}:I{0}", dataRowIndex)])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(LightBlue);  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }

            dataRowIndex++;

            ws.Cells[String.Format("A{0}", dataRowIndex)].LoadFromCollection(j);
            ws.Cells["A1:I" + dataRowIndex].AutoFitColumns();
            return pck;
        }

        private ExcelPackage GenerateCampVarianceReportAsExcel(XDocument xdoc)
        {
            ExcelPackage pck = new ExcelPackage();

            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Variance");

            string startDate = xdoc.Descendants("metaData").First().Element("startDate").Value;
            string endDate = xdoc.Descendants("metaData").First().Element("endDate").Value;
            string amountDifference = xdoc.Descendants("metaData").First().Element("amountDifference").Value;
            string percentageDifference = xdoc.Descendants("metaData").First().Element("percentageDifference").Value;

            int dataRowIndex = 8;

            var j = (from pl in xdoc.Descendants("product")
                     select new
                     {
                         licenseNumber = pl.Element("licenseNumber").Value,
                         productName = pl.Element("productName").Value,
                         regionName = pl.Element("regionName").Value,
                         startUnitsSold = Int32.Parse(pl.Element("startUnitsSold").Value),
                         endUnitsSold = Int32.Parse(pl.Element("endUnitsSold").Value),
                         percentageDifference = decimal.Parse(pl.Element("percentageDifference").Value),
                         amountDifference = Int32.Parse(pl.Element("amountDifference").Value)
                     }).ToList();

            ws.Cells["A1"].Value = "Nova Scotia Tourism Agency";
            ws.Cells["A2"].Value = "Campground Variance Report";
            ws.Cells["A3"].Value = String.Format("{0} - {1}", startDate, endDate);
            ws.Cells["A4"].Value = String.Format("Amount Difference: {0}", amountDifference);
            ws.Cells["A5"].Value = String.Format("Percent Difference: {0}", percentageDifference);

            using (ExcelRange rng = ws.Cells["A1:A5"])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;
                rng.Style.Fill.BackgroundColor.SetColor(DarkBlue);
                rng.Style.Font.Color.SetColor(Color.White);
            }

            ws.Cells[String.Format("A{0}", dataRowIndex)].Value = "License Number";
            ws.Cells[String.Format("B{0}", dataRowIndex)].Value = "Product Name";
            ws.Cells[String.Format("C{0}", dataRowIndex)].Value = "Region";
            ws.Cells[String.Format("D{0}", dataRowIndex)].Value = "Start Units Sold";
            ws.Cells[String.Format("E{0}", dataRowIndex)].Value = "End Units Sold";
            ws.Cells[String.Format("F{0}", dataRowIndex)].Value = "Percentage Difference";
            ws.Cells[String.Format("G{0}", dataRowIndex)].Value = "Amount Difference";

            using (ExcelRange rng = ws.Cells[String.Format("A{0}:G{0}", dataRowIndex)])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(LightBlue);  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }

            dataRowIndex++;

            ws.Cells[String.Format("A{0}", dataRowIndex)].LoadFromCollection(j);

            ws.Cells["A1:G" + dataRowIndex].AutoFitColumns();
            return pck;
        }

        private ExcelPackage GenerateCampConfidentialReportAsExcel(XDocument xdoc)
        {
            ExcelPackage pck = new ExcelPackage();

            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Confidential");

            string years = xdoc.Descendants("metaData").First().Element("years").Value;
            string productName = xdoc.Descendants("metaData").First().Element("productName").Value;
            string licenseNumber = xdoc.Descendants("metaData").First().Element("licenseNumber").Value;

            int dataRowIndex = 8;

            ws.Cells["A1"].Value = "Nova Scotia Tourism Agency";
            ws.Cells["A2"].Value = "Campground Confidential Report";
            ws.Cells["A3"].Value = String.Format("Product Name: {0}", productName);
            ws.Cells["A4"].Value = String.Format("License Number: {0}", licenseNumber);
            ws.Cells["A5"].Value = String.Format("Year(s): {0}", years);

            //Format the header for column 1-3
            using (ExcelRange rng = ws.Cells["A1:A5"])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(DarkBlue);  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }

            var rl = (from pl in xdoc.Descendants("report")
                      select pl);

            foreach (var y in rl)
            {
                ws.Cells[String.Format("A{0}", dataRowIndex)].Value = "Year";
                ws.Cells[String.Format("B{0}", dataRowIndex)].Value = "Month";
                ws.Cells[String.Format("C{0}", dataRowIndex)].Value = "Status";
                ws.Cells[String.Format("D{0}", dataRowIndex)].Value = "Est. Seasonal Site Nights";
                ws.Cells[String.Format("E{0}", dataRowIndex)].Value = "Seasonal Occ. Rate";
                ws.Cells[String.Format("F{0}", dataRowIndex)].Value = "Actual Seasonal Site Nights";
                ws.Cells[String.Format("G{0}", dataRowIndex)].Value = "Est. Short Term Sites Sold";
                ws.Cells[String.Format("H{0}", dataRowIndex)].Value = "Short Term Occ Rate %";
                ws.Cells[String.Format("I{0}", dataRowIndex)].Value = "Short Term Actuals";
                ws.Cells[String.Format("J{0}", dataRowIndex)].Value = "Estimated Total Sites Sold";
                ws.Cells[String.Format("K{0}", dataRowIndex)].Value = "Total Site Actuals";
                ws.Cells[String.Format("L{0}", dataRowIndex)].Value = "Occupancy Rate";
                ws.Cells[String.Format("M{0}", dataRowIndex)].Value = "Reporting Rate";
                ws.Cells[String.Format("N{0}", dataRowIndex)].Value = "Properties Reported";

                using (ExcelRange rng = ws.Cells[String.Format("A{0}:N{0}", dataRowIndex)])
                {
                    rng.Style.Font.Bold = true;
                    rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                    rng.Style.Fill.BackgroundColor.SetColor(LightBlue);  //Set color to dark blue
                    rng.Style.Font.Color.SetColor(Color.White);
                }

                dataRowIndex++;

                var ml = (from m in y.Descendants("month")
                          select new
                          {
                              year = m.Parent.Attribute("id").Value,
                              monthName = m.Attribute("shortName").Value,
                              status = m.Element("status").Value,
                              projectedSeasonalSold = Int32.Parse(m.Element("projectedSeasonalSold").Value),
                              seasonalOccupancyRate = decimal.Parse(m.Element("seasonalOccupancyRate").Value),
                              seasonalSold = Int32.Parse(m.Element("seasonalSold").Value),
                              projectedShortTermSold = Int32.Parse(m.Element("projectedShortTermSold").Value),
                              shortTermOccupancyRate = decimal.Parse(m.Element("shortTermOccupancyRate").Value),
                              shortTermSold = Int32.Parse(m.Element("shortTermSold").Value),
                              projectedUnitsSold = Int32.Parse(m.Element("projectedUnitsSold").Value),
                              totalUnitsSold = Int32.Parse(m.Element("totalUnitsSold").Value),
                              occupancyRate = decimal.Parse(m.Element("occupancyRate").Value),
                              reportingRate = decimal.Parse(m.Element("reportingRate").Value),
                              openPropertiesReported = decimal.Parse(m.Element("openPropertiesReported").Value)
                          }).ToList();

                var sl = (from s in y.Descendants("summary")
                          select new
                          {
                              summaryLabel = "Summary",
                              emptyCell1 = "",
                              emptyCell2 = "",
                              projectedSeasonalSoldSum = Int32.Parse(s.Element("projectedSeasonalSoldSum").Value),
                              seasonalOccupancyRateAvg = decimal.Parse(s.Element("seasonalOccupancyRateAvg").Value),
                              totalSeasonalSoldSum = Int32.Parse(s.Element("totalSeasonalSoldSum").Value),
                              projectedShortTermSoldSum = Int32.Parse(s.Element("projectedShortTermSoldSum").Value),
                              shortTermOccupancyRateAvg = decimal.Parse(s.Element("shortTermOccupancyRateAvg").Value),
                              totalShortTermSoldSum = Int32.Parse(s.Element("totalShortTermSoldSum").Value),
                              projectedUnitsSoldSum = Int32.Parse(s.Element("projectedUnitsSoldSum").Value),
                              totalUnitsSoldSum = Int32.Parse(s.Element("totalUnitsSoldSum").Value),
                              occupancyRateAvg = decimal.Parse(s.Element("occupancyRateAvg").Value),
                              reportingRateAvg = decimal.Parse(s.Element("reportingRateAvg").Value),
                              propertiesReportedSum = Int32.Parse(s.Element("openPropertiesReportedSum").Value)
                          }).ToList();

                ws.Cells["A" + dataRowIndex].LoadFromCollection(ml);
                dataRowIndex += ml.Count();

                using (ExcelRange rng = ws.Cells[String.Format("A{0}:N{0}", dataRowIndex)])
                {
                    rng.Style.Font.Bold = true;
                    rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                    rng.Style.Fill.BackgroundColor.SetColor(DarkBlue);  //Set color to dark blue
                    rng.Style.Font.Color.SetColor(Color.White);
                }

                ws.Cells["A" + dataRowIndex].LoadFromCollection(sl);
                dataRowIndex += sl.Count();

                dataRowIndex++;
            }

            ws.Cells["A1:N" + dataRowIndex].AutoFitColumns();
            return pck;
        }
        
        private void StreamReportAsPdf (XDocument xdoc, string xslt)
        {
            var response = TransformXml(xdoc, xslt);

            Response.Clear();
            Response.AddHeader("Content-Type", "text/html");
            Response.Write(response);
            Response.End();
            
        }

        private string TransformXml(XDocument xdoc, string xslt)
        {
            XmlReader read = xdoc.CreateReader();

            var sw = new StringWriter();

            XmlWriterSettings settings = new XmlWriterSettings();
            settings.OmitXmlDeclaration = true;
            settings.ConformanceLevel = ConformanceLevel.Fragment;
            settings.CheckCharacters = false;
            settings.CloseOutput = false;

            using (var xw = XmlWriter.Create(sw, settings))
            {
                XslCompiledTransform xsl = new XslCompiledTransform();

                xsl.Load(Server.MapPath(xslt));
                xsl.Transform(read, xw);
            }
            return sw.ToString();
        }
    }
}