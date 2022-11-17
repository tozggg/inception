# inception
[subject](https://github.com/tozggg/inception/blob/master/subject.pdf)  
docker-compose를 이용해 wordpress 웹사이트 구성하기  
<br>
<img width="65%" src="https://github.com/tozggg/inception/blob/master/diagram.png?raw=true"/>
<br>
<br>
## Details
### 개념

? 데비안 버스터와 알파인 리눅스의 차이, 데비안 버스터를 사용한 이유

- ㄴ apt 를 이용해서 패키지 관리가 편리하다

? VM과 Container의 차이

- 둘다 가상화(=컴퓨터 자원의 추상화, 독립적인 공간)를 위해
- VM은 hostOS에서 사용되는 것을 가상화 할때 성능저하, 자체 guestOS에 커널포함(용량방대)
- Container는 리눅스상에서 프로세스 단위의 독립적인 공간 만들기

? Docker Image → 환경(컨테이너 실행에 필요한 설정값이 포함)

- VM의 iso와 비슷, 여러 층으로 이루어져서 재사용이 가능한 구조, Read Only

? Docker Container

- Docker Image를 이용해서 생성된 독립된 공간
- Image의 목적만을 위한, 자원 제한 주의 → Storage Driver

? Docker Volume

- 컨테이너들이 공유하는 리소스
- Host Volume, Volume Container, Docker Volume

? Docker Network

- 외부 네트워크에서 컨테이너를 접근(컨테이너 마다 IP주소)
- bridge → docker0, veth을 통해 컨테이너간 통신(default)
- host → host 컴퓨터와 동일한 네트워크 환경 사용
- none → 외부 통신 불가

? Dockerfile

- Docker Image를 생성하는 스크립트 파일

? Docker-compose

- 여러개의 컨테이너를 순서에 따라 자동으로 빌드하고 관리
- .yml 파일로 기재

? VirtualBox에서 Docker를 사용할때 주의해야 할 점

- 2중 포트 포워딩 주의 → !머신 ~ VM , VM ~ Container

? dockerd

- 사용자로부터 입력을 받아 Doker Engine의 기능을 수행하는 데몬프로세스
- unix socket을 이용해서 소통(sock 파일)

---

### Command

#### Makefile

- all → 디렉토리생성, hosts파일에 도메인추가, up
    - -d → 컨테이너 백그라운드로 실행
    - —bulid → 이미지 빌드까지
- clean → (stop)down
- fclean → down, system prune, 볼륨 삭제, 디렉토리 삭제

#### docker compose

- `docker-compose.yml`
    - version: → yml 파일 버전 (3이 호환성좋음 ?)
    - services: → 생성할 컨테이너의 옵션
        - 서비스명:
            - image: → 이미지명
            - container_name: → 컨테이너명
            - build: → 도커파일이 정의된 디렉토리
            - volumes: → 로컬볼륨과 컨테이너 내부 저장소 연결
            - networks: → 사용할 네트워크
            - env_file: → 환경변수파일
            - restart: → 재실행 (always: 종료시 항상  , on-failure: 오류 있을시)
            - ports: → HostOS와 연결되는 포트 ( !nginx )
            - expose: → 컨테이너 간 연결을위한 포트 (host와는 연결x)
            - depends_on: → 의존성추가(실행순서 제어 !mariadb→wordpress→nginx)
    - networks:
        - 네트워크명:
            - driver: bridge
    - volumes:
        - 볼륨명:
            - driver: local
            - driver_opts: → 드라이버 옵션
                - o: bind → 바인드 마운트 사용
                - type: none
                - device: → 마운트될 로컬 저장소

- `.env`

#### mariadb

- `Dockerfile`
    
    ```docker
    FROM → 기반 이미지
    RUN → 이미지 위에서 명령어 실행(빌드할때)
    COPY → 호스트 파일을 컨테이너로 복사
    CMD, ENTRYPOINT → 컨테이너 실행시 명령어 실행(생성되고 실행할때)
        - CMD → 변경가능, ENTRYPOINT → 최초에 꼭 실행
    ```
    
    - FROM debian:buster
    - RUN apt-get -y update, upgrade
    - RUN apt-get -y install mariadb-server
    - COPY sh파일, cnf파일
    - RUN chomd sh파일 권한설정
    - ENTRYPOINT sh파일
- `entrypoint.sh`
    - if [] then → 이미 데이터베이스 존재할시 sql구문 x
        - service mysql start
        - CREATE DATABASE
            - IF NOT EXISTS 존재하지 않는다면
        - CREATE USER
            - @’%’ → 외부접근
            - IDENTIFIED BY → 비밀번호 설정
        - GRANT ALL PRIVILEGES ON 유저
        - ALTER USER root@localhost IDENTIFIED BY
        - FLUSH PRIVILEGES → 변경사항 즉시반영
        - service mysql stop
    - sleep 줘야되나?
    - mysqld → 포어그라운드에서 mysql 실행
- `50-server.cnf`
    - port = 3306
    - bind-adress = 0.0.0.0 → 외부접속허용

#### wordpress

- `Dockerfile`
    - FROM debian:buster
    - RUN apt-get -y update, upgrade
    - RUN apt-get -y install
        - mariadb-client
        - php7.3 → 동적 웹페이지 언어
        - php-fpm → php와 nginx의 연결(CGI의 업그레이드 버전, HTML로 반환?)
        - php-mysqli → php와 mysql의 연결 확장버전
        - curl wget → 웹 상 컨텐츠 다운로드(curl이 좀 더 업그레이드)
    - RUN wp-cli 다운, 권한변경, 이동 → 워드프레스를 명령창에서 관리하는 유틸리티
    - COPY conf파일 pool.d에 넣기
    - COPY sh
    - ENTRYPOINT sh
- `entrypoint.sh`
    - if-then [wp-config.php]
        - 워드프레스 테마 다운(/var/www/wordpress)
        - 디렉토리 소유권 wordpress에 넘겨주기( 권한도? )
        - wp-config.php생성
            - dbname dbuser dbpass dbhost path
        - wp core install (allow-root)
            - url title admin_user admin_password admin_email path
        - wp user create (allow-root)
            - name email pass role path
    - ./run/php 디렉토리 생성
    - php-fpm 포어그라운드로 실행
- `www.conf`
    - listen = wordpress:9000 ?

#### nginx

- `Dockerfile`
    - FROM debian:buster
    - RUN apt-get -y update, upgrade
    - RUN apt-get -y install
        - nginx → 웹서버 역할(중계기능)
        - openssl → 보안 라이브러리
    - RUN openssl req → openssl 키 발급
        - -newkey rsa:4096 -days 365 -x509
        - -nodes → 개인키 암호화 x
        - -subj → C ST O OU CN
        - -keyout → /etc/ssl/private 에 비밀키 발급
        - -out → /etc/ssl/certs 에 인증서(공개키) 발급
        - chmod 777 crt, key 권한변경
    - COPY nginx.conf파일 /etc/nginx/sites-avaliable 에 복사
    - ENTRYPOINT [nginx -g daemon off] → nginx 포그라운드 실행
- `default`
    - server{}
        - listen 443, [::]:443 ssl
        - server_name → 도메인명
        - ssl on
        - ssl_certificate → 인증서파일
        - ssl_certificate_key → 개인키파일
        - ssl_protocols → TLSv1.2 TLSv1.3
        - root → php파일 루트 디렉토리
        - index → 홈페이지(순서대로)
        - location ~ \.php$ {}
            - fastcgi_pass wordpress:9000; → php_fpm 포트경로
            - fastcgi_index index.php;
            - include fastcgi_params;
            - fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                
                → php_fpm으로 전달되는 파라미터(스크립트파일명)
                
            - 404 처리
            - timeout

