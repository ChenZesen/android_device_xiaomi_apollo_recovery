apt install git aria2 rsync curl sudo wget zstd -y
cd /drone/

echo "Download the source code"

wget -O - "https://github.com/Mikubill/transfer/releases/download/v0.4.11/transfer_0.4.11_linux_amd64.tar.gz" | tar -x --gzip -C /usr/bin/
transfer https://we.tl/t-rR6yeDNa4Y?src=dnl
tar axf orangfox.tar.zst

echo "Setting Up the Compile Environment "

git clone https://gitlab.com/OrangeFox/misc/scripts
bash scripts/setup/android_build_env.sh
bash scripts/setup/install_android_sdk.sh

echo "Start compiling "

cd fox_10.0
git clone https://github.com/TeamWin/android_device_qcom_twrp-common -b android-11 device/qcom/twrp-common
git clone https://github.com/ChenZesen/android_device_xiaomi_apollo_recovery.git device/xiaomi/apollo
mkdir vendor/recovery/security/
wget https://gitlab.com/OrangeFox/vendor/recovery/-/raw/master/security/miui.x509.pem?inline=false -O vendor/recovery/security/miui.x509.pem
source build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
export LC_ALL="C"
lunch omni_apollo-eng && mka recoveryimage
transfer wet /drone/fox_10.0/out/target/product/apollo/*.zip
