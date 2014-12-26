#!/bin/bash

#替换apk的res目录中的文件并重新打包签名

target_apk=$1
replace_res_dir=$2
p12_cert_file=$3
cert_password=$4
unpack_target_dir=unpack_target
repack_apk_name=repack.apk

if [ -f ${target_apk} ]; then

	if [ -d ${unpack_target_dir} ]; then
		rm -r ${unpack_target_dir}
	fi

	echo "backup ${target_apk}"
	cp -Rfv ${target_apk} "${target_apk}.bak"

	echo "unpack ${target_apk} to ${unpack_target_dir}..."
	apktool d ${target_apk} ${unpack_target_dir}

	echo "replace files from ${replace_res_dir} to ${unpack_target_dir}/res/"
	cp -Rfv ${replace_res_dir}/* ${unpack_target_dir}/res/

	echo "pack apk..."
	apktool b ${unpack_target_dir} ${repack_apk_name}

	echo "sign apk..."
	jarsigner -verbose -sigalg MD5withRSA -digestalg SHA1 -keystore ${p12_cert_file} -storepass ${cert_password} -storetype pkcs12 -signedjar ${target_apk} ${repack_apk_name} 1

else
	echo ${target_apk} not exist!!
fi


