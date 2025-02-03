REPLACE="
"

# Taken from unlock-cn-gms
# Credit: yujincheng08,feike https://github.com/fei-ke/unlock-cn-gms/
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



set_perm_recursive $MODPATH 0 0 0755 0644

rm -r /data/dalvik-cache
rm -r /cache/dalvik-cache