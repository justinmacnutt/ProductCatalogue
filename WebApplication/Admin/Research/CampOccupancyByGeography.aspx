<%@ Page Language="C#" MasterPageFile="~/research.master" AutoEventWireup="true" CodeBehind="CampOccupancyByGeography.aspx.cs" Inherits="WebApplication.Admin.Research.CampOccupancyByGeography" %>

<asp:Content ID="cHeadContent" ContentPlaceHolderID="cphHeadContent" Runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.multiselect.min.js"></script>

    <script type="text/javascript">

        $(document).ready(function () {
            $("[id*=mn_camp_reports]").addClass("current");
            //            $("[id*=cbEnforceReportingRateMin]").attr('checked', true);
            //            $("[id*=cbGroupGeographyItems]").attr('checked', true);
            //            $("[id*=rblGeographyType_2]").attr('checked', true);
            ClearForm();

            $("[id*=lnkClearForm]").click(function () {
                ClearForm();
                ClearFormErrors();
            });

            $("[id*=btnGeneratePdf]").click(function () {
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

            $("[id*=ddlYear]").multiselect({
                noneSelectedText: 'Select Years',
                selectedList: 4,
                autoOpen: false
            });

            $("[id*=ddlArea]").multiselect({
                noneSelectedText: 'Select Areas',
                selectedList: 4,
                autoOpen: false
            });

            $("[id*=ddlCounty]").multiselect({
                noneSelectedText: 'Select Counties',
                selectedList: 4,
                autoOpen: false
            });

            $("[id*=ddlRegion]").multiselect({
                noneSelectedText: 'Select Regions',
                selectedList: 4,
                autoOpen: false
            });

            $("[id*=ddlStarClass]").multiselect({
                noneSelectedText: 'Select Star Classes',
                selectedList: 4,
                autoOpen: false
            });

            $("[id*=rblGeographyType]").click(function () {
                MakeFormAdjustments();
            });

        });

        function IsFormValid() {
            var isValid = true;
            ClearFormErrors();

            var gt = $("[id*=rblGeographyType]:checked").val();
       
            switch (gt) {
                case "1":
                    if (!$("[id*=ddlArea]").val()) {
                        $("[id*=dvErrorArea]").show();
                        isValid = false;
                    }
                    break;
                case "2":
                    if (!$("[id*=ddlCounty]").val()) {
                        $("[id*=dvErrorCounty]").show();
                        isValid = false;
                    }
                    break;
                case "3":
                    if (!$("[id*=ddlRegion]").val() ) {
                        $("[id*=dvErrorRegion]").show();
                        isValid = false;
                    }
                    break;
                default:
                    $("[id*=dvErrorGeographyType]").show();
                    isValid = false;
            }

            if (!$("[id*=ddlYear]").val()) {
                $("[id*=dvErrorYear]").show();
                isValid = false;
            }

            return isValid;
        }

        function ClearFormErrors() {
            $("[id*=dvError]").hide();
        }

        function ClearForm() {
            $("[id*=tbClientName]").val('');
            $("[id*=tbDescription]").val('');

            $("[id*=ddlYear]").multiselect("uncheckAll");
            $("[id*=ddlArea]").multiselect("uncheckAll");
            $("[id*=ddlCounty]").multiselect("uncheckAll");
            $("[id*=ddlRegion]").multiselect("uncheckAll");
            $("[id*=ddlStarClass]").multiselect("uncheckAll");

            $("[id*=rblGeographyType]").attr('checked', false);
            $("[id*=rblGeographyType_2]").attr('checked', true);

            $("[id*=cbGroupGeographyItems]").attr('checked', true);
            $("[id*=cbEnforceReportingRateMin]").attr('checked', true);
            $("[id*=cbDisplayActuals]").attr('checked', false);
            $("[id*=cbIgnoreNumberMin]").attr('checked', false);
            $("[id*=cbEnforceOneThird]").attr('checked', false);

            MakeFormAdjustments();
        }

        function GenerateReport(formatType) {
            var groupGeographyItems = "false";
            var enforceReportingRateMin = "false";
            var displayActuals = "false";
            var ignoreNumberMin = "false";
            var enforceOneThird = "false";

            if ($("[id*=cbGroupGeographyItems]").attr('checked')) {
                groupGeographyItems = "true";
            }

            if ($("[id*=cbEnforceReportingRateMin]").attr('checked')) {
                enforceReportingRateMin = "true";
            }

            if ($("[id*=cbDisplayActuals]").attr('checked')) {
                displayActuals = "true";
            }

            if ($("[id*=cbIgnoreNumberMin]").attr('checked')) {
                ignoreNumberMin = "true";
            }

            if ($("[id*=cbEnforceOneThird]").attr('checked')) {
                enforceOneThird = "true";
            }

            var geographyTypeId = $("[id*=rblGeographyType]:checked").val();
            var geographyIds;

            var starClasses = ($("[id*=ddlStarClass]").val()) ? $("[id*=ddlStarClass]").val() : "";

            switch (geographyTypeId) {
                case "1":
                    geographyIds = $("[id*=ddlArea]").val();
                    break;
                case "2":
                    geographyIds = $("[id*=ddlCounty]").val();
                    break;
                case "3":
                    geographyIds = $("[id*=ddlRegion]").val();
                    break;
            }

            var url = 'GenerateResearchReport.aspx?reportTypeId=4' + '&geographyTypeId=' + geographyTypeId + '&geographyIds=' + geographyIds + '&starClasses=' + starClasses + '&years=' + $("[id*=ddlYear]").val() + '&groupGeographyItems=' + groupGeographyItems + '&enforceOneThird=' + enforceOneThird + '&enforceReportingRateMin=' + enforceReportingRateMin + '&displayActuals=' + displayActuals + '&ignoreNumberMin=' + ignoreNumberMin + '&clientName=' + encodeURIComponent($("[id*=tbClientName]").val()) + '&desc=' + encodeURIComponent($("[id*=tbDescription]").val()) + '&formatTypeId=' + formatType;
            window.open(url);
        }

        function MakeFormAdjustments() {
            var gt = $("[id*=rblGeographyType]:checked").val();
            $("[id*=dvArea]").hide();
            $("[id*=dvCounty]").hide();
            $("[id*=dvRegion]").hide();

            switch (gt) {
                case "1":
                    $("[id*=dvArea]").show();
                    break;
                case "2":
                    $("[id*=dvCounty]").show();
                    break;
                case "3":
                    $("[id*=dvRegion]").show();
                    break;
            }
        }

    </script>
</asp:Content> 
<asp:Content ID="cMainContent" ContentPlaceHolderID="cphMainContent" Runat="Server"> 
    <div class="form_fields clearfix">
		<div class="form_label"><label>Geography Type:</label></div>
		<div class="form_input">
            <asp:RadioButtonList ID="rblGeographyType" runat="server">
                <asp:ListItem Value="1">Area</asp:ListItem>
                <asp:ListItem Value="2">County</asp:ListItem>
                <asp:ListItem Value="3">Region</asp:ListItem>
            </asp:RadioButtonList>
        </div>
        <div id="dvErrorGeographyType" style="display:none;">
			<span style="color:red;">Geography type is required.</span>
		</div>
	</div>

    <div id="dvArea" class="form_fields clearfix" style="display:none;">
		<div class="form_label"><label>Area:</label></div>
		<div class="form_input">
            <asp:DropDownList ID="ddlArea" runat="server" multiple="multiple">
            </asp:DropDownList>
        </div>
        <div id="dvErrorArea" style="display:none;">
		    <span style="color:red;">At least one Area is required.</span>
       </div>
	</div> 

    <div id="dvCounty" class="form_fields clearfix" style="display:none;">
		<div class="form_label"><label>County:</label></div>
		<div class="form_input">
            <asp:DropDownList ID="ddlCounty" runat="server" multiple="multiple">
            </asp:DropDownList>
        </div>
        <div id="dvErrorCounty" style="display:none;">
		    <span style="color:red;">At least one County is required.</span>
       </div>
	</div> 

    <div id="dvRegion" class="form_fields clearfix" style="display:none;">
		<div class="form_label"><label>Region:</label></div>
		<div class="form_input">
            <asp:DropDownList ID="ddlRegion" runat="server" multiple="multiple">
                <asp:ListItem Value="1">Cape Breton: Bras d'Or Lakes Scenic Drive</asp:ListItem>
                <asp:ListItem Value="2">Cape Breton: Cabot Trail</asp:ListItem>
                <asp:ListItem Value="3">Cape Breton: Ceilidh Trail</asp:ListItem>
                <asp:ListItem Value="4">Cape Breton: Fleur-de-lis/Marconi/Metro CB</asp:ListItem>
                <asp:ListItem Value="5">Eastern Shore</asp:ListItem>
                <asp:ListItem Value="6">Fundy Shore &amp; Annapolis Valley</asp:ListItem>
                <asp:ListItem Value="7">Halifax Metro</asp:ListItem>
                <asp:ListItem Value="8">Northumberland Shore</asp:ListItem>
                <asp:ListItem Value="9">South Shore</asp:ListItem>
                <asp:ListItem Value="10">Yarmouth &amp; Acadian Shores</asp:ListItem>
            </asp:DropDownList>
        </div>
        <div id="dvErrorRegion" style="display:none;">
		    <span style="color:red;">At least one Region is required.</span>
       </div>
	</div> 

    <div id="dvStarClass" class="form_fields clearfix">
		<div class="form_label"><label>Star class:</label></div>
		<div class="form_input">
            <asp:DropDownList ID="ddlStarClass" runat="server" multiple="multiple">
            </asp:DropDownList>
        </div>
        <div id="dvErrorStarClass" style="display:none;">
		    <span style="color:red;">At least one Region is required.</span>
       </div>
	</div> 

    
    
    <div class="form_fields clearfix">
		<div class="form_label"><label>Years:</label></div>
		<div class="form_input">
            <asp:DropDownList ID="ddlYear" runat="server" multiple="multiple">
            </asp:DropDownList></div>
            <div id="dvErrorYear" style="display:none;">
			    <span style="color:red;">At least one year is required.</span>
		    </div>
	</div> 
              
    <div class="form_fields clearfix">
        <table>
            <tr>
                <td><div class="form_label"><label>Group Geography Items:</label></div></td>
                <td>&nbsp;&nbsp;</td>
                <td><div class="form_input"><asp:CheckBox ID="cbGroupGeographyItems" runat="server" /></div></td>
            </tr>
            <tr>
                <td><div class="form_label"><label>Enforce 85% rule:</label></div></td>
                <td>&nbsp;&nbsp;</td>
                <td><div class="form_input"><asp:CheckBox ID="cbEnforceReportingRateMin" runat="server" /></div></td>
            </tr>
            <tr>
                <td><div class="form_label"><label>Display Actuals:</label></div></td>
                <td>&nbsp;&nbsp;</td>
                <td><div class="form_input"><asp:CheckBox ID="cbDisplayActuals" runat="server" /></div></td>
            </tr>
            <tr>
                <td><div class="form_label"><label>Display with less than 6 properties:</label></div></td>
                <td>&nbsp;&nbsp;</td>
                <td><div class="form_input"><asp:CheckBox ID="cbIgnoreNumberMin" runat="server" /></div></td>
            </tr>
            <tr>
                <td><div class="form_label"><label>One third of the units cannot be from one property:</label></div></td>
                <td>&nbsp;&nbsp;</td>
                <td><div class="form_input"><asp:CheckBox ID="cbEnforceOneThird" runat="server" /></div></td>
            </tr>
        </table>
	</div>   
           
    <div class="form_fields clearfix">
		<div class="form_label"><label>Client Name:</label></div>
		<div class="form_input"><asp:TextBox ID="tbClientName" runat="server"></asp:TextBox></div>
	</div>         
    <div class="form_fields clearfix">
		<div class="form_label"><label>Description:</label></div>
		<div class="form_input"><asp:TextBox ID="tbDescription" runat="server" TextMode="MultiLine"></asp:TextBox></div>
	</div>         
    <div class="form_fields clearfix">
	    <asp:Button ID="btnGeneratePdf" runat="server" Text="PDF"  />&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnGenerateExcel" runat="server" Text="Excel"/>&nbsp;&nbsp;&nbsp;&nbsp;<a id="lnkClearForm">Clear</a>
	</div>
</asp:Content> 
