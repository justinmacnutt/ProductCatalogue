<%@ Page Language="C#" MasterPageFile="~/prodCat.master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="WebApplication.Admin.Business.Index" %>

<asp:Content ID="cHeadContent" ContentPlaceHolderID="cphHeadContent" Runat="Server"> 
    <script type="text/javascript">
        $(document).ready(function () {
            $("[id*=mn_business]").addClass("current");

            InitializeEventBindings();
        });

        // Attach events
        function InitializeEventBindings() {
            // Attach event to clear filters link
            $("[id*=lnkClearFilters]").click(function () {
                ClearFilters();
            });
        }

        // Resets the values for the filter textboxes
        function ClearFilters() {
            $("[id*=tbBusinessId]").val('');
            $("[id*=tbBusinessName]").val('');
            $("[id*=tbCommunityName]").val('');
        }
    </script>
</asp:Content> 
<asp:Content ID="cMainContent" ContentPlaceHolderID="cphMainContent" Runat="Server"> 
    <div class="page_header clearfix">
		<h2 class="page_title">Business</h2>
	</div>    
        <div class="col_wrap clearfix">
           <div class="left_col wide">
                <div class="form_fields clearfix hidden">
			        <div class="form_label"><label>Business Id</label></div>
			        <div class="form_input"><asp:TextBox ID="tbBusinessId" runat="server"></asp:TextBox></div>
		        </div>
                <div class="form_fields clearfix">
			        <div class="form_label"><label>Business name</label></div>
			        <div class="form_input"><asp:TextBox ID="tbBusinessName" runat="server" MaxLength="200"></asp:TextBox></div>
		        </div>
                <div class="form_fields clearfix">
			        <div class="form_label"><label>Community/City</label></div>
			        <div class="form_input"><asp:TextBox ID="tbCommunityName" runat="server" MaxLength="100"></asp:TextBox></div>
		        </div>
            </div>
            <div class="right_col wide">
                &nbsp;
            </div>
        </div>
        <div class="search_btn_bar clearfix">
			<asp:Button ID="btnFilter" runat="server" OnClick="btnFilter_OnClick" Text="Search" CssClass="search_btn" />  | <a id="lnkClearFilters" href="#">Clear</a>
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

    <asp:ListView ID="lvBusinesses" runat="server">
    <LayoutTemplate>
        <table border="0" cellpadding="0" cellspacing="0" class="tbl_data">
            <tr class="tbl_header">
                <td><strong>Business Name</strong></td>
                <td><strong>Primary Contact</strong></td>
                <td><strong>Telephone</strong></td>
                <td><strong>Email</strong></td>
            </tr>
            <div id="itemPlaceholder" runat="server" />
        </table>
  </LayoutTemplate>
    <ItemTemplate ><tr><td><a href="Edit.aspx?id=<%# Eval("businessId") %>"><%# Eval("businessName") %></a></td><td><%# Eval("primaryContactName") %></td><td><%# Eval("primaryContactPhone") %></td><td><%# Eval("primaryContactEmail") %></td></tr></ItemTemplate>
    </asp:ListView>

        <div class="pager_nav clearfix">
            <asp:DataPager runat="server" ID="dpBusinessPager" PageSize="20" PagedControlID="lvBusinesses">
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