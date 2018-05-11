install: playbook
	@echo "$@ finished"

yadr:
	@echo "Building $@"
	./scripts/yadr.sh
	@echo "$@ finished!"

playbook: yadr
	@echo "Building $@"
	./scripts/playbook.sh
	@echo "$@ finished!"
