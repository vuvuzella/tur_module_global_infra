#!/bin/bash
cat > index.html  << EOF
<h1>${server_text}, v3</h1>
<h2>db address: ${db_address}</h2>
<h3>db port: ${db_port}<h2>
EOF
nohup busybox httpd -f -p ${server_port} &
