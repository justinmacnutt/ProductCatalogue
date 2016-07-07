using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using ProductCatalogue.MembershipServices;

namespace WebApplication
{
    public partial class Login : System.Web.UI.Page
    {
        //public IFormsAuthentication FormsAuth
        //{
        //    get;
        //    private set;
        //}

        //public IMembershipService MembershipService
        //{
        //    get;
        //    private set;
        //}

        //protected void Page_Load(object sender, EventArgs e)
        //{
        //    FormsAuth = new FormsAuthenticationService();
        //    MembershipService = new AccountMembershipService();
        //}

        protected void btnSubmit_onClick(object sender, EventArgs e)
        {
            //if( MembershipService.ValidateUser(tbUserName.Text,tbPassword.Text))
            //{
            //    FormsAuth.SignIn(tbUserName.Text, true);

            //    if (!String.IsNullOrEmpty(Request.QueryString["ReturnUrl"]))
            //    {
            //        Response.Redirect(Request.QueryString["ReturnUrl"]);
            //    }
            //    else
            //    {
            //        Response.Redirect("~/Admin/Business/Index.aspx");
            //    }
            //}

            //if (Membership.ValidateUser(tbUserName.Text, tbPassword.Text))
            //{
            //    FormsAuthentication.SetAuthCookie(tbUserName.Text, true);

            //    if (!String.IsNullOrEmpty(Request.QueryString["ReturnUrl"]))
            //    {
            //        Response.Redirect(Request.QueryString["ReturnUrl"]);
            //    }
            //    else
            //    {
            //        Response.Redirect("~/Admin/Business/Index.aspx");
            //    }
            //}

            string commaSeperatedRoles = string.Empty;

            //Authenticate user against the user database and obtain comma seperated roles
            if (!UserAuthentication.Instance.AuthenticateUser(tbUserName.Text, tbPassword.Text, out commaSeperatedRoles))
            {
               // lblLoginFailed.Visible = true;
                return;
            }

            //Instead of FormsAuthentication.RedirectFromLoginPage(txtUser.Text, false);
            //Use the following code
            FormsAuthenticationUtil.RedirectFromLoginPage(tbUserName.Text, commaSeperatedRoles, true);
        }

        
    }


    // public interface IFormsAuthentication
    //{
    //    void SignIn(string userName, bool createPersistentCookie);
    //    void SignOut();
    //}

    //public class FormsAuthenticationService : IFormsAuthentication
    //{
    //    public void SignIn(string userName, bool createPersistentCookie)
    //    {
    //        FormsAuthentication.SetAuthCookie(userName, createPersistentCookie);
    //    }
    //    public void SignOut()
    //    {
    //        FormsAuthentication.SignOut();
    //    }
    //}

    //public interface IMembershipService
    //{
    //    int MinPasswordLength { get; }
    //    MembershipUser GetUser(string username);
    //    bool ValidateUser(string userName, string password);
    //    MembershipCreateStatus CreateUser(string userName, string password, string email);
    //    bool ChangePassword(string userName, string oldPassword, string newPassword);
    //}

    //public class AccountMembershipService : IMembershipService
    //{
    //    private MembershipProvider _provider;

    //    public AccountMembershipService()
    //        : this(null)
    //    {
    //    }

    //    public AccountMembershipService(MembershipProvider provider)
    //    {
    //        _provider = provider ?? Membership.Provider;
    //    }

    //    public int MinPasswordLength
    //    {
    //        get
    //        {
    //            return _provider.MinRequiredPasswordLength;
    //        }
    //    }

    //    public bool ValidateUser(string userName, string password)
    //    {
    //        return _provider.ValidateUser(userName, password);
    //    }

    //    public MembershipUser GetUser(string username)
    //    {
    //        return _provider.GetUser(username,false);
    //    }

    //    public MembershipCreateStatus CreateUser(string userName, string password, string email)
    //    {
    //        MembershipCreateStatus status;
    //        _provider.CreateUser(userName, password, email, null, null, true, null, out status);
    //        return status;
    //    }

    //    public bool ChangePassword(string userName, string oldPassword, string newPassword)
    //    {
    //        MembershipUser currentUser = _provider.GetUser(userName, true /* userIsOnline */);
    //        return currentUser.ChangePassword(oldPassword, newPassword);
    //    }
    //}
}