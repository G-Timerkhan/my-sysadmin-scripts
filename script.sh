#!/usr/bin/env bash
# script.sh  сборщик логов: фильтрует системный лог по ключевым словам и пишет отчёт
# Использование: ./script.sh [путь_к_логу]   (по умолчанию /var/log/syslog)
LOGFILE="${1:-/var/log/syslog}"
REPORT="report.txt"
KEYWORDS=("error" "fail" "denied" "warning")
if [ ! -f "$LOGFILE" ]; then
  echo "Ошибка: файл $LOGFILE не найден." >&2
  exit 1
fi
if [ ! -r "$LOGFILE" ]; then
  echo "Ошибка: нет прав на чтение $LOGFILE." >&2
  exit 2
fi

{
  echo "=== Отчёт по логу $LOGFILE ==="
  echo "Создан: $(date '+%Y-%m-%d %H:%M:%S')"
  echo
  for word in "${KEYWORDS[@]}"; do
    count=$(grep -ci "$word" "$LOGFILE")
    echo "Ключевое слово '$word': $count совпадений"
  done
  echo
  echo "=== Последние найденные события (до 20 строк) ==="
  grep -iE "$(IFS='|'; echo "${KEYWORDS[*]}")" "$LOGFILE" | tail -n 20
} > "$REPORT"

echo "Отчёт сохранён в $REPORT"
