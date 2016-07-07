<%@ Page Language="C#" MasterPageFile="~/research.master" AutoEventWireup="true" CodeBehind="Edit.aspx.cs" Inherits="WebApplication.Admin.Research.Edit" %>

<asp:Content ID="cHeadContent" ContentPlaceHolderID="cphHeadContent" Runat="Server"> 

    <link href="../../Styles/jquery.qtip.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/jquery.qtip.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.maxlength.js" type="text/javascript" ></script>

    <style type="text/css">
        input.hasError {border:2px solid #c10000;}
        tr.validRow {background-color:#CFD784;}
        tr.savedRow {background-color:#FFFFFF;}
        tr.unsavedRow {background-color:#fefcc2;}
        tr.inactiveRow {background-color:#EDEDED;}
    </style>

    <script type="text/javascript">
        var errPercentages = "Sum of Visitor percentages must equal 100%";
        var errOpenDays = "Open days must be less than number of days in the month";
        var errUnitsSold = "Units sold must be less than the available units";
        var errUnitsSoldReq = "Units sold is a required field";
        var errTotalGuestsReq = "Total guests is a required field";
        var errTotalGuests = "Total guests must be greater than the units sold";

        var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

        $(document).ready(function () {
            $("[id*=mn_bulkEdit]").addClass("current");
            InitializeEventBindings();

            $("[id*=lnkDeleteMonth]").click(function () {
                var theMonth = $(this).attr("theMonth");
                DeleteResearchRow(theMonth);
                return false;
            });

            //$("#cbDisplayClassRatingInputs").click();
        });

        function DeleteResearchRow(theMonth) {

            var rowId = theMonth;
            
            if (Number(theMonth) < 10) {
                rowId = "0" + theMonth;
            }

            var deletedRow = $("[id*=dataRow" + rowId + "]");

            var r = confirm("Are you sure you want to delete the data for " + monthNames[theMonth - 1] + "?");

            //alert(r);
            
            if (!r) {
                return false;
            }
            
            var productId = $('[id*=hdnProductId]').val();
            var year = $('[id*=ddlYear]').val();

            var dataString = '{"productId":"' + productId + '", "year":"' + year + '","month":"' + theMonth + '"}';

            $.ajax({
                type: "POST",
                url: "Edit.aspx/DeleteResearchRow",
                data: dataString,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var x = msg.d;
                    //alert( $(this).closest('tr').attr("id") );
                    //alert(x);
                    //alert(x.openDays + ":::" + x.units + ":::" + x.productClass + ":::" + x.productRating);
                    deletedRow.find("[id*=tbOpenDays]").val(x.openDays);
                    deletedRow.find("[id*=tbAvailableUnitsDay]").val(x.units);
                    deletedRow.find("[id*=tdAvailableUnitsMonth]").html(Number(x.units) * Number(x.openDays));

                    deletedRow.find("[id*=ddlResearchClass]").val(x.productClass);
                    deletedRow.find("[id*=ddlClassRating]").val(x.productRating);

                    deletedRow.find("[id*=tbUnitsSold]").val('');
                    deletedRow.find("[id*=tbTotalGuests]").val('');
                    deletedRow.find("[id*=tbVacationGuests]").val('');
                    deletedRow.find("[id*=tbBusinessGuests]").val('');
                    deletedRow.find("[id*=tbConventionGuests]").val('');
                    deletedRow.find("[id*=tbMotorcoachGuests]").val('');
                    deletedRow.find("[id*=tbOtherGuests]").val('');

                    deletedRow.removeClass("savedRow");
                    deletedRow.removeClass("validRow");
                    deletedRow.addClass("unsavedRow");
                    deletedRow.find(".lnkDeleteRow").hide();
                },
                error: function (xhr, status, error) {
                    // Display a generic error for now.
                    alert("AJAX Error!");
                }
            });

            return false;
        }
        
        function ClearFormErrors() {
            $("[id*=dvError]").hide();
        }

        // Attach events
        function InitializeEventBindings() {
            //$('#tblData tr').filter("[previouslysaveddata='1']").addClass("savedRow");
           
            //$('#tblData td:nth-child(13)').hide();
            //$('#tblData td:nth-child(14)').hide();

            $("[id*=tbNoteReminderDate]").datepicker({ dateFormat: 'dd-mm-yy' });
            $("[id*=tbNoteReminderDate]").addClass("readOnly");

            var onEditCallback = function(remaining) {
                $(this).siblings('.chars_remaining').text("(" + remaining + " characters remaining)");
            };

            // Attach maxlength function to textarea
            $('textarea[length]').limitMaxlength({
                onEdit: onEditCallback
            });

            $(".tbl_datarow").addClass("unsavedRow");
            
            $("[id*=hdnIsEnabled]").filter("[value='0']").closest('tr').find(":input").attr("disabled", true);
            $("[id*=hdnIsEnabled]").filter("[value='0']").closest('tr').removeClass("unsavedRow").addClass("inactiveRow");
            
            $("#tabs").tabs();

            $("[id*=hdnPreviouslySaved]").filter("[value='1']").closest('tr').removeClass("unsavedRow").addClass("savedRow");
            $("[id*=hdnPreviouslySaved]").filter("[value='1']").closest('tr').find(".lnkDeleteRow").show();

            $("[id*=tbOpenDays]").addClass("validateThis numberOnly");
            $("[id*=tbAvailableUnitsDay]").addClass("validateThis numberOnly");
            $("[id*=tbUnitsSold]").addClass("validateThis numberOnly");
            $("[id*=tbTotalGuests]").addClass("validateThis numberOnly");
            $("[id*=tbVacationGuests]").addClass("validateThis numberOnly");
            $("[id*=tbBusinessGuests]").addClass("validateThis numberOnly");
            $("[id*=tbConventionGuests]").addClass("validateThis numberOnly");
            $("[id*=tbMotorcoachGuests]").addClass("validateThis numberOnly");
            $("[id*=tbOtherGuests]").addClass("validateThis numberOnly");

            $("[id*=ddlResearchClass]").addClass("validateThis");
            $("[id*=ddlClassRating]").addClass("validateThis");

            $("[id*=hdnPreviouslySaved]").filter("[value='0']").each(function () {
                var parentRow = $(this).closest('tr');
                if (parentRow.find("[id*=tbOpenDays]").val() == "0" && parentRow.find("[id*=tbUnitsSold]").val() == "0") {
                    parentRow.removeClass("unsavedRow").addClass("validRow");                    
                }
            });

            $("#cbDisplayClassRatingInputs").click(function () {
//                $('#tblData td:nth-child(13)').hide();
//                $('#tblData td:nth-child(14)').hide();
                $('#tblData td:nth-child(13)').toggle(this.checked);
                $('#tblData td:nth-child(14)').toggle(this.checked);
            });

            $(".readOnly").keydown(function (event) {
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
                    event.preventDefault();
                }
            });
            

            $(".validateThis").change(function () {
                var changedInput = $(this);
                ValidateRow(changedInput);
            });

            $(".numberOnly").keydown(function (event) {
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

//            $("a[class!='suppressWarning']").click(function () {
//                if ($(".validRow").size() > 0) {
//                    var r = confirm("There are valid rows that have not yet been saved, are you sure you want to proceed? (all unsaved data will be lost)");
//                    return r;
//                }
//            });

            $("a").not('.suppressWarning').click(function () {
                if ($(".validRow").size() > 0) {
                    var r = confirm("There are valid rows that have not yet been saved, are you sure you want to proceed? (all unsaved data will be lost)");
                    return r;
                }
            });
            
            $("[id*=btnSubmit]").click(function () {
                if ($(".hasError").size() > 0) {
                    var r = confirm("There are rows with errors, are you sure you want to proceed? (all data in rows with errors will be lost)");
                    return r;
                }
                return true;
            });
        }

        function GetDaysInMonth(month, year) {
            return new Date(year, month, 0).getDate();
        }

        function ValidateRow(changedInput) {
            var isValid = true;

            var year = $("[id*=ddlYear]").val();

            var parentRow = changedInput.closest('tr');

            var month = parentRow.find("[id*=hdnMonth]").val(); 

            //clear errors
            parentRow.find(".hasError").qtip("destroy");
            parentRow.find(".hasError").removeClass("hasError");
            parentRow.removeClass("validRow");
            parentRow.removeClass("savedRow");
            parentRow.removeClass("unsavedRow");

            var openDays = parentRow.find("[id*=tbOpenDays]").val();
            var unitsPerDay = parentRow.find("[id*=tbAvailableUnitsDay]").val();

            var unitsPerMonth = Number(unitsPerDay) * Number(openDays);

            parentRow.find("[id*=tdAvailableUnitsMonth]").html(unitsPerMonth);

            var unitsSold = parentRow.find("[id*=tbUnitsSold]").val();
            var totalGuests = parentRow.find("[id*=tbTotalGuests]").val();

            var vacation = parentRow.find("[id*=tbVacationGuests]").val();
            var business = parentRow.find("[id*=tbBusinessGuests]").val();
            var convention = parentRow.find("[id*=tbConventionGuests]").val();
            var motor = parentRow.find("[id*=tbMotorcoachGuests]").val();
            var other = parentRow.find("[id*=tbOtherGuests]").val();

            //alert(year + ":::" + month + ":::" + openDays + ":::" + unitsPerDay + ":::" + unitsPerMonth + ":::" + unitsSold + ":::" + totalGuests + ":::" + vacation + ":::" + business + ":::" + convention + ":::" + motor + ":::" + other);
            //var errorMessage = parentRow.find("[id*=dvRowError]").html();

            var errMsg = "";

            //number of opendays must be less than number of days in month
            if (Number(GetDaysInMonth(month, year)) < Number(openDays)) {
                isValid = false;
                //errMsg += errOpenDays + "<BR/>";
                parentRow.find("[id*=tbOpenDays]").addClass("hasError");
                parentRow.find("[id*=tbOpenDays]").qtip({
                    content: errOpenDays
                });
            }

            //percentages must sum to under 100
            if ((vacation != "" || business != "" || convention != "" || motor != "" || other != "") && ((Number(vacation) + Number(business) + Number(convention) + Number(motor) + Number(other)) != 100)) {
                isValid = false;
                //errMsg += errPercentages + "<BR/>";
                parentRow.find("[id*=tbVacationGuests]").addClass("hasError");
                parentRow.find("[id*=tbVacationGuests]").qtip({
                    content: errPercentages
                });

                parentRow.find("[id*=tbBusinessGuests]").addClass("hasError");
                parentRow.find("[id*=tbBusinessGuests]").qtip({
                    content: errPercentages
                });

                parentRow.find("[id*=tbMotorcoachGuests]").addClass("hasError");
                parentRow.find("[id*=tbMotorcoachGuests]").qtip({
                    content: errPercentages
                });

                parentRow.find("[id*=tbConventionGuests]").addClass("hasError");
                parentRow.find("[id*=tbConventionGuests]").qtip({
                    content: errPercentages
                });

                parentRow.find("[id*=tbOtherGuests]").addClass("hasError");
                parentRow.find("[id*=tbOtherGuests]").qtip({
                    content: errPercentages
                });


            }

            if (unitsSold.length == 0) {
                isValid = false;
                //errMsg += errUnitsSoldReq + "<BR/>";

                parentRow.find("[id*=tbUnitsSold]").addClass("hasError");
                parentRow.find("[id*=tbUnitsSold]").qtip({
                    content: errUnitsSoldReq
                });

            }

            if (totalGuests.length == 0) {
                isValid = false;
                //errMsg += errTotalGuestsReq + "<BR/>";

                parentRow.find("[id*=tbTotalGuests]").addClass("hasError");
                parentRow.find("[id*=tbTotalGuests]").qtip({
                    content: errTotalGuestsReq
                });
            }

            //units sold for month needs to be less than the available units for the month
            if (Number(unitsSold) > Number(unitsPerMonth)) {
                //  alert(unitsSold + ":::" + unitsPerMonth);
                isValid = false;
                //errMsg += errUnitsSold + "<BR/>";

                parentRow.find("[id*=tbUnitsSold]").addClass("hasError");
                parentRow.find("[id*=tbUnitsSold]").qtip({
                    content: errUnitsSold
                });

            }

            //total guests must be greater than the units sold
            if (totalGuests.length > 0 && (Number(totalGuests) < Number(unitsSold))) {
                //  alert(unitsSold + ":::" + unitsPerMonth);
                isValid = false;
                //errMsg += errTotalGuests + "<BR/>";

                parentRow.find("[id*=tbTotalGuests]").addClass("hasError");
                parentRow.find("[id*=tbTotalGuests]").qtip({
                    content: errTotalGuests
                });

            }

            if (isValid) {
                parentRow.addClass("validRow");
            }
        }

        function IsNumber(n) {
            return !isNaN(parseFloat(n)) && isFinite(n);
        }
        // Resets the values for the filter textboxes
        function ClearFilters() {

        }

        function MakeFormAdjustments() {
        }

    </script>
</asp:Content> 
<asp:Content ID="cMainContent" ContentPlaceHolderID="cphMainContent" Runat="Server"> 
    <div class="page_header clearfix">
		<h2 class="page_title">Research</h2>
	</div>   
    <asp:HiddenField ID="hdnProductId" runat="server" />
  
    <table cellpadding="0" cellspacing="0" border="0" class="researchProdInfo">
        <tr>
            <td class="form_label"><label>Year</label></td>
            <td class="form_label"><label>License number</label></td>
            <td class="form_label"><label>Product name</label></td>
            <td class="form_label"><label>Display class &amp; rating</label></td>
        </tr>
        <tr>
            <td class="form_input"><asp:DropDownList ID="ddlYear" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlYear_OnSelectedIndexChanged"></asp:DropDownList></td>
            <td class="form_input"><asp:Literal ID="litLicenseNumber" runat="server"></asp:Literal></td>
            <td class="form_input"><asp:Literal ID="litProductName" runat="server"></asp:Literal></td>
            <td class="form_input"><input type="checkbox" id="cbDisplayClassRatingInputs" checked="true" /></td>
        </tr>
    </table>

 <div id="tabs" class="clearfix">
    <div class="form_tabs clearfix">
        <ul class="clearfix">
            <li class="first"><a href="#fragment-1" class="suppressWarning"><span class="fr_tab">Research data</span></a></li>
            <li><a href="#fragment-2" class="suppressWarning"><span class="fr_tab">Product data</span></a></li>
            <li class="last"><a href="#fragment-3" class="suppressWarning"><span class="fr_tab">Notes</span></a></li>
        </ul>
    </div>

    <div id="fragment-1">
    <table id="tblData" border="0" cellpadding="0" cellspacing="0" class="tbl_data">
        
        <tr class="tbl_preHeader">
            <td></td>
            <td></td>
            <td></td>
            <td colspan="2"></td>
            <td></td>
            <td></td>
            <td colspan="5" class="headerGroup"><strong>Visitor Percentages</strong><div></div></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr class="tbl_header">
            <td><strong>Year</strong></td>
            <td><strong>Month</strong></td>
            <td><strong>Open<br />Days</strong></td>
            <td><strong>Units</strong></td>
            <td><strong>Available<br/>Units</strong></td>
            <td><strong>Units<br />Sold</strong></td>
            <td><strong>Total<br />Guests</strong></td>
            <td><strong>Vac.</strong></td>
            <td><strong>Bus.</strong></td>
            <td><strong>Conv.</strong></td>
            <td><strong>Motor.</strong></td>
            <td><strong>Other</strong></td>
            <td><strong>Class</strong></td>
            <td><strong>Rating</strong></td>
            <td><strong>Action</strong></td>
        </tr>
        <tr class="tbl_datarow" id="dataRow01">
            <td>
                <asp:Literal ID="litYear1" runat="server"></asp:Literal>
                <asp:HiddenField runat="server" ID="hdnPreviouslySaved1" Value="" />
                <asp:HiddenField runat="server" ID="hdnIsEnabled1" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth1" Value="1" />
            </td>
            <td id="tdMonthName">
                January
            </td>
           
            <td>
                <asp:TextBox ID="tbOpenDays1" runat="server" Width="40" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableUnitsDay1" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td id="tdAvailableUnitsMonth1">
                <asp:Literal ID="litAvailableUnitsMonth1" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbUnitsSold1" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests1" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbVacationGuests1" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbBusinessGuests1" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbConventionGuests1" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbMotorcoachGuests1" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbOtherGuests1" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
             <td>
                <asp:DropDownList ID="ddlResearchClass1" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="1">Apart.</asp:ListItem>
                    <asp:ListItem Value="2">B&B</asp:ListItem>
                    <asp:ListItem Value="3">B&B Inn</asp:ListItem>
                    <asp:ListItem Value="4">Cott/Cab</asp:ListItem>
                    <asp:ListItem Value="5">Hostel</asp:ListItem>
                    <asp:ListItem Value="6">Hotel</asp:ListItem>
                    <asp:ListItem Value="7">Lodge</asp:ListItem>
                    <asp:ListItem Value="8">Inn</asp:ListItem>
                    <asp:ListItem Value="9">Motel</asp:ListItem>
                    <asp:ListItem Value="10">Resort</asp:ListItem>
                    <asp:ListItem Value="11">Tourist</asp:ListItem>
                    <asp:ListItem Value="12">Univ.</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>
                <asp:DropDownList ID="ddlClassRating1" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="2">1.0</asp:ListItem>
                    <asp:ListItem Value="3">1.5</asp:ListItem>
                    <asp:ListItem Value="4">2.0</asp:ListItem>
                    <asp:ListItem Value="5">2.5</asp:ListItem>
                    <asp:ListItem Value="6">3.0</asp:ListItem>
                    <asp:ListItem Value="7">3.5</asp:ListItem>
                    <asp:ListItem Value="8">4.0</asp:ListItem>
                    <asp:ListItem Value="9">4.5</asp:ListItem>
                    <asp:ListItem Value="10">5.0</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td><a id="lnkDeleteMonth" theMonth="1" class="lnkDeleteRow suppressWarning" style="display:none;">Delete</a></td>
        </tr>
        <tr class="tbl_datarow" id="dataRow02">
            <td>
                <asp:Literal ID="litYear2" runat="server"></asp:Literal>
                <asp:HiddenField runat="server" ID="hdnPreviouslySaved2" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth2" Value="1" />
                <asp:HiddenField runat="server" ID="hdnIsEnabled2" Value="" />
            </td>
            <td id="tdMonthName">
                February
            </td>
           
            <td>
                <asp:TextBox ID="tbOpenDays2" runat="server" Width="40" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableUnitsDay2" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td id="tdAvailableUnitsMonth2">
                <asp:Literal ID="litAvailableUnitsMonth2" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbUnitsSold2" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests2" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbVacationGuests2" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbBusinessGuests2" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbConventionGuests2" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbMotorcoachGuests2" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbOtherGuests2" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
             <td>
                <asp:DropDownList ID="ddlResearchClass2" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="1">Apart.</asp:ListItem>
                    <asp:ListItem Value="2">B&B</asp:ListItem>
                    <asp:ListItem Value="3">B&B Inn</asp:ListItem>
                    <asp:ListItem Value="4">Cott/Cab</asp:ListItem>
                    <asp:ListItem Value="5">Hostel</asp:ListItem>
                    <asp:ListItem Value="6">Hotel</asp:ListItem>
                    <asp:ListItem Value="7">Lodge</asp:ListItem>
                    <asp:ListItem Value="8">Inn</asp:ListItem>
                    <asp:ListItem Value="9">Motel</asp:ListItem>
                    <asp:ListItem Value="10">Resort</asp:ListItem>
                    <asp:ListItem Value="11">Tourist</asp:ListItem>
                    <asp:ListItem Value="12">Univ.</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>
                <asp:DropDownList ID="ddlClassRating2" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="2">1.0</asp:ListItem>
                    <asp:ListItem Value="3">1.5</asp:ListItem>
                    <asp:ListItem Value="4">2.0</asp:ListItem>
                    <asp:ListItem Value="5">2.5</asp:ListItem>
                    <asp:ListItem Value="6">3.0</asp:ListItem>
                    <asp:ListItem Value="7">3.5</asp:ListItem>
                    <asp:ListItem Value="8">4.0</asp:ListItem>
                    <asp:ListItem Value="9">4.5</asp:ListItem>
                    <asp:ListItem Value="10">5.0</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td><a id="lnkDeleteMonth" theMonth="2" class="lnkDeleteRow suppressWarning" style="display:none;">Delete</a></td>
        </tr>
        <tr class="tbl_datarow" id="dataRow03">
            <td>
                <asp:Literal ID="litYear3" runat="server"></asp:Literal>
                <asp:HiddenField runat="server" ID="hdnPreviouslySaved3" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth3" Value="1" />
                <asp:HiddenField runat="server" ID="hdnIsEnabled3" Value="" />
            </td>
            <td id="tdMonthName">
                March
            </td>
           
            <td>
                <asp:TextBox ID="tbOpenDays3" runat="server" Width="40" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableUnitsDay3" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td id="tdAvailableUnitsMonth3">
                <asp:Literal ID="litAvailableUnitsMonth3" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbUnitsSold3" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests3" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbVacationGuests3" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbBusinessGuests3" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbConventionGuests3" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbMotorcoachGuests3" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbOtherGuests3" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
             <td>
                <asp:DropDownList ID="ddlResearchClass3" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="1">Apart.</asp:ListItem>
                    <asp:ListItem Value="2">B&B</asp:ListItem>
                    <asp:ListItem Value="3">B&B Inn</asp:ListItem>
                    <asp:ListItem Value="4">Cott/Cab</asp:ListItem>
                    <asp:ListItem Value="5">Hostel</asp:ListItem>
                    <asp:ListItem Value="6">Hotel</asp:ListItem>
                    <asp:ListItem Value="7">Lodge</asp:ListItem>
                    <asp:ListItem Value="8">Inn</asp:ListItem>
                    <asp:ListItem Value="9">Motel</asp:ListItem>
                    <asp:ListItem Value="10">Resort</asp:ListItem>
                    <asp:ListItem Value="11">Tourist</asp:ListItem>
                    <asp:ListItem Value="12">Univ.</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>
                <asp:DropDownList ID="ddlClassRating3" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="2">1.0</asp:ListItem>
                    <asp:ListItem Value="3">1.5</asp:ListItem>
                    <asp:ListItem Value="4">2.0</asp:ListItem>
                    <asp:ListItem Value="5">2.5</asp:ListItem>
                    <asp:ListItem Value="6">3.0</asp:ListItem>
                    <asp:ListItem Value="7">3.5</asp:ListItem>
                    <asp:ListItem Value="8">4.0</asp:ListItem>
                    <asp:ListItem Value="9">4.5</asp:ListItem>
                    <asp:ListItem Value="10">5.0</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td><a id="lnkDeleteMonth" theMonth="3" class="lnkDeleteRow suppressWarning" style="display:none;">Delete</a></td>
        </tr>
        <tr class="tbl_datarow" id="dataRow04">
            <td>
                <asp:Literal ID="litYear4" runat="server"></asp:Literal>
                <asp:HiddenField runat="server" ID="hdnPreviouslySaved4" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth4" Value="4" />
                <asp:HiddenField runat="server" ID="hdnIsEnabled4" Value="" />
            </td>
            <td id="tdMonthName">
                April
            </td>
            <td>
                <asp:TextBox ID="tbOpenDays4" runat="server" Width="40" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableUnitsDay4" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td id="tdAvailableUnitsMonth4">
                <asp:Literal ID="litAvailableUnitsMonth4" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbUnitsSold4" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests4" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbVacationGuests4" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbBusinessGuests4" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbConventionGuests4" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbMotorcoachGuests4" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbOtherGuests4" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:DropDownList ID="ddlResearchClass4" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="1">Apart.</asp:ListItem>
                    <asp:ListItem Value="2">B&B</asp:ListItem>
                    <asp:ListItem Value="3">B&B Inn</asp:ListItem>
                    <asp:ListItem Value="4">Cott/Cab</asp:ListItem>
                    <asp:ListItem Value="5">Hostel</asp:ListItem>
                    <asp:ListItem Value="6">Hotel</asp:ListItem>
                    <asp:ListItem Value="7">Lodge</asp:ListItem>
                    <asp:ListItem Value="8">Inn</asp:ListItem>
                    <asp:ListItem Value="9">Motel</asp:ListItem>
                    <asp:ListItem Value="10">Resort</asp:ListItem>
                    <asp:ListItem Value="11">Tourist</asp:ListItem>
                    <asp:ListItem Value="12">Univ.</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>
                <asp:DropDownList ID="ddlClassRating4" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="2">1.0</asp:ListItem>
                    <asp:ListItem Value="3">1.5</asp:ListItem>
                    <asp:ListItem Value="4">2.0</asp:ListItem>
                    <asp:ListItem Value="5">2.5</asp:ListItem>
                    <asp:ListItem Value="6">3.0</asp:ListItem>
                    <asp:ListItem Value="7">3.5</asp:ListItem>
                    <asp:ListItem Value="8">4.0</asp:ListItem>
                    <asp:ListItem Value="9">4.5</asp:ListItem>
                    <asp:ListItem Value="10">5.0</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td><a id="lnkDeleteMonth" theMonth="4" class="lnkDeleteRow suppressWarning" style="display:none;">Delete</a></td>
        </tr>
        <tr class="tbl_datarow" id="dataRow05">
            <td>
                <asp:Literal ID="litYear5" runat="server"></asp:Literal>
                <asp:HiddenField runat="server" ID="hdnPreviouslySaved5" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth5" Value="1" />
                <asp:HiddenField runat="server" ID="hdnIsEnabled5" Value="" />
            </td>
            <td id="tdMonthName">
                May
            </td>
           
            <td>
                <asp:TextBox ID="tbOpenDays5" runat="server" Width="40" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableUnitsDay5" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td id="tdAvailableUnitsMonth5">
                <asp:Literal ID="litAvailableUnitsMonth5" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbUnitsSold5" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests5" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbVacationGuests5" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbBusinessGuests5" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbConventionGuests5" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbMotorcoachGuests5" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbOtherGuests5" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
             <td>
                <asp:DropDownList ID="ddlResearchClass5" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="1">Apart.</asp:ListItem>
                    <asp:ListItem Value="2">B&B</asp:ListItem>
                    <asp:ListItem Value="3">B&B Inn</asp:ListItem>
                    <asp:ListItem Value="4">Cott/Cab</asp:ListItem>
                    <asp:ListItem Value="5">Hostel</asp:ListItem>
                    <asp:ListItem Value="6">Hotel</asp:ListItem>
                    <asp:ListItem Value="7">Lodge</asp:ListItem>
                    <asp:ListItem Value="8">Inn</asp:ListItem>
                    <asp:ListItem Value="9">Motel</asp:ListItem>
                    <asp:ListItem Value="10">Resort</asp:ListItem>
                    <asp:ListItem Value="11">Tourist</asp:ListItem>
                    <asp:ListItem Value="12">Univ.</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>
                <asp:DropDownList ID="ddlClassRating5" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="2">1.0</asp:ListItem>
                    <asp:ListItem Value="3">1.5</asp:ListItem>
                    <asp:ListItem Value="4">2.0</asp:ListItem>
                    <asp:ListItem Value="5">2.5</asp:ListItem>
                    <asp:ListItem Value="6">3.0</asp:ListItem>
                    <asp:ListItem Value="7">3.5</asp:ListItem>
                    <asp:ListItem Value="8">4.0</asp:ListItem>
                    <asp:ListItem Value="9">4.5</asp:ListItem>
                    <asp:ListItem Value="10">5.0</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td><a id="lnkDeleteMonth" theMonth="5" class="lnkDeleteRow suppressWarning" style="display:none;">Delete</a></td>
        </tr>
        <tr class="tbl_datarow" id="dataRow06">
            <td>
                <asp:Literal ID="litYear6" runat="server"></asp:Literal>
                <asp:HiddenField runat="server" ID="hdnPreviouslySaved6" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth6" Value="6" />
                <asp:HiddenField runat="server" ID="hdnIsEnabled6" Value="" />
            </td>
            <td id="tdMonthName">
                June
            </td>
            
            <td>
                <asp:TextBox ID="tbOpenDays6" runat="server" Width="40" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableUnitsDay6" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td id="tdAvailableUnitsMonth6">
                <asp:Literal ID="litAvailableUnitsMonth6" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbUnitsSold6" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests6" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbVacationGuests6" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbBusinessGuests6" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbConventionGuests6" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbMotorcoachGuests6" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbOtherGuests6" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:DropDownList ID="ddlResearchClass6" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="1">Apart.</asp:ListItem>
                    <asp:ListItem Value="2">B&B</asp:ListItem>
                    <asp:ListItem Value="3">B&B Inn</asp:ListItem>
                    <asp:ListItem Value="4">Cott/Cab</asp:ListItem>
                    <asp:ListItem Value="5">Hostel</asp:ListItem>
                    <asp:ListItem Value="6">Hotel</asp:ListItem>
                    <asp:ListItem Value="7">Lodge</asp:ListItem>
                    <asp:ListItem Value="8">Inn</asp:ListItem>
                    <asp:ListItem Value="9">Motel</asp:ListItem>
                    <asp:ListItem Value="10">Resort</asp:ListItem>
                    <asp:ListItem Value="11">Tourist</asp:ListItem>
                    <asp:ListItem Value="12">Univ.</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>
                <asp:DropDownList ID="ddlClassRating6" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="2">1.0</asp:ListItem>
                    <asp:ListItem Value="3">1.5</asp:ListItem>
                    <asp:ListItem Value="4">2.0</asp:ListItem>
                    <asp:ListItem Value="5">2.5</asp:ListItem>
                    <asp:ListItem Value="6">3.0</asp:ListItem>
                    <asp:ListItem Value="7">3.5</asp:ListItem>
                    <asp:ListItem Value="8">4.0</asp:ListItem>
                    <asp:ListItem Value="9">4.5</asp:ListItem>
                    <asp:ListItem Value="10">5.0</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td><a id="lnkDeleteMonth" theMonth="6" class="lnkDeleteRow suppressWarning" style="display:none;">Delete</a></td>
        </tr>
        <tr class="tbl_datarow" id="dataRow07">
            <td>
                <asp:Literal ID="litYear7" runat="server"></asp:Literal>
                <asp:HiddenField runat="server" ID="hdnPreviouslySaved7" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth7" Value="7" />
                <asp:HiddenField runat="server" ID="hdnIsEnabled7" Value="" />
            </td>
            <td id="tdMonthName">
                July
            </td>
           
            <td>
                <asp:TextBox ID="tbOpenDays7" runat="server" Width="40" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableUnitsDay7" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td id="tdAvailableUnitsMonth7">
                <asp:Literal ID="litAvailableUnitsMonth7" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbUnitsSold7" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests7" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbVacationGuests7" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbBusinessGuests7" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbConventionGuests7" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbMotorcoachGuests7" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbOtherGuests7" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
             <td>
                <asp:DropDownList ID="ddlResearchClass7" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="1">Apart.</asp:ListItem>
                    <asp:ListItem Value="2">B&B</asp:ListItem>
                    <asp:ListItem Value="3">B&B Inn</asp:ListItem>
                    <asp:ListItem Value="4">Cott/Cab</asp:ListItem>
                    <asp:ListItem Value="5">Hostel</asp:ListItem>
                    <asp:ListItem Value="6">Hotel</asp:ListItem>
                    <asp:ListItem Value="7">Lodge</asp:ListItem>
                    <asp:ListItem Value="8">Inn</asp:ListItem>
                    <asp:ListItem Value="9">Motel</asp:ListItem>
                    <asp:ListItem Value="10">Resort</asp:ListItem>
                    <asp:ListItem Value="11">Tourist</asp:ListItem>
                    <asp:ListItem Value="12">Univ.</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>
                <asp:DropDownList ID="ddlClassRating7" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="2">1.0</asp:ListItem>
                    <asp:ListItem Value="3">1.5</asp:ListItem>
                    <asp:ListItem Value="4">2.0</asp:ListItem>
                    <asp:ListItem Value="5">2.5</asp:ListItem>
                    <asp:ListItem Value="6">3.0</asp:ListItem>
                    <asp:ListItem Value="7">3.5</asp:ListItem>
                    <asp:ListItem Value="8">4.0</asp:ListItem>
                    <asp:ListItem Value="9">4.5</asp:ListItem>
                    <asp:ListItem Value="10">5.0</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td><a id="lnkDeleteMonth" theMonth="7" class="lnkDeleteRow suppressWarning" style="display:none;">Delete</a></td>
        </tr>
        <tr class="tbl_datarow" id="dataRow08">
            <td>
                <asp:Literal ID="litYear8" runat="server"></asp:Literal>
                <asp:HiddenField runat="server" ID="hdnPreviouslySaved8" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth8" Value="8" />
                <asp:HiddenField runat="server" ID="hdnIsEnabled8" Value="" />
            </td>
            <td id="tdMonthName">
                August
            </td>
           
            <td>
                <asp:TextBox ID="tbOpenDays8" runat="server" Width="40" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableUnitsDay8" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td id="tdAvailableUnitsMonth8">
                <asp:Literal ID="litAvailableUnitsMonth8" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbUnitsSold8" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests8" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbVacationGuests8" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbBusinessGuests8" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbConventionGuests8" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbMotorcoachGuests8" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbOtherGuests8" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
             <td>
                <asp:DropDownList ID="ddlResearchClass8" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="1">Apart.</asp:ListItem>
                    <asp:ListItem Value="2">B&B</asp:ListItem>
                    <asp:ListItem Value="3">B&B Inn</asp:ListItem>
                    <asp:ListItem Value="4">Cott/Cab</asp:ListItem>
                    <asp:ListItem Value="5">Hostel</asp:ListItem>
                    <asp:ListItem Value="6">Hotel</asp:ListItem>
                    <asp:ListItem Value="7">Lodge</asp:ListItem>
                    <asp:ListItem Value="8">Inn</asp:ListItem>
                    <asp:ListItem Value="9">Motel</asp:ListItem>
                    <asp:ListItem Value="10">Resort</asp:ListItem>
                    <asp:ListItem Value="11">Tourist</asp:ListItem>
                    <asp:ListItem Value="12">Univ.</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>
                <asp:DropDownList ID="ddlClassRating8" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="2">1.0</asp:ListItem>
                    <asp:ListItem Value="3">1.5</asp:ListItem>
                    <asp:ListItem Value="4">2.0</asp:ListItem>
                    <asp:ListItem Value="5">2.5</asp:ListItem>
                    <asp:ListItem Value="6">3.0</asp:ListItem>
                    <asp:ListItem Value="7">3.5</asp:ListItem>
                    <asp:ListItem Value="8">4.0</asp:ListItem>
                    <asp:ListItem Value="9">4.5</asp:ListItem>
                    <asp:ListItem Value="10">5.0</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td><a id="lnkDeleteMonth" theMonth="8" class="lnkDeleteRow suppressWarning" style="display:none;">Delete</a></td>
        </tr>
        <tr class="tbl_datarow" id="dataRow09">
            <td>
                <asp:Literal ID="litYear9" runat="server"></asp:Literal>
                <asp:HiddenField runat="server" ID="hdnPreviouslySaved9" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth9" Value="9" />
                <asp:HiddenField runat="server" ID="hdnIsEnabled9" Value="" />
            </td>
            <td id="tdMonthName">
                September
            </td>
           
            <td>
                <asp:TextBox ID="tbOpenDays9" runat="server" Width="40" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableUnitsDay9" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td id="tdAvailableUnitsMonth9">
                <asp:Literal ID="litAvailableUnitsMonth9" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbUnitsSold9" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests9" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbVacationGuests9" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbBusinessGuests9" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbConventionGuests9" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbMotorcoachGuests9" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbOtherGuests9" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
             <td>
                <asp:DropDownList ID="ddlResearchClass9" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="1">Apart.</asp:ListItem>
                    <asp:ListItem Value="2">B&B</asp:ListItem>
                    <asp:ListItem Value="3">B&B Inn</asp:ListItem>
                    <asp:ListItem Value="4">Cott/Cab</asp:ListItem>
                    <asp:ListItem Value="5">Hostel</asp:ListItem>
                    <asp:ListItem Value="6">Hotel</asp:ListItem>
                    <asp:ListItem Value="7">Lodge</asp:ListItem>
                    <asp:ListItem Value="8">Inn</asp:ListItem>
                    <asp:ListItem Value="9">Motel</asp:ListItem>
                    <asp:ListItem Value="10">Resort</asp:ListItem>
                    <asp:ListItem Value="11">Tourist</asp:ListItem>
                    <asp:ListItem Value="12">Univ.</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>
                <asp:DropDownList ID="ddlClassRating9" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="2">1.0</asp:ListItem>
                    <asp:ListItem Value="3">1.5</asp:ListItem>
                    <asp:ListItem Value="4">2.0</asp:ListItem>
                    <asp:ListItem Value="5">2.5</asp:ListItem>
                    <asp:ListItem Value="6">3.0</asp:ListItem>
                    <asp:ListItem Value="7">3.5</asp:ListItem>
                    <asp:ListItem Value="8">4.0</asp:ListItem>
                    <asp:ListItem Value="9">4.5</asp:ListItem>
                    <asp:ListItem Value="10">5.0</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td><a id="lnkDeleteMonth" theMonth="9" class="lnkDeleteRow suppressWarning" style="display:none;">Delete</a></td>
        </tr>
        <tr class="tbl_datarow" id="dataRow10">
            <td>
                <asp:Literal ID="litYear10" runat="server"></asp:Literal>
                <asp:HiddenField runat="server" ID="hdnPreviouslySaved10" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth10" Value="10" />
                <asp:HiddenField runat="server" ID="hdnIsEnabled10" Value="" />
            </td>
            <td id="tdMonthName">
                October
            </td>
           
            <td>
                <asp:TextBox ID="tbOpenDays10" runat="server" Width="40" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableUnitsDay10" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td id="tdAvailableUnitsMonth10">
                <asp:Literal ID="litAvailableUnitsMonth10" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbUnitsSold10" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests10" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbVacationGuests10" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbBusinessGuests10" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbConventionGuests10" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbMotorcoachGuests10" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbOtherGuests10" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
             <td>
                <asp:DropDownList ID="ddlResearchClass10" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="1">Apart.</asp:ListItem>
                    <asp:ListItem Value="2">B&B</asp:ListItem>
                    <asp:ListItem Value="3">B&B Inn</asp:ListItem>
                    <asp:ListItem Value="4">Cott/Cab</asp:ListItem>
                    <asp:ListItem Value="5">Hostel</asp:ListItem>
                    <asp:ListItem Value="6">Hotel</asp:ListItem>
                    <asp:ListItem Value="7">Lodge</asp:ListItem>
                    <asp:ListItem Value="8">Inn</asp:ListItem>
                    <asp:ListItem Value="9">Motel</asp:ListItem>
                    <asp:ListItem Value="10">Resort</asp:ListItem>
                    <asp:ListItem Value="11">Tourist</asp:ListItem>
                    <asp:ListItem Value="12">Univ.</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>
                <asp:DropDownList ID="ddlClassRating10" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="2">1.0</asp:ListItem>
                    <asp:ListItem Value="3">1.5</asp:ListItem>
                    <asp:ListItem Value="4">2.0</asp:ListItem>
                    <asp:ListItem Value="5">2.5</asp:ListItem>
                    <asp:ListItem Value="6">3.0</asp:ListItem>
                    <asp:ListItem Value="7">3.5</asp:ListItem>
                    <asp:ListItem Value="8">4.0</asp:ListItem>
                    <asp:ListItem Value="9">4.5</asp:ListItem>
                    <asp:ListItem Value="10">5.0</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td><a id="lnkDeleteMonth" theMonth="10" class="lnkDeleteRow suppressWarning" style="display:none;">Delete</a></td>
        </tr>
        <tr class="tbl_datarow" id="dataRow11">
            <td>
                <asp:Literal ID="litYear11" runat="server"></asp:Literal>
                <asp:HiddenField runat="server" ID="hdnPreviouslySaved11" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth11" Value="11" />
                <asp:HiddenField runat="server" ID="hdnIsEnabled11" Value="11" />
            </td>
            <td id="tdMonthName">
                November
            </td>
           
            <td>
                <asp:TextBox ID="tbOpenDays11" runat="server" Width="40" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableUnitsDay11" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td id="tdAvailableUnitsMonth11">
                <asp:Literal ID="litAvailableUnitsMonth11" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbUnitsSold11" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests11" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbVacationGuests11" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbBusinessGuests11" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbConventionGuests11" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbMotorcoachGuests11" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbOtherGuests11" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
             <td>
                <asp:DropDownList ID="ddlResearchClass11" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="1">Apart.</asp:ListItem>
                    <asp:ListItem Value="2">B&B</asp:ListItem>
                    <asp:ListItem Value="3">B&B Inn</asp:ListItem>
                    <asp:ListItem Value="4">Cott/Cab</asp:ListItem>
                    <asp:ListItem Value="5">Hostel</asp:ListItem>
                    <asp:ListItem Value="6">Hotel</asp:ListItem>
                    <asp:ListItem Value="7">Lodge</asp:ListItem>
                    <asp:ListItem Value="8">Inn</asp:ListItem>
                    <asp:ListItem Value="9">Motel</asp:ListItem>
                    <asp:ListItem Value="10">Resort</asp:ListItem>
                    <asp:ListItem Value="11">Tourist</asp:ListItem>
                    <asp:ListItem Value="12">Univ.</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>
                <asp:DropDownList ID="ddlClassRating11" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="2">1.0</asp:ListItem>
                    <asp:ListItem Value="3">1.5</asp:ListItem>
                    <asp:ListItem Value="4">2.0</asp:ListItem>
                    <asp:ListItem Value="5">2.5</asp:ListItem>
                    <asp:ListItem Value="6">3.0</asp:ListItem>
                    <asp:ListItem Value="7">3.5</asp:ListItem>
                    <asp:ListItem Value="8">4.0</asp:ListItem>
                    <asp:ListItem Value="9">4.5</asp:ListItem>
                    <asp:ListItem Value="10">5.0</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td><a id="lnkDeleteMonth" theMonth="11" class="lnkDeleteRow suppressWarning" style="display:none;">Delete</a></td>
        </tr>
        <tr class="tbl_datarow" id="dataRow12">
            <td>
                <asp:Literal ID="litYear12" runat="server"></asp:Literal>
                <asp:HiddenField runat="server" ID="hdnPreviouslySaved12" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth12" Value="12" />
                <asp:HiddenField runat="server" ID="hdnIsEnabled12" Value="" />
            </td>
            <td id="tdMonthName">
                December
            </td>
            
            <td>
                <asp:TextBox ID="tbOpenDays12" runat="server" Width="40" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableUnitsDay12" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td id="tdAvailableUnitsMonth12">
                <asp:Literal ID="litAvailableUnitsMonth12" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbUnitsSold12" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests12" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbVacationGuests12" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbBusinessGuests12" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbConventionGuests12" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbMotorcoachGuests12" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbOtherGuests12" runat="server" Width="40" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:DropDownList ID="ddlResearchClass12" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="1">Apart.</asp:ListItem>
                    <asp:ListItem Value="2">B&B</asp:ListItem>
                    <asp:ListItem Value="3">B&B Inn</asp:ListItem>
                    <asp:ListItem Value="4">Cott/Cab</asp:ListItem>
                    <asp:ListItem Value="5">Hostel</asp:ListItem>
                    <asp:ListItem Value="6">Hotel</asp:ListItem>
                    <asp:ListItem Value="7">Lodge</asp:ListItem>
                    <asp:ListItem Value="8">Inn</asp:ListItem>
                    <asp:ListItem Value="9">Motel</asp:ListItem>
                    <asp:ListItem Value="10">Resort</asp:ListItem>
                    <asp:ListItem Value="11">Tourist</asp:ListItem>
                    <asp:ListItem Value="12">Univ.</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>
                <asp:DropDownList ID="ddlClassRating12" runat="server">
                    <asp:ListItem Value="">Select...</asp:ListItem>
                    <asp:ListItem Value="2">1.0</asp:ListItem>
                    <asp:ListItem Value="3">1.5</asp:ListItem>
                    <asp:ListItem Value="4">2.0</asp:ListItem>
                    <asp:ListItem Value="5">2.5</asp:ListItem>
                    <asp:ListItem Value="6">3.0</asp:ListItem>
                    <asp:ListItem Value="7">3.5</asp:ListItem>
                    <asp:ListItem Value="8">4.0</asp:ListItem>
                    <asp:ListItem Value="9">4.5</asp:ListItem>
                    <asp:ListItem Value="10">5.0</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td><a id="lnkDeleteMonth" theMonth="12" class="lnkDeleteRow suppressWarning" style="display:none;">Delete</a></td>
        </tr>
    </table>
    </div>
    <div id="fragment-2">       
    

        <div style="width:940px;margin:0 auto;" class="clearfix">
            <div class="form_left">
                <div class="form_fields clearfix">
                    <div class="form_label"><label>Region</label></div>
                    <div class="form_input"><asp:Literal ID="litRegion" runat="server"></asp:Literal></div>
                </div>
                <div class="form_fields clearfix">
                    <div class="form_label"><label>General area</label></div>
                    <div class="form_input"><asp:Literal ID="litSubRegion" runat="server"></asp:Literal></div>
                </div>
                <div class="form_fields clearfix">
                    <div class="form_label"><label>County</label></div>
                    <div class="form_input"><asp:Literal ID="litCounty" runat="server"></asp:Literal></div>
                </div>
                <div class="form_fields clearfix">
                    <div class="form_label"><label>Canada Select Class</label></div>
                    <div class="form_input"><asp:Literal ID="litCanadaSelectClass" runat="server"></asp:Literal></div>
                </div>
                <div class="form_fields clearfix">
                    <div class="form_label"><label>Canada Select Rating</label></div>
                    <div class="form_input"><asp:Literal ID="litCanadaSelectRating" runat="server"></asp:Literal></div>
                </div>
                <div class="form_fields clearfix">
                    <div class="form_label"><label>Product Status</label></div>
                    <div class="form_input"><asp:Literal ID="litProductStatus" runat="server"></asp:Literal></div>
                </div>
            </div>
            <div class="form_right">
                <div class="form_fields clearfix">
                    <asp:ListView ID="lvClasses" runat="server">
                        <LayoutTemplate>
                            <table border="0" cellpadding="0" cellspacing="0" class="tbl_data" style="table-layout:fixed;margin:0 0 2em;">
                                <tr class="tbl_header">
                                    <td><strong>Class</strong></td>
                                    <td><strong>Number of units</strong></td>
                                </tr>
                                <div id="itemPlaceholder" runat="server" />
                            </table>
                        </LayoutTemplate>
                        <ItemTemplate ><tr><td><%# Eval("classLabel") %></td><td><%# Eval("unitTotal") %></td></tr></ItemTemplate>
                        <EmptyDataTemplate>
                            <table border="0" cellpadding="0" cellspacing="0" class="tbl_data" style="table-layout:fixed;margin:0 0 2em;">
                                <tr class="tbl_header">
                                    <td><strong>Class</strong></td>
                                    <td><strong>Number of units</strong></td>
                                </tr>
                                <tr>
                                    <td colspan="2">No records available.</td>
                                </tr>
                            </table>
                        </EmptyDataTemplate>
                    </asp:ListView>
                    <br/>
                    <table border="0" cellpadding="0" cellspacing="0" class="tbl_data" style="table-layout:fixed;margin:0 0 2em;">
                        <tr class="tbl_header">
                            <td><b>Seasonal Dates</b></td>
                        </tr>
                        <tr>
                            <td><asp:Literal id="litSeasonalDates" runat="server" ></asp:Literal></td>
                        </tr>
                    </table>
                   
                    <br/>
                    Operational Dates
                    <asp:ListView ID="lvOperationDates" runat="server">
                        <LayoutTemplate>
                            <table border="0" cellpadding="0" cellspacing="0" class="tbl_data" style="table-layout:fixed;margin:0 0 2em;">
                                <tr class="tbl_header">
                                    <td><strong>Open Date</strong></td>
                                    <td><strong>Close Date</strong></td>
                                </tr>
                                <div id="itemPlaceholder" runat="server" />
                            </table>
                        </LayoutTemplate>
                        <ItemTemplate >
                            <tr>
                                <td><%# DataBinder.Eval(Container.DataItem,"openDate","{0:MMM d, yyyy}") %></td>
                                <td><%# (Eval("closeDate") != null) ? DataBinder.Eval(Container.DataItem,"closeDate","{0:MMM d, yyyy}") : "Present"%></td>
                            </tr>
                        </ItemTemplate>
                        <EmptyDataTemplate>
                            <table border="0" cellpadding="0" cellspacing="0" class="tbl_data">
                                <tr class="tbl_header">
                                    <td><strong>Open Date</strong></td>
                                    <td><strong>Close Date</strong></td>
                                </tr>
                                <tr>
                                    <td colspan="2">No records available.</td>
                                </tr>
                            </table>
                        </EmptyDataTemplate>
                    </asp:ListView>
                </div>
            </div>
            <div class="clearfix"></div>

            <asp:ListView ID="lvContacts" runat="server">
                <LayoutTemplate>
                    <table border="0" cellpadding="0" cellspacing="0" class="tbl_data">
                        <tr class="tbl_header">
                            <td><strong>Contact name</strong></td>
                            <td><strong>Contact type</strong></td>
                            <td><strong>Title</strong></td>
                            <td><strong>Email</strong></td>
                            <td><strong>Work phone</strong></td>
                            <td><strong>Fax</strong></td>
                        </tr>
                        <div id="itemPlaceholder" runat="server" />
                    </table>
                </LayoutTemplate>
                <ItemTemplate ><tr><td><%# Eval("contactName") %></td><td><%# Eval("contactType") %></td><td><%# Eval("title") %></td><td><%# Eval("email") %></td><td><%# Eval("telephone") %></td><td><%# Eval("fax") %></td></tr></ItemTemplate>
                <EmptyDataTemplate>
                        No records available.
                </EmptyDataTemplate>
            </asp:ListView>
        </div>
    </div>
     <div id="fragment-3">       
        <asp:ScriptManager ID="toolkitScriptMaster" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="upNote" runat="server">
                            <ContentTemplate>    

        <div style="width:940px;margin:0 auto;" class="clearfix">
            <asp:ListView ID="lvNotes" runat="server">
                <LayoutTemplate>
                    <table border="0" cellpadding="0" cellspacing="0" class="tbl_data_notes">
                        <div id="itemPlaceholder" runat="server" />
                    </table>
                </LayoutTemplate>
                <ItemTemplate><tr><td style="padding:1.25em 0;"><p style="margin-bottom:0.5em;"><strong><%# Eval("lastModifiedBy") %></strong> on <em><%#String.Format("{0:g}", Eval("creationDate"))%></em></p><%# Eval("noteBody") %> </td></tr></ItemTemplate>
                <EmptyDataTemplate>
                        No notes available.
                </EmptyDataTemplate>
            </asp:ListView>
        </div>
        <div style="width:940px;margin:2em auto;" id="noteForm" class="clearfix">
			
				<div class="form_fields clearfix">
					<div class="form_label"><label>Note</label></div>
					<div class="form_input">
                        <asp:TextBox ID="tbNote" TextMode="MultiLine" runat="server" Length="1000"></asp:TextBox>
                        <p class="chars_remaining">Characters remaining: 1000</p>
                    </div>
                     <asp:RequiredFieldValidator ID="rfvNote" runat="server" ControlToValidate="tbNote" ErrorMessage="Note is a required field." Display="Dynamic" ValidationGroup="vgNote" />
				</div>
			
			
            <div class="clearboth"></div>
            <div class="update_btn_bar">
                <asp:Button ID="btnNoteSubmit" runat="server" Text="Add note" OnClick="btnNoteSubmit_onClick" CssClass="update_btn" ValidationGroup="vgNote" /> 
            </div>              
        </div>
         </ContentTemplate>
        </asp:UpdatePanel>

    </div>

</div>
<div class="submit_btn_bar clearfix">
    <asp:Button ID="btnSubmit" runat="server" OnClick="btnSubmit_OnClick" Text="Save" CssClass="submit_btn" />
</div>
</asp:Content> 
