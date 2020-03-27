#!/bin/sh
#-----------------------------------------------------------
#脚本使用方式 sh git_diff.sh commit_id1 commit_id2
# commmit_id1 为变动前commitID  commit_id2为变动后commitID（即为本次最新的commitID）
#
#-----------------------------------------------------------
# 以下参数无需改动
#git diff a b 日志
git_diff_log="git_diff.log"
#获取差异化代码条件
code_path="diff --git"
code_row_number="@@"
#从git_diff_log中获取差异化代码信息
increment_log="increment.log"
#覆盖度全量报告文件名
total_out="system.out"

#覆盖度增量报告文件名
increment_out="increment.out"
#------------------------------------------------------------

function get_increment_log() {
	#从git diff日志中提取增量代码信息（路径 和 变化代码的起始、终止代码行）
	#管道法: 注释：当遇见管道的时候管道左边的命令的输出会作为管道右边命令的输入然后被输入出来。
	path=""
	cat ${git_diff_log} | while read line
	do
		result=`echo ${line} | grep -- "${code_path}"`
		#根据条件 匹配 比较代码路径
		if [[ "${result}" != "" ]]
		then
			#echo ${line}
			before_file=`echo "${line}" |awk -F " " '{print $3}'`
			now_file=`echo "${line}" |awk -F " " '{print $4}'`
			#echo ${before_file#*a}
			#echo ${now_file#*b}
			#echo >> ${increment_log}
			#将本次（变动后的文件路径）保存至文件中
			#echo -n ${now_file#*b} >> ${increment_log}
			path="${now_file#*b}"
		else
			result_row=`echo ${line}| grep -- "${code_row_number}"`
			#根据条件 匹配 日志中的变化代码的行数
			if [[ "${result_row}" != "" ]]
			then
				echo ${line} #line示例数据： @@ -0,0 +1,15 @@     -0,0代表变化前的代码数据  +1,15 代表变化后的代码从1行开始，连续15行的
				#获取变化前的数据 -0,0
				var1=`echo "${line}" |awk -F " " '{print $2}'`
				#获取变化后的数据 +1,15
				var2=`echo "${line}" |awk -F " " '{print $3}'`
				#echo "before_file:"${var1}
				#echo "now_file:"${var2}
				#获取变化前的起始行和连续行数
				before_file_start_col=`echo ${var1#*-} | awk -F "," '{print $1}'`
				before_file_end_col=`echo ${var1#*-} | awk -F "," '{print $2}'`
				#echo "before_file_start_col:"${before_file_start_col}
				#echo "before_file_end_col:"${before_file_end_col}
				#获取变化后的起始行和连续行数
				now_file_start_col=`echo ${var2#*+} | awk -F "," '{print $1}'`
				now_file_end_col=`echo ${var2#*+} | awk -F "," '{print $2}'`
				#echo "now_file_start_col:"${now_file_start_col}
				#echo "now_file_end_col:"${now_file_end_col}
				#算出增量代码 起始行数 和 终止行数
				increment_start_col=`expr ${now_file_start_col} + ${before_file_end_col}`
				#increment_end_col=`expr ${now_file_start_col} + ${before_file_end_col} + ${now_file_end_col} - ${before_file_end_col} - 1`
				#echo "increment_start_col:"${increment_start_col}
				#echo "increment_end_col:"${increment_end_col}
				#将增量代码 起始行数 和 终止行数保存至文件中
				increment_end_col=`expr ${now_file_start_col} + ${now_file_end_col} - 1`
				echo "${path} ${now_file_start_col} ${increment_end_col}" >> ${increment_log}
#				echo "${path} ${increment_start_col} ${increment_end_col}" >> ${increment_log}
			fi
		fi	
	done
}
function get_coverage_out() {
	#按行读取文本
	#读取git diff中的增量代码信息
        cat ${increment_log} | while read line
        do
		#判断本行是否是空字符串，-z 是 -n 否
		if [ -n "${line}" ]
		then
			echo "line1:"${line}
			increment_code_path=`echo ${line} | awk -F " " '{print $1}'`
			increment_start_col=`echo ${line} | awk -F " " '{print $2}'`
			increment_end_col=`echo ${line} | awk -F " " '{print $3}'`
			echo "increment_code_path:"${increment_code_path}"----"
			#echo ${increment_start_col}
			#echo ${increment_end_col}
			cat ${total_out} | while read line2
			#读取全量报告数据
			do
#				path=`echo ${line2} | awk -F " " '{print $1}' | awk -F ":" '{print $1}'`
				#判断git diff中的增量代码 是否在全量覆盖报告中，
				result=`echo ${line2} | grep -- "${increment_code_path}"`
				#echo "result:"${result}
				if [[ "${result}" != "" ]]
				then
					echo ${line2}
					path=`echo ${line2} | awk -F " " '{print $1}' | awk -F ":" '{print $1}'`
					total_start_col=`echo ${line2} | awk -F " " '{print $1}' | awk -F ":" '{print $2}' | awk -F "," '{print $1}' | awk -F "." '{print $1}'`
					total_end_col=`echo ${line2} | awk -F " " '{print $1}' | awk -F ":" '{print $2}' | awk -F "," '{print $2}' | awk -F "." '{print $1}'`
					#echo ${total_start_col}
					#echo ${total_end_col}
					if [[ ${increment_start_col} -le  ${increment_end_col} ]];then
						if [[ ${total_start_col} -le  ${total_end_col} ]];then
							if [[ ${increment_start_col} -le ${total_start_col} ]];then
								if [[ ${total_end_col} -le ${increment_end_col} ]];then
									echo ${line2} >> ${increment_out}
								fi
							fi
						fi
					fi	
				fi
			done
		fi
	done	

}


#
commit_start_id=`echo "$1"`
commit_now_id=`echo "$2"`

if [ -n "${commit_start_id}" ];then
	if [ -n "${commit_now_id}" ];then
		#清空获取增量期间生成的文件
		true > ${git_diff_log}
		true > ${increment_out}
		true > ${increment_log}
		#通过不同的commit id 获取增量代码数据
		git diff ${commit_start_id} ${commit_now_id} > ${git_diff_log}
		sleep 3s
		#获取增量代码的信息
		get_increment_log
		#全量报告 与 增量代码信息 合并，获取增量代码覆盖的报告
		sleep 4s
		get_coverage_out
		#在增量覆盖度报告中补充模式
		sed -i '1i\mode: count' ${increment_out}
		#sed -i "s/_${PWDSLASH}/./g" ${increment_out}
	else
		echo "error,please input now_commit_id!"
	fi
else
	echo "error,please input last_commit_id!"


fi

