#!/usr/bin/php
<?php
require_once('functions.php');

#echo date(time());

#File names 
$rename_forward_fname = 'rename_forward.bash';
$rename_back_fname = 'back_rename.bash';
$all_files_fname = 'all_files.names';

$rename_forw = "echo Renaming... \n";
$rename_back = "echo Renaming back... \n";
$all_files_names = "echo All files: \n";

#http://php.net/manual/en/class.recursivedirectoryiterator.php
$di = new RecursiveDirectoryIterator('.');
foreach (new RecursiveIteratorIterator($di) as $filename => $file) 
{
    #echo $filename . ' - ' . $file->getSize() . "\n";
    $old_name = $file->getFilename();
    #$old_name = $file->getPathname();
    $old_path = $file->getPath();
    #echo $file->getPathname()."\n".$file->getPath()."\n". $file->getFilename()  . ' - ' . $file->getSize() . "\n";
    #echo "$old_name\n";
    #echo get_random_password_from_2_strings(15);
    $new_name = $old_name;
    #$new_name = str_replace ( chr(0xef).chr(0xbf).chr(0xbd), 'х', $new_name);
   
    $new_name = str_replace ( hex2bin('d1d0be'), 'хо', $new_name);
    $new_name = str_replace ( hex2bin('d1d0b0'), 'ха', $new_name);
    $new_name = str_replace ( hex2bin('d1d0b5'), 'хе', $new_name);
    $new_name = str_replace ( hex2bin('d1d0b2'), 'хв', $new_name);
    $new_name = str_replace ( hex2bin('d1d180'), 'хр', $new_name);
    $new_name = str_replace ( hex2bin('d1d0bd'), 'хн', $new_name);
    $new_name = str_replace ( hex2bin('d1d183'), 'ху', $new_name);
    $new_name = str_replace ( hex2bin('d1d181'), 'хс', $new_name);
    $new_name = str_replace ( hex2bin('d1d0b2'), 'хв', $new_name);
    $new_name = str_replace ( hex2bin('d1d0bc'), 'хм', $new_name);
    $new_name = str_replace ( hex2bin('d1d0b8'), 'хи', $new_name);
    $new_name = str_replace ( hex2bin('d1d0bb'), 'хл', $new_name);
    $new_name = str_replace ( hex2bin('d1d182'), 'хт', $new_name);
    $new_name = str_replace ( hex2bin('d1d181'), 'хс', $new_name);
    $new_name = str_replace ( hex2bin('d1d181'), 'хс', $new_name);
    $new_name = str_replace ( hex2bin('d1d181'), 'хс', $new_name);
    
    $new_name = str_replace ( hex2bin('d127'), 'х\'', $new_name);
    $new_name = str_replace ( hex2bin('d12d'), 'х-', $new_name);
    $new_name = str_replace ( hex2bin('d12e'), 'х.', $new_name);
    $new_name = str_replace ( hex2bin('d120'), 'х ', $new_name);
    $new_name = str_replace ( hex2bin('d15f'), 'х_', $new_name);
    #$new_name = str_replace ( hex2bin('d12e'), '.', $new_name);
    #$new_name = str_replace ( hex2bin('d18fd1'), 'ях', $new_name);
    
    $mask='0123456789AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZzЁёЙйЦцУуКкЕеНнГгШшЩщЗзХхЪъФфЫыВвАаПпРрОоЛлДдЖжЭэЯяЧчСсМмИиТтЬьБбЮю_-!+. ()%&,#№\'';
    #$new_name = mask_filter ($new_name, $mask, false, 'UTF8');
    #echo '['.bin2hex($old_name)."]\n";
    #echo '['.bin2hex($new_name)."]\n";
    $old_name = $old_path.'/'.$old_name;
    $new_name = $old_path.'/'.$new_name;
    
    if ($new_name !== $old_name)
    {
        $rename_forw .= "echo \"$old_name\" -\> \n";
        $rename_forw .= "echo \"$new_name\" \n";
        
        $old_filename_arr = mutli_byte_string_to_array ($old_name);
        $char_codes = '';
        foreach ($old_filename_arr as $id => $char)
        {
            //  $id - index => $char - string with 1 char (can be multibyte char)
            #echo $char."[".bin2hex($char)."]";
            $char_codes .= $char."[".bin2hex($char)."]";
            #$rename_forw .= 
        }
        $rename_forw .= "echo \"".$char_codes."\"\n";
        echo "\n[$old_name] -> \n[$new_name]\n";
        echo $char_codes."\n\n";
        
        $rename_forw .= 'mv $\''.escape_str_to_bash($old_name).'\'  $\''.escape_str_to_bash($new_name).'\''."\n";
        
        $rename_back .= "echo \"$new_name\" -\> \n";
        $rename_back .= "echo \"$old_name\" \n";
        $rename_back .= 'mv $\''.escape_str_to_bash($new_name).'\'  $\''.escape_str_to_bash($old_name).'\''."\n";
    }
    else
    {
        //  Сохраним имена файлов 
        $char_codes = '';
        $old_filename_arr = mutli_byte_string_to_array ($old_name);
        foreach ($old_filename_arr as $id => $char)
        {
            //  $id - index => $char - string with 1 char (can be multibyte char)
            #echo $char."[".bin2hex($char)."]";
            $char_codes .= $char."[".bin2hex($char)."]";
        }
        $all_files_names .= $old_name.' = '.$char_codes."\n";
        echo "\n$old_name";
    }
}

#Запишем файлы с bash-командами на переименование файлов
file_put_contents($rename_forward_fname, $rename_forw);
file_put_contents($rename_back_fname, $rename_back);
chmod($rename_forward_fname, 0755);
chmod($rename_back_fname, 0755);

#Имена всех файлов сохраним
file_put_contents($all_files_fname, $all_files_names);

