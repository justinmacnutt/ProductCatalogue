<%@ Page Language="C#" MasterPageFile="~/research.master" AutoEventWireup="true" CodeBehind="Variance.aspx.cs" Inherits="WebApplication.Admin.Research.Variance" %>

<asp:Content ID="cHeadContent" ContentPlaceHolderID="cphHeadContent" Runat="Server">

    <script type="text/javascript">

        $(document).ready(function () {
            $("[id*=mn_acc_reports]").addClass("current");
            $(".integerOnly").keydown(function (event) {
                // Allow: backspace, delete, tab, escape, and enter
                if (event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 27 || event.keyCode == 13 ||
                // Allow: Ctrl+A
                (event.keyCode == 65 && event.ctrlKey === true) ||
                // Allow: home, end, left, right
                (event.keyCode >= 35 && event.keyCode <= 39)) {
                    // let it happen, don't do anything
                    return;
                }
                else {
                    // Ensure that it is a number and stop the keypress
                    if (event.shiftKey || (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105)) {
                        event.preventDefault();
                    }
                }
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

            $("[id*=lnkClearForm]").click(function () {
                ClearForm();
                ClearFormErrors();
            });


        });
        
        function ClearForm() {
            $("[id*=tbAmountDifference]").val('');
            $("[id*=tbPercentageDifference]").val('');

            $("[id*=ddlStartMonth]").val('1');
            $("[id*=ddlEndMonth]").val('1');

            $("[id*=ddlStartYear] option").eq(0).attr('selected', 'selected');
            $("[id*=ddlEndYear] option").eq(0).attr('selected', 'selected');

            $("[id*=radAmount]").prop('checked', false);
            $("[id*=radPercentage]").prop('checked', false);
        }

        function GenerateReport(formatType) {
            var filterByAmount = 0;
            var variance;
            //bool enforceReportingRateMin, bool displayActuals, bool ignoreNumberMin, string clientName, string description) 
            if ($("[id*=radAmount]").is(':checked')) {
                filterByAmount = 1;
                variance = $("[id*=tbAmountDifference]").val();
            }
            else {
                variance = $("[id*=tbPercentageDifference]").val();
            }


            var url = 'GenerateResearchReport.aspx?reportTypeId=9' + '&startYear=' + $("[id*=ddlStartYear]").val() + '&startMonth=' + $("[id*=ddlStartMonth]").val() + '&endYear=' + $("[id*=ddlEndYear]").val() + '&endMonth=' + $("[id*=ddlEndMonth]").val() + '&filterByAmount=' + filterByAmount + '&variance=' + variance + '&formatTypeId=' + formatType;
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

            if (($("[id*=ddlStartYear]").val() != "" && $("[id*=ddlStartMonth]").val() != "" && $("[id*=ddlEndYear]").val() != "" && $("[id*=ddlEndMonth]").val() != "") && (Number($("[id*=ddlStartYear]").val()) > Number($("[id*=ddlEndYear]").val()) || (Number($("[id*=ddlStartYear]").val()) == Number($("[id*=ddlEndYear]").val()) && Number($("[id*=ddlStartMonth]").val()) >= Number($("[id*=ddlEndMonth]").val())))) {
                isValid = false;
                $("[id*=dvErrorTimeWarp]").show();
            }

            if ($("[id*=radAmount]").is(':checked') && ($("[id*=tbAmountDifference]").val() == "" || Number($("[id*=tbAmountDifference]").val()) == 0 )) {
                isValid = false;
                $("[id*=dvErrorAmount]").show();
            }

            if ($("[id*=radPercentage]").is(':checked') && ($("[id*=tbPercentageDifference]").val() == "" || Number($("[id*=tbPercentageDifference]").val()) == 0)) {
                isValid = false;
                $("[id*=dvErrorPercentage]").show();
            }

            if (!$("[id*=radPercentage]").is(':checked') && !$("[id*=radAmount]").is(':checked')) {
                isValid = false;
                $("[id*=dvErrorVarianceType]").show();
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
    <div class="form_fields clearfix">
		<div class="form_label"><label>Variance type</label></div>
		<div class="form_input">
            <table>
                <tr>
                    <td><input type="radio" runat="server" id="radAmount"/>Amount Difference</td>
                    <td>&nbsp;</td>
                    <td><asp:TextBox class="integerOnly" MaxLength="6" runat="server" ID="tbAmountDifference"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="3"><div id="dvErrorAmount" style="display:none;"><span style="color:red;">Please provide an amount difference value.</span></div></td>
                </tr>
                <tr>
                    <td><input type="radio" runat="server" id="radPercentage"/>Percentage Difference</td>
                    <td>&nbsp;</td>
                    <td><asp:TextBox class="integerOnly" runat="server" MaxLength="3" ID="tbPercentageDifference"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="3"><div id="dvErrorPercentage" style="display:none;"><span style="color:red;">Please provide a percentage difference value.</span></div></td>
                </tr>
            </table>
            <div id="dvErrorVarianceType" style="display:none;"><span style="color:red;">Variance type is required.</span></div>
        </div>
	</div>
    
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