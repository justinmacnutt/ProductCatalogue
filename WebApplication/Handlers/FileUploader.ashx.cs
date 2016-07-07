using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

namespace WebApplication.Handlers
{
    /// <summary>
    /// Summary description for FileUploader
    /// </summary>
    public class FileUploader : IHttpHandler
    {

        public class FilesStatus
        {
            public string thumbnail_url { get; set; }
            public string name { get; set; }
            public string url { get; set; }
            public int size { get; set; }
            public string type { get; set; }
            public string delete_url { get; set; }
            public string delete_type { get; set; }
            public string error { get; set; }
            public string progress { get; set; }
            public Guid tempName { get; set; }
            public string extension { get; set; }
            public bool isImage { get; set; }
        }
        private readonly List<string> ImageExtentions = new List<string> {"jpg", "png", "gif", "jpeg"};

        //private string _relativeIngestPath = System.Web.Configuration.WebConfigurationManager.AppSettings["ManagedMediaUploadRelativePath"] + System.Web.Configuration.WebConfigurationManager.AppSettings["ManagedMediaIngestSubDir"];
        private readonly string _relativeIngestPath = String.Format("/{0}{1}", System.Web.Configuration.WebConfigurationManager.AppSettings["ManagedMediaDir"] , System.Web.Configuration.WebConfigurationManager.AppSettings["ManagedMediaIngestSubDir"]);

        private readonly JavaScriptSerializer js = new JavaScriptSerializer();
        private string _ingestPath;
        public bool IsReusable { get { return false; } }
        public void ProcessRequest(HttpContext context)
        {
            var r = context.Response;
//            _ingestPath = @"C:\justinTemp\";

            _ingestPath = System.Web.Configuration.WebConfigurationManager.AppSettings["ManagedMediaUploadPath"] + System.Web.Configuration.WebConfigurationManager.AppSettings["ManagedMediaIngestSubDir"];

            r.AddHeader("Pragma", "no-cache");
            r.AddHeader("Cache-Control", "private, no-cache");

            HandleMethod(context);
        }

        private void HandleMethod(HttpContext context)
        {
            switch (context.Request.HttpMethod)
            {
                case "HEAD":
                case "GET":
                    ServeFile(context);
                    break;

                case "POST":
                    UploadFile(context);
                    break;

                case "DELETE":
                    DeleteFile(context);
                    break;

                default:
                    context.Response.ClearHeaders();
                    context.Response.StatusCode = 405;
                    break;
            }
        }

        private void DeleteFile(HttpContext context)
        {
            var filePath = _ingestPath + context.Request["f"];
            if (File.Exists(filePath))
            {
                File.Delete(filePath);
            }
        }

        private void UploadFile(HttpContext context)
        {
            var statuses = new List<FilesStatus>();
            var headers = context.Request.Headers;

            if (string.IsNullOrEmpty(headers["X-File-Name"]))
            {
                UploadWholeFile(context, statuses);
            }
            else
            {
                UploadPartialFile(headers["X-File-Name"], context, statuses);
            }


            WriteJsonIframeSafe(context, statuses);
        }

        private void UploadPartialFile(string fileName, HttpContext context, List<FilesStatus> statuses)
        {
            if (context.Request.Files.Count != 1) throw new HttpRequestValidationException("Attempt to upload chunked file containing more than one fragment per request");
            var inputStream = context.Request.Files[0].InputStream;
            var fullName = _ingestPath + Path.GetFileName(fileName);

            using (var fs = new FileStream(fullName, FileMode.Append, FileAccess.Write))
            {
                var buffer = new byte[1024];

                var l = inputStream.Read(buffer, 0, 1024);
                while (l > 0)
                {
                    fs.Write(buffer, 0, l);
                    l = inputStream.Read(buffer, 0, 1024);
                }
                fs.Flush();
                fs.Close();
            }

            statuses.Add(new FilesStatus
            {
                thumbnail_url = "Thumbnail.ashx?f=" + fileName,
                url = "Upload.ashx?f=" + fileName,
                name = fileName,
                size = (int)(new FileInfo(fullName)).Length,
                type = "image/png",
                delete_url = "Upload.ashx?f=" + fileName,
                delete_type = "DELETE",
                progress = "1.0"
            });

        }

        private void UploadWholeFile(HttpContext context, List<FilesStatus> statuses)
        {
            for (int i = 0; i < context.Request.Files.Count; i++)
            {
                var myTempName = Guid.NewGuid();
                var file = context.Request.Files[i];
                var fname = Path.GetFileName(file.FileName);
                var myExtension = fname.Split('.').Last();

                //file.SaveAs(_ingestPath + Path.GetFileName(myTempName.ToString()));
                file.SaveAs(String.Format("{0}{1}.{2}", _ingestPath, Path.GetFileName(myTempName.ToString()), myExtension));
                statuses.Add(new FilesStatus
                {
                    thumbnail_url = String.Format("{0}{1}.{2}", _relativeIngestPath, myTempName, myExtension),
                    url = "Upload.ashx?f=" + fname,
                    name = fname,
                    size = file.ContentLength,
                    type = "image/png",
                    delete_url = "Upload.ashx?f=" + fname,
                    delete_type = "DELETE",
                    progress = "1.0",
                    tempName = myTempName,
                    extension = myExtension,
                    isImage = (ImageExtentions.Contains(myExtension))
                });
            }
        }

        private void WriteJsonIframeSafe(HttpContext context, List<FilesStatus> statuses)
        {
            context.Response.AddHeader("Vary", "Accept");
            try
            {
                if (context.Request["HTTP_ACCEPT"].Contains("application/json"))
                {
                    context.Response.ContentType = "application/json";
                }
                else
                {
                    context.Response.ContentType = "text/plain";
                }
            }
            catch
            {
                context.Response.ContentType = "text/plain";
            }

            var jsonObj = js.Serialize(statuses.ToArray());
            context.Response.Write(jsonObj);
        }

        private void ServeFile(HttpContext context)
        {
            if (string.IsNullOrEmpty(context.Request["f"])) ListCurrentFiles(context);
            else DeliverFile(context);
        }

        private void DeliverFile(HttpContext context)
        {
            var filePath = _ingestPath + context.Request["f"];
            if (File.Exists(filePath))
            {
                context.Response.ContentType = "application/octet-stream";
                context.Response.WriteFile(filePath);
                context.Response.AddHeader("Content-Disposition", "attachment, filename=\"" + context.Request["f"] + "\"");
            }
            else
            {
                context.Response.StatusCode = 404;
            }
        }

        private void ListCurrentFiles(HttpContext context)
        {
            var files = new List<FilesStatus>();

            var names = Directory.GetFiles(_ingestPath, "*", SearchOption.TopDirectoryOnly);

            foreach (var name in names)
            {
                var f = new FileInfo(name);
                files.Add(new FilesStatus
                {
                    thumbnail_url = "Thumbnail.ashx?f=" + f.Name,
                    url = "Upload.ashx?f=" + f.Name,
                    name = f.Name,
                    size = (int)f.Length,
                    type = "image/png",
                    delete_url = "Upload.ashx?f=" + f.Name,
                    delete_type = "DELETE"
                });
            }

            context.Response.AddHeader("Content-Disposition", "inline, filename=\"files.json\"");
            var jsonObj = js.Serialize(files.ToArray());
            context.Response.Write(jsonObj);
            context.Response.ContentType = "application/json";
        }
    }
}