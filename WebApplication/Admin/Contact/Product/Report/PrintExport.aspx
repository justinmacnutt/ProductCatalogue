<%@ Page Language="C#" MasterPageFile="~/prodCat.Master" AutoEventWireup="true" CodeBehind="PrintExport.aspx.cs" Inherits="WebApplication.Admin.Report.PrintExport" %>
<asp:Content ID="cHeadContent" ContentPlaceHolderID="cphHeadContent" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("[id*=mn_reports]").addClass("current");

            $("[id*=ddlProductType]").change(function () {
                MakeFormAdjustments();
            });

            $("[id*=btnSubmit]").click(function () {
                if (IsFormValid()) {
                    return true;
                }
                return false;
            });
        });

        function MakeFormAdjustments() {
            switch ($("[id*=ddlProductType]").val()) {
                case "1":
                case "2":
                case "3":
                case "4":
                case "7":
                case "5":
                case "6":
                    $("[id*=dvRegion]").show();
                    break;
                    
//                    $("[id*=dvRegion]").hide();
//                    break;
//                $("[id*=dvRegion]").show();
            }
    }

    function IsFormValid() {
        ClearFormErrors();
        var isValid = true;

        if ($("[id*=ddlProductType]").val() == '') {
            $("[id*=dvErrorProductType]").show();
            isValid = false;
        }
       // if ($("[id*=ddlRegion]").val() == '' && ($("[id*=ddlProductType]").val() == '1' || $("[id*=ddlProductType]").val() == '2' || $("[id*=ddlProductType]").val() == '3' || $("[id*=ddlProductType]").val() == '4' || $("[id*=ddlProductType]").val() == '7')) {
        if ($("[id*=ddlRegion]").val() == '' ) {
            $("[id*=dvErrorRegion]").show();
            isValid = false;
        }

        return isValid;
    }

    function ClearFormErrors() {
        $("[id*=dvError]").hide();
    }

    </script>
</asp:Content>
<asp:Content ID="cMainContent" ContentPlaceHolderID="cphMainContent" Runat="Server">
    <div class="form_fields clearfix">
		<div class="form_label"><label>Language</label></div>
		<div class="form_input">
            <asp:DropDownList id="ddlLanguage" runat="server">
                <asp:ListItem Value="en">English</asp:ListItem>
                <asp:ListItem Value="fr">French</asp:ListItem>
            </asp:DropDownList>
        </div>
	</div>
    <div class="form_fields clearfix">
		<div class="form_label"><label>Product type</label></div>
		<div class="form_input"><asp:DropDownList id="ddlProductType" runat="server"></asp:DropDownList></div>
        <div id="dvErrorProductType" style="display:none;">
			<span style="color:red;">Product type is required.</span>
		</div>
	</div>
    <div id="dvRegion" class="form_fields clearfix">
		<div class="form_label"><label>Region</label></div>
		<div class="form_input">
            <asp:DropDownList ID="ddlRegion" runat="server" AppendDataBoundItems="true">
                <asp:ListItem value="">Please select</asp:ListItem>
            </asp:DropDownList>
        </div>
        <div id="dvErrorRegion" style="display:none;">
			<span style="color:red;">Region is required.</span>
		</div>
	</div>
    <div class="form_fields clearfix">
	    <asp:Button ID="btnSubmit" runat="server" OnClick="btnSubmit_OnClick" Text="Generate File"/>	
	</div>
</asp:Content>
