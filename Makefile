build:
	podman build -f Dockerfile -t gzahl/pat-rigctld-varahf-docker
run:
	mkdir -p config
	podman run -it --rm \
	--mount type=bind,source=config/,target=/root/.config \
	-e RIGCTLD_ARGS="-m 3087 -r /dev/serial/by-id/usb-1a86_USB_Dual_Serial_563E115774-if02 -s 19200" \
	-p 5900:5900/tcp \
	-p 8081:8080/tcp \
	-p 9001:9001/tcp \
	gzahl/pat-rigctld-varahf-docker
push:
	podman push gzahl/pat-rigctld-varahf-docker
