using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Security;

using System.DirectoryServices;


namespace ProductCatalogue.MembershipServices
{
    public class ProductCatalogueADMembershipProvider : MembershipProvider
    {
        //MembershipDataContext db = new MembershipDataContext();

        public override MembershipUser CreateUser(string username, string password, string email, string passwordQuestion, string passwordAnswer, bool isApproved, object providerUserKey, out MembershipCreateStatus status)
        {
            //MembershipRepository mr = new MembershipRepository();
            //UserProfile up = mr.CreateUserProfile(username, password, email);
            //status = MembershipCreateStatus.Success;
            //return GetMembershipUser(up);
            throw new NotImplementedException();
        }

        public override bool ChangePasswordQuestionAndAnswer(string username, string password, string newPasswordQuestion, string newPasswordAnswer)
        {
            throw new NotImplementedException();
        }

        public override string GetPassword(string username, string answer)
        {
            throw new NotImplementedException();
        }

        public override bool ChangePassword(string username, string oldPassword, string newPassword)
        {
            throw new NotImplementedException();
        }

        public override string ResetPassword(string username, string answer)
        {
            throw new NotImplementedException();
        }

        public override void UpdateUser(MembershipUser user)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateUser(string username, string password)
        {
            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password) || username.Length > 100) return false;

            String domain = Properties.Settings.Default.LDAPDomain;
            String domainAndUsername = String.Format("{0}\\{1}", domain, username);
            String path = Properties.Settings.Default.LDAPServer;

            DirectoryEntry entry = new DirectoryEntry(path, domainAndUsername, password);

            try {
            
                //Bind to the native AdsObject to force authentication.
                Object obj = entry.NativeObject;
                DirectorySearcher search = new DirectorySearcher(entry);

                search.Filter = String.Format("(SAMAccountName={0})", username);
                SearchResult result = search.FindOne();

                return (result == null) ? false : true;
            }

            catch (DirectoryServicesCOMException dscEx) {
                // AD throws a DirectoryServicesCOMException exception when the user cannot be validated
                // Message is -> Logon failure: unknown user name or bad password.

                return false;
            }

            catch (Exception ex) {
                // catch all
                 return false;
            }

        }

        public override bool UnlockUser(string userName)
        {
            throw new NotImplementedException();
        }

        public override MembershipUser GetUser(object providerUserKey, bool userIsOnline)
        {
            throw new NotImplementedException();
            
        }

        public override MembershipUser GetUser(string username, bool userIsOnline)
        {
            MembershipRepository mr = new MembershipRepository();
            UserProfile up = mr.GetUserProfile(username);

            return GetMembershipUser(up);
        }


        public override string GetUserNameByEmail(string email)
        {
            throw new NotImplementedException();
        }

        public override bool DeleteUser(string username, bool deleteAllRelatedData)
        {
            throw new NotImplementedException();
        }

        public override MembershipUserCollection GetAllUsers(int pageIndex, int pageSize, out int totalRecords)
        {
            throw new NotImplementedException();
        }

        public override int GetNumberOfUsersOnline()
        {
            throw new NotImplementedException();
        }

        public override MembershipUserCollection FindUsersByName(string usernameToMatch, int pageIndex, int pageSize, out int totalRecords)
        {
            throw new NotImplementedException();
        }

        public override MembershipUserCollection FindUsersByEmail(string emailToMatch, int pageIndex, int pageSize, out int totalRecords)
        {
            throw new NotImplementedException();
        }

        public override bool EnablePasswordRetrieval
        {
            get { throw new NotImplementedException(); }
        }

        public override bool EnablePasswordReset
        {
            get { throw new NotImplementedException(); }
        }

        public override bool RequiresQuestionAndAnswer
        {
            get { throw new NotImplementedException(); }
        }

        public override string ApplicationName
        {
            get { throw new NotImplementedException(); }
            set { throw new NotImplementedException(); }
        }

        public override int MaxInvalidPasswordAttempts
        {
            get { throw new NotImplementedException(); }
        }

        public override int PasswordAttemptWindow
        {
            get { throw new NotImplementedException(); }
        }

        public override bool RequiresUniqueEmail
        {
            get { throw new NotImplementedException(); }
        }

        public override MembershipPasswordFormat PasswordFormat
        {
            get { throw new NotImplementedException(); }
        }

        public override int MinRequiredPasswordLength
        {
            get { return 2; }
        }

        public override int MinRequiredNonAlphanumericCharacters
        {
            get { throw new NotImplementedException(); }
        }

        public override string PasswordStrengthRegularExpression
        {
            get { throw new NotImplementedException(); }
        }

        private MembershipUser GetMembershipUser(UserProfile up)
        {
            return new MembershipUser(this.Name, up.username, up.id, up.email, "", "", true, false, up.creationDate, DateTime.Now, DateTime.Now, DateTime.Now, DateTime.Now);
        }
    }
}
