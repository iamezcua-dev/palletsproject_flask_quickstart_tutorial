project_name := $(shell basename $(shell pwd))
virtual_env_name := ${project_name}_env
python_version := 3.11.2

init:
	@pyenv local ${python_version}
	@echo "[$(shell date '+%d-%m-%Y %T %Z')] Python version used: ${shell pyenv local}"
	@pip install -U pip virtualenv
	@echo "[$(shell date '+%d-%m-%Y %T %Z')] Creating ${virtual_env_name} ..."
	@python -m venv ${virtual_env_name}; \
		. ${virtual_env_name}/bin/activate; \
		pip install -U pip pip-tools; \
		pip-compile --no-header --annotation-style=line --resolver=backtracking requirements-dev.in; \
		pip-compile --no-header --annotation-style=line --resolver=backtracking requirements.in; \
		pip-sync requirements-dev.txt requirements.txt
	@echo "[$(shell date '+%d-%m-%Y %T %Z')] Done! Please, activate the environment by executing:\n\tsource ${virtual_env_name}/bin/activate"

compile:
	@pip-compile --no-header --annotation-style=line --resolver=backtracking requirements.in
	@pip-compile --no-header --annotation-style=line --resolver=backtracking requirements-dev.in

sync: compile
	@pip-sync requirements.txt requirements-dev.txt

