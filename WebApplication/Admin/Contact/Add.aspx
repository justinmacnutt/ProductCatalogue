<%@ Page Language="C#" MasterPageFile="~/prodCat.master" AutoEventWireup="true" CodeBehind="Add.aspx.cs" Inherits="WebApplication.Admin.Contact.Add" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<asp:Content ID="cHeadContent" ContentPlaceHolderID="cphHeadContent" Runat="Server"> 
    <script type="text/javascript">

        $(document).ready(function () {
            $("[id*=mn_contacts]").addClass("current");

            InitializeEventBindings();

        });

        function InitializeEventBindings() {
            $(window).keydown(function (event) {
                if (event.keyCode == 13) {
                    event.preventDefault();
                    return false;
                }
            });

            $("[id*=ddlCountry]").change(function () {
                MakeAddressFormAdjustments();
            });

            // Add '902-' to textbox on focus
//            $("[id*=tbWorkPhone]").focus(function () {
//                if ($(this).val() == "") {
//                    $(this).val('902-');
//                }
//            });

            // Update text remaining
            var onEditCallback = function(remaining) {
                $(this).siblings('.chars_remaining').text("(" + remaining + " characters remaining)");
            };

            // Attach maxlength function to textarea
            $('textarea[length]').limitMaxlength({
                onEdit: onEditCallback
            });

        }

        function MakeAddressFormAdjustments() {
            if (($("[id*=ddlCountry]").val() == "CA" || $("[id*=ddlCountry]").val() == "US")) {
                $("[id*=dvOtherRegion]").hide();
                $("[id*=dvProvinceState]").show();
                ValidatorEnable($get("<%=revPostalCode.ClientID%>"), true);
            }
            else {
                $("[id*=dvOtherRegion]").show();
                $("[id*=dvProvinceState]").hide();
                ValidatorEnable($get("<%=revPostalCode.ClientID%>"), false);
            }
        }


        
    </script>
</asp:Content> 
<asp:Content ID="cMainContent" ContentPlaceHolderID="cphMainContent" Runat="Server">        
     <div class="breadcrumb"><a href="~/Admin/Contact/Index.aspx" runat="server">Contact Index</a> &raquo; <strong>Add Contact</strong></div>
	
    <div class="page_header clearfix">
		<div class="action_btns"></div>
		<h2 class="page_title">Add Contact</h2>
	</div>
    <div class="legend"><span class="required">&bull;</span> <label>indicates required field</label></div>

    <div class="form_wrap clearfix">
        <asp:ScriptManager ID="ScriptManager1"  runat="server"></asp:ScriptManager>
        <script type="text/javascript" language="javascript">
            var prm = Sys.WebForms.PageRequestManager.getInstance();

            prm.add_endRequest(function () {
                MakeAddressFormAdjustments();
                InitializeEventBindings();
            });

        </script>  
        <act:AutoCompleteExtender ID="aceParentBusiness" runat="server" ServicePath="~/WebServices/Services.asmx" ServiceMethod="GetBusinessNameList" MinimumPrefixLength="3" TargetControlID="tbBusinessName" CompletionSetCount="10" ></act:AutoCompleteExtender>
        <div id="contactForm" class="form_wrap clearfix">
           
            <div class="form_fields clearfix">
		        <div class="form_label"><label>Business name</label> <span class="required">&bull;</span></div>
                <div class="form_input"><asp:TextBox ID="tbBusinessName" AutoComplete="Off" AutoPostBack="false" runat="server" CssClass="biz_name_field"></asp:TextBox>&nbsp;
					<asp:UpdatePanel ID="upAddressButton" RenderMode="Inline" runat="server">
					<ContentTemplate>
						<asp:Button ID="btnGetAddresses" runat="server" Text="Get Addresses" OnClick="btnGetAddresses_onClick" CausesValidation="false" /><br />
					
					<asp:RequiredFieldValidator ID="rfvBusinessName" runat="server" ControlToValidate="tbBusinessName" 
							ErrorMessage="Business name is a required field." Display="Dynamic" />
                    <asp:CustomValidator ID="cvBusinessName" runat="server" ControlToValidate="tbBusinessName"
                        ErrorMessage="The business does not exist." Display="Dynamic" 
                        onservervalidate="cvBusinessName_ServerValidate" />
                    </ContentTemplate>
					</asp:UpdatePanel>
                    <div class="form_formatlabel">(start typing to auto-populate)</div>
				</div>
	        </div>

			<div class="fieldset clearfix">
				<div class="form_left">
                    <div class="form_fields clearfix">
			            <div class="form_label"><label>Contact Type</label> <span class="required">&bull;</span></div>
			            <div class="form_input"><asp:DropDownList ID="ddlBusinessContactType" runat="server"></asp:DropDownList></div>
                    </div>
					<div class="form_fields clearfix">
						<div class="form_label"><label>First name</label> <span class="required">&bull;</span></div>
						<div class="form_input"><asp:TextBox ID="tbFirstName" runat="server" MaxLength="50"></asp:TextBox></div>
						<asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="tbFirstName" 
							ErrorMessage="First Name is a required field." Display="Dynamic" />
					</div>
					<div class="form_fields clearfix">
						<div class="form_label"><label>Last name</label> <span class="required">&bull;</span></div>
						<div class="form_input"><asp:TextBox ID="tbLastName" runat="server" MaxLength="50"></asp:TextBox></div>
						<asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="tbLastName" 
							ErrorMessage="Last Name is a required field." Display="Dynamic" />
					</div>
					<div class="form_fields clearfix">
						<div class="form_label"><label>Title</label></div>
						<div class="form_input"><asp:TextBox ID="tbJobTitle" runat="server" MaxLength="50"></asp:TextBox></div>
					</div>
					<div class="form_fields clearfix">
						<div class="form_label"><label>Email</label></div>
						<div class="form_input"><asp:TextBox ID="tbEmail" runat="server" MaxLength="100"></asp:TextBox></div>
						<asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="tbEmail" 
							ErrorMessage="The specified email address is not a valid format." Display="Dynamic"
							ValidationExpression="^[a-zA-Z0-9][\+\w\.-]*@[a-zA-Z0-9][\w\.-]*\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$" />
					</div>
					<div class="form_fields clearfix">
						<div class="form_label"><label>Primary phone</label> <span class="required">&bull;</span></div>
						<div class="form_input"><asp:TextBox ID="tbPrimaryPhone" runat="server" MaxLength="30" CssClass="phone_field"></asp:TextBox></div>
						<asp:RequiredFieldValidator ID="rfvPrimaryPhone" runat="server" ControlToValidate="tbPrimaryPhone" 
							ErrorMessage="Primary phone is a required field." Display="Dynamic" />
					</div>
					<div class="form_fields clearfix">
						<div class="form_label"><label>Mobile</label></div>
						<div class="form_input"><asp:TextBox ID="tbMobile" runat="server" MaxLength="30" CssClass="phone_field"></asp:TextBox></div>
					</div>
                    <div class="form_fields clearfix">
						<div class="form_label"><label>Home</label></div>
						<div class="form_input"><asp:TextBox ID="tbHomePhone" runat="server" MaxLength="30" CssClass="phone_field"></asp:TextBox></div>
					</div>
                    <div class="form_fields clearfix">
						<div class="form_label"><label>Off season</label></div>
						<div class="form_input"><asp:TextBox ID="tbOffSeason" runat="server" MaxLength="30" CssClass="phone_field"></asp:TextBox></div>
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
					<asp:UpdatePanel ID="upAddress" runat="server">
						<ContentTemplate>
							<div class="form_fields clearfix">
								<div class="form_label"><label>Copy an existing address</label></div>
								<div id="dvAddressSelect" class="form_input" runat="server" visible="false"><asp:DropDownList ID="ddlCopyAddress" runat="server"></asp:DropDownList><br />
								<asp:LinkButton ID="lbCopyAddress" runat="server" OnClick="lbCopyAddress_onClick" CausesValidation="false"
									Text="Populate the address fields below with this address." /></div>
                                <div id="dvNoBusiness" class="form_label" runat="server">Select a business above</div>
								<div id="dvNoContacts" class="form_label" runat="server" visible="false">The selected business has no addresses</div>
							</div>
                    
							<div class="form_fields clearfix">
								<div class="form_label"><label>Address type</label> <span class="required">&bull;</span></div>
								<div class="form_input"><asp:DropDownList ID="ddlAddressType" runat="server"></asp:DropDownList></div>
								<asp:RequiredFieldValidator ID="rfvAddressType" runat="server" ControlToValidate="ddlAddressType" 
									ErrorMessage="Address Type is a required field." Display="Dynamic" />
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
								<div class="form_label"><label>City/Community</label> <span class="required">&bull;</span></div>
								<div class="form_input"><asp:TextBox ID="tbCity" runat="server" MaxLength="100"></asp:TextBox></div>
								<asp:RequiredFieldValidator ID="rfvCity" runat="server" ControlToValidate="tbCity" 
									ErrorMessage="City/Community is a required field." Display="Dynamic" />
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
								<div class="form_input"> <asp:TextBox ID="tbPostalCode" runat="server" MaxLength="20" CssClass="postal_field"></asp:TextBox></div>
								<div class="form_formatlabel">(B3L 3H8 or 60622)</div>
								<asp:RegularExpressionValidator ID="revPostalCode" runat="server" ControlToValidate="tbPostalCode" 
									ErrorMessage="Please ensure that the Postal/Zip code is in the correct format." Display="Dynamic"
									ValidationExpression="^[A-Z|a-z]{1}\d{1}[A-Z|a-z]{1}\s?\d{1}[A-Z|a-z]{1}\d{1}|\d{5}$" />
							</div>
						</ContentTemplate>
					</asp:UpdatePanel>
				</div>
			</div>
        </div>
    </div>
    <div class="add_btn_bar">
        <asp:Button ID="btnContactSubmit" runat="server" Text="Add contact" OnClick="btnContactSubmit_onClick" CssClass="submit_btn" />
    </div>

</asp:Content> 