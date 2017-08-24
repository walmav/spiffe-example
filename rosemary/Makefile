build:
# TODO: Remove once Control Plane and Node Agent are public
	rm -rf harness/.repos/ .artifact/ || true
	git clone git@github.com:spiffe/sri.git harness/.repos/sri
	mkdir .artifact
# Build containers
	docker-compose build
	docker-compose up -d

demo:
	docker-compose exec harness cp /root/go/src/github.com/spiffe/sri/artifact.tgz /home/rosemary/.artifact/
	docker-compose exec control_plane tar -xvzf /home/rosemary/.artifact/artifact.tgz -C /
	docker-compose exec blog tar -xvzf /home/rosemary/.artifact/artifact.tgz -C /
	docker-compose exec database tar -xvzf /home/rosemary/.artifact/artifact.tgz -C /
	docker-compose exec harness tmuxinator rosemary

clean:
	docker-compose down
