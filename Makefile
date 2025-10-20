# Makefile
PY            ?= python
MLRUNS_DIR    ?= mlruns
export MLFLOW_TRACKING_URI ?= file://$(PWD)/$(MLRUNS_DIR)

.PHONY: install format format-check train validate evaluate eval ci cd clean

install:
	$(PY) -m pip install --upgrade pip
	pip install -r requirements.txt

format:
	isort --profile black .
	black .

format-check:
	isort --profile black --check-only .
	black --check .

train:
	mkdir -p $(MLRUNS_DIR)
	$(PY) src/train.py

validate:
	$(PY) src/validate.py

evaluate: validate
eval: evaluate

ci: install format-check train evaluate

cd:
	@echo "Aquí iría el despliegue/promoción de tu modelo"
	@echo "Ej: mlflow models serve -m $(MLRUNS_DIR)/<run>/artifacts/model -p 8000 --no-conda"

clean:
	rm -rf $(MLRUNS_DIR)

# Asi funciono:

# export MLFLOW_TRACKING_URI="file://$PWD/ruta/mlruns"
# mlflow models serve -m "runs:/36ac30daa98b4e289535a94bd41b8d06/model" -p 5001 --env-manager local

# PERO ANTES CORRER LOCAL:

# make install
# make train
# make evaluate
