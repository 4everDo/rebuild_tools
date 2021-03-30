#!/bin/sh

#  rebuild.sh
#  Runner
#
#  Created by admin on 2021/3/29.
#  

# 打包流程
# 工程路径
project_path=$(cd `dirname $0`; pwd)
# 工程名
project_name=Runner
# Scheme名称
scheme_name=Runner
# 打包模式
development_mode=Release
# 苹果账号
developer_account="dev@gogen.com.cn"
# 苹果账号密码
developer_pwd="AppleDev8@GOGEN"
# 蒲公英Userkey
uKey="2d10f271f5c0fb1609caa0af47de7139"
# 蒲公英APIKEY
apiKey="ab1727828697d91d9ec5232fb87ff9e2"
# APP name
app_name="高锦社区"


# plist路径
exportOptionsPlistPath=${project_path}/development.plist
# build文件夹路径
build_path=~/Desktop/build
# ipa文件夹
exportIpaPath=${build_path}/$project_name-ipa

# 开始打包
echo "开始打包..."
# 移除
#rm -r $exportIpaPath
# 获取info.plist 路径 用于读取内容
path_info_plist="${project_path}/${project_name}/info.plist"

if [ -e ${path_info_plist} ]; then
    echo "获取info plist文件 ${path_info_plist}"
fi

# 选择发布版本还是开发版本
echo "请选择，1-发布版本，2-开发版本 ..."
read type
while([[ $type != 1 ]] && [[ $type != 2 ]])
do
echo "错误!只能输入1或者2！！！"
read number
done

# 重新配置plist ipa 路径
if [ $type == 1 ]; then
    development_mode=Release
    exportOptionsPlistPath=${project_path}/distribution.plist
    exportIpaPath=${build_path}/$project_name-ipa
else
  development_mode=Release
  exportOptionsPlistPath=${project_path}/development.plist
  exportIpaPath=${build_path}/$project_name-ipa
fi



echo "当前版本号： \c"
/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$path_info_plist"
echo "当前的build: \c"
/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$path_info_plist"

echo "请输入打包版本号："
read bundleVersion
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $bundleVersion" "$path_info_plist"

echo "请输入build版本号："
read bundleBuild
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $bundleBuild" "$path_info_plist"


echo "开始编译..."

xcodebuild \
archive -workspace ${project_path}/${project_name}.xcworkspace \
-scheme ${scheme_name} \
-configuration ${development_mode} \
-archivePath ${build_path}/${project_name}.xcarchive  -quiet  || exit

echo "..."
echo "开始打包..."

xcodebuild -exportArchive -archivePath ${build_path}/${project_name}.xcarchive \
-configuration ${development_mode} \
-exportPath ${exportIpaPath} \
-exportOptionsPlist ${exportOptionsPlistPath} \
-quiet || exit

echo "打包完成 Done"
if [ -e ${$exportIpaPath}/${scheme_name}.ipa ]; then
  open $exportIpaPath
else
  echo "IPA导出包失败"
  exit 1
fi

echo "是否开始上传..."

read number  #1 上传 0 不上传结束
if [ $number == 1 ]; then
  echo "上传中..."
  curl -F "file=@${exportIpaPath}/${app_name}.ipa" -F "uKey=${uKey}" -F "_api_key=${apiKey}" http://www.pgyer.com/apiv1/app/upload
  echo  "上传完成 Done!"
else
  echo "Done"
  exit 1
fi



exit 0


