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
		src/hw02/SAN_assignment_LDA.html \
		src/hw02/SAN_assignment_LDA.pdf

.PHONY: hw03
hw03: $(EXPORT_DIR)
	$(ZIP) -j $(EXPORT_DIR)/$@-$(HW_SUFFIX)-brute.zip \
		src/hw03/SAN_assignment_GLM.Rmd \
		src/hw03/SAN_assignment_GLM.html \
		src/hw03/SAN_assignment_GLM.pdf

.PHONY: hw04
hw04: $(EXPORT_DIR)
	$(ZIP) -j $(EXPORT_DIR)/$@-$(HW_SUFFIX)-brute.zip \
		src/hw04/SAN_assignment_dim_red.Rmd \
		src/hw04/SAN_assignment_dim_red.html \
		src/hw04/SAN_assignment_dim_red.pdf

.PHONY: hw05
hw05: $(EXPORT_DIR)
	$(ZIP) -j $(EXPORT_DIR)/$@-$(HW_SUFFIX)-brute.zip \
		src/hw05/parzen.R \
		src/hw05/mog.R \
		src/hw05/main.R \
		src/hw05/README.md

.PHONY: midterm
midterm: $(EXPORT_DIR)
	$(ZIP) -j $(EXPORT_DIR)/$@-$(HW_SUFFIX)-brute.zip \
		src/midterm/midterm.R

.PHONY: clean
clean:
	rm -rf $(EXPORT_DIR) $(TEMP_DIR)
