VIRTUAL_ENV    = ./venv

.PHONY: producer consumer clean

producer: $(VIRTUAL_ENV)
	@. $(<)/bin/activate; python producer.py $(KAFKA_SERVER)

consumer: $(VIRTUAL_ENV)
	@. $(<)/bin/activate; python consumer.py $(KAFKA_SERVER)

clean:
	@find . -iname "*.pyc" -exec rm {} \;
	@rm -rf "$(VIRTUAL_ENV)"

$(VIRTUAL_ENV):
	@virtualenv $(@)
	@. $(@)/bin/activate; pip install -Ur requirements.txt
