using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ProductCatalogue.BusinessServices;
using ProductCatalogue.DataAccess;
using ProductCatalogue.DataAccess.Enumerations;
using WebApplication.Utilities;
using WebApplication.ValueObjects;
using ContactSearchListItem = WebApplication.ValueObjects.ListItemVos.ContactSearchListItem;

namespace WebApplication.Admin.Contact
{
    public partial class Index : System.Web.UI.Page
    {
        private string[] letters = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K",
                     "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V",
                     "W", "X", "Y", "Z"};

        protected override void OnPreRender(EventArgs e)
        {
            lvContacts.DataSource = GenerateContactList();
            lvContacts.DataBind();
            base.OnPreRender(e);
        }

        private List<ListItemVos.ContactSearchListItem> GenerateContactList()
        {
            BusinessBs businessBs = new BusinessBs();
            //IQueryable<ProductCatalogue.DataAccess.Product> productList = productBs.GetAllProducts();
            //IQueryable<ProductCatalogue.DataAccess.Product> productList = productBs.GetProducts(-1, "", "", "Aber", -1, -1, -1);
            
            //List<SearchBusinessesResult> businessList = businessBs.SearchBusinesses(businessId, tbBusinessName.Text, hdnLetterFilter.Value);
            List<SearchContactsResult> contactList = businessBs.SearchContacts(-1, tbFirstName.Text,
                                                                               tbLastName.Text, tbPhone.Text,
                                                                               tbEmail.Text, tbBusinessName.Text,
                                                                               tbCommunity.Text, hdnLetterFilter.Value);
            //IQueryable<ProductCatalogue.DataAccess.Contact> contactList = businessBs.GetContacts(contactId, tbFirstName.Text, tbLastName.Text, tbBusinessName.Text);)

            List<ListItemVos.ContactSearchListItem> cl = new List<ContactSearchListItem>();
            foreach (var c in contactList)
            {
                var cli = new ContactSearchListItem();
                
                cli.contactName = String.Format("{0}, {1}", c.lastName, c.firstName);
                cli.contactType = ResourceUtils.GetBusinessContactTypeLabel((BusinessContactType)c.contactTypeId);
                cli.email = c.email;
                cli.contactId = c.contactId.ToString();
                cli.jobTitle = c.jobTitle;
                cli.telephone = c.phoneNumber;

                //ProductCatalogue.DataAccess.Contact contact = businessBs.GetContact(c.contactId);
                //cli.productList = GenerateProductList(contact);
                
                cl.Add(cli);
            }

            //return businessList;
            return cl;
        }

        private List<ListItemVos.ProductListItem> GenerateProductList(ProductCatalogue.DataAccess.Contact c)
        {

            ProductBs productBs = new ProductBs();
            List<ProductCatalogue.DataAccess.Product> pl = productBs.GetProducts(c).ToList();

            List<ListItemVos.ProductListItem> theList = new List<ListItemVos.ProductListItem>();

            foreach (ProductCatalogue.DataAccess.Product p in pl)
            {
                ListItemVos.ProductListItem pli = new ListItemVos.ProductListItem();
//                pli.productCommunity = "HALI";
                pli.productName = p.productName;
                pli.productId = p.id.ToString();

                theList.Add(pli);
            }

            return theList;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //BusinessBs businessBs = new BusinessBs();

                //ddlParentBusiness.DataSource = businessBs.GetAllBusinesses();
                //ddlParentBusiness.DataTextField = "businessName";
                //ddlParentBusiness.DataValueField = "id";
                //ddlParentBusiness.DataBind();
                //ddlParentBusiness.Items.Insert(0, new ListItem("Please Select", "-1"));
            }

            rptLetters.DataSource = letters.ToList();
            rptLetters.DataBind();

        }

        protected void lnkLetter_OnClick(object sender, EventArgs e)
        {
            LinkButton lb = (LinkButton)sender;

            hdnLetterFilter.Value = lb.CommandArgument;
            dpContactPager.SetPageProperties(0, 20, false);
        }

        protected void btnFilter_OnClick(object sender, EventArgs e)
        {
            hdnLetterFilter.Value = "";
            //ProductBs productBs = new ProductBs();
            //productBs.GetProducts(-1, "", "", "Aber", -1, -1, -1);
        }
    }
}