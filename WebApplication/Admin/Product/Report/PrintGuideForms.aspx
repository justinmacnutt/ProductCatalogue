<%@ Page Language="C#"  MasterPageFile="~/prodCat.Master" AutoEventWireup="true" CodeBehind="PrintGuideForms.aspx.cs" Inherits="WebApplication.Admin.Report.PrintGuideForms" %>
<asp:Content ID="cHeadContent" ContentPlaceHolderID="cphHeadContent" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $(document).ready(function () {
                $("[id*=mn_reports]").addClass("current");
            });

            $("[id*=lnkClearApplicationForm]").click(function () {
                $("[id*=ddlApplicationProductType]").val('');
                ClearApplicationErrors();
            });

            $("[id*=btnGenerateApplicationForm]").click(function () {
                if (IsApplicationValid()) {
                    GenerateApplicationForm();
                }
                return false;
            });

            //confirmation
            $("[id*=lnkClearConfirmationForm]").click(function () {
                $("[id*=ddlConfirmationProductType]").val('');
                $("[id*=ddlConfirmationPublishStatus]").val('');
                ClearConfirmationErrors();
            });

            $("[id*=btnGenerateConfirmationForm]").click(function () {
                if (IsConfirmationValid()) {
                    GenerateConfirmationForm();
                }
                return false;
            });

            //listing proof

            $("[id*=lnkClearProofForm]").click(function () {
                $("[id*=ddlProofPublishStatus]").val('');
                $("[id*=ddlProofDeliveryType]").val('');
                $("[id*=ddlProofRegion]").val('');
                ClearProofErrors();
            });

            $("[id*=btnGenerateProofForm]").click(function () {
                if (IsProofValid()) {
                    GenerateProofForm();
                }
                return false;
            });
        });

        function IsApplicationValid() {
            ClearApplicationErrors();
            var isValid = true;

            if ($("[id*=ddlApplicationProductType]").val() == '') {
                $("[id*=dvApplicationProductTypeError]").show();
                isValid = false;
            }
            return isValid;
        }

        function ClearApplicationErrors() {
            $("[id*=dvApplicationProductTypeError]").hide();
        }

        function GenerateApplicationForm() {
            ClearApplicationErrors();

            var url = 'FormGeneration.aspx?printGuideFormTypeId=1';

            if ($("[id*=ddlApplicationProductType]").val() != '') {
                url += '&productTypeId=' + $("[id*=ddlApplicationProductType]").val();
            }

            window.open(url);
        }

        function IsConfirmationValid() {
            ClearConfirmationErrors();
            var isValid = true;

            if ($("[id*=ddlConfirmationProductType]").val() == '') {
                $("[id*=dvConfirmationProductTypeError]").show();
                isValid = false;
            }
            return isValid;
        }

        function ClearConfirmationErrors() {
            $("[id*=dvConfirmationProductTypeError]").hide();
        }

        function GenerateConfirmationForm() {
            ClearConfirmationErrors();

            var url = 'FormGeneration.aspx?printGuideFormTypeId=2';

            if ($("[id*=ddlConfirmationProductType]").val() != '') {
                url += '&productTypeId=' + $("[id*=ddlConfirmationProductType]").val();
            }

            if ($("[id*=ddlConfirmationPublishStatus]").val() != '') {
                url += '&publishStatusId=' + $("[id*=ddlConfirmationPublishStatus]").val();
            }

            if ($("[id*=ddlRegion]").val() != '') {
                url += '&regionId=' + $("[id*=ddlRegion]").val();
            }

            window.open(url);
        }

        function IsProofValid() {
            ClearProofErrors();
            var isValid = true;

            if ($("[id*=ddlProofDeliveryType]").val() == '') {
                $("[id*=dvProofDeliveryTypeError]").show();
                isValid = false;
            }

            return isValid;
        }

        function ClearProofErrors() {
            $("[id*=dvProofDeliveryTypeError]").hide();
        }

        function GenerateProofForm() {
            ClearProofErrors();

            var url = 'FormGeneration.aspx?printGuideFormTypeId=3&productTypeId=1';

            if ($("[id*=ddlProofPublishStatus]").val() != '') {
                url += '&publishStatusId=' + $("[id*=ddlProofPublishStatus]").val();
            }

            if ($("[id*=ddlProofDeliveryType]").val() != '') {
                url += '&proofDeliveryTypeId=' + $("[id*=ddlProofDeliveryType]").val();
            }

            if ($("[id*=ddlProofRegion]").val() != '') {
                url += '&regionId=' + $("[id*=ddlProofRegion]").val();
            }

            window.open(url);
        }

        
    </script>
</asp:Content>
<asp:Content ID="cMainContent" ContentPlaceHolderID="cphMainContent" Runat="Server">
    <div class="page_header clearfix">
		<div class="action_btns"></div>
		<h2 class="page_title">Print Guide Forms</h2>
	</div>

    <div class="col_wrap clearfix">
        <div class="wide">
            
			 
            <h3>Application Form</h3>
			<div class="fieldset clearfix">
			    <div class="form_single_row">
					<div class="form_label"><label>Product type</label></div>
					<div class="form_input">
						<asp:DropDownList id="ddlApplicationProductType" runat="server">
							<asp:ListItem Value="">Please select</asp:ListItem>
							<asp:ListItem Value="1">Accommodations</asp:ListItem>
							<asp:ListItem Value="2">Attractions</asp:ListItem>
                            <asp:ListItem Value="3">Campgrounds</asp:ListItem>
							<asp:ListItem Value="4">Fine Arts</asp:ListItem>
							<asp:ListItem Value="5">Outdoors</asp:ListItem>
							<asp:ListItem Value="6">Tour operators</asp:ListItem>
                            <asp:ListItem Value="13">Trails</asp:ListItem>
							<asp:ListItem Value="7">Restaurants</asp:ListItem>
						</asp:DropDownList>
					</div>
					<div id="dvApplicationProductTypeError" style="display:none;">
						<span style="color:red;">Product type is required.</span>
					</div>
					<div class="update_btn_bar clearfix">
						<asp:Button ID="btnGenerateApplicationForm" runat="server" Text="Generate Forms" CssClass="search_btn" /> | <a id="lnkClearApplicationForm" >Clear</a>
					</div>
                </div>
		    </div>


            <h3>Confirmation Form</h3>
			<div class="fieldset clearfix">
			    <div class="form_single_row">
					<div class="form_label"><label>Product type</label></div>
					<div class="form_input">
						<asp:DropDownList id="ddlConfirmationProductType" runat="server">
							<asp:ListItem Value="">Please select</asp:ListItem>
							<asp:ListItem Value="1">Accommodations</asp:ListItem>
							<asp:ListItem Value="2">Attractions</asp:ListItem>
                            <asp:ListItem Value="3">Campgrounds</asp:ListItem>
							<asp:ListItem Value="4">Fine Arts</asp:ListItem>
							<asp:ListItem Value="5">Outdoors</asp:ListItem>
							<asp:ListItem Value="6">Tour operators</asp:ListItem>
                            <asp:ListItem Value="13">Trails</asp:ListItem>
							<asp:ListItem Value="7">Restaurants</asp:ListItem>
						</asp:DropDownList>
					</div>
					<div id="dvConfirmationProductTypeError" style="display:none;">
						<span style="color:red;">Product type is required.</span>
					</div>
                    <br /><br />
					<div class="form_label"><label>Region</label></div>
					<div class="form_input">
						<asp:DropDownList id="ddlRegion" runat="server" AppendDataBoundItems="true">
						    <asp:ListItem value="">Please select</asp:ListItem> 
						</asp:DropDownList> 
					</div>
					<br /><br />
					<div class="form_label"><label>Publish status</label></div>
					<div class="form_input">
						<asp:DropDownList id="ddlConfirmationPublishStatus" runat="server">
							<asp:ListItem Value="1">Published</asp:ListItem>
							<asp:ListItem Value="2">Not published</asp:ListItem>
						</asp:DropDownList> 
					</div>
				
					<div class="update_btn_bar clearfix">
						<asp:Button ID="btnGenerateConfirmationForm" runat="server" Text="Generate Forms" CssClass="search_btn" /> | <a id="lnkClearConfirmationForm" href="#">Clear</a>
					</div>
				</div>
		    </div>

            <h3>Listing Proof Form</h3>
			<div class="fieldset clearfix">
			    <div class="form_single_row">
					<div class="form_label"><label>Region</label></div>
					<div class="form_input">
						<asp:DropDownList id="ddlProofRegion" runat="server" AppendDataBoundItems="true">
						    <asp:ListItem value="">Please select</asp:ListItem> 
						</asp:DropDownList> 
					</div>
                    <br /><br />
					<div class="form_label"><label>Publish status</label></div>
					<div class="form_input">
						<asp:DropDownList id="ddlProofPublishStatus" runat="server">
							<asp:ListItem Value="1">Published</asp:ListItem>
							<asp:ListItem Value="2">Not published</asp:ListItem>
						</asp:DropDownList> 
					</div>
                    <br /><br />
                    <div class="form_label"><label>Proof Delivery Type</label></div>
					<div class="form_input">
						<asp:DropDownList id="ddlProofDeliveryType" runat="server">
                            <asp:ListItem Value="">Please select</asp:ListItem>
							<asp:ListItem Value="1">Email</asp:ListItem>
							<asp:ListItem Value="2">Fax</asp:ListItem>
						</asp:DropDownList> 
					</div>
                    <div id="dvProofDeliveryTypeError" style="display:none;">
						<span style="color:red;">Proof Delivery Type is required.</span>
					</div>
				
					<div class="update_btn_bar clearfix">
						<asp:Button ID="btnGenerateProofForm" runat="server" Text="Generate Forms" CssClass="search_btn" /> | <a id="lnkClearProofForm" href="#">Clear</a>
					</div>
				</div>
			</div>
    </div>
	</div>
</asp:Content>

