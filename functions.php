<?php

/**
Функции
* @date 2018-07-09 11:06
* @Author Alex Borodin-Atamanov <php@borodin-atamanov.ru>
* @Version 2.0.0
*/

function escape_str_to_bash ($field)
{
    //  @date 2019-03-19 22-13-05
    // @Author Alex Borodin-Atamanov
    //  Function converts any string to \xHH\xHH format
    //  For example: FFFFFFFF -> \xFF\xFF\xFF\xFF, " "(space) -> \x20 
    $field=bin2hex($field);
    $field=chunk_split($field,2,"\\x");
    $field= "\\x" . substr($field,0,-2);    
    return $field;
}

function errors_to_globals ($errno, $errstr, $errfile=NULL, $errline=NULL, $errcontext=NULL)
{
	//	Фукнция - обработчик ошибок. (http://php.net/set_error_handler)
	//	Добавляет ошибку в глобальный массив
	global $php_errors_array;

	$error = compact('errno', 'errstr', 'errfile', 'errline', 'errcontext');
	//	Сгененируем Уникальный идентификатор ошибки (чтобы не писать повторы в массив)
	#$error_id = base64_encode(hex2bin(sha1(serialize($errno.$errstr.$errfile.$errline.serialize($errcontext)))));	//	Сохраняет все ошибки, даже повторяющиеся
	$error_id = base64_encode(hex2bin(sha1(serialize($errno.$errstr.$errfile.$errline))));	//	Только уникальные ошибки добавляются в массив
	$error_id = base64_encode(hex2bin(sha1(serialize($errno.$errstr.$errfile.$errline.serialize(array_keys($errcontext))))));	//	Только уникальные ошибки добавляются в массив

	$php_errors_array[$error_id] = $error;

	return false;	//	Чтобы сработал обработчик ошибок $php_errormsg
}

function get_random_password_from_2_strings ($len, $random_reverse=true, $s1='rtpsdfghkzxcvbnm', $s2='euioa')
{
	/*	Фунция генерирует строчку с паролем,
		с чередованием случайных символов из первого и второго набора (аргументы 3 и 4).
		Второй аргумент отвечает за случайное переворачивание строки (с вероятностью ~50%)
		Получает длину строки в аргументах
		@date 2018-07-05 21-22-19
		@Author Alex Borodin-Atamanov
	*/
	$res = '';	//	Складываем в строку результат
	//	Цикл пока не достигнем нужной длины строки
	while (strlen($res) < $len)
	{
		//	Проверим, что у нас есть функция генерации случайных чисел криптографического качества
		if (function_exists('random_int'))
		{
			//	Используем криптографически-стойкий генератор случайных числел
			//	Добавим в $res два случайных символа - по одному из каждой строки
			$res .= $s1[random_int(0, strlen($s1)-1)];
			$res .= $s2[random_int(0, strlen($s2)-1)];
			$reverse = random_int(0, 1);
		}
		else
		{
			//	Используем устаревшую функцию
			$res .= $s1[mt_rand(0, strlen($s1)-1)];
			$res .= $s2[mt_rand(0, strlen($s2)-1)];
			$reverse = mt_rand(0, 1);
		}
	}
	$res = substr($res, 0, $len);//	Обрежем лишнее
	//	Перевернём строку (если надо)
	if (($random_reverse) && ($reverse))
	{
		$res = strrev($res);
	}

	return $res;
}

function send_post_to_url($url, $post_data)
{
	//	Функция возвращает результат запроса к URL
	//	Получает URL и массив запроса
	//	Возвращает результат
	//	2017-05-14 21-01-53
	// создаем подключение
	$ch = curl_init($url);
	// устанавлваем даные для отправки
	// curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
	curl_setopt($ch, CURLOPT_POSTFIELDS, urldecode(http_build_query($post_data))); // Хитрый трюк, иначе cURL не понимает многомерные массивы
	// флаг о том, что нужно получить результат
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_TIMEOUT, 300); //timeout after 30 seconds
	curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_ANY);
	// curl_setopt($ch, CURLOPT_USERPWD, "$username:$password");
	curl_setopt($ch, CURLOPT_SSL_VERIFYHOST,false);	//	Чтобы не проверялись нюансы SSL
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER,false);	//	Чтобы не проверялись нюансы SSL
	// отправляем запрос
	$response = curl_exec($ch);
	// закрываем соединение
	curl_close($ch);
	return ($response);
}


function array_to_xml(array $arr, SimpleXMLElement $xml)
{
	//http://stackoverflow.com/questions/1397036/how-to-convert-array-to-simplexml
    foreach ($arr as $k => $v)
    {
        is_array($v) ? array_to_xml($v, $xml->addChild($k)) : $xml->addChild($k, $v);
    }
    return $xml;
}

/*
$test_array = array (
    'bla' => 'blub',
    'foo' => 'bar',
    'another_array' => array (
        'stack' => 'overflow',
    ),
);
*/

// echo array_to_xml($test_array, new SimpleXMLElement('<root/>'))->asXML();
function mutli_byte_string_to_array ($string, $encoding="UTF-8")
{
	/*
	Фукнция делит мультибайтовую строку на символы, возвращает массив символов
	Второй аргумент - кодировка
	http://php.net/manual/ru/function.mb-split.php
	I figure most people will want a simple way to break-up a multibyte string into its individual characters. Here's a function I'm using to do that. Change UTF-8 to your chosen encoding method.
	* @Author adjwilli at yahoo dot com

	*/
	$strlen = mb_strlen($string, $encoding);
	while ($strlen)
	{
		$array[] = mb_substr($string,0,1,$encoding);
		$string = mb_substr($string,1,$strlen,$encoding);
		$strlen = mb_strlen($string, $encoding);
	}
	return $array;
}

function mask_filter ($str, $mask='0123456789AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz', $invert_mask=false, $mutli_byte_encoding='pass')
{
	/**
	Функция валидит полученную строку, оставляет только символы, которые заданы во втором аргументе
	Если Третий аргумент равен true (или 1), то действует наоборот - удаляет только заданные вторым аргументом символы
	Четвёрный аргумент - кодировка мультибайтовой строки ('UTF-8') или pass (по-умолчанию). Если получена кодировка, то происходит разделение строки на мультибайтовый символы
	* @date 2017-04-27 21-28-07
	* @Author Alex Borodin-Atamanov <php@borodin-atamanov.ru>
	* @Version 2.0.0
	*/

	//	Может получать вторым аргументом символы, которые можно пропускать (остальные удаляются)
	$valid_str = "";	//	Строка, куда запишем валидный номер

	//	Надо ли убирать все лишние символы или действовать наоборот (убирать заданные, оставлять остальные символы)?
	$invert = ($invert_mask == false) ?  false : true;
	//	Кодировка для mb_strpos - для однобайтных символов - "pass" - то есть не вмешиваться в кодировку, оставить как есть
	//$mutli_byte_encoding_for_mb_strpos = ($mutli_byte_encoding == false) ?  'pass' : $mutli_byte_encoding;

	// for($i = 0; $i < strlen($str); $i++)
	$strarr = mutli_byte_string_to_array ($str, $mutli_byte_encoding);
	$maskarr = mutli_byte_string_to_array ($mask, $mutli_byte_encoding);
	
	#print_r($strarr);
    foreach ($strarr as $id => $char)
    {
        //  $id - index => $char - string with 1 char (can be multibyte char)
		//	3 вложенных тернарных оператора "элегантно" решают вопрос:
		#$valid_str .= (mb_strpos($mask,$char,0,$mutli_byte_encoding)===false)     ?     ($invert===false?'':$char)     :     ($invert===false?$char:'');
		#$valid_str .= (strpos($mask,$char)===false)     ?     ($invert===false?'':$char)     :     ($invert===false?$char:'');
        //	Это символ входит в $mask?
        if (in_array($char, $maskarr) !== $invert)
        {
            //	Да, Символ $char нашёлся в строке $mask, добавим его в строку валидный символов
            $valid_str .= $char;
            #echo '+';
        }
        else
        {
            #echo '-';
        }
        #echo $char."[".bin2hex($char)."]";
    }

	/*
	$str_len = (($mutli_byte_encoding===false) ? strlen($str) : mb_strlen($str, $mutli_byte_encoding) );

	// Проходимся по строке, просматриваем побайтно или посимвольно
	for($i = 0; $i <  $str_len; $i++)
	{
		// Текущий символ строки
		$char = (($mutli_byte_encoding===false) ? $str[$i] : mb_substr($str,$i,1,$mutli_byte_encoding) );
		// $char = $str[$i];

		//	3 вложенных тернарных оператора "элегантно" решают вопрос:
		$valid_str .= (mb_strpos($mask,$char,0,$mutli_byte_encoding)===false)     ?     ($invert===false?'':$char)     :     ($invert===false?$char:'');
        // Логика 1 строки кода выше такая же, как у 18 строчек кода ниже:
        // if ($invert === false)
        // {
        //     //	Это символ входит в $mask?
        //     if (strpos($mask, $char) !== false)
        //     {
        //         //	Да, Символ $char нашёлся в строке $mask, добавим его в строку валидный символов
        //         $valid_str .= $char;
        //     }
        // }
        // else
        // {
        //     //	Это символ входит в $mask?
        //     if (strpos($mask, $char) === false)
        //     {
        //         //	Нет, Символ $char не нашёлся в строке $mask, добавим его в строку валидный символов
        //         $valid_str .= $char;
        //     }
        // }
	}
	*/
	//	Вернём валидированную строку
	return $valid_str;
}

function mask_filter_recursive ($arr, $mask='0123456789AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz', $invert_mask=false, $mutli_byte_encoding='pass')
{
	//	Рекурсивный вариант функции mask_filter для массивов
	//	Получает первым параметром массив, последующие параметры работают также как в функции mask_filter
	//	Функция вызывает себя для каждого элемента массива
	//	Мы получили массив?
	if (is_array($arr))
	{
		//	Ура! Настоящий Массив нам доверили! Немедленно пройдёмся по нему!
		foreach ($arr as $k => $v)
		{
			//	$k - ключ => $v - значение
			$arr[$k] = mask_filter_recursive ($v, $mask, $invert_mask, $mutli_byte_encoding);
		}
		//	Вернём обработанный массив
		return $arr;
	}
	else
	{
		//	Это не массив - вызовем обычный скучный нерекурсивный,  вариант этой функции
		return mask_filter ($arr, $mask, $invert_mask, $mutli_byte_encoding);
	}
}

function array_remove_empty_recursive($haystack)
{
	//	Рекурсивная функция удаления пустых элементов массива
	//	Взята тут: http://stackoverflow.com/questions/7696548/php-how-to-remove-empty-entries-of-an-array-recursively
	foreach ($haystack as $key => $value)
	{
		if (is_array($value))
		{
			$haystack[$key] = array_remove_empty_recursive($haystack[$key]);
		}

		if (empty($haystack[$key]))
		{
			unset($haystack[$key]);
		}
	}

	return $haystack;
}

function array_multidimensional_to_onedimensional ($arr, $keys=array())
{
	/**
	* фукнция преобразуем многомерный массив в одномерный
	Где по ключу - сериализованный в JSON-формат массив ключей многомерного массива
	Первый аргумент - массив (или другой тип)
	Второй аргумент массив ключей (используется для рекурсивного вызова)
	* @date 2017-04-28 14:35
	* @Author Alex Borodin-Atamanov <php@borodin-atamanov.ru>
	* @Version 1.0.0
	*/
	//	Получили массив в аргументах?
	if (is_array($arr))
	{
		//	Пройдёмся по массиву, запустим себя для каждого элемента
		$return = array();	//	Массив для складывания результата
		foreach ($arr as $key => $value)
		{
			$keys_4_cur_val = $keys;	//	Массив ключей для этого значения
			$keys_4_cur_val[] = $key;	//Добавляем текущий ключ массива в массив уже полученных ключей
			//	Вызываем себя рекурсивно
			$return = array_merge($return, array_multidimensional_to_onedimensional ($value, $keys_4_cur_val));
		}
	}
	else
	{
		//	Не массив
		//	Сериализуем накопленный ключи в строку
		//	Вернём массив ключей в виде строки и значение
		$return = array();
		//	$return[implode('|', $keys)] = $arr;	//	Будут глюки при любом символе-разделителе
		// $return[serialize($keys)] = $arr;	//	Длинно и не человекопонятно
		// $return[http_build_query($keys)] = $arr;	//	Длинно и не человекопонятно
		$return[json_encode($keys)] = $arr;	//	json - идеальный формат для этой цели - короткий и очень человекопонятный
	}
	return $return;
}


function array_onedimensional_to_multidimensional($arr)
{
	/**
	* фукнция преобразует одномерный массив в многомерный
	Где по ключу - сериализованный в JSON-формат массив ключей многомерного массива
	Первый аргумент - массив, который закодирован функцией array_multidimensional_to_onedimensional
	* @date 2017-04-28 14:35
	* @Author Alex Borodin-Atamanov <php@borodin-atamanov.ru>
	* @Version 1.0.0
	*/
	$return = array();	//	Массив для складывания результата

	//	Пройдёмся по массиву, запустим себя для каждого элемента
	foreach ($arr as $keys => $value)
	{
		//	$keys - json-закодированный массив ключей => $value - значение,  обычно строка или скаляр
		//	Ключей может быть любое количество
		//	Цикл по параметрам, пока они не кончатся
		$keys_arr = json_decode($keys);	//	Декодируем ключи
		//	TODO: добавить проверку если декодирование не увенчалось успехом

		$work_arr = $value;	//	Массив, который мы создаём, чтобы получить массив с единственным значением
		$index = 0;	//	Текущий индекс параметров
		//	Действуем пока не закончатся ключи в массиве ключей
		while ($index < count($keys_arr))
		{
			// Новый рабочий массив - это надмассив старого (взята ветка массива по ключу $params[0], $params[1], etc)
			//	То есть каждый раз мы "добавляем" к массиву ещё ключик и так итеративно пока не пройдём по всем ключам
			$work_arr = array($keys_arr[$index] =>$work_arr);
			$index++;
		}
		//	return $work_arr;
		//	Добавим $work_arr в общим массив
		$return = array_merge_recursive($return, $work_arr);
	}
	return $return;
}


function strict_valid_russian_phone_number ($num)
{
	//	@Date: 2016-11-05 21:43:26
	//	Функция тщательной валидации российского номера телефона
	//	Возвращает 11 значный номер телефона, начинающийся на 7
	//	Если получен 10 значный номер - добавляет 7 в начало
	//	Если получен 11 значный номер с 8 в начале, то меняет первую 8 на 7
	//	Если ничего не получилось - возвращает false
	$num = mask_filter($num, '0123456789');

	if (strlen($num) == 10)
	{
		$num = '7'.$num;
	}
	if (strlen($num) == 11)
	{
		if ($num[0] == '8')
		{
			$num[0] = '7';
		}
	}

	//	Проверим, что номер имеет 11 цифр и начинается на 7 в результате
	if ((strlen($num) == 11) && ($num[0] == '7'))
	{
		return $num;
	}
	//	Номер не является валидным российским, исправить не удалось
	return false;
}

function get_date_and_microtime()
{
	//	Фукнция возвращает дату-время и микросекунды
	/*
	* @date 2017-04-23 20:55:05
	* @Author Alex Borodin-Atamanov <php@borodin-atamanov.ru>
	* @Version 1.0.0
	*/
	//	Если микросекунды равны микросекундам при пришлом запуске - то прибавит к ним одну микросекунду (чтобы микросекунды всегда отличались хотя бы чуть-чуть)
	static $usec = 0;    //  микросекунды
	static $old_time= 0;    //  секунды UTS
	//	Создадим объект даты-времени
	// static $now = 0;    //  Объект
	//$now = DateTime::createFromFormat('U.u', microtime(true));
	// $utime = $now->format("u");	//	Получим микросекунды	- если получать микросекунды через DateTime объект - то при миллионах запусков вылетает с ошибкой почему-то

	//  Получаем микросекунды и секунды и  для того, чтобы сохранить их в строку
	list($utime, $time) = explode(" ", microtime());
	$utime = explode(".", $utime);
	$utime = $utime[1];

	//	Секунды изменились - обнулим микросекунды
	if ($old_time < $time)
	{
		//	Секунды изменились - обнулим микросекунды
		$usec = 0;
	}
	$old_time = $time;	//	Запомним секунды

	//	Если микросекунды меньше или равны микросекундам при пришлом запуске - прибавим к ним единичку, иначе оставим как есть
	if ($utime <= $usec)
	{
		$usec++;
	}
	else
	{
		$usec = $utime;
	}

	//	Вернём дату в формате: 2017-04-23 17:23:05.96648400
	$str = date("Y-m-d H:i:s", $time);
	$str .= '.'.sprintf("%'.08d", $usec);	//	Добавляем ведущие нули к микросекундам
	$str .= mt_rand(10, 99);	//	Последние 2 цифры - случайные
	return $str;
}

function add_ampersand_or_question_to_str_result ($str_result)
{
	//	Функция добавляет амперсанд или вопрос в конец запроса в str_result, если есть такая необходимость

	//	Если в строке запроса не содержится вопроса, то добавим его в конец
	$q_pos = strpos($str_result, '?');
	if ($q_pos === false)
	{
		//	Добавим вопрос в конец строки запроса
		$str_result .= '?';
	}
	else
	{
		//	Если последний символ не амперсанд и не ? - добавим амперсанд в конце
		if ((substr($str_result, -1, 1) != '&') && (substr($str_result, -1, 1) != '?'))
		{
			$str_result .= '&';
		}
	}
	return $str_result;
}

function translit ($string)
{
	//	Функция транслитерирует строку, понимает только кириллицу
	//	Может быть надо использовать iconv вместо этой функции?

	$table = array(
	//	Заглавные
	'А' => 'A', 'Б' => 'B', 'В' => 'V', 'Г' => 'G', 'Д' => 'D', 'Е' => 'E', 'Ё' => 'YO', 'Ж' => 'ZH', 'З' => 'Z', 'И' => 'I', 'Й' => 'J', 'К' => 'K', 'Л' => 'L', 'М' => 'M', 'Н' => 'N',  'О' => 'O', 'П' => 'P', 'Р' => 'R', 'С' => 'S', 'Т' => 'T', 'У' => 'U', 'Ф' => 'F', 'Х' => 'H', 'Ц' => 'C', 'Ч' => 'CH', 'Ш' => 'SH', 'Щ' => 'CSH', 'Ь' => '', 'Ы' => 'Y', 'Ъ' => '', 'Э' => 'E', 'Ю' => 'YU', 'Я' => 'YA', 'КС' => 'X',

	//	строчные
	'а' => 'a', 'б' => 'b', 'в' => 'v', 'г' => 'g', 'д' => 'd', 'е' => 'e', 'ё' => 'yo', 'ж' => 'zh', 'з' => 'z', 'и' => 'i', 'й' => 'j', 'к' => 'k', 'л' => 'l', 'м' => 'm', 'н' => 'n', 'о' => 'o', 'п' => 'p', 'р' => 'r', 'с' => 's', 'т' => 't', 'у' => 'u', 'ф' => 'f', 'х' => 'h', 'ц' => 'c', 'ч' => 'ch', 'ш' => 'sh', 'щ' => 'csh', 'ь' => '', 'ы' => 'y', 'ъ' => '', 'э' => 'e', 'ю' => 'yu', 'я' => 'ya', 'кс' => 'x',
	);

	$output = str_replace(
		array_keys($table),
		array_values($table),
		$string
	);

	return $output;
}
