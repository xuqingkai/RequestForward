<%@ webhandler class="RequestForward"%>

public class RequestForward : System.Web.IHttpHandler
{
    public bool IsReusable 
    { 
        get { return true; } 
    } 
    public void ProcessRequest(System.Web.HttpContext context)
    {
        string pathInfo = context.Request.PathInfo;
        string queryString = context.Request.QueryString.ToString();
        string postString = HttpPost();
        System.IO.File.WriteAllText(System.Web.HttpContext.Current.Server.MapPath("./data.txt"), postString);

        string responseString = null;
        string url="http://192.168.1.100/PEISAPI/API" + pathInfo + "?" + queryString;
        if(context.Request.HttpMethod=="GET")
        {
            responseString = HttpGet(url);
        }
        else
        {
            responseString = HttpPost(url, postString);
        }
        context.Response.Write(responseString);
        context.Response.End();
    }
    public static string HttpPost(string charset = "UTF-8")
    {
        System.IO.Stream stream = System.Web.HttpContext.Current.Request.InputStream;
        stream.Position = 0;
        byte[] bytes = new byte[stream.Length];
        stream.Read(bytes, 0, bytes.Length);
        string result = System.Text.Encoding.GetEncoding(charset).GetString(bytes);
        return result;
    }
    public static string HttpGet(string url, string charset = "UTF-8")
    {
        string result = null;
        System.Net.WebClient webClient = new System.Net.WebClient();
        System.Net.ServicePointManager.Expect100Continue = false;
        System.Net.ServicePointManager.ServerCertificateValidationCallback = new System.Net.Security.RemoteCertificateValidationCallback(delegate { return true; });
        System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Ssl3 | System.Net.SecurityProtocolType.Tls12 | System.Net.SecurityProtocolType.Tls11 | System.Net.SecurityProtocolType.Tls;
        //webClient.Encoding = System.Text.Encoding.UTF8;
        try
        {
            webClient.Headers.Add("aa", "11");
            byte[] bytes = webClient.DownloadData(url);
            result = System.Text.Encoding.GetEncoding(charset).GetString(bytes);
        }
        catch (System.Net.WebException webException)
        {
            System.Net.HttpWebResponse httpWebResponse = (System.Net.HttpWebResponse)webException.Response;
            if(httpWebResponse != null)
            {
                result = new System.IO.StreamReader(httpWebResponse.GetResponseStream(), System.Text.Encoding.GetEncoding("UTF-8")).ReadToEnd();
            }
        }
        catch (System.Exception ex)
        {
            result = "HttpGet:" + ex.Message;
            //result = null;
        }
        return result;
    }
    public static string HttpPost(string url, string data, string charset = "UTF-8", string contentType = "UTF-8")
    {
        string result = null;
        System.Net.WebClient webClient = new System.Net.WebClient();
        System.Net.ServicePointManager.Expect100Continue = false;
        System.Net.ServicePointManager.ServerCertificateValidationCallback = new System.Net.Security.RemoteCertificateValidationCallback(delegate { return true; });
        System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Ssl3 | System.Net.SecurityProtocolType.Tls12 | System.Net.SecurityProtocolType.Tls11 | System.Net.SecurityProtocolType.Tls;
        //webClient.Encoding = System.Text.Encoding.UTF8;
        try
        {
            webClient.Headers.Add("Content-Type", "application/json");
            byte[] bytes = webClient.UploadData(url, System.Text.Encoding.GetEncoding(charset).GetBytes(data));
            result = System.Text.Encoding.GetEncoding(contentType).GetString(bytes);
        }
        catch (System.Net.WebException webException)
        {
            System.Net.HttpWebResponse httpWebResponse = (System.Net.HttpWebResponse)webException.Response;
            if(httpWebResponse != null)
            {
                result = new System.IO.StreamReader(httpWebResponse.GetResponseStream(), System.Text.Encoding.GetEncoding("UTF-8")).ReadToEnd();
            }
        }
        catch (System.Exception ex)
        {
            result = "HttpPost:" + ex.Message;
        }
        return result;
    }
}
  