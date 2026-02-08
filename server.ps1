$path = "c:\GitHub\innoridge.com"
$port = 5501
$listener = New-Object System.Net.HttpListener
# Bind to localhost to avoid requiring admin reservations and reduce conflicts with system services
$prefix = "http://localhost:$port/"
$listener.Prefixes.Add($prefix)
try {
    $listener.Start()
    Write-Host "Server started on $prefix"
} catch {
    Write-Host "Failed to start listener on $prefix : $($_.Exception.Message)"
    exit 1
}
while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response
    $localPath = $request.Url.LocalPath
    if ($localPath -eq "/") { $localPath = "/index.html" }
    $filePath = Join-Path $path $localPath.TrimStart("/")
    if (Test-Path $filePath -PathType Leaf) {
        # Determine content type
        $contentType = switch -Regex ($filePath) {
            "\.html$" { "text/html" }
            "\.css$" { "text/css" }
            "\.js$" { "application/javascript" }
            "\.ico$" { "image/x-icon" }
            "\.png$" { "image/png" }
            "\.jpg$|\.jpeg$" { "image/jpeg" }
            "\.gif$" { "image/gif" }
            "\.svg$" { "image/svg+xml" }
            "\.woff$" { "font/woff" }
            "\.woff2$" { "font/woff2" }
            default { "application/octet-stream" }
        }
        
        # Read file as binary or text based on type
        if ($contentType -like "text/*" -or $contentType -eq "application/javascript") {
            $content = Get-Content $filePath -Raw -Encoding UTF8
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
        } else {
            $buffer = [System.IO.File]::ReadAllBytes($filePath)
        }
        
        $response.ContentType = $contentType
        $response.ContentLength64 = $buffer.Length
        try {
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
        } catch {
            # Ignore write errors, e.g., client disconnected
        }
    } else {
        $response.StatusCode = 404
        $notFound = "<h1>404 Not Found</h1>"
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($notFound)
        $response.ContentLength64 = $buffer.Length
        try {
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
        } catch {
            # Ignore
        }
    }
    try {
        $response.OutputStream.Close()
    } catch {
        # Ignore
    }
}