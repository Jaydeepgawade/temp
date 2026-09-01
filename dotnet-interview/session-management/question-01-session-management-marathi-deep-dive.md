# प्रश्न 1: Session Management म्हणजे काय? — Marathi Deep Dive + Real Project Implementation

> उद्देश: ASP.NET Core / .NET 8 MVC project मध्ये Session Management theory, real implementation, expiry cases, security, AJAX handling, load balancing आणि interview explanation एकाच ठिकाणी समजणे.

---

## 1. Session Management ची basic idea

1. HTTP हा stateless protocol आहे.
2. Stateless म्हणजे server ला मागील request आपोआप आठवत नाही.
3. User ने login request केली तरी पुढची request technically नवीन request असते.
4. त्यामुळे application ला user-specific state maintain करण्यासाठी mechanism लागतो.
5. Session हा त्यापैकी एक mechanism आहे.
6. Session multiple requests मध्ये temporary user-specific data ठेवतो.
7. Session permanent database storage नाही.
8. Session मध्ये data काही काळासाठी ठेवला जातो.
9. Session ला timeout असतो.
10. Session manually clear करता येतो.
11. Logout वेळी session clear करता येते.
12. Session ID सामान्यतः browser cookie मधून maintain केला जातो.
13. Actual session data server-side store मध्ये राहू शकतो.
14. Browser साधारण session identifier पाठवतो.
15. Server त्या identifier वरून संबंधित session data load करतो.
16. Session मध्ये UserId ठेवता येतो.
17. UserName ठेवता येतो.
18. Selected BranchId ठेवता येतो.
19. Temporary workflow state ठेवता येतो.
20. काही UI preferences ठेवता येतात.

---

## 2. Real-life example

21. User login page वर username आणि password भरतो.
22. Login request server कडे जाते.
23. Server database किंवा external identity provider कडून credentials validate करतो.
24. User valid असल्यास authentication complete होते.
25. Application ला UserId मिळतो.
26. उदाहरणार्थ UserId = 101.
27. Application session मध्ये UserId ठेवू शकते.
28. Application UserName ठेवू शकते.
29. Application selected role identifier ठेवू शकते.
30. पुढे user Dashboard वर जातो.
31. Browser session cookie server कडे पाठवतो.
32. Server session identifier वाचतो.
33. Server UserId session मधून retrieve करतो.
34. Dashboard user-specific data load करतो.
35. User दुसऱ्या module मध्ये जातो.
36. तोच session context वापरला जातो.
37. User बराच वेळ inactive राहतो.
38. Session timeout cross होतो.
39. पुढच्या request ला UserId null मिळतो.
40. Application user ला login page वर redirect करते.

---

## 3. Session internally कशी काम करते?

41. Browser request पाठवतो.
42. Request मध्ये session cookie असू शकतो.
43. ASP.NET Core session middleware cookie inspect करते.
44. Session identifier मिळाल्यास backing store मधून session data load होते.
45. Identifier नसल्यास नवीन session context तयार होऊ शकतो.
46. Controller HttpContext.Session वापरू शकतो.
47. Session मध्ये values set केल्या जाऊ शकतात.
48. Response complete होताना state persist होते.
49. Client कडे session cookie राहतो.
50. पुढच्या request मध्ये cookie पुन्हा server कडे जाते.
51. Cookie हा actual पूर्ण session data नसतो.
52. Cookie प्रामुख्याने session reference असतो.
53. Server-side session store memory असू शकतो.
54. Redis असू शकतो.
55. SQL Server distributed cache असू शकतो.
56. दुसरा IDistributedCache provider असू शकतो.
57. Single instance app मध्ये memory-based session सोपी असते.
58. Multiple instances मध्ये distributed session योग्य ठरते.
59. Session read/write operation cost backing store वर depend करतो.
60. Session मध्ये minimum data ठेवणे चांगले असते.

---

## 4. .NET 8 MVC मध्ये Session configure कशी करतात?

61. Program.cs मध्ये cache service register करावी लागते.
62. मग AddSession register करावे लागते.
63. IdleTimeout configure करावा लागतो.
64. Cookie HttpOnly करणे योग्य आहे.
65. Production मध्ये Secure cookie policy विचारात घ्यावी.
66. Middleware pipeline मध्ये UseSession add करावे लागते.
67. Middleware order महत्वाचा असतो.
68. Session वापरणाऱ्या MVC endpoints च्या आधी UseSession available असावे.
69. Configuration centralized ठेवावी.
70. Business requirement नुसार timeout बदलावा.

```csharp
builder.Services.AddDistributedMemoryCache();

builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(20);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});
```

71. AddDistributedMemoryCache in-process backing cache देते.
72. AddSession session services configure करते.
73. IdleTimeout inactivity period define करतो.
74. HttpOnly cookie client-side JavaScript access कमी करते.
75. IsEssential cookie consent-related cases मध्ये उपयोगी असू शकते.
76. Production मध्ये HTTPS compulsory मानावे.
77. SecurePolicy = Always वापरणे production मध्ये विचारात घेता येते.
78. SameSite requirement authentication flow नुसार configure करावी.
79. Cookie name customize करता येते.
80. Environment-specific configuration ठेवता येते.

```csharp
app.UseSession();
```

81. UseSession middleware enable करते.
82. त्यानंतर HttpContext.Session usable होते.
83. Middleware order चुकीचा असल्यास session behavior चुकीचे वाटू शकते.
84. Integration testing मध्येही session setup आवश्यक असू शकते.
85. Session हे framework pipeline concern आहे.

---

## 5. Real Project मध्ये Login नंतर Session set कशी करतात?

86. Controller login request घेतो.
87. Service credentials validate करते.
88. Database मधून user details मिळतात.
89. Authentication successful झाल्यावर session set केली जाते.
90. Session मध्ये minimum required values ठेवाव्यात.
91. Password कधीही ठेवू नये.
92. Full user entity ठेवणे टाळावे.
93. UserId योग्य आहे.
94. DisplayName योग्य असू शकतो.
95. TenantId किंवा BranchId business requirement असेल तर ठेवता येतो.

```csharp
[HttpPost]
public async Task<IActionResult> Login(LoginRequest model)
{
    var user = await _authService.ValidateUserAsync(model);

    if (user == null)
    {
        ModelState.AddModelError(string.Empty, "Invalid username or password");
        return View(model);
    }

    HttpContext.Session.SetInt32("UserId", user.Id);
    HttpContext.Session.SetString("UserName", user.UserName);
    HttpContext.Session.SetString("Role", user.Role);

    return RedirectToAction("Index", "Dashboard");
}
```

96. ValidateUserAsync service layer call करते.
97. Controller credentials logic स्वतः handle करणे टाळतो.
98. User null असल्यास login fail करतो.
99. User valid असल्यास session set होते.
100. मग Dashboard कडे redirect होते.
101. Real project मध्ये authentication cookie/JWT वेगळे manage केले जाऊ शकते.
102. Session authentication replacement म्हणून वापरणे आवश्यक नाही.
103. Session supplementary user state साठी वापरली जाऊ शकते.
104. Authorization database/claims वर आधारित असू शकते.
105. Role session मध्ये ठेवली तरी critical authorization पुन्हा validate करावी.

---

## 6. Session values read कशा करतात?

106. GetInt32 वापरून integer value वाचता येते.
107. GetString वापरून string value वाचता येते.
108. Session values nullable असू शकतात.
109. Null म्हणजे key नाही किंवा session expire झाली असू शकते.
110. Null handling आवश्यक आहे.

```csharp
var userId = HttpContext.Session.GetInt32("UserId");
var userName = HttpContext.Session.GetString("UserName");
```

111. userId nullable int असतो.
112. userName nullable string असतो.
113. Direct .Value वापरणे risky असू शकते.
114. Null check आधी करावा.
115. Session expired असल्यास graceful redirect करावा.

---

## 7. चुकीचा real-project approach

116. प्रत्येक controller action मध्ये session check लिहिणे चुकीचे ठरू शकते.
117. Code duplication वाढते.
118. काही action मध्ये check विसरला जाऊ शकतो.
119. Maintenance कठीण होते.
120. Expiry handling inconsistent होते.

```csharp
if (HttpContext.Session.GetInt32("UserId") == null)
{
    return RedirectToAction("Login", "Account");
}
```

121. हा code एक action मध्ये चालतो.
122. पण 50 actions मध्ये repeat करणे योग्य नाही.
123. Real project मध्ये centralized mechanism वापरावा.
124. Filter वापरता येतो.
125. Middleware काही cases मध्ये वापरता येते.
126. Authentication authorization framework वापरता येते.
127. Session-specific MVC validation साठी custom filter practical आहे.

---

## 8. Real Project मध्ये Global Session Check

128. Custom action filter तयार करू शकतो.
129. तो protected controllers वर apply करू शकतो.
130. किंवा globally register करू शकतो.
131. Login controller exclude करावा.
132. Public endpoints exclude करावेत.
133. Filter session key check करतो.
134. Session missing असल्यास redirect करतो.
135. User-friendly message flag pass करतो.

```csharp
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

public class SessionCheckFilter : IActionFilter
{
    public void OnActionExecuting(ActionExecutingContext context)
    {
        var userId = context.HttpContext.Session.GetInt32("UserId");

        if (userId == null)
        {
            context.Result = new RedirectToActionResult(
                "Login",
                "Account",
                new { sessionExpired = true });
        }
    }

    public void OnActionExecuted(ActionExecutedContext context)
    {
    }
}
```

136. OnActionExecuting action सुरू होण्यापूर्वी चालते.
137. UserId session check होते.
138. UserId null असेल तर action execute होण्याआधी redirect result set होतो.
139. त्यामुळे repetitive controller code कमी होतो.
140. Centralized behavior मिळते.
141. Login page ला filter लागू केल्यास redirect loop होऊ शकतो.
142. म्हणून exclusions नीट design कराव्यात.
143. AJAX requests साठी redirect वेगळ्या प्रकारे handle करावी लागू शकते.
144. API request साठी JSON/401 response योग्य ठरू शकतो.
145. MVC page request साठी login redirect योग्य ठरतो.

---

## 9. Filter register कसा करतात?

146. Service registration मध्ये filter add करता येतो.
147. Global filter म्हणून add करता येतो.
148. किंवा attribute/service filter म्हणून selective apply करता येतो.

```csharp
builder.Services.AddScoped<SessionCheckFilter>();
```

149. DI container filter instance तयार करू शकतो.
150. मग controller वर वापरता येतो.

```csharp
[ServiceFilter(typeof(SessionCheckFilter))]
public class DashboardController : Controller
{
}
```

151. Dashboard protected होतो.
152. Session missing असेल तर filter redirect करतो.
153. Controller methods clean राहतात.
154. प्रत्येक action मध्ये same check लागत नाही.
155. हा production-friendly reusable approach आहे.

---

## 10. Global filter alternative

156. सर्व MVC protected pages साठी global filter configure करता येतो.
157. पण public/login controllers explicitly skip करावे लागतील.
158. Custom SkipSessionCheck attribute बनवता येतो.
159. किंवा controller metadata तपासता येते.
160. Large MVC app मध्ये centralized handling useful आहे.
161. Security rules clear असाव्यात.
162. Authentication filter आणि session filter responsibilities overlap होऊ नयेत.
163. Session ला authorization system म्हणून overuse करू नये.
164. Claims-based authorization framework अधिक robust असतो.
165. Session additional state म्हणून वापरणे योग्य आहे.

---

## 11. Session कोणत्या cases मध्ये expire होते?

166. सर्वात common case म्हणजे idle timeout.
167. User configured timeout पेक्षा जास्त वेळ inactive राहतो.
168. उदाहरण 20 minutes timeout.
169. User 20 minutes request करत नाही.
170. Session expire होऊ शकते.
171. पुढच्या request ला session value null मिळू शकते.
172. App restart झाल्यास in-memory session हरवू शकते.
173. IIS app pool recycle झाल्यास in-memory session हरवू शकते.
174. Application redeploy झाल्यास process restart होऊ शकतो.
175. Server restart झाल्यास memory session नष्ट होऊ शकते.
176. Container restart झाल्यास in-memory data हरवू शकते.
177. Session backing store cache eviction मुळे data हरवू शकतो.
178. Redis TTL expire झाल्यास session data expire होऊ शकतो.
179. Session cookie browser मधून delete झाली तर identifier हरवतो.
180. User browser cookies clear करतो तेव्हा session linkage तुटू शकतो.
181. Private/incognito window close केल्यावर session cookie lifecycle संपुष्टात येऊ शकतो.
182. Logout flow मध्ये application session clear करते.
183. Server-side code Remove/Clear केल्यास session values निघून जातात.
184. Cookie domain/path mismatch मुळे session cookie request सोबत जाऊ शकत नाही.
185. HTTPS/Secure cookie mismatch मुळे cookie send न होण्याची शक्यता असते.
186. SameSite misconfiguration काही cross-site flows प्रभावित करू शकते.
187. Load-balanced app मध्ये in-memory session दुसऱ्या server वर उपलब्ध नसते.
188. Sticky session नसल्यास user session missing वाटू शकते.
189. Redis unavailable असल्यास session read fail होऊ शकतो.
190. Distributed cache connectivity issue मुळे errors येऊ शकतात.
191. Session storage memory pressure मुळे eviction होऊ शकते.
192. Key serialization/deserialization issue मुळे expected state मिळू शकत नाही.
193. Session ID rotation/custom lifecycle logic मुळे old session invalid होऊ शकते.
194. Security policy force logout केल्यास session clear केली जाऊ शकते.
195. Admin user account disable केल्यावर application session invalidate करू शकते.

---

## 12. Idle Timeout म्हणजे नेमके काय?

196. IdleTimeout म्हणजे inactivity period.
197. User request करत राहिला तर timeout refresh होऊ शकतो.
198. User inactive राहिला तर session expire होते.
199. हे absolute login lifetime नसते.
200. Authentication cookie expiry आणि session idle timeout वेगळे असू शकतात.
201. उदाहरण: auth cookie 8 hours आणि session 20 minutes.
202. अशा case मध्ये user authenticated असू शकतो पण temporary session state missing असू शकतो.
203. म्हणून authentication आणि session same समजू नये.
204. Banking/internal applications मध्ये short inactivity timeout common आहे.
205. UX आणि security balance करणे आवश्यक आहे.

---

## 13. App Pool Recycle मुळे काय होते?

206. IIS app pool recycle झाल्यास process restart होतो.
207. In-memory session process memory मध्ये असल्यास ती नष्ट होते.
208. User browser cookie अजून असू शकतो.
209. पण server कडे त्या ID साठी data नसते.
210. User ला session expired सारखा अनुभव येतो.
211. Distributed Redis session असल्यास process restart नंतरही state उपलब्ध राहू शकतो.
212. म्हणून high-availability apps मध्ये distributed session better असते.
213. पण business security requirement नुसार restart नंतर logout intentionally करायचा असू शकतो.
214. Architecture decision documented असावी.
215. Interview मध्ये app restart case सांगितल्यास practical knowledge दिसते.

---

## 14. Browser cookie delete केल्यास काय होते?

216. Browser session identifier cookie delete करतो.
217. Server कडे old session state असू शकते.
218. पण client कडे त्या session ची key/reference राहत नाही.
219. पुढच्या request ला server नवीन session तयार करू शकतो.
220. जुना temporary data user ला मिळत नाही.
221. User logged out वाटू शकतो जर app session वर login state ठेवत असेल.
222. Authentication cookie स्वतंत्र असल्यास auth state टिकू शकतो.
223. म्हणून पुन्हा session vs auth distinction महत्वाची आहे.
224. Cookie clear करणे म्हणजे server-side cache instant delete झालीच असे नाही.
225. TTL नंतर server-side data साफ होईल.

---

## 15. Real Project Expiry Handling Flow

226. User protected page request करतो.
227. Filter किंवा centralized middleware session validate करते.
228. UserId session मध्ये आहे का ते check करते.
229. UserId मिळाला तर request continue होते.
230. UserId null मिळाला तर expiry/missing session मानली जाते.
231. HTML page request असल्यास login page वर redirect करता येते.
232. Redirect मध्ये sessionExpired=true flag पाठवता येतो.
233. Login page हा flag वाचतो.
234. UI वर message दाखवतो.
235. Message: Your session has expired. Please login again.
236. User पुन्हा login करतो.
237. नवीन session values set होतात.
238. User application वापरू शकतो.
239. हा clean real-project flow आहे.
240. Redirect loop avoid करणे आवश्यक आहे.

---

## 16. Login page वर expiry message कसा दाखवायचा?

241. Query parameter वापरता येतो.
242. TempData वापरता येतो.
243. ViewModel flag वापरता येतो.
244. JavaScript toast trigger करता येतो.

```csharp
public IActionResult Login(bool sessionExpired = false)
{
    if (sessionExpired)
    {
        ViewBag.SessionExpiredMessage =
            "Your session has expired. Please login again.";
    }

    return View();
}
```

245. ViewBag current request साठी message carry करते.
246. View मध्ये conditional alert दाखवता येतो.
247. Production UI मध्ये toast/snackbar वापरता येतो.
248. Security-sensitive details message मध्ये disclose करू नयेत.
249. साधा generic message पुरेसा आहे.
250. User ला काय action घ्यायचा ते स्पष्ट असावे.

---

## 17. AJAX/jQuery project मध्ये session expire कसा handle करतात?

251. Traditional page redirect AJAX call मध्ये नेहमी चांगला UX देत नाही.
252. AJAX request session expire झाली तर server JSON किंवा status code return करू शकतो.
253. Frontend global AJAX handler response detect करू शकतो.
254. मग login page वर redirect करू शकतो.
255. Message local/session storage मध्ये temporary ठेवण्याची strategy असू शकते.
256. किंवा query parameter वापरता येतो.
257. jQuery ajaxError global handler वापरता येतो.
258. HTTP 401 सामान्य unauthorized response आहे.
259. काही legacy systems 440 Login Timeout वापरतात, पण standard नाही.
260. API design मध्ये 401 अधिक predictable आहे.

Example conceptual filter behavior:

```csharp
if (userId == null)
{
    var isAjax = context.HttpContext.Request.Headers["X-Requested-With"] == "XMLHttpRequest";

    if (isAjax)
    {
        context.Result = new UnauthorizedObjectResult(new
        {
            sessionExpired = true,
            message = "Your session has expired. Please login again."
        });
        return;
    }

    context.Result = new RedirectToActionResult(
        "Login",
        "Account",
        new { sessionExpired = true });
}
```

261. AJAX असेल तर 401 JSON मिळतो.
262. Normal page request असेल तर redirect मिळतो.
263. यामुळे frontend handling consistent होते.
264. Global interceptor असल्यास प्रत्येक AJAX call मध्ये duplicate handling लागत नाही.
265. ही real project मध्ये खूप उपयोगी pattern आहे.

---

## 18. jQuery global handler example

```javascript
$(document).ajaxError(function (event, xhr) {
    if (xhr.status === 401) {
        window.location.href = '/Account/Login?sessionExpired=true';
    }
});
```

266. हा handler application-level AJAX failures पकडू शकतो.
267. 401 मिळाल्यास login redirect करतो.
268. प्रत्येक $.ajax call मध्ये same code लिहिण्याची गरज कमी होते.
269. API आणि MVC project integrated असताना हा pattern उपयोगी आहे.
270. पण 401 फक्त session expiry मुळे येतो असे assume करू नये.
271. Response body मधील sessionExpired flag तपासणे अधिक precise असू शकते.
272. Frontend architecture नुसार interceptor abstraction बनवता येते.
273. Fetch API वापरत असाल तर common wrapper बनवता येतो.
274. Axios मध्ये interceptor वापरता येतो.
275. jQuery मध्ये ajaxSetup/ajaxError वापरता येतो.

---

## 19. Logout flow real project मध्ये

276. User Logout click करतो.
277. Server logout action execute करतो.
278. Session Clear केली जाते.
279. Authentication cookie sign out केली जाते.
280. Login page वर redirect केले जाते.
281. Cache मधील user-sensitive transient entries clear करणे आवश्यक असल्यास केले जाते.
282. Logout हा session expiry पेक्षा intentional action आहे.
283. Session expired message logout वेळी दाखवू नये.
284. Logout successful message optional आहे.
285. Protected back-navigation prevent करण्यासाठी cache-control विचारात घेता येतो.

```csharp
public async Task<IActionResult> Logout()
{
    HttpContext.Session.Clear();
    await HttpContext.SignOutAsync();

    return RedirectToAction("Login", "Account");
}
```

286. Session.Clear temporary session state remove करते.
287. SignOutAsync authentication scheme sign out करते.
288. दोन्ही concerns वेगळे आहेत.
289. फक्त Session.Clear केल्यास auth cookie राहू शकते.
290. फक्त SignOutAsync केल्यास session values राहू शकतात.

---

## 20. Session मध्ये complex object store करायचा असल्यास

291. ASP.NET Core session primitive byte/string/int operations देते.
292. Complex object store करण्यासाठी serialization वापरावी लागू शकते.
293. JSON serialize करता येतो.
294. पण full entity session मध्ये store करणे टाळावे.
295. Object मोठा असल्यास memory/network cost वाढते.
296. Object schema बदलल्यास deserialization issue येऊ शकते.
297. Stale data problem होऊ शकतो.
298. Database मध्ये data बदलला तरी session object जुना राहू शकतो.
299. म्हणून identifier store करून latest data DB/cache मधून load करणे better असते.
300. Example: Full User object ऐवजी UserId store करणे.

---

## 21. Session मध्ये काय ठेवू नये?

301. Plain-text password ठेवू नये.
302. Database password ठेवू नये.
303. API secret ठेवू नये.
304. Private key ठेवू नये.
305. Card number पूर्ण स्वरूपात ठेवू नये.
306. CVV ठेवू नये.
307. Highly sensitive PII unnecessarily ठेवू नये.
308. Large DataSet ठेवू नये.
309. 20,000 rows session मध्ये ठेवू नयेत.
310. Entire API response blindly ठेवू नये.
311. Huge image/base64 ठेवू नये.
312. Large serialized object graph ठेवू नये.
313. Mutable authorization decision blindly cache करू नये.
314. Session ला dumping ground बनवू नये.
315. Minimum required data ठेवावा.

---

## 22. Session vs Authentication Cookie

316. Authentication cookie user identity prove करण्यासाठी वापरली जाते.
317. Session temporary state साठी वापरली जाते.
318. Cookie auth framework ClaimsPrincipal तयार करते.
319. Session user-specific auxiliary values देते.
320. Auth cookie expire झाली तर user unauthenticated होतो.
321. Session expire झाली तरी auth cookie technically valid असू शकते.
322. उलट auth cookie expire पण session values अजून backing store मध्ये असू शकतात.
323. म्हणून protected access Authorize attribute/claims ने control करणे योग्य आहे.
324. Session फक्त additional context ठेवण्यासाठी वापरावी.
325. Real production app मध्ये हा separation खूप महत्वाचा आहे.

---

## 23. Session vs JWT

326. Session state server-side असते.
327. JWT stateless authentication pattern मध्ये वापरला जातो.
328. JWT client प्रत्येक API request सोबत पाठवतो.
329. Server token validate करतो.
330. JWT मध्ये claims असू शकतात.
331. Sessionमध्ये actual temporary server state ठेवता येते.
332. Microservices मध्ये JWT/OAuth अधिक common आहे.
333. MVC monolithic app मध्ये cookie auth + session common असू शकते.
334. दोन्ही एकाच system मध्ये coexist करू शकतात.
335. Architecture requirement नुसार वापर ठरतो.

---

## 24. Session vs Cache

336. Session per-user state आहे.
337. Cache performance optimization आहे.
338. Master data cache मध्ये योग्य आहे.
339. User-specific workflow state session मध्ये योग्य असू शकतो.
340. Cache shared असू शकते.
341. Session logically user-specific असते.
342. Redis cache session backing store म्हणून वापरला जाऊ शकतो.
343. त्यामुळे underlying technology same असली तरी purpose वेगळा असतो.
344. Session expire झाली तर user state हरवू शकतो.
345. Cache expire झाली तर app source मधून data reload करू शकते.

---

## 25. Load Balancer मध्ये Session issue

346. दोन servers आहेत: A आणि B.
347. User request A वर जाते.
348. Session A च्या memory मध्ये save होते.
349. दुसरी request B वर जाते.
350. B ला A ची memory दिसत नाही.
351. त्यामुळे UserId null वाटू शकतो.
352. User random logout झाल्यासारखा अनुभव येतो.
353. Sticky session वापरता येतो.
354. पण server failure मध्ये sticky approach limited असतो.
355. Redis distributed session better असू शकते.
356. SQL distributed cache पर्याय आहे.
357. Shared IDistributedCache वापरता येतो.
358. Cloud scale-out मध्ये distributed state practical आहे.
359. Stateless architecture शक्य असल्यास अधिक scalable असते.
360. Interview मध्ये हा scenario सांगणे strong point आहे.

---

## 26. Redis Session real project मध्ये का वापरतात?

361. Multiple application instances shared session access करू शकतात.
362. App restart झाला तरी Redis state independently उपलब्ध राहू शकते.
363. Redis low-latency आहे.
364. TTL support करते.
365. Centralized session state मिळते.
366. Load balancing सोपे होते.
367. पण Redis dependency वाढते.
368. Network latency असते.
369. Redis outage handling आवश्यक आहे.
370. Monitoring आवश्यक आहे.
371. Memory sizing आवश्यक आहे.
372. Sensitive session data encryption/threat model विचारात घ्यावा.
373. Redis high availability configure करावी लागू शकते.
374. Session serialization efficient असावी.
375. Oversized session data टाळावा.

---

## 27. Session Security Best Practices

376. HTTPS वापरावे.
377. Cookie HttpOnly ठेवावी.
378. Production मध्ये Secure cookie वापरावी.
379. SameSite योग्य configure करावी.
380. Sensitive data minimize करावी.
381. Password store करू नये.
382. Logout properly implement करावा.
383. Reasonable timeout ठेवावा.
384. Session IDs logs मध्ये लिहू नयेत.
385. Session ID URL मध्ये expose करू नये.
386. XSS protection implement करावी.
387. CSRF protection आवश्यक flow मध्ये implement करावी.
388. Authorization server-side validate करावी.
389. Session role blindly trust करू नये.
390. Privilege changes नंतर stale state refresh करावी.
391. Security-sensitive actions ला re-authentication लागू शकते.
392. Concurrent sessions policy business requirement नुसार ठरवावी.
393. Account disable झाल्यास active sessions invalidate करण्याची strategy असावी.
394. Password reset नंतर sessions revoke करण्याचा विचार करावा.
395. Session fixation protection framework best practices नुसार करावी.

---

## 28. Session Hijacking म्हणजे काय?

396. Attacker valid session identifier मिळवतो.
397. तो identifier वापरून user impersonate करण्याचा प्रयत्न करतो.
398. याला session hijacking म्हणतात.
399. HTTPS हा मुख्य protection आहे.
400. HttpOnly cookie XSS-based theft risk कमी करते.
401. Secure cookie HTTP वर send होऊ देत नाही.
402. SameSite काही cross-site attack risks कमी करू शकतो.
403. Session IDs logs मध्ये expose करू नयेत.
404. Shared computers वर logout आवश्यक आहे.
405. Expiry reasonable ठेवावी.

---

## 29. Real Project मध्ये session expired vs API unauthorized कसे distinguish करावे?

406. प्रत्येक 401 session expiry नसतो.
407. JWT invalid असल्यासही 401 येतो.
408. Auth cookie missing असल्यासही 401 येतो.
409. Session key missing असल्यास custom response flag देता येतो.
410. Example response: sessionExpired = true.
411. Frontend त्या flag वर specific message दाखवू शकतो.
412. Generic unauthorized असल्यास वेगळा flow ठेवता येतो.
413. Central API response contract helpful असतो.
414. Error handling middleware/filter standard response format देऊ शकतो.
415. Frontend global interceptor त्या contract वर काम करू शकतो.

---

## 30. Practical Scenario Questions

416. प्रश्न: User 30 minutes inactive होता आणि timeout 20 minutes आहे. काय होईल?
417. उत्तर: पुढच्या request वेळी session state unavailable होऊ शकते आणि application ने login redirect/401 handle करावे.
418. प्रश्न: App restart झाला. In-memory session चे काय?
419. उत्तर: process memory गमावल्यामुळे session data नष्ट होऊ शकतो.
420. प्रश्न: Redis session असल्यास app restart नंतर काय?
421. उत्तर: Redis independent उपलब्ध असल्यास session data TTL पर्यंत टिकू शकतो.
422. प्रश्न: Browser cookies clear केल्या तर?
423. उत्तर: client session identifier हरवतो आणि old session linkage तुटते.
424. प्रश्न: प्रत्येक action मध्ये session check कराल का?
425. उत्तर: नाही, reusable filter/middleware/authorization mechanism ने centralize करेन.
426. प्रश्न: Session मध्ये password ठेवता का?
427. उत्तर: नाही, sensitive secrets session मध्ये ठेवत नाही.
428. प्रश्न: Multiple servers असतील तर?
429. उत्तर: distributed session store जसे Redis वापरेन किंवा stateless architecture prefer करेन.
430. प्रश्न: AJAX call दरम्यान session expire झाली तर?
431. उत्तर: server 401 + sessionExpired flag देईल आणि frontend global handler login वर redirect करेल.
432. प्रश्न: Logout आणि expiry same आहेत का?
433. उत्तर: नाही. Logout intentional आहे; expiry inactivity/system lifecycle मुळे होऊ शकते.
434. प्रश्न: Session auth replacement आहे का?
435. उत्तर: नाही. Authentication/authorization framework वेगळे वापरणे योग्य आहे.

---

## 31. Strong Interview Answer — 30 seconds

436. "Session Management म्हणजे HTTP च्या stateless nature मुळे multiple requests मध्ये user-specific temporary state maintain करण्याची mechanism आहे."
437. "Browser सामान्यतः session identifier cookie पाठवतो आणि server त्या identifier विरुद्ध session data memory किंवा distributed store मध्ये ठेवतो."
438. "ASP.NET Core मध्ये AddSession आणि UseSession configure करतो."
439. "Real project मध्ये UserId सारखा minimum data session मध्ये ठेवतो, expiry centrally filter ने handle करतो आणि multiple servers असल्यास Redis distributed session वापरतो."
440. "Sensitive data session मध्ये ठेवत नाही."

---

## 32. Strong Interview Answer — 60 seconds

441. "HTTP stateless असल्यामुळे server ला previous request ची user state automatically आठवत नाही."
442. "Session Management वापरून UserId, selected branch किंवा temporary workflow state multiple requests मध्ये maintain करता येते."
443. "Client कडे session identifier cookie राहते आणि server-side state memory, Redis किंवा SQL distributed cache मध्ये राहू शकते."
444. "ASP.NET Core मध्ये AddSession configure करून UseSession middleware enable करतो."
445. "Real project मध्ये प्रत्येक controller action मध्ये repetitive check न करता custom action filter किंवा centralized mechanism वापरतो."
446. "Session idle timeout, app restart, app pool recycle, cookie deletion, logout किंवा distributed-store issues मुळे missing/expired होऊ शकते."
447. "AJAX request असेल तर 401 + sessionExpired flag आणि normal MVC request असेल तर login redirect हा clean pattern आहे."
448. "Multiple instances असल्यास Redis distributed session योग्य ठरते."
449. "Authentication आणि session वेगळे concerns आहेत; claims/cookie/JWT authentication framework वापरतो आणि session supplementary state साठी ठेवतो."
450. "Security साठी HTTPS, HttpOnly, Secure cookie, minimal data आणि proper logout follow करतो."

---

# Final Quick Revision

- HTTP stateless आहे.
- Session temporary user-specific state multiple requests मध्ये टिकवते.
- Session ID सामान्यतः cookie मधून maintain होतो.
- Actual session data server-side store मध्ये राहतो.
- .NET 8 मध्ये AddSession + UseSession लागते.
- UserId सारखे minimum data session मध्ये ठेवावे.
- Password/secret/full entity session मध्ये ठेवू नये.
- प्रत्येक controller मध्ये duplicate checks टाळावेत.
- Custom filter ने centralized session validation करता येते.
- Idle timeout नंतर session expire होऊ शकते.
- In-memory session app restart/app-pool recycle नंतर हरवू शकते.
- Browser cookie delete झाली तर session reference हरवू शकतो.
- Multi-server environment मध्ये distributed Redis session उपयोगी आहे.
- AJAX expiry साठी 401 + sessionExpired flag चांगला pattern आहे.
- Normal MVC request साठी login redirect + message योग्य आहे.
- Logout मध्ये Session.Clear आणि authentication sign-out वेगळे handle करावेत.
- Authentication आणि Session एकच गोष्ट नाहीत.
