install: playbook
	@echo "$@ finished"

yadr:
	@echo "Building $@"
	bash ./scripts/yadr.sh
	@echo "$@ finished!"

playbook: yadr
	@echo "Building $@"
	bash ./scripts/playbook.sh
	@echo "$@ finished!"
