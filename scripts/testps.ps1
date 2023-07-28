$arr1 = "aa","bb","cc"
$arr2 = "11","22","33"
foreach ($n in $arr1)
{
    $y = $arr2.GetValue($arr1.IndexOf($n))
    echo "/$n/is:$y"
}
$ProjectName="YoyoMooc.StuManagement.Web"
$ProjectNamePrefix="YoyoMooc.StuManagement"
$postname=$ProjectName -replace $ProjectNamePrefix,""
echo $postname
$postname=$postname.Trim('.')
echo $postname
echo $ProjectName


"t"+$(Get-Date  -Format 'yyMMddHHmm')
echo version=$postname

//����url
$Url = "http://localhost:5000/api/Version/GetVersionInfo?projectName=$ProjectName&version=$postname"
echo $Url
//����
$result = Invoke-WebRequest -Uri $Url -Method Get
echo $result
//jsonת��
$versionInfo = $result | ConvertFrom-Json
echo $versionInfo
echo $versionInfo.Success
echo $versionInfo.Data
echo $versionInfo.Message
echo $versionInfo.Data.Version
echo $versionInfo.Data.ProjectName
echo $versionInfo.Data.ProjectName
//�ж��Ƿ�ɹ�
if ($versionInfo.Success)
{
    echo "����ɹ�"
    echo $versionInfo.Data.Version
    echo $versionInfo.Data.ProjectName
    echo $versionInfo.Data.ProjectName
}
else
{
    echo "����ʧ��"
    echo $versionInfo.Message
}
#����https
