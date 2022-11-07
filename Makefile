EXPORT_DIR = export
TEMP_DIR = temp
ZIP = zip
HW_SUFFIX = b4m36san

$(EXPORT_DIR):
	mkdir -p $(EXPORT_DIR)

.PHONY: cv01-voluntary-elections-hw
cv01-voluntary-elections-hw: $(EXPORT_DIR)
	cd src/cv01 && $(ZIP) ../../$(EXPORT_DIR)/$@-$(HW_SUFFIX)-brute.zip \
		elections.R \
		cz_lower_house_elections_2006.png \
		elections_attendence.pdf \
		elections/GlobalElections_Czech\ elections.csv \
		elections/labels.csv

.PHONY: hw01
hw01: $(EXPORT_DIR)
	$(ZIP) -j $(EXPORT_DIR)/$@-$(HW_SUFFIX)-brute.zip \
		src/hw01/SAN_assignment_regression.Rmd \
		src/hw01/SAN_assignment_regression.pdf

.PHONY: hw02
hw02: $(EXPORT_DIR)
	$(ZIP) -j $(EXPORT_DIR)/$@-$(HW_SUFFIX)-brute.zip \
		src/hw02/SAN_assignment_LDA.Rmd \
		src/hw02/SAN_assignment_LDA.pdf

.PHONY: midterm
midterm: $(EXPORT_DIR)
	$(ZIP) -j $(EXPORT_DIR)/$@-$(HW_SUFFIX)-brute.zip \
		src/midterm/SAN_midterm.Rmd \
		src/midterm/SAN_midterm.pdf

.PHONY: clean
clean:
	rm -rf $(EXPORT_DIR) $(TEMP_DIR)
