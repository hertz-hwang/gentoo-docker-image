FROM gentoo/portage:latest as portage
FROM gentoo/stage3:latest as production

COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo
COPY gentoo.conf /etc/portage/repos.conf/
COPY gentoo-zh.conf /etc/portage/repos.conf/
COPY 26hz-overlay.conf /etc/portage/repos.conf/

LABEL maintainer="Hertz Hwang <hertz@26hz.com.cn>"

WORKDIR /
ENV PATH="/root/.local/bin:${PATH}"
RUN set -eux;	\
	\
	eselect news read --quiet new >/dev/null 2&>1;	\
	echo 'FEATURES="-ipc-sandbox -network-sandbox -pid-sandbox -userpriv -usersandbox -sandbox"' >> /etc/portage/make.conf;	\
	echo 'EMERGE_DEFAULT_OPTS="--verbose --quiet --keep-going --with-bdeps y --autounmask y --autounmask-continue y"' >> /etc/portage/make.conf;	\
	emerge --jobs $(nproc)	\
        	app-eselect/eselect-repository	\
        	app-portage/eix	\
        	app-portage/flaggie	\
        	app-portage/genlop	\
        	app-portage/gentoolkit	\
        	app-portage/iwdevtools	\
        	app-portage/mgorny-dev-scripts	\
        	app-portage/portage-utils	\
        	app-misc/jq	\
        	app-misc/neofetch	\
        	dev-python/pip	\
        	dev-util/pkgdev	\
        	dev-util/pkgcheck	\
		app-editors/vim \
        	dev-vcs/git;	\
	rm -rf /var/db/repos/*;	\
	eix-sync -a

CMD ["/bin/bash"]
