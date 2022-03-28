#!/bin/bash -x



build_template () {
    n=1
    filename='./config.txt'
    while read line; 
    do
    echo "{{ key \"$line\" }}" > $line.tpl
    echo "./$line.tpl:/etc/nginx/sites-enabled/$line.conf" >> commands.txt
    echo "The config for $line was generated               Configs rendered until now $n "
    n=$((n+1))
    done < $filename
}



multi_render () {
    cat './commands.txt' |while read line
    do
    
    consul-template -consul-addr=$CONSUL_URL -template="$line" & pid=$! | sleep 3 && kill -9 $pid | service nginx restart
    
    done
}

my_main (){
    while true
    do
    rm -f *.tpl && rm -f commands.txt
    consul-template -consul-addr=$CONSUL_URL -template="./templates/config.tpl:./config.txt: exit "
    
    build_template
    multi_render
    done
}

my_main