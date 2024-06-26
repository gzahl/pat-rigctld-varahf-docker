define RUN_CMD
	docker run -d \
	--device /dev/serial/by-id/usb-1a86_USB_Dual_Serial_563E115774-if00 \
	-v /run/user/1000/pipewire-0:/tmp/pipewire-0 \
	-e XDG_RUNTIME_DIR=/tmp \
	-v wine32-prefix:/root/.config/wine32 \
	-v ${PWD}/pat-config.json:/root/.config/pat/config.json \
	-e RIGCTLD_ARGS="-m 3087 -r /dev/ttyACM0 -s 19200" \
	-p 5900:5900/tcp \
	-p 8081:8080/tcp \
	-p 9001:9001/tcp
endef
build:
	docker build -t gzahl/pat-rigctld-varahf-docker .
run-local:
	$(RUN_CMD) gzahl/pat-rigctld-varahf-docker
run:
	$(RUN_CMD) docker.io/gzahl/pat-rigctld-varahf-docker
push:
	podman push gzahl/pat-rigctld-varahf-docker
pull:
	docker pull docker.io/gzahl/pat-rigctld-varahf-docker
