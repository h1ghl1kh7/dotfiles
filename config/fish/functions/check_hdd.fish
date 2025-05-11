function check_hdd
    echo "==== 디스크 용량 및 파일시스템 (df -h -T | grep dev/sd) ===="
    df -h -T | grep dev/sd
end
