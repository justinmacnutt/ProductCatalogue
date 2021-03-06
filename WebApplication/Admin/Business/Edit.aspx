﻿<%@ Page Language="C#" MasterPageFile="~/prodCat.master" AutoEventWireup="true" CodeBehind="Edit.aspx.cs" Inherits="WebApplication.Admin.Business.Edit" %>
<%@ Import Namespace="ProductCatalogue.DataAccess.Enumerations" %>
<%@ Import Namespace="WebApplication.Utilities" %>

<asp:Content ID="cHeadContent" ContentPlaceHolderID="cphHeadContent" Runat="Server"> 
    <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
    
    <script type="text/javascript">
        $(document).ready(function () {
            $("[id*=mn_business]").addClass("current");

            $("[id*=hdnPrimaryContactId]").val($("[id*=rbPrimaryContact]:checked").first().val());

            $('#accordion h4').click(function () {
                $(this).children('span').toggleClass('ui-icon-triangle-1-e').toggleClass('ui-icon-triangle-1-s');
                $(this).next().toggle(400);
                return false;
            }).next().hide();
            $("#tabs").tabs();

            InitializeEventBindings();

        });

        function InitializeEventBindings() {
        	//hide data tables when empty
        	$('table.tbl_data').each(function () {
        		if ($(this).find('tbody > tr').length == 1) {
        			$(this).parent().hide();
        		}
            });

			$("[id*=rbPrimaryContact]").click(function () {
                $("[id*=rbPrimaryContact]").attr('checked', false);
                $(this).attr('checked', true);
                $("[id*=hdnPrimaryContactId]").val($(this).val());
            });

            $("[id*=tbNoteReminderDate]").datepicker({ minDate: 0, dateFormat: 'dd-mm-yy' });

            $("[id*=lnkAddAddress]").click(function () {
                RevealAddressPanel();
            });

            $("[id*=reminderDateValue]:empty").parent().hide();

            if ($('[id*=ddlSourceAddress]').children().size() < 1) {
                $('[id*=dvCopyExistingAddress]').hide();
            }
            

            $("[id*=lnkCancelAddress]").click(function () {
                $("[id*=addressForm]").slideToggle(250);
                $("[id*=addressToggle]").toggleClass('plus').toggleClass('minus');
                $("[id*=lnkAddAddress]").html('Add Address');
                $("[id*=btnAddressSubmit]").attr('value', 'Add Address'); 
                ClearAddressForm();
            });

            $("[id*=lnkAddContact]").click(function () {
                RevealContactPanel();
            });

            $("[id*=lnkCancelContact]").click(function () {
                $("[id*=contactForm]").slideToggle(250);
                $("[id*=contactToggle]").toggleClass('plus').toggleClass('minus');
                ClearContactForm();
            });

            $("[id*=lnkAddProduct]").click(function () {
                RevealProductPanel();
            });

            $("[id*=lnkCancelProduct]").click(function () {
                $("[id*=productForm]").slideToggle(250);
                $("[id*=productToggle]").toggleClass('plus').toggleClass('minus');
                ClearProductForm();
            });

            $("[id*=lnkAddNote]").click(function () {
                RevealNotePanel();
            });

            $("[id*=lnkCancelNote]").click(function () {
                $("[id*=noteForm]").slideToggle(250);
                $("[id*=noteToggle]").toggleClass('plus').toggleClass('minus');
                ClearNoteForm();
            });

            $("[id*=ddlCountry]").change(function () {
                if (($("[id*=ddlCountry]").val() == "CA" || $("[id*=ddlCountry]").val() == "US")) {
                    $("[id*=dvOtherRegion]").hide();
                    $("[id*=dvProvinceState]").show();
                    ValidatorEnable($get("<%=revAddressPostalCode.ClientID%>"), true);
                }
                else {
                    $("[id*=dvOtherRegion]").show();
                    $("[id*=dvProvinceState]").hide();
                    ValidatorEnable($get("<%=revAddressPostalCode.ClientID%>"), false);
                }

            });

            $("[id*=ddlContactCountry]").change(function () {
                if (($("[id*=ddlContactCountry]").val() == "CA" || $("[id*=ddlContactCountry]").val() == "US")) {
                    $("[id*=dvContactOtherRegion]").hide();
                    $("[id*=dvContactProvinceState]").show();
                    ValidatorEnable($get("<%=revContactPostalCode.ClientID%>"), true);
                }
                else {
                    $("[id*=dvContactOtherRegion]").show();
                    $("[id*=dvContactProvinceState]").hide();
                    ValidatorEnable($get("<%=revContactPostalCode.ClientID%>"), false);
                }

            });

            // Add '902-' to textbox on focus
//            $("[id*=tbProductTelephone]").focus(function () {
//                if ($(this).val() == "") {
//                    $(this).val('902-');
//                }
//            });

//            $("[id*=tbWorkPhone]").focus(function () {
//                if ($(this).val() == "") {
//                    $(this).val('902-');
//                }
//            });

            // Update text remaining
            var onEditCallback = function (remaining) {
                $(this).siblings('.chars_remaining').text("(" + remaining + " characters remaining)");
            }

            // Attach maxlength function to textarea
            $('textarea[length]').limitMaxlength({
                onEdit: onEditCallback
            });

            // Check URL function
            $("[id*=lnkCheckProductWebsite]").click(function () {
                CheckUrl("tbProductWebsite");
            });
        } //end event bindings

        function CheckUrl(textbox) {
            var url = $("[id*=" + textbox + "]").val();

            if (url.substring(0, 7).toLowerCase() != "http://") {
                url = "http://" + url;
            }

            window.open(url);
        }

        function RevealAddressPanel() {
        	if ($("[id*=addressForm]").is(':hidden')) {
        		$("[id*=addressToggle]").toggleClass('plus').toggleClass('minus');
        		$("[id*=addressForm]").show(250);
        	}

        	if (($("[id*=ddlCountry]").val() == "CA" || $("[id*=ddlCountry]").val() == "US")) {
        		$("[id*=dvOtherRegion]").hide();
        		$("[id*=dvProvinceState]").show();
        		ValidatorEnable($get("<%=revAddressPostalCode.ClientID%>"), true);
        	}
        	else {
        		$("[id*=dvOtherRegion]").show();
        		$("[id*=dvProvinceState]").hide();
        		ValidatorEnable($get("<%=revAddressPostalCode.ClientID%>"), false);
        	}

        	return false;
        }

        function ClearAddressForm() {
        	$("[id*=ddlAddressType]").val('');
        	$("[id*=tbLine1]").val('');
        	$("[id*=tbLine2]").val('');
        	$("[id*=tbLine3]").val('');
        	$("[id*=tbCity]").val('');
        	$("[id*=tbPostalCode]").val('');
        	$("[id*=hdnAddressId]").val('');

        	$("[id*=tbOtherRegion]").val('');
        	$("[id*=ddlProvinceState]").val('NS');
        	$("[id*=ddlCountry]").val('CA');

        	// Hide validator messages.
        	$("[id*=rfvAddress]").css('display', 'none')
        	$("[id*=revAddress]").css('display', 'none')
        }

        function RevealContactPanel() {
        	if ($("[id*=contactForm]").is(':hidden')) {
        		$("[id*=contactToggle]").toggleClass('plus').toggleClass('minus');
        		$("[id*=contactForm]").show(250);
        	}

        	if (($("[id*=ddlContactCountry]").val() == "CA" || $("[id*=ddlContactCountry]").val() == "US")) {
        		$("[id*=dvContactOtherRegion]").hide();
        		$("[id*=dvContactProvinceState]").show();
        		ValidatorEnable($get("<%=revContactPostalCode.ClientID%>"), true);
        	}
        	else {
        		$("[id*=dvContactOtherRegion]").show();
        		$("[id*=dvContactProvinceState]").hide();
        		ValidatorEnable($get("<%=revContactPostalCode.ClientID%>"), false);
        	}

        	return false;
        }

        function ClearContactForm() {
        	//            alert("HERE");
        	$("[id*=ddlContactType]").val('');
        	$("[id*=tbFirstName]").val('');
        	$("[id*=tbLastName]").val('');
        	$("[id*=tbJobTitle]").val('');
        	$("[id*=tbEmail]").val('');
        	$("[id*=tbComment]").val('');
        	$("[id*=tbWorkPhone]").val('');
        	$("[id*=tbMobile]").val('');
        	$("[id*=tbFax]").val('');

        	$("[id*=ddlContactAddressType]").val('');
        	$("[id*=tbContactLine1]").val('');
        	$("[id*=tbContactLine2]").val('');
        	$("[id*=tbContactLine3]").val('');
        	$("[id*=tbContactCity]").val('');
        	$("[id*=tbContactPostalCode]").val('');
        	$("[id*=ddlContactProvinceState]").val('NS');
        	$("[id*=ddlContactCountry]").val('CA');

        	$("[id*=dvContactOtherRegion]").hide();
        	$("[id*=dvContactProvinceState]").show();

        	$("[id*=hdnDisplayContactForm]").val('');

        	// Hide validator messages.
        	$("[id*=rfvContact]").css('display', 'none')
        	$("[id*=revContact]").css('display', 'none')
        }

        function RevealNotePanel() {
        	if ($("[id*=noteForm]").is(':hidden')) {
        		$("[id*=noteToggle]").toggleClass('plus').toggleClass('minus');
        		$("[id*=noteForm]").show(250);
        	}
        	return false;
        }

        function ClearNoteForm() {
        	$("[id*=tbNote]").val('').triggerHandler("keyup");
        	$("[id*=tbNoteReminderDate]").val('');
        }

        function RevealProductPanel() {
        	if ($("[id*=productForm]").is(':hidden')) {
        		$("[id*=productToggle]").toggleClass('plus').toggleClass('minus');
        		$("[id*=productForm]").show(250);
        	}
        	return false;
        }

        function ClearProductForm() {
        	//            alert("HERE");
        	$("[id*=ddlProductType]").val('-1');
        	$("[id*=ddlPrimaryContact]").val('');
        	$("[id*=tbProductName]").val('');
        	$("[id*=tbProductLine1]").val('');
        	$("[id*=tbProductLine2]").val('');
        	$("[id*=tbProductLine3]").val('');
        	$("[id*=tbProductCommunity]").val('');
        	$("[id*=tbProductPostalCode]").val('');
        	$("[id*=tbProductProprietor]").val('');
        	$("[id*=tbProductEmail]").val('');
        	$("[id*=tbProductWebsite]").val('');
        	$("[id*=tbProductTelephone]").val('');
        	$("[id*=tbProductTollfree]").val('');
        	$("[id*=tbProductFax]").val('');

        	// Hide validator messages.
        	$("[id*=rfvProduct]").css('display', 'none')
        	$("[id*=revProduct]").css('display', 'none')
        }

        function ConfirmDelete(e, message) {
        	if ($(e).attr('disabled') == 'disabled') {
        		return false;
        	}
        	else {
        		return confirm(message);
        	}
        }

        function ConfirmBusinessDelete() {
        	if ($("[id*=lbDeleteBusinessTop]").attr("disabled") == "disabled") {
        		return false;
        	}
        	else {
        		return confirm("Are you sure you would like to delete the business " + $("[id*=tbBusinessName]").val() + "?");
        	}
        }
     </script>
</asp:Content> 
<asp:Content ID="cMainContent" ContentPlaceHolderID="cphMainContent" Runat="Server"> 
    <div class="breadcrumb"><a href="~/Admin/Business/Index.aspx" runat="server">Business Index</a> &raquo; <strong>Modify Business</strong></div>
	
    <div class="page_header clearfix">
		<div class="action_btns"><asp:Button ID="btnSubmitTop" runat="server" Text="SAVE" OnClick="btnSubmit_onClick" CssClass="submit_btn" />  | <asp:LinkButton ID="lbDeleteBusinessTop" runat="server" OnClientClick="return ConfirmBusinessDelete()" OnClick="lbDeleteBusiness_onClick">Delete</asp:LinkButton></div>
		<h2 class="page_title">Modify Business</h2>
	</div>
	<div class="legend"><span class="required">&bull;</span> <label>indicates required field</label></div>

	<div class="form_wrap clearfix">
       
        <asp:ScriptManager ID="ScriptManager1"  runat="server"></asp:ScriptManager>
         
        <script type="text/javascript" language="javascript">
            var prm = Sys.WebForms.PageRequestManager.getInstance();

            prm.add_endRequest(function () {

                if ($("[id*=hdnAddressId]").val() != "") {
                    $("[id*=lnkAddAddress]").html('Edit Address');
                    $("[id*=btnAddressSubmit]").attr('value', 'Update Address'); 
                    RevealAddressPanel();
                }

                if ($("[id*=hdnDisplayContactForm]").val() == "1") {
                    RevealContactPanel();
                }

                InitializeEventBindings();
            });
        </script>

        <asp:HiddenField ID="hdnBusinessId" runat="server" />
        <asp:HiddenField ID="hdnPrimaryContactId" runat="server" /> 
        <div class="col_wrap clearfix">
            <div class="left_col wide">
				<div class="form_fields clearfix">
					<div class="form_label"><label>Business name</label> <span class="required">&bull;</span></div>
					<div class="form_input"><asp:TextBox ID="tbBusinessName" runat="server" MaxLength="200"></asp:TextBox></div>
					<asp:RequiredFieldValidator ID="rfvBusinessName" runat="server" ControlToValidate="tbBusinessName" 
						ErrorMessage="Business name is a required field." Display="Dynamic" />
					<asp:CustomValidator ID="cvBusinessName" runat="server" 
                        ControlToValidate="tbBusinessName" 
                        ErrorMessage="A business with the same name already exists. The value of the business name field must be unique.<br /><br />View " 
                        Display="Dynamic" onservervalidate="cvBusinessName_ServerValidate" />
                    <asp:PlaceHolder ID="plcBusiness" runat="server" Visible="false">
                        <asp:HyperLink ID="lnkBusiness" runat="server" />
                    </asp:PlaceHolder>
				</div>
			</div>
			<div class="right_col wide">
				<div class="form_fields clearfix">
					<div class="form_label"><label>Description</label></div>
					<div class="form_input"><asp:TextBox ID="tbDescription" TextMode="MultiLine" runat="server" Length="500"></asp:TextBox>
					<p class="chars_remaining">Characters remaining: 500</p></div>
				</div>
			</div>
        </div>
        <div id="tabs" class="clearfix">
            <div class="form_tabs clearfix">
                <ul class="clearfix">
                    <li class="first"><a href="#fragment-1"><span class="fr_tab">Addresses</span></a></li>
                    <li><a href="#fragment-3"><span class="fr_tab">Contacts</span></a></li>
                    <li class="last"><a href="#fragment-4"><span class="fr_tab">Products</span></a></li>
                </ul>
            </div>
            <div id="fragment-1">
                <h3>Addresses</h3>
				<asp:UpdatePanel ID="upAddress" runat="server">
				<ContentTemplate>
					<div class="fieldset">
						<table border="0" cellpadding="0" cellspacing="0" class="tbl_data">
							<tr class="tbl_header">
								<td><strong>Type</strong></td>
								<td><strong>Address 1</strong></td>
								<!-- <td><strong>Address 2</strong></td>
								<td><strong>Address 3</strong></td>  -->
								<td><strong>City/Community</strong></td>
								<td><strong>Prov/Locality</strong></td>
								<td><strong>Postal/Zip code</strong></td>
								<td><strong>Country</strong></td>
								<td style="width:15%;"><strong>Action</strong></td>
							</tr>
							<asp:Repeater ID="rptAddress" runat="server">
								<ItemTemplate>
									<tr>
										<td><%# Eval("addressType") %></td>
										<td><%# Eval("line1") %></td>
										<td><%# Eval("city") %></td>
										<td><%# Eval("provinceRegion")%></td>
										<td><%# Eval("postalCode") %></td>
										<td><%# Eval("country") %></td>
										<td><asp:LinkButton ID="btnEditAddress" CommandArgument='<%# Eval("addressId") %>' runat="server" Text="Edit" OnClick="btnEditAddress_onClick" /> | <asp:LinkButton ID="btnDeleteAddress" CommandArgument='<%# Eval("addressId") %>' OnClientClick='<%# "return ConfirmDelete(this, \"Are you sure you would like to delete the address " + Eval("line1") + "?\")" %>' runat="server" Text="Delete" OnClick="btnDeleteAddress_onClick" /></td>
									</tr>
							</ItemTemplate>
							</asp:Repeater>
						</table>
                    </div>
                    <div id="addressToggle" class="section_toggle plus"><a id="lnkAddAddress">Add Address</a></div>
                    <div id="addressForm" class="update_pnl section_body">
                        <asp:HiddenField ID="hdnAddressId" runat="server" />
                        <div class="form_left">
                            <div class="form_fields clearfix">
			                    <div class="form_label"><label>Address type</label> <span class="required">&bull;</span></div>
			                    <div class="form_input"><asp:DropDownList ID="ddlAddressType" runat="server"></asp:DropDownList></div>
                                <asp:RequiredFieldValidator ID="rfvAddressAddressType" runat="server" ControlToValidate="ddlAddressType" 
                                    ErrorMessage="Address type is a required field." Display="Dynamic" ValidationGroup="vgAddress" />
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
                        </div>
                        <div class="form_right">
                            <div class="form_fields clearfix">
			                    <div class="form_label"><label>City/Community</label> <span class="required">&bull;</span></div>
			                    <div class="form_input"><asp:TextBox ID="tbCity" runat="server" MaxLength="100"></asp:TextBox></div>
                                <asp:RequiredFieldValidator ID="rfvAddressCity" runat="server" ControlToValidate="tbCity" 
                                    ErrorMessage="City/Community is a required field." Display="Dynamic" ValidationGroup="vgAddress" />
		                    </div>
                        
                            <div id="dvProvinceState">
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>Province/State</label></div>
			                        <div class="form_input">
                                        <asp:DropDownList ID="ddlProvinceState" runat="server">
                                            <asp:ListItem value='AB'>Alberta</asp:ListItem>
                                            <asp:ListItem value='BC'>British Columbia</asp:ListItem>
                                            <asp:ListItem value='MB'>Manitoba</asp:ListItem>
                                            <asp:ListItem value='NB'>New Brunswick</asp:ListItem>
                                            <asp:ListItem value='NL'>Newfoundland and Labrador</asp:ListItem>
                                            <asp:ListItem value='NT'>Northwest Territories</asp:ListItem>
                                            <asp:ListItem value='NS' Selected="True">Nova Scotia</asp:ListItem>
                                            <asp:ListItem value='NU'>Nunavut</asp:ListItem>
                                            <asp:ListItem value='PE'>Prince Edward Island</asp:ListItem>
                                            <asp:ListItem value='SK'>Saskatchewan</asp:ListItem>
                                            <asp:ListItem value='ON'>Ontario</asp:ListItem>
                                            <asp:ListItem value='QC'>Quebec</asp:ListItem>
                                            <asp:ListItem value='YT'>Yukon</asp:ListItem>
                                            <asp:ListItem value='AL'>Alabama</asp:ListItem>
                                            <asp:ListItem value='AK'>Alaska</asp:ListItem>
                                            <asp:ListItem value='AZ'>Arizona</asp:ListItem>
                                            <asp:ListItem value='AR'>Arkansas</asp:ListItem>
                                            <asp:ListItem value='CA'>California</asp:ListItem>
                                            <asp:ListItem value='CO'>Colorado</asp:ListItem>
                                            <asp:ListItem value='CT'>Connecticut</asp:ListItem>
                                            <asp:ListItem value='DE'>Delaware</asp:ListItem>
                                            <asp:ListItem value='DC'>District of Columbia</asp:ListItem>
                                            <asp:ListItem value='FL'>Florida</asp:ListItem>
                                            <asp:ListItem value='GA'>Georgia</asp:ListItem>
                                            <asp:ListItem value='GU'>Guam</asp:ListItem>
                                            <asp:ListItem value='HI'>Hawaii</asp:ListItem>
                                            <asp:ListItem value='ID'>Idaho</asp:ListItem>
                                            <asp:ListItem value='IL'>Illinois</asp:ListItem>
                                            <asp:ListItem value='IN'>Indiana</asp:ListItem>
                                            <asp:ListItem value='IA'>Iowa</asp:ListItem>
                                            <asp:ListItem value='KS'>Kansas</asp:ListItem>
                                            <asp:ListItem value='KY'>Kentucky</asp:ListItem>
                                            <asp:ListItem value='LA'>Louisiana</asp:ListItem>
                                            <asp:ListItem value='ME'>Maine</asp:ListItem>
                                            <asp:ListItem value='MD'>Maryland</asp:ListItem>
                                            <asp:ListItem value='MA'>Massachusetts</asp:ListItem>
                                            <asp:ListItem value='MI'>Michigan</asp:ListItem>
                                            <asp:ListItem value='MN'>Minnesota</asp:ListItem>
                                            <asp:ListItem value='MS'>Mississippi</asp:ListItem>
                                            <asp:ListItem value='MO'>Missouri</asp:ListItem>
                                            <asp:ListItem value='MT'>Montana</asp:ListItem>
                                            <asp:ListItem value='NE'>Nebraska</asp:ListItem>
                                            <asp:ListItem value='NV'>Nevada</asp:ListItem>
                                            <asp:ListItem value='NH'>New Hampshire</asp:ListItem>
                                            <asp:ListItem value='NJ'>New Jersey</asp:ListItem>
                                            <asp:ListItem value='NM'>New Mexico</asp:ListItem>
                                            <asp:ListItem value='NY'>New York</asp:ListItem>
                                            <asp:ListItem value='NC'>North Carolina</asp:ListItem>
                                            <asp:ListItem value='ND'>North Dakota</asp:ListItem>
                                            <asp:ListItem value='OH'>Ohio</asp:ListItem>
                                            <asp:ListItem value='OK'>Oklahoma</asp:ListItem>
                                            <asp:ListItem value='OR'>Oregon</asp:ListItem>
                                            <asp:ListItem value='PA'>Pennyslvania</asp:ListItem>
                                            <asp:ListItem value='PR'>Puerto Rico</asp:ListItem>
                                            <asp:ListItem value='RI'>Rhode Island</asp:ListItem>
                                            <asp:ListItem value='SC'>South Carolina</asp:ListItem>
                                            <asp:ListItem value='SD'>South Dakota</asp:ListItem>
                                            <asp:ListItem value='TN'>Tennessee</asp:ListItem>
                                            <asp:ListItem value='TX'>Texas</asp:ListItem>
                                            <asp:ListItem value='UT'>Utah</asp:ListItem>
                                            <asp:ListItem value='VT'>Vermont</asp:ListItem>
                                            <asp:ListItem value='VA'>Virginia</asp:ListItem>
                                            <asp:ListItem value='VI'>Virgin Islands</asp:ListItem>
                                            <asp:ListItem value='WA'>Washington</asp:ListItem>
                                            <asp:ListItem value='WV'>West Virginia</asp:ListItem>
                                            <asp:ListItem value='WI'>Wisconsin</asp:ListItem>
                                            <asp:ListItem value='WY'>Wyoming</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>

                            <div id="dvOtherRegion" style="display:none;">
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>Locality</label></div>
			                        <div class="form_input"><asp:TextBox ID="tbOtherRegion" runat="server" MaxLength="100"></asp:TextBox></div>
		                        </div>
                            </div>

                            <div class="form_fields clearfix">
			                    <div class="form_label"><label>Country</label></div>
			                    <div class="form_input">
                                    <asp:DropDownList ID="ddlCountry" runat="server">
                                        <asp:ListItem value="CA" Selected="True">Canada</asp:ListItem>
                                        <asp:ListItem value="US">United States</asp:ListItem>
                                        <asp:ListItem value="AF">Afghanistan</asp:ListItem>
                                        <asp:ListItem value="AX">Åland Islands</asp:ListItem>
                                        <asp:ListItem value="AL">Albania</asp:ListItem>
                                        <asp:ListItem value="DZ">Algeria</asp:ListItem>
                                        <asp:ListItem value="AS">American Samoa</asp:ListItem>
                                        <asp:ListItem value="AD">Andorra</asp:ListItem>
                                        <asp:ListItem value="AO">Angola</asp:ListItem>
                                        <asp:ListItem value="AI">Anguilla</asp:ListItem>
                                        <asp:ListItem value="AQ">Antarctica</asp:ListItem>
                                        <asp:ListItem value="AG">Antigua and Barbuda</asp:ListItem>
                                        <asp:ListItem value="AR">Argentina</asp:ListItem>
                                        <asp:ListItem value="AM">Armenia</asp:ListItem>
                                        <asp:ListItem value="AW">Aruba</asp:ListItem>
                                        <asp:ListItem value="AU">Australia</asp:ListItem>
                                        <asp:ListItem value="AT">Austria</asp:ListItem>
                                        <asp:ListItem value="AZ">Azerbaijan</asp:ListItem>
                                        <asp:ListItem value="BS">Bahamas</asp:ListItem>
                                        <asp:ListItem value="BH">Bahrain</asp:ListItem>
                                        <asp:ListItem value="BD">Bangladesh</asp:ListItem>
                                        <asp:ListItem value="BB">Barbados</asp:ListItem>
                                        <asp:ListItem value="BY">Belarus</asp:ListItem>
                                        <asp:ListItem value="BE">Belgium</asp:ListItem>
                                        <asp:ListItem value="BZ">Belize</asp:ListItem>
                                        <asp:ListItem value="BJ">Benin</asp:ListItem>
                                        <asp:ListItem value="BM">Bermuda</asp:ListItem>
                                        <asp:ListItem value="BT">Bhutan</asp:ListItem>
                                        <asp:ListItem value="BO">Bolivia, Plurinational State of</asp:ListItem>
                                        <asp:ListItem value="BQ">Bonaire, Saint Eustatius and Saba</asp:ListItem>
                                        <asp:ListItem value="BA">Bosnia and Herzegovina</asp:ListItem>
                                        <asp:ListItem value="BW">Botswana</asp:ListItem>
                                        <asp:ListItem value="BV">Bouvet Island</asp:ListItem>
                                        <asp:ListItem value="BR">Brazil</asp:ListItem>
                                        <asp:ListItem value="IO">British Indian Ocean Territory</asp:ListItem>
                                        <asp:ListItem value="BN">Brunei Darussalam</asp:ListItem>
                                        <asp:ListItem value="BG">Bulgaria</asp:ListItem>
                                        <asp:ListItem value="BF">Burkina Faso</asp:ListItem>
                                        <asp:ListItem value="BI">Burundi</asp:ListItem>
                                        <asp:ListItem value="KH">Cambodia</asp:ListItem>
                                        <asp:ListItem value="CM">Cameroon</asp:ListItem>
                                        <asp:ListItem value="CV">Cape Verde</asp:ListItem>
                                        <asp:ListItem value="KY">Cayman Islands</asp:ListItem>
                                        <asp:ListItem value="CF">Central African Republic</asp:ListItem>
                                        <asp:ListItem value="TD">Chad</asp:ListItem>
                                        <asp:ListItem value="CL">Chile</asp:ListItem>
                                        <asp:ListItem value="CN">China</asp:ListItem>
                                        <asp:ListItem value="CX">Christmas Island</asp:ListItem>
                                        <asp:ListItem value="CC">Cocos (Keeling) Islands</asp:ListItem>
                                        <asp:ListItem value="CO">Colombia</asp:ListItem>
                                        <asp:ListItem value="KM">Comoros</asp:ListItem>
                                        <asp:ListItem value="CG">Congo</asp:ListItem>
                                        <asp:ListItem value="CD">Congo, The Democratic Republic of the</asp:ListItem>
                                        <asp:ListItem value="CK">Cook Islands</asp:ListItem>
                                        <asp:ListItem value="CR">Costa Rica</asp:ListItem>
                                        <asp:ListItem value="CI">Côte D'Ivoire</asp:ListItem>
                                        <asp:ListItem value="HR">Croatia</asp:ListItem>
                                        <asp:ListItem value="CU">Cuba</asp:ListItem>
                                        <asp:ListItem value="CW">Curaçao</asp:ListItem>
                                        <asp:ListItem value="CY">Cyprus</asp:ListItem>
                                        <asp:ListItem value="CZ">Czech Republic</asp:ListItem>
                                        <asp:ListItem value="DK">Denmark</asp:ListItem>
                                        <asp:ListItem value="DJ">Djibouti</asp:ListItem>
                                        <asp:ListItem value="DM">Dominica</asp:ListItem>
                                        <asp:ListItem value="DO">Dominican Republic</asp:ListItem>
                                        <asp:ListItem value="EC">Ecuador</asp:ListItem>
                                        <asp:ListItem value="EG">Egypt</asp:ListItem>
                                        <asp:ListItem value="SV">El Salvador</asp:ListItem>
                                        <asp:ListItem value="GQ">Equatorial Guinea</asp:ListItem>
                                        <asp:ListItem value="ER">Eritrea</asp:ListItem>
                                        <asp:ListItem value="EE">Estonia</asp:ListItem>
                                        <asp:ListItem value="ET">Ethiopia</asp:ListItem>
                                        <asp:ListItem value="FK">Falkland Islands (Malvinas)</asp:ListItem>
                                        <asp:ListItem value="FO">Faroe Islands</asp:ListItem>
                                        <asp:ListItem value="FJ">Fiji</asp:ListItem>
                                        <asp:ListItem value="FI">Finland</asp:ListItem>
                                        <asp:ListItem value="FR">France</asp:ListItem>
                                        <asp:ListItem value="GF">French Guiana</asp:ListItem>
                                        <asp:ListItem value="PF">French Polynesia</asp:ListItem>
                                        <asp:ListItem value="TF">French Southern Territories</asp:ListItem>
                                        <asp:ListItem value="GA">Gabon</asp:ListItem>
                                        <asp:ListItem value="GM">Gambia</asp:ListItem>
                                        <asp:ListItem value="GE">Georgia</asp:ListItem>
                                        <asp:ListItem value="DE">Germany</asp:ListItem>
                                        <asp:ListItem value="GH">Ghana</asp:ListItem>
                                        <asp:ListItem value="GI">Gibraltar</asp:ListItem>
                                        <asp:ListItem value="GR">Greece</asp:ListItem>
                                        <asp:ListItem value="GL">Greenland</asp:ListItem>
                                        <asp:ListItem value="GD">Grenada</asp:ListItem>
                                        <asp:ListItem value="GP">Guadeloupe</asp:ListItem>
                                        <asp:ListItem value="GU">Guam</asp:ListItem>
                                        <asp:ListItem value="GT">Guatemala</asp:ListItem>
                                        <asp:ListItem value="GG">Guernsey</asp:ListItem>
                                        <asp:ListItem value="GN">Guinea</asp:ListItem>
                                        <asp:ListItem value="GW">Guinea-Bissau</asp:ListItem>
                                        <asp:ListItem value="GY">Guyana</asp:ListItem>
                                        <asp:ListItem value="HT">Haiti</asp:ListItem>
                                        <asp:ListItem value="HM">Heard Island and Mcdonald Islands</asp:ListItem>
                                        <asp:ListItem value="VA">Holy See (Vatican City State)</asp:ListItem>
                                        <asp:ListItem value="HN">Honduras</asp:ListItem>
                                        <asp:ListItem value="HK">Hong Kong</asp:ListItem>
                                        <asp:ListItem value="HU">Hungary</asp:ListItem>
                                        <asp:ListItem value="IS">Iceland</asp:ListItem>
                                        <asp:ListItem value="IN">India</asp:ListItem>
                                        <asp:ListItem value="ID">Indonesia</asp:ListItem>
                                        <asp:ListItem value="IR">Iran, Islamic Republic of</asp:ListItem>
                                        <asp:ListItem value="IQ">Iraq</asp:ListItem>
                                        <asp:ListItem value="IE">Ireland</asp:ListItem>
                                        <asp:ListItem value="IM">Isle of Man</asp:ListItem>
                                        <asp:ListItem value="IL">Israel</asp:ListItem>
                                        <asp:ListItem value="IT">Italy</asp:ListItem>
                                        <asp:ListItem value="JM">Jamaica</asp:ListItem>
                                        <asp:ListItem value="JP">Japan</asp:ListItem>
                                        <asp:ListItem value="JE">Jersey</asp:ListItem>
                                        <asp:ListItem value="JO">Jordan</asp:ListItem>
                                        <asp:ListItem value="KZ">Kazakhstan</asp:ListItem>
                                        <asp:ListItem value="KE">Kenya</asp:ListItem>
                                        <asp:ListItem value="KI">Kiribati</asp:ListItem>
                                        <asp:ListItem value="KP">Korea, Democratic People'S Republic of</asp:ListItem>
                                        <asp:ListItem value="KR">Korea, Republic of</asp:ListItem>
                                        <asp:ListItem value="KW">Kuwait</asp:ListItem>
                                        <asp:ListItem value="KG">Kyrgyzstan</asp:ListItem>
                                        <asp:ListItem value="LA">Lao People'S Democratic Republic</asp:ListItem>
                                        <asp:ListItem value="LV">Latvia</asp:ListItem>
                                        <asp:ListItem value="LB">Lebanon</asp:ListItem>
                                        <asp:ListItem value="LS">Lesotho</asp:ListItem>
                                        <asp:ListItem value="LR">Liberia</asp:ListItem>
                                        <asp:ListItem value="LY">Libyan Arab Jamahiriya</asp:ListItem>
                                        <asp:ListItem value="LI">Liechtenstein</asp:ListItem>
                                        <asp:ListItem value="LT">Lithuania</asp:ListItem>
                                        <asp:ListItem value="LU">Luxembourg</asp:ListItem>
                                        <asp:ListItem value="MO">Macao</asp:ListItem>
                                        <asp:ListItem value="MK">Macedonia, The Former Yugoslav Republic of</asp:ListItem>
                                        <asp:ListItem value="MG">Madagascar</asp:ListItem>
                                        <asp:ListItem value="MW">Malawi</asp:ListItem>
                                        <asp:ListItem value="MY">Malaysia</asp:ListItem>
                                        <asp:ListItem value="MV">Maldives</asp:ListItem>
                                        <asp:ListItem value="ML">Mali</asp:ListItem>
                                        <asp:ListItem value="MT">Malta</asp:ListItem>
                                        <asp:ListItem value="MH">Marshall Islands</asp:ListItem>
                                        <asp:ListItem value="MQ">Martinique</asp:ListItem>
                                        <asp:ListItem value="MR">Mauritania</asp:ListItem>
                                        <asp:ListItem value="MU">Mauritius</asp:ListItem>
                                        <asp:ListItem value="YT">Mayotte</asp:ListItem>
                                        <asp:ListItem value="MX">Mexico</asp:ListItem>
                                        <asp:ListItem value="FM">Micronesia, Federated States of</asp:ListItem>
                                        <asp:ListItem value="MD">Moldova, Republic of</asp:ListItem>
                                        <asp:ListItem value="MC">Monaco</asp:ListItem>
                                        <asp:ListItem value="MN">Mongolia</asp:ListItem>
                                        <asp:ListItem value="ME">Montenegro</asp:ListItem>
                                        <asp:ListItem value="MS">Montserrat</asp:ListItem>
                                        <asp:ListItem value="MA">Morocco</asp:ListItem>
                                        <asp:ListItem value="MZ">Mozambique</asp:ListItem>
                                        <asp:ListItem value="MM">Myanmar</asp:ListItem>
                                        <asp:ListItem value="NA">Namibia</asp:ListItem>
                                        <asp:ListItem value="NR">Nauru</asp:ListItem>
                                        <asp:ListItem value="NP">Nepal</asp:ListItem>
                                        <asp:ListItem value="NL">Netherlands</asp:ListItem>
                                        <asp:ListItem value="NC">New Caledonia</asp:ListItem>
                                        <asp:ListItem value="NZ">New Zealand</asp:ListItem>
                                        <asp:ListItem value="NI">Nicaragua</asp:ListItem>
                                        <asp:ListItem value="NE">Niger</asp:ListItem>
                                        <asp:ListItem value="NG">Nigeria</asp:ListItem>
                                        <asp:ListItem value="NU">Niue</asp:ListItem>
                                        <asp:ListItem value="NF">Norfolk Island</asp:ListItem>
                                        <asp:ListItem value="MP">Northern Mariana Islands</asp:ListItem>
                                        <asp:ListItem value="NO">Norway</asp:ListItem>
                                        <asp:ListItem value="OM">Oman</asp:ListItem>
                                        <asp:ListItem value="PK">Pakistan</asp:ListItem>
                                        <asp:ListItem value="PW">Palau</asp:ListItem>
                                        <asp:ListItem value="PS">Palestinian Territory, Occupied</asp:ListItem>
                                        <asp:ListItem value="PA">Panama</asp:ListItem>
                                        <asp:ListItem value="PG">Papua New Guinea</asp:ListItem>
                                        <asp:ListItem value="PY">Paraguay</asp:ListItem>
                                        <asp:ListItem value="PE">Peru</asp:ListItem>
                                        <asp:ListItem value="PH">Philippines</asp:ListItem>
                                        <asp:ListItem value="PN">Pitcairn</asp:ListItem>
                                        <asp:ListItem value="PL">Poland</asp:ListItem>
                                        <asp:ListItem value="PT">Portugal</asp:ListItem>
                                        <asp:ListItem value="PR">Puerto Rico</asp:ListItem>
                                        <asp:ListItem value="QA">Qatar</asp:ListItem>
                                        <asp:ListItem value="RE">Réunion</asp:ListItem>
                                        <asp:ListItem value="RO">Romania</asp:ListItem>
                                        <asp:ListItem value="RU">Russian Federation</asp:ListItem>
                                        <asp:ListItem value="RW">Rwanda</asp:ListItem>
                                        <asp:ListItem value="BL">Saint Barthélemy</asp:ListItem>
                                        <asp:ListItem value="SH">Saint Helena, Ascension and Tristan Da Cunha</asp:ListItem>
                                        <asp:ListItem value="KN">Saint Kitts and Nevis</asp:ListItem>
                                        <asp:ListItem value="LC">Saint Lucia</asp:ListItem>
                                        <asp:ListItem value="MF">Saint Martin (French Part)</asp:ListItem>
                                        <asp:ListItem value="PM">Saint Pierre and Miquelon</asp:ListItem>
                                        <asp:ListItem value="VC">Saint Vincent and the Grenadines</asp:ListItem>
                                        <asp:ListItem value="WS">Samoa</asp:ListItem>
                                        <asp:ListItem value="SM">San Marino</asp:ListItem>
                                        <asp:ListItem value="ST">Sao Tome and Principe</asp:ListItem>
                                        <asp:ListItem value="SA">Saudi Arabia</asp:ListItem>
                                        <asp:ListItem value="SN">Senegal</asp:ListItem>
                                        <asp:ListItem value="RS">Serbia</asp:ListItem>
                                        <asp:ListItem value="SC">Seychelles</asp:ListItem>
                                        <asp:ListItem value="SL">Sierra Leone</asp:ListItem>
                                        <asp:ListItem value="SG">Singapore</asp:ListItem>
                                        <asp:ListItem value="SX">Sint Maarten (Dutch Part)</asp:ListItem>
                                        <asp:ListItem value="SK">Slovakia</asp:ListItem>
                                        <asp:ListItem value="SI">Slovenia</asp:ListItem>
                                        <asp:ListItem value="SB">Solomon Islands</asp:ListItem>
                                        <asp:ListItem value="SO">Somalia</asp:ListItem>
                                        <asp:ListItem value="ZA">South Africa</asp:ListItem>
                                        <asp:ListItem value="GS">South Georgia and the South Sandwich Islands</asp:ListItem>
                                        <asp:ListItem value="ES">Spain</asp:ListItem>
                                        <asp:ListItem value="LK">Sri Lanka</asp:ListItem>
                                        <asp:ListItem value="SD">Sudan</asp:ListItem>
                                        <asp:ListItem value="SR">Suriname</asp:ListItem>
                                        <asp:ListItem value="SJ">Svalbard and Jan Mayen</asp:ListItem>
                                        <asp:ListItem value="SZ">Swaziland</asp:ListItem>
                                        <asp:ListItem value="SE">Sweden</asp:ListItem>
                                        <asp:ListItem value="CH">Switzerland</asp:ListItem>
                                        <asp:ListItem value="SY">Syrian Arab Republic</asp:ListItem>
                                        <asp:ListItem value="TW">Taiwan, Province of China</asp:ListItem>
                                        <asp:ListItem value="TJ">Tajikistan</asp:ListItem>
                                        <asp:ListItem value="TZ">Tanzania, United Republic of</asp:ListItem>
                                        <asp:ListItem value="TH">Thailand</asp:ListItem>
                                        <asp:ListItem value="TL">Timor-Leste</asp:ListItem>
                                        <asp:ListItem value="TG">Togo</asp:ListItem>
                                        <asp:ListItem value="TK">Tokelau</asp:ListItem>
                                        <asp:ListItem value="TO">Tonga</asp:ListItem>
                                        <asp:ListItem value="TT">Trinidad and Tobago</asp:ListItem>
                                        <asp:ListItem value="TN">Tunisia</asp:ListItem>
                                        <asp:ListItem value="TR">Turkey</asp:ListItem>
                                        <asp:ListItem value="TM">Turkmenistan</asp:ListItem>
                                        <asp:ListItem value="TC">Turks and Caicos Islands</asp:ListItem>
                                        <asp:ListItem value="TV">Tuvalu</asp:ListItem>
                                        <asp:ListItem value="UG">Uganda</asp:ListItem>
                                        <asp:ListItem value="UA">Ukraine</asp:ListItem>
                                        <asp:ListItem value="AE">United Arab Emirates</asp:ListItem>
                                        <asp:ListItem value="GB">United Kingdom</asp:ListItem>
                                        <asp:ListItem value="UM">United States Minor Outlying Islands</asp:ListItem>
                                        <asp:ListItem value="UY">Uruguay</asp:ListItem>
                                        <asp:ListItem value="UZ">Uzbekistan</asp:ListItem>
                                        <asp:ListItem value="VU">Vanuatu</asp:ListItem>
                                        <asp:ListItem value="VE">Venezuela, Bolivarian Republic of</asp:ListItem>
                                        <asp:ListItem value="VN">Viet Nam</asp:ListItem>
                                        <asp:ListItem value="VG">Virgin Islands, British</asp:ListItem>
                                        <asp:ListItem value="VI">Virgin Islands, U.S.</asp:ListItem>
                                        <asp:ListItem value="WF">Wallis and Futuna</asp:ListItem>
                                        <asp:ListItem value="EH">Western Sahara</asp:ListItem>
                                        <asp:ListItem value="YE">Yemen</asp:ListItem>
                                        <asp:ListItem value="ZM">Zambia</asp:ListItem>
                                        <asp:ListItem value="ZW">Zimbabwe</asp:ListItem>
                                    </asp:DropDownList>
                                 </div>
		                    </div>

                            <div class="form_fields clearfix">
			                    <div class="form_label"><label>Postal/Zip code</label></div>
			                    <div class="form_input"><asp:TextBox ID="tbPostalCode" runat="server" MaxLength="20" CssClass="postal_field"></asp:TextBox></div>
                                <div class="form_formatlabel">(B3L 3H8 or 60622)</div>
                                <asp:RegularExpressionValidator ID="revAddressPostalCode" runat="server" ControlToValidate="tbPostalCode" 
                                    ErrorMessage="Please ensure that the Postal/Zip code is in the correct format." Display="Dynamic" ValidationGroup="vgAddress" 
                                    ValidationExpression="^[A-Z|a-z]{1}\d{1}[A-Z|a-z]{1}\s?\d{1}[A-Z|a-z]{1}\d{1}|\d{5}$" />
		                    </div>
                        </div>
                        
                        
                        
                        <div class="update_btn_bar">
                            <asp:Button ID="btnAddressSubmit" runat="server" Text="Add Address" OnClick="btnAddressSubmit_onClick" CssClass="update_btn" ValidationGroup="vgAddress" /> | <a id="lnkCancelAddress" href="#">Cancel</a>
                        </div>
                    </div>
                </ContentTemplate>
                </asp:UpdatePanel>

            </div>

            <div id="fragment-3">
                <h3>Contacts</h3>
				<asp:UpdatePanel ID="upContact" runat="server">
                    <ContentTemplate>
                        <div class="fieldset">
							<table border="0" cellpadding="0" cellspacing="0" class="tbl_data">
								<tr class="tbl_header">
                                    <td style="width:5%;"><strong>Primary</strong></td>
									<td style="width:25%;"><strong>Name</strong></td>
                                    <td style="width:8%;"><strong>Type</strong></td>
									<td style="width:22%;"><strong>Title</strong></td>
									<td style="width:25%;"><strong>Email</strong></td>
									<td style="width:15%;"><strong>Action</strong></td>
								</tr>
								<asp:Repeater ID="rptContact" runat="server">
									<ItemTemplate>
										<tr>
											<td style="text-align:center;"><asp:RadioButton ID='rbPrimaryContact' Value='<%# Eval("contactId") %>' Checked='<%# (Eval("isPrimary").ToString() == "1") %>' runat="server" /></td> 
                            				<td><%# Eval("firstName") %> <%# Eval("lastName") %></td>
                                            <td><%# Eval("contactType") %></td>
											<td><%# Eval("jobTitle") %></td>
											<td><%# Eval("email") %></td>
											<td><asp:LinkButton ID="btnEditContact" CommandArgument='<%# Eval("contactId") %>' runat="server" Text="Edit" OnClick="btnEditContact_onClick" /> | <asp:LinkButton ID="btnDeleteContact" CommandArgument='<%# Eval("contactId") %>' OnClientClick='<%# (bool)Eval("enableDelete") ? "return ConfirmDelete(this, \"Are you sure you would like to delete the contact " + Eval("firstName") + " " + Eval("lastName") + "?\")" : "return false" %>' runat="server" Enabled='<%# Eval("enableDelete") %>' Text="Delete" OnClick="btnDeleteContact_onClick" /></td>
										</tr>
									</ItemTemplate>
								</asp:Repeater>
							</table>
						</div>

                        <div id="contactToggle" class="section_toggle plus"><a id="lnkAddContact">Add Contact</a></div>
                        <div id="contactForm" class="update_pnl section_body clearfix">
                            <asp:HiddenField ID="hdnDisplayContactForm" runat="server" />
                            <div class="form_left">
                                 <div class="form_fields clearfix">
			                        <div class="form_label"><label>Contact Type</label> <span class="required">&bull;</span></div>
			                        <div class="form_input"><asp:DropDownList ID="ddlBusinessContactType" runat="server"></asp:DropDownList></div>
		                        </div>
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>First name</label> <span class="required">&bull;</span></div>
			                        <div class="form_input"><asp:TextBox ID="tbFirstName" runat="server" MaxLength="50"></asp:TextBox></div>
                                    <asp:RequiredFieldValidator ID="rfvContactFirstName" runat="server" ControlToValidate="tbFirstName" 
                                        ErrorMessage="First name is a required field." Display="Dynamic" ValidationGroup="vgContact" />
		                        </div>
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>Last name</label> <span class="required">&bull;</span></div>
			                        <div class="form_input"><asp:TextBox ID="tbLastName" runat="server" MaxLength="50"></asp:TextBox></div>
                                    <asp:RequiredFieldValidator ID="rfvContactLastName" runat="server" ControlToValidate="tbLastName" 
                                        ErrorMessage="Last name is a required field." Display="Dynamic" ValidationGroup="vgContact" />
		                        </div>
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>Title</label></div>
			                        <div class="form_input"><asp:TextBox ID="tbJobTitle" runat="server" MaxLength="50"></asp:TextBox></div>
		                        </div>
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>Email</label></div>
			                        <div class="form_input"><asp:TextBox ID="tbEmail" runat="server" MaxLength="100"></asp:TextBox></div>
                                    <asp:RegularExpressionValidator ID="revContactEmail" runat="server" ControlToValidate="tbEmail" 
                                        ErrorMessage="The specified email address is not a valid format." Display="Dynamic" ValidationGroup="vgContact" 
                                        ValidationExpression="^[a-zA-Z0-9][\+\w\.-]*@[a-zA-Z0-9][\w\.-]*\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$" />
		                        </div>
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>Work phone</label> <span class="required">&bull;</span></div>
			                        <div class="form_input"><asp:TextBox ID="tbWorkPhone" runat="server" MaxLength="30" CssClass="phone_field"></asp:TextBox></div>
                                    <asp:RequiredFieldValidator ID="rfvContactWorkPhone" runat="server" ControlToValidate="tbWorkPhone" 
                                        ErrorMessage="Work phone is a required field." Display="Dynamic" ValidationGroup="vgContact" />
		                        </div>
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>Mobile</label></div>
			                        <div class="form_input"><asp:TextBox ID="tbMobile" runat="server" MaxLength="30" CssClass="phone_field"></asp:TextBox></div>
		                        </div>
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>Fax</label></div>
			                        <div class="form_input"><asp:TextBox ID="tbFax" runat="server" MaxLength="30" CssClass="phone_field"></asp:TextBox></div>
		                        </div>
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>Comment</label></div>
			                        <div class="form_input"><asp:TextBox ID="tbComment" runat="server" TextMode="MultiLine" Length="500"></asp:TextBox>
                                    <p class="chars_remaining">Characters remaining: 500</p></div>
		                        </div>
                            </div>
                            <div class="form_right">
                                <div id="dvCopyExistingAddress" class="form_fields clearfix">
			                        <div class="form_label"><label>Copy existing address</label></div>
			                        <div class="form_input">
                                        <asp:DropDownList ID="ddlSourceAddress" runat="server">
                                        </asp:DropDownList>&nbsp;
                                        <asp:Button ID="btnCopyAddress" runat="server" Text="Copy" OnClick="btnCopyAddress_onClick" />
                                    </div>
		                        </div>
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>Address type</label> <span class="required">&bull;</span></div>
			                        <div class="form_input"><asp:DropDownList ID="ddlContactAddressType" runat="server"></asp:DropDownList></div>
                                    <asp:RequiredFieldValidator ID="rfvContactAddressType2" runat="server" ControlToValidate="ddlContactAddressType" 
                                        ErrorMessage="Address type is a required field." Display="Dynamic" ValidationGroup="vgContact" />
		                        </div>
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>Address 1</label></div>
			                        <div class="form_input"><asp:TextBox ID="tbContactLine1" runat="server" MaxLength="100"></asp:TextBox></div>
		                        </div>
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>Address 2</label></div>
			                        <div class="form_input"><asp:TextBox ID="tbContactLine2" runat="server" MaxLength="100"></asp:TextBox></div>
		                        </div>
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>Address 3</label></div>
			                        <div class="form_input"><asp:TextBox ID="tbContactLine3" runat="server" MaxLength="100"></asp:TextBox></div>
		                        </div>
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>City/Community</label> <span class="required">&bull;</span></div>
			                        <div class="form_input"><asp:TextBox ID="tbContactCity" runat="server" MaxLength="100"></asp:TextBox></div>
                                    <asp:RequiredFieldValidator ID="rfvContactCity" runat="server" ControlToValidate="tbContactCity" 
                                        ErrorMessage="City/Community is a required field." Display="Dynamic" ValidationGroup="vgContact" />
		                        </div>
                                <div id="dvContactProvinceState">
                                    <div class="form_fields clearfix">
			                            <div class="form_label"><label>Province/State</label></div>
			                            <div class="form_input">
                                            <asp:DropDownList ID="ddlContactProvinceState" runat="server">
                                                <asp:ListItem value='AB'>Alberta</asp:ListItem>
                                                <asp:ListItem value='BC'>British Columbia</asp:ListItem>
                                                <asp:ListItem value='MB'>Manitoba</asp:ListItem>
                                                <asp:ListItem value='NB'>New Brunswick</asp:ListItem>
                                                <asp:ListItem value='NL'>Newfoundland and Labrador</asp:ListItem>
                                                <asp:ListItem value='NT'>Northwest Territories</asp:ListItem>
                                                <asp:ListItem value='NS' Selected="True">Nova Scotia</asp:ListItem>
                                                <asp:ListItem value='NU'>Nunavut</asp:ListItem>
                                                <asp:ListItem value='PE'>Prince Edward Island</asp:ListItem>
                                                <asp:ListItem value='SK'>Saskatchewan</asp:ListItem>
                                                <asp:ListItem value='ON'>Ontario</asp:ListItem>
                                                <asp:ListItem value='QC'>Quebec</asp:ListItem>
                                                <asp:ListItem value='YT'>Yukon</asp:ListItem>
                                                <asp:ListItem value='AL'>Alabama</asp:ListItem>
                                                <asp:ListItem value='AK'>Alaska</asp:ListItem>
                                                <asp:ListItem value='AZ'>Arizona</asp:ListItem>
                                                <asp:ListItem value='AR'>Arkansas</asp:ListItem>
                                                <asp:ListItem value='CA'>California</asp:ListItem>
                                                <asp:ListItem value='CO'>Colorado</asp:ListItem>
                                                <asp:ListItem value='CT'>Connecticut</asp:ListItem>
                                                <asp:ListItem value='DE'>Delaware</asp:ListItem>
                                                <asp:ListItem value='DC'>District of Columbia</asp:ListItem>
                                                <asp:ListItem value='FL'>Florida</asp:ListItem>
                                                <asp:ListItem value='GA'>Georgia</asp:ListItem>
                                                <asp:ListItem value='GU'>Guam</asp:ListItem>
                                                <asp:ListItem value='HI'>Hawaii</asp:ListItem>
                                                <asp:ListItem value='ID'>Idaho</asp:ListItem>
                                                <asp:ListItem value='IL'>Illinois</asp:ListItem>
                                                <asp:ListItem value='IN'>Indiana</asp:ListItem>
                                                <asp:ListItem value='IA'>Iowa</asp:ListItem>
                                                <asp:ListItem value='KS'>Kansas</asp:ListItem>
                                                <asp:ListItem value='KY'>Kentucky</asp:ListItem>
                                                <asp:ListItem value='LA'>Louisiana</asp:ListItem>
                                                <asp:ListItem value='ME'>Maine</asp:ListItem>
                                                <asp:ListItem value='MD'>Maryland</asp:ListItem>
                                                <asp:ListItem value='MA'>Massachusetts</asp:ListItem>
                                                <asp:ListItem value='MI'>Michigan</asp:ListItem>
                                                <asp:ListItem value='MN'>Minnesota</asp:ListItem>
                                                <asp:ListItem value='MS'>Mississippi</asp:ListItem>
                                                <asp:ListItem value='MO'>Missouri</asp:ListItem>
                                                <asp:ListItem value='MT'>Montana</asp:ListItem>
                                                <asp:ListItem value='NE'>Nebraska</asp:ListItem>
                                                <asp:ListItem value='NV'>Nevada</asp:ListItem>
                                                <asp:ListItem value='NH'>New Hampshire</asp:ListItem>
                                                <asp:ListItem value='NJ'>New Jersey</asp:ListItem>
                                                <asp:ListItem value='NM'>New Mexico</asp:ListItem>
                                                <asp:ListItem value='NY'>New York</asp:ListItem>
                                                <asp:ListItem value='NC'>North Carolina</asp:ListItem>
                                                <asp:ListItem value='ND'>North Dakota</asp:ListItem>
                                                <asp:ListItem value='OH'>Ohio</asp:ListItem>
                                                <asp:ListItem value='OK'>Oklahoma</asp:ListItem>
                                                <asp:ListItem value='OR'>Oregon</asp:ListItem>
                                                <asp:ListItem value='PA'>Pennyslvania</asp:ListItem>
                                                <asp:ListItem value='PR'>Puerto Rico</asp:ListItem>
                                                <asp:ListItem value='RI'>Rhode Island</asp:ListItem>
                                                <asp:ListItem value='SC'>South Carolina</asp:ListItem>
                                                <asp:ListItem value='SD'>South Dakota</asp:ListItem>
                                                <asp:ListItem value='TN'>Tennessee</asp:ListItem>
                                                <asp:ListItem value='TX'>Texas</asp:ListItem>
                                                <asp:ListItem value='UT'>Utah</asp:ListItem>
                                                <asp:ListItem value='VT'>Vermont</asp:ListItem>
                                                <asp:ListItem value='VA'>Virginia</asp:ListItem>
                                                <asp:ListItem value='VI'>Virgin Islands</asp:ListItem>
                                                <asp:ListItem value='WA'>Washington</asp:ListItem>
                                                <asp:ListItem value='WV'>West Virginia</asp:ListItem>
                                                <asp:ListItem value='WI'>Wisconsin</asp:ListItem>
                                                <asp:ListItem value='WY'>Wyoming</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
		                            </div>
                                </div>
                                <div id="dvContactOtherRegion" style="display:none;">
                                    <div class="form_fields clearfix">
			                            <div class="form_label"><label>Other region</label></div>
			                            <div class="form_input"><asp:TextBox ID="tbContactOtherRegion" runat="server" MaxLength="100"></asp:TextBox></div>
		                            </div>
                                </div>
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>Country</label></div>
			                        <div class="form_input">
                                        <asp:DropDownList ID="ddlContactCountry" runat="server">
                                            <asp:ListItem value="CA" Selected="True">Canada</asp:ListItem>
                                            <asp:ListItem value="US">United States</asp:ListItem>
                                            <asp:ListItem value="AF">Afghanistan</asp:ListItem>
                                            <asp:ListItem value="AX">Åland Islands</asp:ListItem>
                                            <asp:ListItem value="AL">Albania</asp:ListItem>
                                            <asp:ListItem value="DZ">Algeria</asp:ListItem>
                                            <asp:ListItem value="AS">American Samoa</asp:ListItem>
                                            <asp:ListItem value="AD">Andorra</asp:ListItem>
                                            <asp:ListItem value="AO">Angola</asp:ListItem>
                                            <asp:ListItem value="AI">Anguilla</asp:ListItem>
                                            <asp:ListItem value="AQ">Antarctica</asp:ListItem>
                                            <asp:ListItem value="AG">Antigua and Barbuda</asp:ListItem>
                                            <asp:ListItem value="AR">Argentina</asp:ListItem>
                                            <asp:ListItem value="AM">Armenia</asp:ListItem>
                                            <asp:ListItem value="AW">Aruba</asp:ListItem>
                                            <asp:ListItem value="AU">Australia</asp:ListItem>
                                            <asp:ListItem value="AT">Austria</asp:ListItem>
                                            <asp:ListItem value="AZ">Azerbaijan</asp:ListItem>
                                            <asp:ListItem value="BS">Bahamas</asp:ListItem>
                                            <asp:ListItem value="BH">Bahrain</asp:ListItem>
                                            <asp:ListItem value="BD">Bangladesh</asp:ListItem>
                                            <asp:ListItem value="BB">Barbados</asp:ListItem>
                                            <asp:ListItem value="BY">Belarus</asp:ListItem>
                                            <asp:ListItem value="BE">Belgium</asp:ListItem>
                                            <asp:ListItem value="BZ">Belize</asp:ListItem>
                                            <asp:ListItem value="BJ">Benin</asp:ListItem>
                                            <asp:ListItem value="BM">Bermuda</asp:ListItem>
                                            <asp:ListItem value="BT">Bhutan</asp:ListItem>
                                            <asp:ListItem value="BO">Bolivia, Plurinational State of</asp:ListItem>
                                            <asp:ListItem value="BQ">Bonaire, Saint Eustatius and Saba</asp:ListItem>
                                            <asp:ListItem value="BA">Bosnia and Herzegovina</asp:ListItem>
                                            <asp:ListItem value="BW">Botswana</asp:ListItem>
                                            <asp:ListItem value="BV">Bouvet Island</asp:ListItem>
                                            <asp:ListItem value="BR">Brazil</asp:ListItem>
                                            <asp:ListItem value="IO">British Indian Ocean Territory</asp:ListItem>
                                            <asp:ListItem value="BN">Brunei Darussalam</asp:ListItem>
                                            <asp:ListItem value="BG">Bulgaria</asp:ListItem>
                                            <asp:ListItem value="BF">Burkina Faso</asp:ListItem>
                                            <asp:ListItem value="BI">Burundi</asp:ListItem>
                                            <asp:ListItem value="KH">Cambodia</asp:ListItem>
                                            <asp:ListItem value="CM">Cameroon</asp:ListItem>
                                            <asp:ListItem value="CV">Cape Verde</asp:ListItem>
                                            <asp:ListItem value="KY">Cayman Islands</asp:ListItem>
                                            <asp:ListItem value="CF">Central African Republic</asp:ListItem>
                                            <asp:ListItem value="TD">Chad</asp:ListItem>
                                            <asp:ListItem value="CL">Chile</asp:ListItem>
                                            <asp:ListItem value="CN">China</asp:ListItem>
                                            <asp:ListItem value="CX">Christmas Island</asp:ListItem>
                                            <asp:ListItem value="CC">Cocos (Keeling) Islands</asp:ListItem>
                                            <asp:ListItem value="CO">Colombia</asp:ListItem>
                                            <asp:ListItem value="KM">Comoros</asp:ListItem>
                                            <asp:ListItem value="CG">Congo</asp:ListItem>
                                            <asp:ListItem value="CD">Congo, The Democratic Republic of the</asp:ListItem>
                                            <asp:ListItem value="CK">Cook Islands</asp:ListItem>
                                            <asp:ListItem value="CR">Costa Rica</asp:ListItem>
                                            <asp:ListItem value="CI">Côte D'Ivoire</asp:ListItem>
                                            <asp:ListItem value="HR">Croatia</asp:ListItem>
                                            <asp:ListItem value="CU">Cuba</asp:ListItem>
                                            <asp:ListItem value="CW">Curaçao</asp:ListItem>
                                            <asp:ListItem value="CY">Cyprus</asp:ListItem>
                                            <asp:ListItem value="CZ">Czech Republic</asp:ListItem>
                                            <asp:ListItem value="DK">Denmark</asp:ListItem>
                                            <asp:ListItem value="DJ">Djibouti</asp:ListItem>
                                            <asp:ListItem value="DM">Dominica</asp:ListItem>
                                            <asp:ListItem value="DO">Dominican Republic</asp:ListItem>
                                            <asp:ListItem value="EC">Ecuador</asp:ListItem>
                                            <asp:ListItem value="EG">Egypt</asp:ListItem>
                                            <asp:ListItem value="SV">El Salvador</asp:ListItem>
                                            <asp:ListItem value="GQ">Equatorial Guinea</asp:ListItem>
                                            <asp:ListItem value="ER">Eritrea</asp:ListItem>
                                            <asp:ListItem value="EE">Estonia</asp:ListItem>
                                            <asp:ListItem value="ET">Ethiopia</asp:ListItem>
                                            <asp:ListItem value="FK">Falkland Islands (Malvinas)</asp:ListItem>
                                            <asp:ListItem value="FO">Faroe Islands</asp:ListItem>
                                            <asp:ListItem value="FJ">Fiji</asp:ListItem>
                                            <asp:ListItem value="FI">Finland</asp:ListItem>
                                            <asp:ListItem value="FR">France</asp:ListItem>
                                            <asp:ListItem value="GF">French Guiana</asp:ListItem>
                                            <asp:ListItem value="PF">French Polynesia</asp:ListItem>
                                            <asp:ListItem value="TF">French Southern Territories</asp:ListItem>
                                            <asp:ListItem value="GA">Gabon</asp:ListItem>
                                            <asp:ListItem value="GM">Gambia</asp:ListItem>
                                            <asp:ListItem value="GE">Georgia</asp:ListItem>
                                            <asp:ListItem value="DE">Germany</asp:ListItem>
                                            <asp:ListItem value="GH">Ghana</asp:ListItem>
                                            <asp:ListItem value="GI">Gibraltar</asp:ListItem>
                                            <asp:ListItem value="GR">Greece</asp:ListItem>
                                            <asp:ListItem value="GL">Greenland</asp:ListItem>
                                            <asp:ListItem value="GD">Grenada</asp:ListItem>
                                            <asp:ListItem value="GP">Guadeloupe</asp:ListItem>
                                            <asp:ListItem value="GU">Guam</asp:ListItem>
                                            <asp:ListItem value="GT">Guatemala</asp:ListItem>
                                            <asp:ListItem value="GG">Guernsey</asp:ListItem>
                                            <asp:ListItem value="GN">Guinea</asp:ListItem>
                                            <asp:ListItem value="GW">Guinea-Bissau</asp:ListItem>
                                            <asp:ListItem value="GY">Guyana</asp:ListItem>
                                            <asp:ListItem value="HT">Haiti</asp:ListItem>
                                            <asp:ListItem value="HM">Heard Island and Mcdonald Islands</asp:ListItem>
                                            <asp:ListItem value="VA">Holy See (Vatican City State)</asp:ListItem>
                                            <asp:ListItem value="HN">Honduras</asp:ListItem>
                                            <asp:ListItem value="HK">Hong Kong</asp:ListItem>
                                            <asp:ListItem value="HU">Hungary</asp:ListItem>
                                            <asp:ListItem value="IS">Iceland</asp:ListItem>
                                            <asp:ListItem value="IN">India</asp:ListItem>
                                            <asp:ListItem value="ID">Indonesia</asp:ListItem>
                                            <asp:ListItem value="IR">Iran, Islamic Republic of</asp:ListItem>
                                            <asp:ListItem value="IQ">Iraq</asp:ListItem>
                                            <asp:ListItem value="IE">Ireland</asp:ListItem>
                                            <asp:ListItem value="IM">Isle of Man</asp:ListItem>
                                            <asp:ListItem value="IL">Israel</asp:ListItem>
                                            <asp:ListItem value="IT">Italy</asp:ListItem>
                                            <asp:ListItem value="JM">Jamaica</asp:ListItem>
                                            <asp:ListItem value="JP">Japan</asp:ListItem>
                                            <asp:ListItem value="JE">Jersey</asp:ListItem>
                                            <asp:ListItem value="JO">Jordan</asp:ListItem>
                                            <asp:ListItem value="KZ">Kazakhstan</asp:ListItem>
                                            <asp:ListItem value="KE">Kenya</asp:ListItem>
                                            <asp:ListItem value="KI">Kiribati</asp:ListItem>
                                            <asp:ListItem value="KP">Korea, Democratic People'S Republic of</asp:ListItem>
                                            <asp:ListItem value="KR">Korea, Republic of</asp:ListItem>
                                            <asp:ListItem value="KW">Kuwait</asp:ListItem>
                                            <asp:ListItem value="KG">Kyrgyzstan</asp:ListItem>
                                            <asp:ListItem value="LA">Lao People'S Democratic Republic</asp:ListItem>
                                            <asp:ListItem value="LV">Latvia</asp:ListItem>
                                            <asp:ListItem value="LB">Lebanon</asp:ListItem>
                                            <asp:ListItem value="LS">Lesotho</asp:ListItem>
                                            <asp:ListItem value="LR">Liberia</asp:ListItem>
                                            <asp:ListItem value="LY">Libyan Arab Jamahiriya</asp:ListItem>
                                            <asp:ListItem value="LI">Liechtenstein</asp:ListItem>
                                            <asp:ListItem value="LT">Lithuania</asp:ListItem>
                                            <asp:ListItem value="LU">Luxembourg</asp:ListItem>
                                            <asp:ListItem value="MO">Macao</asp:ListItem>
                                            <asp:ListItem value="MK">Macedonia, The Former Yugoslav Republic of</asp:ListItem>
                                            <asp:ListItem value="MG">Madagascar</asp:ListItem>
                                            <asp:ListItem value="MW">Malawi</asp:ListItem>
                                            <asp:ListItem value="MY">Malaysia</asp:ListItem>
                                            <asp:ListItem value="MV">Maldives</asp:ListItem>
                                            <asp:ListItem value="ML">Mali</asp:ListItem>
                                            <asp:ListItem value="MT">Malta</asp:ListItem>
                                            <asp:ListItem value="MH">Marshall Islands</asp:ListItem>
                                            <asp:ListItem value="MQ">Martinique</asp:ListItem>
                                            <asp:ListItem value="MR">Mauritania</asp:ListItem>
                                            <asp:ListItem value="MU">Mauritius</asp:ListItem>
                                            <asp:ListItem value="YT">Mayotte</asp:ListItem>
                                            <asp:ListItem value="MX">Mexico</asp:ListItem>
                                            <asp:ListItem value="FM">Micronesia, Federated States of</asp:ListItem>
                                            <asp:ListItem value="MD">Moldova, Republic of</asp:ListItem>
                                            <asp:ListItem value="MC">Monaco</asp:ListItem>
                                            <asp:ListItem value="MN">Mongolia</asp:ListItem>
                                            <asp:ListItem value="ME">Montenegro</asp:ListItem>
                                            <asp:ListItem value="MS">Montserrat</asp:ListItem>
                                            <asp:ListItem value="MA">Morocco</asp:ListItem>
                                            <asp:ListItem value="MZ">Mozambique</asp:ListItem>
                                            <asp:ListItem value="MM">Myanmar</asp:ListItem>
                                            <asp:ListItem value="NA">Namibia</asp:ListItem>
                                            <asp:ListItem value="NR">Nauru</asp:ListItem>
                                            <asp:ListItem value="NP">Nepal</asp:ListItem>
                                            <asp:ListItem value="NL">Netherlands</asp:ListItem>
                                            <asp:ListItem value="NC">New Caledonia</asp:ListItem>
                                            <asp:ListItem value="NZ">New Zealand</asp:ListItem>
                                            <asp:ListItem value="NI">Nicaragua</asp:ListItem>
                                            <asp:ListItem value="NE">Niger</asp:ListItem>
                                            <asp:ListItem value="NG">Nigeria</asp:ListItem>
                                            <asp:ListItem value="NU">Niue</asp:ListItem>
                                            <asp:ListItem value="NF">Norfolk Island</asp:ListItem>
                                            <asp:ListItem value="MP">Northern Mariana Islands</asp:ListItem>
                                            <asp:ListItem value="NO">Norway</asp:ListItem>
                                            <asp:ListItem value="OM">Oman</asp:ListItem>
                                            <asp:ListItem value="PK">Pakistan</asp:ListItem>
                                            <asp:ListItem value="PW">Palau</asp:ListItem>
                                            <asp:ListItem value="PS">Palestinian Territory, Occupied</asp:ListItem>
                                            <asp:ListItem value="PA">Panama</asp:ListItem>
                                            <asp:ListItem value="PG">Papua New Guinea</asp:ListItem>
                                            <asp:ListItem value="PY">Paraguay</asp:ListItem>
                                            <asp:ListItem value="PE">Peru</asp:ListItem>
                                            <asp:ListItem value="PH">Philippines</asp:ListItem>
                                            <asp:ListItem value="PN">Pitcairn</asp:ListItem>
                                            <asp:ListItem value="PL">Poland</asp:ListItem>
                                            <asp:ListItem value="PT">Portugal</asp:ListItem>
                                            <asp:ListItem value="PR">Puerto Rico</asp:ListItem>
                                            <asp:ListItem value="QA">Qatar</asp:ListItem>
                                            <asp:ListItem value="RE">Réunion</asp:ListItem>
                                            <asp:ListItem value="RO">Romania</asp:ListItem>
                                            <asp:ListItem value="RU">Russian Federation</asp:ListItem>
                                            <asp:ListItem value="RW">Rwanda</asp:ListItem>
                                            <asp:ListItem value="BL">Saint Barthélemy</asp:ListItem>
                                            <asp:ListItem value="SH">Saint Helena, Ascension and Tristan Da Cunha</asp:ListItem>
                                            <asp:ListItem value="KN">Saint Kitts and Nevis</asp:ListItem>
                                            <asp:ListItem value="LC">Saint Lucia</asp:ListItem>
                                            <asp:ListItem value="MF">Saint Martin (French Part)</asp:ListItem>
                                            <asp:ListItem value="PM">Saint Pierre and Miquelon</asp:ListItem>
                                            <asp:ListItem value="VC">Saint Vincent and the Grenadines</asp:ListItem>
                                            <asp:ListItem value="WS">Samoa</asp:ListItem>
                                            <asp:ListItem value="SM">San Marino</asp:ListItem>
                                            <asp:ListItem value="ST">Sao Tome and Principe</asp:ListItem>
                                            <asp:ListItem value="SA">Saudi Arabia</asp:ListItem>
                                            <asp:ListItem value="SN">Senegal</asp:ListItem>
                                            <asp:ListItem value="RS">Serbia</asp:ListItem>
                                            <asp:ListItem value="SC">Seychelles</asp:ListItem>
                                            <asp:ListItem value="SL">Sierra Leone</asp:ListItem>
                                            <asp:ListItem value="SG">Singapore</asp:ListItem>
                                            <asp:ListItem value="SX">Sint Maarten (Dutch Part)</asp:ListItem>
                                            <asp:ListItem value="SK">Slovakia</asp:ListItem>
                                            <asp:ListItem value="SI">Slovenia</asp:ListItem>
                                            <asp:ListItem value="SB">Solomon Islands</asp:ListItem>
                                            <asp:ListItem value="SO">Somalia</asp:ListItem>
                                            <asp:ListItem value="ZA">South Africa</asp:ListItem>
                                            <asp:ListItem value="GS">South Georgia and the South Sandwich Islands</asp:ListItem>
                                            <asp:ListItem value="ES">Spain</asp:ListItem>
                                            <asp:ListItem value="LK">Sri Lanka</asp:ListItem>
                                            <asp:ListItem value="SD">Sudan</asp:ListItem>
                                            <asp:ListItem value="SR">Suriname</asp:ListItem>
                                            <asp:ListItem value="SJ">Svalbard and Jan Mayen</asp:ListItem>
                                            <asp:ListItem value="SZ">Swaziland</asp:ListItem>
                                            <asp:ListItem value="SE">Sweden</asp:ListItem>
                                            <asp:ListItem value="CH">Switzerland</asp:ListItem>
                                            <asp:ListItem value="SY">Syrian Arab Republic</asp:ListItem>
                                            <asp:ListItem value="TW">Taiwan, Province of China</asp:ListItem>
                                            <asp:ListItem value="TJ">Tajikistan</asp:ListItem>
                                            <asp:ListItem value="TZ">Tanzania, United Republic of</asp:ListItem>
                                            <asp:ListItem value="TH">Thailand</asp:ListItem>
                                            <asp:ListItem value="TL">Timor-Leste</asp:ListItem>
                                            <asp:ListItem value="TG">Togo</asp:ListItem>
                                            <asp:ListItem value="TK">Tokelau</asp:ListItem>
                                            <asp:ListItem value="TO">Tonga</asp:ListItem>
                                            <asp:ListItem value="TT">Trinidad and Tobago</asp:ListItem>
                                            <asp:ListItem value="TN">Tunisia</asp:ListItem>
                                            <asp:ListItem value="TR">Turkey</asp:ListItem>
                                            <asp:ListItem value="TM">Turkmenistan</asp:ListItem>
                                            <asp:ListItem value="TC">Turks and Caicos Islands</asp:ListItem>
                                            <asp:ListItem value="TV">Tuvalu</asp:ListItem>
                                            <asp:ListItem value="UG">Uganda</asp:ListItem>
                                            <asp:ListItem value="UA">Ukraine</asp:ListItem>
                                            <asp:ListItem value="AE">United Arab Emirates</asp:ListItem>
                                            <asp:ListItem value="GB">United Kingdom</asp:ListItem>
                                            <asp:ListItem value="UM">United States Minor Outlying Islands</asp:ListItem>
                                            <asp:ListItem value="UY">Uruguay</asp:ListItem>
                                            <asp:ListItem value="UZ">Uzbekistan</asp:ListItem>
                                            <asp:ListItem value="VU">Vanuatu</asp:ListItem>
                                            <asp:ListItem value="VE">Venezuela, Bolivarian Republic of</asp:ListItem>
                                            <asp:ListItem value="VN">Viet Nam</asp:ListItem>
                                            <asp:ListItem value="VG">Virgin Islands, British</asp:ListItem>
                                            <asp:ListItem value="VI">Virgin Islands, U.S.</asp:ListItem>
                                            <asp:ListItem value="WF">Wallis and Futuna</asp:ListItem>
                                            <asp:ListItem value="EH">Western Sahara</asp:ListItem>
                                            <asp:ListItem value="YE">Yemen</asp:ListItem>
                                            <asp:ListItem value="ZM">Zambia</asp:ListItem>
                                            <asp:ListItem value="ZW">Zimbabwe</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>Postal/Zip code</label></div>
			                        <div class="form_input"> <asp:TextBox ID="tbContactPostalCode" runat="server" MaxLength="10" CssClass="postal_field"></asp:TextBox></div>
                                    <div class="form_formatlabel">(B3L 3H8 or 60622)</div>
                                    <asp:RegularExpressionValidator ID="revContactPostalCode" runat="server" ControlToValidate="tbContactPostalCode" 
                                        ErrorMessage="Please ensure that the Postal/Zip code is in the correct format." Display="Dynamic" ValidationGroup="vgContact" 
                                        ValidationExpression="^[A-Z|a-z]{1}\d{1}[A-Z|a-z]{1}\s?\d{1}[A-Z|a-z]{1}\d{1}|\d{5}$" />
		                        </div>
                                
                            </div>
                            <div class="clearboth"></div>
                            <div class="update_btn_bar">
                                <asp:Button ID="btnContactSubmit" runat="server" Text="Add Contact" OnClick="btnContactSubmit_onClick" CssClass="update_btn" ValidationGroup="vgContact" /> | <a id="lnkCancelContact" href="#">Cancel</a>
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
 
            <div id="fragment-4">
			<h3>Products</h3>
                <asp:UpdatePanel ID="upProduct" runat="server">
                    <ContentTemplate>
						<div class="fieldset">
							<table border="0" cellpadding="0" cellspacing="0" class="tbl_data">
								<tr class="tbl_header">
									<td><strong>Name</strong></td>
									<td><strong>Type</strong></td>
									<td><strong>Community</strong></td>
									<td><strong>Region</strong></td>
									<td><strong>Contact</strong></td>
									<td style="width:15%;"><strong>Action</strong</td>
								</tr>
								<asp:Repeater ID="rptProduct" runat="server">
									<ItemTemplate>
										<tr>
											<td><%# Eval("productName") %></td>
											<td><%# Eval("productType") %></td>
											<td><%# Eval("productCommunity") %></td>
											<td><%# Eval("productRegion") %></td>
											<td><%# Eval("productContactName") %></td>
											<td><asp:LinkButton ID="btnEditProduct" CommandArgument='<%# Eval("productId") %>' runat="server" Text="Edit" OnClick="btnEditProduct_onClick" /> | <asp:LinkButton ID="btnDeleteProduct" CommandArgument='<%# Eval("productId") %>' OnClientClick='<%# "return ConfirmDelete(this, \"Are you sure you would like to delete the product " + Eval("productName") + "?\")" %>' runat="server" Text="Delete" OnClick="btnDeleteProduct_onClick" /></td>
										</tr>
									</ItemTemplate>
								</asp:Repeater>
							</table>
						</div>
                    </ContentTemplate>
                </asp:UpdatePanel>
                <div id="productToggle" class="section_toggle plus"><a id="lnkAddProduct">Add Product</a></div>
                <div id="productForm" class="update_pnl section_body clearfix">
                    <div class="form_left">
                        <asp:UpdatePanel ID="upProductName" runat="server">
                            <ContentTemplate>
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>Product name</label> <span class="required">&bull;</span></div>
			                        <div class="form_input"><asp:TextBox ID="tbProductName" runat="server" MaxLength="100" AutoPostBack="true"></asp:TextBox></div>
                                    <asp:RequiredFieldValidator ID="rfvProductProductName" runat="server" ControlToValidate="tbProductName" 
                                        ErrorMessage="Product name is a required field." Display="Dynamic" ValidationGroup="vgProduct" />
                                    <asp:PlaceHolder ID="plcProductExists" runat="server" Visible="false"><div class="warning ui-corner-all">A Product with this name already exists. <asp:HyperLink ID="lnkViewProduct" runat="server">View Product</asp:HyperLink></div></asp:PlaceHolder>
                                    <asp:PlaceHolder ID="plcProductsExist" runat="server" Visible="false"><div class="warning ui-corner-all">More than one product with the same name already exists. Use product search to find these products if you would like to view them.</div></asp:PlaceHolder>
		                        </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        <div class="form_fields clearfix">
			                <div class="form_label"><label>Product type</label> <span class="required">&bull;</span></div>
			                <div class="form_input"><asp:DropDownList ID="ddlProductType" runat="server"></asp:DropDownList></div>
                            <asp:RequiredFieldValidator ID="rfvProductProductType" runat="server" ControlToValidate="ddlProductType" 
                                ErrorMessage="Product type is a required field." Display="Dynamic" ValidationGroup="vgProduct" />
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label"><label>Contact</label> <span class="required">&bull;</span></div>
			                <div class="form_input"><asp:DropDownList ID="ddlPrimaryContact" runat="server" ></asp:DropDownList></div>
                            <asp:RequiredFieldValidator ID="rfvProductPrimaryContact" runat="server" ControlToValidate="ddlPrimaryContact" 
                                ErrorMessage="Contact is a required field." Display="Dynamic" ValidationGroup="vgProduct" />
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label"><label>Address 1</label></div>
			                <div class="form_input"><asp:TextBox ID="tbProductLine1" runat="server" MaxLength="100"></asp:TextBox></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label"><label>Address 2</label></div>
			                <div class="form_input"><asp:TextBox ID="tbProductLine2" runat="server" MaxLength="100"></asp:TextBox></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label"><label>Address 3</label></div>
			                <div class="form_input"><asp:TextBox ID="tbProductLine3" runat="server" MaxLength="100"></asp:TextBox></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label"><label>City/Community</label></div>
			                <div class="form_input">
                                <asp:DropDownList ID="ddlProductCommunity" runat="server" AppendDataBoundItems="true">
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
			                <div class="form_input"><asp:TextBox ID="tbProductPostalCode" runat="server" MaxLength="10" CssClass="postal_field"></asp:TextBox></div>
                            <div class="form_formatlabel">(B3L 3H8)</div>
                            <asp:RegularExpressionValidator ID="revProductPostalCode" runat="server" ControlToValidate="tbProductPostalCode" 
                                ErrorMessage="Please ensure that the Postal code is in the correct format." Display="Dynamic" ValidationGroup="vgProduct" 
                                ValidationExpression="^[A-Z|a-z]{1}\d{1}[A-Z|a-z]{1}\s?\d{1}[A-Z|a-z]{1}\d{1}$" />
		                </div>
                                
                    </div>
                    <div class="form_right">
                        <div class="form_fields clearfix">
			                <div class="form_label"><label>Proprietor</label></div>
			                <div class="form_input"><asp:TextBox ID="tbProductProprietor" runat="server" MaxLength="100"></asp:TextBox></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label"><label>Email</label></div>
			                <div class="form_input"><asp:TextBox ID="tbProductEmail" runat="server" MaxLength="100"></asp:TextBox></div>
                            <asp:RegularExpressionValidator ID="revProductEmail" runat="server" ControlToValidate="tbProductEmail" 
                                ErrorMessage="The specified email address is not a valid format." Display="Dynamic" ValidationGroup="vgProduct" 
                                ValidationExpression="^[a-zA-Z0-9][\+\w\.-]*@[a-zA-Z0-9][\w\.-]*\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$" />
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label"><label>Website</label></div>
			                <div class="form_input"><asp:TextBox ID="tbProductWebsite" runat="server" MaxLength="300"></asp:TextBox><a id="lnkCheckProductWebsite">Check URL</a></div>
                            <asp:RegularExpressionValidator ID="revProductWebsite" runat="server" ControlToValidate="tbProductWebsite" 
                                ErrorMessage="The specified website is not a valid format." Display="Dynamic" ValidationGroup="vgProduct" 
                                ValidationExpression="^(https?://)?([a-z]|[A-Z]|\d|-|\.)*\.{1}([a-z]|[A-Z]|\d|-|\.|/)+$" />
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label"><label>Telephone</label></div>
			                <div class="form_input"><asp:TextBox ID="tbProductTelephone" runat="server" MaxLength="100" CssClass="phone_field"></asp:TextBox></div>
                            <asp:RegularExpressionValidator ID="valProductTelephone" runat="server" ControlToValidate="tbProductTelephone" ValidationGroup="vgProduct" 
                                ValidationExpression="^\d{3}-\d{3}-\d{4}.*" ErrorMessage="Telephone must have a phone number at the beginning of the field in the format of 902-555-5555." 
                                Display="Dynamic" />
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label"><label>Toll-free</label></div>
			                <div class="form_input"><asp:TextBox ID="tbProductTollfree" runat="server" MaxLength="100" CssClass="phone_field"></asp:TextBox></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label"><label>Fax</label></div>
			                <div class="form_input"><asp:TextBox ID="tbProductFax" runat="server" MaxLength="100" CssClass="phone_field"></asp:TextBox></div>
		                </div>
                    </div>
                    <div class="clearboth"></div>
                    <div class="update_btn_bar">
                        <asp:Button ID="btnProductSubmit" runat="server" Text="Add Product" OnClick="btnProductSubmit_onClick" CssClass="update_btn" ValidationGroup="vgProduct" /> | <a id="lnkCancelProduct" href="#">Cancel</a>
                    </div>
                </div>
            </div>
        </div>
    </div><!-- end form_wrap -->
    <div class="submit_btn_bar">
        <asp:Button ID="btnSubmit" runat="server" Text="SAVE" OnClick="btnSubmit_onClick" CssClass="submit_btn" /> | <asp:LinkButton ID="lbDeleteBusiness" runat="server" OnClientClick="return ConfirmBusinessDelete()" OnClick="lbDeleteBusiness_onClick">Delete</asp:LinkButton>
    </div>
    <div id="accordion" class="clearfix">
        <div class="ui-corner-all accordion_item">
            <h4 class="clearfix"><span class="ui-icon ui-icon-triangle-1-e"></span><a href="#">Notes</a></h4>
            <div class="cnt clearfix">
                <asp:UpdatePanel ID="upNote" runat="server">
                    <ContentTemplate>
                        <table border="0" cellpadding="0" cellspacing="0" class="tbl_data_notes">
                            <asp:Repeater ID="rptNote" runat="server">
                                <ItemTemplate><tr><td style="padding:1.25em 0;"><p style="margin-bottom:0.5em;"><strong><%# Eval("lastModifiedBy") %></strong> on <em><%#String.Format("{0:g}", Eval("creationDate"))%></em></p><%# Eval("noteBody") %><div id="reminderDateSection" style="margin-top:1.25em;"><em>Email reminder date:</em> <span id="reminderDateValue" style="font-weight:bold;"><%#String.Format("{0:d}", Eval("reminderDate"))%></span> | <span id="reminderDateCancel"><asp:LinkButton ID="lbCancelReminder" runat="server" CommandArgument='<%# Eval("id") %>' Text="Cancel Reminder" OnClick="btnCancelReminder_onClick" ></asp:LinkButton></span></div> </td></tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </table>
            
                        <div id="noteToggle" class="section_toggle plus"><a id="lnkAddNote">Add Note</a></div>
                        <div id="noteForm" class="update_pnl section_body clearfix">
							<div class="form_left">
								<div class="form_fields clearfix">
									<div class="form_label"><label>Note</label> <span class="required">&bull;</span></div>
									<div class="form_input"><asp:TextBox ID="tbNote" TextMode="MultiLine" runat="server" Length="1000"></asp:TextBox>
										<p class="chars_remaining">Characters remaining: 1000</p></div>
									<asp:RequiredFieldValidator ID="rfvNote" runat="server" ControlToValidate="tbNote" 
										ErrorMessage="Note is a required field." Display="Dynamic" ValidationGroup="vgNote" />
								</div>
							</div>
							<div class="form_right">
								<div class="form_fields clearfix">
									<div class="form_label"><label>Email reminder date</label></div>
									<div class="form_input"><asp:TextBox ID="tbNoteReminderDate" CssClass="phone_field" runat="server"></asp:TextBox></div>
								</div>
							</div>
							<div class="clearboth"></div>
                            <div class="update_btn_bar">
                                <asp:Button ID="btnNoteSubmit" runat="server" Text="Add note" OnClick="btnNoteSubmit_onClick" CssClass="update_btn" ValidationGroup="vgNote" /> | <a id="lnkCancelNote" href="#">Cancel</a>
                            </div>               
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
   
</asp:Content> 
