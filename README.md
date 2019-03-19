# Docker para Implantação do Sitemas de Chamados [GLPI][1]

### Arquivo "docker-compose.yml" para *deploy* do Container

```
version: "2"
services:
 glpi:
   image: "i9corp/glpi:latest"
   ports:
     - "00000:22"
     - "00000:80"
     - "00000:443"
     - "00000:3306"
   volumes:
     - "vol:/etc/helpdesk"
   environment:
     - "GUEST_PASSWD=123456"
     - "GUEST_LOGIN=user"
     - "SRV_NAME=localhost.com"
volumes:
  vol:

```

No meu caso estou mapeando a porta 443 e definindo a variável "SRV_NAME", pois posteriormente irei incluir um certificado [SSl][2] em meu sistema.

#

### Criar Banco de Dados

Acesse o terminal do MySQL, senha de root do MySQL esta definida com valor vazio:

```
mysql -u root -p
```

Dentro do terminal do MySQL:

```
create database glpi;
create user 'glpi'@'localhost' identified by 'passwd';
grant all on glpi.* to glpi identified by 'passwd';
quit;
```

Com o banco devidamente criado, execute a configuração no ambiente web.

Concluida a instalação, altere a senha dos usuários padrão do sistema (glpi, post-only, tech e normal) no ambiente web e exclua o arquivo abaixo dentro de seu container Docker:

```
rm -fr /etc/helpdesk/glpi/install/install.php
```

Com isso seu sistema de chamados estará devidamente configurado.

#

#### Fontes:
```
https://www.youtube.com/watch?v=y1c_1MIMgy4
https://www.arthurschaefer.com.br/2016/11/instalar-glpi-9-1-1-no-debian-8/
https://www.youtube.com/watch?v=5cuowKZyWxM
https://www.vivaolinux.com.br/artigo/Instalacao-do-GLPI-no-Debian-8?pagina=1
```

#

[1]:http://www.glpibrasil.com.br/
[2]:https://letsencrypt.org/
