<%@ Page Language="C#" MasterPageFile="~/research.Master" AutoEventWireup="true" CodeBehind="BulkEdit.aspx.cs" Inherits="WebApplication.Admin.Research.BulkEdit" %>

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

     var errPercentages = "Sum of Visitor percentages must equal 100%";
     var errOpenDays = "Open days must be less than number of days in the month";
     var errUnitsSold = "Units sold must be less than the available units";
     var errUnitsSoldReq = "Units sold is a required field";
     var errTotalGuestsReq = "Total guests is a required field";
     var errTotalGuests = "Total guests must be greater than the units sold";

     //style = "border:1px solid #c10000;"

     $(document).ready(function () {
         $("[id*=mn_bulkEdit]").addClass("current");

         $("[id*=ddlProductType]").attr("disabled", true);
         InitializeEventBindings();

         //$('#tblBulkEditData tr').filter("[previouslysaveddata='1']").children('td').css("background-color", "#fefcc2");
         //$('#tblBulkEditData tr').filter("[previouslysaveddata='1']").children('td').css("background-color", colourSaved);
         $('#tblBulkEditData tr:gt(1)').addClass("unsavedRow");
         $('#tblBulkEditData tr').filter("[previouslysaveddata='1']").removeClass("unsavedRow").addClass("savedRow");
         $('#tblBulkEditData tr').filter("[previouslysaveddata='1']").find(".lnkDeleteRow").show();
         //$("[id*=hdnPreviouslySaved]").filter("[value='1']").closest('tr').find(".lnkDeleteRow").show();

         $('#tblBulkEditData tr').filter("[previouslysaveddata='0']").each(function () {
             if ($(this).find("[id*=tbOpenDays]").val() == "0") {
                 $(this).removeClass("unsavedRow").addClass("validRow");
             }
         });

         $('a').not('.suppressWarning').click(function () {
             //alert("U CLICKED A LINK");
             //alert("#OF VALID ROWS>>>>" + $(".validRow").size());
//             if ($(".validRow").size() > 0) {
//                 var r = confirm("There are valid rows that have not yet been saved, are you sure you want to proceed? (all unsaved data will be lost)");
//                 return r;
//             }
             return NavigationConfirmation();
             
         });


         $("[id*=btnSearch]").click(function () {
             //alert("U CLICKED A LINK");
             //alert("#OF VALID ROWS>>>>" + $(".validRow").size());
//             if ($(".validRow").size() > 0) {
//                 var r = confirm("There are valid rows that have not yet been saved, are you sure you want to proceed? (all unsaved data will be lost)");
//                 return r;
             //             }
             return NavigationConfirmation();
         });

         //   $('#tblBulkEditData tr').filter("[previouslysaveddata='0']").children('td').css("background-color", colourInvalid);

         //         $("[id*=tbOpenDays]").qtip({
         //             content: $('#contentID')
         //         });
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
             url: "Edit.aspx/DeleteResearchRow",
             data: dataString,
             contentType: "application/json; charset=utf-8",
             dataType: "json",
             success: function (msg) {
                 var x = msg.d;
                 
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
        $('#tblBulkEditData td:nth-child(13)').hide();
        $('#tblBulkEditData td:nth-child(14)').hide();

        $(".validateThis").change(function () {
            var changedInput = $(this);
            ValidateRow(changedInput);
        });

        $("#cbDisplayClassRatingInputs").click(function () {
            $('#tblBulkEditData td:nth-child(13)').toggle(this.checked);
            $('#tblBulkEditData td:nth-child(14)').toggle(this.checked);
        });

//        $(".numberOnly").change(function (e) {
//            if (e.keyCode != "9") {
//                this.value = this.value.replace(/[^0-9\.]/g, '');
//            }
        //        });

//        $(".numberOnly").keyup(function (e) {
//            if (e.keyCode != "9") {
//                this.value = this.value.replace(/[^0-9\.]/g, '');
//            }
//        });

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
           // alert("JUSTIN2");
            var row = $(this).closest('tr');
            DeleteResearchRow(row);
        });
        
        

//        $("[id*=tbOpenDays]").change(function () {
//            var changedInput = $(this);
//            //             alert(input.attr("id") + ":::" + index);
//            //             alert("???" + $(this).closest('tr').find("[id*=tbAvailableUnitsDay]").val());

//            RecalculateAvailableUnitsMonth(changedInput);
//            return true;
//        });

//        $("[id*=tbAvailableUnitsDay]").change(function () {
//            var changedInput = $(this);
//            RecalculateAvailableUnitsMonth(changedInput);
//            return true;
//        });

        $("[id*=btnSave]").click(function () {

            //            alert("ERROR CELLS" + $(".hasError").size());
            //            return false;
            if ($(".hasError").size() > 0) {
                var r = confirm("There are rows with errors, are you sure you want to proceed? (all data in rows with errors will be lost)");
                return r;
            }
            return true;

            //            return true;
            //            if (IsFormValid()) {
            //                return true;
            //            }
            //            return false;
        });
    }

    function GetDaysInMonth(month,year) {
        return new Date(year, month, 0).getDate();
    }

    function ValidateRow(changedInput) {
        var isValid = true;
        
//        var errPercentages = "Sum of Visitor percentages must be less than 100";
//        var errOpenDays = "Open days must be less than number of days in the month";
//        var errUnitsSold = "Units sold must be less than the available units";
//        var errUnitsSoldReq = "Units sold is a required field";
//        var errTotalGuestsReq = "Total guests is a required field";
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

            parentRow.find("[id*=tbUnitsSold]").addClass("hasError");
            parentRow.find("[id*=tbUnitsSold]").qtip({
                content: errUnitsSoldReq
            });

        }

        if (totalGuests.length == 0) {
            isValid = false;

            parentRow.find("[id*=tbTotalGuests]").addClass("hasError");
            parentRow.find("[id*=tbTotalGuests]").qtip({
                content: errTotalGuestsReq
            });
        }

        //units sold for month needs to be less than the available units for the month
        if (Number(unitsSold) > Number(unitsPerMonth)) {
            isValid = false;
            
            parentRow.find("[id*=tbUnitsSold]").addClass("hasError");
            parentRow.find("[id*=tbUnitsSold]").qtip({
                content: errUnitsSold
            });

        }

        //total guests must be greater than the units sold
        if (totalGuests.length > 0 && (Number(totalGuests) < Number(unitsSold))) {
            isValid = false;

            parentRow.find("[id*=tbTotalGuests]").addClass("hasError");
            parentRow.find("[id*=tbTotalGuests]").qtip({
                content: errTotalGuests
            });

        }

        if (isValid) {
            //parentRow.children('td').css("background-color", colourValid);
            //parentRow.css("background-color", colourValid);
            parentRow.addClass("validRow");
        }
        else {
//            parentRow.find(".hasError").qtip({
//                content: errMsg
//            });
            //parentRow.children('td').css("background-color", colourInvalid);
        }


    }

    function IsNumber(n) {
         return !isNaN(parseFloat(n)) && isFinite(n);
    }
     // Resets the values for the filter textboxes
    function ClearFilters() {

    }

    function RecalculateAvailableUnitsMonth(changedInput) {
        //alert(changedInput.val());
        var unitsPerDay = changedInput.closest('tr').find("[id*=tbAvailableUnitsDay]").val();
        var openDays = changedInput.closest('tr').find("[id*=tbOpenDays]").val();

        var unitsPerMonth = Number(unitsPerDay) * Number(openDays);

       // alert(unitsPerMonth);
        changedInput.closest('tr').find("[id*=tdAvailableUnitsMonth]").html(unitsPerMonth);
    }

     function MakeFormAdjustments() {
     }

     function IsFormValid() {
         var isValid = true;


//         $('#tblBulkEditData tr').find('input.validateThis').each(function (index, value) {
//             alert($(this).val());
//             //alert(index);
//         });

         //alert("IS THIS BEING FIRED?");
         $('#tblBulkEditData tr').filter("[class='tbl_datarow']").each(function (index, value) {
             var thisRow = $(this);
             alert("ROW" + index);

             $(this).find('input.validateThis').each(function (index, value) {
//                 alert(index + ":::" + $(this).val());
                 if (!IsNumber($(this).val())) {
                     //$(this).parent().parent().css("background-color", "red");
                     thisRow.css("background-color", "red");
                     isValid = false;
                     //return false;
                     //$("[id*=dataRow" + i + "]").addClass("rowError");
                     //isValid = false;
                 }
             });
             //alert($(this).find('input.validateThis').val());
             //alert(index);
         });

         
//         for (var i = 1; i <= 12; i++) {
//             var n = $("[id*=tbOpenDays" + i + "]").val();
//             var o = $("[id*=tbAvailableUnitsDay" + i + "]").val();
//             var p = $("[id*=tbUnitsSold" + i + "]").val();
//             var q = $("[id*=tbTotalGuests" + i + "]").val();
//             if (!IsNumber(n) || !IsNumber(o) || !IsNumber(p) || !IsNumber(q)) {
//                 $("[id*=dataRow" + i + "]").addClass("rowError");
//                 isValid = false;
//             }
//         }

         return isValid;
     }

    </script>
</asp:Content> 
<asp:Content ID="cMainContent" ContentPlaceHolderID="cphMainContent" Runat="Server"> 
     <div id="contentID" style="display:none;">
   Error One<br />
   Error Two
    </div>

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
                <input type="checkbox" id="cbDisplayClassRatingInputs" /> Display class &amp; rating
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
                            <td colspan="2"></td>
                            <td></td>
                            <td></td>
                            <td colspan="5" class="headerGroup"><strong>Visitor Percentages</strong><div></div></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr class="tbl_header">
                            <td><strong>License</strong></td>
                            <td><strong>Product&nbsp;Name</strong></td>
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
                        <div id="itemPlaceholder" runat="server" />
                    </table>
            </LayoutTemplate>
            <ItemTemplate>
                <tr class="tbl_datarow" previouslysaveddata='<%# Eval("PreviouslySavedData") %>'>
                    <td>
                        <asp:Literal ID="litLicenseNumber" runat="server" Text='<%# Eval("licenseNumber") %>'></asp:Literal>
                    </td>
                    <td>
                        <asp:HiddenField ID="hdnProductId" runat="server" Value='<%# Eval("productId") %>' />
                        <a id="lnkProduct" href='Edit.aspx?productId=<%# Eval("productId") %>&year=<%# Eval("year") %>'><%# Eval("productName") %></a>
                    </td>
                    <td>
                        <asp:TextBox ID="tbOpenDays" runat="server" class="validateThis numberOnly" Text='<%# Eval("openDays") %>' Width="40" MaxLength="2"></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox ID="tbAvailableUnitsDay" runat="server" class="validateThis numberOnly" Text='<%# Eval("availableUnitsDay") %>' Width="40"></asp:TextBox>
                    </td>
                    <td id="tdAvailableUnitsMonth"><%# Eval("availableUnitsMonth") %> </td>
                    <td>
                        <asp:TextBox ID="tbUnitsSold" runat="server" class="validateThis numberOnly" Text='<%# Eval("totalUnitsSold") %>' Width="40" MaxLength="4" ></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox ID="tbTotalGuests" runat="server" class="validateThis numberOnly" Text='<%# Eval("totalGuests") %>' Width="45" MaxLength="6"></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox ID="tbVacationGuests" runat="server" class="validateThis numberOnly" Text='<%# Eval("vacationPct") %>' Width="40" MaxLength="3"></asp:TextBox>%
                    </td>
                    <td>
                        <asp:TextBox ID="tbBusinessGuests" runat="server" class="validateThis numberOnly" Text='<%# Eval("businessPct") %>' Width="40" MaxLength="3"></asp:TextBox>%
                    </td>
                    <td>
                        <asp:TextBox ID="tbConventionGuests" runat="server" class="validateThis numberOnly" Text='<%# Eval("conventionPct") %>' Width="40" MaxLength="3"></asp:TextBox>%
                    </td>
                    <td>
                        <asp:TextBox ID="tbMotorcoachGuests" runat="server" class="validateThis numberOnly" Text='<%# Eval("motorcoachPct") %>' Width="40" MaxLength="3"></asp:TextBox>%
                    </td>
                    <td>
                        <asp:TextBox ID="tbOtherGuests" runat="server" class="validateThis numberOnly" Text='<%# Eval("otherPct") %>' Width="40" MaxLength="3"></asp:TextBox>%
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlResearchClass" runat="server" SelectedValue='<%# Eval("ResearchClassId") %>'>
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
