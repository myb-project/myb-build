[default]
callback_url = "%%CALLBACK_URL%%"
config_dir = "/usr/local/etc/garm"
log_file = "/var/log/runner-manager.log"

[jwt_auth]
secret = "%%JWT_SECRET%%"

time_to_live = "8760h"

[apiserver]
  bind = "0.0.0.0"
  port = 9997
  use_tls = false
  [apiserver.tls]
    certificate = ""
    key = ""
    ca_certificate = ""

[database]
  debug = false
  backend = "sqlite3"
  passphrase = "shreotsinWadquidAitNefayctowUrph"
  [database.mysql]
    username = ""
    password = ""
    hostname = ""
    database = ""
  [database.sqlite3]
    db_file = "/usr/local/etc/garm/garm.db"

[[provider]]
name = "mybee_external"
description = "External MyBee provider"
provider_type = "external"
  [provider.external]
  config_file = "/usr/local/cbsd/modules/garm.d/providers.d/mybee/keystonerc"
  provider_dir = "/usr/local/cbsd/modules/garm.d/providers.d/mybee"

[[github]]
  name = "mybee"
  description = "MyBee github token"
  oauth2_token = "%%PAT%%"
