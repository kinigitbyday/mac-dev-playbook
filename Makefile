install: playbook
	@echo "$@ finished"

yadr:
	@echo "Building $@"
	bash ./yadr.sh
	@echo "$@ finished!"

playbook: yadr
	@echo "Building $@"
	bash ./playbook.sh
	@echo "$@ finished!"
