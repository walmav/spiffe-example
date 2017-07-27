#======================
#----------------------
NAME = spiffe/example/verification/blog

VERSION = 0.1.0



.PHONE: all buid


build:
	@echo "===================="
	@echo "Create Docker Image"
	@echo "--------------------"
	docker build -t $(NAME):$(VERSION) --rm .


run:
	@echo "===================="
	@echo "Run."
	@echo "--------------------"
	docker run -v  -it $(NAME):$(VERSION) /bin/bash
