#!/bin/bash

#替换ane中android的res资源重新生成ane

parent_path=`pwd`
target_ane_base_name=$1
replace_res_dir=$2

res_arm_dir=META-INF/ANE/Android-ARM/res/
res_x86_dir=META-INF/ANE/Android-x86/res/

target_ane=`find ${target_ane_base_name}`

if [ -f ${target_ane} ] && [ -d ${replace_res_dir} ]; then

	target_dir=`dirname ${target_ane}`
	target_name=`basename ${target_ane}`
    unpack_ane_tem_dir="${target_dir}/unpack_temp"

    if [ -d ${unpack_ane_tem_dir} ]; then
		rm -r ${unpack_ane_tem_dir}
	fi

	echo "unpack ${target_ane} to ${unpack_ane_tem_dir}"
	unzip -oq ${target_ane} -d ${unpack_ane_tem_dir}

	echo "replace files ${replace_res_dir}/ to ${unpack_ane_tem_dir}/${res_arm_dir}"
	cp -Rf ${replace_res_dir}/* ${unpack_ane_tem_dir}/${res_arm_dir}

	echo "replace files ${replace_res_dir}/ to ${unpack_ane_tem_dir}/${res_x86_dir}"
	cp -Rf ${replace_res_dir}/* ${unpack_ane_tem_dir}/${res_x86_dir}

	echo "repack ane ${target_ane}"
	cd ${unpack_ane_tem_dir}
	zip -r9Dq ${target_name} META-INF catalog.xml library.swf mimetype
	cd ${parent_path}
	mv -f ${unpack_ane_tem_dir}/${target_name} ${target_ane}
	rm -r ${unpack_ane_tem_dir}

else
    echo ${target_ane} or ${replace_res_dir} not exist!!
fi