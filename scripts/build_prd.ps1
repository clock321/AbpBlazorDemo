# 以上脚本均需要在powershell中使用

$buildFolder = (Get-Item -Path "./" -Verbose).FullName ## 当前文件所在目录
$slnFolder = Join-Path $buildFolder "../"   ## 当前解决方案所在文件夹
$outputFolder = Join-Path $buildFolder "outputs" ## 当前文件夹下的outputs文件夹
$ProjectNamePrefix="YoyoMooc.StuManagement"
$tagver="t"+$(Get-Date  -Format 'yyMMddHHmm')
$ProjectNames= "YoyoMooc.StuManagement.Web","YoyoMooc.StuManagement.Api"  #要build的csproject名称,需配置
$ImageNames= "yoyomooc/blazorwebdemo","yoyomooc/blazorapidemo"  #要build的docker镜像名称,需配置
$RemoteImageRepoNames= "blazorwebdemo","blazorapidemo"  #要推送的docker镜像仓库名称,需配置

## CLEAR ######################################################################
Write-Host "Delete Temp Folder"
Remove-Item $outputFolder -Force -Recurse -ErrorAction Ignore
New-Item -Path $outputFolder -ItemType Directory

foreach ($ProjectName in $ProjectNames)
{
    $ImageName = $ImageNames.GetValue($ProjectNames.IndexOf($ProjectName))
    $ProjectFolder = Join-Path $slnFolder $ProjectName  ## 项目所在文件夹路径
    $postname=$ProjectName -replace $ProjectNamePrefix,""
    $postname=$postname.Trim('.')
    $outputWebFolder = Join-Path $outputFolder $postname

    Write-Output " `start bluid image $ImageName output: $postname input:$ProjectFolder"

    # 设置路径到解决方案文件夹  ###################################################
    Set-Location $ProjectFolder
   
    # 还原项目依赖的包然后发布###################################################
    dotnet restore
    dotnet publish  --configuration Release --output (Join-Path $outputFolder $postname) 
    copy-item   (Join-Path $buildFolder "wait-for-it")   -destination   (Join-Path $outputWebFolder "wait-for-it.sh") 
    
   # 创建Docker镜像 ####################
    Set-Location (Join-Path $outputFolder $postname)
    docker rmi $ImageName -f
    docker build -t $ImageName --build-arg imageVersion=$tagver .
    ## DOCKER COMPOSE FILES ####################################################### 
}

docker login --username=atclock@sina.com -p hBRc5XJPMK@PgMr registry.cn-hangzhou.aliyuncs.com  
Copy-Item (Join-Path $buildFolder "docker/*.*") $outputFolder
foreach ($ImageName in $ImageNames)
{
    $RemoteImageRepoName = $RemoteImageRepoNames.GetValue($ImageNames.IndexOf($ImageName))
    $RemoteImageName=$RemoteImageRepoName,$tagver -join ":"

    Write-Output " `start push image $ImageName to: $RemoteImageName"

    docker tag $ImageName registry.cn-hangzhou.aliyuncs.com/zybprd/$RemoteImageName
    docker push  registry.cn-hangzhou.aliyuncs.com/zybprd/$RemoteImageName

    #推送覆盖远程镜像仓库的lastest版本,用于自动部署
    docker tag $ImageName registry.cn-hangzhou.aliyuncs.com/zybprd/$RemoteImageRepoName
    docker push  registry.cn-hangzhou.aliyuncs.com/zybprd/$RemoteImageRepoName
}

Set-Location $buildFolder

Write-Host 'Press Any Key!' -NoNewline
$null = [Console]::ReadKey('?')