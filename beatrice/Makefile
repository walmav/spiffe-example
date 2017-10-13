
build: up
	cd ../database && VM_EXTRA_MOUNT=../beatrice vagrant halt
	cd ../k8s && VM_EXTRA_MOUNT=../beatrice vagrant halt

up:
	cd ../database && VM_EXTRA_MOUNT=../beatrice vagrant up
	cd ../k8s && VM_EXTRA_MOUNT=../beatrice vagrant up

halt:
	cd ../database && VM_EXTRA_MOUNT=../beatrice vagrant halt
	cd ../k8s && VM_EXTRA_MOUNT=../beatrice vagrant halt

reprovision:
	cd ../database && VM_EXTRA_MOUNT=../beatrice vagrant up --provision
	cd ../k8s && VM_EXTRA_MOUNT=../beatrice vagrant up --provision

destroy:
	cd ../database && VM_EXTRA_MOUNT=../beatrice vagrant destroy -f
	cd ../k8s && VM_EXTRA_MOUNT=../beatrice vagrant destroy -f

harness: build
	cd harness && make screen
	cd harness && make kill

.PHONY: build up halt reprovision destroy harness
