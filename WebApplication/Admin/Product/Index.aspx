<%@ Page Language="C#" MasterPageFile="~/prodCat.master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="WebApplication.Admin.Product.Index" %>

<asp:Content ID="cHeadContent" ContentPlaceHolderID="cphHeadContent" Runat="Server"> 
    <script type="text/javascript">

        $(document).ready(function () {
            $("[id*=mn_products]").addClass("current");

            $("[id*=tbNoteStartDate]").datepicker({ dateFormat: 'dd-mm-yy' });
            $("[id*=tbNoteEndDate]").datepicker({ dateFormat: 'dd-mm-yy' });

            $("[id*=tbProductId]").change(function () {
                this.value = this.value.replace(/[^0-9]/g, '');
            });

            $("[id*=tbProductId]").keyup(function () {
                this.value = this.value.replace(/[^0-9]/g, '');
            });

            $("[id*=dvFeatureSelectUnit]:lt(" + $("[id*=hdnFeatureDisplayNumber]").val() + ")").show();
            $("[id*=dvMediaSelectUnit]:lt(" + $("[id*=hdnMediaDisplayNumber]").val() + ")").show();
            $("[id*=dvLinkSelectUnit]:lt(" + $("[id*=hdnLinkDisplayNumber]").val() + ")").show();

            if ($("[id*=hdnFeatureDisplayNumber]").val() == "1") {
                $("[id*=lnkRemoveFeatureUnit]").attr("disabled", "disabled");
            }

            if ($("[id*=hdnMediaDisplayNumber]").val() == "1") {
                $("[id*=lnkRemoveMediaUnit]").attr("disabled", "disabled");
            }

            if ($("[id*=hdnLinkDisplayNumber]").val() == "1") {
                $("[id*=lnkRemoveLinkUnit]").attr("disabled", "disabled");
            }

            if ($("[id*=hdnFeatureDisplayNumber]").val() == "10") {
                $("[id*=lnkAddFeatureUnit]").attr("disabled", "disabled");
            }

            if ($("[id*=hdnMediaDisplayNumber]").val() == "5") {
                $("[id*=lnkAddMediaUnit]").attr("disabled", "disabled");
            }

            if ($("[id*=hdnLinkDisplayNumber]").val() == "5") {
                $("[id*=lnkAddLinkUnit]").attr("disabled", "disabled");
            }

            $("[id*=lnkCancelAdvancedSearch]").click(function () {
                if ($("[id*=dvAdvancedSearchForm]").is(':visible')) {
                    $("[id*=dvAdvancedSearchForm]").slideToggle(250);
                    // $("[id*=dvAdvancedSearchToggle]").toggleClass('plus').toggleClass('minus');
                    $("[id*=dvAdvancedSearchToggle]").children('span').toggleClass('ui-icon-triangle-1-e').toggleClass('ui-icon-triangle-1-s');
                    ClearAdvancedSearchForm();
                }
                return false;

                //ClearAdvancedSearchForm();
            });

            $("[id*=lnkAdvancedSearch]").click(function () {
                if ($("[id*=dvAdvancedSearchForm]").is(':hidden')) {
                    //$("[id*=dvAdvancedSearchToggle]").toggleClass('plus').toggleClass('minus');
                    $("[id*=dvAdvancedSearchToggle]").children('span').toggleClass('ui-icon-triangle-1-e').toggleClass('ui-icon-triangle-1-s');

                    $("[id*=dvAdvancedSearchForm]").show(250);
                    $("[id*=hdnShowAdvancedSearchPanel]").val("1");
                }
                return false;

                //ClearAdvancedSearchForm();
            });

            if ($("[id*=hdnShowAdvancedSearchPanel]").val() == "1") {
                if ($("[id*=dvAdvancedSearchForm]").is(':hidden')) {
                    //$("[id*=dvAdvancedSearchToggle]").toggleClass('plus').toggleClass('minus');
                    $("[id*=dvAdvancedSearchToggle]").children('span').toggleClass('ui-icon-triangle-1-e').toggleClass('ui-icon-triangle-1-s');
                    $("[id*=dvAdvancedSearchForm]").show(250);
                }
            }

            $("[id*=lnkAddFeatureUnit]").click(function (e) {
                var i = $("[id*=hdnFeatureDisplayNumber]").val();

                if (i == "10") {
                    e.preventDefault();
                    return;
                }

                $("[id*=hdnFeatureDisplayNumber]").val(Number(i) + 1);

                if ($("[id*=hdnFeatureDisplayNumber]").val() != "1") {
                    $("[id*=lnkRemoveFeatureUnit]").removeAttr("disabled");
                }

                if ($("[id*=hdnFeatureDisplayNumber]").val() == "10") {
                    $("[id*=lnkAddFeatureUnit]").attr("disabled", "disabled");
                }

                $("[id*=dvFeatureSelectUnit]:lt(" + $("[id*=hdnFeatureDisplayNumber]").val() + ")").show();
            });

            $("[id*=lnkRemoveFeatureUnit]").click(function () {
                var i = $("[id*=hdnFeatureDisplayNumber]").val();

                if (i == "1") {
                    e.preventDefault();
                    return;
                }

                $("[id*=hdnFeatureDisplayNumber]").val(Number(i) - 1);

                if ($("[id*=hdnFeatureDisplayNumber]").val() == "1") {
                    $("[id*=lnkRemoveFeatureUnit]").attr("disabled", "disabled");
                }

                if ($("[id*=hdnFeatureDisplayNumber]").val() != "10") {
                    $("[id*=lnkAddFeatureUnit]").removeAttr("disabled");
                }

                $("[id*=ddlFeatureType" + i + "]").val('');
                $("[id*=ddlFeatureStatus" + i + "]").val('');

                $("[id*=ddlFeatureValue" + i + "]").find("option[value!='']").remove();

                $("[id*=dvFeatureSelectUnit]:gt(" + (Number($("[id*=hdnFeatureDisplayNumber]").val()) - 1) + ")").hide();

            });

            $("[id*=lnkAddMediaUnit]").click(function () {
                var i = $("[id*=hdnMediaDisplayNumber]").val();

                if (i == "5") {
                    e.preventDefault();
                    return;
                }

                $("[id*=hdnMediaDisplayNumber]").val(Number(i) + 1);

                if ($("[id*=hdnMediaDisplayNumber]").val() != "1") {
                    $("[id*=lnkRemoveMediaUnit]").removeAttr("disabled");
                }

                if ($("[id*=hdnMediaDisplayNumber]").val() == "5") {
                    $("[id*=lnkAddMediaUnit]").attr("disabled", "disabled");
                }

                $("[id*=dvMediaSelectUnit]:lt(" + $("[id*=hdnMediaDisplayNumber]").val() + ")").show();
            });

            $("[id*=lnkRemoveMediaUnit]").click(function () {
                var i = $("[id*=hdnMediaDisplayNumber]").val();

                if (i == "1") {
                    e.preventDefault();
                    return;
                }

                $("[id*=hdnMediaDisplayNumber]").val(Number(i) - 1);

                if ($("[id*=hdnMediaDisplayNumber]").val() == "1") {
                    $("[id*=lnkRemoveMediaUnit]").attr("disabled", "disabled");
                }

                if ($("[id*=hdnMediaDisplayNumber]").val() != "5") {
                    $("[id*=lnkAddMediaUnit]").removeAttr("disabled");
                }

                $("[id*=ddlMediaType" + i + "]").val('');
                $("[id*=ddlMediaStatus" + i + "]").val('');

                $("[id*=dvMediaSelectUnit]:gt(" + (Number($("[id*=hdnMediaDisplayNumber]").val()) - 1) + ")").hide();

            });

            $("[id*=lnkAddLinkUnit]").click(function () {
                var i = $("[id*=hdnLinkDisplayNumber]").val();

                if (i == "5") {
                    e.preventDefault();
                    return;
                }

                $("[id*=hdnLinkDisplayNumber]").val(Number(i) + 1);

                if ($("[id*=hdnLinkDisplayNumber]").val() != "1") {
                    $("[id*=lnkRemoveLinkUnit]").removeAttr("disabled");
                }

                if ($("[id*=hdnLinkDisplayNumber]").val() == "5") {
                    $("[id*=lnkAddLinkUnit]").attr("disabled", "disabled");
                }

                $("[id*=dvLinkSelectUnit]:lt(" + $("[id*=hdnLinkDisplayNumber]").val() + ")").show();
            });

            $("[id*=lnkRemoveLinkUnit]").click(function () {
                var i = $("[id*=hdnLinkDisplayNumber]").val();

                if (i == "1") {
                    e.preventDefault();
                    return;
                }

                $("[id*=hdnLinkDisplayNumber]").val(Number(i) - 1);

                if ($("[id*=hdnLinkDisplayNumber]").val() == "1") {
                    $("[id*=lnkRemoveLinkUnit]").attr("disabled", "disabled");
                }

                if ($("[id*=hdnLinkDisplayNumber]").val() != "5") {
                    $("[id*=lnkAddLinkUnit]").removeAttr("disabled");
                }

                $("[id*=ddlLinkType" + i + "]").val('');
                $("[id*=ddlLinkStatus" + i + "]").val('');

                $("[id*=dvLinkSelectUnit]:gt(" + (Number($("[id*=hdnLinkDisplayNumber]").val()) - 1) + ")").hide();

            });

            $(".feature_toggle").click(function () {
                $(this).toggleClass('plus').toggleClass('minus');
                $(this).siblings(".section_body").slideToggle(250);

                $("[id*=hdnShowAdvancedSearchPanel]").val("1");

                return false;
            });

            InitializeEventBindings();
        });

        // Attach events
        function InitializeEventBindings() {
            // Attach event to clear filters link
            $("[id*=lnkClearFilters]").click(function () {
                ClearFilters();
            });
        }

        function ClearAdvancedSearchForm() {
            $("[id*=hdnShowAdvancedSearchPanel]").val("0");

            $("[id*=ddlFeatureType]").val('');
            $("[id*=ddlFeatureStatus]").val('');
            $("[id*=ddlFeatureValue]").find("option[value!='']").remove();

            $("[id*=ddlMediaType]").val('');
            $("[id*=ddlMediaStatus]").val('');

            $("[id*=ddlLinkType]").val('');
            $("[id*=ddlLinkStatus]").val('');

            $("[id*=ddlCheckInMember]").val('');

            $("[id*=tbAdvSearch]").val('');
            $("[id*=tbNote]").val('');
            $("[id*=tbNoteStartDate]").val('');
            $("[id*=tbNoteEndDate]").val('');

            $("[id*=cbUnitDescription]").removeAttr('checked');
            $("[id*=cbPrintDescription]").removeAttr('checked');
            $("[id*=cbWebDescription]").removeAttr('checked');
            $("[id*=cbLicenseNumber]").removeAttr('checked');
            $("[id*=cbFileMakerId]").removeAttr('checked');
            $("[id*=cbCheckInId]").removeAttr('checked');

            $("[id*=ddlFilterOperator]").val('');
            $("[id*=ddlMediaOperator]").val('');
            $("[id*=ddlLinkOperator]").val('');

        }

        // Resets the values for the filter textboxes
        function ClearFilters() {
            $("[id*=tbProductId]").val('');
            $("[id*=tbProductName]").val('');
            $("[id*=ddlProductType]").val('');
            $("[id*=ddlCommunity]").val('');
            $("[id*=ddlRegion]").val('');
            $("[id*=tbCheckInId]").val('');
            $("[id*=tbFileMakerId]").val('');
            $("[id*=tbLicenseNumber]").val('');
            $("[id*=tbBusinessName]").val('');
            $("[id*=tbContactFirstName]").val('');
            $("[id*=tbContactLastName]").val('');
            $("[id*=ddlProductStatus]").val('');
            $("[id*=ddlValidationStatus]").val('');
            $("[id*=ddlSubRegion]").val('');
            $("[id*=ddlCompletionStatus]").val('');
            $("[id*=ddlErrorsOverridden]").val('');

            if ($("[id*=dvAdvancedSearchForm]").is(':visible')) {
                $("[id*=dvAdvancedSearchForm]").slideToggle(250);
                $("[id*=dvAdvancedSearchToggle]").toggleClass('plus').toggleClass('minus');

                ClearAdvancedSearchForm();
            }
        }
    </script>
</asp:Content> 
<asp:Content ID="cMainContent" ContentPlaceHolderID="cphMainContent" Runat="Server"> 
<asp:ScriptManager ID="ScriptManager1"  runat="server"></asp:ScriptManager>

 <script type="text/javascript" language="javascript">

     var prm = Sys.WebForms.PageRequestManager.getInstance();

     prm.add_endRequest(function () {

         $("[id*=dvFeatureSelectUnit]:lt(" + $("[id*=hdnFeatureDisplayNumber]").val() + ")").show();

         InitializeEventBindings();

     });
        </script>

    <div class="page_header clearfix">
		<h2 class="page_title">Products</h2>
	</div>
        <div class="col_wrap clearfix">
            <div class="left_col wide">
                <div class="form_fields clearfix">
			        <div class="form_label"><label>Product name</label></div>
			        <div class="form_input"><asp:TextBox ID="tbProductName" runat="server" MaxLength="200"></asp:TextBox></div>
		        </div>
                <div class="form_fields clearfix">
			        <div class="form_label"><label>Product Id</label></div>
			        <div class="form_input"><asp:TextBox ID="tbProductId" runat="server" MaxLength="8"></asp:TextBox></div>
		        </div>
                <div class="form_fields clearfix">
			        <div class="form_label"><label>Product type</label></div>
			        <div class="form_input"><asp:DropDownList id="ddlProductType" runat="server"></asp:DropDownList></div>
		        </div>
                <div class="form_fields clearfix">
			        <div class="form_label"><label>City/Community</label></div>
			        <div class="form_input">
                        <asp:DropDownList ID="ddlCommunity" runat="server" AppendDataBoundItems="true">
                            <asp:ListItem value="">Please select</asp:ListItem>
                        </asp:DropDownList>
                    </div>
		        </div>
                <div class="form_fields clearfix">
			        <div class="form_label"><label>Region</label></div>
			        <div class="form_input">
                        <asp:DropDownList ID="ddlRegion" runat="server" AppendDataBoundItems="true">
                            <asp:ListItem value="">Please select</asp:ListItem>
                        </asp:DropDownList>
                    </div>
		        </div>
                <div class="form_fields clearfix">
			        <div class="form_label"><label>General area</label></div>
			        <div class="form_input">
                        <asp:DropDownList ID="ddlSubRegion" runat="server" AppendDataBoundItems="true">
                            <asp:ListItem value="">Please select</asp:ListItem>
                        </asp:DropDownList>
                    </div>
		        </div>
            </div>
            <div class="right_col wide">
                <div class="form_fields clearfix">
			        <div class="form_label"><label>Business name</label></div>
			        <div class="form_input"><asp:TextBox ID="tbBusinessName" runat="server" MaxLength="200"></asp:TextBox></div>
		        </div>
                <div class="form_fields clearfix">
			        <div class="form_label"><label>Contact first name</label></div>
			        <div class="form_input"><asp:TextBox ID="tbContactFirstName" runat="server" MaxLength="200"></asp:TextBox></div>
		        </div>
                <div class="form_fields clearfix">
			        <div class="form_label"><label>Contact last name</label></div>
			        <div class="form_input"><asp:TextBox ID="tbContactLastName" runat="server" MaxLength="200"></asp:TextBox></div>
		        </div>
                <div class="form_fields clearfix">
                    <table id="tblStatus" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td style="padding-bottom:1em;">
                                <div class="form_label"><label>Product status</label></div>
			                    <div class="form_input">
                                    <asp:DropDownList ID="ddlProductStatus" runat="server" >
                                        <asp:ListItem value="">Please select</asp:ListItem>
                                        <asp:ListItem value="1">Active</asp:ListItem>
                                        <asp:ListItem value="0">Inactive</asp:ListItem>
                                    </asp:DropDownList>
                                </div>    
                            </td>
                            <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td style="padding-bottom:1em;">
                                <div class="form_label"><label>Completion status</label></div>
			                    <div class="form_input">
                                    <asp:DropDownList ID="ddlCompletionStatus" runat="server" >
                                        <asp:ListItem value="">Please select</asp:ListItem>
                                        <asp:ListItem value="1">Complete</asp:ListItem>
                                        <asp:ListItem value="0">Incomplete</asp:ListItem>
                                    </asp:DropDownList>
                                </div>    
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="form_label"><label>Validation status</label></div>
			                    <div class="form_input">
                                    <asp:DropDownList ID="ddlValidationStatus" runat="server" >
                                        <asp:ListItem value="">Please select</asp:ListItem>
                                        <asp:ListItem value="1">Valid</asp:ListItem>
                                        <asp:ListItem value="0">Invalid</asp:ListItem>
                                    </asp:DropDownList>
                                </div>    
                            </td>
                            <td></td>
                            <td>
                                <div class="form_label"><label>Errors overridden</label></div>
			                    <div class="form_input">
                                    <asp:DropDownList ID="ddlErrorsOverridden" runat="server" >
                                        <asp:ListItem value="">Please select</asp:ListItem>
                                        <asp:ListItem value="1">Yes</asp:ListItem>
                                        <asp:ListItem value="0">No</asp:ListItem>
                                    </asp:DropDownList>
                                </div>    
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="clearboth"></div>

            <div class="adv_panel">
				<h4 id="dvAdvancedSearchToggle" class="clearfix"><span class="ui-icon ui-icon-triangle-1-e"></span><a id="lnkAdvancedSearch" href="#">Advanced Search</a></h4>
				
				<div id="dvAdvancedSearchForm" class="hidden clearfix">
					<asp:HiddenField ID="hdnShowAdvancedSearchPanel" runat="server" />
					<asp:HiddenField ID="hdnFeatureDisplayNumber" runat="server"/>
					<asp:HiddenField ID="hdnMediaDisplayNumber" runat="server" />
					<asp:HiddenField ID="hdnLinkDisplayNumber" runat="server" />

                
					<div class="form_left" style="width:35%; border-right:0;">
						<div class="form_fields clearfix">
							<div class="form_label"><label>Search within selected fields below:</label></div>
							<div class="form_input"><asp:TextBox ID="tbAdvSearch" runat="server" MaxLength="300"></asp:TextBox></div>
						</div>
						<div class="form_fields clearfix">
							<div class="form_label"><label></label></div>
							<div class="form_input">
								<table id="tblSearchFields" border="0" cellpadding="0" cellspacing="0" class="cbTable">
									<tr>
										<td><asp:CheckBox ID="cbUnitDescription" runat="server" Text="Unit description" /></td>
										<td><asp:CheckBox ID="cbLicenseNumber" runat="server" Text="License number" /></td>
									</tr>
									<tr>
										<td><asp:CheckBox ID="cbPrintDescription" runat="server" Text="Print description" /></td>
										<td><asp:CheckBox ID="cbFileMakerId" runat="server" Text="Filemaker ID" /></td>
									</tr>
									<tr>
										<td><asp:CheckBox ID="cbWebDescription" runat="server" Text="Web description" /></td>
										<td><asp:CheckBox ID="cbCheckInId" runat="server" Text="Check In ID" /></td>
									</tr>
								</table>
							</div>
						</div>
                        <div class="form_fields clearfix">
							<div class="form_label"><label>Check In Symbol</label></div>
							<div class="form_input">
                                <asp:DropDownList ID="ddlCheckInMember" runat="server">
                                    <asp:ListItem Value="">Please Select</asp:ListItem>
                                    <asp:ListItem Value="1">Yes</asp:ListItem>
                                    <asp:ListItem Value="0">No</asp:ListItem>
                                </asp:DropDownList>
                            </div>
						</div>
						<div class="form_fields clearfix">
							<div class="form_label"><label>Notes text search</label></div>
							<div class="form_input"><asp:TextBox ID="tbNote" runat="server"></asp:TextBox></div>
						</div>
						<div class="form_fields clearfix">
							<table id="tblNoteDates" border="0" cellpadding="0" cellspacing="0">
								<tr>    
									<td>
										<div class="form_label"><label>Notes dated from</label></div>
										<div class="form_input"><asp:TextBox ID="tbNoteStartDate" runat="server"></asp:TextBox></div>       
									</td>
									<td>&nbsp;&nbsp;&nbsp;</td>
									<td>
										<div class="form_label"><label>To</label></div>
										<div class="form_input"><asp:TextBox ID="tbNoteEndDate" runat="server"></asp:TextBox></div>
									</td>
								</tr>
							</table>
						</div>
					</div>
                                              
                    <div class="form_right" style="width:63%; border-left:0;">
                        <div class="fieldset" style="margin-left:20px;">
						<div class="form_fields clearfix">
			                <b>Filter Operator</b>
			                
                            <asp:DropDownList ID="ddlFilterOperator" runat="server">
                                <asp:ListItem Value="1" Text="And"></asp:ListItem>
                                <asp:ListItem Value="0" Text="Or"></asp:ListItem>
                            </asp:DropDownList>
                            
							<br /><br />
                            <asp:UpdatePanel ID="upAdvancedSearch" runat="server">
                            <ContentTemplate>
                            <table id="tblFeatures" border="0" cellpadding="2" cellspacing="0" class="adv_search">
                                <tr><td>Filter type</td><td>Filter values</td><td>State</td></tr>
                                <tr id="dvFeatureSelectUnit1" style="display:none;">
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureType1"  AutoPostBack="true" OnSelectedIndexChanged="ddlFeatureType_onIndexChanged" runat="server">
		                                    </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureValue1" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureStatus1" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                                <asp:ListItem Value="0">No</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                                    
                                <tr id="dvFeatureSelectUnit2" style="display:none;">
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureType2" AutoPostBack="true" OnSelectedIndexChanged="ddlFeatureType_onIndexChanged" runat="server">
		                                    </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureValue2" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureStatus2" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                                <asp:ListItem Value="0">No</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                                <tr id="dvFeatureSelectUnit3" style="display:none;">
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureType3" AutoPostBack="true" OnSelectedIndexChanged="ddlFeatureType_onIndexChanged" runat="server">
		                                    </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureValue3" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureStatus3" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                                <asp:ListItem Value="0">No</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                                <tr id="dvFeatureSelectUnit4" style="display:none;">
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureType4" AutoPostBack="true" OnSelectedIndexChanged="ddlFeatureType_onIndexChanged" runat="server">
		                                    </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureValue4" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureStatus4" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                                <asp:ListItem Value="0">No</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                                <tr id="dvFeatureSelectUnit5" style="display:none;">
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureType5" AutoPostBack="true" OnSelectedIndexChanged="ddlFeatureType_onIndexChanged" runat="server">
		                                    </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureValue5" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureStatus5" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                                <asp:ListItem Value="0">No</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                                <tr id="dvFeatureSelectUnit6" style="display:none;">
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureType6" AutoPostBack="true" OnSelectedIndexChanged="ddlFeatureType_onIndexChanged" runat="server">
		                                    </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureValue6" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureStatus6" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                                <asp:ListItem Value="0">No</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                                <tr id="dvFeatureSelectUnit7" style="display:none;">
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureType7" AutoPostBack="true" OnSelectedIndexChanged="ddlFeatureType_onIndexChanged" runat="server">
		                                    </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureValue7" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureStatus7" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                                <asp:ListItem Value="0">No</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                                <tr id="dvFeatureSelectUnit8" style="display:none;">
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureType8" AutoPostBack="true" OnSelectedIndexChanged="ddlFeatureType_onIndexChanged" runat="server">
		                                    </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureValue8" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureStatus8" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                                <asp:ListItem Value="0">No</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                                <tr id="dvFeatureSelectUnit9" style="display:none;">
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureType9" AutoPostBack="true" OnSelectedIndexChanged="ddlFeatureType_onIndexChanged" runat="server">
		                                    </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureValue9" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureStatus9" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                                <asp:ListItem Value="0">No</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                                <tr id="dvFeatureSelectUnit10" style="display:none;">
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureType10" AutoPostBack="true" OnSelectedIndexChanged="ddlFeatureType_onIndexChanged" runat="server">
		                                    </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureValue10" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlFeatureStatus10" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                                <asp:ListItem Value="0">No</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    
                            <br /><br /><a id="lnkAddFeatureUnit">+ Add</a> | <a id="lnkRemoveFeatureUnit">- Remove</a>
							<div class="clearboth"></div>
							
                        </div></div>

                        <div class="fieldset" style="margin-left:20px;">
						<div class="form_fields">
							<b>Media Operator</b>
						
                                <asp:DropDownList ID="ddlMediaOperator" runat="server">
                                    <asp:ListItem Value="1" Text="And"></asp:ListItem>
                                    <asp:ListItem Value="0" Text="Or"></asp:ListItem>
                                </asp:DropDownList>
                        
							<br /><br />
							<table id="tblMedia" border="0" cellpadding="2" cellspacing="0" class="adv_search">
                                <tr><td>Media type</td><td>Assigned</td></tr>
                                <tr id="dvMediaSelectUnit1" style="display:none;">
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlMediaType1" runat="server">
		                                    </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlMediaStatus1" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                                <asp:ListItem Value="0">No</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                                <tr id="dvMediaSelectUnit2" style="display:none;">
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlMediaType2" runat="server">
		                                    </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlMediaStatus2" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                                <asp:ListItem Value="0">No</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                                <tr id="dvMediaSelectUnit3" style="display:none;">
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlMediaType3" runat="server">
		                                    </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlMediaStatus3" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                                <asp:ListItem Value="0">No</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                                <tr id="dvMediaSelectUnit4" style="display:none;">
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlMediaType4" runat="server">
		                                    </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlMediaStatus4" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                                <asp:ListItem Value="0">No</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                                <tr id="dvMediaSelectUnit5" style="display:none;">
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlMediaType5" runat="server">
		                                    </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlMediaStatus5" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                                <asp:ListItem Value="0">No</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <br /><br /><a id="lnkAddMediaUnit">+ Add</a> | <a id="lnkRemoveMediaUnit">- Remove</a>
								
						</div></div>

						<div class="fieldset" style="margin-left:20px;">
							<div class="form_fields clearfix">
								<b>Link Operator</b>
                                <asp:DropDownList ID="ddlLinkOperator" runat="server">
                                    <asp:ListItem Value="1" Text="And"></asp:ListItem>
                                    <asp:ListItem Value="0" Text="Or"></asp:ListItem>
                                </asp:DropDownList>
								<br /><br />
			                    <table id="tblLink" border="0" cellpadding="0" cellspacing="0" class="adv_search">
                                <tr><td>Link type</td><td>Assigned</td></tr>
                                <tr id="dvLinkSelectUnit1" style="display:none;">
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlLinkType1" runat="server">
		                                    </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlLinkStatus1" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                                <asp:ListItem Value="0">No</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                                <tr id="dvLinkSelectUnit2" style="display:none;">
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlLinkType2" runat="server">
		                                    </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlLinkStatus2" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                                <asp:ListItem Value="0">No</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                                <tr id="dvLinkSelectUnit3" style="display:none;">
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlLinkType3" runat="server">
		                                    </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlLinkStatus3" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                                <asp:ListItem Value="0">No</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                                <tr id="dvLinkSelectUnit4" style="display:none;">
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlLinkType4" runat="server">
		                                    </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlLinkStatus4" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                                <asp:ListItem Value="0">No</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                                <tr id="dvLinkSelectUnit5" style="display:none;">
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlLinkType5" runat="server">
		                                    </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form_input">
                                            <asp:DropDownList ID="ddlLinkStatus5" runat="server">
                                                <asp:ListItem Value="">Please Select</asp:ListItem>
                                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                                <asp:ListItem Value="0">No</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <br /><br /><a id="lnkAddLinkUnit">+ Add</a> | <a id="lnkRemoveLinkUnit">- Remove</a>
								
						    <div class="clearboth"></div>
		                </div></div>
                    </div>
					<div class="clearboth"></div>
					<a id="lnkCancelAdvancedSearch" href="#">Cancel Advanced Search</a>
                </div>
			</div>
		</div>
                 
                  

        <div class="search_btn_bar clearfix">
		    <asp:Button ID="btnFilter" runat="server" OnClick="btnFilter_OnClick" Text="Search" CssClass="search_btn" /> | <asp:Button ID="btnExport" runat="server" OnClick="btnExport_OnClick" Text="Export" CssClass="search_btn" /> | <a id="lnkClearFilters" href="#">Clear</a>
		</div>
        <div class="letter_nav">
        <asp:HiddenField id="hdnLetterFilter" runat="server" />
        <asp:repeater id="rptLetters" runat="server">
            <SeparatorTemplate>&nbsp;|&nbsp;</SeparatorTemplate>
            <itemtemplate>
                <asp:linkbutton id="lnkLetter" runat="server" OnClick="lnkLetter_OnClick" commandname="Filter" commandargument='<%# Container.DataItem %>'><%# Container.DataItem %></asp:linkbutton>
            </itemtemplate>
        </asp:repeater>
        &nbsp;|&nbsp;<asp:LinkButton ID="lnkLetterAll" runat="server" OnClick="lnkLetter_OnClick" CommandName="Filter" CommandArgument=''>All</asp:LinkButton>
       </div>

        <asp:ListView ID="lvProducts" runat="server">
            <LayoutTemplate>
                <table border="0" cellpadding="0" cellspacing="0" class="tbl_data">
                        <tr class="tbl_header">
                            <td><strong>Product Name</strong></td>
                            <td><strong>Product Type</strong></td>
                            <td><strong>City/Community</strong></td>
                            <td><strong>Region</strong></td>
                            <td style="display:none;"><strong>Primary Contact</strong></td>
                            <td><strong>Displays</strong></td>
                        </tr>
                        <div id="itemPlaceholder" runat="server" />
                    </table>
            </LayoutTemplate>
            <ItemTemplate>
                <tr>
                    <td><a href='Edit.aspx?id=<%# Eval("productId") %>'><%# Eval("productName") %></a></td>
                    <td><%# Eval("productType") %></td>
                    <td><%# Eval("communityName") %></td>
                    <td><%# Eval("regionName") %></td>
                    <td  style="display:none;"><a href='../Contact/Edit.aspx?id=<%# Eval("contactId") %>'><%# Eval("primaryContactName") %></a></td>
                    <td><%# Eval("isDisplayed") %></td>
                </tr>
            </ItemTemplate>
        </asp:ListView>
   
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
