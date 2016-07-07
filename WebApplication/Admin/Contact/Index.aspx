<%@ Page Language="C#" MasterPageFile="~/prodCat.master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="WebApplication.Admin.Contact.Index" %>

<asp:Content ID="cHeadContent" ContentPlaceHolderID="cphHeadContent" Runat="Server"> 
    <script type="text/javascript">
        $(document).ready(function () {
            $("[id*=mn_contacts]").addClass("current");

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
            $("[id*=tbBusinessName]").val('');
            $("[id*=tbContactId]").val('');
            $("[id*=tbFirstName]").val('');
            $("[id*=tbLastName]").val('');
            $("[id*=tbEmail]").val('');
            $("[id*=tbCommunity]").val('');
            $("[id*=tbPhone]").val('');
        }
    </script>
</asp:Content> 
<asp:Content ID="cMainContent" ContentPlaceHolderID="cphMainContent" Runat="Server"> 
    <div class="page_header clearfix">
		<h2 class="page_title">Contacts</h2>
	</div>
        <div class="col_wrap clearfix">
            <div class="left_col wide">
                <div class="form_fields clearfix">
			        <div class="form_label"><label>Business name</label></div>
			        <div class="form_input"><asp:TextBox ID="tbBusinessName" runat="server" MaxLength="200"></asp:TextBox></div>
		        </div>
                <div class="form_fields clearfix">
			        <div class="form_label"><label>First Name</label></div>
			        <div class="form_input"><asp:TextBox ID="tbFirstName" runat="server" MaxLength="100"></asp:TextBox></div>
		        </div>
                <div class="form_fields clearfix">
			        <div class="form_label"><label>Last Name</label></div>
			        <div class="form_input"><asp:TextBox ID="tbLastName" runat="server" MaxLength="100"></asp:TextBox></div>
		        </div>
            </div>
            <div class="right_col wide">
                <div class="form_fields clearfix">
			        <div class="form_label"><label>Email</label></div>
			        <div class="form_input"><asp:TextBox ID="tbEmail" runat="server" MaxLength="100"></asp:TextBox></div>
		        </div>
                <div class="form_fields clearfix">
			        <div class="form_label"><label>Community/City</label></div>
			        <div class="form_input"><asp:TextBox ID="tbCommunity" runat="server" MaxLength="100"></asp:TextBox></div>
		        </div>
                <div class="form_fields clearfix">
			        <div class="form_label"><label>Primary phone</label></div>
			        <div class="form_input"><asp:TextBox ID="tbPhone" runat="server" MaxLength="30" CssClass="phone_field"></asp:TextBox></div>
		        </div>
            </div>
        </div>

        <div class="search_btn_bar clearfix">
			<asp:Button ID="btnFilter" runat="server" OnClick="btnFilter_OnClick" Text="Search" CssClass="search_btn" /> | <a id="lnkClearFilters" href="#">Clear</a>
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

        <asp:ListView ID="lvContacts" runat="server" >
                <LayoutTemplate>
                    <table border="0" cellpadding="0" cellspacing="0" class="tbl_data">
                        <tr class="tbl_header">
                            <td><strong>Contact Name</strong></td>
                            <td><strong>Type</strong></td>
                            <td><strong>Title</strong></td>
                            <td><strong>Primary Phone</strong></td>
                            <td><strong>Email</strong></td>
                        </tr>
                        <div id="itemPlaceholder" runat="server" />
                    </table>
                </LayoutTemplate>
                <ItemTemplate >
                    <tr>
                        <td><a href='Edit.aspx?id=<%# Eval("contactId") %>'><%# Eval("contactName") %></a></td>
                        <td><%# Eval("contactType") %></td>
                        <td><%# Eval("jobTitle") %></td>
                        <td><%# Eval("telephone") %></td>
                        <td><%# Eval("email") %></td>
                        <td> 
                            <asp:ListView ID="lvP2roducts" runat="server" DataSource='<%# Eval("productList") %>' ItemPlaceholderID="itemPlaceholder2">
                                <LayoutTemplate>
                                    <table border="0" cellpadding="0" cellspacing="0">
                                        <div id="itemPlaceholder2" runat="server" />
                                    </table>
                                </LayoutTemplate>
                                <ItemTemplate >
                                    <tr>
                                        <td><a href="../Product/Edit.aspx?id=<%# Eval("productId") %>"><%# Eval("productName") %></a></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:ListView>   
                        </td>
                    </tr>
                </ItemTemplate>
            </asp:ListView>
   
        <div class="pager_nav clearfix">
            <asp:DataPager runat="server" ID="dpContactPager" PageSize="20" PagedControlID="lvContacts">
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
