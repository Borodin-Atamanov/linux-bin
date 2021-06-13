#!/usr/bin/bash
#Script embed all image and video files in current directory to html file, use base64 encode
#In some day document will stop to show documents. (Find "new Date >" in code below, and try to change date)

OUTDIR="output";
mkdir -pv "$OUTDIR";
output="output/document-$(date "+%F-%H-%M-%S").htm";
#After this count of days*hours*seconds from today file will block from view
absolute_stop_access_after_date=$(( $(date +%s) + 177*24*3600));
absolute_stop_access_after_date="${absolute_stop_access_after_date}000";
#echo $absolute_stop_access_after_date;

#After this count of days*hours*seconds from file modify date file will block from view
stop_access_after_milliseconds_from_file_modify=$((50*24*3600));
stop_access_after_milliseconds_from_file_modify="${stop_access_after_milliseconds_from_file_modify}000";
#echo $stop_access_after_milliseconds_from_file_modify;

#TODO add access restriction from file open (use cookies to save open time)

IFS='' read -r -d '' html_file <<"@@@END_OF_DATA@@@"
<!DOCTYPE html><html lang="ru"><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="https://github.com/Borodin-Atamanov/embed_files_to_html">
<meta name="keywords" content="https://github.com/Borodin-Atamanov/embed_files_to_html">
<meta name="author" content="code@Borodin-Atamanov.ru">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Document</title>
<link href="data:image/x-icon;base64,AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADbOMTQ66TxqMMcwIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAs0D7JNv9M/yrRPqwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAk200rJd5R/SXgUv8k3lD8J9hOJwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAG+Ffnx/1aP8d62T/H/Vo/xzgX6YAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFuJmIxnqafsZ62r/GOZoyRnvbP8Z62r+F+hmLQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAF+h0CxbqbbgY/3n/FeZs5g/waREV5WzHGf99/xXkarYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABPpcF0W/4T/Ff+D/xPqcnkAAAAAE+xzKBLwd/YV/n7/EeduSgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAg34AIEO94cxHveKMA/5kFAAAAAAAAAAAP53RWEv+G/xHxet8g32AIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA3uenUQ/5T/De5+mAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACvODggz/mP8K84RoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAI9op4CP+W/wb2ilUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAb5j1kF+pDyA/mRUQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPmRLAH8k64A+5NAAP8AAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//8BAP+TLQD/qgMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//8AAP//AADx/wAA8f8AAOD/AADg/wAAxH8AAM5/AADvPwAA/58AAP+fAAD/7wAA//cAAP/7AAD//wAA//8AAA==" rel="icon" type="image/x-icon">
@@@END_OF_DATA@@@

echo -n "" > "${output}";
echo -n "${html_file}" >> "${output}";

IFS='' read -r -d '' css_style <<"@@@END_OF_DATA@@@"
body,
html
{
	height: 100%;
	margin: 0;
	padding: 0;
}

img, video, embed
{
	padding: 0;
	display: block;
	margin: 0 auto;
	max-height: 100%;
	max-width: 100%
}

.ontop
{
	z-index: 57;
}

#backgr
{
	width: 100%;
	height: 100%;
	position: fixed;
	left: 0;
	top: 0;
	z-index: 42;
}

.secret
{
	display: none;
	visibility: hidden;
}

.stretch100
{
	width: 100%;
	height: 100%
}
@@@END_OF_DATA@@@

b64_css_style=$( echo "${css_style}" | base64 --wrap=1023 );
str_css_style=$( echo -n "<link href=\"data:text/css;base64,${b64_css_style}\" rel=\"stylesheet\" type=\"text/css\">"; );
echo -n "${str_css_style}" >> "${output}";

js_script_part1="";
js_script_part1+="var absolute_maximum_access_date=${absolute_stop_access_after_date}; "
js_script_part1+="var relative_maximum_access_date = new Date(document.lastModified).getTime() + ${stop_access_after_milliseconds_from_file_modify}; "

IFS='' read -r -d '' js_script_part2 <<"@@@END_OF_DATA@@@"
if(!document.getElementsByClassName)
{
	document.getElementsByClassName = function(className)
	{
		return this.querySelectorAll("." + className);
	};
	Element.prototype.getElementsByClassName = document.getElementsByClassName;
}
function jekyll_or_hyde()
{
	console.log(new Date().getTime());
	console.log('absolute_maximum_access_date='+absolute_maximum_access_date+' ETA:'+((absolute_maximum_access_date - new Date().getTime())/1000));
	console.log('relative_maximum_access_date='+relative_maximum_access_date+' ETA:'+((relative_maximum_access_date - new Date().getTime())/1000));

	if ((new Date().getTime() > relative_maximum_access_date) || (new Date().getTime() > absolute_maximum_access_date))
	{
		var all = document.getElementsByClassName('secret');
		for (var i = 0; i < all.length; i++)
		{
			all[i].style.visibility="hidden";
			all[i].style.display="none";
		}
		for(var n=document.getElementsByTagName("img"), a=0; a<n.length; a++)n[a].style.display="none",
		n[a].style.visibility="hidden";
		document.write("Access denied");
	}
	else
	{
		//show must go on!
		var all = document.getElementsByClassName('secret');
		for (var i = 0; i < all.length; i++)
		{
			all[i].style.visibility="visible";
			all[i].style.display="block";
		}
	}
	timerId = setTimeout(jekyll_or_hyde, 17777);
}
function onloadfun()
{
	jekyll_or_hyde()
}
window.onload=onloadfun;
@@@END_OF_DATA@@@

js_script="${js_script_part1} ${js_script_part2}";
b64_js_script=$( echo "${js_script}" | base64 --wrap=1023 );
str_js_script=$( echo "<script src=\"data:text/javascript;base64,${b64_js_script}\"></script>"; );
echo -n "${str_js_script}" >> "${output}";

IFS='' read -r -d '' html_file <<"@@@END_OF_DATA@@@"
</head><body><div id="backgr"><img class=stretch100 alt="document" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAkAAAAJCAQAAABKmM6bAAAAD0lEQVR42mNkwACMg1QIAAQCAAqyn4R8AAAAAElFTkSuQmCC"></div>
@@@END_OF_DATA@@@
echo -n "${html_file}" >> "${output}";

for f in *.*;
do echo -n "";
mime_type=$( file --mime-type -b "$f" )
echo -n $mime_type;
echo "   $f";
b64_file_data=$( cat "${f}" | base64 --wrap=1023 );
if [[ $mime_type == *"image/"* ]]; then
	str_file_data=$( echo -n "<img class=\"secret\" src=\"data:${mime_type};base64,${b64_file_data}\" class=\"secret\" title=\"${f}\" alt=\"${f}\">"; );
elif [[ $mime_type == *"video/"* ]]; then
	str_file_data=$( echo -n "<video autoplay loop muted preload=auto><source src=\"data:${mime_type};base64,${b64_file_data}\" class=\"secret\" title=\"${f}\" alt=\"${f}\" type=\"${mime_type}\">Your browser does not support mp4 documents</video>"; );
elif [[ $mime_type == *"pdf"* ]]; then
	str_file_data=$( echo -n "<embed src=\"data:${mime_type};base64,${b64_file_data}\" class=\"secret ontop\" title=\"${f}\" alt=\"${f}\"  type=\"${mime_type}\">"; );
fi
echo -n "${str_file_data}" >> "${output}";
str_file_data="";
done;

IFS='' read -r -d '' html_file <<"@@@END_OF_DATA@@@"
<img class="secret" src="data:image/webp;base64,UklGRkIAAABXRUJQVlA4WAoAAAAQAAAACAAACAAAQUxQSAQAAAABiIgIVlA4IBgAAAAwAQCdASoJAAkAD8D+JaQAA3AA/ua1AAA=">
<!--
cat file.webp | base64 > file.base64.txt
mkdir -pv "base64"; for f in *.*; do cat ${f} | base64 --wrap=1023 > "base64/${f%.*}.base64.txt"; done;
-->
@@@END_OF_DATA@@@
echo -n "${html_file}" >> "${output}";

IFS='' read -r -d '' html_file <<"@@@END_OF_DATA@@@"
<script type="text/javascript">!function(e,t,a){(t[a]=t[a]||[]).push(function(){try{t.yaCounter16400947=new Ya.Metrika({id:16400947,clickmap:!0,trackLinks:!0,accurateTrackBounce:!0,webvisor:!0})}catch(e){}});function c(){n.parentNode.insertBefore(r,n)}var n=e.getElementsByTagName("script")[0],r=e.createElement("script");r.type="text/javascript",r.async=!0,r.src="https://mc.yandex.ru/metrika/watch.js","[object Opera]"==t.opera?e.addEventListener("DOMContentLoaded",c,!1):c()}(document,window,"yandex_metrika_callbacks");
</script><noscript><div><img src="https://mc.yandex.ru/watch/16400947" style="position:absolute; left:-9999px;" alt="" /></div></noscript>
@@@END_OF_DATA@@@

js_script_part3="";
yandex_metrika_id="16400947"
js_script_part3+='!function(e,t,a){(t[a]=t[a]||[]).push(function(){try{t.yaCounter16400947=new Ya.Metrika({id:';
js_script_part3+="${yandex_metrika_id}";
js_script_part3+=',clickmap:!0,trackLinks:!0,accurateTrackBounce:!0,webvisor:!0})}catch(e){}});function c(){n.parentNode.insertBefore(r,n)}var n=e.getElementsByTagName("script")[0],r=e.createElement("script");r.type="text/javascript",r.async=!0,r.src="https://mc.yandex.ru/metrika/watch.js","[object Opera]"==t.opera?e.addEventListener("DOMContentLoaded",c,!1):c()}(document,window,"yandex_metrika_callbacks");';

IFS='' read -r -d '' js_script <<"@@@END_OF_DATA@@@"
!function(e,t,a){(t[a]=t[a]||[]).push(function(){try{t.yaCounter16400947=new Ya.Metrika({id:16400947,clickmap:!0,trackLinks:!0,accurateTrackBounce:!0,webvisor:!0})}catch(e){}});function c(){n.parentNode.insertBefore(r,n)}var n=e.getElementsByTagName("script")[0],r=e.createElement("script");r.type="text/javascript",r.async=!0,r.src="https://mc.yandex.ru/metrika/watch.js","[object Opera]"==t.opera?e.addEventListener("DOMContentLoaded",c,!1):c()}(document,window,"yandex_metrika_callbacks");
@@@END_OF_DATA@@@
b64_js_script=$( echo "${js_script_part3}" | base64 --wrap=1023 );
str_js_script=$( echo "<script src=\"data:text/javascript;base64,${b64_js_script}\"></script>"; );
echo -n "${str_js_script}" >> "${output}";

echo -n '<noscript><div><img style="position:absolute; left:-9999px;" alt="" src="https://mc.yandex.ru/watch/' >> "${output}";
echo -n "${yandex_metrika_id}" >> "${output}";
echo -n '"/></div></noscript>' >> "${output}";
echo -n "</body></html>" >> "${output}";


