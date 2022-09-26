EXPORT_DIR = export
TEMP_DIR = temp
ZIP = zip
HW_SUFFIX = b4m36san

$(EXPORT_DIR):
	mkdir -p $(EXPORT_DIR)

.PHONY: test
cv01-voluntary-elections-hw: $(EXPORT_DIR)
	cd src/cv01 && $(ZIP) ../../$(EXPORT_DIR)/$@-$(HW_SUFFIX)-brute.zip \
		elections.R \
		cz_lower_house_elections_2006.png \
		elections_attendence.pdf \
		elections/GlobalElections_Czech\ elections.csv \
		elections/labels.csv

.PHONY: clean
clean:
	rm -rf $(EXPORT_DIR) $(TEMP_DIR)
