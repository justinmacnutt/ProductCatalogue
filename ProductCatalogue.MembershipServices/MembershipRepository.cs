using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.Security.Cryptography;

namespace ProductCatalogue.MembershipServices
{
    public class MembershipRepository
    {
        MembershipDataContext db = new MembershipDataContext(ConfigurationManager.ConnectionStrings["Tourism2ConnectionString"].ConnectionString);

        public UserProfile CreateUserProfile(string username, string password, string email)
        {
            var myNewPasswordSalt = CreateSalt();

            var myUser = new UserProfile()
            {
                passwordSalt = myNewPasswordSalt,
                email = email,
                passwordHash = EncryptPassword(password, myNewPasswordSalt),
                username = email,
                creationDate = DateTime.Now
            };

            db.UserProfiles.InsertOnSubmit(myUser);
            db.SubmitChanges();

            return myUser;
        }

        public UserProfile GetUserProfile(string username, string password)
        {
            //var s = db.UserProfiles.SingleOrDefault(up => up.username == username && up.password == password);
            //return s;

            var myUser = db.UserProfiles.SingleOrDefault(up => up.username == username);

            var loginSuccess = string.Equals(EncryptPassword(password, myUser.passwordSalt), myUser.passwordHash);

            if (loginSuccess)
            {
                return myUser;
            }

            return null;
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

        /// <summary>
        ///     Encrypts a password using the given salt
        /// </summary>
        /// <param name="password"></param>
        /// <param name="salt"></param>
        /// <returns></returns>
        private static string EncryptPassword(string password, string salt)
        {
            using (var sha256 = SHA256.Create())
            {
                var saltedPassword = string.Format("{0}{1}", salt, password);
                var saltedPasswordAsBytes = System.Text.Encoding.UTF8.GetBytes(saltedPassword);
                return Convert.ToBase64String(sha256.ComputeHash(saltedPasswordAsBytes));
            }
        }

        /// <summary>
        ///     Creates a random salt to be used for encrypting a password
        /// </summary>
        /// <returns></returns>
        private static string CreateSalt()
        {
            var data = new byte[0x10];

            var cryptoServiceProvider = new RNGCryptoServiceProvider();
            cryptoServiceProvider.GetBytes(data);
            return Convert.ToBase64String(data);


            /*
            using (var cryptoServiceProvider = new RNGCryptoServiceProvider())
            {
                cryptoServiceProvider.GetBytes(data);
                return Convert.ToBase64String(data);
            }
            */
        }
    }
}
