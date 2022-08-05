function npm_install {
    cd  $1
    npm install
}

npm config set registry http://mirrors.tools.huawei.com/npm/
npm config set @ohos:registry https://cmc.centralrepo.rnd.huawei.com/artifactory/api/npm/product_npm/
npm config set strict-ssl false
npm config set sslVerify false

APP_HOME="`pwd -P`"
npm_install "$APP_HOME"
npm_install "$APP_HOME/product/default/navigationBar"
npm_install "$APP_HOME/product/default/notificationmanagement"
npm_install "$APP_HOME/product/default/volumepanel"
npm_install "$APP_HOME/product/pc/controlpanel"
npm_install "$APP_HOME/product/pc/notificationpanel"
npm_install "$APP_HOME/product/pc/statusbar"

cd $APP_HOME
cp ./compile-resource.js ./node_modules/@ohos/hvigor-ohos-plugin/src/tasks/compile-resource.js
node ./node_modules/@ohos/hvigor/bin/hvigor.js --mode module assembleHap