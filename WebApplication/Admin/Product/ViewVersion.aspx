<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewVersion.aspx.cs" Inherits="WebApplication.Admin.Product.ViewVersion" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Product History</title>
    <link href="../../Styles/prodCat.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../Scripts/jquery-1.6.2.min.js"></script>
    <style type="text/css">
        .fieldHasChanged {background-color: yellow;}
    </style>

    <script type="text/javascript">

        var fields = {
            productName: "<a href='#top'>Product name</a>",
            productTypeId: "<a href='#top'>Product type</a>",
            line1: "<a href='#Location'>Line 1</a>",
            line2: "<a href='#Location'>Line 1</a>",
            line3: "<a href='#Location'>Line 1</a>",
            communityId: "<a href='#Location'>City</a>",
            postalCode: "<a href='#Location'>Postal code</a>",
            subRegionId: "<a href='#Location'>General area</a>",
            webDirectionsEn: "<a href='#Location'>Web directions (en)</a>",
            webDirectionsFr: "<a href='#Location'>Web directions (fr)</a>",
            tollFree: "<a href='#Location'>Toll free</a>",
            reservationsOnly: "<a href='#Location'>Reservations only</a>",
            fax: "<a href='#Location'>Fax</a>",
            latitude: "<a href='#Location'>Latitude</a>",
            longitude: "<a href='#Location'>Longitude</a>",
            pv_printDirectionsEn: "<a href='#Location'>Print directions (en)</a>",
            pv_printDirectionsFr: "<a href='#Location'>Print directions (fr)</a>",
            webDescriptionEn: "<a href='#Description'>Web description (en)</a>",
            webDescriptionFr: "<a href='#Description'>Web description (fr)</a>",
            keywordsEn: "<a href='#Description'>Keywords (en)</a>",
            keywordsFr: "<a href='#Description'>Keywords (fr)</a>",
            pv_printDescriptionEn: "<a href='#Location'>Print description (en)</a>",
            pv_printDescriptionFr: "<a href='#Location'>Print description (fr)</a>",
            pv_unitDescriptionEn: "<a href='#Location'>Unit description (en)</a>",
            pv_unitDescriptionFr: "<a href='#Location'>Unit description (fr)</a>",
            periodOfOperationTypeId: "<a href='#Dates'>Period of operation</a>",
            openMonth: "<a href='#Dates'>Open month</a>",
            openDay: "<a href='#Dates'>Open day</a>",
            closeMonth: "<a href='#Dates'>Close month</a>",
            closeDay: "<a href='#Dates'>Close day</a>",
            lowRate: "<a href='#Dates'>Low rate</a>",
            highRate: "<a href='#Dates'>High rate</a>",
            hasOffSeasonRates: "<a href='#Dates'>Off season rates available</a>",
            noTax: "<a href='#Dates'>No tax</a>",
            rateTypeId: "<a href='#Dates'>Rate type</a>",
            cancellationPolicyId: "<a href='#Dates'>Cancellation policy</a>",
            dateDescriptionEn: "<a href='#Dates'>Date detail (en)</a>",
            dateDescriptionFr: "<a href='#Dates'>Date detail (fr)</a>",
            rateDescriptionEn: "<a href='#Dates'>Rate detail (en)</a>",
            rateDescriptionFr: "<a href='#Dates'>Rate detail (fr)</a>",
            cancellationPolicyEn: "<a href='#Dates'>Cancellation policy (en)</a>",
            cancellationPolicyFr: "<a href='#Dates'>Cancellation policy (fr)</a>",
            paymentTypeList: "<a href='#Dates'>Payment types</a>",
            pv_periodOfOperationTypeId: "<a href='#Dates'>Period of operation (print)</a>",
            pv_openMonth: "<a href='#Dates'>Open month (print)</a>",
            pv_openDay: "<a href='#Dates'>Open day (print)</a>",
            pv_closeMonth: "<a href='#Dates'>Close month (print)</a>",
            pv_closeDay: "<a href='#Dates'>Close day (print)</a>",
            pv_lowRate: "<a href='#Dates'>Low rate (print)</a>",
            pv_highRate: "<a href='#Dates'>High rate (print)</a>",
            pv_hasOffSeasonRates: "<a href='#Dates'>Off season rates available (print)</a>",
            pv_noTax: "<a href='#Dates'>No tax (print)</a>",
            pv_rateTypeId: "<a href='#Dates'>Rate type (print)</a>",
            pv_cancellationPolicyId: "<a href='#Dates'>Cancellation policy (print)</a>",
            pv_dateDescriptionEn: "<a href='#Dates'>Date detail (print/en)</a>",
            pv_dateDescriptionFr: "<a href='#Dates'>Date detail (print/fr)</a>",
            pv_rateDescriptionEn: "<a href='#Dates'>Rate detail (print/en)</a>",
            pv_rateDescriptionFr: "<a href='#Dates'>Rate detail (print/fr)</a>",
            checkInId: "<a href='#Features'>Check-in id</a>",
            canadaSelectRatingList: "<a href='#Features'>Canada select ratings</a>",
            caaRatingList: "<a href='#Features'>Caa ratings</a>",
            otherMemberships: "<a href='#Features'>Other memberships</a>",
            parkingSpaces: "<a href='#Features'>Parking spaces</a>",
            seatingCapacity: "<a href='#Features'>Seating capacity</a>",
            accessAdvisorList: "<a href='#Features'>Access advisor</a>",
            accommodationAmenityList: "<a href='#Features'>Accommodation amentity</a>",
            accommodationServiceList: "<a href='#Features'>Accommodation service</a>",
            accommodationTypeList: "<a href='#Features'>Accommodation type</a>",
            activityList: "<a href='#Features'>Activity</a>",
            approvedByList: "<a href='#Features'>Approved by</a>",
            areaOfInterestList: "<a href='#Features'>Area of interest</a>",
            artTypeList: "<a href='#Features'>Art product type</a>",
            campgroundAmenityList: "<a href='#Features'>Campground amenity</a>",
            coreExperienceList: "<a href='#Features'>Core experience</a>",
            cuisineList: "<a href='#Features'>Cuisine</a>",
            culturalHeritageList: "<a href='#Features'>Cultural heritage</a>",
            exhibitTypeList: "<a href='#Features'>Exhibit type</a>",
            featureList: "<a href='#Features'>Feature</a>",
            governmentLevelList: "<a href='#Features'>Government level</a>",
            membershipList: "<a href='#Features'>Membership</a>",
            petsPolicyList: "<a href='#Features'>Pets policy</a>",
            printOptionList: "<a href='#Features'>Print option</a>",
            productCategoryList: "<a href='#Features'>Product category</a>",
            restaurantServiceList: "<a href='#Features'>Restaurant service</a>",
            restaurantTypeList: "<a href='#Features'>Restaurant type</a>",
            shareInformationWithList: "<a href='#Features'>Share information with</a>",
            trailTypeList: "<a href='#Features'>Trail type</a>",
            transportationTypeList: "<a href='#Features'>Transportation type</a>",
            tourTypeList: "<a href='#Features'>Tour type</a>",
            isActive: "<a href='#Editor'>Is active</a>",
            isComplete: "<a href='#Editor'>Is complete</a>",
            confirmationDueDate: "<a href='#Editor'>Confirmation due date</a>",
            editorCheckList: "<a href='#Editor'>Editor checks</a>",
            checkboxLabel: "<a href='#Editor'>Checkbox label</a>",
            paymentReceived: "<a href='#Editor'>Payment received</a>",
            paymentAmount: "<a href='#Editor'>Payment amount</a>",
            isValid: "<a href='#Editor'>Is valid</a>",
            overrideErrors: "<a href='#Editor'>Override errors</a>",
            ownershipTypeId: "<a href='#ManagementOptions'>Ownership model</a>",
            isTicketed: "<a href='#ManagementOptions'>Is ticketed</a>",
            capacity: "<a href='#ManagementOptions'>Capacity</a>"
        };

        $(document).ready(function () {
            //alert("JUSTIN");
            //alert($("[id*=hdnProductFieldChangeList]").val());

            var cl = $("[id*=hdnProductFieldChangeList]").val();

            var arr = cl.split(',');

            var modifiedFieldList = "";

            $.each(arr, function (index, value) {
                //alert(value);
                //if (value )
                //$("[id*=lbl_" + value + "]").addClass("fieldHasChanged");

                if (!(fields[value] === undefined) && fields[value] != '') {
                    modifiedFieldList += fields[value] + ", ";
                    $("[id*=lbl_" + value + "]").addClass("fieldHasChanged");
                }
            });

            if (modifiedFieldList.length > 0) {
                modifiedFieldList = modifiedFieldList.substring(0, modifiedFieldList.length - 2);
            }


            //$("[id*=chg_" + value + "]").addClass("fieldHasChanged");

            //$("[id*=chg_modificationDate]").addClass("fieldHasChanged");

            //$("[id*=dvModifiedFieldList]").addClass("fieldHasChanged");

            $("[id*=dvModifiedFieldList]").html(modifiedFieldList);
        });
        
        
    
    
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="top" class="popup_view ui-corner-all">
        <h3>View History</h3>
        <asp:HiddenField ID="hdnVersionType" runat="server" />
        <asp:HiddenField ID="hdnProductFieldChangeList" runat="server" />

        <asp:Panel ID="pnlGuideDescriptionVersion" runat="server">
            <asp:ListView ID="lvGuideDescriptionVersionView" runat="server">
            <LayoutTemplate>
                <div id="itemPlaceholder" runat="server" />
            </LayoutTemplate>
            <ItemTemplate>
                <table cellpadding="0" cellspacing="0" border="0" class="pop_table fill">
                    <tr>
                        <td><strong >Last Modified</strong><br /><%# Eval("modificationDate") %></td>
                        <td><strong>Version</strong><br /><%# Eval("versionId") %></td>
                        <td><strong>Modified By</strong><br /><%# Eval("modifiedBy") %></td>
                    </tr>
                </table>
                
                <br /><br />

                <h2>Guide Description</h2>
                
                <table cellpadding="0" cellspacing="0" border="0" class="pop_table">
                    <tr>
                        <td>
                            <strong>Guide Description Type</strong>
                            <p><%# Eval("descriptionTypeId") %></p>                                       
                        </td>
                   </tr>
                   <tr>
						<td>
                            <strong>Description En</strong>
                            <p><%# Eval("descriptionEn") %></p>
                        </td>
                        <td>
                            <strong>Description Fr</strong>
                            <p><%# Eval("descriptionFr") %></p>
                        </td>
                    </tr>
                </table>
                </ItemTemplate>
                </asp:ListView>
        
        </asp:Panel>

        <asp:Panel ID="pnlMediaVersion" runat="server">
            <asp:ListView ID="lvMediaVersionView" runat="server">
            <LayoutTemplate>
                <div id="itemPlaceholder" runat="server" />
            </LayoutTemplate>
            <ItemTemplate>
                <table cellpadding="0" cellspacing="0" border="0" class="pop_table fill">
                    <tr>
                        <td><strong>Last Modified</strong><br /><%# Eval("modificationDate") %></td>
                        <td><strong>Version</strong><br /><%# Eval("versionId") %></td>
                        <td><strong>Modified By</strong><br /><%# Eval("modifiedBy") %></td>
                    </tr>
                </table>
                
                <br /><br />

                <h2>Media</h2>
                
                <table cellpadding="0" cellspacing="0" border="0" class="pop_table">
                    <tr>
                        <td>
                            <strong>Original File Name</strong>
                            <p><%# Eval("originalFileName") %></p>
                            <strong>Media Type</strong>
                            <p><%# Eval("mediaTypeId") %></p>                                       
                        </td>
                        <td>
                            <strong>Media Language</strong>
                            <p><%# Eval("mediaLanguageId") %></p>
                            <strong>Sort Order</strong>
                            <p><%# Eval("sortOrder") %></p>                       
                        </td>
                   </tr>
                   <tr>
						<td>
                            <strong>Media Title En</strong>
                            <p><%# Eval("titleEn") %></p>
                            <strong>Caption En</strong>
                            <p><%# Eval("captionEn") %></p>
                        </td>
                        <td>
                            <strong>Media Title Fr</strong>
                            <p><%# Eval("titleFr") %></p>
                            <strong>Caption Fr</strong>
                            <p><%# Eval("captionFr") %></p>
                        </td>
					</tr>
                </table>
                </ItemTemplate>
                </asp:ListView>
        
        </asp:Panel>

        <asp:Panel ID="pnlUrlVersion" runat="server">
         
        <asp:ListView ID="lvUrlVersionView" runat="server">
            <LayoutTemplate>
                <div id="itemPlaceholder" runat="server" />
            </LayoutTemplate>
            <ItemTemplate>
                <table cellpadding="0" cellspacing="0" border="0" class="pop_table fill">
                    <tr>
                        <td><strong>Last Modified</strong><br /><%# Eval("modificationDate") %></td>
                        <td><strong>Version</strong><br /><%# Eval("versionId") %></td>
                        <td><strong>Modified By</strong><br /><%# Eval("modifiedBy") %></td>
                    </tr>
                </table>
                
                <br /><br />

                <h2>Url</h2>
                
                <table cellpadding="0" cellspacing="0" border="0" class="pop_table">
                    <tr>
                        <td>
                            <strong>url</strong>
                            <p><%# Eval("url") %></p>

                            <strong>Url Type</strong>
                            <p><%# Eval("urlTypeId") %></p>                                       
                        </td>
                        <td>
                            <strong>Url Title</strong>
                            <p><%# Eval("titleEn") %></p>
                            <strong>Description</strong>
                            <p><%# Eval("descriptionEn") %></p>
                        </td>
                        <td>
                            <strong>Url Title</strong>
                            <p><%# Eval("titleFr") %></p>
                            <strong>Description</strong>
                            <p><%# Eval("descriptionFr") %></p>
                        </td>
                        <td>
                            <strong>Distance</strong>
                            <p><%# Eval("distance") %></p>
                        </td>
                   </tr>
                </table>
                </ItemTemplate>
                </asp:ListView>
        </asp:Panel>

        <asp:Panel ID="pnlProductVersion" runat="server">
        
        <asp:ListView ID="lvProductVersionView" runat="server">
            <LayoutTemplate>
                <div id="itemPlaceholder" runat="server" />
            </LayoutTemplate>
            <ItemTemplate>
                <table cellpadding="0" cellspacing="0" border="0" class="pop_table fill">
                    <tr>
                        <td><strong id="lbl_modificationDate">Last Modified</strong><br /><%# Eval("modificationDate") %></td>
                        <td><strong >Version</strong><br /><%# Eval("versionId") %></td>
                        <td><strong>Modified By</strong><br /><%# Eval("modifiedBy") %></td>
                    </tr>
                    <tr><td colspan="3"><strong>Modified Fields:</strong><br/><div id="dvModifiedFieldList">Last Modified, evil sucks, longs lists suck, conan sucks</div></td></tr>
                </table>
                
                <br /><br />

                <h2>Product</h2>

                <table cellpadding="0" cellspacing="0" border="0" class="pop_table">
                    <tr>
                        <td>
                            <strong id="lbl_productName">Product name</strong>
                            <p><%# Eval("productName") %></p>
                            <strong id="lbl_productTypeId">Product type</strong>
                            <p><%# Eval("productTypeName") %></p>  
                        </td>
                        <td>
                            <strong id="lbl_email">Email</strong>
                            <p><%# Eval("email") %></p>
                            <strong id="lbl_web">Website</strong>
                            <p><%# Eval("web") %></p>
                        </td>
                        <td>&nbsp;</td>
                   </tr>
                </table>

                <div class="popup_nav">
                    <ul>
                        <li class="first"><a href="#Location">Location & Phone</a></li>
                        <li><a href="#Description">Description</a></li>
                        <li><a href="#Dates">Dates & Rates</a></li>
                        <li><a href="#Features">Features</a></li>
                        <li><a href="#Editor">Editor</a></li>
                        <li><a href="#ManagementOptions">Management Options</a></li>
                        <li><a href="#Contacts">Contacts</a></li>
                    </ul>
                </div>
                
                
                <h2 id="Location">Location & Phone</h2>

                <div class="fieldset clearfix">
                    <div class="form_left">
                        <div class="form_fields clearfix">
                            <div class="form_label" id="lbl_proprietor"><label>Proprietor</label></div>
                            <div class="form_input"><%# Eval("proprietor") %></div>
                        </div>
                        <div class="form_fields clearfix">
                            <div class="form_label" id="lbl_telephone"><label>Telephone</label></div>
                            <div class="form_input"><%# Eval("telephone") %></div>
                        </div>
                        <div class="form_fields clearfix">
                            <div class="form_label" id="lbl_secondaryPhone"><label>Secondary phone</label></div>
                            <div class="form_input"><%# Eval("secondaryPhone") %></div>
                        </div>
                        <div class="form_fields clearfix">
                            <div class="form_label" id="lbl_offSeasonPhone"><label>Off season phone</label></div>
                            <div class="form_input"><%# Eval("offSeasonPhone") %></div>
                        </div>
                        <div class="form_fields clearfix">
                            <div class="form_label" id="lbl_line1"><label>Address 1</label></div>
                            <div class="form_input"><%# Eval("line1") %></div>
                        </div>
                        <div class="form_fields clearfix">
                            <div class="form_label" id="lbl_line2"><label>Address 2</label></div>
                            <div class="form_input"><%# Eval("line2") %></div>
                        </div>
                        <div class="form_fields clearfix">
                            <div class="form_label" id="lbl_line3"><label>Address 3</label></div>
                            <div class="form_input"><%# Eval("line3") %></div>
                        </div>
                        <div class="form_fields clearfix">
                            <div class="form_label" id="lbl_communityId"><label>City/Community</label></div>
                            <div class="form_input"><%# Eval("communityName") %></div>
                        </div>
                        <div class="form_fields clearfix">
                            <div class="form_label" id="lbl_postalCode"><label>Postal Code</label></div>
                            <div class="form_input"><%# Eval("postalCode") %></div>
                        </div>
                        <div class="form_fields clearfix">
                            <div class="form_label" id="lbl_subRegionId"><label>General Area</label></div>
                            <div class="form_input"><%# Eval("subRegionName") %></div>
                        </div>
                        <div class="form_fields clearfix">
                            <div class="form_label" id="lbl_directionsEn"><label>Web Directions - en</label></div>
                            <div class="form_input"><%# Eval("directionsEn") %></div>
                        </div>
                        <div class="form_fields clearfix">
                            <div class="form_label" id="lbl_directionsFr"><label>Web Directions - fr</label></div>
                            <div class="form_input"><%# Eval("directionsFr") %></div>
                        </div>
                    </div>
                    <div class="form_right">                
                        <div class="form_fields clearfix">
                            <div class="form_label" id="lbl_tollFree"><label>Toll Free</label></div>
                            <div class="form_input"><%# Eval("tollfree") %></div>
                        </div>
                        <div class="form_fields clearfix">
                            <div class="form_label" id="lbl_reservationsOnly"><label>Reservations only</label></div>
                            <div class="form_input"><%# Eval("reservationsOnly") %></div>
                        </div>
                        <div class="form_fields clearfix">
                            <div class="form_label" id="lbl_fax"><label>Fax</label></div>
                            <div class="form_input"><%# Eval("fax") %></div>
                        </div>
                        <div class="form_fields clearfix">
                            <div class="form_label" id="lbl_latitude"><label>Latitude</label></div>
                            <div class="form_input"><%# Eval("latitude") %></div>
                        </div>
                        <div class="form_fields clearfix">
                            <div class="form_label" id="lbl_longitude"><label>Longitude</label></div>
                            <div class="form_input"><%# Eval("longitude") %></div>
                        </div>
                        <div class="form_fields clearfix">
                            <div class="form_label" id="lbl_pv_directionsEn"><label>Print Directions - en</label></div>
                            <div class="form_input"><%# Eval("printVersion.directionsEn")%></div>
                        </div>
                        <div class="form_fields clearfix">
                            <div class="form_label" id="lbl_pv_directionsFr"><label>Print Directions - fr</label></div>
                            <div class="form_input"><%# Eval("printVersion.directionsFr")%></div>
                        </div>
                    </div>
                </div>
                
                
                <div class="popup_backtotop"><a href="#top">TOP</a></div>
                
                <h2 id="Description">Description</h2>
                <div class="fieldset clearfix">
                    <div class="form_left">
                        <h3>Web content</h3>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_webDescriptionEn"><label>Web description - en</label></div>
			                <div class="form_input"><%# Eval("webDescriptionEn") %></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_webDescriptionFr"><label>Web description - fr</label></div>
			                <div class="form_input"><%# Eval("webDescriptionFr") %></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_keywordsEn"><label>Keywords - en</label></div>
			                <div class="form_input"><%# Eval("keywordsEn") %></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_keywordsFr"><label>Keyword - fr</label></div>
			                <div class="form_input"><%# Eval("keywordsFr") %></div>
		                </div>
                    </div>
                    <div class="form_right">
                        <h3>Print content</h3>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_pv_printDescriptionEn"><label>Print description - en</label></div>
			                <div class="form_input"><%# Eval("printVersion.printDescriptionEn")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_pv_printDescriptionFr"><label>Print description - fr</label></div>
			                <div class="form_input"><%# Eval("printVersion.printDescriptionFr")%></div>
		                </div>
                        <div id="dvUnitDescriptionEn" class="form_fields clearfix">
			                <div class="form_label" id="lbl_pv_unitDescriptionEn"><label>Unit description - en</label></div>
			                <div class="form_input"><%# Eval("printVersion.unitDescriptionEn")%></div>
		                </div>
                        <div id="dvUnitDescriptionFr" class="form_fields clearfix">
			                <div class="form_label" id="lbl_pv_unitDescriptionFr"><label>Unit description - fr</label></div>
			                <div class="form_input"><%# Eval("printVersion.unitDescriptionFr")%></div>
		                </div>
                    </div>
                </div>

                <div class="popup_backtotop"><a href="#top">TOP</a></div>
                
                
                <h2 id="Dates">Dates & Rates</h2>
                <div class="fieldset clearfix">
                    <div class="form_left">
                        <h3>Web Open and Close Dates</h3>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_periodOfOperationTypeId"><label>Period of operation</label></div>
			                <div class="form_input"><%# Eval("periodOfOperationTypeName") %></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_openMonth"><label id="lbl_openDay">Open date</label></div>
			                <div class="form_input"> <%# Eval("openMonthName") %> <%# Eval("openDay") %></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_closeMonth"><label id="lbl_closeDay">Close date</label></div>
			                <div class="form_input"> <%# Eval("closeMonthName") %> <%# Eval("closeDay") %></div>
		                </div>
                        
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_lowRate"><label>Low rate</label></div>
			                <div class="form_input"><%# Eval("lowRate") %></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_highRate"><label>High rate</label></div>
			                <div class="form_input"><%# Eval("highRate") %></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label"  id="lbl_hasOffSeasonRates"><label>Off season rates available</label></div>
			                <div class="form_input"><%# Eval("hasOffSeasonRates") %></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label"  id="lbl_noTax"><label>No tax</label></div>
			                <div class="form_input"><%# Eval("noTax") %></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_rateTypeId"><label>Rate type</label></div>
			                <div class="form_input"><%# Eval("rateTypeName") %></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label"  id="lbl_cancellationPolicyId"><label>Cancellation policy</label></div>
			                <div class="form_input"><%# Eval("cancellationPolicyName") %></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_dateDescriptionEn"><label>Date detail - en</label></div>
			                <div class="form_input"><%# Eval("dateDescriptionEn") %></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_dateDescriptionFr"><label>Date detail - fr</label></div>
			                <div class="form_input"><%# Eval("dateDescriptionFr") %></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_rateDescriptionEn"><label>Rate detail - en</label></div>
			                <div class="form_input"><%# Eval("rateDescriptionEn") %></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_rateDescriptionFr"><label>Rate detail - fr</label></div>
			                <div class="form_input"><%# Eval("rateDescriptionFr") %></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_cancellationPolicyEn"><label>Cancellation policy - en</label></div>
			                <div class="form_input"><%# Eval("cancellationPolicyEn")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_cancellationPolicyFr"><label>Cancellation policy - fr</label></div>
			                <div class="form_input"><%# Eval("cancellationPolicyFr") %></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_paymentTypeList"><label>Payment types</label></div>
			                <div class="form_input"><%# Eval("paymentTypeList") %></div>
		                </div>
                     </div>
                    <div class="form_right">
                        <h3>Print Open and Close Dates</h3>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_pv_periodOfOperationTypeId"><label>Period of Operation</label></div>
			                <div class="form_input"><%# Eval("printVersion.periodOfOperationTypeName")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_pv_openMonth"><label id="lbl_pv_openDay">Open Date</label></div>
			                <div class="form_input"> <%# Eval("printVersion.openMonthName")%> <%# Eval("printVersion.openDay")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_pv_closeMonth"><label id="lbl_pv_closeDay">Close Date</label></div>
			                <div class="form_input"> <%# Eval("printVersion.closeMonthName")%> <%# Eval("printVersion.closeDay")%></div>
		                </div>
                        
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_pv_lowRate"><label>Low Rate</label></div>
			                <div class="form_input"><%# Eval("printVersion.lowRate")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_pv_highRate"><label>High Rate</label></div>
			                <div class="form_input"><%# Eval("printVersion.highRate")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_pv_hasOffSeasonRates"><label>Off season rates available</label></div>
			                <div class="form_input"><%# Eval("printVersion.hasOffSeasonRates")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_pv_noTax"><label>No tax</label></div>
			                <div class="form_input"><%# Eval("printVersion.noTax")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_pv_rateTypeId"><label>Rate Type</label></div>
			                <div class="form_input"><%# Eval("printVersion.rateTypeName")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_pv_cancellationPolicyId"><label>Cancellation Policy</label></div>
			                <div class="form_input"><%# Eval("printVersion.cancellationPolicyName")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_pv_dateDescriptionEn"><label>Date Detail - en</label></div>
			                <div class="form_input"><%# Eval("printVersion.dateDescriptionEn")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_pv_dateDescriptionFr"><label>Date Detail - fr</label></div>
			                <div class="form_input"><%# Eval("printVersion.dateDescriptionFr")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_pv_rateDescriptionEn"><label>Rate Detail - en</label></div>
			                <div class="form_input"><%# Eval("printVersion.rateDescriptionEn")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_pv_rateDescriptionFr"><label>Rate Detail - fr</label></div>
			                <div class="form_input"><%# Eval("printVersion.rateDescriptionFr")%></div>
		                </div>
                    </div>
                </div>

                <div class="popup_backtotop"><a href="#top">TOP</a></div>
                                
                
                <h2 id="Features">Features</h2>
                <div class="fieldset clearfix">
                    <div class="form_left">
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_checkInId"><label>Check-In ID</label></div>
			                <div class="form_input"><%# Eval("checkInId") %></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_canadaSelectRatingList"><label>Canada Select Ratings</label></div>
			                <div class="form_input"><%# Eval("canadaSelectRatingList") %></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_accessCanadaRating"><label>Caa Ratings</label></div>
			                <div class="form_input"><%# Eval("accessCanadaRating") %></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_otherMemberships"><label>Other memberships</label></div>
			                <div class="form_input"><%# Eval("otherMemberships") %></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_parkingSpaces"><label>Parking spaces</label></div>
			                <div class="form_input"><%# Eval("parkingSpaces") %></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_seatingCapacity"><label>Seating capacity</label></div>
			                <div class="form_input"><%# Eval("seatingCapacity") %></div>
		                </div>
                    </div>
                    <div class="form_right">
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_accessAdvisorList"><label>Access advisor</label></div>
			                <div class="form_input"><%# Eval("accessAdvisorList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_accommodationAmenityList"><label>Accommodation amenities</label></div>
			                <div class="form_input"><%# Eval("accommodationAmenityList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_accommodationServiceList"><label>Accommodation services</label></div>
			                <div class="form_input"><%# Eval("accommodationServiceList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_accommodationTypeList"><label>Accommodation types</label></div>
			                <div class="form_input"><%# Eval("accommodationTypeList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_activityList"><label>Activity</label></div>
			                <div class="form_input"><%# Eval("activityList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_approvedByList"><label>Approved by</label></div>
			                <div class="form_input"><%# Eval("approvedByList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_areaOfInterestList"><label>Area of interest</label></div>
			                <div class="form_input"><%# Eval("areaOfInterestList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_artTypeList"><label>Art product type</label></div>
			                <div class="form_input"><%# Eval("artTypeList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_campgroundAmentityList"><label>Campground amenity</label></div>
			                <div class="form_input"><%# Eval("campgroundAmenityList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_coreExperienceList"><label>Core experience</label></div>
			                <div class="form_input"><%# Eval("coreExperienceList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_cuisineList"><label>Cuisine</label></div>
			                <div class="form_input"><%# Eval("cuisineList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_culturalHeritageList"><label>Cultural heritage</label></div>
			                <div class="form_input"><%# Eval("culturalHeritageList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_exhibitTypeList"><label>Exhibit type</label></div>
			                <div class="form_input"><%# Eval("exhibitTypeList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_featureList"><label>Feature</label></div>
			                <div class="form_input"><%# Eval("featureList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_governmentLevelList"><label>Government level</label></div>
			                <div class="form_input"><%# Eval("governmentLevelList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_mediumList"><label>Medium</label></div>
			                <div class="form_input"><%# Eval("mediumList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_membershipList"><label>Membership</label></div>
			                <div class="form_input"><%# Eval("membershipList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_petsPolicyList"><label>Pets policy</label></div>
			                <div class="form_input"><%# Eval("petsPolicyList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_printOptionList"><label>Print options</label></div>
			                <div class="form_input"><%# Eval("printOptionList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_productCategoryList"><label>Product category</label></div>
			                <div class="form_input"><%# Eval("productCategoryList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_restaurantServiceList"><label>Restaurant services</label></div>
			                <div class="form_input"><%# Eval("restaurantServiceList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_restaurantSpecialtyList"><label>Restaurant specialty</label></div>
			                <div class="form_input"><%# Eval("restaurantSpecialtyList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_restaurantTypeList"><label>Restaurant type</label></div>
			                <div class="form_input"><%# Eval("restaurantTypeList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_shareInformationWithList"><label>Share Information With</label></div>
			                <div class="form_input"><%# Eval("shareInformationWithList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_trailTypeList"><label>Trail type</label></div>
			                <div class="form_input"><%# Eval("trailTypeList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_transportationTypeList"><label>Transportation type</label></div>
			                <div class="form_input"><%# Eval("transportationTypeList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_tourTypeList"><label>Tour type</label></div>
			                <div class="form_input"><%# Eval("tourTypeList")%></div>
		                </div>
                    </div>
                </div>

                <div class="popup_backtotop"><a href="#top">TOP</a></div>
                                
                
                <h2 id="Editor">Editor</h2>
                <div class="fieldset clearfix">
                    <div class="form_left">
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_isActive"><label>Is Active</label></div>
			                <div class="form_input"><%# Eval("isActive")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_isComplete"><label>Is Complete</label></div>
			                <div class="form_input"><%# Eval("isComplete")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_confirmationDueDate"><label>Confirmation form due date</label></div>
			                <div class="form_input"><%# Eval("confirmationDueDate")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_editorCheckList"><label>Edit checks</label></div>
			                <div class="form_input"><%# Eval("editorCheckList")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_checkboxLabel"><label>Checkbox label</label></div>
			                <div class="form_input"><%# Eval("checkboxLabel")%></div>
		                </div>
                     </div>
                    <div class="form_right">
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_paymentReceived"><label>Payment received</label></div>
			                <div class="form_input"><%# Eval("paymentReceived")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_paymentAmount"><label>Payment amount</label></div>
			                <div class="form_input"><%# Eval("paymentAmount")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_isValid"><label>Is Valid</label></div>
			                <div class="form_input"><%# Eval("isValid")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_overrideErrors"><label>Override errors</label></div>
			                <div class="form_input"><%# Eval("overrideErrors")%></div>
		                </div>
                    </div>
                </div>

                <div class="popup_backtotop"><a href="#top">TOP</a></div>
                                
                
                <h2 id="ManagementOptions">Management Options</h2>
                <div class="fieldset clearfix">
                    <div class="form_left">
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_ownershipTypeId"><label>Ownership model</label></div>
			                <div class="form_input"><%# Eval("ownershipTypeName")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_isTicketed"><label>Ticketed</label></div>
			                <div class="form_input"><%# Eval("isTicketed")%></div>
		                </div>
                     </div>
                    <div class="form_right">
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_capacityTypeId"><label>Capacity</label></div>
			                <div class="form_input"><%# Eval("capacityTypeName")%></div>
		                </div>
                        <div class="form_fields clearfix">
			                <div class="form_label" id="lbl_sustainabilityTypeId><label>Economic sustainability</label></div>
			                <div class="form_input"><%# Eval("sustainabilityTypeName")%></div>
		                </div>
                    </div>
                </div>

                <div class="popup_backtotop"><a href="#top">TOP</a></div>
                                
                
                <h2 id="Contacts">Contacts</h2>
                <div class="fieldset clearfix">
					<table border="0" cellpadding="0" cellspacing="0" class="tbl_data">
						<tr class="tbl_header">
							<td style="width:15%;"><strong>Contact Type</strong></td>
							<td style="width:85%;"><strong>Name</strong></td>
						</tr>
					<asp:ListView ID="lvProductContact" runat="server" DataSource='<%# Eval("contacts") %>'>
						<LayoutTemplate>
							<div id="itemPlaceholder" runat="server" />
						</LayoutTemplate>
						<ItemTemplate>
							<tr>
								<td><%# Eval("contactTypeName") %></td>
								<td><%# Eval("firstName") %> <%# Eval("lastName") %></td>
							</tr>
						</ItemTemplate>
					</asp:ListView>
					</table>
				</div>
				
                <div class="popup_backtotop"><a href="#top">TOP</a></div>
                

            </ItemTemplate>
        </asp:ListView>

    </asp:Panel>
    
    </div>
    </form>
</body>
</html>
