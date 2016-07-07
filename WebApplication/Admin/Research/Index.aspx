<%@ Page Language="C#" MasterPageFile="~/research.master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="WebApplication.Admin.Research.Index" %>

<asp:Content ID="cHeadContent" ContentPlaceHolderID="cphHeadContent" Runat="Server"> 
    <script type="text/javascript">
        $(document).ready(function () {
            $("[id*=mn_search]").addClass("current");
            InitializeEventBindings();
        });

        function ClearFormErrors() {
            $("[id*=dvError]").hide();
        }

        // Attach events
        function InitializeEventBindings() {
            $("[id*=tbLicenseNumber]").focus();
            
            $("[id*=btnSearch]").click(function () {
                if (IsFormValid()) {
                    return true;
                }
                return false;
            });

            // Attach event to clear filters link
            $("[id*=lnkClearForm]").click(function () {
                ClearFilters();
                $("[id*=tbLicenseNumber]").focus();
            });

            $("[id*=rblProductType]").click(function () {
           //     MakeFormAdjustments();
            });
        }

        // Resets the values for the filter textboxes
        function ClearFilters() {
            $("[id*=tbLicenseNumber]").val('');
            $("[id*=tbProductName]").val('');
            $("[id*=ddlYear]").val('');
            $("[id*=rblProductType]").attr('checked', false);
            $("[id*=rblProductType]").filter("[value='1']").attr('checked', true);
        }


        function MakeFormAdjustments() {
            var pt = $("[id*=rblProductType]:checked").val();
            $("[id*=dvAccommodationType]").hide();
            $("[id*=dvCampgroundType]").hide();

            switch (pt) {
                case "1":
                    $("[id*=dvAccommodationType]").show();
                    break;
                case "2":
                    $("[id*=dvCampgroundType]").show();
                    break;
            }
        }

        function IsFormValid() {
            var isValid = true;
            ClearFormErrors();

/*
            var pt = $("[id*=rblProductType]:checked").val();

            switch (pt) {
                case "1":
//                    if (!$("[id*=ddlAccommodationType]").val()) {
//                        $("[id*=dvErrorAccommodationType]").show();
//                        isValid = false;
//                    }
                    break;
                case "2":
//                    if (!$("[id*=ddlCampgroundType]").val()) {
//                        $("[id*=dvErrorCampgroundType]").show();
//                        isValid = false;
//                    }
                    break;
                default:
                    $("[id*=dvErrorProductType]").show();
                    isValid = false;
            }
*/
            /*
            if (!$("[id*=ddlYear]").val()) {
                $("[id*=dvErrorYear]").show();
                isValid = false;
            }
            */

            return isValid;
        }

    </script>
</asp:Content> 
<asp:Content ID="cMainContent" ContentPlaceHolderID="cphMainContent" Runat="Server"> 
    <div class="page_header clearfix">
		<h2 class="page_title">Research</h2>
	</div>

    <table cellpadding="0" cellspacing="0" border="0" class="researchProdInfo">
        <tr>
            <td class="form_label"><label>License number</label></td>
            <td class="form_label"><label>Product name</label></td>
            <td class="form_label"><label>Product type</label></td>
        </tr>
        <tr>
            <td class="form_input"><asp:TextBox ID="tbLicenseNumber" runat="server" MaxLength="20"></asp:TextBox></td>
            <td class="form_input"><asp:TextBox ID="tbProductName" runat="server" MaxLength="200"></asp:TextBox></td>
            <td class="form_input">
                <asp:RadioButtonList ID="rblProductType" runat="server" RepeatLayout="Flow">
                    <asp:ListItem Value="1" Selected="true">Accommodation</asp:ListItem>
                    <asp:ListItem Value="3">Campground</asp:ListItem>
                </asp:RadioButtonList>
                <div id="dvErrorProductType" style="display:none;">
		            <span style="color:red;">Product type is required.</span>
                </div>
            </td>
        </tr>
    </table>
                <!--
                <div class="form_fields clearfix">
			        <div class="form_label"><label>Year</label></div>
			        <div class="form_input"><asp:DropDownList ID="ddlYear" runat="server"></asp:DropDownList></div>
		        </div>

                <div id="dvAccommodationType" class="form_fields clearfix" style="display:none;">
			        <div class="form_label"><label>Class type</label></div>
			        <div class="form_input">
                        <asp:DropDownList ID="ddlAccommodationType" runat="server" AppendDataBoundItems="true">
                            <asp:ListItem Value="">Please select</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div id="dvErrorAccommodationType" style="display:none;">
		                <span style="color:red;">Class is required.</span>
                    </div>
		        </div>
                <div id="dvCampgroundType" class="form_fields clearfix" style="display:none;">
			        <div class="form_label"><label>Campround type</label></div>
			        <div class="form_input">
                        <asp:DropDownList ID="ddlCampgroundType" runat="server">
                            <asp:ListItem Value="">Please select</asp:ListItem>
                            <asp:ListItem Value="1">National</asp:ListItem>
                            <asp:ListItem Value="2">Private</asp:ListItem>
                            <asp:ListItem Value="3">Provincial</asp:ListItem>
                        </asp:DropDownList></div>
                    <div id="dvErrorCampgroundType" style="display:none;">
            		    <span style="color:red;">Campground type is required.</span>
                    </div>
		        </div>

                <div class="form_fields clearfix" >
			        <div class="form_label"><label>Completion status</label></div>
			        <div class="form_input">
                        <asp:DropDownList ID="ddlCompletionStatus" runat="server">
                            <asp:ListItem Value="">Please select</asp:ListItem>
                            <asp:ListItem Value="1">Yes</asp:ListItem>
                            <asp:ListItem Value="0">No</asp:ListItem>
                        </asp:DropDownList>
                    </div>
		        </div>
                -->

        <div class="search_btn_bar clearfix">
			<asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_OnClick" Text="Search" CssClass="submit_btn" />  | <a id="lnkClearForm" href="#">Clear</a>
		</div>
        <hr />
    <asp:ListView ID="lvProducts" runat="server">
    <LayoutTemplate>
        <table border="0" cellpadding="0" cellspacing="0" class="tbl_data">
            <tr class="tbl_header">
                <td><strong>License Number</strong></td>
                <td><strong>Product Name</strong></td>
                <td><strong>Total Units</strong></td>
                <td><strong>Region</strong></td>
            </tr>
            <div id="itemPlaceholder" runat="server" />
        </table>
  </LayoutTemplate>
    <ItemTemplate ><tr><td><a href="<%# (string)Eval("productTypeId") == "1" ? "Edit.aspx" : "EditCampground.aspx"%>?productId=<%# Eval("productId") %>"><%# Eval("licenseNumber") %></a></td><td><a href="<%# (string)Eval("productTypeId") == "1" ? "Edit.aspx" : "EditCampground.aspx"%>?productId=<%# Eval("productId") %>"><%# Eval("productName") %></a></td><td><%# Eval("totalUnits") %></td><td><%# Eval("regionName") %></td></tr></ItemTemplate>
    <EmptyDataTemplate>
                    No records available.
        </EmptyDataTemplate>
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
