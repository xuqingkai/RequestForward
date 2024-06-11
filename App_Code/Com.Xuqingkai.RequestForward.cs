namespace Com.Xuqingkai
{
	/// <summary>
	/// 伪静态，URL重写
	/// </summary>
	public class RequestForward : System.Web.IHttpModule
	{
		/// <summary>
		/// 伪静态配置文件路径
		/// </summary>
		public void Init(System.Web.HttpApplication context) { context.BeginRequest += new System.EventHandler(BeginRequest); }
		public void Dispose() { }
		private static string UrlEncode(string url)
		{
			string result = null;
			for (int i = 0; i < url.Length; i++) {
				result += (int)url[i] < 128 ? url[i].ToString() : System.Web.HttpUtility.UrlEncode(url[i].ToString());
			}
			return result;
		}
		private void BeginRequest(object sender, System.EventArgs e)
		{
			System.Web.HttpContext context = ((System.Web.HttpApplication)sender).Context;
            string url = context.Request.RawUrl;
            string[] urlArr = url.Split('?');
            url = System.Web.HttpUtility.UrlEncode(urlArr[0]).Replace("%2f", "/").Replace("%2F", "/") + (urlArr.Length > 1 ? "?" + urlArr[1] : "");
            string path = System.Configuration.ConfigurationManager.AppSettings["Com.Xuqingkai.RequestForward"];
            string role = "/RequestForward.ashx/$1";
            if (System.Text.RegularExpressions.Regex.IsMatch(@url, @path, System.Text.RegularExpressions.RegexOptions.IgnoreCase))
            {
                context.RewritePath(UrlEncode(System.Text.RegularExpressions.Regex.Replace(@url, @path, UrlEncode(role), System.Text.RegularExpressions.RegexOptions.IgnoreCase)), true);
            }
		}
	}
}