all: update-ca-certificates c_rehash certdata2pem certdata2pem_host

update-ca-certificates: update-ca.c
	${CC} ${CFLAGS} -o $@ update-ca.c ${LDFLAGS}

c_rehash: c_rehash.c
	${CC} ${CFLAGS} -o $@ c_rehash.c -lcrypto ${LDFLAGS}

certdata2pem: certdata2pem.c
	${CC} ${CFLAGS} -o $@ certdata2pem.c ${LDFLAGS}

certdata2pem_host: certdata2pem.c
	${HOST_CC} -o $@ certdata2pem.c

#certdata.stamp:
#	./certdata2pem
#	touch $@

install: all
	install -d -m755 ${DESTDIR}/etc/ca-certificates/update.d \
		${DESTDIR}/usr/bin \
		${DESTDIR}/usr/sbin \
		${DESTDIR}/usr/share/ca-certificates \
		${DESTDIR}/usr/local/share/ca-certificates \
		${DESTDIR}/etc/ssl/certs

	for cert in *.crt; do \
		install -D -m644 $$cert ${DESTDIR}/usr/share/ca-certificates/mozilla/$$cert; \
	done

	install -D -m644 update-ca-certificates.8 ${DESTDIR}/usr/share/man/man8/update-ca-certificates.8
	install -m755 update-ca-certificates ${DESTDIR}/usr/sbin
	install -m755 c_rehash ${DESTDIR}/usr/bin
	install -m755 certdata2pem ${DESTDIR}/usr/bin
	install -m755 certhash ${DESTDIR}/etc/ca-certificates/update.d

clean:
	rm -rf update-ca-certificates c_rehash certdata2pem certdata2pem_host certdata.stamp *.crt

.PHONY: install clean
