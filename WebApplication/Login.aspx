<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebApplication.Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml"> 
<head id="Head1" runat="server">  
    <title>Product Catalogue</title>
    <link href="Styles/prodCat.css" rel="stylesheet" type="text/css" /> 
</head> 
<body id="ProdCat_login">  
<form id="form1" runat="server">
	<div id="main_wrap" class="clearfix"><div id="body_wrap" class="clearfix">
        <div id="login_form">
            <h3>Product Catalog /// Login</h3>
            <strong>Username</strong><br />
            <asp:TextBox ID="tbUserName" runat="server"></asp:TextBox>
            <br /><br />
            <strong>Password</strong><br />
            <asp:TextBox ID="tbPassword" TextMode="Password" runat="server"></asp:TextBox>
            <br /><br /><asp:button ID="btnSubmit" runat="server" text="Submit" OnClick="btnSubmit_onClick"/>
        </div>
    </div></div>
</form>
</body> 
</html> 
