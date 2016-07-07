// Add the correct data to the print preview
function RefreshPrintPreview() {
    // Line 1 information
    // Clear line 1 div
    $("[id*=divPrintPreviewProduct]").html('');
    $("[id*=divPrintPreviewIcons]").html('');

    // Product Name
    if ($("[id*=tbProductName]").val() != "") {
        $("[id*=divPrintPreviewProduct]").append($("[id*=tbProductName]").val());
    }

    // Proprietor
    if ($("[id*=tbProprietor]").val().trim() != "" && $("[id*=hdnProductTypeId]").val() == "4") {
        $("[id*=divPrintPreviewProduct]").append(' &bull; ' + $("[id*=tbProprietor]").val().trim());
    }

    // Wheelchair accessible
    if ($("[id*=cbAtt11_515]").attr('checked')) {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon wheelchair">Wheelchair</div>');
    }

    // Provincial
    if ($("[id*=cbAtt12_552]").attr('checked')) {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon provincial">Provincial</div>');
    }

    // Limited accessibility
    if ($("[id*=cbAtt11_516]").attr('checked')) {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon limited_access">Limited accessibility</div>');
    }

    // Museum
    if ($("[id*=cbAtt18_863]").attr('checked')) {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon museum">Museum</div>');
    }

    // Park
    if ($("[id*=cbAtt18_865]").attr('checked') && $("[id*=cbAtt12_551]").attr('checked')) {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon park">Park</div>');
    }

    // Housekeeping
    if ($("[id*=cbAtt2_57]").attr('checked')) {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_txt_icon outfitters">O</div>');
    }

    // Outfitters
    if ($("[id*=cbAtt1_16]").attr('checked')) {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon housekeeping">Housekeeping</div>');
    }

    // Check-In Member
    if ($("[id*=cbCheckinMember]").attr('checked')) {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon checkin_member">Check-In Member</div>');
    }

    // Internet Access
    if ($("[id*=cbAtt11_519]").attr('checked')) {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon internet_access">Internet Access</div>');
    }

    // Pets on Premises
    if ($("[id*=cbAtt16_751]").attr('checked')) {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon pets_on_premises">Pets allowed on premises</div>');
    }

    // Pets allowed
    if ($("[id*=cbAtt16_753]").attr('checked')) {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon pets">Pets allowed</div>');
    }

    // No pets
    if ($("[id*=cbAtt16_752]").attr('checked')) {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon no_pets">No pets</div>');
    }

    // TasteOfNs
    if ($("[id*=cbAtt15_710]").attr('checked')) {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon tasteofns">TasteOfNs</div>');
    }

    // NsApproved
    if ($("[id*=cbAtt5_203]").attr('checked')) {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon nsa">NS Approved</div>');
    }

    // SmokingPermitted
    if ($("[id*=cbAtt11_521]").attr('checked')) {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon smoking">Smoking Permitted</div>');
    }

    // Bienvenue
    if ($("[id*=cbAtt11_517]").attr('checked')) {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon bienvenue">Bienvenue</div>');
    }

    // RANS
    if ($("[id*=cbAtt15_709]").attr('checked')) {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon rans">RANS</div>');
    }

    // Golf NS
    if ($("[id*=cbAtt15_708]").attr('checked')) {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon golf_ns">Golf NS</div>');
    }

    // Outdoor activities
    if ($("[id*=hdnProductTypeId]").val() != "2") {

        // Golf
        if ($("[id*=cbAtt4_163]").attr('checked')) {
            $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon golf">Golf</div>');
        }

        // Diving
        if ($("[id*=cbAtt4_158]").attr('checked') && $("[id*=hdnProductTypeId]").val() != "1" && $("[id*=hdnProductTypeId]").val() != "3") {
            $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon diving">Diving</div>');
        }

        // Whale Watching
        if ($("[id*=cbAtt4_176]").attr('checked') && $("[id*=hdnProductTypeId]").val() != "1" && $("[id*=hdnProductTypeId]").val() != "3") {
            $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon whale">Whale Watching</div>');
        }

        // Fishing
        if ($("[id*=cbAtt4_161]").attr('checked')) {
            $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon fishing">Fishing</div>');
        }

        // Birding
        if ($("[id*=cbAtt4_152]").attr('checked') && $("[id*=hdnProductTypeId]").val() != "1" && $("[id*=hdnProductTypeId]").val() != "3") {
            $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon birding">Birding</div>');
        }

        // Sightseeing Tours
        if ($("[id*=cbAtt4_181]").attr('checked')) {
            $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon sightseeing">Sightseeing Tours</div>');
        }

        // Photography Landscape Painting
        if ($("[id*=cbAtt4_171]").attr('checked') && $("[id*=hdnProductTypeId]").val() != "1" && $("[id*=hdnProductTypeId]").val() != "3") {
            $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon plp">Photography Landscape Painting</div>');
        }

        // Sailing
        if ($("[id*=cbAtt4_169]").attr('checked') && $("[id*=hdnProductTypeId]").val() != "1" && $("[id*=hdnProductTypeId]").val() != "3") {
            $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon sailing">Sailing</div>');
        }

        // Cycling
        if ($("[id*=cbAtt4_157]").attr('checked')) {
            $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon cycling">Cycling</div>');
        }

        // Hiking
        if ($("[id*=cbAtt4_164]").attr('checked')) {
            $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon hiking">Hiking</div>');
        }

        // Canoeing
        if ($("[id*=cbAtt4_154]").attr('checked')) {
            $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon canoeing">Canoeing</div>');
        }

        // Kayaking
        if ($("[id*=cbAtt4_165]").attr('checked')) {
            $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon kayaking">Kayaking</div>');
        }

        // Nature Wildlife
        if ($("[id*=cbAtt24_1155]").attr('checked')) {
            $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon wildlife">Nature Wildlife</div>');
        }

        // Camping
        if ($("[id*=cbAtt4_153]").attr('checked') && $("[id*=hdnProductTypeId]").val() != "1" && $("[id*=hdnProductTypeId]").val() != "3") {
            $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon camping">Camping</div>');
        }

        // Skiing
        if ($("[id*=cbAtt4_155]").attr('checked') || $("[id*=cbAtt4_160]").attr('checked')) {
            $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon cc_skiing">Skiing</div>');
        }

        // Snowmobiling
        if ($("[id*=cbAtt4_178]").attr('checked') && $("[id*=hdnProductTypeId]").val() != "1" && $("[id*=hdnProductTypeId]").val() != "3") {
            $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon snowmobile">Snowmobiling</div>');
        }

        // Showshoeing
        if ($("[id*=cbAtt4_174]").attr('checked')) {
            $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon snowshoe">Snowshoeing</div>');
        }

        // Fossils
        if ($("[id*=cbAtt6_256]").attr('checked')) {
            $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon fossils">Fossils</div>');
        }

        // Atv
        if ($("[id*=cbAtt4_151]").attr('checked') && $("[id*=hdnProductTypeId]").val() != "1" && $("[id*=hdnProductTypeId]").val() != "3") {
            $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon atv">Atv</div>');
        }

        // Winery
        if ($("[id*=cbAtt18_873]").attr('checked')) {
            $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon winery">Winery</div>');
        }
    }

    // GenealogicalServices
    if ($("[id*=cbAtt6_269]").attr('checked')) {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon genealogical">Genealogical Services</div>');
    }

    // AccessCanadaRating
    if ($("[id*=ddlAccessCanadaRating]").val() != "") {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon acc_can_' + $("[id*=ddlAccessCanadaRating]").val() + '">Access Canada Level ' + $("[id*=ddlAccessCanadaRating]").val() + '</div>');
    }

    // Canada Select Ratings
    if ($("[id*=ddlRatingBedAndBreakfast]").val() != "") {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon csr_' + $("[id*=ddlRatingBedAndBreakfast]").val() + '">[BB]</div>');
    }

    if ($("[id*=ddlRatingTouristHome]").val() != "") {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon csr_' + $("[id*=ddlRatingTouristHome]").val() + '">[TH/BB]</div>');
    }

    if ($("[id*=ddlRatingBedAndBreakfastInn]").val() != "") {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon csr_' + $("[id*=ddlRatingBedAndBreakfastInn]").val() + '">[BBI]</div>');
    }

    if ($("[id*=ddlRatingCottage]").val() != "") {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon csr_' + $("[id*=ddlRatingCottage]").val() + '">[C]</div>');
    }

    if ($("[id*=ddlRatingHotelMotel]").val() != "") {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon csr_' + $("[id*=ddlRatingHotelMotel]").val() + '">[HM]</div>');
    }

    if ($("[id*=ddlRatingFishing]").val() != "") {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon csr_' + $("[id*=ddlRatingFishing]").val() + '">[FH]</div>');
    }

    if ($("[id*=ddlRatingInn]").val() != "") {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon csr_' + $("[id*=ddlRatingInn]").val() + '">[I]</div>');
    }

    if ($("[id*=ddlRatingResort]").val() != "") {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon csr_' + $("[id*=ddlRatingResort]").val() + '">[R]</div>');
    }

    if ($("[id*=ddlRatingFacilities]").val() != "") {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon csr_' + $("[id*=ddlRatingFacilities]").val() + '">[F]</div>');
    }

    if ($("[id*=ddlRatingRecreation]").val() != "") {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon csr_' + $("[id*=ddlRatingRecreation]").val() + '">[R]</div>');
    }

    // CAA class
    if ($("[id*=ddlCaaLevel]").val() != "" && $("[id*=hdnProductTypeId]").val() == "1") {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon caa_' + $("[id*=ddlCaaLevel]").val() + '">' + $("[id*=ddlCaaLevel]").val() + '</div>');
    }
    else if ($("[id*=ddlCaaLevel]").val() > 1 && $("[id*=hdnProductTypeId]").val() == "3") {
        $("[id*=divPrintPreviewIcons]").append('<div class="pp_icon caa_camp_' + $("[id*=ddlCaaLevel]").val() + '">' + $("[id*=ddlCaaLevel]").val() + '</div>');
    }

    // Line 2 information
    // Clear line 2 div
    $("[id*=divPrintPreview2]").html('');

    // Fine arts type and media
    if ($("[id*=hdnProductTypeId]").val() == "4") {
        var type = "";

        if ($("[id*=cbAtt7_301]").attr('checked')) {
            type += 'Accessories, ';
        }

        if ($("[id*=cbAtt7_302]").attr('checked')) {
            type += 'Bath & body products, ';
        }

        if ($("[id*=cbAtt7_303]").attr('checked')) {
            type += 'Clothing, ';
        }

        if ($("[id*=cbAtt7_304]").attr('checked')) {
            type += 'Furniture, ';
        }

        if ($("[id*=cbAtt7_305]").attr('checked')) {
            type += 'Garden accessories, ';
        }

        if ($("[id*=cbAtt7_306]").attr('checked')) {
            type += 'Home décor, ';
        }

        if ($("[id*=cbAtt7_307]").attr('checked')) {
            type += 'Jewelry, ';
        }

        if ($("[id*=cbAtt7_308]").attr('checked')) {
            type += 'Sculpture, ';
        }

        var media = "";

        if ($("[id*=cbAtt14_651]").attr('checked')) {
            media += 'Books & cards, ';
        }

        if ($("[id*=cbAtt14_652]").attr('checked')) {
            media += 'Clay, ';
        }

        if ($("[id*=cbAtt14_653]").attr('checked')) {
            media += 'Decorative art, ';
        }

        if ($("[id*=cbAtt14_654]").attr('checked')) {
            media += 'Fibre, ';
        }

        if ($("[id*=cbAtt14_655]").attr('checked')) {
            media += 'Food, ';
        }

        if ($("[id*=cbAtt14_656]").attr('checked')) {
            media += 'Glass, ';
        }

        if ($("[id*=cbAtt14_657]").attr('checked')) {
            media += 'Leather, ';
        }

        if ($("[id*=cbAtt14_658]").attr('checked')) {
            media += 'Metal, ';
        }

        if ($("[id*=cbAtt14_659]").attr('checked')) {
            media += 'Organics, ';
        }

        if ($("[id*=cbAtt14_660]").attr('checked')) {
            media += 'Paper, ';
        }

        if ($("[id*=cbAtt14_661]").attr('checked')) {
            media += 'Stone & bone, ';
        }

        if ($("[id*=cbAtt14_662]").attr('checked')) {
            media += 'Visual arts, ';
        }

        if ($("[id*=cbAtt14_663]").attr('checked')) {
            media += 'Wood, ';
        }

        // Remove div if it was added
        $("[id*=divArts]").remove();

        // Remove last 2 characters, add period and space
        if (type.length || media.length) {

            $('<div id="divArts"></div>').insertBefore($("[id*=divPrintPreview2]"));

            if (type.length) {
                $("[id*=divArts]").append('<strong>Category: </strong>' + type.substring(0, type.length - 2));
            }
            if (type.length && media.length) {
                $("[id*=divArts]").append(' <strong>&bull;</strong> ');
            }
            if (media.length) {
                $("[id*=divArts]").append('<strong>Media: </strong>' + media.substring(0, media.length - 2));
            }
        }
    }

    // Phone
    if ($("[id*=tbPhone]").val().trim() != "") {
        if ($("[id*=tbPhone]").val().trim() == $("[id*=tbFax]").val().trim()) {
            $("[id*=divPrintPreview2]").append('tel/fax ' + $("[id*=tbPhone]").val().trim().replace("902-", ""));
        }
        else {
            $("[id*=divPrintPreview2]").append($("[id*=tbPhone]").val().trim().replace("902-", ""));
        }
    }

    // Secondary Phone
    if ($("[id*=tbSecondaryPhone]").val().trim() != "" && $("[id*=hdnProductTypeId]").val() != "4") {
        $("[id*=divPrintPreview2]").append('; ' + $("[id*=tbSecondaryPhone]").val().trim().replace("902-", ""));
    }

    // Off Season Phone
    if ($("[id*=tbOffSeasonPhone]").val().trim() != "" && $("[id*=hdnProductTypeId]").val() != "4") {
        $("[id*=divPrintPreview2]").append('; O/S ' + $("[id*=tbOffSeasonPhone]").val().trim().replace("902-", ""));
    }

    // Toll-free phone
    if ($("[id*=tbTollFree]").val().trim() != "") {
        TelephoneAddBullet();
        $("[id*=divPrintPreview2]").append($("[id*=tbTollFree]").val().trim());
        if ($("[id*=cbReservationsOnly]").attr('checked')) {
            $("[id*=divPrintPreview2]").append(' (reservations)');
        }
    }

    // Fax
    if ($("[id*=tbFax]").val().trim() != "" && $("[id*=tbPhone]").val().trim() != $("[id*=tbFax]").val().trim()) {
        TelephoneAddBullet();
        $("[id*=divPrintPreview2]").append('fax ' + $("[id*=tbFax]").val().trim().replace("902-", ""));
    }

    // Email
    if ($("[id*=tbEmail]").val().trim() != "") {
        TelephoneAddBullet();
        $("[id*=divPrintPreview2]").append($("[id*=tbEmail]").val().trim());
    }

    // Website
    if ($("[id*=tbWeb]").val().trim() != "") {
        TelephoneAddBullet();
        $("[id*=divPrintPreview2]").append($("[id*=tbWeb]").val().replace(/http:\/\//, "").trim() + ' ');
    }

    // Line 3 information
    // Clear line 3 div
    $("[id*=divPrintPreview3]").html('');

    // Proprietor
    if ($("[id*=tbProprietor]").val().trim() != "" && $("[id*=hdnProductTypeId]").val() != "4") {
        $("[id*=divPrintPreview3]").append($("[id*=tbProprietor]").val().trim() + '. ');
    }

    // Address line 1
    if ($("[id*=tbLine1]").val().trim() != "") {
        $("[id*=divPrintPreview3]").append($("[id*=tbLine1]").val().trim() + ', ');
    }

    // Address line 2
    if ($("[id*=tbLine2]").val().trim() != "") {
        $("[id*=divPrintPreview3]").append($("[id*=tbLine2]").val().trim() + ', ');
    }

    // Address line 3
    if ($("[id*=tbLine2]").val().trim() != "") {
        $("[id*=divPrintPreview3]").append($("[id*=tbLine3]").val().trim() + ', ');
    }

    // Community
    if ($("[id*=ddlCommunity]").val() != "") {
        $("[id*=divPrintPreview3]").append($("[id*=ddlCommunity] option:selected").text());
    }

    // Province
    if ($("[id*=hdnProductTypeId]").val() != "4") {
        $("[id*=divPrintPreview3]").append(', NS');
    }

    // Postal code
    if ($("[id*=tbPostalCode]").val().trim() != "" && $("[id*=hdnProductTypeId]").val() != "4") {
        $("[id*=divPrintPreview3]").append(', ' + $("[id*=tbPostalCode]").val());
    }

    // Period
    if ($("[id*=hdnProductTypeId]").val() != "4" || !$("[id*=cbAtt17_801]").attr('checked')) {
        $("[id*=divPrintPreview3]").append('. ');
    }
    else {
        $("[id*=divPrintPreview3]").append(' ');
    }

    // Directions
    if ($("[id*=tbPrintDirectionsEn]").val().trim() != "") {
        $("[id*=divPrintPreview3]").append($("[id*=tbPrintDirectionsEn]").val().trim() + ' ');
    }

    // GPS Coordinates
    if ($("[id*=cbAtt17_801]").attr('checked') && $("[id*=tbLatitude]").val().trim() != "" && $("[id*=tbLongitude]").val().trim() != "") {
        $("[id*=divPrintPreview3]").append('(GPS N' + ConvertDDtoDMS($("[id*=tbLatitude]").val().trim()) + ' W' + ConvertDDtoDMS($("[id*=tbLongitude]").val().trim()) + '). ');
    }

    // Type span
    $("[id*=divPrintPreview3]").append('<span id="AccType"></span>');

    // Add accommodation types
    if ($("[id*=cbAtt3_101]").attr('checked')) {
        $("[id*=AccType]").append('Apt.');
    }

    if ($("[id*=cbAtt3_102]").attr('checked')) {
        AccTypeAddComma();
        $("[id*=AccType]").append('B&B');
    }

    if ($("[id*=cbAtt3_103]").attr('checked')) {
        AccTypeAddComma();
        $("[id*=AccType]").append('B&B Inn');
    }

    if ($("[id*=cbAtt3_104]").attr('checked')) {
        AccTypeAddComma();
        $("[id*=AccType]").append('Cabin');
    }

    if ($("[id*=cbAtt3_105]").attr('checked')) {
        AccTypeAddComma();
        $("[id*=AccType]").append('Condo-Cottage');
    }

    if ($("[id*=cbAtt3_106]").attr('checked')) {
        AccTypeAddComma();
        $("[id*=AccType]").append('Cottage');
    }

    if ($("[id*=cbAtt3_116]").attr('checked')) {
        AccTypeAddComma();
        $("[id*=AccType]").append('Dorm-style');
    }

    if ($("[id*=cbAtt3_107]").attr('checked')) {
        AccTypeAddComma();
        $("[id*=AccType]").append('Guest Room');
    }

    if ($("[id*=cbAtt3_108]").attr('checked')) {
        AccTypeAddComma();
        $("[id*=AccType]").append('Hostel');
    }

    if ($("[id*=cbAtt3_109]").attr('checked')) {
        AccTypeAddComma();
        $("[id*=AccType]").append('Hotel');
    }

    if ($("[id*=cbAtt3_110]").attr('checked')) {
        AccTypeAddComma();
        $("[id*=AccType]").append('Inn');
    }

    if ($("[id*=cbAtt3_111]").attr('checked')) {
        AccTypeAddComma();
        $("[id*=AccType]").append('Lodge');
    }

    if ($("[id*=cbAtt3_112]").attr('checked')) {
        AccTypeAddComma();
        $("[id*=AccType]").append('Mini-home');
    }

    if ($("[id*=cbAtt3_113]").attr('checked')) {
        AccTypeAddComma();
        $("[id*=AccType]").append('Motel');
    }

    if ($("[id*=cbAtt3_114]").attr('checked')) {
        AccTypeAddComma();
        $("[id*=AccType]").append('Resort');
    }

    if ($("[id*=cbAtt3_115]").attr('checked')) {
        AccTypeAddComma();
        $("[id*=AccType]").append('Tourist Home');
    }

    if ($("[id*=cbAtt3_117]").attr('checked')) {
        AccTypeAddComma();
        $("[id*=AccType]").append('Vac. Home');
    }

    // Colon
    if ($("[id*=AccType]").html().length) {
        $("[id*=AccType]").append(": ");
    }

    // Restaurant Type
    if ($("[id*=hdnProductTypeId]").val() == "7") {
        var types = "";

        if ($("[id*=cbAtt25_1200]").attr('checked')) {
            types += 'Coffee shop, ';
        }

        if ($("[id*=cbAtt25_1201]").attr('checked')) {
            types += 'Continental, ';
        }

        if ($("[id*=cbAtt25_1202]").attr('checked')) {
            types += 'Family dining, ';
        }

        if ($("[id*=cbAtt25_1203]").attr('checked')) {
            types += 'Fast food, ';
        }

        if ($("[id*=cbAtt25_1204]").attr('checked')) {
            types += 'Fine dining, ';
        }

        if ($("[id*=cbAtt25_1205]").attr('checked')) {
            types += 'Gourmet, ';
        }

        if ($("[id*=cbAtt25_1206]").attr('checked')) {
            types += 'Informal, ';
        }

        if ($("[id*=cbAtt25_1207]").attr('checked')) {
            types += 'Lounge, ';
        }

        if ($("[id*=cbAtt25_1208]").attr('checked')) {
            types += 'Pub, ';
        }

        // Remove last 2 characters, add period and space
        if (types.length) {
            $("[id*=divPrintPreview3]").append(types.capitalize().substring(0, types.length - 2) + '. ');
        }
    }

    // Restaurant Specialty
    if ($("[id*=hdnProductTypeId]").val() == "7") {
        var specialties = "";

        if ($("[id*=cbAtt26_1251]").attr('checked')) {
            specialties += 'Acadian, ';
        }

        if ($("[id*=cbAtt26_1252]").attr('checked')) {
            specialties += 'Burgers, ';
        }

        if ($("[id*=cbAtt26_1253]").attr('checked')) {
            specialties += 'Canadian, ';
        }

        if ($("[id*=cbAtt26_1254]").attr('checked')) {
            specialties += 'Chinese, ';
        }

        if ($("[id*=cbAtt26_1255]").attr('checked')) {
            specialties += 'European, ';
        }

        if ($("[id*=cbAtt26_1256]").attr('checked')) {
            specialties += 'Fish and chips, ';
        }

        if ($("[id*=cbAtt26_1257]").attr('checked')) {
            specialties += 'German, ';
        }

        if ($("[id*=cbAtt26_1258]").attr('checked')) {
            specialties += 'Italian, ';
        }

        if ($("[id*=cbAtt26_1259]").attr('checked')) {
            specialties += 'Pasta, ';
        }

        if ($("[id*=cbAtt26_1260]").attr('checked')) {
            specialties += 'Pizza, ';
        }

        if ($("[id*=cbAtt26_1261]").attr('checked')) {
            specialties += 'Sandwiches, ';
        }

        if ($("[id*=cbAtt26_1262]").attr('checked')) {
            specialties += 'Seafood, ';
        }

        if ($("[id*=cbAtt26_1263]").attr('checked')) {
            specialties += 'Steaks, ';
        }

        if ($("[id*=cbAtt26_1264]").attr('checked')) {
            specialties += 'Vegetarian, ';
        }

        // Remove last 2 characters, add period and space
        if (specialties.length) {
            $("[id*=divPrintPreview3]").append(specialties.capitalize().substring(0, specialties.length - 2) + '. ');
        }
    }

    // Restaurant Services
    if ($("[id*=hdnProductTypeId]").val() == "7") {
        var services = "";

        if ($("[id*=cbAtt19_901]").attr('checked')) {
            services += 'B, ';
        }

        if ($("[id*=cbAtt19_902]").attr('checked')) {
            services += 'CM, ';
        }

        if ($("[id*=cbAtt19_903]").attr('checked')) {
            services += 'DEL, ';
        }

        if ($("[id*=cbAtt19_908]").attr('checked')) {
            services += 'RR, ';
        }

        if ($("[id*=cbAtt19_909]").attr('checked')) {
            services += 'SA, ';
        }

        if ($("[id*=cbAtt19_907]").attr('checked')) {
            services += 'Pa, ';
        }

        if ($("[id*=cbAtt19_910]").attr('checked')) {
            services += 'TO, ';
        }

        if ($("[id*=cbAtt19_906]").attr('checked')) {
            services += 'LE, ';
        }

        if ($("[id*=cbAtt19_904]").attr('checked')) {
            services += 'DR, ';
        }

        if ($("[id*=cbAtt19_905]").attr('checked')) {
            services += 'L, ';
        }

        // Remove last 2 characters, add period and space
        if (services.length) {
            $("[id*=divPrintPreview3]").append(services.capitalize().substring(0, services.length - 2) + '. ');
        }
    }

    // Print unit description
    if ($("[id*=tbPrintUnitDescriptionEn]").val().trim() != "") {
        $("[id*=divPrintPreview3]").append($("[id*=tbPrintUnitDescriptionEn]").val().trim() + ' ');
    }

    // Print description
    if ($("[id*=tbPrintDescriptionEn]").val().trim() != "") {
        $("[id*=divPrintPreview3]").append($("[id*=tbPrintDescriptionEn]").val().trim() + ' ');
    }


    // Attraction codes
    if ($("[id*=hdnProductTypeId]").val() == "2") {
        var codes = "";

        // Gift shop
        if ($("[id*=cbAtt11_505]").attr('checked')) {
            codes += 'G, ';
        }

        // Bus
        if ($("[id*=cbAtt11_502]").attr('checked')) {
            codes += 'B, ';
        }

        // Pic
        if ($("[id*=cbAtt11_509]").attr('checked')) {
            codes += 'Pic, ';
        }

        // Restaurant
        if ($("[id*=cbAtt11_512]").attr('checked')) {
            codes += 'R, ';
        }

        // Tea room
        if ($("[id*=cbAtt11_513]").attr('checked')) {
            codes += 'TR, ';
        }

        // Take Out
        if ($("[id*=cbAtt11_514]").attr('checked')) {
            codes += 'TO, ';
        }

        // Parking
        if ($("[id*=cbAtt11_508]").attr('checked')) {
            codes += 'P ';
            if ($("[id*=tbParkingSpaces]").val() != "") {
                codes += $("[id*=tbParkingSpaces]").val() + '  ';
            }
            else {
                codes += ' ';
            }
        }

        // Remove last 2 characters, add period and space
        if (codes.length) {
            $("[id*=divPrintPreview3]").append(codes.substring(0, codes.length - 2) + '. ');
        }
    }

    // Members
    if ($("[id*=dvMembership] .selectedList").text() != "" && $("[id*=dvMembership] .selectedList").text() != "None selected" && $("[id*=dvMembership] .selectedList").text() != "Taste of NS") {
        $("[id*=divPrintPreview3]").append('Member: ' + $("[id*=dvMembership] .selectedList").html().replace(", Taste of NS", "").replace("Taste of NS, ", "") + '. ');
    }

    // Rates
    if ($("[id*=tbPrintLowRate]").val().trim() != "") {
        $("[id*=divPrintPreview3]").append('Rates');
    }

    // Rate type
    if ($("[id*=ddlPrintRateType]").val() != "") {
        if ($("[id*=ddlPrintRateType]").val() == "1") {
            $("[id*=divPrintPreview3]").append(' STC');
        }
        else if ($("[id*=ddlPrintRateType]").val() == "2") {
            $("[id*=divPrintPreview3]").append(' GTD');
        }
    }

    // Rates
    if ($("[id*=hdnProductTypeId]").val() == "1" || $("[id*=hdnProductTypeId]").val() == "3") {
    
        // No tax
        if ($("[id*=cbPrintNoTax]").attr('checked')) {
            $("[id*=divPrintPreview3]").append(' (no tax)');
        }

        // Low rate
        if ($("[id*=tbPrintLowRate]").val().trim() != "") {
            $("[id*=divPrintPreview3]").append(' $' + $("[id*=tbPrintLowRate]").val());
        }

        // High rate
        if ($("[id*=tbPrintHighRate]").val().trim() != "") {
            $("[id*=divPrintPreview3]").append(' - ' + $("[id*=tbPrintHighRate]").val());
        }

        // Rate period
        if ($("[id*=ddlPrintRatePeriod]").val().trim() == "2") {
            $("[id*=divPrintPreview3]").append(' weekly');
        }
        else if ($("[id*=ddlPrintRatePeriod]").val().trim() == "3") {
            $("[id*=divPrintPreview3]").append(' monthly');
        }

        // Comma
        $("[id*=divPrintPreview3]").append(',');

        // Extra person
        if ($("[id*=tbPrintExtraPersonRate]").val().trim() != "") {
            $("[id*=divPrintPreview3]").append(' XP $' + $("[id*=tbPrintExtraPersonRate]").val().trim() + ';');
        }
    }

    // Rate details
    if ($("[id*=tbPrintRateDescriptionEn]").val().trim() != "") {
        $("[id*=divPrintPreview3]").append(' ' + $("[id*=tbPrintRateDescriptionEn]").val().trim());
    }

    // Cancelation policy
    if ($("[id*=ddlPrintCancellationPolicy]").val() == "2") {
        $("[id*=divPrintPreview3]").append(' Noon CXL policy;');
    }
    else if ($("[id*=ddlPrintCancellationPolicy]").val() == "3") {
        $("[id*=divPrintPreview3]").append(' Booking-specific CXL policy;');
    }
    else if ($("[id*=ddlPrintCancellationPolicy]").val() == "4") {
        $("[id*=divPrintPreview3]").append(' 12-hr CXL policy;');
    }
    else if ($("[id*=ddlPrintCancellationPolicy]").val() == "5") {
        $("[id*=divPrintPreview3]").append(' 24-hr CXL policy;');
    }
    else if ($("[id*=ddlPrintCancellationPolicy]").val() == "6") {
        $("[id*=divPrintPreview3]").append(' 48-hr CXL policy;');
    }
    else if ($("[id*=ddlPrintCancellationPolicy]").val() == "7") {
        $("[id*=divPrintPreview3]").append(' 72-hr CXL policy;');
    }
    else if ($("[id*=ddlPrintCancellationPolicy]").val() == "8") {
        $("[id*=divPrintPreview3]").append(' 1 wk CXL policy;');
    }
    else if ($("[id*=ddlPrintCancellationPolicy]").val() == "9") {
        $("[id*=divPrintPreview3]").append(' 2 wk CXL policy;');
    }
    else if ($("[id*=ddlPrintCancellationPolicy]").val() == "10") {
        $("[id*=divPrintPreview3]").append(' 4 wk CXL policy;');
    }
    else if ($("[id*=ddlPrintCancellationPolicy]").val() == "11") {
        $("[id*=divPrintPreview3]").append(' 8 wk CXL policy;');
    }
    else if ($("[id*=ddlPrintCancellationPolicy]").val() == "12") {
        $("[id*=divPrintPreview3]").append(' 12 wk CXL policy;');
    }

    // Off season rates
    if ($("[id*=cbPrintHasOffSeasonRates]").attr('checked')) {
        $("[id*=divPrintPreview3]").append(' O/S rates.');
    }

    // PaymentType
    $("[id*=divPrintPreview3]").append(' <span id="PaymentType"></span>');

    // Add payment types
    if ($("[id*=cbPaymentTypeCashOnly]").attr('checked')) {
        $("span[id*=PaymentType]").append('$/TC');
    }
    else if ($("[id*=cbPaymentTypeMasterCard]").attr('checked') && $("[id*=cbPaymentTypeVisa]").attr('checked')) {
        $("span[id*=PaymentType]").append('AMCC');
    }
    else {
        if ($("[id*=cbPaymentTypeAmex]").attr('checked')) {
            PaymentTypeAddComma();
            $("span[id*=PaymentType]").append('AE');
        }

        if ($("[id*=cbPaymentTypeDiners]").attr('checked')) {
            PaymentTypeAddComma();
            $("span[id*=PaymentType]").append('DC');
        }

        if ($("[id*=cbPaymentTypeDiscover]").attr('checked')) {
            PaymentTypeAddComma();
            $("span[id*=PaymentType]").append('DIS');
        }

        if ($("[id*=cbPaymentTypeMasterCard]").attr('checked')) {
            PaymentTypeAddComma();
            $("span[id*=PaymentType]").append('MC');
        }

        if ($("[id*=cbPaymentTypeVisa]").attr('checked')) {
            PaymentTypeAddComma();
            $("span[id*=PaymentType]").append('VS');
        }
    }

    // Add correct punctuation
    if ($("span[id*=PaymentType]").html().length) {
        $("span[id*=PaymentType]").append('. ');
    }
    else {
        $("span[id*=PaymentType]").remove();
        var text = $("[id*=divPrintPreview3]").text();
        $("[id*=divPrintPreview3]").html(text.substring(0, text.length - 2) + '. ');
    }

    // # of Seats
    if ($("[id*=hdnProductTypeId]").val() == "7") {
        if ($("[id*=tbSeatingCapacity]").val().trim() != "") {
            $("[id*=divPrintPreview3]").append('Seats ' + $("[id*=tbSeatingCapacity]").val().trim() + '. ');
        }
    }

    // Opening and closing dates
    if ($("[id*=ddlPrimaryGuideSection]").val() == "1") {
        var open = "Supervised";
    }
    else {
        var open = "Open";
    }

    if ($("[id*=rblPrintPeriodOfOperation_0]").attr('checked')) {
        $("[id*=divPrintPreview3]").append('<strong>' + open + ' year-round</strong>');
    }
    else if ($("[id*=rblPrintPeriodOfOperation_1]").attr('checked')) {
        $("[id*=divPrintPreview3]").append('<strong>' + open + ' seasonally</strong>');
    }
    else {
        if ($("[id*=ddlPrintOpenMonth]").val() != "" && $("[id*=ddlPrintCloseMonth]").val() != "") {
            // Append starting month
            $("[id*=divPrintPreview3]").append('<strong>' + open + ' ' + monthsEN[$("[id*=ddlPrintOpenMonth]").val()] + '</strong>');

            // Append starting day
            if ($("[id*=ddlPrintOpenDay]").val() != "") {
                $("[id*=divPrintPreview3]").append(' <strong>' + $("[id*=ddlPrintOpenDay] option:selected").text() + '</strong>');
            }

            // Append ending month
            $("[id*=divPrintPreview3]").append('<strong> - ' + monthsEN[$("[id*=ddlPrintCloseMonth]").val()] + '</strong>');

            // Append ending day
            if ($("[id*=ddlPrintCloseDay]").val() != "") {
                $("[id*=divPrintPreview3]").append(' <strong>' + $("[id*=ddlPrintCloseDay] option:selected").text() + "</strong>");
            }
        }
    }

    // Date detail or period
    if ($("[id*=tbPrintDateDescriptionEn]").val().trim() != "") {
        $("[id*=divPrintPreview3]").append(', ' + $("[id*=tbPrintDateDescriptionEn]").val().trim());
    }
    else {
        $("[id*=divPrintPreview3]").append('. ');
    }    

    // Ad Ref
    if ($("[id*=cbAtt17_802]").attr('checked')) {
        $("[id*=divPrintPreview3]").append('See ad p. XXX.');
    }

    // Clear errors
    $("[id*=divPrintPreviewError]").html('');

    // Check count
    if ($("[id*=divPrintPreview3]").text().split(' ').join('').length > 450) {
        $("[id*=divPrintPreviewError]").append('The English print preview exceeds the maximum characters.');
    }
}

// Converts Decimal based coordinate to DMS notation
function ConvertDDtoDMS(dd) {
    d = parseInt(dd);
    nFract = Math.abs(dd - d);
    m = parseInt(nFract * 60);
    s = Math.round(nFract * 36000 - m * 600);

    dms = Math.abs(d) + ' ' + m + '.' + s;

    return dms;
}

// Adds a comma if needed
function AccTypeAddComma() {
    if ($("[id*=AccType]").html().length) {
        $("[id*=AccType]").append(", ");
    }
}

// Adds a comma if needed
function PaymentTypeAddComma() {
    if ($("span[id*=PaymentType]").html().length) {
        $("span[id*=PaymentType]").append(", ");
    }
}

// Adds a bullet if needed
function TelephoneAddBullet() {
    if ($("[id*=divPrintPreview2]").html().length) {
        $("[id*=divPrintPreview2]").append(" <strong>&bull;</strong> ");
    }
}

String.prototype.capitalize = function () {
    return this.charAt(0).toUpperCase() + this.slice(1);
}