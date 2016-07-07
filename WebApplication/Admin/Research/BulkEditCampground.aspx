<%@ Page Language="C#" MasterPageFile="~/research.Master" AutoEventWireup="true" CodeBehind="BulkEditCampground.aspx.cs" Inherits="WebApplication.Admin.Research.BulkEditCampground" %>

<asp:Content ID="cHeadContent" ContentPlaceHolderID="cphHeadContent" Runat="Server"> 
    <link href="../../Styles/jquery.qtip.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/jquery.qtip.min.js" type="text/javascript"></script>
    <style type="text/css">
        input.hasError {border:2px solid #c10000;}
        tr.validRow {background-color:#CFD784;}
        tr.savedRow {background-color:#FFFFFF;}
        tr.unsavedRow {background-color:#fefcc2;}
        
    </style>
 <script type="text/javascript">
     //var colourSaved = "#99CC55";
     //var colourSaved = "#CFD784";
     var colourSaved = "#fefcc2";
     var colourValid = "#CFD784";
     //var colourInvalid = "#FFB060";
     var colourInvalid = "#EEB4B4";

     var errOpenDays = "Open days must be less than or equal to number of days in the month";
     var errSeasonalUnitsSold = "Seasonal units sold must be less than or equal to the available seasonal units";
     var errShortTermUnitsSold = "Short-term units sold must be less than or equal to the available short-term units";
     var errSeasonalUnitsSoldReq = "Seasonal units sold is a required field";
     var errShortTermUnitsSoldReq = "Short-term units sold is a required field";
     var errTotalGuestsReq = "Total guests is a required field";
     var errTotalGuests = "Total guests must be greater than or equal to the short term units sold";
     var errTotalUnitTypes = "Total of tents, rvs, and cabins must be less than or equal to the units sold";

     //style = "border:1px solid #c10000;"

     $(document).ready(function () {
         $("[id*=mn_bulkEdit]").addClass("current");
         $("[id*=ddlProductType]").attr("disabled", true);
         
         InitializeEventBindings();

         $('#tblBulkEditData tr:gt(1)').addClass("unsavedRow");
         $('#tblBulkEditData tr').filter("[previouslysaveddata='1']").removeClass("unsavedRow").addClass("savedRow");
         $('#tblBulkEditData tr').filter("[previouslysaveddata='1']").find(".lnkDeleteRow").show();
       
         $('#tblBulkEditData tr').filter("[previouslysaveddata='0']").each(function () {
             if ($(this).find("[id*=tbOpenDays]").val() == "0") {
                 $(this).removeClass("unsavedRow").addClass("validRow");
             }
         });

         $('a').not('.suppressWarning').click(function () {
             return NavigationConfirmation();
         });


         $("[id*=btnSearch]").click(function () {
             return NavigationConfirmation();
         });
     });

     function NavigationConfirmation() {
         if ($(".validRow").size() > 0) {
             var r = confirm("There are valid rows that have not yet been saved, are you sure you want to proceed? (all unsaved data will be lost)");
             return r;
         }
         return true;
     }


     function DeleteResearchRow(deletedRow) {
         
         if (!confirm("Are you sure you want to delete the " + deletedRow.find("[id*=lnkProduct]").text() + " data?")) {
             return false;
         }

         var year = $('[id*=ddlYear]').val();
         var month = $('[id*=ddlMonth]').val();
         var productId = deletedRow.find("[id*=hdnProductId]").val();
         
         var dataString = '{"productId":"' + productId + '", "year":"' + year + '","month":"' + month + '"}';

         $.ajax({
             type: "POST",
             url: "BulkEditCampground.aspx/DeleteResearchRow",
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

                 deletedRow.attr("previouslysaveddata", "0");
                 deletedRow.find(".lnkDeleteRow").hide();
             },
             error: function (xhr, status, error) {
                 // Display a generic error for now.
                 alert("AJAX Error!");
             }
         });
     }


     function ClearFormErrors() {
         $("[id*=dvError]").hide();
     }


     // Attach events
    function InitializeEventBindings() {
        $('#tblBulkEditData td:nth-child(29)').hide();

        $(".validateThis").change(function () {
            var changedInput = $(this);
            ValidateRow(changedInput);
        });

        $("#cbDisplayClassRatingInputs").click(function () {
            $('#tblBulkEditData td:nth-child(29)').toggle(this.checked);
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

        $(".lnkDeleteRow").click(function (event) {
            var row = $(this).closest('tr');
            DeleteResearchRow(row);
        });
        
        $("[id*=btnSave]").click(function () {
            if ($(".hasError").size() > 0) {
                var r = confirm("There are rows with errors, are you sure you want to proceed? (all data in rows with errors will be lost)");
                return r;
            }
            return true;
        });
    }

    function GetDaysInMonth(month,year) {
        return new Date(year, month, 0).getDate();
    }

    function ValidateRow(changedInput) {
        var isValid = true;
       
        var month = $("[id*=ddlMonth]").val();
        var year = $("[id*=ddlYear]").val();

        var parentRow = changedInput.closest('tr');

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

        //sum of tents, rvs, cabins must be less than or equal to the units sold
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
	
    <table cellpadding="0" cellspacing="0" border="0" class="researchProdInfo">
        <tr>
            <td class="form_label"><label>Product type</label></td>
            <td class="form_label"><label>Year</label></td>
            <td class="form_label"><label>Month</label></td>
            <td class="form_label"><label>Start from license #</label></td>
            <td class="form_label"></td>
        </tr>
        <tr>
            <td class="form_input"><asp:DropDownList ID="ddlProductType" runat="server"></asp:DropDownList></td>
            <td class="form_input"><asp:DropDownList ID="ddlYear" runat="server"></asp:DropDownList></td>
            <td class="form_input"><asp:DropDownList ID="ddlMonth" runat="server"></asp:DropDownList></td>
            <td class="form_input"><asp:TextBox ID="tbLicenseNumber" runat="server" Width="120" ></asp:TextBox></td>
            <td class="form_input">
                <asp:CheckBox ID="cbKeepSavedProducts" runat="server" Text=" Include recently saved products" /><br/>
                <input type="checkbox" id="cbDisplayClassRatingInputs" /> Display rating
            </td>
        </tr>
    </table>
    <div class="search_btn_bar clearfix">
        <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_OnClick" Text="Go" CssClass="submit_btn" />
	</div>

    <div class="submit_btn_bar clearfix">
		<asp:Button ID="btnSave1" runat="server" Text="Save" OnClick="btnSave_OnClick" CssClass="submit_btn" />
	</div>
     <asp:ListView ID="lvProducts" runat="server">
            <LayoutTemplate>
                <table id="tblBulkEditData" border="0" cellpadding="0" cellspacing="0" class="tbl_data">
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
                            <td><strong>License #</strong></td>
                            <td><strong>Product&nbsp;name</strong></td>
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
                        <div id="itemPlaceholder" runat="server" />
                    </table>
            </LayoutTemplate>
            <ItemTemplate>
                <tr class="tbl_datarow" previouslysaveddata='<%# Eval("PreviouslySavedData") %>'>
                    <td id="tdLicenseNumber">
                        <asp:Literal ID="litLicenseNumber" runat="server" Text='<%# Eval("licenseNumber") %>'></asp:Literal>
                    </td>
                    <td>
                        <asp:HiddenField ID="hdnProductId" runat="server" Value='<%# Eval("productId") %>' />
                        <a id="lnkProduct" href='EditCampground.aspx?productId=<%# Eval("productId") %>&year=<%# Eval("year") %>'><%# Eval("productName") %></a>
                    </td>
                    <td>
                        <asp:TextBox ID="tbOpenDays" runat="server" class="validateThis numberOnly" Text='<%# Eval("openDays") %>' Width="20" MaxLength="2"></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox ID="tbAvailableSeasonal" runat="server" class="validateThis numberOnly" Text='<%# Eval("availableSeasonal") %>' Width="30" MaxLength="4"></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox ID="tbAvailableShortTerm" runat="server" class="validateThis numberOnly" Text='<%# Eval("availableShortTerm") %>' Width="30" MaxLength="4"></asp:TextBox>
                    </td>
                    <td id="tdAvailableSeasonalMonth"><%# Eval("availableSeasonalMonth") %> </td>
                    <td id="tdAvailableShortTermMonth"><%# Eval("availableShortTermMonth") %> </td>
                    <td id="tdAvailableUnitsMonth"><%# Eval("availableUnitsMonth") %> </td>
                    <td>
                        <asp:TextBox ID="tbSeasonalUnitsSold" runat="server" class="validateThis numberOnly" Text='<%# Eval("seasonalUnitsSold") %>' Width="45" MaxLength="3" ></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox ID="tbShortTermUnitsSold" runat="server" class="validateThis numberOnly" Text='<%# Eval("shortTermUnitsSold") %>' Width="45" MaxLength="3" ></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox ID="tbTotalGuests" runat="server" class="validateThis numberOnly" Text='<%# Eval("totalGuests") %>' Width="45" MaxLength="6"></asp:TextBox>
                    </td>
                    <td id="tdSeasonalTotalUnits"><%# Eval("totalSeasonalUnits") %> </td>
                    <td id="tdTotalUnitsSold"><%# Eval("totalUnitsSold") %> </td>
                    <td>
                        <asp:TextBox ID="tbTentsNs" runat="server" class="validateThis numberOnly" Text='<%# Eval("tentsNs") %>' Width="30" MaxLength="4"></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox ID="tbTentsCan" runat="server" class="validateThis numberOnly" Text='<%# Eval("tentsCan") %>' Width="30" MaxLength="4"></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox ID="tbTentsUs" runat="server" class="validateThis numberOnly" Text='<%# Eval("tentsUs") %>' Width="30" MaxLength="4"></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox ID="tbTentsInt" runat="server" class="validateThis numberOnly" Text='<%# Eval("tentsInt") %>' Width="30" MaxLength="4"></asp:TextBox>
                    </td>
                    <td id="tdTentsTotal"><%# Eval("tentsTotal") %> </td>

                    <td>
                        <asp:TextBox ID="tbRvsNs" runat="server" class="validateThis numberOnly" Text='<%# Eval("rvsNs") %>' Width="30" MaxLength="4"></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox ID="tbRvsCan" runat="server" class="validateThis numberOnly" Text='<%# Eval("rvsCan") %>' Width="30" MaxLength="4"></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox ID="tbRvsUs" runat="server" class="validateThis numberOnly" Text='<%# Eval("rvsUs") %>' Width="30" MaxLength="4"></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox ID="tbRvsInt" runat="server" class="validateThis numberOnly" Text='<%# Eval("rvsInt") %>' Width="30" MaxLength="4"></asp:TextBox>
                    </td>
                    <td id="tdRvsTotal"><%# Eval("rvsTotal") %> </td>
                    
                    <td>
                        <asp:TextBox ID="tbCabinsNs" runat="server" class="validateThis numberOnly" Text='<%# Eval("cabinsNs") %>' Width="30" MaxLength="4"></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox ID="tbCabinsCan" runat="server" class="validateThis numberOnly" Text='<%# Eval("cabinsCan") %>' Width="30" MaxLength="4"></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox ID="tbCabinsUs" runat="server" class="validateThis numberOnly" Text='<%# Eval("cabinsUs") %>' Width="30" MaxLength="4"></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox ID="tbCabinsInt" runat="server" class="validateThis numberOnly" Text='<%# Eval("cabinsInt") %>' Width="30" MaxLength="4"></asp:TextBox>
                    </td>
                    <td id="tdCabinsTotal"><%# Eval("cabinsTotal") %> </td>
                    <td>
                        <asp:DropDownList ID="ddlClassRating" runat="server" SelectedValue='<%# Eval("StarClassRating") %>'>
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
                    <td><a class="lnkDeleteRow suppressWarning" style="display:none;">Delete</a></td>
                </tr>
            </ItemTemplate>
            <EmptyDataTemplate>
                            <table border="0" cellpadding="0" cellspacing="0" class="tbl_data">
                                <tr>
                                    <td colspan="2">There are no accommodations requiring data entry for the selected year and month.</td>
                                </tr>
                            </table>
                        </EmptyDataTemplate>
        </asp:ListView>
    
    <div class="submit_btn_bar clearfix">
		<asp:Button ID="btnSave2" runat="server" Text="Save" OnClick="btnSave_OnClick" CssClass="submit_btn" />
	</div>
    <div class="pager_nav clearfix">
            <asp:DataPager runat="server" ID="dpProductPager" PageSize="20" PagedControlID="lvProducts">
                <Fields>
                  <asp:TemplatePagerField>              
                    <PagerTemplate>
                    <div class="pageing_results">
                    Page
                    <asp:Label runat="server" ID="CurrentPageLabel" 
                      Text="<%# Container.TotalRowCount>0 ? (Container.StartRowIndex / Container.PageSize) + 1 : 0 %>" />
                    of
                    <asp:Label runat="server" ID="TotalPagesLabel" 
                      Text="<%# Math.Ceiling ((double)Container.TotalRowCount / Container.PageSize) %>" />
                    (
                    <asp:Label runat="server" ID="TotalItemsLabel" 
                      Text="<%# Container.TotalRowCount%>" />
                    records)
                    </div>
                    </PagerTemplate>
                  </asp:TemplatePagerField>
          
                  <asp:NextPreviousPagerField
                    ButtonType="Link"
                    ButtonCssClass="page_prev"
                    FirstPageText="≤ First" 
                    ShowFirstPageButton="true"
                    ShowNextPageButton="false"
                    ShowPreviousPageButton="false" />

                    <asp:NextPreviousPagerField
                    ButtonType="Link"
                    ButtonCssClass="page_prev"
                    PreviousPageText="« Prev"
                    ShowNextPageButton="false"
                    ShowPreviousPageButton="true" />

                  <asp:NumericPagerField ButtonCount="10"  />

                    <asp:NextPreviousPagerField
                    ButtonType="Link"
                    ButtonCssClass="page_next"
                    NextPageText="Next »"
                    ShowNextPageButton="true"
                    ShowPreviousPageButton="false" />

            
                  <asp:NextPreviousPagerField
                    ButtonType="Link"
                    ButtonCssClass="page_next"
                    LastPageText="Last ≥"
                    ShowLastPageButton="true"
                    ShowNextPageButton="false"
                    ShowPreviousPageButton="false" />
                </Fields>
              </asp:DataPager>
        </div>

</asp:Content>
