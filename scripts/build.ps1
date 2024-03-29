# 以上脚本均需要在powershell中使用

$buildFolder = (Get-Item -Path "./" -Verbose).FullName ## 当前文件所在目录
$slnFolder = Join-Path $buildFolder "../"   ## 当前解决方案所在文件夹
$outputFolder = Join-Path $buildFolder "outputs" ## 当前文件夹下的outputs文件夹
$webFolder = Join-Path $slnFolder "YoyoMooc.StuManagement.Web"  ## web项目所在文件夹路径
$apiFolder = Join-Path $slnFolder "YoyoMooc.StuManagement.Api"  ## web项目所在文件夹路径

 
$outputWebFolder = Join-Path $outputFolder "web"
$outputApiFolder = Join-Path $outputFolder "Api"
$newtag = date -f yyMMddHHmm
echo $newtag

## CLEAR ######################################################################
Write-Host "Delete Temp Folder"
Remove-Item $outputFolder -Force -Recurse -ErrorAction Ignore
New-Item -Path $outputFolder -ItemType Directory
 
# 设置路径到解决方案文件夹  ###################################################
Set-Location $webFolder

# 还原项目依赖的包然后发布###################################################
dotnet restore

dotnet publish  --configuration Release --output (Join-Path $outputFolder "web")
 
copy-item   (Join-Path $buildFolder "wait-for-it")   -destination   (Join-Path $outputWebFolder "wait-for-it.sh") 


# 设置路径到解决方案文件夹  ###################################################
Set-Location $apiFolder

# 还原项目依赖的包包然后发布###################################################
dotnet restore

dotnet publish  --configuration Release --output (Join-Path $outputFolder "api")

copy-item   (Join-Path $buildFolder "wait-for-it")   -destination   (Join-Path $outputApiFolder "wait-for-it.sh") 

# 创建Docker镜像 ####################

# web
Set-Location (Join-Path $outputFolder "web")

docker rmi yoyomooc/blazorwebdemo -f

docker build -t yoyomooc/blazorwebdemo .
 

## api

Set-Location (Join-Path $outputFolder "api")
docker rmi yoyomooc/blazorapidemo -f

docker build -t yoyomooc/blazorapidemo .


## DOCKER COMPOSE FILES #######################################################

Copy-Item (Join-Path $buildFolder "docker/*.*") $outputFolder

docker login --username=atclock@sina.com -p hBRc5XJPMK@PgMr registry.cn-hangzhou.aliyuncs.com 

docker tag  yoyomooc/blazorapidemo registry.cn-hangzhou.aliyuncs.com/zybdev/blazorapidemo:t$newtag

docker tag  yoyomooc/blazorwebdemo registry.cn-hangzhou.aliyuncs.com/zybdev/blazorwebdemo:t$newtag

docker push  registry.cn-hangzhou.aliyuncs.com/zybdev/blazorapidemo:t$newtag
docker push  registry.cn-hangzhou.aliyuncs.com/zybdev/blazorwebdemo:t$newtag

Set-Location $buildFolder

Write-Host 'Press Any Key!' -NoNewline
$null = [Console]::ReadKey('?')

#请求https
#Invoke-WebRequest -Uri "https://www.baidu.com" -UseBasicParsing
#Invoke-WebRequest -Uri "https://www.baidu.com" -UseBasicParsing | Select-Object -ExpandProperty BaseResponse
#Invoke-WebRequest -Uri "https://www.baidu.com" -UseBasicParsing | Select-Object -ExpandProperty BaseResponse | Select-Object -ExpandProperty Headers
#请求http
#Invoke-WebRequest -Uri "http://www.baidu.com" -UseBasicParsing
#Invoke-WebRequest -Uri "http://www.baidu.com" -UseBasicParsing | Select-Object -ExpandProperty BaseResponse
#Invoke-WebRequest -Uri "http://www.baidu.com" -UseBasicParsing | Select-Object -ExpandProperty BaseResponse | Select-Object -ExpandProperty Headers
#请求https
#Invoke-WebRequest -Uri "https://www.baidu.com" -UseBasicParsing -Method Head
#Invoke-WebRequest -Uri "https://www.baidu.com" -UseBasicParsing -Method Head | Select-Object -ExpandProperty BaseResponse
#Invoke-WebRequest -Uri "https://www.baidu.com" -UseBasicParsing -Method Head | Select-Object -ExpandProperty BaseResponse | Select-Object -ExpandProperty Headers
#请求http
#Invoke-WebRequest -Uri "http://www.baidu.com" -UseBasicParsing -Method Head
#Invoke-WebRequest -Uri "http://www.baidu.com" -UseBasicParsing -Method Head | Select-Object -ExpandProperty BaseResponse
#Invoke-WebRequest -Uri "http://www.baidu.com" -UseBasicParsing -Method Head | Select-Object -ExpandProperty BaseResponse | Select-Object -ExpandProperty Headers
#获取本机IP
#(Invoke-WebRequest -Uri "http://ip.3322.net").Content
#获取本机IP
#(Invoke-WebRequest -Uri "http://ip.3322.net").RawContent
#获取本机IP
#(Invoke-WebRequest -Uri "http://ip.3322.net").RawContent.Split(" ")[0]
#获取本机IP
#(Invoke-WebRequest -Uri "http://ip.3322.net").RawContent.Split(" ")[0].Replace(" ","")
#获取本机IP
#(Invoke-WebRequest -Uri "http://ip.3322.net").RawContent.Split(" ")[0].Replace(" ","").Replace("
#","")