#!/bin/bash

LOG_FILE="/var/log/monitoring.log"
PROCESS_NAME="test"
MONITORING_URL="https://test.com/monitoring/test/api"
PID_FILE="/var/run/monitor_test.pid"

echo "$(date) - Script started" >> "$LOG_FILE"

# Проверка на повторный запуск
if [[ -f "$PID_FILE" ]] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
    echo "$(date) - Script is already running, exiting." >> "$LOG_FILE"
    exit 1
fi

# Сохранение PID текущего процесса
echo $$ > "$PID_FILE"

if pgrep -x "$PROCESS_NAME" > /dev/null; then
    echo "$(date) - Process $PROCESS_NAME is running" >> "$LOG_FILE"

    if ! curl -s --connect-timeout 5 "$MONITORING_URL" > /dev/null; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Monitoring server is unreachable." >> "$LOG_FILE"
    fi
else
    echo "$(date) - Process $PROCESS_NAME not running" >> "$LOG_FILE"

    if [[ -f /tmp/test_was_running ]]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $PROCESS_NAME process was restarted." >> "$LOG_FILE"
        rm /tmp/test_was_running
    fi

    echo "$(date) - Script finished" >> "$LOG_FILE"
    rm -f "$PID_FILE"
    exit 0
fi

touch /tmp/test_was_running

echo "$(date) - Script finished" >> "$LOG_FILE"

# Удаление PID-файла при завершении
rm -f "$PID_FILE"
