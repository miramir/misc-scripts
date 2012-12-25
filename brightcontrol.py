#! /usr/bin/env python3

# Скрипт управления яркостью экрана ноутбука для intel видеокарт
# Использование: brightcontrol.py [up|down|level]
# 	где level - это число от 0 до 100
#
# Если параметров не задано, то скрипт печатает текущую яркость в процентах

import syslog
import sys

max_brightness = int(open('/sys/class/backlight/intel_backlight/max_brightness').read())
actual_brightness = int(open('/sys/class/backlight/intel_backlight/actual_brightness').read())
log = syslog.openlog("brightcontrol.py")


def setBrightnes(bright):
	brightness = open('/sys/class/backlight/intel_backlight/brightness', 'w')
	brightness.write(str(int(max_brightness / 100 * bright)))
	brightness.close()


if len(sys.argv) == 1:
	print(int(actual_brightness / max_brightness * 100))
elif sys.argv[1] == 'up':
	current_level = int(actual_brightness / max_brightness * 10 + 0.5) * 10
	next_level = current_level + 10 if current_level < 100 else 100
	setBrightnes(next_level)
	log.syslog(syslog.LOG_INFO, "Увеличиваем яркость до " + str(next_level) + "%")
elif sys.argv[1] == 'down':
	current_level = int(actual_brightness / max_brightness * 10 + 0.5) * 10
	next_level = current_level - 10 if current_level > 0 else 0
	setBrightnes(next_level)
	log.syslog(syslog.LOG_INFO, "Уменьшаем яркость до " + str(next_level) + "%")
elif 0 <= int(sys.argv[1]) <= 100:
	setBrightnes(int(sys.argv[1]))
	log.syslog(syslog.LOG_INFO, "Устанавливаем яркость в " + str(int(sys.argv[1])) + '%')
