$start1stop0 = "%22ZX%22.STOP=0&%22ZX%22.START=1"
$start0stop1 = "%22ZX%22.STOP=1&%22ZX%22.START=0"
$ip= "192.168.2.222"
$urlbase = "https://"+$ip
$url_index = $urlbase+"/awp/best2/index.html"
$url_login = $urlbase+"/FormLogin"
$url_login
$url_logout = $urlbase+"/FormLogin?LOGOUT"
$url_logout
$LoginResponse = Invoke-WebRequest -UseBasicParsing `
-SkipCertificateCheck `
-SessionVariable websession `
-Uri $url_login `
-Method POST `
-ContentType "application/x-www-form-urlencoded" `
-Body "Redirection=&Login=admin&Password="
$LoginResponse
$cookies = $websession.Cookies.GetCookies($urlbase) 
$cookies.Name
$cookies.Value
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.Cookies.Add((New-Object System.Net.Cookie($cookies.Name, $cookies.Value, "/", $ip)))

Invoke-WebRequest -UseBasicParsing -SkipCertificateCheck `
-Uri $url_index `
-Method POST `
-WebSession $session `
-ContentType "application/x-www-form-urlencoded" `
-Body $start1stop0

ping 127.0.0.1 -n 2

Invoke-WebRequest -UseBasicParsing -SkipCertificateCheck `
-Uri $url_index `
-Method POST `
-WebSession $session `
-ContentType "application/x-www-form-urlencoded" `
-Body $start0stop1

$logout_body="Redirection=.&Cookie="+$cookies.Value+"%3D"
$logout_body
Invoke-WebRequest -UseBasicParsing -SkipCertificateCheck `
-Uri $url_logout `
-Method POST `
-WebSession $session `
-ContentType "application/x-www-form-urlencoded" `
-Body $logout_body

