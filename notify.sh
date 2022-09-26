#!/bin/bash

set -u

config_path=/etc/hpb

dict_file=${config_path}/directory.txt
webhook_url="$(cat ${config_path}/webhook_url.txt)"

botname="たんおめbot"

is_today() {
    test "$(date --date=${1} +%m/%d)" = "$(date +%m/%d)"
}

is_prev_sat() {
    test "$(date --date=${1} +%m/%d)" = "$(date --date="last week" +%m/%d)"
}

# send_to_discord ${webhook_url} ${botname} ${content}
send_to_discord() {
    url=$1
    bot=$2
    shift 2
    # json encoded
    text="{\"username\": "\"${bot}\"", \"content\": "\"$@"\"}"
    curl \
        -H "Content-Type: application/json" \
        -X POST \
        -d "${text}" \
        ${url}
}

while read line;
do
    IFS=" " read -ra data <<< ${line}
    name=${data[0]}
    date=${data[1]}

    is_prev_sat ${date}
    if [ $? -eq 0 ]; then
        send_to_discord ${webhook_url} ${botname} "${name} の誕生日まで1週間です。"
    fi

    is_today ${date}
    if [ $? -eq 0 ]; then
        send_to_discord ${webhook_url} ${botname} "${name} の誕生日です。おめでとう！"
    fi

done <${dict_file}
