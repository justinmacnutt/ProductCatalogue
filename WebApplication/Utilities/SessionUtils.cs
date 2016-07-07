using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.SessionState;

namespace WebApplication.Utilities
{
    /// <summary>
    /// Wrapper class for <see cref=”HttpContext.Session”/>.
    /// </summary>
    /// <typeparam key=”T”>
    /// The type of the value to be stored.
    /// </typeparam>
    /// 
    /// 
    public class SessionVariable<T>
    {
        private readonly string key;
        private readonly Func<T> initializer;

        /// <summary>
        /// Initializes a new session variable.
        /// </summary>
        /// <param name=”key”>
        /// The key to use for storing the value in the session.
        /// </param>
        public SessionVariable(string key)
        {
            if (string.IsNullOrEmpty(key))
                throw new ArgumentNullException("key");

            this.key = GetType() + key;
        }

        /// <summary>
        /// Initializes a new session variable with a initializer.
        /// </summary>
        /// <param name=”key”>
        /// The key to use for storing the value in the session.
        /// </param>
        /// <param name=”initializer”>
        /// A function that is called in order to create a
        /// default value per session.
        /// </param>
        public SessionVariable(string key, Func<T> initializer)
            : this(key)
        {
            if (initializer == null)
                throw new ArgumentNullException("initializer");

            this.initializer = initializer;
        }

        private object GetInternalValue(bool initializeIfNessesary)
        {
            HttpSessionState session = CurrentSession;

            var value = session[key];

            if (value == null && initializeIfNessesary
              && initializer != null)
                session[key] = value = initializer();

            return value;
        }

        private static HttpSessionState CurrentSession
        {
            get
            {
                var current = HttpContext.Current;

                if (current == null)
                    throw new InvalidOperationException(
                      "No HttpContext is not available.");

                var session = current.Session;
                if (session == null)
                    throw new InvalidOperationException(
                      "No Session available on current HttpContext.");
                return session;
            }
        }

        /// <summary>
        /// Indicates wether there is a value present or not.
        /// </summary>
        public bool HasValue
        {
            get { return GetInternalValue(false) != null; }
        }

        /// <summary>
        /// Sets or gets the value in the current session.
        /// </summary>
        /// <exception cref=”InvalidOperationException”>
        /// If you try to get a value while none is set.
        /// Use <see cref=”ValueOrDefault”/> for safe access.
        /// </exception>
        public T Value
        {
            get
            {
                object v = GetInternalValue(true);

                if (v == null)
                    throw new InvalidOperationException(
                      "The session does not contain any value for ‘"
                      + key + "‘.");

                return (T)v;
            }
            set { CurrentSession[key] = value; }
        }

        /// <summary>
        /// Gets the value in the current session or if
        /// none is available <c>default(T)</c>.
        /// </summary>
        public T ValueOrDefault
        {
            get
            {
                object v = GetInternalValue(true);

                if (v == null)
                    return default(T);

                return (T)v;
            }
        }

        /// <summary>
        /// Clears the value in the current session.
        /// </summary>
        public void Clear()
        {
            CurrentSession.Remove(key);
        }
    }

    public class MySessionVariables
    {
        // public static readonly SessionVariable<string> FavouriteColour = new SessionVariable<string>("FavouriteColour");

        public static readonly SessionVariable<List<int>> ProductSearchItems = new SessionVariable<List<int>>("ProductSearchItems", () => new List<int>());

        public static SessionVariable<int> CurrentIndex = new SessionVariable<int>("CurrentIndex");

        // public static readonly SessionVariable<List<MyItineraryItem>> ItineraryItems = new SessionVariable<List<MyItineraryItem>>("ItineraryItems", () => new List<MyItineraryItem>());
        public static SessionVariable<SearchParameters> SearchParameters = new SessionVariable<SearchParameters>("SearchParameters");

        public static SessionVariable<ResearchSearchParameters> ResearchSearchParameters = new SessionVariable<ResearchSearchParameters>("ResearchSearchParameters");
    }

    public class ResearchSearchParameters
    {
        public string LicenseNumber { get; set; }
        public string ProductName { get; set; }
        public string ProductTypeId { get; set; }
    }

    public class SearchParameters
    {
        public SearchParameters()
        {
            FilterUnitList = new List<FilterUnit>();
            MediaUnitList = new List<MediaUnit>();
            LinkUnitList = new List<LinkUnit>();
        }
        
        public List<FilterUnit> FilterUnitList { get; set; }
        public List<MediaUnit> MediaUnitList { get; set; }
        public List<LinkUnit> LinkUnitList { get; set; }
        public string FilterOperator { get; set; }
        public string MediaOperator { get; set; }
        public string LinkOperator { get; set; }
        public string SearchString { get; set; }
        public bool SearchUnit { get; set; }
        public bool SearchPrint { get; set; }
        public bool SearchWeb { get; set; }
        public bool SearchLicenseNumber { get; set; }
        public bool SearchFileMakerId { get; set; }
        public bool SearchCheckInId { get; set; }
        public string NotesSearch { get; set; }
        public string NotesStartDate { get; set; }
        public string NotesEndDate { get; set; }
        public string ProductName { get; set; }
        public string ProductId { get; set; }
        public string ProductType { get; set; }
        public string Community { get; set; }
        public string Region { get; set; }
        public string GeneralArea { get; set; }
        public string BusinessName { get; set; }
        public string ContactFirstName { get; set; }
        public string ContactLastName { get; set; }
        public string ProductStatus { get; set; }
        public string CompletionStatus { get; set; }
        public string ValidationStatus { get; set; }
        public string ErrorsOverridden { get; set; }
        public string IsCheckInMember { get; set; }
        public string DisplayAdvancedSearchPanel { get; set; }
    }

    public class FilterUnit
    {
        public string FilterType { get; set; }
        public string FilterValue { get; set; }
        public string FilterStatus { get; set; }
    }

    public class MediaUnit
    {
        public string MediaType { get; set; }
        public string MediaStatus { get; set; }
    }

    public class LinkUnit
    {
        public string LinkType { get; set; }
        public string LinkStatus { get; set; }
    }
}