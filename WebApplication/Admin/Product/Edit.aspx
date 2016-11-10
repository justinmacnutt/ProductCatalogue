<%@ Page Language="C#" MasterPageFile="~/prodCat.master" AutoEventWireup="true" CodeBehind="Edit.aspx.cs" Inherits="WebApplication.Admin.Product.Edit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="cHeadContent" ContentPlaceHolderID="cphHeadContent" Runat="Server">
    <script src="https://maps-api-ssl.google.com/maps/api/js?v=3&sensor=false"type="text/javascript"></script>
	<script type="text/javascript" src="../../Scripts/jquery.wysiwyg.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.tmpl.min.js"></script>
    <link href="../../Styles/jquery.tagit.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/tag-it.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.iframe-transport.js"></script>
    <script src="../../Scripts/jquery.fileupload.js"></script>
    <script src="../../Scripts/jquery.fileupload-ui.js"></script>
    <script src="../../Scripts/date.js"></script>
	
    <script type="text/javascript">
        var map;

        var geocoder;

        var markersArray = [];

        var availableTags = [ <%= AvailableTags %> ];
        
        function GeneratePromotionPeriodList() {
            var productId = $("[id*=hdnProductId]").val();
            
            var dataString = '{"productId":"' + productId + '"}';
            
            $.ajax({
                type: "POST",
                url: "Edit.aspx/GetPromotionPeriodList",
                data: dataString,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var x = msg.d;
                    
                    var myLength = x.length;

                    if (myLength > 0) {
                        var myPromotionTable = '<table id="tblPromotionPeriodList" border="0" cellpadding="0" cellspacing="0" class="tbl_data">';
                        myPromotionTable += '<tr class="tbl_header"><td style="width:35%;"><strong>Start Date</strong></td><td style="width:35%;"><strong>End Date</strong></td><td style="width:30%;"><strong>Action</strong></td></tr>';
                        //alert(x.length);
                        for (var q = 0; q < myLength; q++) {
                            var myStartDate = new Date(x[q].startDate);
                            
                            myPromotionTable += "<tr>";
                            myPromotionTable += "<td>" + x[q].startDateDisplay + "</td>";
                            myPromotionTable += "<td>" + x[q].endDateDisplay + "</td>";
                            myPromotionTable += "<td><a id='lnkEditPromotionPeriod' startDate='" + x[q].startDate + "' endDate='" + x[q].endDate + "' promotionPeriodId='" + x[q].promotionPeriodId + "'>Edit</a> | <a id='lnkDeletePromotionPeriod' promotionPeriodId='" + x[q].promotionPeriodId + "'>Delete</a></td>";
                            myPromotionTable += "</tr>";
                        }

                        myPromotionTable += "</table>";
                        
                        $("#dvPromotionPeriodList").html(myPromotionTable);
                    }
                    else {
                        $("#dvPromotionPeriodList").html("No promotion periods have been assigned.<br/><br/>");
                    }
                },
                error: function (xhr, status, error) {
                    // Display a generic error for now.
                    alert("AJAX Error! Generate Promotion Period List");
                }
            });
        }
        
        function ProcessPromotionPeriod(promotionPeriodId, startDate, endDate) {
            var productId = $("[id*=hdnProductId]").val();
            
            var dataString = '{"productId":"' + productId + '","promotionPeriodId":"' + promotionPeriodId + '","startDate":"' + startDate + '","endDate":"' + endDate + '"}';
            
            $.ajax({
                type: "POST",
                url: "Edit.aspx/ProcessPromotionPeriod",
                data: dataString,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var x = msg.d;

                    $("[id*=hdnPromotionPeriodId]").val("");
                    
                    $("[id*=tbPromotionStartDate]").val("");
                    $("[id*=tbPromotionEndDate]").val("");
                    
                    GeneratePromotionPeriodList();
                },
                error: function (xhr, status, error) {
                    var x = JSON.parse(xhr.responseText);
                    
                    alert("AJAX Error! Process Promotion Period..." + x.Message);
                }
            });
        }
        
        function DeletePromotionPeriod(promotionPeriodId) {
            
            var dataString = '{"promotionPeriodId":"' + promotionPeriodId + '"}';
            
            $.ajax({
                type: "POST",
                url: "Edit.aspx/DeletePromotionPeriod",
                data: dataString,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var x = msg.d;
                    
                    $("[id*=hdnPromotionPeriodId]").val("");
                    
                    $("[id*=tbPromotionStartDate]").val("");
                    $("[id*=tbPromotionEndDate]").val("");
                    
                    GeneratePromotionPeriodList();
                },
                error: function (xhr, status, error) {
                    var x = JSON.parse(xhr.responseText);
                    
                    alert("AJAX Error! Delete Promotion Period..." + x.Message);
                }
            });
        }

        function GenerateForm(formType) {
            //alert(formType);
            var productId = $("[id*=hdnProductId]").val();
            var productTypeId = $("[id*=hdnProductTypeId]").val();
            var url = '/Admin/Product/Report/FormGeneration.aspx?printGuideFormTypeId=' + formType + '&productId=' + productId + '&productTypeId=' + productTypeId;
            // alert(url);
            window.open(url);
            //return true;
        }

        function ViewFileMakerArchive(archiveType) {
            var productId = $("[id*=hdnProductId]").val();
            var url = 'ViewFileMakerArchive.aspx?archiveTypeId=' + archiveType + '&productId=' + productId;
            // alert(url);
            window.open(url);
        }

        // Removes the overlays from the map, but keeps them in the array
        function clearMarkers() {
            if (markersArray) {
                for (i in markersArray) {
                    markersArray[i].setMap(null);
                }
                markersArray.length = 0;
            }
        }

        $(document).ready(function () {
            GeneratePromotionPeriodList();

            $('#tbTags').val($("[id*=hdnTags]").val());

            $('#tbTags').tagit({
                autocomplete: { delay: 0, minLength: 2, source: availableTags },
                allowSpaces: true,
                afterTagAdded: function (event, ui) {
                    //alert($("#tbTags").val());

                    $("[id*=hdnTags]").val($("#tbTags").val());

                },
                afterTagRemoved: function (event, ui) {
                    //alert($("#tbTags").val());

                    $("[id*=hdnTags]").val($("#tbTags").val());

                }
            });

            $("[id*=mn_products]").addClass("current");
            //$("#accordion").accordion({ collapsible: true, active: false, clearStyle: true });


            var currentTab = $(document).attr('location').hash.replace(/!/, "");

            $('#tabs').bind('tabsshow', function (event, ui) {
                // Add hash to location
                window.location.hash = ui.tab.hash + "!";

                $("[id*=hdnCurrentTabHash]").val(window.location.hash);

                if (ui.tab.hash == "#fragment-8") {
                    RefreshValidationErrors();
                }
            });

            $("#tabs").tabs();

            $('#tabs').tabs('select', currentTab);

            $(".feature_toggle").click(function () {
                $(this).toggleClass('plus').toggleClass('minus');
                $(this).siblings(".section_body").slideToggle(250);

                return false;
            });

            $("[id*=tbConfirmationDueDate]").datepicker({ dateFormat: 'dd-mm-yy' });
            $("[id*=tbConfirmationLastReceived]").datepicker({ dateFormat: 'dd-mm-yy' });

            DisableDivCheckboxes("dvArtType", 2);
            DisableDivCheckboxes("dvMedium", 2);
            DisableDivCheckboxes("dvRestaurantType", 2);
            DisableDivCheckboxes("dvRestaurantSpecialty", 2);

            MakeProductTypeAdjustments();
            MakeSeasonalFormAdjustments();
            MakePrintSeasonalFormAdjustments();

            InitializeMap();
            InitializeEventBindings();

            $("[id*=fragment-4]").find(".section_body").each(function () {
                GenerateSelectedCheckboxList($(this));
            });

            $("[id*=fragment-4]").find("input:checkbox").click(function () {
                //                alert($this.parent().parent().attr("id"));
                GenerateSelectedCheckboxList($(this).parent().parent());
            });
            $('.wysiwyg').wysiwyg();

            if ($("[id*=cvLicenseNumber]").attr("style").indexOf("none") != -1) {
                //alert("apparently hidden");
            }
            else {
                $('#aTab4').addClass('invalid');
                //    alert("apparently visible");
            }


            $("[id*=lnkAddOperationalPeriod]").click();
        });

        function MakeCrossReferenceFormAdjustments() {
            if ($("[id*=rblGuideSection]:checked").val() == "5") {
                $("[id*=dvGuideSectionOutdoors]").show();
                $("[id*=dvGuideSectionTourOps]").hide();
                ValidatorEnable($get("<%=rfvGuideSectionOutdoors.ClientID%>"), true);
                ValidatorEnable($get("<%=rfvGuideSectionTourOps.ClientID%>"), false);
                $get("<%=rfvGuideSectionOutdoors.ClientID%>").style.display = "none";
            }
            else {
                $("[id*=dvGuideSectionOutdoors]").hide();
                $("[id*=dvGuideSectionTourOps]").show();
                ValidatorEnable($get("<%=rfvGuideSectionOutdoors.ClientID%>"), false);
                ValidatorEnable($get("<%=rfvGuideSectionTourOps.ClientID%>"), true);
                $get("<%=rfvGuideSectionTourOps.ClientID%>").style.display = "none";
            }
        }

        function MakeProductTypeAdjustments() {

            switch ($("[id*=hdnProductType]").val()) {
                //Accommodation  
                case "1":
                    $("[id*=tbLicenseNumber]").addClass("integerOnly");

                    $("[id*=liOperationalDatesTab]").show();

                    $("#listingproof_link").css({ "display": "inline" });

                    $("[id*=dvRatings]").show();
                    $("[id*=dvLicenseNumber]").show();
                    $("[id*=dvCheckIn]").show();

                    $("[id*=dvAccessAdvisor]").show();
                    $("[id*=dvAccommodationAmenities]").show();
                    $("[id*=dvAccommodationService]").show();
                    $("[id*=dvAccommodationType]").show();
                    $("[id*=dvApprovedBy]").show();
                    $("[id*=dvCanadaSelectRatings]").show();
                    $("[id*=dvPetsPolicy]").show();
                    $("[id*=dvShareInformationWith]").show();
                    $("[id*=dvOtherMemberships]").show();

                    $("[id*=dvAreaOfInterest]").hide();
                    $("[id*=dvCulturalHeritage]").hide();

                    $("[id*=dvWebLowRate]").show();
                    $("[id*=dvWebHighRate]").show();
                    $("[id*=dvWebExtraPersonRate]").show();
                    $("[id*=dvWebHasOffSeasonDates]").show();
                    $("[id*=dvWebHasOffSeasonRates]").show();
                    $("[id*=dvWebRateIncludesTax]").show();
                    $("[id*=dvWebRateType]").show();
                    $("[id*=dvWebRatePeriod]").show();
                    $("[id*=dvWebCancellationPolicy]").show();

                    $("[id*=dvWebRateDescriptionGroup]").show();

                    $("[id*=dvPrintLowRate]").show();
                    $("[id*=dvPrintHighRate]").show();
                    $("[id*=dvPrintExtraPersonRate]").show();
                    $("[id*=dvPrintHasOffSeasonDates]").show();
                    $("[id*=dvPrintHasOffSeasonRates]").show();
                    $("[id*=dvPrintRateIncludesTax]").show();
                    $("[id*=dvPrintRateType]").show();
                    $("[id*=dvPrintRatePeriod]").show();
                    $("[id*=dvPrintCancellationPolicy]").show();

                    $("[id*=dvPrintRateDescriptionGroup]").show();

                    $("[id*=dvPrintUnitDescription]").show();

                    $("[id*=dvWebCancellationPolicyDesc]").show();

                    $("[id*=dvOperationPeriod]").show();

                    //TravelAgentCommissionFeature
                    $("[id*=dv11_522]").show();

                    //Membership 
                    $("[id*=dv15_701]").show();
                    $("[id*=dv15_702]").show();
                    $("[id*=dv15_704]").show();
                    $("[id*=dv15_705]").show();

                    //Print Guide items
                    //Outdoors
                    $("#pg_canoe").show();
                    $("#pg_cc_ski").show();
                    $("#pg_cycle").show();
                    $("#pg_dh_ski").show();
                    $("#pg_golf").show();
                    $("#pg_hiking").show();
                    $("#pg_kayaking").show();
                    $("#pg_snowshoe").show();
                    $("#pg_sport_fish").show();
                    //Features
                    //$("#pg_bien").show();
                    $("#pg_internet").show();
                    // $("#pg_limited").show();
                    $("#pg_smoking").show();
                    // $("#pg_wheelchair").show();
                    //Memberships
                    $("#pg_IGNS").show();
                    $("#pg_NSBBA").show();
                    $("#pg_TIANS").show();
                    $("#pg_COANS").show();
                    $("#pg_HANS").show();
                    $("#pg_tasteNS").show();
                    $("#pg_otherMem").show();

                    $("#pg_destinationHfx").show();
                    break;
                //Attraction  
                case "2":
                    $("[id*=dvWebRateDescriptionGroup]").show();

                    $("[id*=dvPrintRateDescriptionGroup]").show();

                    $("[id*=dvParkingSpaces]").show();

                    $("[id*=dvGovernmentLevel]").show();

                    //Print Guide 
                    //Features
                    //$("#pg_bien").show();
                    $("#pg_bus_tour").show();
                    $("#pg_gift_shop").show();
                    $("#pg_internet").show();
                    $("#pg_limited").show();
                    $("#pg_picnic").show();
                    $("#pg_restaurant").show();
                    //                    $("#pg_smoking").show();
                    $("#pg_takeout").show();
                    $("#pg_tea_room").show();
                    $("#pg_wheelchair").show();
                    //Product category
                    $("#pg_museum").show();
                    $("#pg_park").show();
                    $("#pg_winery").show();
                    //Area of Interest
                    $("#pg_geneal").show();
                    $("#pg_fossils").show();
                    //Memberships
                    $("#pg_tasteNS").show();

                    break;
                //Campground  
                case "3":
                    $("[id*=liOperationalDatesTab]").show();

                    $("#listingproof_link").css({ "display": "inline" });
                    $("[id*=dvGovernmentLevel]").show();
                    $("[id*=dvRatings]").show();
                    $("[id*=dvLicenseNumber]").show();
                    $("[id*=dvCheckIn]").show();
                    $("[id*=dvAccessAdvisor]").show();

                    $("[id*=ddlCaaClass]").hide();
                    $("[id*=dvCampingSelectRatings]").show();
                    $("[id*=lblCampground]").show();
                    $("[id*=dvCampgroundAmenity]").show();
                    $("[id*=dvApprovedBy]").show();
                    $("[id*=dvShareInformationWith]").show();
                    $("[id*=dvPetsPolicy]").show();
                    $("[id*=dvOtherMemberships]").show();
                    $("[id*=dvCampgroundUnits]").show();

                    $("[id*=dvAreaOfInterest]").hide();
                    $("[id*=dvCulturalHeritage]").hide();

                    $("[id*=dvWebLowRate]").show();
                    $("[id*=dvWebHighRate]").show();
                    $("[id*=dvWebExtraPersonRate]").show();
                    $("[id*=dvWebHasOffSeasonDates]").show();
                    $("[id*=dvWebHasOffSeasonRates]").show();
                    $("[id*=dvWebRateIncludesTax]").show();
                    $("[id*=dvWebRateType]").show();
                    $("[id*=dvWebRatePeriod]").show();
                    $("[id*=dvWebCancellationPolicy]").show();

                    $("[id*=dvWebRateDescriptionGroup]").show();

                    $("[id*=dvPrintLowRate]").show();
                    $("[id*=dvPrintHighRate]").show();
                    $("[id*=dvPrintExtraPersonRate]").show();
                    $("[id*=dvPrintHasOffSeasonDates]").show();
                    $("[id*=dvPrintHasOffSeasonRates]").show();
                    $("[id*=dvPrintRateIncludesTax]").show();
                    $("[id*=dvPrintRateType]").show();
                    $("[id*=dvPrintRatePeriod]").show();
                    $("[id*=dvPrintCancellationPolicy]").show();

                    $("[id*=dvPrintRateDescriptionGroup]").show();

                    $("[id*=dvPrintUnitDescription]").show();

                    $("[id*=dvWebCancellationPolicyDesc]").show();

                    $("[id*=dvOperationPeriod]").show();

                    //TravelAgentCommissionFeature
                    $("[id*=dv11_522]").show();

                    $("[id*=dv15_701]").show();
                    $("[id*=dv15_702]").show();
                    $("[id*=dv15_704]").show();
                    $("[id*=dv15_705]").show();

                    //Print Guide
                    //Outdoors
                    $("#pg_canoe").show();
                    $("#pg_cc_ski").show();
                    $("#pg_cycle").show();
                    $("#pg_dh_ski").show();
                    $("#pg_golf").show();
                    $("#pg_hiking").show();
                    $("#pg_kayaking").show();
                    $("#pg_snowshoe").show();
                    $("#pg_sport_fish").show();
                    //Features
                    //$("#pg_bien").show();
                    $("#pg_internet").show();
                    $("#pg_limited").show();
                    $("#pg_smoking").show();
                    $("#pg_wheelchair").show();
                    //Product category
                    $("#pg_park").show();
                    //Memberships
                    $("#pg_IGNS").show();
                    $("#pg_NSBBA").show();
                    $("#pg_TIANS").show();
                    $("#pg_COANS").show();
                    $("#pg_HANS").show();
                    $("#pg_tasteNS").show();
                    $("#pg_otherMem").show();

                    $("#pg_destinationHfx").show();

                    break;
                //Artisans  
                case "4":
                    $("[id*=dvArtType]").show();
                    $("[id*=dvMedium]").show();
                    $("[id*=dvCuisine]").hide();
                    $("[id*=dvActivity]").hide();
                    $("[id*=dvExhibitType]").show();

                    $("[id*=dv11_501]").hide();
                    $("[id*=dv11_502]").hide();
                    $("[id*=dv11_503]").hide();
                    $("[id*=dv11_504]").hide();
                    $("[id*=dv11_518]").hide();
                    $("[id*=dv11_505]").hide();
                    $("[id*=dv11_519]").hide();
                    $("[id*=dv11_520]").hide();
                    $("[id*=dv11_507]").hide();
                    $("[id*=dv11_508]").hide();
                    $("[id*=dv11_509]").hide();
                    $("[id*=dv11_510]").hide();
                    $("[id*=dv11_511]").hide();
                    $("[id*=dv11_512]").hide();
                    $("[id*=dv11_521]").hide();
                    $("[id*=dv11_514]").hide();
                    $("[id*=dv11_513]").hide();
                    $("[id*=dv11_522]").hide();
                    $("[id*=dv11_523]").hide();
                    $("[id*=dv11_524]").hide();

                    //Print Guide
                    //Features
                    //$("#pg_bien").show();
                    $("#pg_limited").show();
                    $("#pg_wheelchair").show();

                    break;

                //Outdoors  
                case "5":
                    $("[id*=dvMicsellaneous]").hide();
                    $("[id*=dv11_501]").hide();
                    $("[id*=dv11_502]").hide();
                    $("[id*=dv11_503]").hide();
                    $("[id*=dv11_504]").hide();
                    $("[id*=dv11_518]").hide();
                    $("[id*=dv11_505]").hide();
                    $("[id*=dv11_519]").hide();
                    $("[id*=dv11_520]").hide();
                    $("[id*=dv11_507]").hide();
                    $("[id*=dv11_508]").hide();
                    $("[id*=dv11_509]").hide();
                    $("[id*=dv11_510]").hide();
                    $("[id*=dv11_511]").hide();
                    $("[id*=dv11_512]").hide();
                    $("[id*=dv11_521]").hide();
                    $("[id*=dv11_514]").hide();
                    $("[id*=dv11_513]").hide();
                    $("[id*=dv11_522]").hide();

                    $("[id*=dv11_524]").hide();

                    //SHOW NSATA
                    //    $("[id*=dv15_707]").show();
                    //SHOW GOLF NS
                    $("[id*=dv15_708]").show();

                    $("[id*=dvGovernmentLevel]").show();

                    $("[id*=liCrossReferenceTab]").show();

                    $("[id*=dvPrimaryGuideSection]").show();

                    $("[id*=dvTrailType]").show();

                    //Print Guide
                    $("#pg_atv").show();
                    $("#pg_birds").show();
                    $("#pg_camp").show();
                    $("#pg_canoe").show();
                    $("#pg_cc_ski").show();
                    $("#pg_cycle").show();
                    $("#pg_dive").show();
                    $("#pg_dh_ski").show();
                    $("#pg_golf").show();
                    $("#pg_hiking").show();
                    $("#pg_kayaking").show();
                    $("#pg_sailing").show();
                    $("#pg_sight_see").show();
                    $("#pg_snowmo").show();
                    $("#pg_snowshoe").show();
                    $("#pg_sport_fish").show();
                    $("#pg_whale").show();
                    //Features
                    // $("#pg_bien").show();
                    $("#pg_limited").show();
                    $("#pg_wheelchair").show();
                    //Product category
                    $("#pg_park").show();
                    //Area of Interest
                    $("#pg_fossils").show();
                    //Memberships
                    $("#pg_golfNS").show();

                    break;
                //Tour Ops  
                case "6":
                    $("[id*=dvCheckIn]").show();

                    $("[id*=dv11_501]").hide();
                    $("[id*=dv11_502]").hide();
                    $("[id*=dv11_503]").hide();
                    $("[id*=dv11_504]").hide();
                    $("[id*=dv11_518]").hide();
                    $("[id*=dv11_505]").hide();
                    $("[id*=dv11_519]").hide();
                    $("[id*=dv11_520]").hide();
                    $("[id*=dv11_507]").hide();
                    $("[id*=dv11_508]").hide();
                    $("[id*=dv11_509]").hide();
                    $("[id*=dv11_510]").hide();
                    $("[id*=dv11_511]").hide();
                    $("[id*=dv11_512]").hide();
                    $("[id*=dv11_521]").hide();
                    $("[id*=dv11_514]").hide();
                    $("[id*=dv11_513]").hide();
                    $("[id*=dv11_522]").hide();
                    $("[id*=dv11_523]").hide();
                    $("[id*=dv11_524]").hide();

                    //Memberships
                    //          $("[id*=dv15_707]").show();

                    $("[id*=dvTourType]").show();

                    $("[id*=liCrossReferenceTab]").show();

                    $("[id*=dvPrimaryGuideSection]").show();

                    //Print Guide
                    //Outdoors
                    $("#pg_atv").show();
                    $("#pg_birds").show();
                    $("#pg_camp").show();
                    $("#pg_canoe").show();
                    $("#pg_cc_ski").show();
                    $("#pg_cycle").show();
                    $("#pg_dive").show();
                    $("#pg_dh_ski").show();
                    $("#pg_golf").show();
                    $("#pg_hiking").show();
                    $("#pg_kayaking").show();
                    $("#pg_sailing").show();
                    $("#pg_sight_see").show();
                    $("#pg_snowmo").show();
                    $("#pg_snowshoe").show();
                    $("#pg_sport_fish").show();
                    $("#pg_whale").show();
                    //Features
                    // $("#pg_bien").show();
                    $("#pg_limited").show();
                    $("#pg_wheelchair").show();
                    //Area of Interest
                    $("#pg_fossils").show();

                    break;
                //Restaurants  
                case "7":
                    $("[id*=dvRestaurantService]").show();
                    $("[id*=dvRestaurantSpecialty]").show();
                    $("[id*=dvRestaurantType]").show();
                    $("[id*=dvSeatingCapacity]").show();
                    $("[id*=dvAccessAdvisor]").show();

                    $("[id*=dvCuisine]").hide();
                    $("[id*=dvAreaOfInterest]").hide();
                    $("[id*=dvActivity]").hide();
                    $("[id*=dvProductCategory]").hide();
                    $("[id*=dvCulturalHeritage]").hide();

                    $("[id*=dvWebDescription] textarea").removeClass("wysiwyg").attr("disabled", true);
                    $("[id*=dvWebDescription]").hide();

                    $("[id*=dvKeywordsGroup]").removeClass("form_right");
                    $("[id*=dvKeywordsGroup]").addClass("form_left");

                    $("[id*=dvPrintDescription] textarea").attr("disabled", true);
                    $("[id*=dvPrintContent]").hide();



                    $("[id*=dv11_502]").hide();
                    $("[id*=dv11_512]").hide();
                    $("[id*=dv11_514]").hide();
                    $("[id*=dv11_520]").hide();
                    $("[id*=dv11_523]").hide();

                    //SHOW RANS
                    $("[id*=dv15_709]").show();
                    //SHOW TASTE NS

                    //Print Guide
                    //Features
                    //     $("#pg_bien").show();
                    $("#pg_internet").show();
                    $("#pg_limited").show();
                    $("#pg_wheelchair").show();
                    //Memberships
                    $("#pg_RANS").show();
                    $("#pg_tasteNS").show();

                    break;

                //Transportation   
                case "8":

                    $("[id*=dvParkingSpaces]").show();

                    $("[id*=dvTransportationType]").show();

                    $("[id*=dvPrintDirections]").hide();
                    $("[id*=dvPrintPreview]").hide();

                    $("[id*=dvPrintContent]").hide();

                    $("[id*=dvPrintDatesRatesSection]").hide();
                    $("[id*=dvPrintDateRateDescriptions]").hide();

                    $("[id*=dvAreaOfInterest]").hide();
                    $("[id*=dvActivity]").hide();
                    $("[id*=dvProductCategory]").hide();
                    $("[id*=dvCulturalHeritage]").hide();
                    $("[id*=dvCuisine]").hide();
                    $("[id*=dvCoreExperience]").hide();
                    
                    $("[id*=dvPrintOption]").hide();
                    $("[id*=dvMembership]").hide();

                    $("[id*=dvPaymentReceived]").hide();
                    $("[id*=dvConfirmationDueDate]").hide();

                    $("[id*=dvFormLinks]").hide();

                    break;

                //Trails    
                case "13":

                    $("[id*=dvAreaOfInterest]").hide();
                    //$("[id*=dvActivity]").hide();
                    $("[id*=dvProductCategory]").hide();
                    $("[id*=dvCulturalHeritage]").hide();
                    $("[id*=dvCuisine]").hide();
                    $("[id*=dvCoreExperience]").hide();
                    $("[id*=dvMembership]").hide();
                    $("[id*=dvRegistryNumber]").hide();
                    //$("[id*=dvFeature]").hide();

                    $("[id*=dvGovernmentLevel]").show();
                    $("[id*=dvTrailDistance]").show();
                    $("[id*=dvTrailDuration]").show();
                    $("[id*=dvTrailType]").show();
                    $("[id*=dvTrailSurface]").show();
                    $("[id*=dvTrailPetsPolicy]").show();
                    $("[id*=dvCellService]").show();

                    break;

                //Eat & Drink   
                case "14":
                    $("[id*=dvAreaOfInterest]").hide();
                    $("[id*=dvActivity]").hide();
                    $("[id*=dvProductCategory]").hide();
                    $("[id*=dvCulturalHeritage]").hide();
                    $("[id*=dvCoreExperience]").hide();

                    $("[id*=dvAccessAdvisor]").show();
                    $("[id*=dvWebRateDescriptionGroup]").show();
                    $("[id*=dvPrintRateDescriptionGroup]").show();
                    $("[id*=dvParkingSpaces]").show();
                    $("[id*=dvEatAndDrinkType]").show();
                    $("[id*=dvRestaurantService]").show();
                    $("[id*=dvRestaurantType]").show();
                    $("[id*=dvRestaurantSpecialty]").show();

                    //Print Guide 
                    //Features
                    //$("#pg_bien").show();
                    $("#pg_bus_tour").show();
                    $("#pg_gift_shop").show();
                    $("#pg_internet").show();
                    $("#pg_limited").show();
                    $("#pg_picnic").show();
                    $("#pg_restaurant").show();
                    //                    $("#pg_smoking").show();
                    $("#pg_takeout").show();
                    $("#pg_tea_room").show();
                    $("#pg_wheelchair").show();
                    //Product category
                    $("#pg_museum").show();
                    $("#pg_park").show();
                    $("#pg_winery").show();
                    //Area of Interest
                    $("#pg_geneal").show();
                    $("#pg_fossils").show();
                    //Memberships
                    $("#pg_tasteNS").show();

                    break;

            }
        }

        function MakeMediaFormAdjustments() {
            //if it is a brochure or ad
            if ($("[id*=ddlMediaType]").val() == "4" || $("[id*=ddlMediaType]").val() == "3") {
                $("[id*=dvMediaLanguage]").show();
                ValidatorEnable($get("<%=rfvMediaLanguage.ClientID%>"), true);
                $("[id*=rfvMediaLanguage]").hide();
            }
            else {
                $("[id*=dvMediaLanguage]").hide();
                ValidatorEnable($get("<%=rfvMediaLanguage.ClientID%>"), false);
            }
        }

        function MakeLinkFormAdjustments() {
            if ($("[id*=ddlLinkType]").val() == "4") {
                $("[id*=dvLinkDistance]").show();
                ValidatorEnable($get("<%=rfvLinkDistance.ClientID%>"), true);
            }
            else {
                $("[id*=dvLinkDistance]").hide();
                ValidatorEnable($get("<%=rfvLinkDistance.ClientID%>"), false);
            }
        }

        function MakeSeasonalFormAdjustments() {
            if ($("[id*=rblPeriodOfOperation]:checked").val() == "3") {
                $("[id*=dvWebDates]").show();
            }
            else {
                $("[id*=dvWebDates]").hide();
            }
        }

        function MakePrintSeasonalFormAdjustments() {
            if ($("[id*=rblPrintPeriodOfOperation]:checked").val() == "3") {
                $("[id*=dvPrintDatesSection]").show();
            }
            else {
                $("[id*=dvPrintDatesSection]").hide();
            }
        }

        function RefreshListOrder() {
            var s = "";
            $("#photoSortable li").each(function (i) {
                s += $(this).attr("id") + ",";
            });


            $("[id*=hdnPhotoOrder]").val(s);
        }

        function ValidateMediaForm() {
            if (($("[id*=hdnTempFileName]").val() == "") && ($("[id*=hdnMediaId]").val() == "")) {
                $('#dvFileError').show();
                return false;
            }

            //var ext = $('#hdnOrigFileName').val().split('.').pop().toLowerCase();
            var ext = $("[id*=hdnOrigFileName]").val().split('.').pop().toLowerCase();
            var mediaType = $("[id*=ddlMediaType]").val();

            if (((mediaType == "1" || mediaType == "2") && ($.inArray(ext, ['gif', 'png', 'jpg', 'jpeg']) == -1)) || ((mediaType == "3" || mediaType == "4") && (ext != "pdf"))) {
                $('#dvFileTypeError').show();
                return false;
            }

            return true;
        }
        
        function InitializeEventBindings() {
            
            $("[id*=lnkAddPromotionPeriod]").click(function (e) {
                var startDate = $("[id*=tbPromotionStartDate]").val();
                var endDate = $("[id*=tbPromotionEndDate]").val();
                
                var promotionPeriodId = $("[id*=hdnPromotionPeriodId]").val();
                
                if (startDate != "" && endDate != "") {
                    $("[id*=dvPromotionPeriodError]").hide();
                    ProcessPromotionPeriod(promotionPeriodId, startDate, endDate);
                }
                else {
                    $("[id*=dvPromotionPeriodError]").show();
                }
            });
            
            $("[id*=lnkEditPromotionPeriod]").live("click", function (e) {
                
                //alert($(this).attr("promotionPeriodId"));   
                $("[id*=hdnPromotionPeriodId]").val($(this).attr("promotionPeriodId"));
                $("[id*=tbPromotionStartDate]").val($(this).attr("startDate"));
                $("[id*=tbPromotionEndDate]").val($(this).attr("endDate"));
                
                $("[id*=lnkAddPromotionPeriod]").text("Update Promotion Period");
            });
            
            $("[id*=lnkCancelPromotionPeriod]").live("click", function (e) {
                
                $("[id*=hdnPromotionPeriodId]").val("");
                $("[id*=tbPromotionStartDate]").val("");
                $("[id*=tbPromotionEndDate]").val("");
                $("[id*=dvPromotionPeriodError]").hide();
                
                $("[id*=lnkAddPromotionPeriod]").text("Save Promotion Period");
            });
            
            $("[id*=lnkDeletePromotionPeriod]").live("click", function (e) {
                //var promotionPeriodId = $("[id*=hdnPromotionPeriodId]").val();
                
                DeletePromotionPeriod($(this).attr("promotionPeriodId"));
            });
            
            $("[id*=tbPromotionStartDate]").datepicker({
                dateFormat: 'dd-mm-yy',
                onSelect: function (selected) {
                    $("[id*=tbPromotionEndDate]").datepicker("option", "minDate", selected);
                }
            });

            $("[id*=tbPromotionEndDate]").datepicker({
                dateFormat: 'dd-mm-yy',
                onSelect: function (selected) {
                    $("[id*=tbPromotionStartDate]").datepicker("option", "maxDate", selected);
                }
            });
            
            $('#accordion h4').unbind('click');
            $('.accordion_item h3').unbind('click');

            $('#accordion h4').click(function () {
                //                alert("H4 FIRED");
                $(this).children('span').toggleClass('ui-icon-triangle-1-e').toggleClass('ui-icon-triangle-1-s');
                $(this).next().toggle(400);
                return false;
            }).next().hide();

            $('.accordion_item h3').click(function () {
                //                alert("H3 FIRED");
                $(this).children('span').toggleClass('ui-icon-triangle-1-e').toggleClass('ui-icon-triangle-1-s');
                $(this).next().toggle(400);
                return false;
            }).next().hide();

            $("[id*=btnMediaSubmit]").click(function (e) {
                if (!ValidateMediaForm()) {
                    e.preventDefault();
                }
            });

            $("[id*=btnOperationalPeriodSubmit]").click(function (e) {
                if (!ValidateOperationalPeriodForm()) {
                    e.preventDefault();
                }
            });

            $('#dvFileUpload').fileupload({
                url: '../../Handlers/FileUploader.ashx',
                maxNumberOfFiles: 1,
                autoUpload: true,
                maxFileSize: 1000000000,
                method: 'POST'
            });

            $('#dvFileUpload').bind('fileuploaddestroy', function (e, data) {
                $('#dvFileInput').show();
                var that = $(this).data('fileupload');
                that._adjustMaxNumberOfFiles(1);
                $('#tblFileUploads').find("tr").remove();
                $("[id*=hdnTempFileName]").val('');
                $("[id*=hdnOrigFileName]").val('');
            });

            $('#dvFileUpload').bind('fileuploaddone', function (e, data) {
                $('#dvFileInput').hide();
                $('#dvFileError').hide();
                $('#dvFileTypeError').hide();

                $("[id*=hdnTempFileName]").val(data.result[0].tempName);
                $("[id*=hdnOrigFileName]").val(data.result[0].name);
            });

            //hide data tables when empty
            $('table.tbl_data').each(function () {
                if ($(this).find('tbody > tr').length == 1) {
                    $(this).parent().hide();
                }
            });
            //hide media items box when empty
            if ($('table.tbl_sumthumb').length == 0 && $('table.tbl_docs').length == 0 && $('#photoSortable').length == 0) {
                $('#dvMediaItems').hide();
            }
            if ($('table.tbl_sumthumb').length) {
                $('#add_slt').hide();
            }
            if ($('table.tbl_docs').length) {
                $('#add_doc').hide();
            }
            if ($('#photoSortable').length) {
                $('#add_pv').hide();
            }

            $("[id*=dvDescriptionType]").hide();

            $("[id*=lnkProductLink]").click(function () {
                CheckUrl($(this).attr("href"));
                return false;
            });

            $("[id*=lnkViewFileMakerCommentArchive]").click(function () {
                ViewFileMakerArchive(2);
            });

            $("[id*=lnkViewFileMakerHistoryArchive]").click(function () {
                ViewFileMakerArchive(1);
            });

            $("[id*=lnkGenerateApplicationForm]").click(function () {
                GenerateForm(1);
            });

            $("[id*=lnkGenerateConfirmationForm]").click(function () {
                GenerateForm(2);
            });

            $("[id*=lnkGenerateListingProofForm]").click(function () {
                GenerateForm(3);
            });

            $("[id*=rblPeriodOfOperation]").click(function () {
                MakeSeasonalFormAdjustments();
            });

            $("[id*=rblPrintPeriodOfOperation]").click(function () {
                MakePrintSeasonalFormAdjustments();
            });

            MakeCrossReferenceFormAdjustments();

            $("[id*=rblGuideSection]").click(function () {
                MakeCrossReferenceFormAdjustments();
            });

            $("[id*=ddlGuideSectionOutdoors]").change(function () {
                MakeCrossReferenceFormAdjustments();
            });


            $("[id*=rbPrimaryContact]").click(function () {
                $("[id*=rbPrimaryContact]").attr('checked', false);
                $(this).attr('checked', true);
                $("[id*=hdnPrimaryContactId]").val($(this).val());
            });

            $("#photoSortable").sortable({
                update: function (event, ui) {
                    RefreshListOrder();
                }
            });

            $("[id*=cbPaymentType]").change(function () {

                if ($(this).attr('id') == '<%=cbPaymentTypeCashOnly.ClientID%>' && $(this).attr('checked')) {
                    $("[id*=cbPaymentType]").attr('checked', false);
                    $("#<%=cbPaymentTypeCashOnly.ClientID%>").attr('checked', true);
                }
                else {
                    $("#<%=cbPaymentTypeCashOnly.ClientID%>").attr('checked', false);
                }
            });

            $("[id*=ddlLinkType]").change(function () {
                MakeLinkFormAdjustments();
            });

            $("[id*=ddlMediaType]").change(function () {
                MakeMediaFormAdjustments();
            });

            $("[id*=lnkAddMedia]").click(function () {
                ClearMediaForm();
                RevealMediaPanel();
            });

            $("[id*=lnkWebDescription]").click(function () {
                RevealWebDescriptionPanel();
            });

            $("[id*=lnkPrintDescription]").click(function () {
                RevealPrintDescriptionPanel();
            });

            $("[id*=lnkWebDates]").click(function () {
                RevealWebDatesPanel();
            });

            $("[id*=lnkWebDateDescriptions]").click(function () {
                RevealWebDatesDescriptionsPanel();
            });

            $("[id*=lnkPrintDates]").click(function () {
                RevealPrintDatesPanel();
            });

            $("[id*=lnkPrintDateDescriptions]").click(function () {
                RevealPrintDatesDescriptionsPanel();
            });

            $("[id*=lnkCancelMedia]").click(function () {
                $("[id*=mediaForm]").slideToggle(250);
                $("[id*=mediaToggle]").toggleClass('plus').toggleClass('minus');
                $("[id*=lnkAddMedia]").html('Save Media');
                $("[id*=btnMediaSubmit]").attr('value', 'Save Media');
                ClearMediaForm();
            });

            $("[id*=lnkAddContact]").click(function () {
                ClearContactForm();
                RevealContactPanel();
            });

            $("[id*=lnkCancelContact]").click(function () {
                $("[id*=contactForm]").slideToggle(250);
                $("[id*=contactToggle]").toggleClass('plus').toggleClass('minus');
                ClearContactForm();
            });

            $("[id*=lnkAddSupplementalDescription]").click(function (e) {

                if ($("[id*=hdnSupplementalDescriptionTypeId]").attr("value") != "" || $("#tblCrossReference tr").length > 2) {
                    e.preventDefault();
                }
                else {
                    ClearSuppDescForm();
                    RevealSuppDescPanel();
                }
            });

            $("[id*=lnkCancelSupplementalDescription]").click(function () {
                $("[id*=suppDescForm]").slideToggle(250);
                $("[id*=suppDescToggle]").toggleClass('plus').toggleClass('minus');
                $("[id*=lnkAddSupplementalDescription]").html('Add Cross Reference Description');
                $("[id*=btnSupplementalDescriptionSubmit]").attr('value', 'Save Cross Reference');
                ClearSuppDescForm();
            });

            $("[id*=lnkAddLink]").click(function () {
                ClearLinkForm();
                RevealLinkPanel();
            });

            $("[id*=lnkCancelLink]").click(function () {
                $("[id*=linkForm]").slideToggle(250);
                $("[id*=linkToggle]").toggleClass('plus').toggleClass('minus');
                $("[id*=lnkAddLink]").html('Add Link');
                $("[id*=btnLinkSubmit]").attr('value', 'Save Link');
                ClearLinkForm();
            });

            $("[id*=tbOperationalOpenDate]").datepicker({
                dateFormat: 'dd-mm-yy',
                onSelect: function (selected) {
                    $("[id*=tbOperationalCloseDate]").datepicker("option", "minDate", selected);
                }
            });

            $("[id*=tbOperationalCloseDate]").datepicker({
                dateFormat: 'dd-mm-yy',
                onSelect: function (selected) {
                    $("[id*=tbOperationalOpenDate]").datepicker("option", "maxDate", selected);
                }
            });

            $("[id*=lnkAddOperationalPeriod]").click(function () {
                ClearOperationalPeriodForm();
                RevealOperationalPeriodPanel();
            });

            $("[id*=lnkCancelOperationalPeriod]").click(function () {
                $("[id*=dvOperationalPeriodForm]").slideToggle(250);
                $("[id*=dvOperationalPeriodToggle]").toggleClass('plus').toggleClass('minus');
                $("[id*=lnkAddOperationalPeriod]").html('Add Open & Close Date Range');
                $("[id*=btnOperationalPeriodSubmit]").attr('value', 'Save Open & Close Date Range');
                ClearOperationalPeriodForm();
            });

            $("[id*=lnkAddNote]").click(function () {
                RevealNotePanel();
            });

            $("[id*=lnkCancelNote]").click(function () {
                $("[id*=noteForm]").slideToggle(250);
                $("[id*=noteToggle]").toggleClass('plus').toggleClass('minus');
                ClearNoteForm();
            });

            $("[id*=tbNoteReminderDate]").datepicker({ minDate: 0, dateFormat: 'dd-mm-yy' });

            $("[id*=reminderDateValue]:empty").parent().hide();

            // Update text remaining
            var onEditCallback = function (remaining) {
                $(this).siblings('.chars_remaining').text("(" + remaining + " characters remaining)");
            };

            // Attach maxlength function to textarea
            $('textarea[length]').limitMaxlength({
                onEdit: onEditCallback
            });

            // Limit selections to 2 in Art Type and Medium sections
            $("[id*=dvArtType] input").change(function () {
                DisableDivCheckboxes("dvArtType", 2);
                //                if ($("[id*=dvArtType] input:checked").length > 1) {
                //                    $("[id*=dvArtType] input").not(":checked").attr('disabled', true);
                //                }
                //                else {
                //                    $("[id*=dvArtType] input").not(":checked").attr('disabled', false);
                //                }
            });

            $("[id*=dvMedium] input").change(function () {
                DisableDivCheckboxes("dvMedium", 2);
            });

            $("[id*=dvRestaurantSpecialty] input").change(function () {
                DisableDivCheckboxes("dvRestaurantSpecialty", 2);
            });

            $("[id*=dvRestaurantType] input").change(function () {
                DisableDivCheckboxes("dvRestaurantType", 2);
            });

            $("[id*=tbUnits]").addClass("integerOnly");
            $("[id*=tbLowRate]").addClass("decimalOnly");
            $("[id*=tbHighRate]").addClass("decimalOnly");
            $("[id*=tbExtraPersonRate]").addClass("decimalOnly");
            $("[id*=tbPrintLowRate]").addClass("decimalOnly");
            $("[id*=tbPrintHighRate]").addClass("decimalOnly");
            $("[id*=tbAttendance]").addClass("integerOnly");
            $("[id*=tbPrintExtraPersonRate]").addClass("decimalOnly");
            $("[id*=tbPaymentAmount]").addClass("decimalOnly");
            $("[id*=tbLinkDistance]").addClass("decimalOnly");

            $("[id*=tbTrailDistance]").addClass("decimalOnly");
            $("[id*=tbTrailDuration]").addClass("decimalOnly");

            $("[id*=tbOperationPeriodOpen]").addClass("readOnly");
            $("[id*=tbOperationPeriodClose]").addClass("readOnly");
            $("[id*=tbOperationPeriodOpen]").addClass("readOnly");

            $(".readOnly").keydown(function (event) {
                // Allow: backspace, delete, tab, escape, and enter
                if (event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 27 || event.keyCode == 13 ||
                // Allow: Ctrl+A
                (event.keyCode == 65 && event.ctrlKey === true) ||
                // Allow: home, end, left, right
                (event.keyCode >= 35 && event.keyCode <= 39)) {
                    // let it happen, don't do anything
                    return;
                }
                else {
                    event.preventDefault();
                }
            });


            $(".integerOnly").keydown(function (event) {
                // Allow: backspace, delete, tab, escape, and enter
                if (event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 27 || event.keyCode == 13 ||
                // Allow: Ctrl+A
                (event.keyCode == 65 && event.ctrlKey === true) ||
                // Allow: home, end, left, right
                (event.keyCode >= 35 && event.keyCode <= 39)) {
                    // let it happen, don't do anything
                    return;
                }
                else {
                    // Ensure that it is a number and stop the keypress
                    if (event.shiftKey || (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105)) {
                        event.preventDefault();
                    }
                }
            });

            $(".decimalOnly").keydown(function (event) {
                // Allow: backspace, delete, tab, escape, and enter
                
                if (event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 27 || event.keyCode == 13 ||
                // Allow: Ctrl+A
                (event.keyCode == 65 && event.ctrlKey === true) ||
                // Allow: home, end, left, right
                (event.keyCode >= 35 && event.keyCode <= 39)) {
                    // let it happen, don't do anything
                    return;
                }
                else {
                    //if (event.shiftKey || (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105) && (event.keyCode != 190 || (event.keyCode == 190 && $(this).val().indexOf('.') != -1))) {
                    // Ensure that it is a number and stop the keypress
                    if ((event.shiftKey || (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105) && (event.keyCode != 190)) || (event.keyCode == 190 && $(this).val().indexOf('.') != -1)) {
                        event.preventDefault();
                    }
                }
            });

            $("[id*=ddlMediaType]").change(function () {
                if (this.value == "1" || this.value == "2") {
                    $("[id*=divFile]").text('(.jpg, .gif, or .png file types only)');
                }
                else if (this.value == "3" || this.value == "4") {
                    $("[id*=divFile]").text('(.pdf file type only) ');
                }
                else {
                    $("[id*=divFile]").text('');
                }
            });

            // Check URL function
            $("[id*=lnkCheckWeb]").click(function () {
                var url = $("[id*=tbWeb]").val();
                CheckUrl(url);
            });

            $("[id*=lnkCheckLinkUrl]").click(function () {
                var url = $("[id*=tbLinkUrl]").val();
                CheckUrl(url);
            });
        }


        function ClearOperationalPeriodForm() {
            $("[id*=tbOperationalOpenDate]").val('');
            $("[id*=tbOperationalCloseDate]").val('');
            $("[id*=hdnOperationalPeriodId]").val('');
            $("[id*=dvErrorConflict]").hide();
            $("[id*=dvErrorOpenDateRequired]").hide();
        }

        function ValidateOperationalPeriodForm() {

            $("[id*=dvErrorConflict]").hide();
            $("[id*=dvErrorOpenDateRequired]").hide();

            var newOpenDate = Date.parseExact($("[id*=tbOperationalOpenDate]").val(), "dd-MM-yyyy");
            var newCloseDate = Date.parseExact($("[id*=tbOperationalCloseDate]").val(), "dd-MM-yyyy");
            var currentId = $("[id*=hdnOperationalPeriodId]").val();

            var myResult = true;

            if (newOpenDate == null) {
                $("[id*=dvErrorOpenDateRequired]").show();
                return false;
            }

            $(".operationalPeriodDataRow").each(function () {
                var rowId = $(this).find("[id*=hdnRowId]").val();

                if (rowId == currentId) {
                    return true;
                }

                var openDate = Date.parseExact($(this).find("[id*=hdnOpenDate]").val(), "dd-MM-yyyy");
                var closeDate = Date.parseExact($(this).find("[id*=hdnCloseDate]").val(), "dd-MM-yyyy");

                if (closeDate == null && newCloseDate == null) {
                    $("[id*=dvErrorConflict]").show();
                    myResult = false;
                    //alert("already a row with a null closed date");
                }

                if (openDate < newOpenDate && closeDate > newOpenDate) {
                    $("[id*=dvErrorConflict]").show();
                    myResult = false;
                    //alert("// new open date falls within existing period     ");
                }

                if (openDate < newCloseDate && (closeDate == null || closeDate > newCloseDate)) {
                    $("[id*=dvErrorConflict]").show();
                    myResult = false;
                    //alert("new close date falls within existing period");
                }
                //    
                if (openDate > newOpenDate && ((closeDate != null && closeDate < newCloseDate) || newCloseDate == null)) {
                    $("[id*=dvErrorConflict]").show();
                    myResult = false;
                    //alert("// new period envelops existing period" + openDate + "-" + closeDate + ">>>>>>>" + newOpenDate + "-" + newCloseDate);
                }
            });

            return myResult;
        }

        function DisableDivCheckboxes(divName, maxSelections) {
            if ($("[id*=" + divName + "] input:checked").length >= maxSelections) {
                $("[id*=" + divName + "] input").not(":checked").attr('disabled', true);
            }
            else {
                $("[id*=" + divName + "] input").not(":checked").attr('disabled', false);
            }
        }

        function CheckUrl(url) {
            if (url.substring(0, 7).toLowerCase() != "http://") {
                url = "http://" + url;
            }
            window.open(url);
        }

        function RevealOperationalPeriodPanel() {
            if ($("[id*=dvOperationalPeriodForm]").is(':hidden')) {
                $("[id*=dvOperationalPeriodToggle]").toggleClass('plus').toggleClass('minus');
                $("[id*=dvOperationalPeriodForm]").show(250);
            }
            return false;
        }

        function RevealNotePanel() {
            if ($("[id*=noteForm]").is(':hidden')) {
                $("[id*=noteToggle]").toggleClass('plus').toggleClass('minus');
                $("[id*=noteForm]").show(250);
                $('html,body').animate({ scrollTop: $("[id*=btnNoteSubmit]").offset().top }, 'slow');
            }
            return false;
        }

        function ClearNoteForm() {
            $("[id*=tbNote]").val('').triggerHandler("keyup");
            $("[id*=tbNoteReminderDate]").val('');
        }

        function RevealContactPanel() {
            if ($("[id*=contactForm]").is(':hidden')) {
                $("[id*=contactToggle]").toggleClass('plus').toggleClass('minus');
                $("[id*=contactForm]").show(250);
            }
            return false;
        }

        function ClearContactForm() {
            $("[id*=tbBusinessName]").val('');
            $("[id*=hdnBusinessId]").val('');
            $("[id*=ddlContact] > option").remove();
            $("[id*=dvContactSelect]").hide();
            $("[id*=dvNoContacts]").hide();

            $("[id*=dvEmptyContact]").show();

            // Hide validator messages.
            $("[id*=rfvContacts]").css('display', 'none');
        }

        function GenerateSelectedCheckboxList(section) {
            var k = "";
            section.find('input').each(function () {
                if (this.checked == true) {
                    k = k + $("label[for='" + this.id + "']").html();

                    //this if clause was added to include units values for the Accommodation Type checkbox group ONLY
                    if (section.parent().attr("id") == "dvAccommodationType") {
                        var parent = $(this).parent();
                        var unitsValue = parent.find('input[type="text"]').val();
                        if (unitsValue == '') {
                            unitsValue = '-';
                        }
                        k = k + " (" + unitsValue + ")";
                    }

                    k = k + ", ";

                }
            });

            //minor hack to include other memberships in list for the Membership checkbox group ONLY
            if (section.parent().attr("id") == "dvMembership" && $("[id*=tbOtherMemberships]").val() != "") {
                k = k + $("[id*=tbOtherMemberships]").val() + ", ";
            }
            // remove the last comma and space, and set the html
            if (k.length > 0) {
                section.siblings(".selectedList").html(k.substring(0, (k.length - 2)));
            }
            else {
                section.siblings(".selectedList").html('<span class="hint">None selected</span>');
            }
        }

        function RevealSuppDescPanel() {
            if ($("[id*=suppDescForm]").is(':hidden')) {
                $("[id*=suppDescToggle]").toggleClass('plus').toggleClass('minus');
                $("[id*=suppDescForm]").show(250);
            }

            return false;
        }

        function ClearSuppDescForm() {
            // Reset value and trigger handler to reset field count
            $("[id*=tbSupplementalDescriptionEn]").attr("value", "").triggerHandler("keyup");
            $("[id*=tbSupplementalDescriptionFr]").attr("value", "").triggerHandler("keyup");

            $("[id*=ddlGuideSectionOutdoors]").val("");
            $("[id*=ddlGuideSectionTourOps]").val("");
            $("[id*=btnSupplementalDescriptionSubmit]").attr('value', 'Save Cross Reference');

            //Remove the last edited desc type from the list as it is already in use
            if ($("[id*=hdnSupplementalDescriptionTypeId]").attr("value") != "") {
                $("[id*=ddlGuideSectionOutdoors] option[value='" + $("[id*=hdnSupplementalDescriptionTypeId]").attr("value") + "']").remove();
                $("[id*=ddlGuideSectionTourOps] option[value='" + $("[id*=hdnSupplementalDescriptionTypeId]").attr("value") + "']").remove();
            }

            $("[id*=hdnSupplementalDescriptionTypeId]").attr("value", "");
        }

        function RevealMediaPanel() {
            if ($("[id*=mediaForm]").is(':hidden')) {
                $("[id*=mediaToggle]").toggleClass('plus').toggleClass('minus');
                $("[id*=mediaForm]").show(250);
            }

            if ($("[id*=ddlMediaType]").val() == "1" || $("[id*=ddlMediaType]").val() == "2") {
                $("[id*=divFile]").text('(.jpg, .gif, or .png file types only)');
            }
            else if ($("[id*=ddlMediaType]").val() == "3" || $("[id*=ddlMediaType]").val() == "4") {
                $("[id*=divFile]").text('(.pdf file type only) ');
            }
            else {
                $("[id*=divFile]").text('');
            }

            return false;
        }

        function RevealWebDescriptionPanel() {
            $("[id*=webDescriptionToggle]").toggleClass('plus').toggleClass('minus');
            $("[id*=webDescriptionSection]").toggle(250);

            return false;
        }

        function RevealPrintDescriptionPanel() {
            $("[id*=printDescriptionToggle]").toggleClass('plus').toggleClass('minus');
            $("[id*=printDescriptionSection]").toggle(250);

            return false;
        }

        function RevealWebDatesPanel() {
            $("[id*=webDatesToggle]").toggleClass('plus').toggleClass('minus');
            $("[id*=webDatesSection]").toggle(250);

            return false;
        }

        function RevealWebDatesDescriptionsPanel() {
            $("[id*=webDatesDescriptionsToggle]").toggleClass('plus').toggleClass('minus');
            $("[id*=webDatesDescriptionsSection]").toggle(250);

            return false;
        }

        function RevealPrintDatesPanel() {
            $("[id*=printDatesToggle]").toggleClass('plus').toggleClass('minus');
            $("[id*=printDatesSection]").toggle(250);

            return false;
        }

        function RevealPrintDatesDescriptionsPanel() {
            $("[id*=printDatesDescriptionsToggle]").toggleClass('plus').toggleClass('minus');
            $("[id*=printDatesDescriptionsSection]").toggle(250);

            return false;
        }

        function ClearMediaForm() {
            $("[id*=hdnTempFileName]").val('');
            $("[id*=hdnOrigFileName]").val('');

            $("[id*=ddlMediaType]").attr("value", "");
            $("[id*=ddlMediaLanguage]").attr("value", "");
            // Reset file input by replacing html with current html to make it work in IE

            $("[id*=tbMediaTitleEn]").attr("value", "");
            $("[id*=tbMediaCaptionEn]").attr("value", "");
            $("[id*=tbMediaShortDescEn]").attr("value", "");
            $("[id*=tbMediaLongDescEn]").attr("value", "");

            $("[id*=tbMediaTitleFr]").attr("value", "");
            $("[id*=tbMediaCaptionFr]").attr("value", "");
            $("[id*=tbMediaShortDescFr]").attr("value", "");
            $("[id*=tbMediaLongDescFr]").attr("value", "");

            $("[id*=hdnMediaId]").attr("value", "");

            $("[id*=cbTransMarkMediaCaption]").attr("checked", false);
            $("[id*=cbTransMarkMediaTitle]").attr("checked", false);

            // Hide validator messages.
            $("[id*=rfvMedia]").css('display', 'none')
        }

        function MapLongLat() {
            clearMarkers();
            var myLatlng = new google.maps.LatLng($("[id*=tbLatitude]").val(), $("[id*=tbLongitude]").val());
            map.setCenter(myLatlng, 14);
            var marker = new google.maps.Marker({
                position: myLatlng,
                map: map,
                draggable: true
            });

            google.maps.event.addListener(marker, 'dragend', function () {
                var point = marker.getPosition();
                map.panTo(point);

                $("[id*=tbLatitude]").attr("value", round_number(point.lat(), 6));
                $("[id*=tbLongitude]").attr("value", round_number(point.lng(), 6));
            });

            markersArray.push(marker);
            return false;
        }

        function SearchAddress() {

            var address = $("[id*=tbLine1]").val() + "," + $("[id*=tbLine2]").val() + "," + $("#ddlCommunity option:selected").text() + ", NS," + $("[id*=tbPostalCode]").val();

            if (geocoder) {
                //geocoder.getLatLng(address, function (point) {
                geocoder.geocode({ 'address': address }, function (results, status) {
                    if (status == google.maps.GeocoderStatus.OK) {
                        var point = results[0].geometry.location;
                        //alert(latlng); //Adding Marker here             

                        $("[id*=tbLatitude]").attr("value", point.lat());
                        $("[id*=tbLongitude]").attr("value", point.lng());

                        clearMarkers();
                        map.setCenter(point, 14);

                        var marker = new google.maps.Marker({
                            position: point,
                            map: map,
                            draggable: true
                        });

                        markersArray.push(marker);

                        google.maps.event.addListener(marker, 'dragend', function () {
                            var point = marker.getPosition();
                            map.panTo(point);
                            $("[id*=tbLatitude]").attr("value", round_number(point.lat(), 6));
                            $("[id*=tbLongitude]").attr("value", round_number(point.lng(), 6));
                        });

                    } else {
                        alert("Geocode was not successful for the following reason: " + status);
                    }
                });
            }
            return false;
        }

        function round_number(num, dec) {
            return Math.round(num * Math.pow(10, dec)) / Math.pow(10, dec);
        }

        function InitializeMap() {

            //var myLatlng = new google.maps.LatLng(45.2, -63.0);
            //  alert($("[id*=tbLatitude]").attr("value") + ":::" + $("[id*=tbLongitude]").attr("value"));

            var myLatLng = new google.maps.LatLng($("[id*=tbLatitude]").attr("value"), $("[id*=tbLongitude]").attr("value"));
            var myOptions = {
                zoom: 14,
                center: myLatLng,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            }
            map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
            geocoder = new google.maps.Geocoder();

            var marker = new google.maps.Marker({
                position: myLatLng,
                map: map,
                draggable: true
            });

            markersArray.push(marker);

            google.maps.event.addListener(marker, 'dragend', function () {
                var point = marker.getPosition();

                //$("[id*=tbLatitude]").attr("value", point.lat());
                $("[id*=tbLatitude]").attr("value", round_number(point.lat(), 6));
                $("[id*=tbLongitude]").attr("value", round_number(point.lng(), 6));
            });


        }

        function getCurrentLatLong() {
            $("[id*=tbLatitude]").attr("value");
            $("[id*=tbLongitude]").attr("value");
        }

        function RevealLinkPanel() {
            if ($("[id*=linkForm]").is(':hidden')) {
                $("[id*=linkToggle]").toggleClass('plus').toggleClass('minus');
                $("[id*=linkForm]").show(250);
            }

            return false;
        }

        function ClearLinkForm() {
            $("[id*=tbLinkTitleEn]").val('');
            $("[id*=tbLinkTitleFr]").val('');
            $("[id*=tbLinkDescriptionEn]").val('');
            $("[id*=tbLinkDescriptionFr]").val('');
            $("[id*=tbLinkUrl]").val('');
            $("[id*=tbLinkDistance]").val('');
            $("[id*=ddlLinkType]").val('');
            $("[id*=hdnLinkId]").val('');

            $("[id*=cbTransMarkLinkTitle]").attr("checked", false);
            $("[id*=cbTransMarkLinkDesc]").attr("checked", false);

            // Hide validator messages.
            $("[id*=rfvLink]").css('display', 'none')
        }

        function ConfirmDelete(e, message) {
            if ($(e).attr('disabled') == 'disabled') {
                return false;
            }
            else {
                return confirm(message);
            }
        }

        function ConfirmProductDelete() {
            return confirm("Are you sure you would like to delete the product " + $("[id*=tbProductName]").val() + "?");
        }

        // Validation function
        function validate() {
        
            // Validate the page
            Page_ClientValidate();

            // Highlight tabs with invalid fields.
            highlightTabs();

            // Refresh validation summary
            RefreshValidationErrors();
        }

        // Highlight tabs that contain invalid fields
        function highlightTabs() {

            for (var i = 0; i < 10; i++) {
                // Remove invalid class
                $('#aTab' + i).removeClass('invalid');

                // Check for any validators that are currently being displayed
                if ($("[id*=valTab" + i + "][style*=inline]").length)
                    $('#aTab' + i).addClass('invalid');
            }

        }

        // Create arrays for months
        var monthsEN = new Array("", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
        var monthsFR = new Array("", "jan", "fév", "mars", "avr", "mai", "juin", "juil", "août", "sep", "oct", "nov", "déc");

        // Refresh the validation error list
        function RefreshValidationErrors() {

            $("[id*=dvValidationErrors]").show();
            $("[id*=dvValidationWarnings]").show();

            var isValid = 1;

            // City/Community
            if ($("[id*=hdnProductType]").val() == "5" || $("[id*=hdnProductType]").val() == "6" || $("[id*=ddlCommunity]").val() != "") {
                $("[id*=dvValErrCity]").hide();
            }
            else {
                $("[id*=dvValErrCity]").show();
                isValid = 0;
            }

            // Telephone
            if ($("[id*=tbPhone]").val() != "" || $("[id*=tbTollFree]").val()) {
                $("[id*=dvValWarTelephone]").hide();
            }
            else {
                $("[id*=dvValWarTelephone]").show();
            }

            // Region
            if ($("[id*=tblOtherRegion] input:checked").length) {
                $("[id*=dvValErrRegion]").hide();
            }
            else {
                $("[id*=dvValErrRegion]").show();
                isValid = 0;
            }

            // General Area
            //            if ($("[id*=ddlCommunity]").val() != "") {
            //                $("[id*=dvValWarGeneralArea]").hide();
            //            }
            //            else {
            //                $("[id*=dvValWarGeneralArea]").show();
            //            }

            // Print Description
            if ($("[id*=tbPrintDescriptionEn]").val() != "" || $("[id*=hdnProductType]").val() == "7" || $("[id*=hdnProductType]").val() == "8" || $("[id*=hdnProductType]").val() == "1" || $("[id*=hdnProductType]").val() == "3") {
                $("[id*=dvValErrPrintDescription]").hide();
            }
            else {
                $("[id*=dvValErrPrintDescription]").show();
                isValid = 0;
            }

            // Eng Unit Description
            if ($("[id*=tbPrintUnitDescriptionEn]").val() != "" || ($("[id*=hdnProductType]").val() != "1")) {
                $("[id*=dvValErrUnitDescription]").hide();
            }
            else {
                $("[id*=dvValErrUnitDescription]").show();
                isValid = 0;
            }

//            // Fr Unit Description
//            if ($("[id*=tbPrintUnitDescriptionFr]").val() != "" || ($("[id*=hdnProductType]").val() != "1" && $("[id*=hdnProductType]").val() != "3")) {
//                $("[id*=dvValWarUnitDescription]").hide();
//            }
//            else {
//                $("[id*=dvValWarUnitDescription]").show();
//            }

            // Print Description French
            if ($("[id*=tbPrintDescriptionFr]").val() != "" || $("[id*=hdnProductType]").val() == "8") {
                $("[id*=dvValWarPrintDescription]").hide();
            }
            else {
                $("[id*=dvValWarPrintDescription]").show();
            }

            // Web Description
            if ($("[id*=tbWebDescriptionEn]").val() != "" || $("[id*=hdnProductType]").val() == "7") {
                $("[id*=dvValErrWebDescription]").hide();
            }
            else {
                $("[id*=dvValErrWebDescription]").show();
                isValid = 0;
            }

            // Web Description French
            if ($("[id*=tbWebDescriptionFr]").val() != "") {
                $("[id*=dvValWarWebDescription]").hide();
            }
            else {
                $("[id*=dvValWarWebDescription]").show();
            }

            // Print dates
            if ($("[id*=hdnProductType]").val() == "5"
                    || $("[id*=rblPrintPeriodOfOperation_0]").attr('checked')
                    || $("[id*=rblPrintPeriodOfOperation_1]").attr('checked')
                    || ($("[id*=ddlPrintOpenMonth]").val() != ""
                        && $("[id*=ddlPrintOpenDay]").val() != ""
                        && $("[id*=ddlPrintCloseMonth]").val() != ""
                        && $("[id*=ddlPrintCloseDay]").val() != "")) {
                $("[id*=dvValErrPrintDates]").hide();
            }
            else {
                $("[id*=dvValErrPrintDates]").show();
                isValid = 0;
            }

            // Web dates
            if ($("[id*=hdnProductType]").val() == "5"
                    || $("[id*=rblPeriodOfOperation_0]").attr('checked')
                    || $("[id*=rblPeriodOfOperation_1]").attr('checked')
                    || ($("[id*=ddlOpenMonth]").val() != ""
                        && $("[id*=ddlOpenDay]").val() != ""
                        && $("[id*=ddlCloseMonth]").val() != ""
                        && $("[id*=ddlCloseDay]").val() != "")) {
                $("[id*=dvValErrWebDates]").hide();
            }
            else {
                $("[id*=dvValErrWebDates]").show();
                isValid = 0;
            }

            // Print rates
            if ($("[id*=hdnProductType]").val() != "1" && $("[id*=hdnProductType]").val() != "3"
                    || $("[id*=tbPrintLowRate]").val() != "" && $("[id*=tbPrintHighRate]").val() != "") {
                $("[id*=dvValErrPrintRates]").hide();
            }
            else {
                $("[id*=dvValErrPrintRates]").show();
                isValid = 0;
            }

            // Web rates
            if ($("[id*=hdnProductType]").val() != "1" && $("[id*=hdnProductType]").val() != "3"
                    || $("[id*=tbLowRate]").val() != "" && $("[id*=tbHighRate]").val() != "") {
                $("[id*=dvValErrWebRates]").hide();
            }
            else {
                $("[id*=dvValErrWebRates]").show();
                isValid = 0;
            }

            // Program approval
            if ($("[id*=hdnProductType]").val() != "1" && $("[id*=hdnProductType]").val() != "3" || $("[id*=dvApprovedBy] input:checked").length) {
                $("[id*=dvValErrApproval]").hide();
            }
            else {
                $("[id*=dvValErrApproval]").show();
                isValid = 0;
            }

            // Print guide section
            if ($("[id*=hdnProductType]").val() != "5" && $("[id*=hdnProductType]").val() != "6" || $("[id*=ddlPrimaryGuideSection]").val() != "") {
                $("[id*=dvValErrPrintGuide]").hide();
            }
            else {
                $("[id*=dvValErrPrintGuide]").show();
                isValid = 0;
            }

            // confirmation not received in 3 years
//            if ($("[id*=tbConfirmationLastReceived]").val() != "") {
//                var confirmationLastReceived = Date.parseExact($("[id*=tbConfirmationLastReceived]").val(), "dd-MM-yyyy");
//                if (confirmationLastReceived < Date.today().addYears(-3)) {
//                    $("[id*=dvValErrConfirmationLastReceived]").show();
//                    isValid = 0;
//                }
//                else {
//                    $("[id*=dvValErrConfirmationLastReceived]").hide();
//                }
//            }
//            else {
//                $("[id*=dvValErrConfirmationLastReceived]").hide();
//            }

            // Refresh Validation Summary
            if (!isValid) {

                $("[id*=hdnIsValid]").val("");
                $("[id*=dvValStatValid]").hide();
                $("[id*=dvValStatInvalid]").show();
                $("[id*=dvValidationErrors]").show();
                $("[id*=cbOverrideErrors]").removeAttr('disabled');
            }
            else {
                //alert("valid");
                $("[id*=hdnIsValid]").val("1");
                $("[id*=dvValStatValid]").show();
                $("[id*=dvValStatInvalid]").hide();
                $("[id*=dvValidationErrors]").hide();
                $("[id*=cbOverrideErrors]").removeAttr('checked').attr('disabled', true);
            }

            if ($("[id*=dvValWar]:not([style])").length) {
                $("[id*=dvValidationWarnings]").show();
            }
            else {
                $("[id*=dvValidationWarnings]").hide();
            }
        }
    
     </script>

     <script id="template-upload" type="text/x-jquery-tmpl">
    <tr class="template-upload{{if error}} ui-state-error{{/if}}">
        <td class="preview"></td>
        <td class="name">${name}</td>
        <td class="size">${sizef}</td>
        {{if error}}
            <td class="error" colspan="2">Error:
                {{if error === 'maxFileSize'}}File is too big
                {{else error === 'minFileSize'}}File is too small
                {{else error === 'acceptFileTypes'}}Filetype not allowed
                {{else error === 'maxNumberOfFiles'}}Max number of files exceeded
                {{else}}${error}
                {{/if}}
            </td>
        {{else}}
            <td><div class="fileupload-content"><div class="ui-progressbar-value ui-progressbar fileupload-progressbar"></div></div></td>
        {{/if}}
        <td class="cancel"><button></button></td>
    </tr>
</script>
<script id="template-download" type="text/x-jquery-tmpl">
    <tr class="template-download{{if error}} ui-state-error{{/if}}">
        {{if error}}
            <td></td>
            <td class="name">${name}</td>
            <td class="size">${sizef}</td>
            <td class="error" colspan="2">Error:
                {{if error === 1}}File exceeds upload_max_filesize (php.ini directive)
                {{else error === 2}}File exceeds MAX_FILE_SIZE (HTML form directive)
                {{else error === 3}}File was only partially uploaded
                {{else error === 4}}No File was uploaded
                {{else error === 5}}Missing a temporary folder
                {{else error === 6}}Failed to write file to disk
                {{else error === 7}}File upload stopped by extension
                {{else error === 'maxFileSize'}}File is too big
                {{else error === 'minFileSize'}}File is too small
                {{else error === 'acceptFileTypes'}}Filetype not allowed
                {{else error === 'maxNumberOfFiles'}}Max number of files exceeded
                {{else error === 'uploadedBytes'}}Uploaded bytes exceed file size
                {{else error === 'emptyResult'}}Empty file upload result
                {{else}}${error}
                {{/if}}
            </td>
        {{else}}
            <td class="preview">
                {{if isImage}}
                    <img style="width:80px;" runat="server" src="${thumbnail_url}" />
                {{/if}}
            </td>
            <td class="name">${name}</td>
            <td class="size">${sizef}</td>
            <td colspan="2"></td>
        {{/if}}
        <td class="delete">
            <button ></button>
        </td>
    </tr>
</script>
    
</asp:Content> 
<asp:Content ID="cMainContent" ContentPlaceHolderID="cphMainContent" Runat="Server"> 

    
    <div class="breadcrumb"><a href="Index.aspx">Product Index</a> &raquo; <strong>Modify Product</strong></div>
	
    <div class="page_header clearfix">
		<div class="action_btns"><asp:Button ID="btnSubmitTop" runat="server" Text="SAVE" OnClick="btnSubmit_onClick" OnClientClick="validate();" CssClass="submit_btn" />  | <asp:LinkButton ID="lbDeleteProductTop" runat="server" CausesValidation="false" OnClientClick="return ConfirmProductDelete()" OnClick="lbDeleteProduct_onClick">Delete</asp:LinkButton></div>
		<h2 class="page_title">Modify Product</h2>
	</div>
    <div id="dvFormLinks" class="task_links">
		<a id="lnkGenerateApplicationForm">Application form</a> | <a id="lnkGenerateConfirmationForm">Confirmation form</a><span id="listingproof_link" style="display:none;"> | <a id="lnkGenerateListingProofForm">Listing proof</a></span>
	</div>
        
            <asp:ScriptManager ID="toolkitScriptMaster" runat="server"></asp:ScriptManager>
         
            <script type="text/javascript" language="javascript">

                var prm = Sys.WebForms.PageRequestManager.getInstance();

                prm.add_endRequest(function () {
                    if ($("[id*=hdnMediaId]").val() != "") {
                        $("[id*=btnMediaSubmit]").attr('value', 'Update Media');
                        $("[id*=lnkAddMedia]").html('Edit Media');
                        MakeMediaFormAdjustments();
                        RevealMediaPanel();
                    }

                    if ($("[id*=hdnLinkId]").val() != "") {
                        $("[id*=btnLinkSubmit]").attr('value', 'Update Link');
                        $("[id*=lnkAddLink]").html('Edit Link');
                        MakeLinkFormAdjustments();
                        RevealLinkPanel();
                    }

                    if ($("[id*=hdnOperationalPeriodId]").val() != "") {
                        $("[id*=btnOperationalPeriodSubmit]").attr('value', 'Update Operational Period');
                        $("[id*=lnkAddOperationalPeriod]").html('Edit Operational Period');
                        RevealOperationalPeriodPanel();
                    }

                    if ($("[id*=hdnSupplementalDescriptionTypeId]").val() != "") {
                        $("[id*=btnSupplementalDescriptionSubmit]").attr('value', 'Update Cross Reference');
                        $("[id*=lnkAddSupplementalDescription]").html('Edit Cross Reference Description');
                        RevealSuppDescPanel();
                    }

                    if ($("[id*=hdnBusinessId]").val() != "") {
                        RevealContactPanel();
                    }

                    if ($("[id*=hdnBusinessId]").val() == "" || $("[id*=hdnBusinessId]").val() == "-1") {
                        $("[id*=ddlContact] > option").remove();
                        $("[id*=dvContactSelect]").hide();
                        $("[id*=dvEmptyContact]").show();
                    }
                    else {
                        $("[id*=dvContactSelect]").show();
                        $("[id*=dvEmptyContact]").hide();
                    }

                    if ($("[id*=hdnProductType]").val() == "5" || $("[id*=hdnProductType]").val() == "6") {
                        $("[id*=dvPrimaryGuideSection]").show();
                    }

                    //                    $("[id*=dvNotes]").click(function () {
                    //                        $(this).children('span').toggleClass('ui-icon-triangle-1-e').toggleClass('ui-icon-triangle-1-s');
                    //                        $(this).next().toggle(400);
                    //                        return false;
                    //                    }).next().hide();

                    InitializeEventBindings();
                });

                 
            </script>

		<div class="form_wrap clearfix">
    
            <asp:HiddenField ID="hdnProductId" runat="server" />
            <asp:HiddenField ID="hdnProductTypeId" runat="server" />
            <asp:HiddenField ID="hdnCurrentTabHash" runat="server" />
            <div class="col_wrap clearfix">
                
                <div class="left_col">
                    <div class="form_fields clearfix">
			            <div class="form_label"><label>Product name</label> <span class="required">&bull;</span></div>
			            <div class="form_input"><asp:TextBox ID="tbProductName" runat="server" MaxLength="200"></asp:TextBox></div>
                        <asp:RequiredFieldValidator ID="rfvProductName" runat="server" ControlToValidate="tbProductName" 
                            ErrorMessage="Product Name is a required field." Display="Dynamic" />
		            </div>
                    <div class="form_fields clearfix">
			            <div class="form_label"><label>Product type</label> <span class="required">&bull;</span></div>
			            <div id="litProductType" class="form_input"><asp:Literal ID="litProductType" runat="server"></asp:Literal></div>
                        
		            </div>
                    <div class="form_fields clearfix">
			            <div class="form_label"><label>Primary contact</label></div>
			            <div class="form_input"><a id="lnkOnsiteContact" runat="server" ><asp:Label ID="lblOnsiteContact" runat="server"></asp:Label></a></div>
                    </div>
                 </div>
                 <div class="midl_col">
                    <div class="form_fields clearfix">
			            <div class="form_label"><label>Email</label></div>
			            <div class="form_input"><asp:TextBox ID="tbEmail" runat="server" MaxLength="100"></asp:TextBox></div>
                        <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="tbEmail" ValidationExpression="^.+@([a-z]|[A-Z]|\d|-)+([a-z]|[A-Z]|\d|-|\.)*\.{1}([a-z]|[A-Z]|\d|-|\.|/)+$"
                            ErrorMessage="The specified email address is not a valid format." Display="Dynamic" />
		            </div>
                    <div class="form_fields clearfix">
			            <div class="form_label"><label>Website</label></div>
			            <div class="form_input"><asp:TextBox ID="tbWeb" runat="server" MaxLength="200"></asp:TextBox><a id="lnkCheckWeb">Check URL</a></div>
                        <asp:RegularExpressionValidator ID="revWeb" runat="server" ControlToValidate="tbWeb" ValidationExpression='^(https?://)?([^\s"])+$'
                            ErrorMessage="The specified web address is not a valid format." Display="Dynamic" />
		            </div>
                    
                </div>
                <div class="right_col">
                    <div class="form_fields clearfix">
			            <div class="form_label"><label>Product status</label></div>
			            <div class="form_input"><asp:Label ID="lblProductStatus" runat="server"></asp:Label></div>
                    </div>
                    <div class="form_fields clearfix">
			            <div class="form_label"><label>Validation status</label></div>
			            <div class="form_input"><asp:Label ID="lblValidationStatus" runat="server"></asp:Label></div>
		            </div>
                    <div class="form_fields clearfix">
			            <div class="form_label"><label>Errors overridden</label></div>
			            <div class="form_input"><asp:Label ID="lblErrorsOverridden" runat="server"></asp:Label></div>
                    </div>
                </div>
            </div>
			<div class="edit_paging">
				<asp:Button id="btnPrevProduct" runat="server" CssClass="btn_prev" Text="< Prev" OnClick="btnPrevProduct_OnClick" />
				<asp:Button id="btnNextProduct" runat="server" CssClass="btn_next" Text="Next >" OnClick="btnNextProduct_OnClick" />
			</div>
            <div id="tabs" class="clearfix">
                <div class="form_tabs clearfix">
                    <ul class="clearfix">
                        <li class="first"><a id="aTab1" onclick="highlightTabs();" href="#fragment-1"><span class="fr_tab">Location & Phone</span></a></li>
                        <li><a id="aTab2" onclick="highlightTabs();" href="#fragment-2"><span class="fr_tab">Description</span></a></li>
                        <li id="liCrossReferenceTab" style="display:none" ><a id="aTab9" onclick="highlightTabs();" href="#fragment-9"><span class="fr_tab">Cross References</span></a></li>
                        <li><a id="aTab3" onclick="highlightTabs();" href="#fragment-3"><span class="fr_tab">Dates &amp; Rates</span></a></li>
                        <li><a id="aTab4" onclick="highlightTabs();" href="#fragment-4"><span class="fr_tab">Features</span></a></li>
                        <li><a id="aTab5" onclick="highlightTabs();" href="#fragment-5"><span class="fr_tab">Media</span></a></li>
                        <li><a id="aTab6" onclick="highlightTabs();" href="#fragment-6"><span class="fr_tab">Links</span></a></li>
                        <li><a id="aTab7" onclick="highlightTabs();" href="#fragment-7"><span class="fr_tab">Contacts</span></a></li>
                        <li id="liOperationalDatesTab" style="display:none"><a id="aTab10" onclick="highlightTabs();" href="#fragment-10"><span class="fr_tab">Operational Dates</span></a></li>
                        <li class="last"><a id="aTab8" onclick="highlightTabs();" href="#fragment-8"><span class="fr_tab">Editor</span></a></li>
                        
                    </ul>
                </div>
                <div id="fragment-1">
					<div class="form_single_row">
						<div class="form_fields clearfix">
							<div class="form_label"><label>Proprietor</label></div>
							<div class="form_input"><asp:TextBox ID="tbProprietor" runat="server" MaxLength="100"></asp:TextBox></div>
						</div>
					</div>
					
					<h3>Phone</h3>
                    <div class="fieldset clearfix">
                        <div class="form_left">
                            <div class="form_fields clearfix">
		                        <div class="form_label"><label>Telephone</label></div>
			                    <div class="form_input"><asp:TextBox ID="tbPhone" runat="server" MaxLength="100" CssClass="phone_field"></asp:TextBox></div>
                                <asp:RegularExpressionValidator ID="valTab1Phone" runat="server" ControlToValidate="tbPhone" ValidationExpression="^\d{3}-\d{3}-\d{4}.*"
                                    ErrorMessage="Telephone must have a phone number at the beginning of the field in the format of 902-555-5555." Display="Dynamic" />
	                        </div>
                            <div class="form_fields clearfix">
		                        <div class="form_label"><label>Secondary telephone</label></div>
			                    <div class="form_input"><asp:TextBox ID="tbSecondaryPhone" runat="server" MaxLength="100" CssClass="phone_field"></asp:TextBox></div>
	                        </div>
                            <div class="form_fields clearfix">
		                        <div class="form_label"><label>Off season phone</label></div>
                                <div class="form_input"><asp:TextBox ID="tbOffSeasonPhone" runat="server" MaxLength="100" CssClass="phone_field"></asp:TextBox></div>
                      </div>
                       </div>
                       <div class="form_right">
                            <div class="form_fields clearfix">
                                <table>
                                    <tr><td><div class="form_label"><label>Toll-free</label></div></td><td><div class="form_label"><label>Area</label></div></td></tr>
                                    <tr><td style="padding-right:20px;"><div class="form_input"><asp:TextBox ID="tbTollFree" runat="server" MaxLength="100" CssClass="phone_field"></asp:TextBox></div></td><td><div class="form_input"><asp:DropDownList ID="ddlTollFreeArea" runat="server">
                                                        <asp:ListItem Value="">Please Select</asp:ListItem>
                                                        <asp:ListItem Value="1">Canada</asp:ListItem>
                                                        <asp:ListItem Value="2">North America</asp:ListItem></asp:DropDownList></div></td></tr>
                                </table>
			                    <div class="form_input" style="margin-top:0.5em;"><asp:CheckBox ID="cbReservationsOnly" runat="server" Text="Reservations only"/></div>
	                        </div>
                            <div class="form_fields clearfix">
		                        <div class="form_label"><label>Fax</label></div>
						                    <div class="form_input"><asp:TextBox ID="tbFax" runat="server" MaxLength="100" CssClass="phone_field"></asp:TextBox></div>
                      </div>                   
                       </div>
                   </div>
                   
                  <h3>Address</h3>
                  <asp:UpdatePanel ID="upAddress" runat="server">
                        <ContentTemplate>
                           <div class="fieldset clearfix">
                       <div class="form_left">
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
			                    <div class="form_input"><asp:DropDownList ID="ddlCommunity" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlCommunity_onIndexChanged" AppendDataBoundItems="true" ><asp:ListItem Value="">Please Select</asp:ListItem></asp:DropDownList></div>
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
                        <div class="form_right">
                            <div class="form_fields clearfix">
		                        <div class="form_label"><label>General area</label></div>
			                    <div class="form_input">
                                    <asp:Literal ID="litSubRegion" runat="server"></asp:Literal>
                                </div>
	                        </div>

                            <div class="form_fields clearfix">
		                        <div class="form_label"><label>Region</label></div>
			                    <div class="form_input">
                                    <table id="tblOtherRegion" border="0" cellpadding="0" cellspacing="0" class="cbTable">
                                        <tr>
                                            <td><asp:CheckBox ID="cbRegBrasDor" runat="server" Text="Bras d'Or Lakes Scenic Drive" /></td>
                                            <td><asp:CheckBox ID="cbRegCabotTrail" runat="server" Text="Cabot Trail" /></td>
                                        </tr>
                                        <tr>
                                            <td><asp:CheckBox ID="cbRegCeilidh" runat="server" Text="Ceilidh Trail" /></td>
                                            <td><asp:CheckBox ID="cbRegEasternShore" runat="server" Text="Eastern Shore" /></td>
                                        </tr>
                                        <tr>
                                            <td><asp:CheckBox ID="cbRegFleurDeLis" runat="server" Text="Fleur-de-Lis-Marconi-Metro CB" /></td>
                                            <td><asp:CheckBox ID="cbRegFundyShore" runat="server" Text="Fundy Shore & Annapolis Valley" /></td>
                                        </tr>
                                        <tr>
                                            <td><asp:CheckBox ID="cbRegHalifax" runat="server" Text="Halifax Metro" /></td>
                                            <td><asp:CheckBox ID="cbRegNorthumberland" runat="server" Text="Northumberland Shore" /></td>
                                        </tr>
                                        <tr>
                                            <td><asp:CheckBox ID="cbRegSouthShore" runat="server" Text="South Shore" /></td>
                                            <td><asp:CheckBox ID="cbRegYarmouth" runat="server" Text="Yarmouth & Acadian Shores" /></td>
                                        </tr>
                                    </table>
                                </div>
	                        </div>
                        </div>
                    </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    
                   <h3>Map</h3>
                    <div class="fieldset clearfix">
                        <div class="form_left">
                            <div class="form_fields clearfix">
		                        <div class="form_label"><label>Generate map pin</label></div>
			                    <div class="form_input"><asp:Button ID="btnSearchAddress" CausesValidation="false" Text="Based on address" OnClientClick="return SearchAddress()" runat="server"></asp:Button>&nbsp;<asp:Button ID="btnSearchLongLat" CausesValidation="false" Text="Based on long/lat" OnClientClick="return MapLongLat()" runat="server"></asp:Button></div>
	                        </div>
                            <div class="form_fields clearfix">
		                        <div class="form_label"><label>Latitude</label></div>
			                    <div class="form_input"><asp:TextBox ID="tbLatitude" runat="server" MaxLength="20" CssClass="latlong_field"></asp:TextBox></div>
	                        </div>
                            <div class="form_fields clearfix">
		                        <div class="form_label"><label>Longitude</label></div>
			                    <div class="form_input"><asp:TextBox ID="tbLongitude" runat="server" MaxLength="20" CssClass="latlong_field"></asp:TextBox></div>
	                        </div>

                            <asp:Panel ID="pnlCoordinateEditChecks" runat="server">
								<asp:CheckBox ID="cbAtt28_1351" runat="server" Text="Coordinates confirmed by operator" /><br />
								<asp:CheckBox ID="cbAtt28_1352" runat="server" Text="Coordinates checked by staff" /><br />
<!--                                <asp:CheckBox ID="cbAtt28_1353" runat="server" Text="Coordinates match" /> -->
							</asp:Panel>

                        
                        </div>
                        <div class="form_right">
                            <div id="map_canvas" class="form_fields clearfix" style="width:200px; height:200px"></div>
                        </div>
                    </div>
                    
                    <h3>Directions</h3>
                     <div class="fieldset clearfix">
                         <div class="form_left">
                             <div class="languageGroup">
                                <div class="form_fields clearfix">
		                            <div class="form_label lang_en"><label>Web directions</label></div>
			                        <div class="form_input"><asp:TextBox ID="tbWebDirectionsEn" runat="server" CssClass="wysiwyg" TextMode="MultiLine"></asp:TextBox></div>
	                            </div>
                                <div class="form_fields clearfix">
		                            <div class="form_label lang_fr"><label>Web directions</label></div>
			                        <div class="form_input"><asp:TextBox ID="tbWebDirectionsFr" runat="server" CssClass="wysiwyg" TextMode="MultiLine"></asp:TextBox></div>
	                            </div>
                                <div class="form_fields clearfix">
			                        <div class="form_input"><asp:CheckBox ID="cbTransMarkWebDirections" CssClass="translationMark" runat="server" Text="Translation required" /></div>
		                        </div>
                            </div>
                        </div>
                        <div class="form_right">
                            <div id="dvPrintDirections" class="languageGroup">
                                <div class="form_fields clearfix">
		                            <div class="form_label lang_en"><label>Print directions</label></div>
			                        <div class="form_input"><asp:TextBox ID="tbPrintDirectionsEn" runat="server" TextMode="MultiLine" Length="450"></asp:TextBox>
                                        <p class="chars_remaining">Characters remaining: 450</p></div>
	                            </div>
                                <div class="form_fields clearfix">
		                            <div class="form_label lang_fr"><label>Print directions</label></div>
			                        <div class="form_input"><asp:TextBox ID="tbPrintDirectionsFr" runat="server" TextMode="MultiLine" Length="900"></asp:TextBox>
                                        <p class="chars_remaining">Characters remaining: 450</p></div>
	                            </div>
                                <div class="form_fields clearfix">
			                        <div class="form_input"><asp:CheckBox ID="cbTransMarkPrintDirections" CssClass="translationMark" runat="server" Text="Translation required" /> </div>
		                        </div>
                            </div>                   
                        </div>
                    </div>
                </div><!-- end fragment-1 -->

                <div id="fragment-2" class="use_accordion">
                   

					<div class="ui-corner-all accordion_item">
						<h3><span class="ui-icon ui-icon-triangle-1-e"></span><a href="#">Web Content</a></h3>
						<div class="cnt clearfix">
							<div class="form_left">
								<div class="languageGroup" id="dvWebDescription">
									<div class="form_fields clearfix">
										<div class="form_label lang_en"><label>Property description</label></div>
										<div class="form_input"><asp:TextBox ID="tbWebDescriptionEn" runat="server" CssClass="wysiwyg" TextMode="MultiLine"></asp:TextBox></div>
									</div>
									<div class="form_fields clearfix">
										<div class="form_label lang_fr"><label>Property description</label></div>
										<div class="form_input"><asp:TextBox ID="tbWebDescriptionFr" runat="server" CssClass="wysiwyg" TextMode="MultiLine"></asp:TextBox></div>
									</div>
									<div class="form_fields clearfix">
										<div class="form_input"><asp:CheckBox ID="cbTransMarkWebDescription" CssClass="translationMark" runat="server" Text="Translation required" /> </div>
									</div>
								</div>
							</div>
							<div id="dvKeywordsGroup" class="form_right">
								<div class="languageGroup">
									<div class="form_fields clearfix">
										<div class="form_label lang_en"><label>Keywords</label></div>
										<div class="form_input"><asp:TextBox ID="tbWebKeywordsEn" runat="server" TextMode="MultiLine" Length="1000"></asp:TextBox>
											(keywords/phrases must be comma separated) <p class="chars_remaining">Characters remaining: 1000</p></div>
									</div>
									<div class="form_fields clearfix">
										<div class="form_label lang_fr"><label>Keywords</label></div>
										<div class="form_input"><asp:TextBox ID="tbWebKeywordsFr" runat="server" TextMode="MultiLine" Length="1000"></asp:TextBox>
											(keywords/phrases must be comma separated) <p class="chars_remaining">Characters remaining: 1000</p></div>
									</div>
									<div class="form_fields clearfix">
										<div class="form_input"><asp:CheckBox ID="cbTransMarkWebKeywords" CssClass="translationMark" runat="server" Text="Translation required" /> </div>
									</div>
								</div>

                                <div class="form_fields clearfix">
                                        <asp:HiddenField ID="hdnTags" runat="server" />
										<div class="form_label"><label>Tags</label></div>
										<div class="form_input"><input id="tbTags" value=""/></div>
								</div>
                            
							</div>
						</div>
                    </div>
                    <div id="dvPrintContent" class="ui-corner-all accordion_item">
						<h3><span class="ui-icon ui-icon-triangle-1-e"></span><a href="#">Print Content</a></h3>
						<div class="cnt clearfix">
							<div class="form_left">
							<asp:UpdatePanel ID="upPrimaryGuideSection" runat="server">
							<ContentTemplate>
								<div id="dvPrimaryGuideSection"  style="display:none" class="form_fields clearfix">
									<div class="form_label"><label>Primary Guide Section</label></div>
									<div class="form_input"><asp:DropDownList id="ddlPrimaryGuideSection" AppendDataBoundItems="true" runat="server"><asp:ListItem Value="">Please Select</asp:ListItem></asp:DropDownList></div>
								</div>
									</ContentTemplate>
								</asp:UpdatePanel>
								<div class="languageGroup" id="dvPrintDescription">
									<div class="form_fields clearfix">
										<div class="form_label lang_en"><label>Property description</label></div>
										<div class="form_input"><asp:TextBox ID="tbPrintDescriptionEn" runat="server" TextMode="MultiLine" Length="700"></asp:TextBox>
											<p class="chars_remaining">Characters remaining: 450</p></div>
									</div>
									<div class="form_fields clearfix">
										<div class="form_label lang_fr"><label>Property description</label></div>
										<div class="form_input"><asp:TextBox ID="tbPrintDescriptionFr" runat="server" TextMode="MultiLine" Length="900"></asp:TextBox>
											<p class="chars_remaining">Characters remaining: 450</p></div>
									</div>
									<div class="form_fields clearfix">
										<div class="form_input"><asp:CheckBox ID="cbTransMarkPrintDescription" CssClass="translationMark" runat="server" Text="Translation required" /> </div>
									</div>
								</div>
							</div>
							<div class="form_right">
								<div class="languageGroup" id="dvPrintUnitDescription" style="display:none" >
									<div id="dvUnitDescriptionEn" class="form_fields clearfix">
										<div class="form_label lang_en"><label>Unit description</label></div>
										<div class="form_input"><asp:TextBox ID="tbPrintUnitDescriptionEn" runat="server" TextMode="MultiLine" Length="450"></asp:TextBox>
											<p class="chars_remaining">Characters remaining: 450</p></div>
									</div>
									<div id="dvUnitDescriptionFr" class="form_fields clearfix">
										<div class="form_label lang_fr"><label>Unit description</label></div>
										<div class="form_input"><asp:TextBox ID="tbPrintUnitDescriptionFr" runat="server" TextMode="MultiLine" Length="900"></asp:TextBox>
											<p class="chars_remaining">Characters remaining: 450</p></div>
									</div>
									<div class="form_fields clearfix">
										<div class="form_input"><asp:CheckBox ID="cbTransMarkPrintUnit" CssClass="translationMark" runat="server" Text="Translation required" /> </div>
									</div>
								</div>
							</div>
						</div>
					</div>
                </div><!-- end fragment-2 -->

                <div id="fragment-9">
					<h3>Cross References</h3>
					<div class="warning_box">Please select or deselect related Features after you add, edit, or delete a Cross Reference.</div>
                    <asp:UpdatePanel ID="upProductDescription" runat="server">
                        <ContentTemplate>
                            
							<div class="fieldset clearfix">
								<table id="tblCrossReference" border="0" cellpadding="0" cellspacing="0" class="tbl_data">
									<asp:Repeater ID="rptProductDescription" runat="server">
										<HeaderTemplate>
											<tr class="tbl_header">
												<td style="width:28%;"><strong>Cross Reference Type</strong></td>
												<td style="width:28%;"><strong>English</strong></td>
												<td style="width:28%;"><strong>French</strong></td>
												<td style="width:15%;"><strong>Actions</strong></td>
											</tr>
										</HeaderTemplate>
										<ItemTemplate>
												<tr>
												<td><%# Eval("descriptionTypeName") %></td>
												<td><%# Eval("descriptionEn") %></td>
												<td><%# Eval("descriptionFr") %></td>
												<td><asp:LinkButton ID="btnEditSupplementalDescription" CommandArgument='<%# Eval("descriptionTypeId") %>' runat="server" Text="Edit" CausesValidation="false" OnClick="btnEditSupplementalDescription_onClick" /> | <asp:LinkButton ID="btnDeleteSupplementalDescription" CommandArgument='<%# Eval("descriptionTypeId") %>' OnClientClick='<%# "return ConfirmDelete(this, \"Are you sure you would like to delete the activity description " + Eval("descriptionEn") + "?\")" %>' runat="server" Text="Delete" OnClick="btnDeleteSupplementalDescription_onClick" /></td>
											</tr>
										</ItemTemplate>
									</asp:Repeater>
								</table>
							</div>
							
							<div id="suppDescToggle" class="section_toggle plus"><a id="lnkAddSupplementalDescription">Add Cross Reference</a></div>
                            <div id="suppDescForm" class="update_pnl section_body clearfix">
                                <asp:HiddenField ID="hdnSupplementalDescriptionTypeId" runat="server" />
                                <div class="clearfix">
                                    <div class="form_left">
                                        <div class="form_fields clearfix">
											<div class="form_label"><label>Product type</label> <span class="required">&bull;</span></div>
											<div class="form_input">
                                                <asp:RadioButtonList ID="rblGuideSection" runat="server">
                                                    <asp:ListItem Value="5">Outdoors</asp:ListItem>
                                                    <asp:ListItem Value="6">Tour Ops</asp:ListItem>
                                                </asp:RadioButtonList>
                                            </div>
										</div>
                                        <div id ="dvGuideSectionOutdoors" class="form_fields clearfix">
											<div class="form_label"><label>Cross reference type</label> <span class="required">&bull;</span></div>
											<div class="form_input"><asp:DropDownList ID="ddlGuideSectionOutdoors" runat="server"></asp:DropDownList></div>
                                            <asp:RequiredFieldValidator ID="rfvGuideSectionOutdoors" runat="server" ControlToValidate="ddlGuideSectionOutdoors" 
                                                    ErrorMessage="Description type is a required field." Display="Dynamic" ValidationGroup="vgActivity" />
										</div>
                                        <div id ="dvGuideSectionTourOps" class="form_fields clearfix">
											<div class="form_label"><label>Cross reference type</label> <span class="required">&bull;</span></div>
											<div class="form_input"><asp:DropDownList ID="ddlGuideSectionTourOps" runat="server"></asp:DropDownList></div>
                                            <asp:RequiredFieldValidator ID="rfvGuideSectionTourOps" runat="server" ControlToValidate="ddlGuideSectionTourOps" 
                                                    ErrorMessage="Description type is a required field." Display="Dynamic" ValidationGroup="vgActivity" />
										</div>
                                    </div>
                                    
									<div class="form_right">
										<div id="dvCrossReferenceDescriptionGroup" class="languageGroup">
                                            <div class="form_fields clearfix">
			                                    <div class="form_label lang_en"><label>Cross reference description</label></div>
			                                    <div class="form_input"><asp:TextBox ID="tbSupplementalDescriptionEn" runat="server" TextMode="MultiLine" Length="450"></asp:TextBox>
                                                <p class="chars_remaining">Characters remaining: 450</p></div>
  	                                        </div>
                                            <div class="form_fields clearfix">
			                                    <div class="form_label lang_fr"><label>Cross reference description</label></div>
			                                    <div class="form_input"><asp:TextBox ID="tbSupplementalDescriptionFr" runat="server" TextMode="MultiLine" Length="450"></asp:TextBox>
                                                <p class="chars_remaining">Characters remaining: 450</p></div>
		                                    </div>
                                            <div class="form_fields clearfix">
			                                    <div class="form_input"><asp:CheckBox ID="cbTransMarkSupplementalDescription" CssClass="translationMark" runat="server" Text="Translation required" /> </div>
		                                    </div>
                                        </div>
									</div>
                                </div>
                                
                                <div class="update_btn_bar">
                                    <asp:Button ID="btnSupplementalDescriptionSubmit" runat="server" Text="Save Cross Reference" OnClick="btnSupplementalDescriptionSubmit_onClick" CssClass="update_btn" ValidationGroup="vgActivity" /> | <a id="lnkCancelSupplementalDescription" href="#">Cancel</a>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div><!-- end fragment-9 -->

                <div id="fragment-3" class="use_accordion">
					<div class="ui-corner-all accordion_item">
						<h3><span class="ui-icon ui-icon-triangle-1-e"></span><a href="#">Web Dates &amp; Rates</a></h3>
						<div class="cnt clearfix">
                        <div class="form_left">
                            <div class="form_fields clearfix">
		                        <div class="form_label"><label>Year-round or seasonally</label></div>
			                    <div class="form_input">
                                    <asp:RadioButtonList ID="rblPeriodOfOperation" runat="server" >
                                        <asp:ListItem Value="1">Open year-round</asp:ListItem>
                                        <asp:ListItem Value="2">Open seasonally</asp:ListItem> 
                                        <asp:ListItem Value="3">Date range</asp:ListItem>
                                    </asp:RadioButtonList>
                                </div>
	                        </div>
                            <div id="dvWebDates">
                            <asp:Placeholder ID="plcWebDates" runat="server">
                            <div class="form_fields clearfix">
		                        <div class="form_label"><label>Open Date</label></div>
			                    <div class="form_input">
                                    <asp:DropDownList ID="ddlOpenMonth" runat="server">
                                        <asp:ListItem Value="">Select month</asp:ListItem>
                                        <asp:ListItem Text="January" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="February" Value="2"></asp:ListItem>
                                        <asp:ListItem Text="March" Value="3"></asp:ListItem>
                                        <asp:ListItem Text="April" Value="4"></asp:ListItem>
                                        <asp:ListItem Text="May" Value="5"></asp:ListItem>
                                        <asp:ListItem Text="June" Value="6"></asp:ListItem>
                                        <asp:ListItem Text="July" Value="7"></asp:ListItem>
                                        <asp:ListItem Text="August" Value="8"></asp:ListItem>
                                        <asp:ListItem Text="September" Value="9"></asp:ListItem>
                                        <asp:ListItem Text="October" Value="10"></asp:ListItem>
                                        <asp:ListItem Text="November" Value="11"></asp:ListItem>
                                        <asp:ListItem Text="December" Value="12"></asp:ListItem>
                                    </asp:DropDownList>
                                    &nbsp;
                                    <asp:DropDownList ID="ddlOpenDay" runat="server">
                                        <asp:ListItem Value="">Select day</asp:ListItem>
                                        <asp:ListItem Text="1" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="2" Value="2"></asp:ListItem>
                                        <asp:ListItem Text="3" Value="3"></asp:ListItem>
                                        <asp:ListItem Text="4" Value="4"></asp:ListItem>
                                        <asp:ListItem Text="5" Value="5"></asp:ListItem>
                                        <asp:ListItem Text="6" Value="6"></asp:ListItem>
                                        <asp:ListItem Text="7" Value="7"></asp:ListItem>
                                        <asp:ListItem Text="8" Value="8"></asp:ListItem>
                                        <asp:ListItem Text="9" Value="9"></asp:ListItem>
                                        <asp:ListItem Text="10" Value="10"></asp:ListItem>
                                        <asp:ListItem Text="11" Value="11"></asp:ListItem>
                                        <asp:ListItem Text="12" Value="12"></asp:ListItem>
                                        <asp:ListItem Text="13" Value="13"></asp:ListItem>
                                        <asp:ListItem Text="14" Value="14"></asp:ListItem>
                                        <asp:ListItem Text="15" Value="15"></asp:ListItem>
                                        <asp:ListItem Text="16" Value="16"></asp:ListItem>
                                        <asp:ListItem Text="17" Value="17"></asp:ListItem>
                                        <asp:ListItem Text="18" Value="18"></asp:ListItem>
                                        <asp:ListItem Text="19" Value="19"></asp:ListItem>
                                        <asp:ListItem Text="20" Value="20"></asp:ListItem>
                                        <asp:ListItem Text="21" Value="21"></asp:ListItem>
                                        <asp:ListItem Text="22" Value="22"></asp:ListItem>
                                        <asp:ListItem Text="23" Value="23"></asp:ListItem>
                                        <asp:ListItem Text="24" Value="24"></asp:ListItem>
                                        <asp:ListItem Text="25" Value="25"></asp:ListItem>
                                        <asp:ListItem Text="26" Value="26"></asp:ListItem>
                                        <asp:ListItem Text="27" Value="27"></asp:ListItem>
                                        <asp:ListItem Text="28" Value="28"></asp:ListItem>
                                        <asp:ListItem Text="29" Value="29"></asp:ListItem>
                                        <asp:ListItem Text="30" Value="30"></asp:ListItem>
                                        <asp:ListItem Text="31" Value="31"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
	                            </div>
                        

                                <div class="form_fields clearfix">
		                            <div class="form_label"><label>Close Date</label></div>
			                        <div class="form_input">
                                        <asp:DropDownList ID="ddlCloseMonth" runat="server">
                                            <asp:ListItem Value="">Select month</asp:ListItem>
                                            <asp:ListItem Text="January" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="February" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="March" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="April" Value="4"></asp:ListItem>
                                            <asp:ListItem Text="May" Value="5"></asp:ListItem>
                                            <asp:ListItem Text="June" Value="6"></asp:ListItem>
                                            <asp:ListItem Text="July" Value="7"></asp:ListItem>
                                            <asp:ListItem Text="August" Value="8"></asp:ListItem>
                                            <asp:ListItem Text="September" Value="9"></asp:ListItem>
                                            <asp:ListItem Text="October" Value="10"></asp:ListItem>
                                            <asp:ListItem Text="November" Value="11"></asp:ListItem>
                                            <asp:ListItem Text="December" Value="12"></asp:ListItem>
                                        </asp:DropDownList>
                                        &nbsp;
                                        <asp:DropDownList ID="ddlCloseDay" runat="server">
                                            <asp:ListItem Value="">Select day</asp:ListItem>
                                            <asp:ListItem Text="1" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="2" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="3" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="4" Value="4"></asp:ListItem>
                                            <asp:ListItem Text="5" Value="5"></asp:ListItem>
                                            <asp:ListItem Text="6" Value="6"></asp:ListItem>
                                            <asp:ListItem Text="7" Value="7"></asp:ListItem>
                                            <asp:ListItem Text="8" Value="8"></asp:ListItem>
                                            <asp:ListItem Text="9" Value="9"></asp:ListItem>
                                            <asp:ListItem Text="10" Value="10"></asp:ListItem>
                                            <asp:ListItem Text="11" Value="11"></asp:ListItem>
                                            <asp:ListItem Text="12" Value="12"></asp:ListItem>
                                            <asp:ListItem Text="13" Value="13"></asp:ListItem>
                                            <asp:ListItem Text="14" Value="14"></asp:ListItem>
                                            <asp:ListItem Text="15" Value="15"></asp:ListItem>
                                            <asp:ListItem Text="16" Value="16"></asp:ListItem>
                                            <asp:ListItem Text="17" Value="17"></asp:ListItem>
                                            <asp:ListItem Text="18" Value="18"></asp:ListItem>
                                            <asp:ListItem Text="19" Value="19"></asp:ListItem>
                                            <asp:ListItem Text="20" Value="20"></asp:ListItem>
                                            <asp:ListItem Text="21" Value="21"></asp:ListItem>
                                            <asp:ListItem Text="22" Value="22"></asp:ListItem>
                                            <asp:ListItem Text="23" Value="23"></asp:ListItem>
                                            <asp:ListItem Text="24" Value="24"></asp:ListItem>
                                            <asp:ListItem Text="25" Value="25"></asp:ListItem>
                                            <asp:ListItem Text="26" Value="26"></asp:ListItem>
                                            <asp:ListItem Text="27" Value="27"></asp:ListItem>
                                            <asp:ListItem Text="28" Value="28"></asp:ListItem>
                                            <asp:ListItem Text="29" Value="29"></asp:ListItem>
                                            <asp:ListItem Text="30" Value="30"></asp:ListItem>
                                            <asp:ListItem Text="31" Value="31"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
	                            </div>
                                </asp:Placeholder>
                            </div>

                            <div id="dvWebHasOffSeasonDates" style="display:none" class="form_fields clearfix">
			                    <div class="form_label"><label>Off season dates by reservation</label></div>
			                    <div class="form_input"><asp:CheckBox ID="cbHasOffSeasonDates" runat="server" /></div>
		                    </div>

							<div id="dvWebHasOffSeasonRates" style="display:none" class="form_fields clearfix">
			                    <div class="form_label"><label>Off season rates available</label></div>
			                    <div class="form_input"><asp:CheckBox ID="cbHasOffSeasonRates" runat="server" /></div>
		                    </div>
                            <div id="dvWebRateIncludesTax" style="display:none" class="form_fields clearfix">
			                    <div class="form_label"><label>No tax</label></div>
			                    <div class="form_input"><asp:CheckBox ID="cbNoTax" runat="server"></asp:CheckBox></div>
		                    </div>
                            
						</div>
                        <div class="form_right">
                            <div id="dvWebLowRate" style="display:none" class="form_fields clearfix">
			                    <div class="form_label"><label>Low rate</label></div>
			                    <div class="form_input">$&nbsp;<asp:TextBox ID="tbLowRate" CssClass="money_field" runat="server" MaxLength="10"></asp:TextBox></div>
		                    </div>
                            <div id="dvWebHighRate" style="display:none" class="form_fields clearfix">
			                    <div class="form_label"><label>High rate</label></div>
			                    <div class="form_input">$&nbsp;<asp:TextBox ID="tbHighRate" CssClass="money_field" runat="server" MaxLength="10"></asp:TextBox></div>
		                    </div>
                            <div id="dvWebExtraPersonRate" style="display:none" class="form_fields clearfix">
			                    <div class="form_label"><label>Extra person rate</label></div>
			                    <div class="form_input">$&nbsp;<asp:TextBox ID="tbExtraPersonRate" CssClass="money_field" runat="server" MaxLength="10"></asp:TextBox></div>
		                    </div>
                            <div id="dvWebRateType" style="display:none" class="form_fields clearfix">
			                    <div class="form_label"><label>Rate type</label></div>
			                    <div class="form_input"><asp:DropDownList ID="ddlRateType" runat="server"></asp:DropDownList></div>
		                    </div>
                            <div id="dvWebRatePeriod" style="display:none" class="form_fields clearfix">
			                    <div class="form_label"><label>Rate period</label></div>
			                    <div class="form_input"><asp:DropDownList ID="ddlRatePeriod" runat="server"></asp:DropDownList></div>
		                    </div>
                            <div id="dvWebCancellationPolicy" style="display:none" class="form_fields clearfix">
			                    <div class="form_label"><label>Cancellation policy</label></div>
			                    <div class="form_input"><asp:DropDownList ID="ddlCancellationPolicy" runat="server"></asp:DropDownList></div>
		                    </div>
                         </div>
						 </div>
                    </div>

                    <div class="ui-corner-all accordion_item">
						<h3><span class="ui-icon ui-icon-triangle-1-e"></span><a href="#">Web Dates &amp; Rates Descriptions</a></h3>
						<div class="cnt clearfix">
							<div class="form_left">
								<div class="languageGroup">
									<div class="form_fields clearfix">
										<div class="form_label lang_en"><label>Date details/Hours of operation</label></div>
										<div class="form_input"><asp:TextBox ID="tbWebDateDescriptionEn" runat="server" CssClass="wysiwyg" TextMode="MultiLine"></asp:TextBox></div>
									</div>
									<div class="form_fields clearfix">
										<div class="form_label lang_fr"><label>Date details/Hours of operation</label></div>
										<div class="form_input"><asp:TextBox ID="tbWebDateDescriptionFr" runat="server" CssClass="wysiwyg" TextMode="MultiLine"></asp:TextBox></div>
									</div>
									<div class="form_fields clearfix">
										<div class="form_input"><asp:CheckBox ID="cbTransMarkWebDate" CssClass="translationMark" runat="server" Text="Translation required" /> </div>
									</div>
								</div>

								<div class="languageGroup" id="dvWebCancellationPolicyDesc" style="display:none" >
									<div class="form_fields clearfix">
										<div class="form_label lang_en"><label>Cancellation policy</label></div>
										<div class="form_input"><asp:TextBox ID="tbWebCancellationPolicyEn" runat="server" CssClass="wysiwyg" TextMode="MultiLine"></asp:TextBox></div>
									</div>
									<div class="form_fields clearfix">
										<div class="form_label lang_fr"><label>Cancellation policy</label></div>
										<div class="form_input"><asp:TextBox ID="tbWebCancellationPolicyFr" runat="server" CssClass="wysiwyg" TextMode="MultiLine"></asp:TextBox></div>
									</div>
									<div class="form_fields clearfix">
										<div class="form_input"><asp:CheckBox ID="cbTransMarkWebCancellationPolicy" CssClass="translationMark" runat="server" Text="Translation required" /> </div>
									</div>
								</div>
							</div>
							<div class="form_right">
								<div id="dvWebRateDescriptionGroup" style="display:none" class="languageGroup">
									<div id="dvWebRateDescriptionEn" class="form_fields clearfix">
										<div class="form_label lang_en"><label>Rate/admission details</label></div>
										<div class="form_input lang_fr"><asp:TextBox ID="tbWebRateDescriptionEn" runat="server" CssClass="wysiwyg" TextMode="MultiLine"></asp:TextBox></div>
									</div>
									<div id="dvWebRateDescriptionFr" class="form_fields clearfix">
										<div class="form_label"><label>Rate/admission details</label></div>
										<div class="form_input"><asp:TextBox ID="tbWebRateDescriptionFr" runat="server" CssClass="wysiwyg" TextMode="MultiLine"></asp:TextBox></div>
									</div>
									<div id="dvWebRateTransMark" class="form_fields clearfix">
										<div class="form_input"><asp:CheckBox ID="cbTransMarkWebRate" CssClass="translationMark" runat="server" Text="Translation required" /> </div>
									</div>
								</div>
							</div>
						</div>
					</div>

					<div id="dvPrintDatesRatesSection" class="ui-corner-all accordion_item">
						<h3><span class="ui-icon ui-icon-triangle-1-e"></span><a href="#">Print Dates &amp; Rates</a></h3>
						<div class="cnt clearfix">
							<div class="form_left">
									<div class="form_fields clearfix">
										<div class="form_label"><label>Year-round or seasonally</label></div>
										<div class="form_input">
											<asp:RadioButtonList ID="rblPrintPeriodOfOperation" runat="server" >
												<asp:ListItem Value="1">Open year-round</asp:ListItem>
												<asp:ListItem Value="2">Open seasonally</asp:ListItem> 
												<asp:ListItem Value="3">Date range</asp:ListItem> 
											</asp:RadioButtonList>
										</div>
									</div>
									<div id="dvPrintDatesSection">
									<asp:Placeholder ID="plcPrintDates" runat="server" >
									<div class="form_fields clearfix">
										<div class="form_label"><label>Open Date</label></div>
										<div class="form_input">
											<asp:DropDownList ID="ddlPrintOpenMonth" runat="server">
												<asp:ListItem Value="">Select month</asp:ListItem>
												<asp:ListItem Text="January" Value="1"></asp:ListItem>
												<asp:ListItem Text="February" Value="2"></asp:ListItem>
												<asp:ListItem Text="March" Value="3"></asp:ListItem>
												<asp:ListItem Text="April" Value="4"></asp:ListItem>
												<asp:ListItem Text="May" Value="5"></asp:ListItem>
												<asp:ListItem Text="June" Value="6"></asp:ListItem>
												<asp:ListItem Text="July" Value="7"></asp:ListItem>
												<asp:ListItem Text="August" Value="8"></asp:ListItem>
												<asp:ListItem Text="September" Value="9"></asp:ListItem>
												<asp:ListItem Text="October" Value="10"></asp:ListItem>
												<asp:ListItem Text="November" Value="11"></asp:ListItem>
												<asp:ListItem Text="December" Value="12"></asp:ListItem>
											</asp:DropDownList>
											&nbsp;
											<asp:DropDownList ID="ddlPrintOpenDay" runat="server">
												<asp:ListItem Value="">Select day</asp:ListItem>
												<asp:ListItem Text="1" Value="1"></asp:ListItem>
												<asp:ListItem Text="2" Value="2"></asp:ListItem>
												<asp:ListItem Text="3" Value="3"></asp:ListItem>
												<asp:ListItem Text="4" Value="4"></asp:ListItem>
												<asp:ListItem Text="5" Value="5"></asp:ListItem>
												<asp:ListItem Text="6" Value="6"></asp:ListItem>
												<asp:ListItem Text="7" Value="7"></asp:ListItem>
												<asp:ListItem Text="8" Value="8"></asp:ListItem>
												<asp:ListItem Text="9" Value="9"></asp:ListItem>
												<asp:ListItem Text="10" Value="10"></asp:ListItem>
												<asp:ListItem Text="11" Value="11"></asp:ListItem>
												<asp:ListItem Text="12" Value="12"></asp:ListItem>
												<asp:ListItem Text="13" Value="13"></asp:ListItem>
												<asp:ListItem Text="14" Value="14"></asp:ListItem>
												<asp:ListItem Text="15" Value="15"></asp:ListItem>
												<asp:ListItem Text="16" Value="16"></asp:ListItem>
												<asp:ListItem Text="17" Value="17"></asp:ListItem>
												<asp:ListItem Text="18" Value="18"></asp:ListItem>
												<asp:ListItem Text="19" Value="19"></asp:ListItem>
												<asp:ListItem Text="20" Value="20"></asp:ListItem>
												<asp:ListItem Text="21" Value="21"></asp:ListItem>
												<asp:ListItem Text="22" Value="22"></asp:ListItem>
												<asp:ListItem Text="23" Value="23"></asp:ListItem>
												<asp:ListItem Text="24" Value="24"></asp:ListItem>
												<asp:ListItem Text="25" Value="25"></asp:ListItem>
												<asp:ListItem Text="26" Value="26"></asp:ListItem>
												<asp:ListItem Text="27" Value="27"></asp:ListItem>
												<asp:ListItem Text="28" Value="28"></asp:ListItem>
												<asp:ListItem Text="29" Value="29"></asp:ListItem>
												<asp:ListItem Text="30" Value="30"></asp:ListItem>
												<asp:ListItem Text="31" Value="31"></asp:ListItem>
											</asp:DropDownList>
										</div>
									</div>

									<div class="form_fields clearfix">
										<div class="form_label"><label>Close Date</label> <span class="required">&bull;</span></div>
										<div class="form_input">
											<asp:DropDownList ID="ddlPrintCloseMonth" runat="server">
												<asp:ListItem Value="">Select month</asp:ListItem>
												<asp:ListItem Text="January" Value="1"></asp:ListItem>
												<asp:ListItem Text="February" Value="2"></asp:ListItem>
												<asp:ListItem Text="March" Value="3"></asp:ListItem>
												<asp:ListItem Text="April" Value="4"></asp:ListItem>
												<asp:ListItem Text="May" Value="5"></asp:ListItem>
												<asp:ListItem Text="June" Value="6"></asp:ListItem>
												<asp:ListItem Text="July" Value="7"></asp:ListItem>
												<asp:ListItem Text="August" Value="8"></asp:ListItem>
												<asp:ListItem Text="September" Value="9"></asp:ListItem>
												<asp:ListItem Text="October" Value="10"></asp:ListItem>
												<asp:ListItem Text="November" Value="11"></asp:ListItem>
												<asp:ListItem Text="December" Value="12"></asp:ListItem>
											</asp:DropDownList>
											&nbsp;
											<asp:DropDownList ID="ddlPrintCloseDay" runat="server">
												<asp:ListItem Value="">Select day</asp:ListItem>    
												<asp:ListItem Text="1" Value="1"></asp:ListItem>
												<asp:ListItem Text="2" Value="2"></asp:ListItem>
												<asp:ListItem Text="3" Value="3"></asp:ListItem>
												<asp:ListItem Text="4" Value="4"></asp:ListItem>
												<asp:ListItem Text="5" Value="5"></asp:ListItem>
												<asp:ListItem Text="6" Value="6"></asp:ListItem>
												<asp:ListItem Text="7" Value="7"></asp:ListItem>
												<asp:ListItem Text="8" Value="8"></asp:ListItem>
												<asp:ListItem Text="9" Value="9"></asp:ListItem>
												<asp:ListItem Text="10" Value="10"></asp:ListItem>
												<asp:ListItem Text="11" Value="11"></asp:ListItem>
												<asp:ListItem Text="12" Value="12"></asp:ListItem>
												<asp:ListItem Text="13" Value="13"></asp:ListItem>
												<asp:ListItem Text="14" Value="14"></asp:ListItem>
												<asp:ListItem Text="15" Value="15"></asp:ListItem>
												<asp:ListItem Text="16" Value="16"></asp:ListItem>
												<asp:ListItem Text="17" Value="17"></asp:ListItem>
												<asp:ListItem Text="18" Value="18"></asp:ListItem>
												<asp:ListItem Text="19" Value="19"></asp:ListItem>
												<asp:ListItem Text="20" Value="20"></asp:ListItem>
												<asp:ListItem Text="21" Value="21"></asp:ListItem>
												<asp:ListItem Text="22" Value="22"></asp:ListItem>
												<asp:ListItem Text="23" Value="23"></asp:ListItem>
												<asp:ListItem Text="24" Value="24"></asp:ListItem>
												<asp:ListItem Text="25" Value="25"></asp:ListItem>
												<asp:ListItem Text="26" Value="26"></asp:ListItem>
												<asp:ListItem Text="27" Value="27"></asp:ListItem>
												<asp:ListItem Text="28" Value="28"></asp:ListItem>
												<asp:ListItem Text="29" Value="29"></asp:ListItem>
												<asp:ListItem Text="30" Value="30"></asp:ListItem>
												<asp:ListItem Text="31" Value="31"></asp:ListItem>
											</asp:DropDownList>
										</div>
									</div>
									</asp:Placeholder>
									</div>

                                <div id="dvPrintHasOffSeasonDates" style="display:none" class="form_fields clearfix">
			                        <div class="form_label"><label>Off season dates by reservation</label></div>
			                        <div class="form_input"><asp:CheckBox ID="cbPrintHasOffSeasonDates" runat="server" /></div>
		                        </div>
								<div id="dvPrintHasOffSeasonRates" style="display:none" class="form_fields clearfix">
									<div class="form_label"><label>Off season rates available</label></div>
									<div class="form_input"><asp:CheckBox ID="cbPrintHasOffSeasonRates" runat="server" /></div>
								</div>
								<div id="dvPrintRateIncludesTax" style="display:none" class="form_fields clearfix">
									<div class="form_label"><label>No tax</label></div>
									<div class="form_input"><asp:CheckBox ID="cbPrintNoTax" runat="server"></asp:CheckBox></div>
								</div>
                            
							</div>
							<div class="form_right">
								<div id="dvPrintLowRate" style="display:none" class="form_fields clearfix">
									<div class="form_label"><label>Low rate</label></div>
									<div class="form_input">$&nbsp;<asp:TextBox ID="tbPrintLowRate" CssClass="money_field" runat="server"></asp:TextBox></div>
								</div>
								<div id="dvPrintHighRate" style="display:none" class="form_fields clearfix">
									<div class="form_label"><label>High rate</label></div>
									<div class="form_input">$&nbsp;<asp:TextBox ID="tbPrintHighRate" CssClass="money_field" runat="server"></asp:TextBox></div>
								</div>
								<div id="dvPrintExtraPersonRate" style="display:none" class="form_fields clearfix">
									<div class="form_label"><label>Extra person rate</label></div>
									<div class="form_input">$&nbsp;<asp:TextBox ID="tbPrintExtraPersonRate" CssClass="money_field" runat="server"></asp:TextBox></div>
								</div>
								<div id="dvPrintRateType" style="display:none" class="form_fields clearfix">
									<div class="form_label"><label>Rate type</label></div>
									<div class="form_input"><asp:DropDownList ID="ddlPrintRateType" runat="server"></asp:DropDownList></div>
								</div>
								<div id="dvPrintRatePeriod" style="display:none" class="form_fields clearfix">
									<div class="form_label"><label>Rate period</label></div>
									<div class="form_input"><asp:DropDownList ID="ddlPrintRatePeriod" runat="server"></asp:DropDownList></div>
								</div>
								<div id="dvPrintCancellationPolicy" style="display:none" class="form_fields clearfix">
									<div class="form_label"><label>Cancellation policy</label></div>
									<div class="form_input"><asp:DropDownList ID="ddlPrintCancellationPolicy" runat="server"></asp:DropDownList></div>
								</div>
							</div>
						</div>
                    </div>

					<div id="dvPrintDateRateDescriptions" class="ui-corner-all accordion_item">
						<h3><span class="ui-icon ui-icon-triangle-1-e"></span><a href="#">Print Date &amp; Rate Descriptions</a></h3>
						<div class="cnt clearfix">
							<div class="form_left">
								<div class="languageGroup">
									<div class="form_fields clearfix">
										<div class="form_label lang_en"><label>Date details/Hours of operation</label></div>
										<div class="form_input"><asp:TextBox ID="tbPrintDateDescriptionEn" runat="server" TextMode="MultiLine"></asp:TextBox></div>
									</div>
									<div class="form_fields clearfix">
										<div class="form_label lang_fr"><label>Date details/Hours of operation</label></div>
										<div class="form_input"><asp:TextBox ID="tbPrintDateDescriptionFr" runat="server" TextMode="MultiLine"></asp:TextBox></div>
									</div>
									<div class="form_fields clearfix">
										<div class="form_input"><asp:CheckBox ID="cbTransMarkPrintDate" CssClass="translationMark" runat="server" Text="Translation required" /> </div>
									</div>
								</div>
							</div>
							<div class="form_right">
								<div id="dvPrintRateDescriptionGroup" style="display:none" class="languageGroup">
									<div id="dvPrintRateDescriptionEn" class="form_fields clearfix">
										<div class="form_label lang_en"><label>Rate/Admission details</label></div>
										<div class="form_input"><asp:TextBox ID="tbPrintRateDescriptionEn" runat="server" TextMode="MultiLine"></asp:TextBox></div>
									</div>
									<div id="dvPrintRateDescriptionFr" class="form_fields clearfix">
										<div class="form_label lang_fr"><label>Rate/Admission details</label></div>
										<div class="form_input"><asp:TextBox ID="tbPrintRateDescriptionFr" runat="server" TextMode="MultiLine"></asp:TextBox></div>
									</div>
									<div id="dvPrintRateTransMark" class="form_fields clearfix">
										<div class="form_input"><asp:CheckBox ID="cbTransMarkPrintRate" CssClass="translationMark" runat="server" Text="Translation required" /> </div>
									</div>
								</div>
							</div>
						</div>
					</div>

					<h3>Payment Types</h3>
                    <div class="fieldset clearfix">
                        <div class="form_left">
                            <div class="form_fields">
								<table border="0" cellpadding="0" cellspacing="0" class="cbTable">
									<tr><td><strong>Select all accepted payment types</strong></td></tr>
									<tr>
										<td><asp:CheckBox ID="cbPaymentTypeCashOnly" runat="server" Text="Cash only" /></td>
									</tr>
									<tr>
										<td><div style="margin:0.5em 0;height:1px;border-bottom:1px solid #ddd;">&nbsp;</div></td>
									</tr>
									<tr>
										<td><asp:CheckBox ID="cbPaymentTypeAmex" runat="server" Text="American Express" /></td>
									</tr>
                                    <tr>
										<td><asp:CheckBox ID="cbPaymentTypeDebitCard" runat="server" Text="Debit cards" /></td>
									</tr>
									<tr>
										<td><asp:CheckBox ID="cbPaymentTypeDiners" runat="server" Text="Diner's Club" /></td>
									</tr>
									<tr>
										<td><asp:CheckBox ID="cbPaymentTypeDiscover" runat="server" Text="Discover" /></td>
									</tr>
                                    <tr>
										<td><asp:CheckBox ID="cbPaymentTypeJcb" runat="server" Text="JCB" /></td>
									</tr>
									<tr>
										<td><asp:CheckBox ID="cbPaymentTypeMasterCard" runat="server" Text="MasterCard" /></td>
									</tr>
									<tr>
										<td><asp:CheckBox ID="cbPaymentTypeVisa" runat="server" Text="Visa" /></td>
									</tr>
									<tr>
										<td><asp:CheckBox ID="cbPaymentTypePayPal" runat="server" Text="PayPal" /></td>
									</tr>
                                   
                                    <!--
									<tr>
										<td><asp:CheckBox ID="cbPaymentTypeTravellersCheques" runat="server" Text="Travellers cheques" /></td>
									</tr>
                                    -->
								</table>
							</div>
                        </div>
                        <div class="form_right">
							<div class="form_fields">
								&nbsp;
							</div>
                        </div>
                    </div>
                </div><!-- end fragment-3 -->
            
                <div id="fragment-4">
                <asp:Panel ID="pnlProductAttributes" runat="server">
                    <div id="dvMicsellaneous" class="fieldset clearfix">
                        <div class="form_left">
                            <div id="dvLicenseNumber" style="display:none;" class="form_fields clearfix">
                                <div class="form_label"><label>License number</label> </div>
			                    <div class="form_input"><asp:TextBox ID="tbLicenseNumber" runat="server" MaxLength="10" CssClass="biz_name_field"></asp:TextBox></div>
                                <asp:CustomValidator ID="cvLicenseNumber" runat="server" ControlToValidate="tbLicenseNumber"
                                    ErrorMessage="The submitted license number is already in use." Display="Dynamic" Enabled="true" 
                                    onservervalidate="cvLicenseNumber_ServerValidate" />
                                
                            </div>
                            <div id="dvCheckIn" style="display:none;" class="form_fields clearfix">
			                    <div class="form_label"><label>Check-In ID</label> <span class="pg_item">(PG)</span></div>
			                    <div class="form_input"><asp:CheckBox ID="cbCheckinMember" runat="server" Text="Check-In Member" />&nbsp;&nbsp;&nbsp;<asp:TextBox ID="tbCheckinId" runat="server" MaxLength="6" style="width:120px;"></asp:TextBox></div>
		                    </div>
                            <div id="dvRegistryNumber">
						        <div class="form_fields clearfix">
							        <div class="form_label"><label>Registry Number</label> </div>
							        <div class="form_input"><asp:TextBox id="tbRegistryNumber" runat="server" MaxLength="7" CssClass="biz_name_field"></asp:TextBox></div>
						        </div>
					        </div>
                            <div id="dvParkingSpaces"  style="display:none">
						        <div class="form_fields clearfix">
							        <div class="form_label"><label>Parking spaces</label> <span class="pg_item">(PG)</span></div>
							        <div class="form_input"><asp:TextBox id="tbParkingSpaces" runat="server" MaxLength="30" CssClass="biz_name_field"></asp:TextBox></div>
						        </div>
					        </div>

                            <div id="dvSeatingCapacity"  style="display:none">
						        <div class="form_fields clearfix">
                                    <table>
                                        <tr><td ><div class="form_label"><label>Interior seating</label> <span class="pg_item">(PG)</span></div></td><td><div class="form_label"><label>Exterior seating</label> <span class="pg_item">(PG)</span></div></td></tr>
                                        <tr><td style="padding-right:20px;"><div class="form_input"><asp:TextBox id="tbSeatingCapacityInterior" runat="server" MaxLength="10" CssClass="phone_field"></asp:TextBox></div></td><td><div class="form_input"><asp:TextBox id="tbSeatingCapacityExterior" runat="server" MaxLength="10" CssClass="phone_field"></asp:TextBox></div></td></tr></table>
						        </div>
					        </div>

                             <div id="dvTrailDistance"  style="display:none">
						        <div class="form_fields clearfix">
							        <div class="form_label"><label>Trail Distance (km)</label></div>
							        <div class="form_input"><asp:TextBox id="tbTrailDistance" runat="server" MaxLength="4" CssClass="biz_name_field"></asp:TextBox></div>
						        </div>
					        </div>

                            <div id="dvTrailDuration"  style="display:none">
						        <div class="form_fields clearfix">
							        <div class="form_label"><label>Trail Duration (hr)</label></div>
							        <div class="form_input"><asp:TextBox id="tbTrailDuration" runat="server" MaxLength="4" CssClass="biz_name_field"></asp:TextBox></div>
						        </div>
					        </div>

                            <div id="dvExhibitType"  style="display:none">
						        <div class="form_fields clearfix">
							        <div class="form_label"><label>Exhibit type</label></div>
							        <div class="form_input">
                                        <asp:DropDownList ID="ddlExhibitType" runat="server">
                                            <asp:ListItem Value="">Please Select</asp:ListItem>         
                                            <asp:ListItem Value="1301">Artisan Studios</asp:ListItem>
                                            <asp:ListItem Value="1302">Shops & Galleries</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
						        </div>
					        </div>
                        </div>
                    </div>


                    <div id="dvListingRank">
						<h3>Listing Rank</h3>
                    
						<div class="fieldset clearfix">
							<div class="form_fields clearfix">
								<div id="dvPromotionPeriodList"></div>
								<asp:HiddenField id ="hdnPromotionPeriodId" runat="server" Value="" />

								<table id="tblPromotionPeriodForm" border="0" cellpadding="0" cellspacing="0"  >
									<tr>
										<td style="width:35%;">
											<div id="dvPromotionStartDate" class="form_fields clearfix">
												<div class="form_label"><label>Promotion Start Date</label></div>
												<div class="form_input"><asp:TextBox ID="tbPromotionStartDate" runat="server" CssClass="phone_field"></asp:TextBox></div>
											</div>
										</td>
										<td style="width:35%;">
											<div id="dvPromotionEndDate" class="form_fields clearfix">
												<div class="form_label"><label>Promotion End date</label></div>
												<div class="form_input"><asp:TextBox ID="tbPromotionEndDate" runat="server" CssClass="phone_field"></asp:TextBox></div>
											</div>
										</td>
										<td style="width:30%;">
											<div id="dvPromotionPeriodError" style="color:red;display:none;">Start and End Dates are required.<br/></div>
											<a id="lnkAddPromotionPeriod">Save Promotion Period</a> | <a id="lnkCancelPromotionPeriod">Cancel</a>
										</td>
									</tr>
								</table>
							</div>
							
							<div id="dvAccessCanada2" class="form_fields clearfix" >
								<div class="form_label"><label>Is Featured Listing</label> </div>
								<div class="form_input">
									<asp:CheckBox ID="cbIsFeaturedListing" runat="server"></asp:CheckBox>
								</div>
							</div>
					   
							<div id="dvCampingSelectRatings2" class="form_fields clearfix">
								<div class="form_label"><label>Listing Quality</label> </div>
								<div class="form_input">
									<asp:DropDownList ID="ddlListingQuality" runat="server">
										<asp:ListItem Value="">Please Select</asp:ListItem>
										<asp:ListItem Value="1">1</asp:ListItem>
										<asp:ListItem Value="2">2</asp:ListItem>
										<asp:ListItem Value="3">3</asp:ListItem>
										<asp:ListItem Value="4">4</asp:ListItem>
										<asp:ListItem Value="5">5</asp:ListItem>
										<asp:ListItem Value="6">6</asp:ListItem>
										<asp:ListItem Value="7">7</asp:ListItem>
										<asp:ListItem Value="8">8</asp:ListItem>
										<asp:ListItem Value="9">9</asp:ListItem>
										<asp:ListItem Value="10">10</asp:ListItem>
									</asp:DropDownList> 
								</div>
							</div>
						
						</div>
                    </div>


                    <div id="dvRatings"  style="display:none" >
                    <h3>Ratings</h3>
                    
                    <div class="fieldset clearfix">
                        <div class="form_left">
                            
                            <div id="dvAccessCanada" class="form_fields clearfix" style="display:none;">
                                <div class="form_label"><label>Access Canada Rating</label> <span class="pg_item">(PG)</span></div>
			                    <div class="form_input">
                                    <asp:DropDownList ID="ddlAccessCanadaRating" runat="server">
                                        <asp:ListItem Text="Please Select" Value=""></asp:ListItem>
                                        <asp:ListItem Text="A1" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="A2" Value="2"></asp:ListItem>
                                        <asp:ListItem Text="A3" Value="3"></asp:ListItem>
                                        <asp:ListItem Text="A4" Value="4"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
		                    </div>
                            <div id="dvCampgroundUnits" style="display:none" class="form_fields clearfix">
                                <div class="form_label"><label>Campground Units</label></div>
			                    <div class="form_input">
                                    <table cellpadding="0" cellspacing="0" border="0" class="select_options">
                                        <tr>
                                            <td class="form_label">Seasonal</td> 
                                            <td><asp:TextBox ID="tbUnits50" style="width:40px" runat="server" MaxLength="4" ></asp:TextBox></td>
                                        </tr>
                                        <tr>
                                            <td class="form_label">Short term</td> 
                                            <td><asp:TextBox ID="tbUnits51" style="width:40px" runat="server" MaxLength="4" ></asp:TextBox></td>
                                        </tr>
                                    </table>
                                </div>
		                    </div>
                            <div id="dvCanadaSelectRatings" style="display:none" class="clearfix">
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>Canada Select Ratings</label> <span class="pg_item">(PG)</span></div>
			                        <div class="form_input">
                                    <table cellpadding="0" cellspacing="0" border="0" class="select_options">
                                    <tr>
                                        <td class="form_label">Bed and breakfast</td> 
                                        <td><asp:DropDownList id="ddlRatingBedAndBreakfast" runat="server">
                                        <asp:ListItem Value="">Please Select</asp:ListItem>
                                        <asp:ListItem Value="2">1.0</asp:ListItem>
                                        <asp:ListItem Value="3">1.5</asp:ListItem>
                                        <asp:ListItem Value="4">2.0</asp:ListItem>
                                        <asp:ListItem Value="5">2.5</asp:ListItem>
                                        <asp:ListItem Value="6">3.0</asp:ListItem>
                                        <asp:ListItem Value="7">3.5</asp:ListItem>
                                        <asp:ListItem Value="8">4.0</asp:ListItem>
                                        <asp:ListItem Value="9">4.5</asp:ListItem>
                                        <asp:ListItem Value="10">5.0</asp:ListItem>
                                        </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Tourist home</td>
                                        <td><asp:DropDownList id="ddlRatingTouristHome" runat="server">
                                        <asp:ListItem Value="">Please Select</asp:ListItem>
                                        <asp:ListItem Value="2">1.0</asp:ListItem>
                                        <asp:ListItem Value="3">1.5</asp:ListItem>
                                        <asp:ListItem Value="4">2.0</asp:ListItem>
                                        <asp:ListItem Value="5">2.5</asp:ListItem>
                                        <asp:ListItem Value="6">3.0</asp:ListItem>
                                        <asp:ListItem Value="7">3.5</asp:ListItem>
                                        <asp:ListItem Value="8">4.0</asp:ListItem>
                                        <asp:ListItem Value="9">4.5</asp:ListItem>
                                        <asp:ListItem Value="10">5.0</asp:ListItem>
                                        </asp:DropDownList>
                                     </td>
                                    </tr>
                                    <tr>
                                        <td>B&B/Inn</td>
                                        <td><asp:DropDownList id="ddlRatingBedAndBreakfastInn" runat="server">
                                        <asp:ListItem Value="">Please Select</asp:ListItem>
                                        <asp:ListItem Value="2">1.0</asp:ListItem>
                                        <asp:ListItem Value="3">1.5</asp:ListItem>
                                        <asp:ListItem Value="4">2.0</asp:ListItem>
                                        <asp:ListItem Value="5">2.5</asp:ListItem>
                                        <asp:ListItem Value="6">3.0</asp:ListItem>
                                        <asp:ListItem Value="7">3.5</asp:ListItem>
                                        <asp:ListItem Value="8">4.0</asp:ListItem>
                                        <asp:ListItem Value="9">4.5</asp:ListItem>
                                        <asp:ListItem Value="10">5.0</asp:ListItem>
                                    </asp:DropDownList>
                                     </td>
                                    </tr>
                                    <tr>
                                        <td>Cottage/Apartment</td>
                                        <td><asp:DropDownList id="ddlRatingApartment" runat="server">
                                        <asp:ListItem Value="">Please Select</asp:ListItem>
                                        <asp:ListItem Value="2">1.0</asp:ListItem>
                                        <asp:ListItem Value="3">1.5</asp:ListItem>
                                        <asp:ListItem Value="4">2.0</asp:ListItem>
                                        <asp:ListItem Value="5">2.5</asp:ListItem>
                                        <asp:ListItem Value="6">3.0</asp:ListItem>
                                        <asp:ListItem Value="7">3.5</asp:ListItem>
                                        <asp:ListItem Value="8">4.0</asp:ListItem>
                                        <asp:ListItem Value="9">4.5</asp:ListItem>
                                        <asp:ListItem Value="10">5.0</asp:ListItem>
                                    </asp:DropDownList>
                                    </td>
                                    </tr>
                                    <tr>
                                        <td>Cottage/Vacation home</td>
                                        <td><asp:DropDownList id="ddlRatingCottage" runat="server">
                                        <asp:ListItem Value="">Please Select</asp:ListItem>
                                        <asp:ListItem Value="2">1.0</asp:ListItem>
                                        <asp:ListItem Value="3">1.5</asp:ListItem>
                                        <asp:ListItem Value="4">2.0</asp:ListItem>
                                        <asp:ListItem Value="5">2.5</asp:ListItem>
                                        <asp:ListItem Value="6">3.0</asp:ListItem>
                                        <asp:ListItem Value="7">3.5</asp:ListItem>
                                        <asp:ListItem Value="8">4.0</asp:ListItem>
                                        <asp:ListItem Value="9">4.5</asp:ListItem>
                                        <asp:ListItem Value="10">5.0</asp:ListItem>
                                    </asp:DropDownList>
                                    </td>
                                    </tr>
                                    <tr>
                                        <td>Hotel/Motel</td>
                                        <td><asp:DropDownList id="ddlRatingHotelMotel" runat="server">
                                        <asp:ListItem Value="">Please Select</asp:ListItem>
                                        <asp:ListItem Value="2">1.0</asp:ListItem>
                                        <asp:ListItem Value="3">1.5</asp:ListItem>
                                        <asp:ListItem Value="4">2.0</asp:ListItem>
                                        <asp:ListItem Value="5">2.5</asp:ListItem>
                                        <asp:ListItem Value="6">3.0</asp:ListItem>
                                        <asp:ListItem Value="7">3.5</asp:ListItem>
                                        <asp:ListItem Value="8">4.0</asp:ListItem>
                                        <asp:ListItem Value="9">4.5</asp:ListItem>
                                        <asp:ListItem Value="10">5.0</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    </tr>
                                    <tr>
                                        <td>Fishing & hunting</td>
                                        <td><asp:DropDownList id="ddlRatingFishing" runat="server">
                                        <asp:ListItem Value="">Please Select</asp:ListItem>
                                        <asp:ListItem Value="2">1.0</asp:ListItem>
                                        <asp:ListItem Value="3">1.5</asp:ListItem>
                                        <asp:ListItem Value="4">2.0</asp:ListItem>
                                        <asp:ListItem Value="5">2.5</asp:ListItem>
                                        <asp:ListItem Value="6">3.0</asp:ListItem>
                                        <asp:ListItem Value="7">3.5</asp:ListItem>
                                        <asp:ListItem Value="8">4.0</asp:ListItem>
                                        <asp:ListItem Value="9">4.5</asp:ListItem>
                                        <asp:ListItem Value="10">5.0</asp:ListItem>
                                    </asp:DropDownList>
                                    </td>
                                    </tr>
                                    <tr>
                                        <td>Inn</td>
                                        <td><asp:DropDownList id="ddlRatingInn" runat="server">
                                        <asp:ListItem Value="">Please Select</asp:ListItem>
                                        <asp:ListItem Value="2">1.0</asp:ListItem>
                                        <asp:ListItem Value="3">1.5</asp:ListItem>
                                        <asp:ListItem Value="4">2.0</asp:ListItem>
                                        <asp:ListItem Value="5">2.5</asp:ListItem>
                                        <asp:ListItem Value="6">3.0</asp:ListItem>
                                        <asp:ListItem Value="7">3.5</asp:ListItem>
                                        <asp:ListItem Value="8">4.0</asp:ListItem>
                                        <asp:ListItem Value="9">4.5</asp:ListItem>
                                        <asp:ListItem Value="10">5.0</asp:ListItem>
                                    </asp:DropDownList>
                                    </td>
                                    </tr>
                                    <tr>
                                        <td>Resort</td>
                                        <td><asp:DropDownList id="ddlRatingResort" runat="server">
                                        <asp:ListItem Value="">Please Select</asp:ListItem>
                                        <asp:ListItem Value="2">1.0</asp:ListItem>
                                        <asp:ListItem Value="3">1.5</asp:ListItem>
                                        <asp:ListItem Value="4">2.0</asp:ListItem>
                                        <asp:ListItem Value="5">2.5</asp:ListItem>
                                        <asp:ListItem Value="6">3.0</asp:ListItem>
                                        <asp:ListItem Value="7">3.5</asp:ListItem>
                                        <asp:ListItem Value="8">4.0</asp:ListItem>
                                        <asp:ListItem Value="9">4.5</asp:ListItem>
                                        <asp:ListItem Value="10">5.0</asp:ListItem>
                                    </asp:DropDownList>
                                    </td>
                                    </tr>
                                    <tr>
                                        <td>Suite</td>
                                        <td><asp:DropDownList id="ddlRatingSuite" runat="server">
                                        <asp:ListItem Value="">Please Select</asp:ListItem>
                                        <asp:ListItem Value="2">1.0</asp:ListItem>
                                        <asp:ListItem Value="3">1.5</asp:ListItem>
                                        <asp:ListItem Value="4">2.0</asp:ListItem>
                                        <asp:ListItem Value="5">2.5</asp:ListItem>
                                        <asp:ListItem Value="6">3.0</asp:ListItem>
                                        <asp:ListItem Value="7">3.5</asp:ListItem>
                                        <asp:ListItem Value="8">4.0</asp:ListItem>
                                        <asp:ListItem Value="9">4.5</asp:ListItem>
                                        <asp:ListItem Value="10">5.0</asp:ListItem>
                                    </asp:DropDownList>
                                    </td>
                                    </tr>
                                    <tr>
                                        <td>University</td>
                                        <td><asp:DropDownList id="ddlRatingUniversity" runat="server">
                                        <asp:ListItem Value="">Please Select</asp:ListItem>
                                        <asp:ListItem Value="2">1.0</asp:ListItem>
                                        <asp:ListItem Value="3">1.5</asp:ListItem>
                                        <asp:ListItem Value="4">2.0</asp:ListItem>
                                        <asp:ListItem Value="5">2.5</asp:ListItem>
                                        <asp:ListItem Value="6">3.0</asp:ListItem>
                                        <asp:ListItem Value="7">3.5</asp:ListItem>
                                        <asp:ListItem Value="8">4.0</asp:ListItem>
                                        <asp:ListItem Value="9">4.5</asp:ListItem>
                                        <asp:ListItem Value="10">5.0</asp:ListItem>
                                    </asp:DropDownList>
                                    </td>
                                    </tr>
                                    <tr>
                                        <td>Hostel</td>
                                        <td><asp:DropDownList id="ddlRatingHostel" runat="server">
                                        <asp:ListItem Value="">Please Select</asp:ListItem>
                                        <asp:ListItem Value="2">1.0</asp:ListItem>
                                        <asp:ListItem Value="3">1.5</asp:ListItem>
                                        <asp:ListItem Value="4">2.0</asp:ListItem>
                                        <asp:ListItem Value="5">2.5</asp:ListItem>
                                        <asp:ListItem Value="6">3.0</asp:ListItem>
                                        <asp:ListItem Value="7">3.5</asp:ListItem>
                                        <asp:ListItem Value="8">4.0</asp:ListItem>
                                        <asp:ListItem Value="9">4.5</asp:ListItem>
                                        <asp:ListItem Value="10">5.0</asp:ListItem>
                                    </asp:DropDownList>
                                    </td>
                                    </tr>
                                    </table>
                                    </div>
		                        </div>
                            </div>                    
                        </div>
                        <div class="form_right">
                            <div id="dvCampingSelectRatings" style="display:none" class="clearfix">
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>Camping Select Ratings</label> <span class="pg_item">(PG)</span></div>
			                        <div class="form_input">
                                        <table cellpadding="0" cellspacing="0" border="0" class="select_options">
                                        <tr>
                                            <td class="form_label">Facilities</td>
                                            <td><asp:DropDownList id="ddlRatingFacilities" runat="server">
                                            <asp:ListItem Value="">Please Select</asp:ListItem>
                                            <asp:ListItem Value="2">1.0</asp:ListItem>
                                            <asp:ListItem Value="3">1.5</asp:ListItem>
                                            <asp:ListItem Value="4">2.0</asp:ListItem>
                                            <asp:ListItem Value="5">2.5</asp:ListItem>
                                            <asp:ListItem Value="6">3.0</asp:ListItem>
                                            <asp:ListItem Value="7">3.5</asp:ListItem>
                                            <asp:ListItem Value="8">4.0</asp:ListItem>
                                            <asp:ListItem Value="9">4.5</asp:ListItem>
                                            <asp:ListItem Value="10">5.0</asp:ListItem>
                                        </asp:DropDownList>
                                        </td>
                                        </tr>
                                        <tr>
                                            <td>Recreation</td>
                                            <td><asp:DropDownList id="ddlRatingRecreation" runat="server">
                                            <asp:ListItem Value="">Please Select</asp:ListItem>
                                            <asp:ListItem Value="2">1.0</asp:ListItem>
                                            <asp:ListItem Value="3">1.5</asp:ListItem>
                                            <asp:ListItem Value="4">2.0</asp:ListItem>
                                            <asp:ListItem Value="5">2.5</asp:ListItem>
                                            <asp:ListItem Value="6">3.0</asp:ListItem>
                                            <asp:ListItem Value="7">3.5</asp:ListItem>
                                            <asp:ListItem Value="8">4.0</asp:ListItem>
                                            <asp:ListItem Value="9">4.5</asp:ListItem>
                                            <asp:ListItem Value="10">5.0</asp:ListItem>
                                        </asp:DropDownList>
                                        </td>
                                        </tr>
                                        </table>
                                    </div>
		                        </div>
                            </div>

                            <div id="dvCaaRatings" class="clearfix">
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>CAA Ratings</label></div>
			                        <div class="form_input">
                                        <table cellpadding="0" cellspacing="0" border="0" class="select_options">
                                            <tr>
                                                <td class="form_label">Class</td>
                                                <td><asp:DropDownList id="ddlCaaClass" runat="server"></asp:DropDownList><asp:Label ID="lblCampground" runat="server" style="display:none;">Campground</asp:Label></td>
                                             </tr>
                                             <tr>
                                                <td>Level</td>
                                                <td><asp:DropDownList id="ddlCaaLevel" runat="server">
                                                    <asp:ListItem Value="">Please Select</asp:ListItem>
                                                    <asp:ListItem Value="1">1</asp:ListItem>
                                                    <asp:ListItem Value="2">2</asp:ListItem>
                                                    <asp:ListItem Value="3">3</asp:ListItem>
                                                    <asp:ListItem Value="4">4</asp:ListItem>
                                                    <asp:ListItem Value="5">5</asp:ListItem>
                                                    </asp:DropDownList> <span class="pg_item">(PG)</span>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>   
                        
                            <div id="dvApprovedBy" style="display:none;" class="toggle_wrap clearfix">
                                <div class="feature_toggle section_toggle plus"><a>Approved by</a></div>
                                <div class="selectedList"></div>
                                <div class="section_body" style="display:none;">
                                    <div class="checkboxItem"><asp:CheckBox ID="cbAtt5_201" runat="server" Text="Canada Select" /></div>
                                    <div class="checkboxItem"><asp:CheckBox ID="cbAtt5_202" runat="server" Text="CAA" /></div>
                                    <div class="checkboxItem"><asp:CheckBox ID="cbAtt5_203" runat="server" Text="NS Approved" /> <span class="pg_item">(PG)</span></div>
                                </div>
                            </div>

                            <div id="dvShareInformationWith" style="display:none;" class="toggle_wrap clearfix">
                                <div class="feature_toggle section_toggle plus"><a>Share information with</a></div>
                                <div class="selectedList"></div>
                                <div class="section_body" style="display:none;">
                                    <div class="checkboxItem"><asp:CheckBox ID="cbAtt20_951" runat="server" Text="Canada Select" /></div>
                                    <div class="checkboxItem"><asp:CheckBox ID="cbAtt20_952" runat="server" Text="CAA" /></div>
                                    <div class="checkboxItem"><asp:CheckBox ID="cbAtt20_953" runat="server" Text="NS Approved" /></div>
                                
                                </div>
                            </div>
                                         
                        </div>
                    </div>
                    </div>
					
					


                    <h3>Features</h3>
                    <div class="fieldset clearfix">

                         <div id="dvAccessAdvisor" style="display:none;" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Access advisor</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt30_1451" runat="server" Text="Full mobile accessible" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt30_1452" runat="server" Text="Partially accessible" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt30_1453" runat="server" Text="Sight accessible" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt30_1454" runat="server" Text="Hearing accessible" /> <span class="pg_item">(PG)</span></div>
                            </div>
                        </div>

                        <div id="dvAccommodationAmenities" style="display:none;" class="toggle_wrap clearfix">
                         <div class="feature_toggle section_toggle plus"><a>Accommodation amenities</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt1_1" runat="server" Text="Air conditioning" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt1_22" runat="server" Text="Bathroom (Ensuite)" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt1_23" runat="server" Text="Bathroom (Private)" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt1_24" runat="server" Text="Bathroom (Shared)" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt1_2" runat="server" Text="Cable TV" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt1_3" runat="server" Text="Coffee maker" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt1_5" runat="server" Text="Data port" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt1_18" runat="server" Text="Dvd player" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt1_19" runat="server" Text="Fireplace" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt1_6" runat="server" Text="Hair dryer" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt1_16" runat="server" Text="Kitchen (H)" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt1_21" runat="server" Text="Kitchenette (H)" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt1_7" runat="server" Text="Microwave" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt1_8" runat="server" Text="Minifridge" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt1_9" runat="server" Text="Movies" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt1_17" runat="server" Text="Satellite TV" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt1_20" runat="server" Text="Telephone" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt1_11" runat="server" Text="Television" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt1_15" runat="server" Text="Video games" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt1_12" runat="server" Text="Wi-Fi" /></div> 
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt1_25" runat="server" Text="Wired Internet Access" /></div>
                                                                                          
                            </div>
                        </div>
                    
                        <div id="dvAccommodationService" style="display:none;" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Accommodation services</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                            
<!--                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt2_51" runat="server" Text="Breakfast Included" /></div> -->
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt2_52" runat="server" Text="Concierge" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt2_53" runat="server" Text="Fitness centre" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt2_57" runat="server" Text="Outfitters" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt2_55" runat="server" Text="Room service" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt2_56" runat="server" Text="Spa services" /></div>
                            
                            </div>
                        </div>
                   
                        <div id="dvAccommodationType" style="display:none;"  class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Accommodation types/Number of units</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
								<div class="checkboxItem">
                                    <asp:CheckBox ID="cbAtt3_101" runat="server" Text="Apartment" /> <span class="pg_item">(PG)</span>
                                    <div class="featureInput"><asp:TextBox ID="tbUnits1" runat="server" MaxLength="4" ></asp:TextBox>&nbsp;Units</div>
                                </div>
                                
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt3_102" runat="server" Text="Bed & breakfast" /> <span class="pg_item">(PG)</span> <div class="featureInput"><asp:TextBox ID="tbUnits2" runat="server" MaxLength="4" ></asp:TextBox>&nbsp;Units</div></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt3_103" runat="server" Text="Bed & breakfast inn" /> <span class="pg_item">(PG)</span> <div class="featureInput"><asp:TextBox ID="tbUnits3" runat="server" MaxLength="4" ></asp:TextBox>&nbsp;Units</div></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt3_104" runat="server" Text="Cabin" /> <span class="pg_item">(PG)</span> <div class="featureInput"><asp:TextBox ID="tbUnits4" runat="server" MaxLength="4" ></asp:TextBox>&nbsp;Units</div></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt3_105" runat="server" Text="Condo" /> <span class="pg_item">(PG)</span> <div class="featureInput"><asp:TextBox ID="tbUnits5" runat="server" MaxLength="4" ></asp:TextBox>&nbsp;Units</div></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt3_106" runat="server" Text="Cottage" /> <span class="pg_item">(PG)</span> <div class="featureInput"><asp:TextBox ID="tbUnits6" runat="server" MaxLength="4" ></asp:TextBox>&nbsp;Units</div></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt3_116" runat="server" Text="Dorm-style" /> <span class="pg_item">(PG)</span> <div class="featureInput"><asp:TextBox ID="tbUnits7" runat="server" MaxLength="4" ></asp:TextBox>&nbsp;Units</div></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt3_107" runat="server" Text="Guest room" /> <span class="pg_item">(PG)</span> <div class="featureInput"><asp:TextBox ID="tbUnits8" runat="server" MaxLength="4" ></asp:TextBox>&nbsp;Units</div></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt3_108" runat="server" Text="Hostel" /> <span class="pg_item">(PG)</span> <div class="featureInput"><asp:TextBox ID="tbUnits9" runat="server" MaxLength="4" ></asp:TextBox>&nbsp;Units</div></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt3_109" runat="server" Text="Hotel" /> <div class="featureInput"><asp:TextBox ID="tbUnits10" runat="server" MaxLength="4" ></asp:TextBox>&nbsp;Units</div></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt3_110" runat="server" Text="Inn" /> <span class="pg_item">(PG)</span> <div class="featureInput"><asp:TextBox ID="tbUnits11" runat="server" MaxLength="4" ></asp:TextBox>&nbsp;Units</div></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt3_111" runat="server" Text="Lodge" /> <span class="pg_item">(PG)</span> <div class="featureInput"><asp:TextBox ID="tbUnits12" runat="server" MaxLength="4" ></asp:TextBox>&nbsp;Units</div></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt3_112" runat="server" Text="Minihome" /> <span class="pg_item">(PG)</span> <div class="featureInput"><asp:TextBox ID="tbUnits13" runat="server" MaxLength="4" ></asp:TextBox>&nbsp;Units</div></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt3_113" runat="server" Text="Motel" /> <span class="pg_item">(PG)</span> <div class="featureInput"><asp:TextBox ID="tbUnits14" runat="server" MaxLength="4" ></asp:TextBox>&nbsp;Units</div></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt3_114" runat="server" Text="Resort" /> <span class="pg_item">(PG)</span> <div class="featureInput"><asp:TextBox ID="tbUnits15" runat="server" MaxLength="4" ></asp:TextBox>&nbsp;Units</div></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt3_115" runat="server" Text="Tourist home" /> <span class="pg_item">(PG)</span> <div class="featureInput"><asp:TextBox ID="tbUnits16" runat="server" MaxLength="4" ></asp:TextBox>&nbsp;Units</div></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt3_117" runat="server" Text="Vacation home" /> <span class="pg_item">(PG)</span> <div class="featureInput"><asp:TextBox ID="tbUnits17" runat="server" MaxLength="4" ></asp:TextBox>&nbsp;Units</div></div>
                            </div>
                        </div>
                    
                        <div id="dvAreaOfInterest" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Area of interest</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt6_251" runat="server" Text="Agriculture" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt6_271" runat="server" Text="Art & artisan" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt6_252" runat="server" Text="Aviation" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt6_253" runat="server" Text="Bay of Fundy" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt6_254" runat="server" Text="Community heritage" /></div>
<!--                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt6_255" runat="server" Text="Firefighting" /></div> -->
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt6_256" runat="server" Text="Fossils & rockhounding" /> <span id="pg_fossils" class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt6_269" runat="server" Text="Genealogy" /> <span id="pg_geneal" class="pg_item">(PG)</span></div>
<!--                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt6_257" runat="server" Text="Harvest celebration" /></div> -->
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt6_258" runat="server" Text="Immigration" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt6_259" runat="server" Text="Industrial" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt6_261" runat="server" Text="Marine" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt6_267" runat="server" Text="Military" /></div>
<!--                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt6_262" runat="server" Text="Mining" /></div> -->
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt6_263" runat="server" Text="Music" /></div>
<!--                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt6_264" runat="server" Text="Nature & wildlife" /></div> -->
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt6_270" runat="server" Text="Shopping" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt6_265" runat="server" Text="Sports" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt6_266" runat="server" Text="Trains" /></div> 
                            </div>
                        </div>

                        <div id="dvArtType" style="display:none;" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Art Product Type</a> (maximum of 2)</div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt7_301" runat="server" Text="Accessories" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt7_302" runat="server" Text="Bath & body products" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt7_303" runat="server" Text="Clothing" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt7_312" runat="server" Text="Crafts" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt7_310" runat="server" Text="Fine Art" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt7_313" runat="server" Text="Folk Art" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt7_311" runat="server" Text="Food" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt7_304" runat="server" Text="Furniture" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt7_305" runat="server" Text="Garden accessories" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt7_306" runat="server" Text="Home decor" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt7_307" runat="server" Text="Jewelry" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt7_308" runat="server" Text="Sculpture" /> <span class="pg_item">(PG)</span></div> 
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt7_309" runat="server" Text="Visual art" /> <span class="pg_item">(PG)</span></div>                           
                            </div>
                        </div>
                    
                        <div id="dvCampgroundAmenity" style="display:none;" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Campground amenity</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_363" runat="server" Text="Camp Cabins/Trailers" /></div>  
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_364" runat="server" Text="Cooking Shelter" /></div>  
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_356" runat="server" Text="Disposal station" /></div>  
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_357" runat="server" Text="Electrical hook-up" /></div>  
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_351" runat="server" Text="Flush toilets" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_362" runat="server" Text="Kitchen/Kitchenette (H)" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_365" runat="server" Text="Laundromat" /></div>   
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_366" runat="server" Text="Open Sites" /></div>   
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_358" runat="server" Text="Pit toilet" /></div>    
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_352" runat="server" Text="Playground" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_367" runat="server" Text="Propane" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_353" runat="server" Text="Pull-throughs" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_355" runat="server" Text="Rec Hall" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_359" runat="server" Text="Sewage hook-up" /></div>  
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_368" runat="server" Text="Shaded Sites" /></div>  
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_354" runat="server" Text="Showers (Free)" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_369" runat="server" Text="Showers (Pay)" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_370" runat="server" Text="Store" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_371" runat="server" Text="Swimming (Lake)" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_372" runat="server" Text="Swimming (Ocean)" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_373" runat="server" Text="Swimming (River)" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_360" runat="server" Text="Unserviced" /></div>  
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt8_361" runat="server" Text="Water hook-up" /></div>  
                            </div>
                        </div>

                        <div id="dvCellService" style="display:none;" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Cell Service</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt34_1651" runat="server" Text="Full" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt34_1652" runat="server" Text="Partial" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt34_1653" runat="server" Text="No Service" /></div>
                            </div>
                        </div>
                    
                        <div id="dvCoreExperience" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Core experience</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt9_401" runat="server" Text="Beaches & Seacoast" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt9_402" runat="server" Text="Cities & Towns" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt9_403" runat="server" Text="Food & Wine" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt9_404" runat="server" Text="History" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt9_405" runat="server" Text="Our culture" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt9_406" runat="server" Text="Outdoor adventure" /></div>
                            
                            </div>
                        </div>

                        <div id="dvCuisine" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Cuisine</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div id="dv23_1101" class="checkboxItem"><asp:CheckBox ID="cbAtt23_1101" runat="server" Text="Local" /></div>
                                <div id="dv23_1102" class="checkboxItem"><asp:CheckBox ID="cbAtt23_1102" runat="server" Text="Lobster & seafood" /></div>
                                <div id="dv23_1103" class="checkboxItem"><asp:CheckBox ID="cbAtt23_1103" runat="server" Text="Organic" /></div>
                            </div>
                        </div>
                    
                        <div id="dvCulturalHeritage" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Cultural heritage</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt10_451" runat="server" Text="Acadian" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt10_452" runat="server" Text="African Nova Scotian" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt10_453" runat="server" Text="Gaelic/Scottish" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt10_454" runat="server" Text="Mi'kmaq" /></div>
                            </div>
                        </div>

                        <div id="dvEatAndDrinkType" style="display:none" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Eat & Drink type</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt35_1700" runat="server" Text="Brew Pub" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt35_1701" runat="server" Text="Brewery" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt35_1702" runat="server" Text="Cidery" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt35_1703" runat="server" Text="Distillery" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt35_1704" runat="server" Text="Specialty Food" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt35_1705" runat="server" Text="Taste of NS Restaurant" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt35_1706" runat="server" Text="Winery" /></div>
                            </div>
                        </div>
                    
                        <div id="dvFeature" class="toggle_wrap clearfix">
							<div class="feature_toggle section_toggle plus"><a>Feature</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                  <!--              <div id="dv11_501" class="checkboxItem"><asp:CheckBox ID="cbAtt11_501" runat="server" Text="Beach" /></div> -->
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt11_517" runat="server" Text="Bilingual/Multilingual" /> </div>
                                <div id="dv11_502" class="checkboxItem"><asp:CheckBox ID="cbAtt11_502" runat="server" Text="Bus tours" /> <span id="pg_bus_tour" class="pg_item">(PG)</span></div>
                                <div id="dv11_524" class="checkboxItem"><asp:CheckBox ID="cbAtt11_524" runat="server" Text="Children's activities" /></div>
                  <!--              <div id="dv11_503" class="checkboxItem"><asp:CheckBox ID="cbAtt11_503" runat="server" Text="Environmentally friendly" /></div> -->
                  <!--              <div id="dv11_523" class="checkboxItem"><asp:CheckBox ID="cbAtt11_523" runat="server" Text="Equipment rentals" /></div> -->
                  <!--              <div id="dv11_504" class="checkboxItem"><asp:CheckBox ID="cbAtt11_504" runat="server" Text="Gardens" /></div> -->
                  <!--              <div id="dv11_518" class="checkboxItem"><asp:CheckBox ID="cbAtt11_518" runat="server" Text="Genealogical services" /></div> -->
                                <div id="dv11_505" class="checkboxItem"><asp:CheckBox ID="cbAtt11_505" runat="server" Text="Gift shop" /> <span id="pg_gift_shop" class="pg_item">(PG)</span></div>
                                <div id="dv11_519" class="checkboxItem"><asp:CheckBox ID="cbAtt11_519" runat="server" Text="Internet access" /> <span id="pg_internet" class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt11_516" runat="server" Text="Limited accessibility" /> <span id="pg_limited" class="pg_item">(PG)</span></div>
                 <!--               <div id="dv11_520" class="checkboxItem"><asp:CheckBox ID="cbAtt11_520" runat="server" Text="Live music" /></div> -->
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt11_506" runat="server" Text="Meeting facilities" /></div>
                                <div id="dv11_507" class="checkboxItem"><asp:CheckBox ID="cbAtt11_507" runat="server" Text="Ocean view" /></div>
                                <div id="dv11_508" class="checkboxItem"><asp:CheckBox ID="cbAtt11_508" runat="server" Text="Parking" /></div>
                                <div id="dv11_509" class="checkboxItem"><asp:CheckBox ID="cbAtt11_509" runat="server" Text="Picnic tables" /> <span id="pg_picnic" class="pg_item">(PG)</span></div>
                                <div id="dv11_525" class="checkboxItem"><asp:CheckBox ID="cbAtt11_525" runat="server" Text="Pool (Indoor)" /></div>
                                <div id="dv11_510" class="checkboxItem"><asp:CheckBox ID="cbAtt11_510" runat="server" Text="Pool (Outdoor)" /></div>
                                <div id="dv11_511" class="checkboxItem"><asp:CheckBox ID="cbAtt11_511" runat="server" Text="Public washroom" /></div>
                                <div id="dv11_512" class="checkboxItem"><asp:CheckBox ID="cbAtt11_512" runat="server" Text="Restaurant" /> <span id="pg_restaurant" class="pg_item">(PG)</span></div>
                                <div id="dv11_521" class="checkboxItem"><asp:CheckBox ID="cbAtt11_521" runat="server" Text="Smoking permitted" /> <span id="pg_smoking" class="pg_item">(PG)</span></div>
                                <div id="dv11_514"  class="checkboxItem"><asp:CheckBox ID="cbAtt11_514" runat="server" Text="Takeout" /> <span id="pg_takeout" class="pg_item">(PG)</span></div>
                                <div id="dv11_526"  class="checkboxItem"><asp:CheckBox ID="cbAtt11_526" runat="server" Text="Tasting Room" /> </div>
                               
                                <div id="dv11_513" class="checkboxItem"><asp:CheckBox ID="cbAtt11_513" runat="server" Text="Tea room" /> <span id="pg_tea_room" class="pg_item">(PG)</span></div>
                                <div id="dv11_522" style="display:none;" class="checkboxItem"><asp:CheckBox ID="cbAtt11_522" runat="server" Text="Travel agent commission" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt11_515" runat="server" Text="Wheelchair accessible" /> <span id="pg_wheelchair" class="pg_item">(PG)</span></div>                                
                            </div>
                        </div>
                    

                        <div id="dvGovernmentLevel" style="display:none" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Government level</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt12_551" runat="server" Text="National" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt12_552" runat="server" Text="Provincial" /> <span class="pg_item">(PG)</span></div>
                            
                            </div>
                        </div>
                    
                        <div id="dvMedium" style="display:none;" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Medium</a> (maximum of 2)</div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt14_651" runat="server" Text="Books & cards" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt14_665" runat="server" Text="Candles" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt14_652" runat="server" Text="Clay" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt14_654" runat="server" Text="Fibre" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt14_656" runat="server" Text="Glass" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt14_657" runat="server" Text="Leather" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt14_658" runat="server" Text="Metal" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt14_664" runat="server" Text="Multiple media" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt14_659" runat="server" Text="Painting & prints" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt14_660" runat="server" Text="Paper" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt14_662" runat="server" Text="Photography" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt14_661" runat="server" Text="Stone & bone" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt14_663" runat="server" Text="Wood" /> <span class="pg_item">(PG)</span></div>    
                            </div>
                        </div>
                    
                        <div id="dvMembership" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Membership</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div id="dv15_712" class="checkboxItem" ><asp:CheckBox ID="cbAtt15_712" runat="server" Text="Bienvenue" /> <span id="pg_bienvenue" class="pg_item">(PG)</span></div>
                                <div id="dv15_701" class="checkboxItem" style="display:none;"><asp:CheckBox ID="cbAtt15_701" runat="server" Text="IGNS" /> <span id="pg_IGNS" class="pg_item">(PG)</span></div>
                                <div id="dv15_702" class="checkboxItem" style="display:none;"><asp:CheckBox ID="cbAtt15_702" runat="server" Text="NSBBA" /> <span id="pg_NSBBA" class="pg_item">(PG)</span></div>
                                <div id="dv15_703" class="checkboxItem" ><asp:CheckBox ID="cbAtt15_703" runat="server" Text="TIANS" /> <span id="pg_TIANS" class="pg_item">(PG)</span></div>
                                <div id="dv15_704" class="checkboxItem" style="display:none;"><asp:CheckBox ID="cbAtt15_704" runat="server" Text="COANS" /> <span id="pg_COANS" class="pg_item">(PG)</span></div>
                                <div id="dv15_705" class="checkboxItem" style="display:none;"><asp:CheckBox ID="cbAtt15_705" runat="server" Text="HANS" /> <span id="pg_HANS" class="pg_item">(PG)</span></div>
<!--                                <div id="dv15_707" class="checkboxItem" style="display:none;"><asp:CheckBox ID="cbAtt15_707" runat="server" Text="NSATA" /> <span id="pg_NSATA" class="pg_item">(PG)</span></div>-->
                                <div id="dv15_708" class="checkboxItem" style="display:none;"><asp:CheckBox ID="cbAtt15_708" runat="server" Text="Golf NS" /> <span id="pg_golfNS" class="pg_item">(PG)</span></div>
                                <div id="dv15_709" class="checkboxItem" style="display:none;"><asp:CheckBox ID="cbAtt15_709" runat="server" Text="RANS" /> <span id="pg_RANS" class="pg_item">(PG)</span></div>
                                <div id="dv15_710" class="checkboxItem"><asp:CheckBox ID="cbAtt15_710" runat="server" Text="Taste of NS" /> <span id="pg_tasteNS" class="pg_item">(PG)</span></div>
                                <div id="dv15_711" class="checkboxItem"><asp:CheckBox ID="cbAtt15_711" runat="server" Text="Destination Hfx" /> <span id="pg_destinationHfx" style="display:none;" class="pg_item">(PG)</span> </div>
                                <div id="dv15_713" class="checkboxItem"><asp:CheckBox ID="cbAtt15_713" runat="server" Text="Good Cheer Trail" /> </div>
                                
                                <br clear="all" />
                                <div id="dvOtherMemberships" style="display:none; margin: 0 0 20px 10px">
                                    <div class="form_label"><label>Other memberships</label> <span id="pg_otherMem" class="pg_item">(PG)</span></div>
			                        <div class="form_input"><asp:TextBox ID="tbOtherMemberships" runat="server" MaxLength="30" CssClass="biz_name_field"></asp:TextBox></div>
                                </div>
                            </div>
                        </div>

                        <div id="dvActivity" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Outdoor activities</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_151" runat="server" Text="4-wheeling/ATVs" /> <span id="pg_atv" class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_172" runat="server" Text="Air adventure" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_152" runat="server" Text="Birding & wildlife" /> <span id="pg_birds" class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_153" runat="server" Text="Camping" /> <span id="pg_camp" class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_154" runat="server" Text="Canoeing" /> <span id="pg_canoe" class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_155" runat="server" Text="Cross country skiing" /> <span id="pg_cc_ski" class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_157" runat="server" Text="Cycling" /> <span id="pg_cycle" class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_158" runat="server" Text="Diving" /> <span id="pg_dive" class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_159" runat="server" Text="Dog sledding" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_160" runat="server" Text="Downhill skiing" /> <span id="pg_dh_ski" class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_162" runat="server" Text="Flying" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_179" runat="server" Text="Geocaching" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_163" runat="server" Text="Golf" /> <span id="pg_golf" class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_164" runat="server" Text="Hiking" /> <span id="pg_hiking" class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_165" runat="server" Text="Kayaking" /> <span id="pg_kayaking" class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_183" runat="server" Text="Kitesurfing" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_182" runat="server" Text="Mountain biking" /></div>
                               <!-- <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_166" runat="server" Text="Mini golf" /></div> -->
                                <!-- <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_180" runat="server" Text="Paragliding" /></div> -->
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_171" runat="server" Text="Photography & landscape painting" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_167" runat="server" Text="Riding/Hay rides" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_168" runat="server" Text="River rafting" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_169" runat="server" Text="Sailing" /> <span id="pg_sailing" class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_181" runat="server" Text="Sightseeing tour" /> <span id="pg_sight_see" class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_173" runat="server" Text="Sleigh ride" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_178" runat="server" Text="Snowmobiling" /> <span id="pg_snowmo" class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_174" runat="server" Text="Snowshoeing" /> <span id="pg_snowshoe" class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_184" runat="server" Text="Stand Up Paddleboarding" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_161" runat="server" Text="Sports fishing" /> <span id="pg_sport_fish" class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_175" runat="server" Text="Surfing" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_176" runat="server" Text="Whale watching" /> <span id="pg_whale" class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt4_177" runat="server" Text="Ziplining" /></div>
                            </div>
                        </div>
                    
                        <div id="dvPetsPolicy" style="display:none;" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Pets policy</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt16_753" runat="server" Text="Pets allowed" /> <span class="pg_item">(PG)</span></div>
								<div class="checkboxItem"><asp:CheckBox ID="cbAtt16_752" runat="server" Text="No pets" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt16_751" runat="server" Text="Pets live on premises" /> <span class="pg_item">(PG)</span></div>
                            </div>
                        </div>
                    
                        <div id="dvPrintOption" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Print options</a></div> 
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt17_801" runat="server" Text="Print GPS" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt17_802" runat="server" Text="Add English ad ref" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt17_803" runat="server" Text="Add French ad ref" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt17_804" runat="server" Text="Has English guide ad" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt17_805" runat="server" Text="Has French guide ad" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt17_806" runat="server" Text="Brochure available" /></div>   
                            </div>
                        </div>
                    
                         <div id="dvProductCategory" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Product category</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_851" runat="server" Text="Archive" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_864" runat="server" Text="Art gallery (non-profit)" /></div> 
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_852" runat="server" Text="Beach (supervised)" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_875" runat="server" Text="Beach (unsupervised)" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_853" runat="server" Text="Brewery/Distillery" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_854" runat="server" Text="Casino/Gaming" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_877" runat="server" Text="Collection (private)" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_876" runat="server" Text="Dive Shop" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_878" runat="server" Text="Driving range" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_855" runat="server" Text="Economuseum" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_881" runat="server" Text="Equipment rentals" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_885" runat="server" Text="Farmers' Market" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_856" runat="server" Text="Fun park" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_857" runat="server" Text="Garden" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_858" runat="server" Text="Golf course" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_859" runat="server" Text="History/Heritage site" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_860" runat="server" Text="Interpretive centre" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_861" runat="server" Text="Lighthouse" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_883" runat="server" Text="Marina/Yacht club" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_862" runat="server" Text="Memorial/Monument" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_863" runat="server" Text="Museum/Collection" /> <span id="pg_museum" class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_882" runat="server" Text="Novelty activity" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_865" runat="server" Text="Park" /> <span id="pg_park" class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_880" runat="server" Text="Sailing charter" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_884" runat="server" Text="Sailing instruction" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_867" runat="server" Text="Science centre" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_868" runat="server" Text="Specialty food shop" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_866" runat="server" Text="Stocked pond" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_869" runat="server" Text="Theatre venue" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_870" runat="server" Text="Trail" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_871" runat="server" Text="UNESCO site" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_872" runat="server" Text="Waterfall" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_873" runat="server" Text="Winery" /> <span id="pg_winery" class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt18_874" runat="server" Text="Zoo/Wildlife/Farm" /></div>
                            </div>
                        </div>
                    
                        <div id="dvRestaurantService" style="display:none;" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Restaurant services</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt19_901" runat="server" Text="Bus tours welcome" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt19_902" runat="server" Text="Childrens menu" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt19_903" runat="server" Text="Delivery" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt19_904" runat="server" Text="Dining room" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt19_905" runat="server" Text="Licensed" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt19_906" runat="server" Text="Live entertainment" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt19_907" runat="server" Text="Patio" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt19_908" runat="server" Text="Reservations recommended" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt19_909" runat="server" Text="Smoking area" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt19_910" runat="server" Text="Takeout" /> <span class="pg_item">(PG)</span></div>
                            </div>
                        </div>

                        <div id="dvRestaurantSpecialty" style="display:none;" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Restaurant specialty</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt26_1251" runat="server" Text="Acadian" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt26_1254" runat="server" Text="Asian" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt26_1253" runat="server" Text="Canadian" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt26_1268" runat="server" Text="Desserts" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt26_1255" runat="server" Text="European" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt26_1256" runat="server" Text="Fish and chips" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt26_1269" runat="server" Text="Gluten Free" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt26_1265" runat="server" Text="Indian" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt26_1266" runat="server" Text="Latin" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt26_1267" runat="server" Text="Middle Eastern" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt26_1260" runat="server" Text="Pizza/Burgers" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt26_1261" runat="server" Text="Sandwiches" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt26_1262" runat="server" Text="Seafood" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt26_1263" runat="server" Text="Steaks" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt26_1264" runat="server" Text="Vegetarian" /> <span class="pg_item">(PG)</span></div>
                            </div>
                        </div>

                        <div id="dvRestaurantType" style="display:none;" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Restaurant type</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt25_1200" runat="server" Text="Cafe/Tea Room" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt25_1201" runat="server" Text="Continental" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt25_1202" runat="server" Text="Family dining" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt25_1203" runat="server" Text="Fast food" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt25_1204" runat="server" Text="Fine dining" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt25_1205" runat="server" Text="Gourmet" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt25_1206" runat="server" Text="Informal" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt25_1207" runat="server" Text="Lounge" /> <span class="pg_item">(PG)</span></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt25_1208" runat="server" Text="Pub" /> <span class="pg_item">(PG)</span></div>
                            </div>
                        </div>

                        <div id="dvTourType" style="display:none;" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Tour types</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt24_1151" runat="server" Text="Boat tours & charters" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt24_1154" runat="server" Text="Multi-Activity adventure" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt24_1153" runat="server" Text="Multi-day tours" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt24_1155" runat="server" Text="Nature & wildlife" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt24_1156" runat="server" Text="Outdoor adventure" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt24_1152" runat="server" Text="Sightseeing & day tours" /></div>
<!--                            <div class="checkboxItem"><asp:CheckBox ID="cbAtt24_1157" runat="server" Text="Step-On" /></div>  -->
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt24_1158" runat="server" Text="Walking tours" /></div>
                            </div>
                        </div>

                        <div id="dvTrailPetsPolicy" style="display:none;" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Trail Pets Policy</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt32_1551" runat="server" Text="Off Leash" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt32_1552" runat="server" Text="Leashed" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt32_1553" runat="server" Text="Not Allowed" /></div>
                            </div>
                        </div>

                        <div id="dvTrailSurface" style="display:none;" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Trail Surface</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt33_1600" runat="server" Text="Hard" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt33_1601" runat="server" Text="Gravel" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt33_1602" runat="server" Text="Natural" /></div>
                            </div>
                        </div>

                        <div id="dvTrailType" style="display:none;" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Trail Type</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt31_1500" runat="server" Text="Day Use" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt31_1501" runat="server" Text="Linear" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt31_1502" runat="server" Text="Urban" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt31_1503" runat="server" Text="Wilderness" /></div>
                            </div>
                        </div>

                        <div id="dvTransportationType" style="display:none;" class="toggle_wrap clearfix">
                            <div class="feature_toggle section_toggle plus"><a>Transportation types</a></div>
                            <div class="selectedList"></div>
                            <div class="section_body" style="display:none;">
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt29_1401" runat="server" Text="Bus" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt29_1402" runat="server" Text="Car rental" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt29_1403" runat="server" Text="Ferry" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt29_1404" runat="server" Text="Major airport" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt29_1405" runat="server" Text="Provincial VIC" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt29_1406" runat="server" Text="Service airport" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt29_1407" runat="server" Text="Shuttle" /></div>
                                <div class="checkboxItem"><asp:CheckBox ID="cbAtt29_1408" runat="server" Text="Train" /></div>
                            </div>
                        </div>

                        

                        
                    </div>
                </asp:Panel>
                </div><!-- end fragment-4 -->


                <div id="fragment-5">
					<h3>Media Items</h3>
                    <asp:UpdatePanel ID="upMedia" runat="server">
                        <ContentTemplate>
                             <div id="dvMediaItems" class="fieldset clearfix" style="margin-bottom:2em;">
                                <div class="form_left">
                                    <div class="form_fields clearfix">
                                        <h4>Summary listing thumbnail</h4>
										<em id="add_slt">There is currently no summary listing thumbnail</em>
                                        <asp:ListView ID="lvSummaryImage" runat="server">
                                            <LayoutTemplate>
                                                <table cellpadding="0" cellspacing="0" border="0" class="tbl_sumthumb">
                                                    <div id="itemPlaceholder" runat="server" />
                                                </table>
                                            </LayoutTemplate>
                                            <ItemTemplate>
                                                <tr><td class="media_th"><img src='<%# Eval("mediaPath") %>' alt='<%# Eval("mediaOriginalFileName") %>' height="60" width="60" runat="server" /></td><td><%# Eval("mediaOriginalFileName") %></td><td style="text-align:right;"><asp:LinkButton ID="btnEditMedia" CausesValidation="false" CommandArgument='<%# Eval("mediaId") %>' runat="server" Text="Edit" OnClick="btnEditMedia_onClick" /> | <asp:LinkButton ID="btnDeleteMedia" CommandArgument='<%# Eval("mediaId") %>' OnClientClick='<%# "return ConfirmDelete(this, \"Are you sure you would like to delete the media " + Eval("mediaOriginalFileName") + "?\")" %>' runat="server" Text="Delete" OnClick="btnDeleteMedia_onClick" /></td></tr>
                                            </ItemTemplate>
                                        </asp:ListView>
                                    </div>
                                    <div class="form_fields clearfix">
                                        <h4>Document list</h4>
										<em id="add_doc">There are currently no documents in the list</em>
                                        <asp:ListView ID="lvDocuments" runat="server">
                                            <LayoutTemplate>
                                                <table cellpadding="0" cellspacing="0" border="0" class="tbl_docs">
                                                    <div id="itemPlaceholder" runat="server" />
                                                </table>
                                            </LayoutTemplate>
                                            <ItemTemplate>
                                                <tr><td><img src="../../Images/icon_file_generic.gif" alt='<%# Eval("mediaOriginalFileName") %>' border="0" /></td><td><a href='<%# Eval("mediaPath") %>' target="_blank" runat="server"><%# Eval("mediaOriginalFileName") %></a></td><td style="text-align:right;"><asp:LinkButton ID="btnEditMedia" CausesValidation="false" CommandArgument='<%# Eval("mediaId") %>' runat="server" Text="Edit" OnClick="btnEditMedia_onClick" /> | <asp:LinkButton ID="btnDeleteMedia" CommandArgument='<%# Eval("mediaId") %>' OnClientClick='<%# "return ConfirmDelete(this, \"Are you sure you would like to delete the media " + Eval("mediaOriginalFileName") + "?\")" %>' runat="server" Text="Delete" OnClick="btnDeleteMedia_onClick" /></td></tr>
                                            </ItemTemplate> 
                                        </asp:ListView>
                                    </div>
                                </div>
                                <div class="form_right">
                                   <div class="form_fields clearfix">
                                        <h4>Photo viewer</h4>
                                        <em id="add_pv">There are currently no photos in the viewer</em>
                                        <asp:ListView ID="lvPhoto" runat="server">
                                            <LayoutTemplate>
                                                <ol id="photoSortable">
                                                    <div id="itemPlaceholder" runat="server" />
                                                </ol>
                                            </LayoutTemplate>
                                            <ItemTemplate>
                                                <li id="<%# Eval("mediaId") %>" class="ui-state-default">
                                                    <table cellpadding="0" cellspacing="0" border="0" class="tbl_thumb">
                                                        <tr><td class="dragme"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span></td><td class="media_th"><img src='<%# Eval("mediaPath") %>' alt='<%# Eval("mediaOriginalFileName") %>' height="60" width="60" runat="server" /></td><td><%# Eval("mediaOriginalFileName") %></td><td style="text-align:right;"><asp:LinkButton ID="btnEditMedia" CausesValidation="false" CommandArgument='<%# Eval("mediaId") %>' runat="server" Text="Edit" OnClick="btnEditMedia_onClick" /> | <asp:LinkButton ID="btnDeleteMedia" CommandArgument='<%# Eval("mediaId") %>' OnClientClick='<%# "return ConfirmDelete(this, \"Are you sure you would like to delete the media " + Eval("mediaOriginalFileName") + "?\")" %>' runat="server" Text="Delete" OnClick="btnDeleteMedia_onClick" /></td></tr>
                                                    </table>
                                                </li>
                                            </ItemTemplate>
                                        </asp:ListView>

                                        <div class="update_btn_bar"><asp:Button ID="btnUpdateOrder" runat="server" OnClick="btnUpdateOrder_OnClick" Text="Update order" CausesValidation="false" CssClass="update_btn" /></div>
                                    </div>
                                </div>
                             </div>
                            
                            <div id="mediaToggle" class="section_toggle plus"><a id="lnkAddMedia">Add Media</a></div>
                            <div id="mediaForm" class="update_pnl section_body clearfix">
                                <asp:HiddenField ID="hdnPhotoOrder" runat="server" />
                                <asp:HiddenField ID="hdnMediaId" runat="server" />
                                <asp:UpdatePanel ID="upMediaType" runat="server">
                                    <ContentTemplate>
                                        <div class="form_fields clearfix">
			                                <div class="form_label"><label>Media type</label> <span class="required">&bull;</span></div>
			                                <div class="form_input"><asp:DropDownList ID="ddlMediaType" runat="server"></asp:DropDownList></div>
                                            <asp:RequiredFieldValidator ID="rfvMediaType" runat="server" ControlToValidate="ddlMediaType" 
                                                ErrorMessage="Media type is a required field." Display="Dynamic" ValidationGroup="vgMedia" />
		                                </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <div id="dvMediaLanguage" style="display:none" class="form_fields clearfix">
			                        <div class="form_label"><label>Language</label> <span class="required">&bull;</span></div>
			                        <div class="form_input"><asp:DropDownList ID="ddlMediaLanguage" runat="server"></asp:DropDownList></div>
                                    <asp:RequiredFieldValidator ID="rfvMediaLanguage" runat="server" ControlToValidate="ddlMediaLanguage" 
                                        ErrorMessage="Language is a required field." Display="Dynamic" ValidationGroup="vgMedia" />
		                        </div>
                                <asp:HiddenField ID="hdnTempFileName" runat="server" />
                                <asp:HiddenField ID="hdnOrigFileName" runat="server" />
                                <div id="dvMediaFile" class="form_fields clearfix">
			                        <div class="form_label"><label>Media file</label> <span class="required">&bull;</span></div>
			                        <div class="form_input">  <!-- JUSTIN -->
                                        <div id="dvFileUpload">
                                            <div id="dvFileInput" class="fileupload-buttonbar">
                                                <label >
                                                    <span></span>
                                                    <input id="jqFileUpload" type="file" name="files[]" />
                                                </label>
                                                <div id="divFile" class="form_formatlabel"></div>
                                            </div>
                                            <div id="dvFileError" style="color:red;display:none;">File is required.</div>
                                            <div class="fileupload-content">
                                                <table id="tblFileUploads" class="files"></table>
                                            </div>
                                            <div id="dvFileTypeError" style="color:red;display:none;">Invalid file type.</div>
                                        </div>
                                    </div>
                                    
		                        </div>

                                <div class="clearfix">
                                    <div class="form_left">
                                        <div class="languageGroup">
                                            <div class="form_fields clearfix">
			                                    <div class="form_label lang_en"><label>Title</label></div>
			                                    <div class="form_input"><asp:TextBox ID="tbMediaTitleEn" runat="server" MaxLength="50"></asp:TextBox></div>
		                                    </div>
                                            <div class="form_fields clearfix">
			                                    <div class="form_label lang_fr"><label>Title</label></div>
			                                    <div class="form_input"><asp:TextBox ID="tbMediaTitleFr" runat="server" MaxLength="50"></asp:TextBox></div>
		                                    </div>
                                            <div class="form_fields clearfix">
			                                    <div class="form_input"><asp:CheckBox ID="cbTransMarkMediaTitle" CssClass="translationMark" runat="server" Text="Translation required" /> </div>
		                                    </div>
                                        </div>
                                    </div>
                                    <div class="form_right">
                                        <div class="languageGroup">
                                            <div class="form_fields clearfix">
			                                    <div class="form_label lang_en"><label>Caption</label></div>
			                                    <div class="form_input"><asp:TextBox ID="tbMediaCaptionEn" runat="server" MaxLength="56"></asp:TextBox></div>
		                                    </div>
                                            <div class="form_fields clearfix">
			                                    <div class="form_label lang_fr"><label>Caption</label></div>
			                                    <div class="form_input"><asp:TextBox ID="tbMediaCaptionFr" runat="server" MaxLength="56"></asp:TextBox></div>
		                                    </div>
                                            <div class="form_fields clearfix">
			                                    <div class="form_input"><asp:CheckBox ID="cbTransMarkMediaCaption" CssClass="translationMark" runat="server" Text="Translation required" /> </div>
		                                    </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="update_btn_bar">
                                    <asp:Button ID="btnMediaSubmit" runat="server" Text="Save Media" OnClick="btnMediaSubmit_onClick" CssClass="update_btn" ValidationGroup="vgMedia" /> | <asp:LinkButton id="lbMediaCancel" runat="server" OnClick="lbMediaCancel_onClick" Text="Cancel" CausesValidation="false" ></asp:LinkButton>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div><!-- end fragment-5 -->

                <div id="fragment-6">
					<h3>Links</h3>
                    <asp:UpdatePanel ID="upLink" runat="server">
                        <ContentTemplate>
							<div class="fieldset clearfix">
								<table border="0" cellpadding="0" cellspacing="0" class="tbl_data">
									<asp:Repeater ID="rptLink" runat="server">
										<HeaderTemplate>
											<tr class="tbl_header">
												<td style="width:20%;"><strong>Title</strong></td>
												<td style="width:20%;"><strong>Type</strong></td>
												<td style="width:45%;"><strong>Link</strong></td>
												<td style="width:15%;"><strong>Actions</strong></td>
											</tr>
										</HeaderTemplate>
										<ItemTemplate>
											<tr>
												<td><%# Eval("linkName") %></td>
												<td><%# Eval("linkType") %></td>
												<td><a id="lnkProductLink" href='<%# Eval("linkUrl") %>'><%# Eval("linkUrl") %></a></td>
												<td><asp:LinkButton ID="btnEditLink" CommandArgument='<%# Eval("linkId") %>' runat="server" Text="Edit" CausesValidation="false" OnClick="btnEditLink_onClick" /> | <asp:LinkButton ID="btnDeleteLink" CommandArgument='<%# Eval("linkId") %>' OnClientClick='<%# "return ConfirmDelete(this, \"Are you sure you would like to delete the link " + Eval("linkName") + "?\")" %>' runat="server" Text="Delete" CausesValidation="false" OnClick="btnDeleteLink_onClick" /></td>
											</tr>
										</ItemTemplate>
									</asp:Repeater>
								</table>
							</div>

                            <div id="linkToggle" class="section_toggle plus"><a id="lnkAddLink">Add Link</a></div>
                            <div id="linkForm" class="update_pnl section_body clearfix">
                                <asp:HiddenField ID="hdnLinkId" runat="server" />
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>Link type</label> <span class="required">&bull;</span></div>
			                        <div class="form_input"><asp:DropDownList ID="ddlLinkType" runat="server"></asp:DropDownList></div>
                                    <asp:RequiredFieldValidator ID="rfvLinkType" runat="server" ControlToValidate="ddlLinkType" 
                                        ErrorMessage="Link type is a required field." Display="Dynamic" ValidationGroup="vgLink" />
		                        </div>
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>Link URL</label> <span class="required">&bull;</span></div>
			                        <div class="form_input"><asp:TextBox ID="tbLinkUrl" runat="server" MaxLength="250"></asp:TextBox><a id="lnkCheckLinkUrl">Check URL</a></div>
                                    <asp:RequiredFieldValidator ID="rfvLinkUrl" runat="server" ControlToValidate="tbLinkUrl" 
                                        ErrorMessage="Link URL is a required field." Display="Dynamic" ValidationGroup="vgLink" />
		                        </div>
                                <div id="dvLinkDistance" style="display:none;" class="form_fields clearfix">
			                        <div class="form_label"><label>Distance (km)</label></div>
			                        <div class="form_input"><asp:TextBox ID="tbLinkDistance" runat="server" MaxLength="6"></asp:TextBox></div>
                                    <asp:RequiredFieldValidator ID="rfvLinkDistance" runat="server" ControlToValidate="tbLinkDistance" 
                                        ErrorMessage="Distance is a required field." Display="Dynamic" ValidationGroup="vgLink" Enabled="false" />
		                        </div>
                                
                                <div class="clearfix">
                                    <div class="form_left">
                                        <div class="languageGroup">
                                            <div class="form_fields clearfix">
			                                    <div class="form_label lang_en"><label>Link title</label> <span class="required">&bull;</span></div>
			                                    <div class="form_input"><asp:TextBox ID="tbLinkTitleEn" runat="server" MaxLength="250"></asp:TextBox></div>
                                                <asp:RequiredFieldValidator ID="rfvLinkTitleEn" runat="server" ControlToValidate="tbLinkTitleEn" 
                                                    ErrorMessage="Link title is a required field." Display="Dynamic" ValidationGroup="vgLink" />
		                                    </div>
                                            <div class="form_fields clearfix">
			                                    <div class="form_label lang_fr"><label>Link title</label></div>
			                                    <div class="form_input"><asp:TextBox ID="tbLinkTitleFr" runat="server" MaxLength="250"></asp:TextBox></div>
		                                    </div>
                                            <div class="form_fields clearfix">
			                                    <div class="form_input"><asp:CheckBox ID="cbTransMarkLinkTitle" CssClass="translationMark" runat="server" Text="Translation required" /> </div>
		                                    </div>
                                        </div>
                                        
                                    </div>
                                    <div class="form_right">
                                        <div class="languageGroup">
                                            <div class="form_fields clearfix">
			                                    <div class="form_label lang_en"><label>Link description</label> <span class="required">&bull;</span></div>
			                                    <div class="form_input"><asp:TextBox ID="tbLinkDescriptionEn" runat="server" MaxLength="500"></asp:TextBox></div>
                                                <asp:RequiredFieldValidator ID="rfvLinkDescriptionEn" runat="server" ControlToValidate="tbLinkDescriptionEn" 
                                                    ErrorMessage="Link description is a required field." Display="Dynamic" ValidationGroup="vgLink" />
		                                    </div>
                                            <div class="form_fields clearfix">
			                                    <div class="form_label lang_fr"><label>Link description</label></div>
			                                    <div class="form_input"><asp:TextBox ID="tbLinkDescriptionFr" runat="server" MaxLength="500"></asp:TextBox></div>
		                                    </div>
                                            <div class="form_fields clearfix">
			                                    <div class="form_input"><asp:CheckBox ID="cbTransMarkLinkDesc" CssClass="translationMark" runat="server" Text="Translation required" /> </div>
		                                    </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="update_btn_bar">
                                    <asp:Button ID="btnLinkSubmit" runat="server" Text="Save Link" OnClick="btnLinkSubmit_onClick" CssClass="update_btn" ValidationGroup="vgLink" /> | <a id="lnkCancelLink" href="#">Cancel</a>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div><!-- end fragment-6 -->


                <div id="fragment-7">
					<h3>Contacts</h3>
                    <asp:UpdatePanel ID="upContact" runat="server">
                        <ContentTemplate>
							<div class="fieldset clearfix">
								<table border="0" cellpadding="0" cellspacing="0" class="tbl_data">
									<tr class="tbl_header">
										<td style="width:5%;"><strong>Primary</strong></td>
										<td style="width:20%;"><strong>Name</strong></td>
                                        <td style="width:8%;"><strong>Type</strong></td>
										<td style="width:10%;"><strong>Title</strong></td>
										<td style="width:20%;"><strong>Email</strong></td>
										<td style="width:35%;"><strong>Business</strong></td>
                                        <td style="width:5%;"><strong>Action</strong></td>
									</tr>
									<asp:Repeater ID="rptContact" runat="server">
										<ItemTemplate>
											<tr>
												<td style="text-align:center;"><asp:RadioButton ID='rbPrimaryContact' Value='<%# Eval("contactId") %>' Checked='<%# (Eval("contactTypeId").ToString() == "1") %>' runat="server" /></td>
												<td><a href='../Contact/Edit.aspx?id=<%# Eval("contactId") %>'><%# Eval("contactName") %></a></td>
                                                <td><%# Eval("businessContactType")%></td>
												<td><%# Eval("jobTitle") %></td>
												<td><a href='mailto:<%# Eval("email") %>'><%# Eval("email") %></a></td>
												<td><a href='../Business/Edit.aspx?id=<%# Eval("businessId") %>'><%# Eval("businessName") %></a></td>
                                                <td><asp:LinkButton ID="btnRemoveContact" CommandArgument='<%# Eval("contactId") %>' runat="server" Enabled='<%# (Eval("contactTypeId").ToString() != "1") %>' Text="Remove" CausesValidation="false" OnClick="btnRemoveContact_onClick" /> </td>
											</tr>
										</ItemTemplate>
									</asp:Repeater>
								</table>
							</div>
                            <div id="contactToggle" class="section_toggle plus"><a id="lnkAddContact">Add Contact</a></div>
                            <div id="contactForm" class="update_pnl section_body clearfix">
                                <asp:HiddenField ID="hdnPrimaryContactId" runat="server" />
                                <asp:HiddenField ID="hdnBusinessId" runat="server" />
                                <asp:AutoCompleteExtender ID="aceParentBusiness" runat="server" ServicePath="~/WebServices/Services.asmx" ServiceMethod="GetBusinessNameList"
                                    MinimumPrefixLength="3" TargetControlID="tbBusinessName" CompletionSetCount="10">
                                </asp:AutoCompleteExtender>
                                <div class="form_fields clearfix">
                                    <div class="form_label">
                                        <label>
                                            Business name</label> <span class="required">&bull;</span></div>
                                    <div class="form_input clearfix">
                                        <asp:TextBox CssClass="floatLeft biz_name_field" ID="tbBusinessName" AutoComplete="Off" AutoPostBack="false" runat="server"></asp:TextBox>
                                         <asp:LinkButton
                                            ID="lbRefreshContactDropDown" runat="server" CausesValidation="false" OnClick="lbRefreshContactDropDown_OnClick"><span class="floatLeft ui-icon ui-icon-arrowrefresh-1-w"></span>Refresh contact names</asp:LinkButton>
                                            </div>
                                            <div class="form_formatlabel">(start typing to auto-populate)</div>
                                    <asp:RequiredFieldValidator ID="rfvContactsBusinessName" runat="server" ControlToValidate="tbBusinessName" 
                                        ErrorMessage="Business name is a required field." Display="Dynamic" ValidationGroup="vgContact" />
                                        <asp:CustomValidator ID="cvBusinessName" runat="server" ControlToValidate="tbBusinessName"
                        ErrorMessage="The business does not exist." Display="Dynamic" 
                        onservervalidate="cvBusinessName_ServerValidate" />
                                </div>
                                <div class="form_fields clearfix">
                                    <div class="form_label">
                                        <label>Contact name</label> <span class="required">&bull;</span></div>
                                    <div id="dvContactSelect" class="form_input">
                                        <asp:DropDownList ID="ddlContact" runat="server">
                                        </asp:DropDownList>
                                    </div>
                                    <div id="dvEmptyContact" runat="server" class="form_label"><em>Enter a full or partial business name in the text field above</em></div>
                                    <div id="dvNoContacts" class="form_label" runat="server" visible="false">The selected business has no unassigned contacts</div>
                                    <asp:RequiredFieldValidator ID="rfvContactsContact" runat="server" ControlToValidate="ddlContact" 
                                        ErrorMessage="Contact is a required field." Display="Dynamic" ValidationGroup="vgContact" />
                                </div>
                                <div class="clearboth"></div>
                                <div class="update_btn_bar">
                                    <asp:Button ID="btnContactSubmit" runat="server" Text="Save Contact"
                                        OnClick="btnContactSubmit_onClick" CssClass="update_btn" ValidationGroup="vgContact" />
                                    | <a id="lnkCancelContact" href="#">Cancel</a>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div><!-- end fragment-7 -->


                <div id="fragment-8">
					<h3>Editor</h3>
                    <asp:HiddenField ID="hdnIsValid" runat="server" />
                    <div class="fieldset clearfix">
                        <div class="form_left">
                            <div class="form_fields clearfix">
		                        <div class="form_label"><label>Product status</label></div>
                                <div class="form_input">
                                    <asp:CheckBox ID="cbIsActive" runat="server" Text="Active" />
                                </div>
                            </div>
                            <div class="form_fields clearfix">
		                        <div class="form_label"><label>Completion status</label></div>
                                <div class="form_input">
                                    <asp:CheckBox ID="cbIsComplete" runat="server" Text="Complete" />
                                </div>
                            </div>
                            <div id="dvConfirmationDueDate" class="form_fields clearfix">
                                <div class="form_label"><label>Confirmation form due date</label></div>
			                    <div class="form_input"><asp:TextBox ID="tbConfirmationDueDate" runat="server" CssClass="phone_field"></asp:TextBox></div>
                            </div>
                            <div id="dvConfirmationLastReceived" class="form_fields clearfix">
                                <div class="form_label"><label>Confirmation form last received</label></div>
			                    <div class="form_input"><asp:TextBox ID="tbConfirmationLastReceived" runat="server" CssClass="phone_field"></asp:TextBox></div>
                            </div>
                            <div class="form_fields clearfix">
								<div class="form_label"><label>Edit checks</label></div>
								<div class="form_input">
									<asp:Panel ID="pnlEditorAttributes" runat="server">
										<table border="0" cellpadding="0" cellspacing="0" class="cbTable">
											<tr>
												<td><asp:CheckBox ID="cbAtt22_1051" runat="server" Text="Renewal form out" /></td>
												<td><asp:CheckBox ID="cbAtt22_1056" runat="server" Text="Fax proof" /></td>
											</tr>
											<tr>
                                                <td><asp:CheckBox ID="cbAtt22_1052" runat="server" Text="Updates entered" /></td>
												<td><asp:CheckBox ID="cbAtt22_1057" runat="server" Text="Email proof" /></td>
											</tr>
											<tr>
                                                <td><asp:CheckBox ID="cbAtt22_1053" runat="server" Text="Queries to check" /></td>
												<td><asp:CheckBox ID="cbAtt22_1058" runat="server" Text="Proof sent" /></td>
											</tr>
											<tr>
                                                <td><asp:CheckBox ID="cbAtt22_1054" runat="server" Text="Checking with QA" /></td>
												<td><asp:CheckBox ID="cbAtt22_1059" runat="server" Text="Proof signed" /></td>
											</tr>
											<tr>
                                                <td><asp:CheckBox ID="cbAtt22_1055" runat="server" Text="Entry completed" /></td>
												<td><asp:CheckBox ID="cbAtt22_1062" runat="server" Text="Ready for print" /></td>
											</tr>
											<tr>
												<td><asp:CheckBox ID="cbAtt22_1061" runat="server" /><asp:TextBox ID="tbCheckboxLabel" runat="server" style="width:120px;"></asp:TextBox></td>
												<td><asp:CheckBox ID="cbAtt22_1060" runat="server" Text="Translation proofed" /></td>
											</tr>
                                            <tr>
                                                <td><asp:CheckBox ID="cbAtt22_1063" runat="server" Text="Listing not published by operator's request" /></td>
												<td><asp:CheckBox ID="cbAtt22_1064" runat="server" Text="Enhanced Listing" /></td>
											</tr>
										</table>
									</asp:Panel>
								</div>
	                        </div>
                            <div id="dvPaymentReceived" class="form_fields clearfix">
                                <div class="form_input">
									<asp:CheckBox ID="cbPaymentReceived" runat="server" Text="Payment received" />
									<br />&nbsp;&nbsp;&nbsp;&nbsp;$<asp:TextBox ID="tbPaymentAmount" runat="server" CssClass="money_field"></asp:TextBox>
								</div>
                            </div>
                            <div class="form_fields clearfix">
                                <div class="form_label"><label>Previous year's attendance</label></div>
                                <div class="form_input">
                                    <asp:TextBox ID="tbAttendance" runat="server" MaxLength="50" ></asp:TextBox>
                                </div>
                            </div>
	                    </div>
                    
                       
                        <div class="form_right">
                            <div class="form_fields clearfix">
		                        <div class="form_label"><label>Validation Status</label></div>
			                    <div class="form_input">
                                    <div id="dvValStatValid">Valid</div>
                                    <div id="dvValStatInvalid">Invalid</div>
                                </div>
	                        </div>
							<div class="form_fields clearfix">
								<div class="form_input"><asp:CheckBox ID="cbOverrideErrors" runat="server" Text="Override errors" /></div>
							</div>
                            <div id="dvValidationErrors" class="form_fields clearfix">
		                        <div class="form_label"><label>Validation Errors</label></div>
			                    <div class="form_input">
                                    <ul class="bulletList">
                                        <li id="dvValErrCity" class="validation_error">City/Community is required</li>
                                        <li id="dvValErrRegion" class="validation_error">At least 1 Region must be assigned</li>
                                        <li id="dvValErrUnitDescription" class="validation_error">Missing English unit description</li>
                                        <li id="dvValErrPrintDescription" class="validation_error">Missing English property description (print version)</li>
                                        <li id="dvValErrWebDescription" class="validation_error">Missing English property description (web version)</li>
                                        <li id="dvValErrPrintDates" class="validation_error">Incomplete print dates</li>
                                        <li id="dvValErrWebDates" class="validation_error">Incomplete web dates</li>
                                        <li id="dvValErrPrintRates" class="validation_error">Incomplete print rates</li>
                                        <li id="dvValErrWebRates" class="validation_error">Incomplete web rates</li>
                                        <li id="dvValErrApproval" class="validation_error">No program approval</li>
                                        <li id="dvValErrPrintGuide" class="validation_error">No print guide section assigned</li>
                                        <li id="dvValErrConfirmationLastReceived" class="validation_error">An update has not been received from the operator for three years</li>
                                    </ul>
                                </div>
	                        </div>
                            <div id="dvValidationWarnings" class="ui-corner-all form_fields clearfix">
		                        <div class="form_label"><label>Validation Warnings</label></div>
			                    <div class="form_input">
                                    <ul class="bulletList">
                                        <li id="dvValWarTelephone" class="validation_error">Both the Telephone and Toll-free fields are missing; at least one of these fields should have a value</li>
                                        <li id="dvValWarPrintDescriptionFrench" class="validation_warning">Missing French property description (print version)</li>
                                        <li id="dvValWarWebDescriptionFrench" class="validation_warning">Missing French property description (web version)</li>
                                    </ul>
                                </div>
	                        </div>
                        </div>
                    </div>
                </div><!-- end fragment-8 -->
               
                
                 <div id="fragment-10">
					<h3>Operational Open and Close Dates</h3>
                    <asp:UpdatePanel ID="upOperationalDates" runat="server">
                        <ContentTemplate>
							<div class="fieldset clearfix">
								<table border="0" cellpadding="0" cellspacing="0" class="tbl_data">
									<asp:Repeater ID="rptOperationalPeriods" runat="server">
										<HeaderTemplate>
											<tr id="tblOperationalPeriods" class="tbl_header">
												<td style="width:20%;"><strong>Open Date</strong></td>
												<td style="width:20%;"><strong>Close Date</strong></td>
												<td style="width:15%;"><strong>Actions</strong></td>
											</tr>
										</HeaderTemplate>
										<ItemTemplate>
											<tr class="operationalPeriodDataRow">
                                                <asp:HiddenField ID="hdnOpenDate" runat="server" Value='<%# DataBinder.Eval(Container.DataItem,"openDate","{0:dd-MM-yyyy}") %>'/>
                                                <asp:HiddenField ID="hdnCloseDate" runat="server" Value='<%# DataBinder.Eval(Container.DataItem,"closeDate","{0:dd-MM-yyyy}") %>' />
                                                <asp:HiddenField ID="hdnRowId" runat="server" Value='<%# Eval("id") %>' />
												<td><%# DataBinder.Eval(Container.DataItem,"openDate","{0:MMM d, yyyy}") %></td>
												<td><%# DataBinder.Eval(Container.DataItem,"closeDate","{0:MMM d, yyyy}") %></td>
												<td><asp:LinkButton ID="btnEditOperationalPeriod" CommandArgument='<%# Eval("id") %>' runat="server" Text="Edit" CausesValidation="false" OnClick="btnEditOperationalPeriod_onClick" /> | <asp:LinkButton ID="btnDeleteOperationalPeriod" CommandArgument='<%# Eval("id") %>' OnClientClick='<%# "return ConfirmDelete(this, \"Are you sure you would like to delete the selected period?\")" %>' runat="server" Text="Delete" CausesValidation="false" OnClick="btnDeleteOperationalPeriod_onClick" /></td>
											</tr>
										</ItemTemplate>
									</asp:Repeater>
								</table>
							</div>

                            <div id="dvOperationalPeriodToggle" class="section_toggle plus"><a id="lnkAddOperationalPeriod">Add Open & Close Date Range</a></div>
                            <div id="dvOperationalPeriodForm" class="update_pnl section_body clearfix">
                                <asp:HiddenField ID="hdnOperationalPeriodId" runat="server" />
                                <div id="dvErrorConflict" style="display:none;">
			                        <span style="color:red;">The operational date period conflicts with a pre-existing period.</span>
                                    <br /><br />
		                        </div>
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>Open date</label> <span class="required">&bull;</span></div>
			                        <div class="form_input">
                                        <asp:TextBox id="tbOperationalOpenDate" runat="server" CssClass="phone_field"></asp:TextBox>
                                        <div id="dvErrorOpenDateRequired" style="display:none;">
			                                <span style="color:red;">Open date is a required field.</span>
		                                </div>
                                    </div>
                                    
		                        </div>
                                
                                
                                <div class="form_fields clearfix">
			                        <div class="form_label"><label>Close date</label> </div>
			                        <div class="form_input"><asp:TextBox id="tbOperationalCloseDate" runat="server" CssClass="phone_field"></asp:TextBox><br /><span class="hint">(leave blank for presently open)</span></div>
		                        </div>
                                
                                <div class="update_btn_bar">
                                    <asp:Button ID="btnOperationalPeriodSubmit" runat="server" Text="Save Operational Range" OnClick="btnOperationalPeriodSubmit_onClick" CssClass="update_btn" /> | <a id="lnkCancelOperationalPeriod" href="#">Cancel</a>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div><!-- end fragment-10 -->


            </div><!-- end tabs -->

		</div><!-- end forms -->

        <div class="submit_btn_bar">
            <asp:Button ID="btnSubmit" runat="server" Text="SAVE" OnClick="btnSubmit_onClick" OnClientClick="validate();" CssClass="submit_btn" /> | <asp:LinkButton ID="lbDeleteProduct" runat="server" CausesValidation="false" OnClientClick="return ConfirmProductDelete()" OnClick="lbDeleteProduct_onClick">Delete</asp:LinkButton>
        </div>

        <div id="accordion" class="clearfix">
                <div id="dvPrintPreview" class="ui-corner-all accordion_item">
                    <h4 class="clearfix"><span class="ui-icon ui-icon-triangle-1-e"></span><a href="#">Print Preview</a></h4>
                    <div class="cnt clearfix">
                        <div id="divPrintPreview3"><asp:Literal id="litPrintPreview" runat="server"></asp:Literal></div>
                    </div>
                </div>
                <asp:UpdatePanel ID="upNote" runat="server">
                            <ContentTemplate>
                <div id="dvNotes" class="ui-corner-all accordion_item">
                    <h4 class="clearfix"><span class="ui-icon ui-icon-triangle-1-e"></span><a href="#">Notes</a>&nbsp;<asp:Literal ID="litNoteCount" runat="server"></asp:Literal>&nbsp;&nbsp; <a id="lnkViewFileMakerCommentArchive" style="text-decoration:none; color:#0da1d1;font-size:12px;" runat="server">View Filemaker Comments</a></h4>
                    <div class="cnt clearfix">
                         
                                <table border="0" cellpadding="0" cellspacing="0" class="tbl_data_notes">
                                    <asp:Repeater ID="rptNote" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td style="padding:1.25em 0;">
                                                    <p style="margin-bottom:0.5em;"><strong><%# Eval("lastModifiedBy") %></strong> on <em><%#String.Format("{0:g}", Eval("creationDate"))%></em> | <asp:LinkButton ID="lbDeleteNote" runat="server" CommandArgument='<%# Eval("id") %>' Text="Delete" OnClick="btnDeleteNote_onClick" ></asp:LinkButton></p>
                                                    <%# Eval("noteBody") %>
                                                    <div id="reminderDateSection" style="margin-top:1.25em;">
                                                        <em>Email reminder date:</em> 
                                                        <span id="reminderDateValue" style="font-weight:bold;"><%#String.Format("{0:d}", Eval("reminderDate"))%></span> | 
                                                        <span id="reminderDateCancel"><asp:LinkButton ID="lbCancelReminder" runat="server" CommandArgument='<%# Eval("id") %>' Text="Cancel Reminder" OnClick="btnCancelReminder_onClick" ></asp:LinkButton></span>
                                                    </div> 
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </table>
            
                                <div id="noteToggle" class="section_toggle plus"><a id="lnkAddNote">Add Note</a></div>
                                <div id="noteForm" class="update_pnl section_body clearfix">
									<div class="form_left">
										<div class="form_fields clearfix">
											<div class="form_label"><label>Note</label></div>
											<div class="form_input"><asp:TextBox ID="tbNote" TextMode="MultiLine" runat="server" Length="1000"></asp:TextBox>
										        <p class="chars_remaining">Characters remaining: 1000</p></div>
									        <asp:RequiredFieldValidator ID="rfvNote" runat="server" ControlToValidate="tbNote" 
										        ErrorMessage="Note is a required field." Display="Dynamic" ValidationGroup="vgNote" />
										</div>
									</div>
									<div class="form_right">
										<div class="form_fields clearfix">
											<div class="form_label"><label>Email reminder date</label></div>
											<div class="form_input"><asp:TextBox ID="tbNoteReminderDate" runat="server" CssClass="phone_field"></asp:TextBox></div>
										</div>
									</div>
									<div class="clearboth"></div>
                                    <div class="update_btn_bar">
                                        <asp:Button ID="btnNoteSubmit" runat="server" CausesValidation="false" Text="Save note" OnClick="btnNoteSubmit_onClick" CssClass="update_btn" ValidationGroup="vgNote" /> | <a id="lnkCancelNote" href="#">Cancel</a>
                                    </div>               
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
                                
                <div class="ui-corner-all accordion_item">
                    <h4 class="clearfix"><span class="ui-icon ui-icon-triangle-1-e"></span><a href="#">History</a>&nbsp;&nbsp;&nbsp; <a id="lnkViewFileMakerHistoryArchive" style="text-decoration:none; color:#0da1d1;font-size:12px;" runat="server">View Filemaker History</a></h4>
                    <div class="cnt clearfix">
                        <asp:UpdatePanel ID="upProductVersion" runat="server">
                            <ContentTemplate>
                                <table border="0" cellpadding="0" cellspacing="0" class="tbl_data_notes">
                                    <asp:Repeater ID="rptProductVersion" runat="server">
                                        <ItemTemplate><tr><td><a target='_blank' href='ViewVersion.aspx?id=<%# Eval("versionId") %>'><%# Eval("versionId") %></a></td><td><%# Eval("actionId") %></td><td><%# Eval("typeId") %></td><td><%# Eval("modificationDate") %></td><td><%# Eval("modifiedBy") %></td></tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </table>
                            </ContentTemplate>
                         </asp:UpdatePanel>
                    </div>
                </div>
                <div class="ui-corner-all accordion_item">
                    <h4 class="clearfix"><span class="ui-icon ui-icon-triangle-1-e"></span><a href="#">Management Options</a></h4>
                    <div class="cnt clearfix">
                        <div class="form_left">
                            <div class="form_fields clearfix">
		                        <div class="form_label"><label>Ownership Model</label></div>
	                            <div class="form_input">
                                    <asp:DropDownList ID="ddlOwnershipType" runat="server">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="form_fields clearfix">
                                <div class="form_label"><label>Ticketed</label></div>
	                            <div class="form_input">
                                    <asp:CheckBox ID="cbTicketed" Text="Yes" runat="server" />
                                </div>
                            </div>
                        </div>
                        <div class="form_right">
                            <div class="form_fields clearfix">
                                <div class="form_label"><label>Capacity</label></div>
	                            <div class="form_input">
                                    <asp:DropDownList ID="ddlCapacityType" runat="server">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="form_fields clearfix">
                                <div class="form_label"><label>Economic Sustainability</label></div>
	                            <div class="form_input">
                                    <asp:DropDownList ID="ddlSustainabilityType" runat="server">
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

</asp:Content> 

