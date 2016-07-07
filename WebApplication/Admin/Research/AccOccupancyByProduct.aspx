<%@ Page Language="C#" MasterPageFile="~/research.master" AutoEventWireup="true" CodeBehind="AccOccupancyByProduct.aspx.cs" Inherits="WebApplication.Admin.Research.AccOccupancyByProduct" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>

<asp:Content ID="cHeadContent" ContentPlaceHolderID="cphHeadContent" Runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.multiselect.min.js"></script>

    <script type="text/javascript">

        $(document).ready(function () {

            $("[id*=cbEnforceReportingRateMin]").attr('checked', true);
            $("[id*=cbEnforceOneThird]").attr('checked', true);
            
            $("[id*=mn_acc_reports]").addClass("current");

            $("[id*=lnkClearForm]").click(function () {
                ClearForm();
                ClearFormErrors();
            });
            
            $("[id*=tbLicenseNumber]").keydown(function (event) {
                // Allow: backspace, delete, tab, escape, and enter
                if (event.keyCode == 13) {
                    // let it happen, don't do anything
                    $("[id*=lnkAddProduct]").click();
                    event.preventDefault();
                }
                else {
                    return;
                }
            });

            $("[id*=lnkAddProduct]").click(function () {
                AddProduct();
            });

            //$("[id*=dvProductList]").on('click', $("[id*=lnkDeleteProduct]"), function (e) {
            $("[id*=dvProductList]").live('click', $("[id*=lnkDeleteProduct]"), function (e) {
                var id = $(e.target).attr("productId");

                var newList = "";

                $.each($("[id*=hdnProductIds]").val().split(','), function (idx, val) {
                    if (val != id) {
                        newList += val + ",";
                    }
                });

                if (newList.length > 0) {
                    newList = newList.substr(0, newList.length - 1);
                }

                $("[id*=hdnProductIds]").val(newList);
                GenerateProductList();
            });

            $("[id*=btnGeneratePdf]").click(function () {
            
                $("[id*=hdnYears]").val($("[id*=ddlYear]").val());

//                if ($("[id*=cbEnforceOneThird]").attr('checked')) {
//                    // alert("calling validateonethird");
//                    isValid = PerformServerValidation();
//                }
//                else {
                    isValid = IsFormValid("");
//                }
             
                if (isValid) {
                    GenerateReport(1);
                }
                //alert("BBBBB");
                return false;
            });

            $("[id*=btnGenerateExcel]").click(function () {
                //return false;
                $("[id*=hdnYears]").val($("[id*=ddlYear]").val());

//                if ($("[id*=cbEnforceOneThird]").attr('checked')) {
//                    // alert("calling validateonethird");
//                    isValid = PerformServerValidation();
//                }
//                else {
                    isValid = IsFormValid("");
//                }
                
                if (isValid) {
                    GenerateReport(2);
                }
                return false;
            });

            $("[id*=ddlYear]").multiselect({
                noneSelectedText: 'Select Years',
                selectedList: 5,
                autoOpen: false
            });

        });

        function ClearFormErrors() {
            $("[id*=dvErrorYear]").hide();
        }

        function ClearForm() {

            $("[id*=tbLicenseNumber]").val('');
            $("[id*=tbClientName]").val('');
            $("[id*=tbDescription]").val('');

            $("[id*=ddlYear]").multiselect("uncheckAll");

            $("[id*=cbEnforceReportingRateMin]").attr('checked',true);
            $("[id*=cbDisplayActuals]").attr('checked', false);
            $("[id*=cbIgnoreNumberMin]").attr('checked', false);
            $("[id*=cbEnforceOneThird]").attr('checked', true);
        }
        
        function GenerateProductList() {
            var idList = $("[id*=hdnProductIds]").val();
            
            var dataString = '{"idList":"' + idList + '"}';
            
            $.ajax({
                type: "POST",
                url: "AccOccupancyByProduct.aspx/GetProductList",
                data: dataString,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var x = msg.d;
                    
                    var myLength = x.length;

                    if (myLength > 0) {
                        var myProductTable = '<table id="tblProductList" border="0" cellpadding="0" cellspacing="0" class="tbl_data">';
                        myProductTable += '<tr class="tbl_header"><td style="width:20%;"><strong>License Number</strong></td><td style="width:20%;"><strong>Product Name</strong></td><td style="width:20%;"><strong>Class</strong></td><td style="width:15%;"><strong>Region</strong></td><td style="width:15%;"><strong>Action</strong></td></tr>';
                        //alert(x.length);
                        for (var q = 0; q < myLength; q++) {
                            myProductTable += "<tr>";
                            myProductTable += "<td><a target='_blank' href='Edit.aspx?productId=" + x[q].productId + "'>" + x[q].licenseNumber + "</a></td>";
                            myProductTable += "<td>" + x[q].productName + "</td>";
                            myProductTable += "<td>" + x[q].accommodationType + "</td>";
                            myProductTable += "<td>" + x[q].region + "</td>";
                            myProductTable += "<td><a id='lnkDeleteProduct' productId='" + x[q].productId + "'>Delete</a></td>";
                            myProductTable += "</tr>";
                        }

                        myProductTable += "</table>";
                        
                        $("#dvProductList").html(myProductTable);
                    }
                    else {
                        $("#dvProductList").html("No products have been assigned.<br/><br/>");
                    }
                },
                error: function (xhr, status, error) {
                    // Display a generic error for now.
                    alert("AJAX Error! Generate Product List");
                }
            });

        }

        function AddProduct() {
            //alert("WHY");
            $("[id*=dvErrorLicenseNumber]").html("");
            var newLicenseNumber = $("[id*=tbLicenseNumber]").val();

            if (newLicenseNumber == "") {
                $("[id*=dvErrorLicenseNumber]").html("License Number is required.");
                return;
            }
            
            var currentValues = $("[id*=hdnProductIds]").val();
            
            var dataString = '{"newLicenseNumber":"' + newLicenseNumber + '","currentValues":"' + currentValues + '"}';

            $.ajax({
                type: "POST",
                url: "AccOccupancyByProduct.aspx/AddProduct",
                data: dataString,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var x = msg.d;

                    $("[id*=hdnProductIds]").val(x);
                    $("[id*=tbLicenseNumber]").val("");
                    $("[id*=tbLicenseNumber]").focus();
                    GenerateProductList();
                },
                error: function (xhr, status, error) {
                    // Display a generic error for now.
//                    alert("AJAX Error! Add Product");
//                    alert(xhr);
//                    alert(xhr.responseText);
                    var x = JSON.parse(xhr.responseText);
//                    alert(x);
//                    alert(x.Message);
//                    alert(status);
//                    alert(error);
                    $("[id*=dvErrorLicenseNumber]").html(x.Message);
                }
            });
        }

        function IsFormValid(errMessage) {
            //return false;
            var isValid = true;
            ClearFormErrors();
            //alert("KKKaaa" + errMessage);
            var productIds = $("[id*=hdnProductIds]").val();
            
            if (productIds == "") {
                //$("[id*=dvErrorLicenseNumber]").show();
              //  alert("XXX");
                $("[id*=dvErrorLicenseNumber]").html("Products are required.");
                isValid = false;
            }

            if (!$("[id*=ddlYear]").val()) {
              //  alert("YYY");
                $("[id*=dvErrorYear]").show();
                isValid = false;
            }
            
            if (errMessage != "") {
             //   alert("ZZZ");
                $("[id*=dvErrorLicenseNumber]").html(errMessage);
                isValid = false;
            }
            //***********
           // alert("WHYA" + isValid + errMessage);

            return isValid;

            if (isValid) {
              //  alert("WWWW");
                GenerateReport();   
                //return true;
            }
            else {
               // alert("QQQ");
                //return false;
            }
            return false;
            //return isValid;
        }

        function PerformServerValidation() {
            
            var productIds = $("[id*=hdnProductIds]").val();
            var dataString = '{"productIds":"' + productIds + '"}';

            $.ajax({
                type: "POST",
                url: "AccOccupancyByProduct.aspx/ValidateOneThird",
                data: dataString,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                   // alert("Ajax success");
                    return IsFormValid("");
                    //return true;
                    //isValid = true;
                    //return isValid;
                },
                error: function (xhr, status, error) {
                    //alert("Ajax fail" + xhr.responseText);
                    var x = JSON.parse(xhr.responseText);
                    return IsFormValid(x.Message);
                    //$("[id*=dvErrorLicenseNumber]").html(x.Message);
                }
            });
            
        }

//        function ClearFormErrors() {
//            //$("[id*=dvError]").hide();
//            $("[id*=dvErrorYear]").hide();
//        }

        function GenerateReport(formatType) {
            var enforceReportingRateMin = "false";
            var displayActuals = "false";
            var ignoreNumberMin = "false";
            var enforceOneThird = "false";

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

            //bool enforceReportingRateMin, bool displayActuals, bool ignoreNumberMin, string clientName, string description) 
            var url = 'GenerateResearchReport.aspx?reportTypeId=1&productIds=' + $("[id*=hdnProductIds]").val() + '&years=' + $("[id*=ddlYear]").val() + '&enforceReportingRateMin=' + enforceReportingRateMin + '&displayActuals=' + displayActuals + '&ignoreNumberMin=' + ignoreNumberMin + '&enforceOneThird=' + enforceOneThird + '&clientName=' + encodeURIComponent($("[id*=tbClientName]").val()) + '&desc=' + encodeURIComponent($("[id*=tbDescription]").val()) + '&formatTypeId=' + formatType;
            window.open(url, '_blank');
            return false;
        }

    </script>
</asp:Content> 
<asp:Content ID="cMainContent" ContentPlaceHolderID="cphMainContent" Runat="Server"> 
    <div class="page_header clearfix">
		<h2 class="page_title">Research</h2>
	</div>

    <table cellpadding="0" cellspacing="0" border="0" class="researchProdInfo">
        <tr>
            <td class="form_label"><label>License Number:</label></td>
        </tr>
        <tr>
            <td class="form_input">
                <asp:TextBox ID="tbLicenseNumber" runat="server"></asp:TextBox>
                <div id="dvErrorLicenseNumber" style="color:red;">
		        </div>
            </td>
        </tr>
    </table>
    <div class="search_btn_bar clearfix">
         <a id="lnkAddProduct">Add</a>
	</div>
    <hr />

    <asp:HiddenField ID="hdnLicenseNumbers" runat="server" />
    <asp:HiddenField ID="hdnProductIds" runat="server" />
    
    <div id="dvProductList"></div>       
    
    <asp:HiddenField runat="server" ID="hdnYears"/>
    <div class="form_fields clearfix">
		<div class="form_label"><label>Years:</label></div>
		<div class="form_input">
            <select id="ddlYear" runat="server" multiple="true"></select>
            
            </div>
            <div id="dvErrorYear" style="display:none;">
			    <span style="color:red;">At least one year is required.</span>
		    </div>
	</div> 
              
    <div class="form_fields clearfix">
        <table>
            <tr>
                <td><div class="form_label"><label>Enforce 85% rule:</label></div></td>
                <td>&nbsp;&nbsp;</td>
                <td><div class="form_input"><asp:CheckBox ID="cbEnforceReportingRateMin" runat="server" /></div></td>
            </tr>
            <tr>
                <td><div class="form_label"><label>Display actuals:</label></div></td>
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
		<div class="form_input"><asp:TextBox ID="tbClientName" runat="server" MaxLength="100"></asp:TextBox></div>
	</div>         
    <div class="form_fields clearfix">
		<div class="form_label"><label>Description:</label></div>
		<div class="form_input"><asp:TextBox ID="tbDescription" runat="server" TextMode="MultiLine" MaxLength="250"></asp:TextBox></div>
	</div>         
    <div class="form_fields clearfix">
	    <asp:Button ID="btnGeneratePdf" runat="server" Text="PDF"  />&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnGenerateExcel" runat="server" Text="Excel"/>&nbsp;&nbsp;&nbsp;&nbsp;<a id="lnkClearForm">Clear</a>
	</div>
</asp:Content> 
