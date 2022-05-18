
# Dynamic proxy with Consul and Nginx

#### On this README will be explained the usage of the stack :

 * Nginx 
 * Consul 
 * Consul-template.

#### The focus will be on the usage , the architure was explained on the following link 

[![meddiun](https://img.shields.io/badge/Tutorial-medium-red)](https://medium.com/@raphaelrpg1/consul-consul-template-and-dynamic-nginx-configuration-b6470a7a09c3)


## Usage 


#### On Consul 


    1 . Under the KV app/config/dirconfig/
    The URL should look similar to http://IP:8500/ui/dc1/kv/app/config/dirconfig/edit

    Insert the names of the "configurations" that should be render by Consul .

Example

    2 .  Create new Keys with same names as created on step one .

Example


    3 . Store a new value under the new keys created .


asasdsa

    4 . Most important reload the config by , simple adding a dummy value under the key app/config/dirconfig

#### Sample configuration  
 
```json
server {
    listen 80;
    listen [::]:80;
    server_name http://138.68.160.171 ;
    resolver 1.1.1.1 valid=10s;


  location /wix {
      proxy_set_header Host $host;
      proxy_set_header Accept-Encoding "";
      proxy_pass http://www.wix.com;
  }
}
```
or 
```json
server{
			listen 80;
  
			location / {
			 proxy_pass "http://143.198.240.53";
			}

			location /especial {
			 rewrite ^/codify(.*) $1 break;
			 proxy_pass "http://info.cern.ch/";
			}
}


```


```json
server{

    location /prodapiv2 {
        rewrite ^/codify(.*) $1 break;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-NginX-Proxy true;
        proxy_pass "http://stgretail360.verifone.co.il/R360.Server.IIS/services/Services.asmx";
        proxy_ssl_session_reuse off;
        proxy_cache_bypass $http_upgrade;
        proxy_redirect off;
    }
}

```



#### Debuging can be done by :

* Accessing the docker container and performing 

#### nginx -t 
It should check if the config inserted on nginx are correct 




## Expected behavior 


On the docker machine with the consul-template & nginx .
![App Screenshot](https://i.ibb.co/BqT4Tbx/Screen-Shot-2022-04-13-at-17-55-42.png)


