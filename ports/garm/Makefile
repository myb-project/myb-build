PORTNAME=	garm
PORTVERSION=	0.1
CATEGORIES=	sysutils

MAINTAINER=	olevole@olevole.ru
COMMENT=	Simplified API for creating and destroying CBSD virtual environments

LICENSE=	APACHE20

USES=		cpe go:modules
USE_GITHUB=	yes
GH_ACCOUNT=	cloudbase
GH_TAGNAME=	0a17578
GH_TUPLE=	\
		BurntSushi:toml:v0.3.1:burntsushi_toml/vendor/github.com/BurntSushi/toml \
		chzyer:readline:2972be24d48e:chzyer_readline/vendor/github.com/chzyer/readline \
		felixge:httpsnoop:v1.0.1:felixge_httpsnoop/vendor/github.com/felixge/httpsnoop \
		flosch:pongo2:0d938eb266f3:flosch_pongo2/vendor/github.com/flosch/pongo2 \
		go-errgo:errgo:v1.0.1:go_errgo_errgo/vendor/gopkg.in/errgo.v1 \
		go-gorm:gorm:v1.23.4:go_gorm_gorm/vendor/gorm.io/gorm \
		go-gorm:mysql:v1.3.3:go_gorm_mysql/vendor/gorm.io/driver/mysql \
		go-gorm:sqlite:v1.3.2:go_gorm_sqlite/vendor/gorm.io/driver/sqlite \
		go-httprequest:httprequest:v1.2.1:go_httprequest_httprequest/vendor/gopkg.in/httprequest.v1 \
		go-macaroon-bakery:macaroon-bakery:v2.3.0:go_macaroon_bakery_macaroon_bakery/vendor/gopkg.in/macaroon-bakery.v2 \
		go-macaroon-bakery:macaroonpb:v1.0.0:go_macaroon_bakery_macaroonpb/vendor/github.com/go-macaroon-bakery/macaroonpb \
		go-macaroon:macaroon:v2.1.0:go_macaroon_macaroon/vendor/gopkg.in/macaroon.v2 \
		go-resty:resty:v2.7.0:go_resty_resty_v2/vendor/github.com/go-resty/resty/v2 \
		go-sql-driver:mysql:v1.6.0:go_sql_driver_mysql/vendor/github.com/go-sql-driver/mysql \
		go-yaml:yaml:496545a6307b:go_yaml_yaml/vendor/gopkg.in/yaml.v3 \
		golang-jwt:jwt:v3.2.2:golang_jwt_jwt/vendor/github.com/golang-jwt/jwt \
		golang:appengine:v1.6.7:golang_appengine/vendor/google.golang.org/appengine \
		golang:crypto:2c7772ba3064:golang_crypto/vendor/golang.org/x/crypto \
		golang:net:de3da57026de:golang_net/vendor/golang.org/x/net \
		golang:oauth2:2e8d93401602:golang_oauth2/vendor/golang.org/x/oauth2 \
		golang:protobuf:v1.5.2:golang_protobuf/vendor/github.com/golang/protobuf \
		golang:sys:e17cdc41300f:golang_sys/vendor/golang.org/x/sys \
		golang:term:03fcf44c2211:golang_term/vendor/golang.org/x/term \
		google:go-github:v43.0.0:google_go_github_v43/vendor/github.com/google/go-github/v43 \
		google:go-querystring:v1.1.0:google_go_querystring/vendor/github.com/google/go-querystring \
		google:uuid:v1.3.0:google_uuid/vendor/github.com/google/uuid \
		gorilla:handlers:v1.5.1:gorilla_handlers/vendor/github.com/gorilla/handlers \
		gorilla:mux:v1.8.0:gorilla_mux/vendor/github.com/gorilla/mux \
		gorilla:websocket:v1.5.0:gorilla_websocket/vendor/github.com/gorilla/websocket \
		inconshreveable:mousetrap:v1.0.0:inconshreveable_mousetrap/vendor/github.com/inconshreveable/mousetrap \
		jedib0t:go-pretty:v6.3.1:jedib0t_go_pretty_v6/vendor/github.com/jedib0t/go-pretty/v6 \
		jinzhu:inflection:v1.0.0:jinzhu_inflection/vendor/github.com/jinzhu/inflection \
		jinzhu:now:v1.1.5:jinzhu_now/vendor/github.com/jinzhu/now \
		juju:webbrowser:v1.0.0:juju_webbrowser/vendor/github.com/juju/webbrowser \
		julienschmidt:httprouter:v1.3.0:julienschmidt_httprouter/vendor/github.com/julienschmidt/httprouter \
		kballard:go-shellquote:95032a82bc51:kballard_go_shellquote/vendor/github.com/kballard/go-shellquote \
		kr:fs:v0.1.0:kr_fs/vendor/github.com/kr/fs \
		lxc:lxd:1170f2806124:lxc_lxd/vendor/github.com/lxc/lxd \
		manifoldco:promptui:v0.9.0:manifoldco_promptui/vendor/github.com/manifoldco/promptui \
		mattn:go-runewidth:v0.0.13:mattn_go_runewidth/vendor/github.com/mattn/go-runewidth \
		mattn:go-sqlite3:v1.14.12:mattn_go_sqlite3/vendor/github.com/mattn/go-sqlite3 \
		natefinch:lumberjack:v2.0.0:natefinch_lumberjack/vendor/gopkg.in/natefinch/lumberjack.v2 \
		nbutton23:zxcvbn-go:fa2cb2858354:nbutton23_zxcvbn_go/vendor/github.com/nbutton23/zxcvbn-go \
		pborman:uuid:v1.2.1:pborman_uuid/vendor/github.com/pborman/uuid \
		pkg:errors:v0.9.1:pkg_errors/vendor/github.com/pkg/errors \
		pkg:sftp:v1.13.4:pkg_sftp/vendor/github.com/pkg/sftp \
		protocolbuffers:protobuf-go:v1.28.0:protocolbuffers_protobuf_go/vendor/google.golang.org/protobuf \
		rivo:uniseg:v0.2.0:rivo_uniseg/vendor/github.com/rivo/uniseg \
		robfig:cron:v3.0.1:robfig_cron_v3/vendor/github.com/robfig/cron/v3 \
		rogpeppe:fastuuid:v1.2.0:rogpeppe_fastuuid/vendor/github.com/rogpeppe/fastuuid \
		satori:go.uuid:b2ce2384e17b:satori_go_uuid/vendor/github.com/satori/go.uuid \
		sirupsen:logrus:v1.8.1:sirupsen_logrus/vendor/github.com/sirupsen/logrus \
		spf13:cobra:9e88759b19cd:spf13_cobra/vendor/github.com/spf13/cobra \
		spf13:pflag:v1.0.5:spf13_pflag/vendor/github.com/spf13/pflag
USE_RC_SUBR=	garm

#USERS=		cbsd
#GROUPS=		cbsd

GO_TARGET=	${GO_PKGNAME}/cmd/${PORTNAME} \
		${GO_PKGNAME}/cmd/${PORTNAME}-cli

PLIST_FILES=	bin/garm \
		bin/garm-cli \
		"@sample etc/garm/config.toml.sample"

#post-extract:
#	${LN} -sf ${WRKSRC}/src ${WRKDIR}
#	${LN} -sf ${WRKSRC} ${WRKDIR}/src/${PORTNAME}

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/etc/garm
	${INSTALL_PROGRAM} -s ${WRKDIR}/bin/garm ${STAGEDIR}${PREFIX}/bin
	${INSTALL_PROGRAM} -s ${WRKDIR}/bin/garm-cli ${STAGEDIR}${PREFIX}/bin
	${SED} -e "s@/etc/garm@${PREFIX}/etc/garm@" ${WRKDIR}/${PORTNAME}-${GH_TAGNAME}/testdata/config.toml > ${STAGEDIR}${PREFIX}/etc/garm/config.toml.sample
#	${INSTALL_DATA} ${WRKDIR}/${PORTNAME}-${GH_TAGNAME}/testdata/config.toml ${STAGEDIR}${PREFIX}/etc/garm/config.toml.sample

.include <bsd.port.mk>
