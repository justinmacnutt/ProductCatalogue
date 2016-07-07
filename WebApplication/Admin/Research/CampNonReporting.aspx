<%@ Page Language="C#" MasterPageFile="~/research.master" AutoEventWireup="true" CodeBehind="CampNonReporting.aspx.cs" Inherits="WebApplication.Admin.Research.CampNonReporting" %>

<asp:Content ID="cHeadContent" ContentPlaceHolderID="cphHeadContent" Runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.multiselect.min.js"></script>

    <script type="text/javascript">

        $(document).ready(function () {

            $("[id*=mn_camp_reports]").addClass("current");
            
            $("[id*=btnGeneratePdf]").click(function() {
                if (IsFormValid()) {
                    GenerateReport(1);
                }
                return false;
            });

            $("[id*=btnGenerateExcel]").click(function () {
                if (IsFormValid()) {
                    GenerateReport(2);
                }
                return false;
            });

            $("[id*=lnkClearForm]").click(function () {
                ClearForm();
                ClearFormErrors();
            });
        });

        function ClearForm() {
            var defaultMonth = $("[id*=hdnDefaultMonth]").val();
            
            $("[id*=ddlStartMonth]").val(defaultMonth);
            $("[id*=ddlEndMonth]").val(defaultMonth);

            var yearIndex = 0;

            if (defaultMonth == "1") {
                yearIndex = 1;
            }

            $("[id*=ddlStartYear] option").eq(yearIndex).attr('selected', 'selected');
            $("[id*=ddlEndYear] option").eq(yearIndex).attr('selected', 'selected');
        }

        function GenerateReport(formatType) {
            //bool enforceReportingRateMin, bool displayActuals, bool ignoreNumberMin, string clientName, string description) 
            var url = 'GenerateResearchReport.aspx?reportTypeId=6' + '&startYear=' + $("[id*=ddlStartYear]").val() + '&startMonth=' + $("[id*=ddlStartMonth]").val() + '&endYear=' + $("[id*=ddlEndYear]").val() + '&endMonth=' + $("[id*=ddlEndMonth]").val() + '&formatTypeId=' + formatType;
            //alert(url);
            window.open(url, '_blank');
            return false;
        }

        function IsFormValid(errMessage) {
            //return false;
            var isValid = true;
            ClearFormErrors();

            if ($("[id*=ddlStartYear]").val() == "" || $("[id*=ddlStartMonth]").val() == "") {
                isValid = false;
                $("[id*=dvErrorStartDate]").show();
            }

            if ($("[id*=ddlEndYear]").val() == "" || $("[id*=ddlEndMonth]").val() == "") {
                isValid = false;
                $("[id*=dvErrorEndDate]").show();
            }

            if (($("[id*=ddlStartYear]").val() != "" && $("[id*=ddlStartMonth]").val() != "" && $("[id*=ddlEndYear]").val() != "" && $("[id*=ddlEndMonth]").val() != "") && (Number($("[id*=ddlStartYear]").val()) > Number($("[id*=ddlEndYear]").val()) || (Number($("[id*=ddlStartYear]").val()) == Number($("[id*=ddlEndYear]").val()) && Number($("[id*=ddlStartMonth]").val()) > Number($("[id*=ddlEndMonth]").val()))))
            {
                isValid = false;
                $("[id*=dvErrorTimeWarp]").show();
            }

            if (Number($("[id*=ddlEndYear]").val()) - Number($("[id*=ddlStartYear]").val()) > 1) {
                isValid = false;
                $("[id*=dvErrorYearMax]").show();
            }
            else if ((Number($("[id*=ddlEndYear]").val()) - Number($("[id*=ddlStartYear]").val()) == 1) && (Number($("[id*=ddlEndMonth]").val()) >= Number($("[id*=ddlStartMonth]").val()))) {
                isValid = false;
                $("[id*=dvErrorYearMax]").show();
            }

            return isValid;
        }

        function ClearFormErrors() {
            $("[id*=dvError]").hide();
//            $("[id*=dvErrorYear]").hide();
        }


    </script>
</asp:Content> 

<asp:Content ID="cMainContent" ContentPlaceHolderID="cphMainContent" Runat="Server"> 
    <asp:HiddenField id="hdnDefaultMonth" runat="server" />
    <div class="form_fields clearfix">
		<div class="form_label"><label>From:</label></div>
		<div class="form_input">
            <asp:DropDownList ID="ddlStartMonth" runat="server"></asp:DropDownList>&nbsp;<asp:DropDownList ID="ddlStartYear" runat="server"></asp:DropDownList>
        </div>
        <div id="dvErrorStartDate" style="display:none;">
		    <span style="color:red;">A valid start month/year is required.</span>
       </div>
       <div id="dvErrorTimeWarp" style="display:none;">
		    <span style="color:red;">The start date must precede the end date.</span>
       </div>
       <div id="dvErrorYearMax" style="display:none;">
		    <span style="color:red;">The reporting period must be less than a year.</span>
       </div>
	</div>

    <div class="form_fields clearfix">
		<div class="form_label"><label>To:</label></div>
		<div class="form_input">
            <asp:DropDownList ID="ddlEndMonth" runat="server"></asp:DropDownList>&nbsp;<asp:DropDownList ID="ddlEndYear" runat="server"></asp:DropDownList>
        </div>
        <div id="dvErrorEndDate" style="display:none;">
		    <span style="color:red;">A valid end month/year is required.</span>
       </div>
	</div> 

    <div class="form_fields clearfix">
	    <asp:Button ID="btnGeneratePdf" runat="server" Text="PDF"  />&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnGenerateExcel" runat="server" Text="Excel" />&nbsp;&nbsp;&nbsp;&nbsp;<a id="lnkClearForm">Clear</a>
	</div>
</asp:Content> 