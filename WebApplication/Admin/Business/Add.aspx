<%@ Page Language="C#" MasterPageFile="~/prodCat.master"  AutoEventWireup="true" CodeBehind="Add.aspx.cs" Inherits="WebApplication.Admin.Business.Add" %>
<asp:Content ID="cHeadContent" ContentPlaceHolderID="cphHeadContent" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("[id*=mn_business]").addClass("current");

            // Update text remaining
            var onEditCallback = function (remaining) {
                $(this).siblings('.chars_remaining').text("(" + remaining + " characters remaining)");
            }

            // Attach maxlength function to textarea
            $('textarea[length]').limitMaxlength({
                onEdit: onEditCallback
            });
        });

        function HideLink() {
            $("[id*=lnkBusiness]").hide();
        }
    </script>
</asp:Content> 

<asp:Content ID="cMainContent" ContentPlaceHolderID="cphMainContent" Runat="Server">    
     <div class="breadcrumb"><a href="~/Admin/Business/Index.aspx" runat="server">Business Index</a> &raquo; <strong>Add Business</strong></div>
	
    <div class="page_header clearfix">
		<div class="action_btns"></div>
		<h2 class="page_title">Add Business</h2>
	</div>
    <div class="legend"><span class="required">&bull;</span> <label>indicates required field</label></div>
    
    <div class="form_wrap clearfix">
        <div class="form_fields clearfix">
            <div class="form_label"><label>Business name</label> <span class="required">&bull;</span></div>
		    <div class="form_input"><asp:TextBox ID="tbBusinessName" runat="server" MaxLength="200" CssClass="biz_name_field"></asp:TextBox></div>
            <asp:RequiredFieldValidator ID="rfvBusinessName" runat="server" ControlToValidate="tbBusinessName" 
                ErrorMessage="Business Name is a required field." Display="Dynamic" />
            <asp:CustomValidator ID="cvBusinessName" runat="server" 
                ControlToValidate="tbBusinessName" 
                ErrorMessage="A business with the same name already exists. The value of the business name field must be unique.<br /><br />View " 
                Display="Dynamic" onservervalidate="cvBusinessName_ServerValidate" />
            <asp:PlaceHolder ID="plcBusiness" runat="server" Visible="false">
                <asp:HyperLink ID="lnkBusiness" runat="server" />
            </asp:PlaceHolder>
        </div>
		<div class="fieldset">
			<div class="form_fields clearfix">
				<div class="form_label"><label>Description</label></div>
				<div class="form_input"><asp:TextBox ID="tbDescription" runat="server" TextMode="MultiLine" Length="500"></asp:TextBox>
                <p class="chars_remaining">Characters remaining: 500</p></div>
			</div>
		</div>
    </div>
    <div class="add_btn_bar clearfix">
        <asp:Button ID="btnSubmit" runat="server" Text="Add Business" OnClick="btnSubmit_OnClick" OnClientClick="HideLink()" CssClass="submit_btn" />
    </div>
    
</asp:Content> 
