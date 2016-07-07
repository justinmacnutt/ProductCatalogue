<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AuthWidget.ascx.cs" Inherits="WebApplication.UserControls.AuthWidget" %>
<asp:Panel ID="pnlLoggedIn" runat="server">
    
    <div class="task_nav clearfix">
	    <ul class="clearfix">
            
		    <li class="first"><a href="#">Welcome, <asp:Literal ID="litUserName" runat="server"></asp:Literal></a></li>
			<li class="last"><asp:LinkButton ID="btnLogout" runat="server" Text="Logout" OnClick="btnLogout_onClick" /></li>
		</ul>
	</div>
    


</asp:Panel>
