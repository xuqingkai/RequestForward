# 请求转发，个人调试使用

- web.config，修改重写规则，
```
<add key="Com.Xuqingkai.RequestForward" value="^/PEISAPI/API/(.+)" />
```

- RequestForward.ashx，自行根据需要修改转发报文
```
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
```
