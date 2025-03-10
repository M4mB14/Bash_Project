Это репозиторий для тестового задания по bash 

Все фалы должны быть расположены в данных директориях 
  1. monitor.service - /etc/systemd/system/
  2. monitor.timer - /etc/systemd/system/
  3. monitor_test.sh - /usr/local/bin/
Файлы monitor_test.pid и monitoring.log создаються автоматически в директориях:
  1. /var/run/monitor_test.pid
  2. /var/log/monitoring.log

После запуска основного файла (monitor_test.sh) нужно поднять юниты .timer и .service через команду enable/staart

