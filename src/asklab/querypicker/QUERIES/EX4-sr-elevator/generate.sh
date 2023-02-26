#! /bin/sh

BASE=../BASE/

REASONING=../Sophisticated-Reasoning/

# Build files OWL Ontoly Case 1
# Most/Least Trustworthy Component (Case 0)
FILES="$REASONING/Integration/SR-RE-01-truthworthiness/ontology_driven.lp $REASONING/Integration/SR-RE-01-truthworthiness/ontology_init_ele_0.lp $REASONING/Integration/SR-RE-01-truthworthiness/reasoning_2_1_onto.lp output_sr_re_01_01.lp"
OUTPUT=FULL-SR-ER-01-ELE-01-00.txt
cat $FILES > $OUTPUT

# Check unsatisfied concerns (Case 0) 
FILES="$REASONING/Integration/SR-RE-01-truthworthiness/ontology_driven.lp $REASONING/Integration/SR-RE-01-truthworthiness/ontology_init_ele_0.lp $REASONING/Integration/SR-RE-01-truthworthiness/reasoning_2_2_onto.lp output_sr_re_01_02.lp"
OUTPUT=FULL-SR-ER-01-ELE-02-00.txt
cat $FILES > $OUTPUT

# Mitigation Strategy: Random method + List all possible solutions (Case 0)
FILES="$REASONING/Integration/SR-RE-01-truthworthiness/ontology_driven.lp $REASONING/Integration/SR-RE-01-truthworthiness/ontology_init_ele_0.lp $REASONING/Integration/SR-RE-01-truthworthiness/reasoning_2_3_onto.lp output_sr_re_01_03.lp"
OUTPUT=FULL-SR-ER-01-ELE-03-00.txt
cat $FILES > $OUTPUT

FILES="$REASONING/Integration/SR-RE-01-truthworthiness/ontology_driven.lp $REASONING/Integration/SR-RE-01-truthworthiness/ontology_init_ele_0.lp $REASONING/Integration/SR-RE-01-truthworthiness/reasoning_2_4_onto.lp output_sr_re_01_04.lp"
OUTPUT=FULL-SR-ER-01-ELE-04-00.txt
cat $FILES > $OUTPUT