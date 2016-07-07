﻿<%@ Page Title="" Language="C#" MasterPageFile="~/prodCat.Master" AutoEventWireup="true" CodeBehind="WebTranslation.aspx.cs" Inherits="WebApplication.Admin.Report.WebTranslation" %>
<asp:Content ID="cHeadContent" ContentPlaceHolderID="cphHeadContent" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("[id*=mn_reports]").addClass("current");

            InitializeEventBindings();

        });

        // Attach events
        function InitializeEventBindings() {
            //hide data tables when empty
            $('table.tbl_data').each(function () {
                if ($(this).find('tbody > tr').length == 1) {
                    $(this).parent().hide();
                }
            });

            // Attach event to clear filters link
            $("[id*=lnkClearFilters]").click(function () {
                ClearFilters();
            });

            // Attach event to select or deselect all checkboxes
            $("[id*=cbToggleAll]").change(function () {
                ToggleAll();
            });
        }

        // Resets the values for the filter textboxes
        function ClearFilters() {
            $("[id*=ddlProductType]").val('');
            $("[id*=ddlRegion]").val('');
            $("[id*=ddlField]").val('');
            $("[id*=tbProductId]").val('');
            $("[id*=tbProductName]").val('');
        }

        // Select or deselect all checkboxes
        function ToggleAll() {
            if ($("[id*=cbToggleAll]").attr('checked')) {
                $('input.translationCheckbox').attr('checked', true);
            }
            else {
                $('input.translationCheckbox').attr('checked', false);
            }
        }
    </script>
</asp:Content>
<asp:Content ID="cMainContent" ContentPlaceHolderID="cphMainContent" Runat="Server">
    <div class="page_header clearfix">
		<div class="action_btns"></div>
		<h2 class="page_title">Web Translation Report</h2>
	</div>

    <div class="col_wrap clearfix">
        <div class="left_col wide">
            <div class="form_fields clearfix">
			    <div class="form_label"><label>Product type</label></div>
			    <div class="form_input"><asp:DropDownList id="ddlProductType" runat="server" /></div>
		    </div>
            <div class="form_fields clearfix">
			    <div class="form_label"><label>Region</label></div>
			    <div class="form_input">
                    <asp:DropDownList ID="ddlRegion" runat="server" AppendDataBoundItems="true">
                        <asp:ListItem value="-1">Please Select</asp:ListItem>
                    </asp:DropDownList>
                </div>
		    </div>
			<div class="form_fields clearfix">
			    <div class="form_label"><label>Field name</label></div>
			    <div class="form_input"><asp:DropDownList id="ddlField" runat="server" /></div>
		    </div>
        </div>
        <div id="dvWebFields" class="right_col wide">
            <div class="form_fields clearfix">
			    <div class="form_label"><label>Product ID</label></div>
			    <div class="form_input"><asp:TextBox ID="tbProductId" runat="server" MaxLength="10" CssClass="money_field" /></div>
		    </div>
            <div class="form_fields clearfix">
			    <div class="form_label"><label>Product name</label></div>
			    <div class="form_input"><asp:TextBox ID="tbProductName" runat="server" /></div>
		    </div>
        </div>
    </div>

    <div class="search_btn_bar clearfix">
		<asp:Button ID="btnFilter" runat="server" OnClick="btnFilter_OnClick" Text="Search" CssClass="search_btn" /> | <a id="lnkClearFilters" href="#">Clear</a>
	</div>

	<div style="display:block; height:1px; margin:36px 0 0; border-top:1px dotted #dedede;"></div>
    <asp:ListView ID="lvTranslations" runat="server" >
        <LayoutTemplate>
            <table border="0" cellpadding="0" cellspacing="0" class="tbl_data">
                <tr class="tbl_header">
                    <td style="text-align:center;"><input type="checkbox" id="cbToggleAll" /></td>
                    <td><strong>ID</strong></td>
                    <td><strong>Product name</strong></td>
                    <td><strong>Field name</strong></td>
                    <td><strong>Status date</strong></td>
                </tr>
                <div id="itemPlaceholder" runat="server" />
            </table>
        </LayoutTemplate>
        <ItemTemplate >
            <tr>
                <td style="text-align:center;"><input class="translationCheckbox" type="checkbox" /></td>
                <td><%# Eval("productId")%></td>
                <td><a href='../Product/Edit.aspx?id=<%# Eval("productId") %>'><%# Eval("productName") %></a></td>
                <td><%# Eval("fieldName") %></td>
                <td><%# DataBinder.Eval(Container.DataItem, "statusDate", "{0:d-MMM-yyyy}") %></td>
            </tr>
        </ItemTemplate>
    </asp:ListView>
   
    <div class="pager_nav clearfix">
        <asp:DataPager runat="server" ID="dpTranslationPager" PageSize="20" PagedControlID="lvTranslations">
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
