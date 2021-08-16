# rebuild_tools
# rebuild_tools
自动化打包工具

安卓自动化打包脚本
iOS自动化打包脚本

使用说明：
1. iOS打包在build之前最好加上权限，不然Jenklins 远程打包会有Command CodeSign failed with a nonzero exit code错误
   security unlock-keychain -p "admin123" ~/Library/Keychains/login.keychain
2. 输入打包版本号，build版本号必须为数字
3. Android打包错误 verifyReleaseResources FAILED 需修改执行命令 ./gradlew app:assembleRelease

