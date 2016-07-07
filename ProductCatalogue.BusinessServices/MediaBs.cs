using System;
using System.Web;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Linq.SqlClient;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml.Linq;
using ProductCatalogue.DataAccess;
using ProductCatalogue.DataAccess.Enumerations;
using Action = ProductCatalogue.DataAccess.Enumerations.Action;

namespace ProductCatalogue.BusinessServices
{
    public class MediaBs
    {
        private TourismDataContext db = new TourismDataContext(ConfigurationManager.ConnectionStrings["Tourism2ConnectionString"].ConnectionString);
        
        public Media AddMedia (string originalFileName, string fileExtension, byte? mediaLanguageId, byte mediaTypeId, int productId, string userId)
        {
            Media m = new Media();

            m.originalFileName = originalFileName;
            m.fileExtension = fileExtension;
            m.mediaLanguageId = mediaLanguageId;
            m.mediaTypeId = mediaTypeId;
            m.productId = productId;

            m.lastModifiedBy = userId;
            m.lastModifiedDate = DateTime.Now;

            //m.sortOrder = (mediaTypeId == (byte) MediaType.PhotoViewer) ? 100 : (byte?)null;
            m.sortOrder = (mediaTypeId == (byte)MediaType.PhotoViewer) ? (byte)GetNextSortOrder(productId) : (byte?)null;

            db.Medias.InsertOnSubmit(m);
            
            db.SubmitChanges();
            return m;
        }

        private int GetNextSortOrder(int productId)
        {
            IQueryable<Media> mq = GetProductMedia(productId, MediaType.PhotoViewer);

            return (from m in mq select (int?)m.sortOrder).Max() + 1 ?? 1;
        }

        public Media AddMediaTranslation (Media m, string language, string title, string caption)
        {
            MediaTranslation mt = new MediaTranslation();
            mt.mediaTitle = title;
            mt.caption = caption;
            
            mt.mediaId = m.id;
            mt.languageId = language;

            m.MediaTranslations.Add(mt);
            db.SubmitChanges();
            return m;
        }

        public IQueryable<Media> GetProductMedia(int productId)
        {
            var query = from m in db.Medias
                        where m.productId == productId
                        orderby m.sortOrder
                        select m;

            return query;
        }

        public IQueryable<Media> GetAllMedia()
        {
            var query = from m in db.Medias
                        select m;

            return query;
        }

        public IQueryable<Media> GetProductMedia(int productId, MediaType mt)
        {
            var query = from m in db.Medias
                        where m.productId == productId && m.mediaTypeId == (int)mt
                        orderby m.sortOrder
                        select m;

            return query;
        }

        public Media GetMedia(int mediaId)
        {
            return db.Medias.SingleOrDefault(m => m.id == mediaId);
        }

        public MediaTranslation GetMediaTranslation(int mediaId, string languageId)
        {
            return db.MediaTranslations.SingleOrDefault(mt => mt.mediaId == mediaId && mt.languageId == languageId);
        }

        public IQueryable<MediaTranslation> GetMediaTranslations (int mediaId)
        {
            var query = from mt in db.MediaTranslations
                        where mt.mediaId == mediaId
                        select mt;
            
            return query;
        }

        public void UpdateMediaSortOrder(int mediaId, short sortOrder, string userId)
        {
            Media m = GetMedia(mediaId);
            m.sortOrder = sortOrder;

            m.lastModifiedBy = userId;
            m.lastModifiedDate = DateTime.Now;

            db.SubmitChanges();
        }

        public void Save()
        {
            db.SubmitChanges();
        }

        public void LogMediaVersion(int mediaId, Action a, string userId)
        {
         
            Media m = GetMedia(mediaId);
            XElement xml = GenerateMediaXml(m);

            VersionHistory vh = new VersionHistory();
            vh.productId = m.productId;
            vh.secondaryId = mediaId;
            vh.modificationDate = DateTime.Now;
            vh.modifiedBy = userId;
            vh.typeId = (byte)VersionHistoryType.Media;
            vh.actionId = (byte) a;
            vh.versionXml = xml.ToString();

            db.VersionHistories.InsertOnSubmit(vh);

            db.SubmitChanges();
        }

       
        public XElement GenerateMediaXml(Media m)
        {
            XElement xml = new XElement("medias",
                                        new XElement("media",
                                                     new XAttribute("id", m.id),
                                                     new XAttribute("productId", m.productId),
                                                     new XAttribute("typeId", m.mediaTypeId),
                                                     new XElement("originalFileName", m.originalFileName),
                                                     new XElement("fileExtension", m.fileExtension),
                                                     new XElement("mediaLanguageId", m.mediaLanguageId),
                                                     new XElement("sortOrder", m.sortOrder),
                                                     new XElement("mediaTranslations",
                                                                  from mt in db.MediaTranslations
                                                                  where mt.mediaId == m.id
                                                                  select
                                                                      new XElement("mediaTranslation",
                                                                                   new XAttribute("languageId", mt.languageId),
                                                                                   new XElement("title", mt.mediaTitle),
                                                                                   new XElement("caption", mt.caption)
                                                                      )
                                                         )
                                                )
                                        );
            return xml;
        }

        public void DeleteMedia(int mediaId)
        {
            var q = from mt in db.MediaTranslations
                    where mt.mediaId == mediaId
                    select mt;
            db.MediaTranslations.DeleteAllOnSubmit(q);

            Media m = GetMedia(mediaId);
            db.Medias.DeleteOnSubmit(m);
            db.SubmitChanges();
        }

       
    }
}