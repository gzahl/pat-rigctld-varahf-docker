build:
	podman build -f Dockerfile -t lordzahl/pat-rigctld-varahf-docker
run:
	podman run -it -v wine:/root/.wine -p 5900:5900/tcp lordzahl/pat-rigctld-varahf-docker
