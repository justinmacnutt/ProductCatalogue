using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ProductCatalogue.MembershipServices
{
    public class MembershipRepository
    {
        MembershipDataContext db = new MembershipDataContext();

        public UserProfile CreateUserProfile(string username, string password, string email)
        {
            UserProfile up = new UserProfile();
            up.username = username;
            up.password = password;
            up.email = email;
            up.creationDate = DateTime.Now;

            db.UserProfiles.InsertOnSubmit(up);
            db.SubmitChanges();

            return up;
        }

        public UserProfile GetUserProfile(string username, string password)
        {
            var s = db.UserProfiles.SingleOrDefault(up => up.username == username && up.password == password);
            return s;
        }

        public UserProfile GetUserProfile(string username)
        {
            var s = db.UserProfiles.SingleOrDefault(up => up.username.ToLower() == username.ToLower());
            return s;
        }

        public List<GetRolesForUserResult> GetRolesForUser(string username)
        {
            return db.GetRolesForUser(username).ToList();
        }
    }
}
