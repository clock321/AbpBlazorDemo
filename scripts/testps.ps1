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
