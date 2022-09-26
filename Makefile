EXPORT_DIR = export
TEMP_DIR = temp
ZIP = zip
HW_SUFFIX = b4m36san

$(EXPORT_DIR):
	mkdir -p $(EXPORT_DIR)

.PHONY: test
cv01-voluntary-elections-hw: $(EXPORT_DIR)
	$(ZIP) -j $(EXPORT_DIR)/$@-$(HW_SUFFIX)-brute.zip \
		src/cv01/elections.R \
		src/cv01/elections/GlobalElections_Czech\ elections.csv \
		src/cv01/elections/labels.csv

.PHONY: clean
clean:
	rm -rf $(EXPORT_DIR) $(TEMP_DIR)
