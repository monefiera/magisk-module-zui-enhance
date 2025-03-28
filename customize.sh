REPLACE="
/system/priv-app/LenovoStore
/system/priv-app/ZuiNewBrowser
/system/product/priv-app/LenovoXiaoTian
/system/vendor/etc/thermal-engine_cpu_0.conf
/system/vendor/etc/thermal-engine_cpu_1.conf
/system/vendor/etc/thermal-engine_cpu_2.conf
/system/vendor/etc/thermal-engine_cpu_3.conf
/system/vendor/etc/thermal-engine_cpu_4.conf
/system/vendor/etc/thermal-engine_gpu_0.conf
/system/vendor/etc/thermal-engine_gpu_1.conf
/system/vendor/etc/thermallevel_to_fps.xml
/system/vendor/etc/pwr/GamePowerOptFeature.xml
/system/vendor/etc/perf
/system/vendor/etc/perf/perfboostsconfig.xml
/system/vendor/etc/perf/targetresourceconfigs.xml
/system/vendor/etc/perf/testcommonresourceconfigs.xml
/system/vendor/etc/perf/commonsysnodesconfigs.xml
/system/vendor/etc/perf/perfconfigstore.xml
/system/vendor/etc/perf/targetavcsysnodesconfigs.xml
/system/vendor/etc/perf/targetconfig.xml
/system/vendor/etc/perf/targetsysnodesconfigs.xml
/system/vendor/etc/perf/testtargetresourceconfigs.xml
"
PACKAGES="
"

# Taken from unlock-cn-gms
# Credit: feike https://github.com/fei-ke/unlock-cn-gms/
pm enable com.google.android.gms
pm enable com.google.android.gsf
pm enable com.android.vending
pm enable com.google.android.onetimeinitializer
pm enable com.google.android.partnersetup

if [ -e /system/etc/permissions/services.cn.google.xml ]; then
    origin=/system/etc/permissions/services.cn.google.xml
elif [ -e /system/etc/permissions/com.oppo.features.cn_google.xml ]; then
    origin=/system/etc/permissions/com.oppo.features.cn_google.xml
elif [ -e /vendor/etc/permissions/services.cn.google.xml ]; then
    origin=/vendor/etc/permissions/services.cn.google.xml
elif [ -e /product/etc/permissions/services.cn.google.xml ]; then
    origin=/product/etc/permissions/services.cn.google.xml
elif [ -e /product/etc/permissions/cn.google.services.xml ]; then
    origin=/product/etc/permissions/cn.google.services.xml
elif [ -e /my_bigball/etc/permissions/oplus_google_cn_gms_features.xml ]; then
    origin=/my_bigball/etc/permissions/oplus_google_cn_gms_features.xml
elif [ -e /my_heytap/etc/permissions/my_heytap_cn_gms_features.xml ]; then
    origin=/my_heytap/etc/permissions/my_heytap_cn_gms_features.xml
else
    abort "File not found!"
fi

if [[ $origin == *my_bigball* ]]; then
    target=$MODPATH/oplus_google_cn_gms_features.xml
    echo -e '#!/system/bin/sh\nmount -o ro,bind ${0%/*}/oplus_google_cn_gms_features.xml /my_bigball/etc/permissions/oplus_google_cn_gms_features.xml' > $MODPATH/post-fs-data.sh
    # echo 'sleep 60; umount /my_bigball/etc/permissions/oplus_google_cn_gms_features.xml' > $MODPATH/service.sh
elif [[ $origin == *my_heytap* ]]; then
    target=$MODPATH/my_heytap_cn_gms_features.xml
    echo -e '#!/system/bin/sh\nmount -o ro,bind ${0%/*}/my_heytap_cn_gms_features.xml /my_heytap/etc/permissions/my_heytap_cn_gms_features.xml' > $MODPATH/post-fs-data.sh
    if [[ -e /my_heytap/etc/permissions/my_heytap_cn_features.xml ]]; then
        echo -e '\nmount -o ro,bind ${0%/*}/my_heytap_cn_features.xml /my_heytap/etc/permissions/my_heytap_cn_features.xml' >> $MODPATH/post-fs-data.sh
        heytap_cn_features_orgin=/my_heytap/etc/permissions/my_heytap_cn_features.xml
        heytap_cn_features_target=$MODPATH/my_heytap_cn_features.xml
    fi
elif [[ $origin == *system* || $KSU ]]; then
    target=$MODPATH$origin    
else
    target=$MODPATH/system$origin
fi

mkdir -p $(dirname $target)
cp -f $origin $target
sed -i '/cn.google.services/d' $target
sed -i '/services_updater/d' $target
ui_print "modify $origin"

if [[ -e $heytap_cn_features_orgin ]]; then
mkdir -p $(dirname $heytap_cn_features_target)
cp -f $heytap_cn_features_orgin $heytap_cn_features_target
sed -i '/cn.google.services/d' $heytap_cn_features_target
sed -i '/services_updater/d' $heytap_cn_features_target
ui_print "modify $heytap_cn_features_orgin"
fi


# Set Japanese Launguage

settings put system system_locales ja-JP;


# Switch to some apps to system-app

if [ -d /data/app/*'=='/'com.omarea.vtools'*'==' ]; then
mkdir -p $MODPATH/system/app/com.omarea.vtools
cp -r /data/app/*'=='/'com.omarea.vtools'*'=='/* $MODPATH/system/app/com.omarea.vtools/
fi

if [ -d /data/app/*'=='/'com.aurora.store'*'==' ]; then
mkdir -p $MODPATH/system/app/com.aurora.store
cp -r /data/app/*'=='/'com.aurora.store'*'=='/* $MODPATH/system/app/com.aurora.store/
fi

# Add denylist Google Apps to achieve MEETS_BASIC_INTEGRITY and avoid defects caused by font modules

magisk --denylist add com.android.vending com.android.vending
magisk --denylist add com.android.vending com.android.vending:background
magisk --denylist add com.android.vending com.android.vending:instant_app_installer
magisk --denylist add com.android.vending com.android.vending:quick_launch
magisk --denylist add com.android.vending com.android.vending:recovery_mode
magisk --denylist add com.android.vending com.google.android.finsky.verifier.apkanalysis.service.ApkContentsScanService
magisk --denylist add com.google.android.gms com.google.android.gms
magisk --denylist add com.google.android.gms com.google.android.gms.feedback
magisk --denylist add com.google.android.gms com.google.android.gms.learning
magisk --denylist add com.google.android.gms com.google.android.gms.persistent
magisk --denylist add com.google.android.gms com.google.android.gms.remapping1
magisk --denylist add com.google.android.gms com.google.android.gms.room
magisk --denylist add com.google.android.gms com.google.android.gms.ui
magisk --denylist add com.google.android.gms com.google.android.gms.unstable
magisk --denylist add com.google.android.gms com.google.android.gms:car
magisk --denylist add com.google.android.gms com.google.android.gms:identitycredentials
magisk --denylist add com.google.android.gms com.google.android.gms:snet

# Disable some apps cannnot replace

pm disable-user --user 0 magisk --denylist add com.zui.contacts
pm disable-user --user 0 magisk --denylist add com.zui.filemanager
pm disable-user --user 0 magisk --denylist add com.zui.clone
pm disable-user --user 0 magisk --denylist add com.lenovo.leos.cloud.sync

set_perm_recursive $MODPATH 0 0 0755 0644
set_perm $MODPATH 0 0 0644

rm -r /data/dalvik-cache
rm -r /cache/dalvik-cache