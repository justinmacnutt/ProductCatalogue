<%@ Page Language="C#" MasterPageFile="~/prodCat.master"  AutoEventWireup="true" CodeBehind="Add.aspx.cs" Inherits="WebApplication.Admin.Product.Add" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<asp:Content ID="cHeadContent" ContentPlaceHolderID="cphHeadContent" Runat="Server"> 
    <script type="text/javascript">
        $(document).ready(function () {
            $("[id*=mn_products]").addClass("current");
            $(window).keydown(function (event) {
                if (event.keyCode == 13) {
                    event.preventDefault();
                    return false;
                }
            });

            // Add '902-' to textbox on focus
//            $("[id*=tbTelephone]").focus(function () {
//                if ($(this).val() == "") {
//                    $(this).val('902-');
//                }
//            }); 

            // Check URL function
            $("[id*=lnkCheckWebsite]").click(function () {
                CheckURL("tbWebsite");
            });
        });

        function CheckURL(textbox) {
            var url = $("[id*=" + textbox + "]").val();
            if (url.substring(0, 7).toLowerCase() != "http://") {
            	url = "http://" + url;
            }
            window.open(url);
        }
    </script>
    
</asp:Content> 
<asp:Content ID="cMainContent" ContentPlaceHolderID="cphMainContent" Runat="Server">
    <div class="breadcrumb"><a href="~/Admin/Product/Index.aspx" runat="server">Product Index</a> &raquo; <strong>Add Product</strong></div>
	
    <div class="page_header clearfix">
		<div class="action_btns"></div>
		<h2 class="page_title">Add Product</h2>
	</div>
    <div class="legend"><span class="required">&bull;</span> <label>indicates required field</label></div>

    <div class="form_wrap clearfix">
        <asp:ScriptManager ID="ScriptManager1"  runat="server"></asp:ScriptManager>
        <script type="text/javascript" language="javascript">
            var prm = Sys.WebForms.PageRequestManager.getInstance();

            prm.add_endRequest(function () {
                if ($("[id*=hdnBusinessId]").val() == "") {
                    $("[id*=dvContactSelect]").hide();
                    $("[id*=dvNoContacts]").hide();
                    $("[id*=dvEmptyContact]").show();
                }
                else if ($("[id*=ddlContact] option").length) {
                    $("[id*=dvContactSelect]").show();
                    $("[id*=dvNoContacts]").hide();
                    $("[id*=dvEmptyContact]").hide();
                }
                else {
                    $("[id*=dvContactSelect]").hide();
                    $("[id*=dvNoContacts]").show();
                    $("[id*=dvEmptyContact]").hide();
                }

            });

        </script>  
        
        <div id="contactForm" class="section_body clearfix">
            <asp:UpdatePanel ID="upContactDropDown" runat="server">
                <ContentTemplate>
                    <act:AutoCompleteExtender ID="aceParentBusiness" runat="server" ServicePath="~/WebServices/Services.asmx" ServiceMethod="GetBusinessNameList" MinimumPrefixLength="3" TargetControlID="tbBusinessName" CompletionSetCount="10" ></act:AutoCompleteExtender>
                    <div class="form_fields clearfix">
		                <div class="form_label"><label>Business name</label> <span class="required">&bull;</span></div>
		                <div class="form_input">
                            <asp:TextBox ID="tbBusinessName" AutoComplete="Off" AutoPostBack="false" runat="server" CssClass="biz_name_field"></asp:TextBox>
                            <div class="form_formatlabel">(start typing to auto-populate)</div>
                            <asp:RequiredFieldValidator ID="rfvBusinessName" runat="server" ControlToValidate="tbBusinessName" 
                            ErrorMessage="Business is a required field." Display="Dynamic" />
                            <asp:CustomValidator ID="cvBusinessName" runat="server" ControlToValidate="tbBusinessName"
                                ErrorMessage="The business does not exist." Display="Dynamic" 
                                onservervalidate="cvBusinessName_ServerValidate" /><br />
                            <asp:Button ID="btnGetContacts" runat="server" Text="Get Contacts" OnClick="btnGetContacts_onClick" CausesValidation="false" />
                        </div>
                        
	                </div>
       
                    <div class="form_fields clearfix">
		                <div class="form_label"><label>Contact</label> <span class="required">&bull;</span></div>
		                <div id="dvContactSelect" class="form_input" runat="server" visible="false"><asp:DropDownList ID="ddlContact" runat="server"></asp:DropDownList></div>
                        <div id="dvNoBusiness" class="form_label" runat="server">Select a business above</div>
                        <div id="dvNoContacts" class="form_label" runat="server" visible="false">The selected business has no contacts</div>
                        <asp:RequiredFieldValidator ID="rfvContact" runat="server" ControlToValidate="ddlContact" 
                            ErrorMessage="Contact is a required field." Display="Dynamic" />
	                </div>
                </ContentTemplate>
            </asp:UpdatePanel>
            <div class="fieldset clearfix">
                <div class="form_left">
                    <asp:UpdatePanel ID="upProductName" runat="server">
                        <ContentTemplate>
                            <div class="form_fields clearfix">
			                    <div class="form_label"><label>Product name</label> <span class="required">&bull;</span></div>
			                    <div class="form_input"><asp:TextBox ID="tbProductName" runat="server" MaxLength="200" AutoPostBack="true"></asp:TextBox></div>
                                <asp:RequiredFieldValidator ID="rfvProductName" runat="server" ControlToValidate="tbProductName" 
                                    ErrorMessage="Product Name is a required field." Display="Dynamic" />
                                <asp:PlaceHolder ID="plcProductExists" runat="server" Visible="false"><div class="warning ui-corner-all">A Product with this name already exists. <asp:HyperLink ID="lnkViewProduct" runat="server">View Product</asp:HyperLink></div></asp:PlaceHolder>
                                <asp:PlaceHolder ID="plcProductsExist" runat="server" Visible="false"><div class="warning ui-corner-all">More than one product with the same name already exists. Use product search to find these products if you would like to view them.</div></asp:PlaceHolder>
		                    </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <div class="form_fields clearfix">
			            <div class="form_label"><label>Product type</label> <span class="required">&bull;</span></div>
			            <div class="form_input"><asp:DropDownList ID="ddlProductType" runat="server"></asp:DropDownList></div>
                        <asp:RequiredFieldValidator ID="rfvProductType" runat="server" ControlToValidate="ddlProductType" 
                            ErrorMessage="Product Type is a required field." Display="Dynamic" />
		            </div>
					<div class="form_fields clearfix">
			            <div class="form_label"><label>Email</label></div>
			            <div class="form_input"><asp:TextBox ID="tbEmail" runat="server" MaxLength="100"></asp:TextBox></div>
                        <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="tbEmail" ValidationExpression="^.+@([a-z]|[A-Z]|\d|-)+([a-z]|[A-Z]|\d|-|\.)*\.{1}([a-z]|[A-Z]|\d|-|\.|/)+$"
                            ErrorMessage="The specified email address is not a valid format." Display="Dynamic" />
		            </div>
                    <div class="form_fields clearfix">
			            <div class="form_label"><label>Website</label></div>
			            <div class="form_input"><asp:TextBox ID="tbWebsite" runat="server" MaxLength="200"></asp:TextBox><a id="lnkCheckWebsite">Check URL</a></div>
                        <asp:RegularExpressionValidator ID="revWeb" runat="server" ControlToValidate="tbWebsite" ValidationExpression="^(https?://)?([a-z]|[A-Z]|\d|-|\.|\~)*\.{1}([a-z]|[A-Z]|\d|-|\.|\~|/)+$"
                            ErrorMessage="The specified web address is not a valid format." Display="Dynamic" />
		            </div>
                    <div class="form_fields clearfix">
			            <div class="form_label"><label>Telephone</label></div>
			            <div class="form_input"><asp:TextBox ID="tbTelephone" runat="server" MaxLength="100" CssClass="phone_field"></asp:TextBox></div>
                        <asp:RegularExpressionValidator ID="revPhone" runat="server" ControlToValidate="tbTelephone" ValidationExpression="^\d{3}-\d{3}-\d{4}.*"
                            ErrorMessage="Telephone must have a phone number at the beginning of the field in the format of 902-555-5555." Display="Dynamic" />
		            </div>
                    <div class="form_fields clearfix">
			            <div class="form_label"><label>Toll-free</label></div>
			            <div class="form_input"><asp:TextBox ID="tbTollFree" runat="server" MaxLength="100" CssClass="phone_field"></asp:TextBox></div>
		            </div>
                    <div class="form_fields clearfix">
			            <div class="form_label"><label>Fax</label></div>
			            <div class="form_input"><asp:TextBox ID="tbFax" runat="server" MaxLength="100" CssClass="phone_field"></asp:TextBox></div>
		            </div>
                </div>
                <div class="form_right">
                    <div class="form_fields clearfix">
			            <div class="form_label"><label>Proprietor</label></div>
			            <div class="form_input"><asp:TextBox ID="tbProprietor" runat="server" MaxLength="100"></asp:TextBox></div>
		            </div>
                    <div class="form_fields clearfix">
			            <div class="form_label"><label>Address 1</label></div>
			            <div class="form_input"><asp:TextBox ID="tbLine1" runat="server" MaxLength="100"></asp:TextBox></div>
		            </div>
                    <div class="form_fields clearfix">
			            <div class="form_label"><label>Address 2</label></div>
			            <div class="form_input"><asp:TextBox ID="tbLine2" runat="server" MaxLength="100"></asp:TextBox></div>
		            </div>
                    <div class="form_fields clearfix">
			            <div class="form_label"><label>Address 3</label></div>
			            <div class="form_input"><asp:TextBox ID="tbLine3" runat="server" MaxLength="100"></asp:TextBox></div>
		            </div>
                    <div class="form_fields clearfix">
			            <div class="form_label"><label>City/Community</label></div>
			            <div class="form_input">
                            <asp:DropDownList ID="ddlCommunity" runat="server" AppendDataBoundItems="true">
                                <asp:ListItem Value="">Please Select</asp:ListItem>
                            </asp:DropDownList>
                        </div>
		            </div>
                     <div class="form_fields clearfix">
			            <div class="form_label"><label>Province</label></div>
			            <div class="form_input">Nova Scotia</div>
		            </div>
                    <div class="form_fields clearfix">
			            <div class="form_label"><label>Postal code</label></div>
			            <div class="form_input"><asp:TextBox ID="tbPostalCode" runat="server" MaxLength="10" CssClass="postal_field"></asp:TextBox></div>
                        <div class="form_formatlabel">(B3L 3H8)</div>
                        <asp:RegularExpressionValidator ID="revPostalCode" runat="server" ControlToValidate="tbPostalCode" 
                                        ErrorMessage="Please ensure that the Postal code is in the correct format." Display="Dynamic" ValidationGroup="vgContact" 
                                        ValidationExpression="^[A-Z|a-z]{1}\d{1}[A-Z|a-z]{1}\s?\d{1}[A-Z|a-z]{1}\d{1}$" />
		            </div>
                </div>
            </div>
        </div>
    </div>
    <div class="add_btn_bar">
        <asp:Button ID="btnProductSubmit" runat="server" Text="Add product" OnClick="btnProductSubmit_onClick" CssClass="submit_btn" />
    </div>
    
</asp:Content> 
