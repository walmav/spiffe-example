#======================
#----------------------
NAME = spiffe/example/verification/database

VERSION = 0.1.0



.PHONE: all buid


build:
	@echo "===================="
	@echo "Create Docker Image: $(NAME)"
	@echo "--------------------"
	docker build -t $(NAME):$(VERSION) --rm .


run:
	@echo "===================="
	@echo "Run."
	@echo "--------------------"
	docker run -it $(NAME):$(VERSION) /bin/bash
