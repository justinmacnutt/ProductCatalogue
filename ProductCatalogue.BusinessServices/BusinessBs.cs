using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using ProductCatalogue.DataAccess;
using ProductCatalogue.DataAccess.Enumerations;

namespace ProductCatalogue.BusinessServices
{
    public class BusinessBs
    {
        private TourismDataContext db = new TourismDataContext(ConfigurationManager.ConnectionStrings["Tourism2ConnectionString"].ConnectionString);
        

        public Business GetParentBusinsess (Product p)
        {
            var query = from b in db.Businesses
                        join c in db.Contacts on b.id equals c.businessId
                        join cp in db.ContactProducts on c.id equals cp.contactId
                        where cp.productId == p.id && (c.isDeleted == false)
                        select b;

            return query.First();
        }

        public Contact GetPrimaryContact(Product p)
        {
            var query = from c in db.Contacts
                        join cp in db.ContactProducts on c.id equals cp.contactId
                        where cp.productId == p.id && cp.contactTypeId == 1 && (c.isDeleted == false)
                        select c;

            return (query.Count() > 0) ? query.First() : null;
        }

        //public Contact GetPrimaryContact(Business b)
        //{
        //    var query = from c in db.Contacts
        //                where c.businessId == b.id && c.contactTypeId == 1 && (c.isDeleted == false)
        //                select c;

        //    return query.First();
        //}

        public Business AddBusiness (string businessName, string description, string userId)
        {
            Business b = new Business();
            b.businessName = businessName;
            b.description = description;

            b.lastModifiedBy = userId;
            b.lastModifiedDate = DateTime.Now;

            db.Businesses.InsertOnSubmit(b);
            db.SubmitChanges();
            return b;
        }

        public IQueryable<Business> GetAllBusinesses()
        {
            return db.Businesses;
        }

        public IQueryable<Contact> GetAllContacts()
        {
            return db.Contacts;
        }

        public Business GetBusiness(int id)
        {
            return db.Businesses.SingleOrDefault(b => b.id == id);
        }

        public IQueryable<Address> GetContactAddresses(int contactId)
        {
            var query = from a in db.Addresses
                        join ca in db.ContactAddresses on a.id equals ca.addressId
                        where ca.contactId == contactId
                        select a;

            return query;
        }

        public IQueryable<Phone> GetContactPhones(int contactId)
        {
            var query = from p in db.Phones
                        join cp in db.ContactPhones on p.id equals cp.phoneId
                        where cp.contactId == contactId
                        select p;

            return query;
        }

        public IQueryable<Note> GetContactNotes(int contactId)
        {
            var query = from n in db.Notes
                        join cn in db.ContactNotes on n.id equals cn.noteId
                        where cn.contactId == contactId
                        orderby n.creationDate descending
                        select n;

            return query;
        }

        public IQueryable<Note> GetBusinessNotes(int businessId)
        {
            var query = from n in db.Notes
                        join bn in db.BusinessNotes on n.id equals bn.noteId
                        where bn.businessId == businessId
                        orderby n.creationDate descending
                        select n;

            return query;
        }

        public IQueryable<Address> GetBusinessAddresses(int businessId)
        {
            var query = from a in db.Addresses
                        join ba in db.BusinessAddresses on a.id equals ba.addressId
                        where ba.businessId == businessId
                        select a;

            return query;
        }

        public IQueryable<Contact> GetBusinessContacts(int businessId)
        {
            var query = from c in db.Contacts
                        where c.businessId == businessId && (c.isDeleted == false)
                        select c;

            return query;
        }

        public IQueryable<Contact> GetBusinessContacts(int businessId, int productId)
        {
            // returns a list of contacts for a business that are not currently associated with the passed productid

            var query = (from c in db.Contacts
                         where c.businessId == businessId && (c.isDeleted == false)
                         select c).Except(from c in db.Contacts
                                          join cp in db.ContactProducts on c.id equals cp.contactId
                                          where c.businessId == businessId && cp.productId == productId
                                          select c);
                         
            return query;
        }

        public void SetBusinessPrimaryContact (int businessId, int contactId)
        {
            var query = from c in db.Contacts where (c.isDeleted == false) && c.businessId == businessId select c;
            foreach (var contact in query)
            {
                contact.isPrimary = (contact.id == contactId);
            }

            db.SubmitChanges();
        }

        public Address GetAddress(int id)
        {
            return db.Addresses.SingleOrDefault(a => a.id == id);
        }

        public Phone GetPhone(int id)
        {
            return db.Phones.SingleOrDefault(p => p.id == id);
        }

        public void Save()
        {
            db.SubmitChanges();
        } 

        public Contact GetContact(int id)
        {
            return db.Contacts.SingleOrDefault(c => c.id == id);
        }

        public Note GetNote(int id)
        {
            return db.Notes.SingleOrDefault(c => c.id == id);
        }

        public Address AddAddress(Business b, byte addressTypeId, string line1, string line2, string line3, string city, string provinceStateId, string otherRegion, string postalCode, string countryId, string userId )
        {
            Address a = new Address();
            a.line1 = line1;
            a.line2 = line2;
            a.line3 = line3;
            a.addressTypeId = addressTypeId;
            a.city = city;
            a.postalCode = postalCode;
            a.otherRegion = otherRegion;
            
            a.provinceStateId = provinceStateId;
            a.countryId = countryId;

            a.lastModifiedBy = userId;
            a.lastModifiedDate = DateTime.Now;

            db.Addresses.InsertOnSubmit(a);
            db.SubmitChanges();

            BusinessAddress ba = new BusinessAddress();
            ba.addressId = a.id;
            ba.businessId = b.id;
            db.BusinessAddresses.InsertOnSubmit(ba);
            db.SubmitChanges();
            return a;
        }

        public void DeleteBusinessAddress(int addressId)
        {
            var q = from ba in db.BusinessAddresses
                    where ba.addressId == addressId
                    select ba;
            db.BusinessAddresses.DeleteAllOnSubmit(q);
            
            Address a = GetAddress(addressId);
            db.Addresses.DeleteOnSubmit(a);
            db.SubmitChanges();
        }

        public void DeleteContactAddress(int addressId)
        {
            var q = from ca in db.ContactAddresses
                    where ca.addressId == addressId
                    select ca;
            db.ContactAddresses.DeleteAllOnSubmit(q);

            Address a = GetAddress(addressId);
            db.Addresses.DeleteOnSubmit(a);
            db.SubmitChanges();
        }

        //public void DeleteAddress(Contact c, int addressId)
        //{
        //    Address a = GetAddress(addressId);
        //    db.Addresses.DeleteOnSubmit(a);
        //    db.SubmitChanges();
        //}

        public Contact AddContact(int businessId, byte businessContactTypeId, string firstName, string lastName, string jobTitle, string email, string comments, string userId)
        {
            Contact c = new Contact();
            
            c.firstName = firstName;
            c.lastName = lastName;
            c.jobTitle = jobTitle;
            c.email = email;
            c.comment = comments;
            c.businessId = businessId;
            c.contactTypeId = businessContactTypeId;

            c.lastModifiedBy = userId;
            c.lastModifiedDate = DateTime.Now;

            //if this is the first contact then make it primary
            var cc = GetBusinessContacts(businessId).Count();
            c.isPrimary = (cc == 0);

            db.Contacts.InsertOnSubmit(c);
            db.SubmitChanges();

            return c;
        }

        public Address AddAddress(Contact c, byte addressTypeId, string line1, string line2, string line3, string city, string provinceStateId, string postalCode, string otherRegion, string countryId, string userId)
        {
            Address a = new Address();
            a.line1 = line1;
            a.line2 = line2;
            a.line3 = line3;
            a.addressTypeId = addressTypeId;
            a.city = city;
            a.postalCode = postalCode;
            a.provinceStateId = provinceStateId;
            a.otherRegion = otherRegion;
            a.countryId = countryId;

            a.lastModifiedBy = userId;
            a.lastModifiedDate = DateTime.Now;

            db.Addresses.InsertOnSubmit(a);
            db.SubmitChanges();

            ContactAddress ca = new ContactAddress();
            ca.addressId = a.id;
            ca.contactId = c.id;
            db.ContactAddresses.InsertOnSubmit(ca);
            db.SubmitChanges();
            return a;
        }

        public Phone AddPhone (Contact c, byte phoneTypeId, string phoneNumber, string phoneComment, string userId)
        {
            Phone p = new Phone();
            p.phoneTypeId = phoneTypeId;
            p.phoneNumber = phoneNumber;
            p.comment = phoneComment;

            p.lastModifiedBy = userId;
            p.lastModifiedDate = DateTime.Now;

            db.Phones.InsertOnSubmit(p);
            db.SubmitChanges();

            ContactPhone cp = new ContactPhone();
            cp.contactId = c.id;
            cp.phoneId = p.id;
            db.ContactPhones.InsertOnSubmit(cp);
            db.SubmitChanges();
            return p;
        }

        public Note AddNote(Contact c, string note, DateTime? reminderDate, string userId)
        {
            Note n = new Note();
            n.noteBody = note;
            n.reminderDate = reminderDate;
            n.creationDate = DateTime.Now;

            n.lastModifiedBy = userId;
            n.lastModifiedDate = DateTime.Now;

            db.Notes.InsertOnSubmit(n);
            db.SubmitChanges();

            ContactNote cn = new ContactNote();
            cn.contactId = c.id;
            cn.noteId = n.id;
            db.ContactNotes.InsertOnSubmit(cn);
            db.SubmitChanges();
            return n;
        }

        public Note AddNote(Business b, string note, DateTime? reminderDate, string userId)
        {
            Note n = new Note();
            n.noteBody = note;
            n.reminderDate = reminderDate;
            n.creationDate = DateTime.Now;

            n.lastModifiedBy = userId;
            n.lastModifiedDate = DateTime.Now;

            db.Notes.InsertOnSubmit(n);
            db.SubmitChanges();

            BusinessNote bn = new BusinessNote();
            bn.businessId = b.id;
            bn.noteId = n.id;
            db.BusinessNotes.InsertOnSubmit(bn);
            db.SubmitChanges();
            
            return n;
        }

        public void CancelNoteReminder (int noteId)
        {
            Note n = GetNote(noteId);
            n.reminderDate = null;
            db.SubmitChanges();
        }

        public List<SearchBusinessesResult> SearchBusinesses(int businessId, string businessName, string communityName, string filterLetter)
        {
            return db.SearchBusinesses(businessId, businessName, communityName, filterLetter).ToList();
        }

        public IQueryable<Business> SearchBusinesses(string businessName, string communityName, string filterLetter)
        {
            var query = from b in db.Businesses
                        where (businessName == "" || b.businessName.Contains(businessName))
                              && (filterLetter == "" || b.businessName.StartsWith(filterLetter))
                        select b;

            if (communityName != "")
            {
                query = (from b in query
                         join ba in db.BusinessAddresses on b.id equals ba.businessId
                         join a in db.Addresses on ba.addressId equals a.id
                         where a.city.Contains(communityName)
                         select b).Distinct();
            }

            query = from b in query
                    orderby b.businessName
                    select b;

            return query;

        }

       


        public List<SearchContactsResult> SearchContacts(int contactId, string firstName, string lastName, string telephone, string email, string businessName, string communityName, string filterLetter)
        {
            return db.SearchContacts(contactId, firstName, lastName, telephone, email, businessName, communityName,
                                     filterLetter).ToList();
        }

        public IQueryable<Contact> SearchContacts(string firstName, string lastName, string telephone, string email, string businessName, string communityName, string filterLetter)
        {
            var query = from c in db.Contacts
                        where (firstName == "" || c.firstName.Contains(firstName))
                              && (lastName == "" || c.firstName.Contains(lastName))
                              && (email == "" || c.email.Contains(email))
                              && (filterLetter == "" || c.lastName.StartsWith(filterLetter))
                        select c;

            if (businessName != "")
            {
                query = from c in query
                        join b in db.Businesses on c.businessId equals b.id
                        where b.businessName.Contains(businessName)
                        select c; 
            }

            if (communityName != "")
            {
                query = (from c in query
                        join ca in db.ContactAddresses on c.id equals ca.contactId
                        join a in db.Addresses on ca.addressId equals a.id
                        where a.city.Contains(communityName)
                        select c).Distinct();
            }

            if (telephone != "")
            {
                query = (from c in query
                         join cp in db.ContactPhones on c.id equals cp.contactId
                         join p in db.Phones on cp.phoneId equals p.id
                         where p.phoneNumber.Contains(telephone)
                         select c).Distinct();
            }

            query = from c in query
                    orderby c.lastName , c.lastName
                    select c;

            return query;
                        
        }

        //public List<SearchContactsResult> SearchContacts(int contactId, string firstName, string lastName, string telephone, string email, int region, string filterLetter)
        //{
        //    return db.SearchContacts(businessId, businessName, filterLetter).ToList();
        //}
       
        public IQueryable<Business> GetBusinesses(int businessId, string businessName)
        {
            var query = from b in db.Businesses
                        select b;

            if (businessId != -1)
            {
                query = from b in query
                        where b.id == businessId
                        select b;
            }

            if (businessName != "")
            {
                //query.Where(p => p.productName.Contains(productName));
                query = from b in query
                        where b.businessName.Contains(businessName)
                        select b;
            }

            return query;
        }

        public IQueryable<Contact> GetContacts(int contactId, string firstName, string lastName, string businessName)
        {
            var query = from c in db.Contacts
                        where c.isDeleted == false
                        select c;

            if (contactId != -1)
            {
                query = from c in query
                        where c.id == contactId
                        select c;
            }

            if (lastName != "")
            {
                //query.Where(p => p.productName.Contains(productName));
                query = from c in query
                        where c.lastName.Contains(lastName)
                        select c;
            }

            if (firstName != "")
            {
                //query.Where(p => p.productName.Contains(productName));
                query = from c in query
                        where c.firstName.Contains(firstName)
                        select c;
            }

            if (businessName != "")
            {
                //query.Where(p => p.productName.Contains(productName));
                query = from c in query
                        join b in db.Businesses on c.businessId equals b.id
                        where b.businessName.Contains(businessName)
                        select c;
            }

            return query;
        }


        public void DeleteContactPhone(int phoneId)
        {
            var q = from cp in db.ContactPhones
                    where cp.phoneId == phoneId
                    select cp;
            db.ContactPhones.DeleteAllOnSubmit(q);

            Phone p = GetPhone(phoneId);
            db.Phones.DeleteOnSubmit(p);
            db.SubmitChanges();
        }

        public int GetBusinessId(string businessName)
        {
            if (businessName != "")
            {
                var query = from b in db.Businesses
                            where b.businessName.Equals(businessName) && !b.isDeleted
                            select b;

                if (query.Count() > 0)
                    return query.First().id;
            }

            return -1;
        }

        public Boolean IsBusinessInUse (int businessId)
        {
            var query = from c in db.Contacts
                        join cp in db.ContactProducts on c.id equals cp.contactId
                        where c.businessId == businessId && cp.contactTypeId == 1
                        select c;

            return query.Count() > 0;
        }

        public void DeleteContact (int contactId, string userId)
        {
            Contact c = GetContact(contactId);
            c.isDeleted = true;

            c.lastModifiedBy = userId;
            c.lastModifiedDate = DateTime.Now;

            db.SubmitChanges();

        }

        public void DeleteBusiness(int businessId, string userId)
        {
            Business b = GetBusiness(businessId);
            b.isDeleted = true;

            b.lastModifiedBy = userId;
            b.lastModifiedDate = DateTime.Now;

            db.SubmitChanges();
        }
    }
}
