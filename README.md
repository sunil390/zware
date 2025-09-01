# zware

## PgVector Creation 

1. sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-$(rpm -E %{rhel})-x86_64/pgdg-redhat-repo-latest.noarch.rpm
2. sudo dnf -qy module disable postgresql
3. sudo dnf install pgvector_17
4. sudo /usr/pgsql-17/bin/postgresql-17-setup initdb
5. sudo systemctl start postgresql-17
6. sudo systemctl enable postgresql-17
7. sudo -i -u postgres
8. psql
9. CREATE ROLE rag_user WITH LOGIN PASSWORD 'Sunil390@rag';
10. CREATE DATABASE rag_knowledge_db OWNER rag_user;
11. \c rag_knowledge_db
12. CREATE EXTENSION IF NOT EXISTS vector;
13. \dx vector
14. \q
15. exit
16. sudo nano /var/lib/pgsql/17/data/pg_hba.conf
17. host rag_knowledge_db rag_user 0.0.0.0/0 scram-sha-256
18. sudo systemctl restart postgresql-17
19. host.containers.internal if running under systemd and n8n is under podman


## PGvector Refresh 
1. sudo -i -u postgres
2. psql
3. \c rag_knowledge_db
4. DROP TABLE n8n_vectors CASCADE;

## ollama granite3.3:8b 
1. curl -fsSL https://ollama.com/install.sh | sh
2. ollama run ibm/granite3.3:2b
3. ollama pull ibm/granite-embedding:278m
4. in n8n Change base url to http://host.docker.external:11434 if in same host or http://192.168.2.80:11434 if run outside.

## n8n self hosted AI on AMD with nvidia 3070
1. git clone https://github.com/n8n-io/self-hosted-ai-starter-kit.git
2. cd self-hosted-ai-starter-kit
3. cp .env.example .env # only postgress passwords changed.
4. docker compose --profile gpu-nvidia up

## n8n

1. podman volume create n8n_data
2. openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -out ./n8n/tls.crt -keyout ./n8n/tls.key -subj "/CN=n8n/O=n8n" -addext "subjectAltName = DNS:n8n,IP:192.168.2.226"
3. chmod 644 ./n8n/tls.crt
4. chmod 644 ./n8n/tls.key
5. kubectl get services -A
6. podman run -it --rm --name n8n -p 5678:5678 --add-host awx.znext.com:10.43.154.140 -e N8N_SECURE_COOKIE="false" -e TZ="Asia/Kolkata" -e N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true -e N8N_RUNNERS_ENABLED=true -e DB_SQLITE_POOL_SIZE=2 -e N8N_SSL_CERT=/certs/tls.crt -e N8N_SSL_KEY=/certs/tls.key -e N8N_PROTOCOL=https -v ./n8n:/certs:Z -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n
   
## misc Authenticator issue
1. sudo timedatectl set-ntp true

## nginx comnfig
1. sudo dnf install nginx

## AWX Minimum Config

1. add Organization
2. add admin user and tag to Oraganuzation
3. add a team in Organization
4. ssh to mainframe and generate the keypair without passphrase. AWX is one year old and is not accepting the passphrase protected RSA Key.
```
ssh-keygen -t rsa -b 3072 -N "" -m PEM
```
5. copy the id_rsa
6. create a new "Machine" credential in AWX enter mainframe user name and private key.
7. add github project with project url and sync it
8. add an inventory name
9. add a host and link to inventory name
10. add these variables in the host definition
```
---
ansible_host: 192.168.2.44
ansible_user: IBMUSER
PYZ: "/usr/lpp/IBM/cyp/v3r11/pyz"
PYZ_VERSION: "3.11"
ZOAU: "/usr/lpp/IBM/zoautil"
ZOAU_PYTHON_LIBRARY_PATH: "{{ ZOAU }}/lib/{{ PYZ_VERSION }}"
ansible_python_interpreter: "{{ PYZ }}/bin/python{{PYZ_VERSION}}" 
environment_vars:
  _BPXK_AUTOCVT: "ON"
  ZOAU_HOME: "{{ ZOAU }}"
  PYTHONPATH: "{{ ZOAU_PYTHON_LIBRARY_PATH}}"
  LIBPATH: "{{ ZOAU }}/lib:{{ PYZ }}/lib:/lib:/usr/lib:."
  PATH: "{{ ZOAU }}/bin:{{ PYZ }}/bin:/bin:/var/bin"
  _CEE_RUNOPTS: "FILETAG(AUTOCVT,AUTOTAG) POSIX(ON)"
  _TAG_REDIR_ERR: "txt"
  _TAG_REDIR_IN: "txt"
  _TAG_REDIR_OUT: "txt"
  LANG: "C"
  PYTHONSTDINENCODING: "cp1047"
```
11. add a job template with a playbook and select inventory and credentials.
12. Launch Template
