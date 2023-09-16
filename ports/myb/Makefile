#
PORTNAME=	myb
PORTVERSION=	14.0.0.1619
CATEGORIES=	sysutils
DISTFILES=

MAINTAINER=	olevole@olevole.ru
COMMENT=	MyBee Meta port

LICENSE=	BSD2CLAUSE

NO_BUILD=	yes
MYB_HOME?=	${PREFIX}/myb

.include <bsd.port.pre.mk>

do-install:
	@${ECHO} "Installing in ${MYB_HOME}"
	${MKDIR} ${STAGEDIR}${MYB_HOME}
	${CP} -a /root/myb-build/myb/ ${STAGEDIR}${MYB_HOME}/

post-install:
	${CAT} ${PKGDIR}/pkg-plist-chunk > ${TMPPLIST} ;
	@${FIND} -s ${STAGEDIR}${MYB_HOME} -not -type d | ${SORT} | \
	${SED} -e 's#^${STAGEDIR}${PREFIX}/##' >> ${TMPPLIST}

.include <bsd.port.post.mk>
