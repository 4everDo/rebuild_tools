#!/bin/sh

#  android_build.sh
#  Runner
#
#  Created by Forever on 2021/8/10.
#  


# 工程路径
project_path=$(cd `dirname $0`; pwd)
# 打包文件导出地址
apk_path=~/Desktop/android_build
# 配置地址 读写版本号等
config_path=${project_path}/local.properties

#echo ${config_path}

project_name="Gaojin"
temp_versionName=""
temp_versionCode=""

echo "请输入打包版本号:"
read versionName
temp_versionName=$versionName
sed -i "" "s#^flutter.versionName=.*#flutter.versionName=$versionName#g"  ${config_path}

echo  "请输入build版本号:"
read versionCode
temp_versionCode=$versionCode
sed -i "" "s#^flutter.versionCode=.*#flutter.versionCode=$versionCode#g"  ${config_path}

echo "$project_name""_v""$temp_versionName""_""$temp_versionCode"

echo "编译中..."
./gradlew clean build --stacktrace
./gradlew app:assembleRelease

cp $(dirname "$PWD")/build/app/outputs/apk/release/"$project_name""_v""$temp_versionName""_""$temp_versionCode"".apk" ${apk_path}

echo "Done"


