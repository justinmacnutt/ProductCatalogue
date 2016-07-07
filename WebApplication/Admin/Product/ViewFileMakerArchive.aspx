<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewFileMakerArchive.aspx.cs" Inherits="WebApplication.Admin.Product.ViewFileMakerArchive" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
	<link href="../../Styles/prodCat.css" rel="stylesheet" type="text/css" />
</head>
<body style="background-color:#fff; background-image:none;">
    <form id="form1" runat="server">
    <div style="padding:20px;">
        <h1><asp:Literal ID="litProductName" runat="server"></asp:Literal></h1>
        <h2><asp:Literal ID="litProductType" runat="server"></asp:Literal></h2>
        <h3><asp:Literal ID="litPrimaryContact" runat="server"></asp:Literal></h3>
        
		<div style="padding-top:20px;border-top:1px solid #333;"><asp:Literal ID="litArchive" runat="server"></asp:Literal></div>
    </div>
    </form>
</body>
</html>
