<%@ Page Language="C#" MasterPageFile="~/research.master" AutoEventWireup="true" CodeBehind="Confidential.aspx.cs" Inherits="WebApplication.Admin.Research.Confidential" %>

<asp:Content ID="cHeadContent" ContentPlaceHolderID="cphHeadContent" Runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.multiselect.min.js"></script>
    <style >
        .ui-autocomplete-loading { background: white url('../../Styles/ui-lightness/images/ui-anim_basic_16x16.gif') right center no-repeat; }
	    #productName { width: 25em; }
    </style>

    <script type="text/javascript">

        $(document).ready(function () {
            $("[id*=mn_acc_reports]").addClass("current");
            $("[id*=ddlYear]").multiselect({
                noneSelectedText: 'Select Years',
                selectedList: 4,
                autoOpen: false
            });

            $("[id*=tbProductName]").autocomplete({
                source: function (request, response) {
                    //alert(request.term);
                    //var dataString = '{"productName":"just"}';
                    var dataString = '{"productName":"' + request.term + '"}';

                    $.ajax({
                        type: "POST",
                        url: "Confidential.aspx/GetProducts",
                        dataType: "json",
                        data: dataString,
                        contentType: "application/json; charset=utf-8",
                        success: function (data) {
                            var x = data.d;
                            //alert(x);
                            response($.map(x, function (item) {
                                return {
                                    value: item.productId,
                                    label: item.productName
                                };
                            }));
                            //alert(data.d);
                        },
                        error: function (xhr, status, error) {
                            // Display a generic error for now.
                            alert("AJAX Error! Generate Product List");
                            alert(xhr.responseText);
                            alert(error);

                        }
                    });
                },
                focus: function (event, ui) {
                    //alert(ui.item.label);
                    $("[id*=tbProductName]").val(ui.item.label);
                    return false;
                },
                minLength: 3,
                select: function (event, ui) {
                    $("[id*=tbProductName]").val(ui.item.label);
                    $("[id*=hdnProductId]").val(ui.item.value);
                    return false;
                },
                open: function () {
                    $(this).removeClass("ui-corner-all").addClass("ui-corner-top");
                },
                close: function () {
                    $(this).removeClass("ui-corner-top").addClass("ui-corner-all");
                }
            });

            $("[id*=btnGeneratePdf]").click(function () {
                
                PerformServerValidation(1);

                return false;
            });

            $("[id*=btnGenerateExcel]").click(function () {

                PerformServerValidation(2);

                return false;
            });

            $("[id*=lnkClearForm]").click(function () {
                ClearForm();
                ClearFormErrors();
            });
        });

        function ClearForm() {
            $("[id*=tbLicenseNumber]").val('');
            $("[id*=tbProductName]").val('');

            //$("[id*=ddlYear] option:selected").prop("selected", false);
            $("[id*=ddlYear]").multiselect("uncheckAll");
        }

        function GenerateReport(formatType) {
            var url = 'GenerateResearchReport.aspx?reportTypeId=7' + '&years=' + $("[id*=ddlYear]").val() + '&productName=' + encodeURIComponent($("[id*=tbProductName]").val()) + '&licenseNumber=' + encodeURIComponent($("[id*=tbLicenseNumber]").val()) + '&formatTypeId=' + formatType;
            if (formatType == 2) {
                window.open(url, '_parent');
            }
            else {
                window.open(url, '_blank');
            }
            
            return false;
        }

        function IsFormValid(errMessage) {
            //return false;
            var isValid = true;
            ClearFormErrors();

            if (!$("[id*=ddlYear]").val()) {
                //  alert("YYY");
                $("[id*=dvErrorYear]").show();
                isValid = false;
            }

            if (!$("[id*=tbProductName]").val() && !$("[id*=tbLicenseNumber]").val()) {
                //  alert("YYY");
                $("[id*=dvErrorProductName]").show();
                isValid = false;
            }

            if (errMessage != "") {
                //alert(errMessage);
                $('"[id*=' + errMessage + ']"').show();
                isValid = false;
            }

            //alert("In isFormValid..." + isValid);
            return isValid;
        }

        function PerformServerValidation(formatType) {
            //var productId = $("[id*=hdnProductId]").val();
            var productName = $("[id*=tbProductName]").val();
            var licenseNumber = $("[id*=tbLicenseNumber]").val();
            
            var dataString = '{"productName":"' + productName + '","licenseNumber":"' + licenseNumber + '"}';

            $.ajax({
                type: "POST",
                url: "Confidential.aspx/ValidateForm",
                data: dataString,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    // alert("Ajax success");
                    //alert("This is in ajax success" + IsFormValid(""));
                    var isValid = IsFormValid("");
                    //alert(isValid);
                    if (isValid) {
                        GenerateReport(formatType);
                    }
                    return isValid;
                    //return true;
                    //isValid = true;
                    //return isValid;
                },
                error: function (xhr, status, error) {
                    //alert("Ajax fail" + xhr.responseText);
                    var x = JSON.parse(xhr.responseText);
                    var isValid = IsFormValid(x.Message);
                    //alert(isValid);
                    return isValid;
                    //$("[id*=dvErrorLicenseNumber]").html(x.Message);
                }
            });

        }

        function ClearFormErrors() {
            $("[id*=dvError]").hide();
            //            $("[id*=dvErrorYear]").hide();
        }


    </script>
</asp:Content> 

<asp:Content ID="cMainContent" ContentPlaceHolderID="cphMainContent" Runat="Server"> 
    <asp:HiddenField id="hdnProductId" runat="server"></asp:HiddenField>
    

    <div class="form_fields clearfix">
		<div class="form_label"><label>License number:</label></div>
		<div class="form_input">
            <asp:TextBox ID="tbLicenseNumber" runat="server"></asp:TextBox>
        </div>
        <div id="dvErrorNoLicenseNumber" style="display:none;">
		    <span style="color:red;">No product exists with the submitted license number.</span>
       </div>
	</div> 

    <div class="form_fields clearfix">
		<div class="form_label"><label>Product name:</label></div>
		<div class="form_input">
            <asp:TextBox ID="tbProductName" runat="server"></asp:TextBox>
        </div>
        <div id="dvErrorProductName" style="display:none;">
		    <span style="color:red;">Product name or license number is required.</span>
       </div>
       <div id="dvErrorNoProductName" style="display:none;">
		    <span style="color:red;">No product exists with the submitted product name.</span>
       </div>
	</div> 

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
	    <asp:Button ID="btnGeneratePdf" runat="server" Text="PDF"  />&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnGenerateExcel" runat="server" Text="Excel" />&nbsp;&nbsp;&nbsp;&nbsp;<a id="lnkClearForm">Clear</a>
	</div>
</asp:Content> 
