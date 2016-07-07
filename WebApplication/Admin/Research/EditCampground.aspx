<%@ Page Language="C#" MasterPageFile="~/research.master" AutoEventWireup="true" CodeBehind="EditCampground.aspx.cs" Inherits="WebApplication.Admin.Research.EditCampground" %>

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
        //var errPercentages = "Sum of Visitor percentages must equal 100%";
        var errOpenDays = "Open days must be less than or equal to number of days in the month";
        var errSeasonalUnitsSold = "Seasonal units sold must be less than or equal to the available seasonal units";
        var errShortTermUnitsSold = "Short-term units sold must be less than or equal to the available short-term units";
        var errSeasonalUnitsSoldReq = "Seasonal units sold is a required field";
        var errShortTermUnitsSoldReq = "Short-term units sold is a required field";
        var errTotalGuestsReq = "Total guests is a required field";
        var errTotalGuests = "Total guests must be greater than or equal to the short term units sold";
        var errTotalUnitTypes = "Total of tents, rvs, and cabins must be less than or equal to the units sold";

        var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

        $(document).ready(function () {
            $("[id*=mn_bulkEdit]").addClass("current");
            InitializeEventBindings();

            $("[id*=lnkDeleteMonth]").click(function () {
                var theMonth = $(this).attr("theMonth");
                DeleteResearchRow(theMonth);
                return false;
            });
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
                url: "EditCampground.aspx/DeleteResearchRow",
                data: dataString,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var x = msg.d;
                    
                    deletedRow.find("[id*=tbOpenDays]").val(x.openDays);
                    deletedRow.find("[id*=tbAvailableSeasonal]").val(x.seasonalUnits);
                    deletedRow.find("[id*=tbAvailableShortTerm]").val(x.shortTermUnits);

                    deletedRow.find("[id*=tdAvailableSeasonalMonth]").html(Number(x.seasonalUnits) * Number(x.openDays));
                    deletedRow.find("[id*=tdAvailableShortTermMonth]").html(Number(x.shortTermUnits) * Number(x.openDays));
                    deletedRow.find("[id*=tdAvailableUnitsMonth]").html((Number(x.shortTermUnits) + Number(x.seasonalUnits)) * Number(x.openDays));

                    deletedRow.find("[id*=tbSeasonalUnitsSold]").val('');
                    deletedRow.find("[id*=tbShortTermUnitsSold]").val('');
                    deletedRow.find("[id*=tbTotalGuests]").val('');

                    deletedRow.find("[id*=tdSeasonalTotalUnits]").html('');
                    deletedRow.find("[id*=tdTotalUnitsSold]").html('');
                    
                    deletedRow.find("[id*=tbTents]").val('');
                    deletedRow.find("[id*=tbRvs]").val('');
                    deletedRow.find("[id*=tbCabins]").val('');

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

             $('#tblData td:nth-child(29)').hide();
            // $('#tblData td:nth-child(14)').hide();

            $("[id*=tbNoteReminderDate]").datepicker({ dateFormat: 'dd-mm-yy' });
            $("[id*=tbNoteReminderDate]").addClass("readOnly");

            $("#cbDisplayClassRatingInputs").click(function () {
                $('#tblData td:nth-child(29)').toggle(this.checked);
            });

            var onEditCallback = function (remaining) {
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
            $("[id*=tbAvailableSeasonal]").addClass("validateThis numberOnly");
            $("[id*=tbAvailableShortTerm]").addClass("validateThis numberOnly");
            $("[id*=tbSeasonalUnitsSold]").addClass("validateThis numberOnly");
            $("[id*=tbShortTermUnitsSold]").addClass("validateThis numberOnly");
            $("[id*=tbTotalGuests]").addClass("validateThis numberOnly");

            $("[id*=tbTentsNs]").addClass("validateThis numberOnly");
            $("[id*=tbTentsCan]").addClass("validateThis numberOnly");
            $("[id*=tbTentsUs]").addClass("validateThis numberOnly");
            $("[id*=tbTentsInt]").addClass("validateThis numberOnly");

            $("[id*=tbRvsNs]").addClass("validateThis numberOnly");
            $("[id*=tbRvsCan]").addClass("validateThis numberOnly");
            $("[id*=tbRvsUs]").addClass("validateThis numberOnly");
            $("[id*=tbRvsInt]").addClass("validateThis numberOnly");

            $("[id*=tbCabinsNs]").addClass("validateThis numberOnly");
            $("[id*=tbCabinsCan]").addClass("validateThis numberOnly");
            $("[id*=tbCabinsUs]").addClass("validateThis numberOnly");
            $("[id*=tbCabinsInt]").addClass("validateThis numberOnly");
            
            //$("[id*=ddlResearchClass]").addClass("validateThis");
            //$("[id*=ddlClassRating]").addClass("validateThis");

            $("[id*=hdnPreviouslySaved]").filter("[value='0']").each(function () {
                var parentRow = $(this).closest('tr');
                if (parentRow.find("[id*=tbOpenDays]").val() == "0" && parentRow.find("[id*=tbSeasonalUnitsSold]").val() == "0" && parentRow.find("[id*=tbShortTermUnitsSold]").val() == "0") {
                    parentRow.removeClass("unsavedRow").addClass("validRow");
                }
            });

//            $("#cbDisplayClassRatingInputs").click(function () {
//                //                $('#tblData td:nth-child(13)').hide();
//                //                $('#tblData td:nth-child(14)').hide();
//                $('#tblData td:nth-child(13)').toggle(this.checked);
//                $('#tblData td:nth-child(14)').toggle(this.checked);
//            });

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
            var seasonalUnitsPerDay = parentRow.find("[id*=tbAvailableSeasonal]").val();
            var shortTermUnitsPerDay = parentRow.find("[id*=tbAvailableShortTerm]").val();

            var seasonalUnitsPerMonth = Number(seasonalUnitsPerDay) * Number(openDays);
            var shortTermUnitsPerMonth = Number(shortTermUnitsPerDay) * Number(openDays);

            var seasonalUnitsSold = parentRow.find("[id*=tbSeasonalUnitsSold]").val();
            var shortTermUnitsSold = parentRow.find("[id*=tbShortTermUnitsSold]").val();
            var totalGuests = parentRow.find("[id*=tbTotalGuests]").val();

            var seasonalUnitsSoldPerMonth = Number(seasonalUnitsSold) * openDays;
            var totalUnitsSoldPerMonth = Number(shortTermUnitsSold) + seasonalUnitsSoldPerMonth;

            parentRow.find("[id*=tdAvailableSeasonalMonth]").html(seasonalUnitsPerMonth);
            parentRow.find("[id*=tdAvailableShortTermMonth]").html(shortTermUnitsPerMonth);
            parentRow.find("[id*=tdAvailableUnitsMonth]").html(shortTermUnitsPerMonth + seasonalUnitsPerMonth);
            
            parentRow.find("[id*=tdSeasonalTotalUnits]").html(seasonalUnitsSoldPerMonth);
            parentRow.find("[id*=tdTotalUnitsSold]").html(totalUnitsSoldPerMonth);

            var totalTents = Number(parentRow.find("[id*=tbTentsNs]").val()) + Number(parentRow.find("[id*=tbTentsCan]").val()) + Number(parentRow.find("[id*=tbTentsUs]").val()) + Number(parentRow.find("[id*=tbTentsInt]").val());
            var totalRvs = Number(parentRow.find("[id*=tbRvsNs]").val()) + Number(parentRow.find("[id*=tbRvsCan]").val()) + Number(parentRow.find("[id*=tbRvsUs]").val()) + Number(parentRow.find("[id*=tbRvsInt]").val());
            var totalCabins = Number(parentRow.find("[id*=tbCabinsNs]").val()) + Number(parentRow.find("[id*=tbCabinsCan]").val()) + Number(parentRow.find("[id*=tbCabinsUs]").val()) + Number(parentRow.find("[id*=tbCabinsInt]").val());

            parentRow.find("[id*=tdTentsTotal]").html(totalTents);
            parentRow.find("[id*=tdRvsTotal]").html(totalRvs);
            parentRow.find("[id*=tdCabinsTotal]").html(totalCabins);

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

//            //percentages must sum to under 100
//            if ((vacation != "" || business != "" || convention != "" || motor != "" || other != "") && ((Number(vacation) + Number(business) + Number(convention) + Number(motor) + Number(other)) != 100)) {
//                isValid = false;
//                //errMsg += errPercentages + "<BR/>";
//                parentRow.find("[id*=tbVacationGuests]").addClass("hasError");
//                parentRow.find("[id*=tbVacationGuests]").qtip({
//                    content: errPercentages
//                });

//                parentRow.find("[id*=tbBusinessGuests]").addClass("hasError");
//                parentRow.find("[id*=tbBusinessGuests]").qtip({
//                    content: errPercentages
//                });

//                parentRow.find("[id*=tbMotorcoachGuests]").addClass("hasError");
//                parentRow.find("[id*=tbMotorcoachGuests]").qtip({
//                    content: errPercentages
//                });

//                parentRow.find("[id*=tbConventionGuests]").addClass("hasError");
//                parentRow.find("[id*=tbConventionGuests]").qtip({
//                    content: errPercentages
//                });

//                parentRow.find("[id*=tbOtherGuests]").addClass("hasError");
//                parentRow.find("[id*=tbOtherGuests]").qtip({
//                    content: errPercentages
//                });


//            }

            if (seasonalUnitsSold.length == 0) {
                isValid = false;
                //errMsg += errUnitsSoldReq + "<BR/>";

                parentRow.find("[id*=tbSeasonalUnitsSold]").addClass("hasError");
                parentRow.find("[id*=tbSeasonalUnitsSold]").qtip({
                    content: errSeasonalUnitsSoldReq
                });
            }

            if (shortTermUnitsSold.length == 0) {
                isValid = false;
                //errMsg += errUnitsSoldReq + "<BR/>";

                parentRow.find("[id*=tbShortTermUnitsSold]").addClass("hasError");
                parentRow.find("[id*=tbShortTermUnitsSold]").qtip({
                    content: errShortTermUnitsSoldReq
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

            //seasonal units sold for month needs to be less than the available seasonal units per day
            if (Number(seasonalUnitsSold) > Number(seasonalUnitsPerDay)) {
                //  alert(unitsSold + ":::" + unitsPerMonth);
                isValid = false;
                //errMsg += errUnitsSold + "<BR/>";

                parentRow.find("[id*=tbSeasonalUnitsSold]").addClass("hasError");
                parentRow.find("[id*=tbSeasonalUnitsSold]").qtip({
                    content: errSeasonalUnitsSold
                });

            }

            //short term units sold for month needs to be less than the available short term units per month
            if (Number(shortTermUnitsSold) > Number(shortTermUnitsPerMonth)) {
                //  alert(unitsSold + ":::" + unitsPerMonth);
                isValid = false;
                //errMsg += errUnitsSold + "<BR/>";

                parentRow.find("[id*=tbShortTermUnitsSold]").addClass("hasError");
                parentRow.find("[id*=tbShortTermUnitsSold]").qtip({
                    content: errShortTermUnitsSold
                });

            }

            //total guests must be greater than the units sold
            if (totalGuests.length > 0 && (Number(totalGuests) < Number(shortTermUnitsSold))) {
                //  alert(unitsSold + ":::" + unitsPerMonth);
                isValid = false;
                //errMsg += errTotalGuests + "<BR/>";

                parentRow.find("[id*=tbTotalGuests]").addClass("hasError");
                parentRow.find("[id*=tbTotalGuests]").qtip({
                    content: errTotalGuests
                });

            }

            //total guests must be greater than the units sold
            if ((totalCabins + totalTents + totalRvs) > totalUnitsSoldPerMonth) {
                //  alert(unitsSold + ":::" + unitsPerMonth);
                isValid = false;
                //errMsg += errTotalGuests + "<BR/>";

                parentRow.find("[id*=tbTents]").addClass("hasError");
                parentRow.find("[id*=tbRvs]").addClass("hasError");
                parentRow.find("[id*=tbCabins]").addClass("hasError");
                
                parentRow.find("[id*=tbTents]").qtip({
                    content: errTotalUnitTypes
                });

                parentRow.find("[id*=tbRvs]").qtip({
                    content: errTotalUnitTypes 
                });

                parentRow.find("[id*=tbCabins]").qtip({
                    content: errTotalUnitTypes
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
            <td class="form_input"><input type="checkbox" id="cbDisplayClassRatingInputs"/></td>
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
            <td colspan="2" class="headerGroup"><strong>Daily Availability</strong><div></div></td>
            <td colspan="3" class="headerGroup"><strong>Monthly Availability</strong><div></div></td>
            <td colspan="3" class="headerGroup"><strong>Sales</strong><div></div></td>
            <td colspan="2" class="headerGroup"><strong>Totals</strong><div></div></td>
            <td colspan="5" class="headerGroup"><strong>Tents</strong><div></div></td>
            <td colspan="5" class="headerGroup"><strong>RVs</strong><div></div></td>
            <td colspan="5" class="headerGroup"><strong>Cabins</strong><div></div></td>
            <td></td>
            <td></td>
        </tr>
        <tr class="tbl_header">
            <td><strong>Year</strong></td>
            <td><strong>Month</strong></td>
            <td><strong>Open<br />Days</strong></td>
            <td><strong>Seasnl</strong></td>
            <td><strong>Short<br />term</strong></td>
            <td><strong>Seasnl</strong></td>
            <td><strong>Short<br />term</strong></td>
            <td><strong>Total</strong></td>
            
            <td><strong>Seasnl</strong></td>
            <td><strong>Short<br />term</strong></td>
            <td><strong>Guests</strong></td>

            <td><strong>Seasnl<br />Nights</strong></td>
            <td><strong>Total<br />Nights</strong></td>
            
            <td><strong>NS</strong></td>
            <td><strong>Can</strong></td>
            <td><strong>US</strong></td>
            <td><strong>Int</strong></td>
            <td><strong>Tot</strong></td>
            <td><strong>NS</strong></td>
            <td><strong>Can</strong></td>
            <td><strong>US</strong></td>
            <td><strong>Int</strong></td>
            <td><strong>Tot</strong></td>
            <td><strong>NS</strong></td>
            <td><strong>Can</strong></td>
            <td><strong>US</strong></td>
            <td><strong>Int</strong></td>
            <td><strong>Tot</strong></td>
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
                <asp:TextBox ID="tbOpenDays1" runat="server" Width="20" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableSeasonal1" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableShortTerm1" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
             <td id="tdAvailableSeasonalMonth1">
                <asp:Literal ID="litAvailableSeasonalMonth1" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableShortTermMonth1">
                <asp:Literal ID="litAvailableShortTermMonth1" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableUnitsMonth1">
                <asp:Literal ID="litAvailableUnitsMonth1" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbSeasonalUnitsSold1" runat="server" Width="45" MaxLength="3"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbShortTermUnitsSold1" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests1" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td id="tdSeasonalTotalUnits1">
                <asp:Literal ID="litSeasonalTotalUnits1" runat="server"></asp:Literal>
            </td>
            <td id="tdTotalUnitsSold1">
                <asp:Literal ID="litTotalUnitsSold1" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbTentsNs1" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsCan1" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsUs1" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsInt1" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdTentsTotal1">
                <asp:Literal ID="litTentsTotal1" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbRvsNs1" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsCan1" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsUs1" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsInt1" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdRvsTotal1">
                <asp:Literal ID="litRvsTotal1" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbCabinsNs1" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsCan1" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsUs1" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsInt1" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdCabinsTotal1">
                <asp:Literal ID="litCabinsTotal1" runat="server"></asp:Literal>
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
                <asp:HiddenField runat="server" ID="hdnIsEnabled2" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth2" Value="2" />
            </td>
            <td id="tdMonthName">
                February
            </td>
            <td>
                <asp:TextBox ID="tbOpenDays2" runat="server" Width="20" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableSeasonal2" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableShortTerm2" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
             <td id="tdAvailableSeasonalMonth2">
                <asp:Literal ID="litAvailableSeasonalMonth2" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableShortTermMonth2">
                <asp:Literal ID="litAvailableShortTermMonth2" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableUnitsMonth2">
                <asp:Literal ID="litAvailableUnitsMonth2" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbSeasonalUnitsSold2" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbShortTermUnitsSold2" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests2" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td id="tdSeasonalTotalUnits2">
                <asp:Literal ID="litSeasonalTotalUnits2" runat="server"></asp:Literal>
            </td>
            <td id="tdTotalUnitsSold2">
                <asp:Literal ID="litTotalUnitsSold2" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbTentsNs2" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsCan2" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsUs2" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsInt2" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdTentsTotal1">
                <asp:Literal ID="litTentsTotal2" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbRvsNs2" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsCan2" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsUs2" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsInt2" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdRvsTotal1">
                <asp:Literal ID="litRvsTotal2" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbCabinsNs2" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsCan2" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsUs2" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsInt2" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdCabinsTotal1">
                <asp:Literal ID="litCabinsTotal2" runat="server"></asp:Literal>
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
                <asp:HiddenField runat="server" ID="hdnIsEnabled3" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth3" Value="3" />
            </td>
            <td id="tdMonthName">
                March
            </td>
            <td>
                <asp:TextBox ID="tbOpenDays3" runat="server" Width="20" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableSeasonal3" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableShortTerm3" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
             <td id="tdAvailableSeasonalMonth3">
                <asp:Literal ID="litAvailableSeasonalMonth3" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableShortTermMonth3">
                <asp:Literal ID="litAvailableShortTermMonth3" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableUnitsMonth3">
                <asp:Literal ID="litAvailableUnitsMonth3" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbSeasonalUnitsSold3" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbShortTermUnitsSold3" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests3" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td id="tdSeasonalTotalUnits3">
                <asp:Literal ID="litSeasonalTotalUnits3" runat="server"></asp:Literal>
            </td>
            <td id="tdTotalUnitsSold3">
                <asp:Literal ID="litTotalUnitsSold3" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbTentsNs3" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsCan3" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsUs3" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsInt3" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdTentsTotal3">
                <asp:Literal ID="litTentsTotal3" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbRvsNs3" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsCan3" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsUs3" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsInt3" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdRvsTotal3">
                <asp:Literal ID="litRvsTotal3" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbCabinsNs3" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsCan3" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsUs3" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsInt3" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdCabinsTotal3">
                <asp:Literal ID="litCabinsTotal3" runat="server"></asp:Literal>
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
                <asp:HiddenField runat="server" ID="hdnIsEnabled4" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth4" Value="4" />
            </td>
            <td id="tdMonthName">
                April
            </td>
            <td>
                <asp:TextBox ID="tbOpenDays4" runat="server" Width="20" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableSeasonal4" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableShortTerm4" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
             <td id="tdAvailableSeasonalMonth4">
                <asp:Literal ID="litAvailableSeasonalMonth4" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableShortTermMonth4">
                <asp:Literal ID="litAvailableShortTermMonth4" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableUnitsMonth4">
                <asp:Literal ID="litAvailableUnitsMonth4" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbSeasonalUnitsSold4" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbShortTermUnitsSold4" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests4" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td id="tdSeasonalTotalUnits4">
                <asp:Literal ID="litSeasonalTotalUnits4" runat="server"></asp:Literal>
            </td>
            <td id="tdTotalUnitsSold4">
                <asp:Literal ID="litTotalUnitsSold4" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbTentsNs4" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsCan4" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsUs4" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsInt4" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdTentsTotal4">
                <asp:Literal ID="litTentsTotal4" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbRvsNs4" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsCan4" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsUs4" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsInt4" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdRvsTotal4">
                <asp:Literal ID="litRvsTotal4" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbCabinsNs4" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsCan4" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsUs4" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsInt4" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdCabinsTotal4">
                <asp:Literal ID="litCabinsTotal4" runat="server"></asp:Literal>
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
                <asp:HiddenField runat="server" ID="hdnIsEnabled5" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth5" Value="5" />
            </td>
            <td id="tdMonthName">
                May
            </td>
            <td>
                <asp:TextBox ID="tbOpenDays5" runat="server" Width="20" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableSeasonal5" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableShortTerm5" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
             <td id="tdAvailableSeasonalMonth5">
                <asp:Literal ID="litAvailableSeasonalMonth5" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableShortTermMonth5">
                <asp:Literal ID="litAvailableShortTermMonth5" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableUnitsMonth5">
                <asp:Literal ID="litAvailableUnitsMonth5" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbSeasonalUnitsSold5" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbShortTermUnitsSold5" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests5" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td id="tdSeasonalTotalUnits5">
                <asp:Literal ID="litSeasonalTotalUnits5" runat="server"></asp:Literal>
            </td>
            <td id="tdTotalUnitsSold5">
                <asp:Literal ID="litTotalUnitsSold5" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbTentsNs5" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsCan5" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsUs5" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsInt5" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdTentsTotal5">
                <asp:Literal ID="litTentsTotal5" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbRvsNs5" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsCan5" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsUs5" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsInt5" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdRvsTotal5">
                <asp:Literal ID="litRvsTotal5" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbCabinsNs5" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsCan5" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsUs5" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsInt5" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdCabinsTotal5">
                <asp:Literal ID="litCabinsTotal5" runat="server"></asp:Literal>
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
                <asp:HiddenField runat="server" ID="hdnIsEnabled6" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth6" Value="6" />
            </td>
            <td id="tdMonthName">
                June
            </td>
            <td>
                <asp:TextBox ID="tbOpenDays6" runat="server" Width="20" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableSeasonal6" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableShortTerm6" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
             <td id="tdAvailableSeasonalMonth6">
                <asp:Literal ID="litAvailableSeasonalMonth6" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableShortTermMonth6">
                <asp:Literal ID="litAvailableShortTermMonth6" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableUnitsMonth6">
                <asp:Literal ID="litAvailableUnitsMonth6" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbSeasonalUnitsSold6" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbShortTermUnitsSold6" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests6" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td id="tdSeasonalTotalUnits6">
                <asp:Literal ID="litSeasonalTotalUnits6" runat="server"></asp:Literal>
            </td>
            <td id="tdTotalUnitsSold6">
                <asp:Literal ID="litTotalUnitsSold6" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbTentsNs6" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsCan6" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsUs6" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsInt6" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdTentsTotal6">
                <asp:Literal ID="litTentsTotal6" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbRvsNs6" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsCan6" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsUs6" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsInt6" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdRvsTotal6">
                <asp:Literal ID="litRvsTotal6" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbCabinsNs6" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsCan6" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsUs6" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsInt6" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdCabinsTotal6">
                <asp:Literal ID="litCabinsTotal6" runat="server"></asp:Literal>
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
                <asp:HiddenField runat="server" ID="hdnIsEnabled7" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth7" Value="7" />
            </td>
            <td id="tdMonthName">
                July
            </td>
            <td>
                <asp:TextBox ID="tbOpenDays7" runat="server" Width="20" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableSeasonal7" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableShortTerm7" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
             <td id="tdAvailableSeasonalMonth7">
                <asp:Literal ID="litAvailableSeasonalMonth7" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableShortTermMonth7">
                <asp:Literal ID="litAvailableShortTermMonth7" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableUnitsMonth7">
                <asp:Literal ID="litAvailableUnitsMonth7" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbSeasonalUnitsSold7" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbShortTermUnitsSold7" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests7" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td id="tdSeasonalTotalUnits7">
                <asp:Literal ID="litSeasonalTotalUnits7" runat="server"></asp:Literal>
            </td>
            <td id="tdTotalUnitsSold7">
                <asp:Literal ID="litTotalUnitsSold7" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbTentsNs7" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsCan7" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsUs7" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsInt7" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdTentsTotal7">
                <asp:Literal ID="litTentsTotal7" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbRvsNs7" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsCan7" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsUs7" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsInt7" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdRvsTotal7">
                <asp:Literal ID="litRvsTotal7" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbCabinsNs7" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsCan7" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsUs7" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsInt7" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdCabinsTotal7">
                <asp:Literal ID="litCabinsTotal7" runat="server"></asp:Literal>
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
                <asp:HiddenField runat="server" ID="hdnIsEnabled8" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth8" Value="8" />
            </td>
            <td id="tdMonthName">
                August
            </td>
            <td>
                <asp:TextBox ID="tbOpenDays8" runat="server" Width="20" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableSeasonal8" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableShortTerm8" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
             <td id="tdAvailableSeasonalMonth8">
                <asp:Literal ID="litAvailableSeasonalMonth8" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableShortTermMonth8">
                <asp:Literal ID="litAvailableShortTermMonth8" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableUnitsMonth8">
                <asp:Literal ID="litAvailableUnitsMonth8" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbSeasonalUnitsSold8" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbShortTermUnitsSold8" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests8" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td id="tdSeasonalTotalUnits8">
                <asp:Literal ID="litSeasonalTotalUnits8" runat="server"></asp:Literal>
            </td>
            <td id="tdTotalUnitsSold8">
                <asp:Literal ID="litTotalUnitsSold8" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbTentsNs8" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsCan8" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsUs8" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsInt8" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdTentsTotal8">
                <asp:Literal ID="litTentsTotal8" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbRvsNs8" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsCan8" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsUs8" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsInt8" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdRvsTotal1">
                <asp:Literal ID="litRvsTotal8" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbCabinsNs8" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsCan8" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsUs8" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsInt8" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdCabinsTotal8">
                <asp:Literal ID="litCabinsTotal8" runat="server"></asp:Literal>
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
                <asp:HiddenField runat="server" ID="hdnIsEnabled9" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth9" Value="9" />
            </td>
            <td id="tdMonthName">
                September
            </td>
            <td>
                <asp:TextBox ID="tbOpenDays9" runat="server" Width="20" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableSeasonal9" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableShortTerm9" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
             <td id="tdAvailableSeasonalMonth9">
                <asp:Literal ID="litAvailableSeasonalMonth9" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableShortTermMonth9">
                <asp:Literal ID="litAvailableShortTermMonth9" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableUnitsMonth9">
                <asp:Literal ID="litAvailableUnitsMonth9" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbSeasonalUnitsSold9" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbShortTermUnitsSold9" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests9" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td id="tdSeasonalTotalUnits9">
                <asp:Literal ID="litSeasonalTotalUnits9" runat="server"></asp:Literal>
            </td>
            <td id="tdTotalUnitsSold9">
                <asp:Literal ID="litTotalUnitsSold9" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbTentsNs9" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsCan9" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsUs9" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsInt9" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdTentsTotal9">
                <asp:Literal ID="litTentsTotal9" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbRvsNs9" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsCan9" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsUs9" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsInt9" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdRvsTotal9">
                <asp:Literal ID="litRvsTotal9" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbCabinsNs9" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsCan9" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsUs9" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsInt9" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdCabinsTotal9">
                <asp:Literal ID="litCabinsTotal9" runat="server"></asp:Literal>
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
                <asp:HiddenField runat="server" ID="hdnIsEnabled10" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth10" Value="1" />
            </td>
            <td id="tdMonthName">
                October
            </td>
            <td>
                <asp:TextBox ID="tbOpenDays10" runat="server" Width="20" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableSeasonal10" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableShortTerm10" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
             <td id="tdAvailableSeasonalMonth10">
                <asp:Literal ID="litAvailableSeasonalMonth10" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableShortTermMonth10">
                <asp:Literal ID="litAvailableShortTermMonth10" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableUnitsMonth10">
                <asp:Literal ID="litAvailableUnitsMonth10" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbSeasonalUnitsSold10" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbShortTermUnitsSold10" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests10" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td id="tdSeasonalTotalUnits10">
                <asp:Literal ID="litSeasonalTotalUnits10" runat="server"></asp:Literal>
            </td>
            <td id="tdTotalUnitsSold10">
                <asp:Literal ID="litTotalUnitsSold10" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbTentsNs10" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsCan10" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsUs10" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsInt10" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdTentsTotal10">
                <asp:Literal ID="litTentsTotal10" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbRvsNs10" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsCan10" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsUs10" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsInt10" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdRvsTotal10">
                <asp:Literal ID="litRvsTotal10" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbCabinsNs10" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsCan10" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsUs10" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsInt10" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdCabinsTotal10">
                <asp:Literal ID="litCabinsTotal10" runat="server"></asp:Literal>
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
                <asp:HiddenField runat="server" ID="hdnIsEnabled11" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth11" Value="11" />
            </td>
            <td id="tdMonthName">
                November
            </td>
            <td>
                <asp:TextBox ID="tbOpenDays11" runat="server" Width="20" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableSeasonal11" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableShortTerm11" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
             <td id="tdAvailableSeasonalMonth11">
                <asp:Literal ID="litAvailableSeasonalMonth11" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableShortTermMonth11">
                <asp:Literal ID="litAvailableShortTermMonth11" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableUnitsMonth11">
                <asp:Literal ID="litAvailableUnitsMonth11" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbSeasonalUnitsSold11" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbShortTermUnitsSold11" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests11" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td id="tdSeasonalTotalUnits11">
                <asp:Literal ID="litSeasonalTotalUnits11" runat="server"></asp:Literal>
            </td>
            <td id="tdTotalUnitsSold11">
                <asp:Literal ID="litTotalUnitsSold11" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbTentsNs11" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsCan11" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsUs11" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsInt11" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdTentsTotal11">
                <asp:Literal ID="litTentsTotal11" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbRvsNs11" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsCan11" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsUs11" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsInt11" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdRvsTotal11">
                <asp:Literal ID="litRvsTotal11" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbCabinsNs11" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsCan11" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsUs11" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsInt11" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdCabinsTotal11">
                <asp:Literal ID="litCabinsTotal11" runat="server"></asp:Literal>
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
                <asp:HiddenField runat="server" ID="hdnIsEnabled12" Value="" />
                <asp:HiddenField runat="server" ID="hdnMonth12" Value="12" />
            </td>
            <td id="tdMonthName">
                December
            </td>
            <td>
                <asp:TextBox ID="tbOpenDays12" runat="server" Width="20" MaxLength="2"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableSeasonal12" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbAvailableShortTerm12" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
             <td id="tdAvailableSeasonalMonth12">
                <asp:Literal ID="litAvailableSeasonalMonth12" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableShortTermMonth12">
                <asp:Literal ID="litAvailableShortTermMonth12" runat="server"></asp:Literal>
            </td>
            <td id="tdAvailableUnitsMonth12">
                <asp:Literal ID="litAvailableUnitsMonth12" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbSeasonalUnitsSold12" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbShortTermUnitsSold12" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTotalGuests12" runat="server" Width="45" MaxLength="6"></asp:TextBox>
            </td>
            <td id="tdSeasonalTotalUnits12">
                <asp:Literal ID="litSeasonalTotalUnits12" runat="server"></asp:Literal>
            </td>
            <td id="tdTotalUnitsSold12">
                <asp:Literal ID="litTotalUnitsSold12" runat="server"></asp:Literal>
            </td>
            <td>
                <asp:TextBox ID="tbTentsNs12" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsCan12" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsUs12" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbTentsInt12" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdTentsTotal12">
                <asp:Literal ID="litTentsTotal12" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbRvsNs12" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsCan12" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsUs12" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbRvsInt12" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdRvsTotal12">
                <asp:Literal ID="litRvsTotal12" runat="server"></asp:Literal>
            </td>

            <td>
                <asp:TextBox ID="tbCabinsNs12" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsCan12" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsUs12" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="tbCabinsInt12" runat="server" Width="30" MaxLength="4"></asp:TextBox>
            </td>
            <td id="tdCabinsTotal12">
                <asp:Literal ID="litCabinsTotal12" runat="server"></asp:Literal>
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

