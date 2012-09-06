#! /bin/bash
# Программа для преобразования набора фоток в баннер.
# Запускать так convert_foto.sh "Имя папки" "Заголовок банера" "Имя выходного файла"
# Имя фала фотографии должно быть следующим "номер_первая строка_вторая строка.jpg"
# Номер нужен для сортировки, первая строка и вторая строка - это строки подписи

folder=$1
bannername=$2
outfile=$3

tmpdir="tmp-${folder}"
oldpwd=$(pwd)

#удаляем старые фаилы и папки и создаём новые
[[ -e "${tmpdir}" ]] && rm -rf "${tmpdir}"; mkdir "${tmpdir}"
[[ -e "${outfile}" ]] && rm "${outfile}"

cd "${folder}"

# удаляем мусор
[[ -e "desktop.ini" ]] && rm -rf "desktop.ini"

for f in *
do
	name=$(echo ${f}|cut -d. -f1|cut -d_ -f2)
	prof=$(echo ${f}|cut -d. -f1|cut -d_ -f3)
	convert -resize 1062x -gravity South \
			-font Myriad-Pro-Bold -pointsize 66 \
			-background White -splice 0x156 \
			-annotate +0+2 "${name}\n${prof}" \
			"${f}" "../${tmpdir}/${f}"
done

cd "${oldpwd}"

montage "${tmpdir}"/* -tile 20x5  -border 42 -bordercolor white -geometry +0+0 "${tmpdir}/${folder}.jpg"
convert "${tmpdir}/${folder}.jpg" -gravity North -font Myriad-Pro-Bold -pointsize 300 -background White -splice 0x381 -annotate +0+2 "${bannername}" "${tmpdir}/${folder}.jpg"
convert "${tmpdir}/${folder}.jpg" -compose copy -bordercolor "rgb(245,127,32)" -border 381 "${tmpdir}/${folder}.jpg"

convert "${tmpdir}/${folder}.jpg" "${outfile}"

#удаляем временные файлы
[[ -e "${tmpdir}" ]] && rm -rf "${tmpdir}"
