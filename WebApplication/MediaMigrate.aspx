<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MediaMigrate.aspx.cs" Inherits="WebApplication.MediaMigrate" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        Media Date: <asp:TextBox ID="tbMediaDate" runat="server"></asp:TextBox> <br />
        Product Type: <asp:TextBox ID="tbProductType" runat="server"></asp:TextBox> <br />
        <asp:Button ID="btnSubmit" runat="server" OnClick="btnSubmit_OnClick" />
    </div>
    </form>
</body>
</html>
