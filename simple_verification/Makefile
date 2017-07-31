build:
	make -C blog
	make -C database
	docker-compose up -d

run:
	x-terminal-emulator -e docker-compose exec database /nc.sh
	x-terminal-emulator -e docker-compose exec database /ghostunnel_server.sh $(URI)
	x-terminal-emulator -e docker-compose exec blog /ghostunnel_client.sh
	x-terminal-emulator -e docker-compose exec blog /nc.sh

clean:
	docker-compose down